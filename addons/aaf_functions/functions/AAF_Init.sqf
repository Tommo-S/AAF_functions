
private _value = missionnamespace getVariable ["aaf_disable_postinit",false];
if _value exitwith {};

if (isserver) then {
	["Initialize", [true]] call BIS_fnc_dynamicGroups;
	[0] call aaf_fnc_serverFPS;
	
	private _value = missionnamespace getVariable ["aaf_disable_serverAI",false];
	if !_value then {
		[] spawn aaf_fnc_aiskill;
	};
    private _value = missionnamespace getVariable ["aaf_disable_AI_Resupply",false];
	if !_value then {
		[] spawn aaf_fnc_resupply;
	};
	private _value = missionnamespace getVariable ["aaf_disable_GroupCleaner",false];
	if !_value then {
		[] spawn aaf_fnc_grpclean;
	};
};

//Dedi/Headless client exit.
if (not hasInterface) exitwith {};

private _value = missionnamespace getVariable ["aaf_disable_serverAI",false];
if !_value then {
	[] spawn aaf_fnc_aiSkillModule;
};

private _value = missionnamespace getVariable ["aaf_disable_respawnLoadout",false];
if !_value then {
	player setVariable["Saved_Loadout",getUnitLoadout player];
	
	player addEventHandler ["respawn",{
		player setUnitLoadout (player getVariable["Saved_Loadout",[]]);
		{
			private _tempValue = player getVariable [_x,nil];
			if not (isnil "_tempValue") then {
				switch _foreachIndex do {
					case 0 : {player setVariable ["ace_medical_medicClass",_tempValue,true];};
					case 1 : {player setVariable ["ACE_isEngineer",_tempValue,true];};
					case 2 : {player setVariable ["ACE_isEOD",_tempValue,true];};
				};
			};
		} foreach ["aaf_var_respawn_medicLevel","aaf_var_respawn_engineerLevel","aaf_var_respawn_eodLevel"];
	}];
};





//A catch in case the mission maker disabled player's ability to activate dynamically simmed units.
//Things get weird if players get into vehicles they can't wake up.
if not (canTriggerDynamicSimulation player) then {
	player triggerDynamicSimulation true;
};

//Y'know that 'press U to join/rename/create/leave groups' menu? This starts that clientside.
["InitializePlayer", [player,true]] call BIS_fnc_dynamicGroups;


private _value = missionnamespace getVariable ["aaf_disable_CustomModules",false];
if !_value then {
	//Register Ares custom modules for dynamic sim/Curator fix.
	if (not isnil "Ares_fnc_RegisterCustomModule") then {
		["Dynamic Simulation", "Disable on Unit/Vehicle", { [_this select 1] call aaf_fnc_dynSimSingle; }] call Ares_fnc_RegisterCustomModule;
		["Dynamic Simulation", "Enable for all objects", { [] call aaf_fnc_dynSimAll; }] call Ares_fnc_RegisterCustomModule;
		["Dynamic Simulation", "Exclude Unit/Vehicle From Dynamic Sim Enable", { [_this select 1] call aaf_fnc_dynSimExcludeModule; }] call Ares_fnc_RegisterCustomModule;
        ["AAF", "Fix Promoted Zeus", { [_this select 1] remoteExec ["aaf_fnc_zeusCleanOldEHs",(_this select 1),false]; }] call Ares_fnc_RegisterCustomModule;
	};
};
private _value = missionnamespace getVariable ["aaf_disable_AI_DontShootUnco",false];
if !_value then {
	//ACE removed unconscious units going captive, now AI can get hung up shooting unconscious/invincible guys in revive.
	//This is to turn that back on. Using remote exec to be safe because I'm not sure locality of player units when carried by other players.
	["ace_unconscious", {
		params ["_unit", "_status"];
		if (local _unit) then {
			if _status then {
				[{
					if ((_this select 0) getvariable "Ace_isUnconscious") then {_this remoteExec ["setCaptive", _this select 0, false];};
					},
					[_unit, _status],
					1
				] call CBA_fnc_waitAndExecute;
			} else {
				_this remoteExec ["setCaptive", _unit, false];
			};
		};
	}] call CBA_fnc_addEventHandler;
	
	player addEventHandler ["respawn",{
		player setcaptive false; //Just in case player died while captive. Probably shouldn't matter but I'm paranoid.
	}];
};
 

//Set up the custom 'increasing chance to really die each time a player enters revive' system.
//This also disables the revive markers as the two systems are linked at the moment.
private _value = missionnamespace getVariable ["aaf_disable_randomDeath_ReviveMarkers",false];
if !_value then {

	//Check if ACE revive is enabled.
	private _medical = missionNamespace getvariable ["ace_medical_enableRevive",0];
	if (_medical > 0) then {
		["ace_unloadPersonEvent", aaf_fnc_vehicleDeath] call CBA_fnc_addEventHandler;
		["reset"] call aaf_fnc_randomDeath;
		["ace_cardiacArrestEntered", {[_this select 0] call ace_medical_fnc_setdead;}] call CBA_fnc_addEventHandler;


		//Killed EH persists after respawn, no need to reapply it constantly.
		player addEventHandler ["killed",{
			//Checking if death marker exists at time of death.
			//No direct command to check for marker, but can check its color. If it has a colour that matches, it exists, delete it.
			private _markerName = "Revive_marker_"+(name player);
			if ((getMarkerColor _markerName) in ["ColorWhite","ColorGreen","ColorYellow", "ColorOrange","ColorRed","Default"]) then {
				deleteMarker _markerName;
			};
		}];
		
		player addEventHandler ["Respawn",{
			player allowDamage true;
			player setvariable ["ace_medical_inrevivestate",false]; //noticed this has sometimes failed to be reset after death, not just in testing but in missions/lrm.
			player setvariable ["aaf_revive_init",false];
			["reset"] call aaf_fnc_randomDeath;
		}];
	};
};





//ACRE radio respawn - snapshot radios on killed, set them up on respawn.
//This is somewhat exploitable in that if someone got their hands on an extra radio during the mission, they will be given one of the same type on respawn, regardless of initial loadout.
//Did this because there are still enough missions where people either have an extra radio they need to ditch on start, or need to be given a long range, that loadout validating would be a giant pain in the ass.
//With radio volume, the getter function returns volume ^ 3, i.e. if you get the volume of a radio set to 20% volume, the result will be 0.008, which is 0.2 ^3.
//The setter function will correct that.
//Note that this checks if ACRE is loaded before running, so it's safe to have even if we switch back to TFAR.

private _value = missionnamespace getVariable ["aaf_disable_ACRE_RadioRespawnSetter",false];
if !_value then {
	if !(isnil "acre_api_fnc_getBaseRadio") then {
		//On killed radio snapshot.
		player addEventHandler ["killed",{
			private _radioList = [] call acre_api_fnc_getCurrentRadioList;
			private _finalRadioList = [];

			{
				private _thisRadio = [
				([_x] call acre_api_fnc_getBaseRadio),
				([_x, "getVolume"] call acre_sys_data_fnc_dataEvent),
				([_x] call acre_api_fnc_getRadioSpatial),
				([_x] call acre_api_fnc_getRadioChannel)

				];
				_finalRadioList pushback _thisRadio;
			} foreach _radioList;

			missionNamespace setvariable ["aaf_var_acre_respawn",_finalRadioList];
		}];
		
		//On respawn setup.
		player addEventHandler ["respawn",{
			[] spawn {
				//Need to wait a second for the respawn radios to init, otherwise the deleter will miss them.
				sleep 2;
				//remove whatever radios in loadout on respawn.
				private _radioList = [] call acre_api_fnc_getCurrentRadioList;
				{player removeItem _x} foreach _radioList;

				//Get pre-death radio info, give new radios
				_radioList = missionNamespace getvariable ["aaf_var_acre_respawn",[]];
				{
					player additem (_x select 0);
				} foreach _radioList;

				//Wait 2 sec for radios to init, then call setter.
				[{[] call aaf_fnc_acre_radio_respawn;}, [], 2] call CBA_fnc_waitAndExecute;
			};
		}];
	};
};


//When players JIP they won't have access to any non-Adminlogged Zeus modules until they've respawned.
//This checks if there is a module assigned to them and repairs the connection without requiring respawn.

private _value = missionnamespace getVariable ["aaf_disable_JIPZeus",false];
if !_value then {
	if didJIP then {
		[] spawn aaf_fnc_JIPZeusAssign;
	};
};


//Group insignia setter. Matches named groups with CB11B's awesome patches. i.e. group named 1-1 will get the 1-1 arm patch.
private _value = missionnamespace getVariable ["aaf_disable_groupInsignia",false];
if !_value then {
	//There are CBA events that could make this a LOT easier. Read later
	//https://cbateam.github.io/CBA_A3/docs/files/events/fnc_addPlayerEventHandler-sqf.html
	if (player == (leader (group player))) then {
			[] spawn aaf_fnc_SetGroupSig;
	};

	if didJIP then {
		if ((group player) getvariable ["BIS_dg_reg",false]) then {
			[] call aaf_fnc_setPersonalSig;
		} else {
			["RegisterGroup", [(group player),(leader (group player)), [nil,(groupid(group player)),false]]] call BIS_fnc_dynamicGroups;
		};
	};

	//Event handler to replace insignia after Ace arsenal is closed. Not going to do a matching EH for vanilla arsenal as insignia shouldn't be available by default.
	["ace_arsenal_displayClosed", {
		[] call aaf_fnc_setPersonalSig;
	}] call CBA_fnc_addEventHandler;
};




//Notification messages for doctor/medic/EOD/UAV hacker. Not sure why UAV hacker is a thing but someone requested it.
private _value = missionnamespace getVariable ["aaf_disable_skillNotification",false];
if !_value then {
	[] call aaf_fnc_skillNotification;
};

// Headless Client Loadouts Fix
// Partial fix for units losing their loadout when being transferred to or from the Headless Client
// Note that it doesn't consider customized AI loadouts, it will give them default loadout for their class.
// Fix provided by Schwaggot (Schwaggot#6822) on the Arma 3 discord
private _value = missionnamespace getVariable ["aaf_disable_HCTransferFix",false];
if !_value then {
    ["CAManBase", "Local", {
        params ["_entity", "_isLocal"];

        if (_isLocal) then {
            if ((uniform _entity) isEqualTo "") then {
                _entity setUnitLoadout (getUnitLoadout (typeOf _entity));
            };
        };
    }] call CBA_fnc_addClassEventHandler;
};
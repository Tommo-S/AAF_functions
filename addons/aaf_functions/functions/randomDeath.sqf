//Lessons learned about CBA event handler. One, fuck ace team, their example is wrong.
//Two, do not add the event hander in initplayerlocal, it doesn't seem to ever update the event handler value.


params [["_control",""],["_InRevive",false]];
private ["_control", "_InRevive","_maxRevives","_minRevives","_ChanceofDeath","_timesRevived","_index","_aaf_revive_init"];

_minRevives = missionnamespace getvariable ["aaf_revive_MinimumRevives",1]; //Variables defined in init.sqf
_maxRevives = missionnamespace getvariable ["aaf_revive_MaximumRevives",5];
_ChanceOfDeath = missionnamespace getvariable ["aaf_revive_ChanceofDeath",[33,50,75,90]];

diag_log "AAF log Random Death";
diag_log format ["_control: %1",_control];
diag_log format ["_InRevive: %1",_InRevive];

//////////////// Check to see if the system has been started /////////
_aaf_revive_init = player getvariable ["aaf_revive_init",false];
if (!_aaf_revive_init) then {

	player setvariable ["aaf_revive_init",true];

	[{
    params ["_args", "_id"];
    _args params ["_unit"];


    if (_unit getvariable ["ace_medical_inrevivestate",false]) exitwith {
        
		[_id] call CBA_fnc_removePerFrameHandler;
		["update",true] call aaf_fnc_randomDeath;
    };
	},0.2,[player]] call CBA_fnc_addPerFrameHandler;
};


/////////////// Various controls to reset, add or subtract - for init/zeus commands.

if (_control == "reset") exitWith {
	player setvariable ["aaf_revive_TimesRevived",0];
};

if (_control == "add") exitWith {
	_timesRevived = (player getvariable ["aaf_revive_TimesRevived",0]) + 1;
	if (_timesRevived < 0) then {_timesRevived = 0};
	player setvariable ["aaf_revive_TimesRevived",_timesRevived];
	};

if (_control == "sub") exitWith {
	_timesRevived = (player getvariable ["aaf_revive_TimesRevived",0]) - 1;
	if (_timesRevived < 0) then {_timesRevived = 0};
	player setvariable ["aaf_revive_TimesRevived",_timesRevived];
	};

	
////////////////////////// Part one - gets called when player is in revive.

if ((_control == "update") && (_InRevive)) exitWith {
	[{player allowDamage false;}, [], 0.4] call CBA_fnc_waitAndExecute;
	_timesRevived = player getvariable ["aaf_revive_TimesRevived",0];

	
	if (_timesRevived >= _maxRevives) exitWith {
		[player, true, false] call ace_medical_fnc_setDead;
	};
	
	

	
	if (_timesRevived >= _minRevives) then {
		_index = _timesRevived - _minRevives;
		if (_index >= (count _ChanceOfDeath)) then {_index = ((count _ChanceOfDeath) -1);};
		_chance = _ChanceOfDeath select _index;
		_randomNum = floor random 100;
	
		if (_randomNum <= _chance) then {
		[player, true, false] call ace_medical_fnc_setDead;
		};
	};
	
	
	[{
    params ["_args", "_id"];
    _args params ["_unit"];


    if (not(_unit getvariable ["ace_medical_inrevivestate",true])) exitwith {
        
		[_id] call CBA_fnc_removePerFrameHandler;
		["update",false] call aaf_fnc_randomDeath;
    };
	},0.2,[player]] call CBA_fnc_addPerFrameHandler;
	
	
	private _markerName = "Revive_marker_"+(name player);	
	[(name player),_markerName,player] call aaf_fnc_reviveMarkers;
	//The function will create the marker, then remoteexec to everyone else to do their part.
	//If script hasn't already exited, you can assume the player wasn't killed and can call event handler 2.
};
	
	
////////////////////////// Part two - gets called when player was in but is now not in revive.


if ((_control == "update") && (not (_InRevive))) exitWith {
	[{player allowDamage true;}, [], 0.5] call CBA_fnc_waitAndExecute;
	_timesRevived = player getvariable ["aaf_revive_TimesRevived",0];
	_timesRevived = _timesRevived + 1;
	player setvariable ["aaf_revive_TimesRevived",_timesRevived];
	
	//call the event handler
	[{
    params ["_args", "_id"];
    _args params ["_unit"];


    if (_unit getvariable ["ace_medical_inrevivestate",false]) exitwith {
        
		[_id] call CBA_fnc_removePerFrameHandler;
		["update",true] call aaf_fnc_randomDeath;
    };
	},0.2,[player]] call CBA_fnc_addPerFrameHandler;
	
	//Checking if marker exists. No direct command, but if its color is an empty string it doesn't exist.
	//Need to also raise an event to tell everyone else to delete their revive markers.
	//Actually. If the draw3d event handler has something that checks for the existence of the marker, and if it doesn't exist end EH, that'd avoid that.
	//Ehh could or could not.
	private _markerName = "Revive_marker_"+(name player); 
	if ((getMarkerColor _markerName) in ["ColorWhite","ColorGreen","ColorYellow", "ColorOrange","ColorRed","Default"]) then { 
		deleteMarker _markerName; 
	};
	//Getting rid of serverside handledisconnect EHID. The server set it and remoteexec'd the ID to only the player's unit/computer.
	private _EHID = player getvariable ["aaf_revive_marker_EHID",nil];
	if !(isnil "_EHID") then {
		["HandleDisconnect",_EHID] remoteExec ["removeMissionEventHandler", 2, false];
		player setvariable ["aaf_revive_marker_EHID",nil];
	};
	//Removing revive marker from JIP queue.
	remoteExec ["", _markername]; 
};










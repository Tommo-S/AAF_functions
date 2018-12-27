//Tommo - this is from P:\a3\modules_f_curator\multiplayer\functions\fn_modulecountdown.sqf, it's to replace the end scenario module in Zeus, so we can log who fires after mission is ended by the countdown module.
//Will not catch when mission is ended via trigger or other scripts.
//Note - also need to add an exception that checks if AAF postinit stuff is disabled.


_logic = _this select 0;
_units = _this select 1;
_activated = _this select 2;

if (_activated) then {
	if (_logic call bis_fnc_isCuratorEditable) then {
		waituntil {!isnil {_logic getvariable "updated"} || isnull _logic};
	};
	if (isnull _logic) exitwith {};
    
	//--- End the mission after countdown reaches 0
	if (isnil "bis_fnc_moduleCountdown_end") then {
		bis_fnc_moduleCountdown_end = [typeof _logic] spawn {
			scriptname "bis_fnc_moduleCountdown: Loop";
			_logicType = _this select 0;
			waituntil {
				sleep 1;
				([] call bis_fnc_missionTimeLeft) == 0
			};
                //Tommo - Insert call for logger. Will send the call to all computers, then exit out for HC/Server.
                [] remoteExecCall ["aaf_fnc_endShootingLogger",0,false];
			_debriefing = missionnamespace getvariable [_logicType + "RscAttributeEndMission_debriefing",""];
			RscDisplayDebriefing_params = _debriefing;
			publicvariable "RscDisplayDebriefing_params";
			_type = missionnamespace getvariable [_logicType + "RscAttributeEndMission_type",""];
			_type call bis_fnc_endMissionServer;
		};
	};
	if (_logic call bis_fnc_isCuratorEditable) exitwith {};

	_valueCode = _logic getvariable ["value",""];
	if (_valueCode != "") then {

		_time = [] call bis_fnc_countdown;
		if (_time <= 0) then {_time = estimatedendservertime - servertime;};
		_value = _time call compile _valueCode;
		_value = _value param [0,-1,[0]];
		if (_value >= 0) then {

			//--- Show notification
			if (abs (([] call bis_fnc_missionTimeLeft) - _value) > 60) then {
				_valueText = format ["%1 %2",ceil (_value / 60),localize "STR_A3_RSCMPPROGRESS_min"];
				[["Countdown",[_valueText]],"bis_fnc_showNotification"] call bis_fnc_mp;
			};

			if (ismultiplayer) then {
				estimatedtimeleft _value;
			} else {
				_value call bis_fnc_countdown;
			};
		};
	} else {
		if (ismultiplayer) then {
			estimatedtimeleft 1e10;
		} else {
			-1 call bis_fnc_countdown;
		};
		if !(isnil "bis_fnc_moduleCountdown_end") then {
			terminate bis_fnc_moduleCountdown_end;
			bis_fnc_moduleCountdown_end = nil
		};
	};
};
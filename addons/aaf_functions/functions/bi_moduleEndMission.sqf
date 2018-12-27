//Tommo - this is from P:\a3\modules_f_curator\intel\functions\fn_moduleendmissions.sqf, it's to replace the end scenario end module in Zeus, so we can log who fires after mission complete, when mission complete is done via Zeus.
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

	//--- Use custom type
	_typeCustom = _logic getvariable ["TypeCustom",""];
	_win = _logic getvariable ["Win",true];
	if ({isclass (_x >> "CfgDebriefing" >> _typeCustom)} count [configfile,campaignconfigfile,missionconfigfile] > 0) exitwith {
		[[_typeCustom,_win],"bis_fnc_endMission"] call bis_fnc_mp;
	};

	_debriefing = missionnamespace getvariable [typeof _logic + "RscAttributeEndMission_debriefing",""];
	RscDisplayDebriefing_params = _debriefing;
	publicvariable "RscDisplayDebriefing_params";

    //Tommo - Insert call for logger. Will send the call to all computers, then exit out for HC/Server.
    [] remoteExecCall ["aaf_fnc_endShootingLogger",0,false];
    
	_type = _logic getvariable ["Type",""];
	_type call bis_fnc_endMissionServer;

	RscDisplayDebriefing_params = _debriefing;
	publicvariable "RscDisplayDebriefing_params";

	if (count objectcurators _logic > 0) then {deletevehicle _logic};
};
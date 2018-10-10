//Note for when I inevitably forget in 3 months. Setting/unsetting dynamic sim is handled serverside. Triggering dynamic sim is not. Putting dynamic sim on a vehicle itself doesn't do much, just worry about the AI crew.
if !(hasInterface) exitwith {};

private _value = missionnamespace getVariable ["aaf_disable_curatorEH",false];
if _value exitWith {};

private _curator = param [0,objNull];
//waitUntil {time >= 15}; //Change init of zeus module in config.cpp to use CBAs wait and execute.
private _unit = getAssignedCuratorUnit _curator;
if (_unit == player) then {
	systemChat "Zeus event handlers added.";
	[format['AAF Log: Zeus registered. Zeus Module: %1. Owner: %2',(vehicleVarName _curator), (name _unit)]] remoteExec ["diag_log", 2, false];
	_curator addEventHandler["CuratorObjectPlaced",{[(_this select 1)] call aaf_fnc_curatorObjectEH;}];

	//Checking existence of server FPS marker, if it's there unhiding it. It should always be there but whatever, caution is good sometimes.
	//if ((getMarkerColor "AAF_Server_FPS") == "ColorBlue") then {"AAF_Server_FPS" setMarkerAlphaLocal 1;};
	//Changed so that anyone can see server FPS from now on.
};
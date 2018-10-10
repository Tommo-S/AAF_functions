/*
Intention:
To go through a list of groups and objects provided by the Zeus' client and enable or disable dynamic simulation on them.
Trying it this way to reduce the amount of work the server does.
As it turns out it's not much work at all to have the server assemble the list but only the server can enable/disable dynamic sim.

Usage:
Must be remoteExec'd from client or run on server directly.
[[unit1,unit2],true] call aaf_fnc_dynSimServer;
[[unit1,unit2],true] remoteExec ["aaf_fnc_dynSimServer", 2, false];

Arguments:
0: List of groups/units to act on (Array)
1: Enable/Disable (Boolean)

*/

params ["_list","_bool"];

if _bool then {
	{
		if !(_x getvariable ["NeverDynamicSim",false]) then {
			_x enableDynamicSimulation _bool;
		};
	} forEach _list;
} else {
	{
		_x enableDynamicSimulation _bool;
	} forEach _list;
};


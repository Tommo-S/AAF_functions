/*
Intention:
To set an exemption on a unit/vehicle so that it will not be included in further dynamic simulate EVERYTHING modules.

Usage:
Zeus Module via Ares custom modules.

Arguments:
0: Target (object or vehicle in mission)

*/

private _target = param [0,objNull]; //Ares module passes the target of the module.
private _list = []; //Declares _list as an empty array.


if (isnull _target) exitWith {["Module must be placed on a unit!"] call Ares_fnc_ShowZeusMessage;}; //Check to make sure the module was dropped on a target.
if !(_target isKindof "AllVehicles") exitWith {["Target must be a man or a vehicle."] call Ares_fnc_ShowZeusMessage;}; //Check to make sure the target is an appropriate type. Men are included in Allvehicles.

if (_target isKindof "Man") then {_list pushback (group _target);} //Checks if the target is a soldier. Adds their group to _list.
    else  //If not a soldier, it must be a vehicle.
	{
	_list pushback _target;//Adds the vehicle module was dropped on to _list.
	_fullcrew = fullCrew [_target, "", false]; //Gets everyone inside the vehicle. This is returned as a multidimensional array of [[unitname1,position,othershitetc],[unitname2,pos...],[etc]] so it can be refined further.
	_crew =[];
	{_crew pushback (_x select 0);} forEach _fullcrew; //Refines the full crew array down to an array of just the crew members.
	    {
		if !((group _x) in _list) then {_list pushback (group _x);} //Checks if the group of the unit being considered is NOT already in the list to act on. If not, adds to _list.
        } forEach _crew; //Runs the above line for all crew members.
	};

["Targets now excluded from Dynamic Simulation"] call Ares_fnc_ShowZeusMessage; //Displays a "good job kid" message for Zeus.

[_list,false] remoteExec ["aaf_fnc_dynSimServer", 2, false]; //Disables dynamic sim on the units if set already.

{
 _x setvariable ["NeverDynamicSim",true,true];
} foreach _list;
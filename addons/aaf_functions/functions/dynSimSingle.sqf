/*
Intention: To be called from a Zeus module on the server todisable dynamic simumlation on a unit or group.
Requirements: Ares or Achilles must be enabled. This is to be called from an Ares custom zeus module.

Usage:
Add the following line to initplayerlocal.sqf 
["Dynamic Simulation", "Disable on Unit", { [_this select 1] spawn fnc_dynSimSingle; }] call Ares_fnc_RegisterCustomModule;

While in Zeus, go to modules, then the Dynamic Simulation tab, select Disable on Unit module, place module on a vehicle or soldier. 

Note: Dynamic sim for men needs to act on their group, not the man itself.
*/

private _unit = param [0,objNull]; //Ares module passes the target of the module.
private _list = []; //Declares _list as an empty array.


if (isnull _unit) exitWith {["Module must be placed on a unit!"] call Ares_fnc_ShowZeusMessage;}; //Check to make sure the module was dropped on a target.
if !(_unit isKindof "AllVehicles") exitWith {["Target must be a man or a vehicle."] call Ares_fnc_ShowZeusMessage;}; //Check to make sure the target is an appropriate type. Men are included in Allvehicles.

if (_unit isKindof "Man") then {_list pushback (group _unit);} //Checks if the target is a soldier. Adds their group to _list.
    else  //If not a soldier, it must be a vehicle.
	{
	_list pushback _unit;//Adds the vehicle module was dropped on to _list.
	private _fullcrew = fullCrew [_unit, "", false]; //Gets everyone inside the vehicle. This is returned as a multidimensional array of [[unitname1,position,othershitetc],[unitname2,pos...],[etc]] so it can be refined further.
	private _crew =[];
	{_crew pushback (_x select 0);} forEach _fullcrew; //Refines the full crew array down to an array of just the crew members.
	    {
		if !((group _x) in _list) then {_list pushback (group _x);} //Checks if the group of the unit being considered is NOT already in the list to act on. If not, adds to _list.
        } forEach _crew; //Runs the above line for all crew members.
	};

["Dynamic simulation is now off for the target."] call Ares_fnc_ShowZeusMessage; //Displays a "good job kid" message for Zeus.

[_list,false] remoteExec ["aaf_fnc_dynSimServer", 2, false]; //Sends list + instruction to server.
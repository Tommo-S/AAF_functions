/*
Intention:
To set an exemption from enabling dynamic sim on a units group, vehicle, crew of a vehicle. It's mostly to stop it from being enabled by the Enable Dyn Sim on Everything (trademark pending) module.
Mostly needed because our coders can't be trusted with setvariable etc etc.

Usage:
[this] call aaf_fnc_dynSimExclude;
Place in init field of a group, unit, or vehicle.
Only to be run on server at init, all clients/headless should exit.

Arguments:
0: Target (group, object or vehicle)

*/

if !(isserver) exitwith {};

private _target = param [0];
private _list = [];

if (isnil "_target") exitwith {
["No target."] call BIS_fnc_error;
};

if ((typename _target) == "GROUP") then {
	_list pushback _target;
	[(leader _target)] call aaf_fnc_dynSimExclude;
};


if ((typename _target) == "OBJECT") then {
	if (_target isKindof "Man") then {_list pushback (group _target)};

	if ((_target isKindOf "AllVehicles") && (!(_target isKindof "Man"))) then {
		_list pushback _target;
		private _fullcrew = fullCrew [_target, "", false];
		private _crew =[];
		{_crew pushback (_x select 0);} forEach _fullcrew; 
			{
				if !((group _x) in _list) then {_list pushback (group _x);}
			} forEach _crew;
		};

};

[_list,false] call aaf_fnc_dynSimServer;

{
	_x setvariable ["NeverDynamicSim",true,true];
} foreach _list;
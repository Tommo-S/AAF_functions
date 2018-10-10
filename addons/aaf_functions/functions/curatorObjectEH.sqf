//Note for when I inevitably forget in 3 months. Setting/unsetting dynamic sim is handled serverside. Triggering dynamic sim is not. Putting dynamic sim on a vehicle itself doesn't do much, just worry about the AI crew.


private _target = param [0,objNull];
private _DynSimList = [];

if (isnull _target) exitwith {}; 
if (_target isKindof "Logic") exitWith {};
if (_target isKindOf "UAV") exitWith {};
if (_target isKindOf "AIR") exitWith {};
//Exceptions so that modules, UAVs and aircraft placed by Zeus are not dynamic simmed automatically.

if (_target isKindOf "Man") then {
	if !(dynamicSimulationEnabled (group _target)) then {
		_DynSimList pushBackUnique (group _target);
	};
	if ((side _target) == civilian) then {
		_target triggerDynamicSimulation false;
	};
	
} else {
private _crew = crew _target;
	if ((count _crew) > 0) then {
		private _group = group (_crew select 0);
	
		if !(dynamicSimulationEnabled _group) then {
			_DynSimList pushBackUnique _group;
		};
		
		{
			if ((side _x) == civilian) then {
				_x triggerDynamicSimulation false;
			};
		} forEach _crew;
	};
	_DynSimList pushBackUnique _target;
};




if ((count _DynSimList) > 0) then {
	[_DynSimList,true] remoteExec ["aaf_fnc_dynSimServer", 2, false];
};
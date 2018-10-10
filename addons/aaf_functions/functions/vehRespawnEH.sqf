//Need to make an event handler to run on vehicles to respawn them after death, in the same position they were in, and clean up their old body, after 15 seconds. respawn module is kinda shit because it will spawn the unit on the module pos, so if it has to do two at a time they all pile in together which is garbage.

//Added second param _thermal. if true when the vehicle respawns it will be hot thermally, good for practising locks with thermals.

//Make sure to disable cook off + ammo cook off on new spawn
//aaf_fnc_vehRespawnEH
//Non server exit. Might break it if we start using HCs again.
if !isserver exitWith {};

params [["_target", objnull, [objNull]],["_thermal",false,[true]]];

if (isnull _target) exitWith {
	["aaf_fnc_vehRespawnEH: No target. Exiting",_target] call BIS_fnc_error;
};

private _pos = getposATL _target;
private _vectorDir = vectorDir _target;
private _vectorUp = vectorUp _target;
private _typeof = typeof _target;

if _thermal then {
	_target setVehicleTIPars [1,0,0];
};

_target = _target call BIS_fnc_netId;

call compile format ["
	private _target = '%1' call BIS_fnc_objectFromNetId;
	_target addEventHandler ['killed', {
	private _type = '%2';
	private _pos = %3;
	private _vectorDirAndUp = %4;
	private _thermal = %5;
	private _unit = _this select 0;
	[{deleteVehicle (_this select 0);}, [_unit], 10] call CBA_fnc_waitAndExecute;
	[{_this call aaf_fnc_vehRespawnCMD;}, [_type,_pos,_vectorDirAndUp,_thermal], 15] call CBA_fnc_waitAndExecute;	
	}];
",_target,_typeof,_pos,[_vectorDir,_vectorUp],_thermal];
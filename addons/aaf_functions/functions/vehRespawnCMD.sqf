//aaf_fnc_vehRespawn
//This is called 15 seconds after vehicle was killed by event handler. The original vehicle was deleted five seconds before this runs.

//Non server exit. Might break it if we start using HCs again.
if !isserver exitWith {};

params ["_type","_pos","_vectorDirAndUp","_thermal"];

private _newVehicle = createVehicle [_type, _pos, [], 0, "CAN_COLLIDE"];
_newVehicle setVectorDirAndUp _vectorDirAndUp;
_newVehicle setvariable ["ace_cookoff_enable",false,true];
_newVehicle setvariable ["ace_cookoff_enableammocookoff",false,true];

[_newVehicle,_thermal] call aaf_fnc_vehRespawnEH;

params ["_unit", "_vehicle", ["_unloader", objNull]];

if ((damage _vehicle) >= 1) then {
	if !(_vehicle iskindof "StaticWeapon") then {
    [_unit, true, false] call ace_medical_fnc_setDead;
	};
};

//Todo
//Expand, instead of just killing them, add some wounds first. And then kill them.
//ace_medical_fnc_addDamageToUnit
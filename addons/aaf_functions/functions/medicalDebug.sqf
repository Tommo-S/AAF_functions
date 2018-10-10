if (isnil "AAF_meddebugVars") then {
AAF_meddebugVars = [
"ACE_isDead",
"ace_medical_inReviveState",
"ace_medical_reviveStartTime",
"ace_medical_inCardiacArrest",
"Ace_isUnconscious",
"ace_medical_addedToUnitLoop",
"ace_medical_bloodVolume",
"ace_medical_heartRate",
"ace_medical_bloodPressure",
"ace_medical_pain",
"ace_medical_openWounds"
];
};


diag_log "AAF log Medical start";
diag_log format ["CBA_missiontime: %1",CBA_missiontime];
{
	diag_log format ["%1: %2",_x,player getvariable _x];
} foreach AAF_meddebugVars;
diag_log "AAF log Medical done";


[{[] call aaf_fnc_medicalDebug;}, [], 30] call CBA_fnc_waitAndExecute;

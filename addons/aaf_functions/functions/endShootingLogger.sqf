/* ----------------------------------------------------------------------------
Function: aaf_fnc_endShootingLogger

Description:
    Starts logging of players firing their weapon, throwing grenades, shooting vehicle weapons etc at end of scenario.
    Might not be perfect, say if player is engaging AI as mission ends, but should be able to establish patterns from players or log when they're shooting teammates.

Parameters:
    Nil

Returns:
    Nil

Examples:
    [] call aaf_fnc_endShootingLogger;
    [] remoteExecCall ["aaf_fnc_endShootingLogger",0,false];

Author: 
    Tommo
---------------------------------------------------------------------------- */


//Server & HC exit
if !hasInterface exitWith {};

player addEventHandler ["Dammaged", {
    params ["_unit", "_selection", "_damage", "_hitIndex", "_hitPoint", "_shooter", "_projectile"];
        if isPlayer _shooter then {
            private _message = format ["[AAF] End Mission Logger: %1 was shot by %2",(name _unit),(name _shooter)];
            [_message] remoteExec ["diag_log",2,false];
            diag_log _message;
        };
}];
    
["ace_firedPlayer",{
    params ["_unit", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
    _weapon = getText (configFile >> "CfgWeapons" >> _weapon >> "DisplayName");
    private _message = format ["[AAF] End Mission Logger: %1 shot their %2. Mode: %3. Ammo: %4",(name _unit),_weapon,_mode,_ammo];
    [_message] remoteExec ["diag_log",2,false];
    diag_log _message;
}] call CBA_fnc_addEventHandler;

["ace_firedPlayerVehicle", {
    params ["_vehicle", "_weapon", "_muzzle", "_mode", "_ammo", "_magazine", "_projectile"];
    _weapon = getText (configFile >> "CfgWeapons" >> _weapon >> "DisplayName");
    private _message = format ["[AAF] End Mission Logger: %1, mounted in a %2, shot their %3. Mode: %4. Ammo: %5",(name player),(typeof _vehicle),_weapon,_mode,_ammo];
    [_message] remoteExec ["diag_log",2,false];
    diag_log _message;
}] call CBA_fnc_addEventHandler;
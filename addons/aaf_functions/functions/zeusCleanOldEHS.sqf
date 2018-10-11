/*
	Fixes doubled event handlers for Zeus promoted by Achilles promote Zeus function, when double-clicking units, groups, objectsm waypoints.
    Fixes by removing ALL event handlers of those types, then adding one of each.
	
    Called by Achilles custom module. If calling manually must provide target player.
    
    [bill] call aaf_fnc_zeusCleanOldEHs;
*/

params [["_target",objnull,[objNull]]];

if (_target == objNull) exitWith {
    ["aaf_fnc_zeusCleanOldEHs exit: no unit provided"] remoteExec ["systemChat",remoteExecutedOwner,false];
};

if not (isplayer _target) exitWith {
    ["aaf_fnc_zeusCleanOldEHs exit: target unit is not a player"] remoteExec ["systemChat",remoteExecutedOwner,false];
};

if ((getassignedcuratorlogic _target) == objNull) exitWith {
    ["aaf_fnc_zeusCleanOldEHs exit: target has no assigned Zeus module"] remoteExec ["systemChat",remoteExecutedOwner,false];
};

private _logic = (getAssignedCuratorLogic _target);
{
    private _ehCount = _logic addEventHandler [_x, {}];
    for "_i" from 0 to _ehCount do {
        _logic removeEventHandler [_x,_i];
    };
    _logic addEventHandler [_x,{(_this select 1) call bis_fnc_showCuratorAttributes;}];

} foreach ["curatorObjectDoubleClicked","curatorGroupDoubleClicked","curatorWaypointDoubleClicked","curatorMarkerDoubleClicked"];

["aaf_fnc_zeusCleanOldEHs finished successfully"] remoteExec ["systemChat",remoteExecutedOwner,false];
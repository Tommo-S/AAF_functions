//Bit of a dogs breakfast as I made most of this ages ago. Just became aware that the player's insignia is set to X, if you try to set it again to X it will fail. The insignia can disappear when the player changes uniform, in arsenal, etc, and resetting it will fail if the new insignia is the same as the old one.

private _useGroup = (group player) getvariable ["aaf_var_useGroup",true];
private _personalSig = profilenamespace getvariable ["aaf_var_personalSig",""];
private _useRoleSig = profilenamespace getvariable ["aaf_var_useRoleSig",true];
private _roleSig = "";
private _currentInsignia = [player] call BIS_fnc_getUnitInsignia;
private _newInsignia = "";

//_usegroup is an override set by group leader to force group members to use the same sig.
if _useGroup then {_personalSig = ""};
if ([player] call ace_common_fnc_isEngineer) then {_roleSig = "AAF_ENGINEERING"};
if ([player,2] call ace_medical_fnc_isMedic) then {_roleSig = "AAF_MEDICAL"};

if (_personalSig == "") then {
	//No personal sig.
	if (_rolesig != "") then {
		//Has no personal but has a specialist role.
		_newInsignia = _rolesig;
	} else {
		//Has no personal, no specialist, this is a catch in case their specialist role is taken away during the mission.
		private _groupSig = (group player) getvariable "BIS_dg_ins";
		_newInsignia = _groupSig;
	};
} else {
	//Has a personal sig.
	if (_roleSig == "") then {
		//has personal sig & no role sig.
		_newInsignia = _personalSig;
	} else {
	//Has both, work out which to use.
		if _useRoleSig then {
			_newInsignia = _rolesig;
		} else {
			_newInsignia = _personalSig;
		};
	};
};

if (_currentInsignia == _newInsignia) then {
	[player,""] call BIS_fnc_setUnitInsignia;
	[player,_newInsignia] call BIS_fnc_setUnitInsignia;
} else {
	[player,_newInsignia] call BIS_fnc_setUnitInsignia;
};
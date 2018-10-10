//Register a custom Ares module to change AI skills. Only for players.
if (hasInterface) then {
	['AAF', 'Change AI Skill Rank', {
		params ['_position', '_object'];
		private _selectedObjects = if (isNull _object) then	{
			["Objects"] call Achilles_fnc_SelectUnits;
		} else {
			[_object];
		};
		if (isNil "_selectedObjects") exitWith {};
	  
		if (_selectedObjects isEqualTo []) exitWith {
			["No unit or group was selected!"] call Achilles_fnc_showZeusErrorMessage;
		};
	  
		private _dialogResult =
		[
			"Set Group Skill Level",
			[
				["Combo Box Control", ["Conscript","Regular","Special Forces"], 1]
			]
		] call Ares_fnc_showChooseDialog;

		if (_dialogResult isEqualTo []) exitWith{};
		_dialogResult params ["_rank"];
		_rank = _rank + 1;

		private _groups = [];
		{
			private _group = group _x;
			if (_group != grpNull) then {
				_groups pushBackUnique _group;
			};
		} foreach _selectedObjects;

		{
			_x setvariable ["aaf_ai_rank", _rank, 2];
			_x setvariable ["aaf_ai_skills_set", false, 2];
		} foreach _groups;
	}] call Ares_fnc_RegisterCustomModule;
};
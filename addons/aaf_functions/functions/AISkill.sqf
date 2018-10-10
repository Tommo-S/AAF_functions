//Kick everyone out who is not the server. Still local host friendly.
//Should only be run by the server but paranoia.

if (!isserver) exitWith {};

//Build the skill arrays. When they're built, they'll look like aaf_ai_rank_1 = [aaf_ai_aimingshake1,aaf_ai_aimingspeed1...] etc, with the values from CBA options subbing in for the variable names.

//Rank 1 is conscript level, rank 2 is regular, rank 3 is SF.
//Each skill at each rank has its own variable, unfortunately that's what CBA options requires. i.e. aaf_ai_aimingshake1, aaf_ai_aimingshake2, aaf_ai_aimingshake3 for aim shake at conscript/regular/SF

//When any of the CBA options are changed, it flags aaf_rebuildskills = true; to rebuild the skill tree the next time this function runs, which also sets aaf_ai_skills_set to false on all groups, so all groups will be updated when any skill is changed.

//Rank is determined by getting the variable "aaf_ai_rank" set on group. When promoting/demoting groups, set "aaf_ai_rank" on the group to 1-3 and set "aaf_ai_skills_set" to false on the group so that their skills will be set the next time it runs.

//Structured like this to make sure every group is checked, but only those that have been changed or have not had their skills set before (i.e. newly created units) will be updated, unless a full rebuild happens and everyone gets checked/set.

//By default, units will be set to regular skill level.

//If they haven't been built, build the skill trees.
if isnil "aaf_rebuildskills" then {
	aaf_rebuildskills = true;
};

//Whenever ANY skill is changed in CBA settings, all the skill arrays are rebuilt. All groups will be flagged to have skills applied after the rebuild.
if aaf_rebuildskills then {

	aaf_ai_skillcategories = [
		"aaf_ai_aimingaccuracy",
		"aaf_ai_aimingshake",
		"aaf_ai_aimingspeed",
		"aaf_ai_reloadSpeed",
		"aaf_ai_spottime",
		"aaf_ai_spotdistance",
		"aaf_ai_courage",
		"aaf_ai_endurance",
		"aaf_ai_commanding",
		"aaf_ai_endurance"
	];


	{
		private _rank = str _x;
		private _code = "aaf_ai_rank_" + _rank + " = [";
		private _count = count aaf_ai_skillcategories;

		{
			private _text = "missionnamespace getvariable ['" +_x + _rank +"',0.1]";
			
			if (_foreachindex == (_count - 1)) then {
				_text = _text + "];";
				_code = _code + _text;
				[] call compile _code;
			} else {
				_text = _text + ", ";
			};
			_code = _code + _text;
		} foreach aaf_ai_skillcategories;

	} foreach [1,2,3];

	aaf_rebuildskills = false;
	
	{
		_x setvariable ["aaf_ai_skills_set",false];
	} foreach allgroups;
};



{
	if not (_x getvariable ["aaf_ai_skills_set",false]) then {
		private _rank = _x getvariable ["aaf_ai_rank",0];
		if (_rank == 0) then {
			_x setvariable ["aaf_ai_rank",2];
			_rank = 2;
		};
		private _code = "_rank = aaf_ai_rank_" + str _rank;
		[] call compile _code;
		_rank params ["_aimingaccuracy", "_aimingshake", "_aimingspeed", "_reloadSpeed", "_spottime", "_spotdistance", "_courage", "_endurance", "_commanding", "_general"];
		
		{
			_x setSkill ["aimingaccuracy", _aimingaccuracy];
			_x setSkill ["aimingshake", _aimingshake];
			_x setSkill ["aimingspeed", _aimingspeed];
			_x setSkill ["reloadSpeed", _reloadSpeed];
			_x setSkill ["spottime", _spottime];
			_x setSkill ["spotdistance", _spotdistance];
			_x setSkill ["courage", _courage];
			_x setSkill ["endurance", _endurance];
			_x setSkill ["commanding", _commanding];
			_x setSkill ["general", _general];	
		} foreach units _x;
		
		_x setVariable ["aaf_ai_skills_set",true];
	};
} foreach allgroups;

[{[] call aaf_fnc_AISkill;}, [], 30] call CBA_fnc_waitAndExecute;
while {true} do {
	{
		if (({alive _x} count (units _x)) == 0) then {
			deletegroup _x;
		};
	} foreach allgroups;

	sleep 300 + (random 1);
};

//Param
// 0 - The CBA_missiontime + 30 seconds the last low server FPS warning was broadcast. Compared to current time to avoid spamming.)

private _lastWarningTime = param [0,0];

//Checking and reseting last low FPS warning time. Reset it if it has been long enough.
if (_lastWarningTime > 0) then {
	if (CBA_missiontime >= _lastWarningTime) then {
		_lastWarningTime = 0;
	};
};

If isserver then {
	//Checking existence of marker by checking its color. 
	if ((getMarkerColor "AAF_Server_FPS") != "ColorBlue") then {
		private _marker = createMarker ["AAF_Server_FPS", [050,000,0]];
		_marker setMarkerColor "ColorBlue";
		//_marker setMarkerAlpha 0;  //Changing it so anyone can see server FPS because why not.
		_marker setMarkerType "hd_dot";
		_marker setMarkerText ("Server FPS: " + (diag_fps tofixed 1));
		[{[0] call aaf_fnc_serverFPS;}, [], 2] call CBA_fnc_waitAndExecute;
	} else {
		//Updating
		private _fps = diag_fps;
		"AAF_Server_FPS" setMarkerText ("Server FPS: " + (_fps tofixed 1));
		
		if (_fps <= 22) then {
			if (_lastWarningTime == 0) then {
				private _curatorIDList = [];
				{
					private _owner = getAssignedCuratorUnit _x;
					if (!isnull _owner) then {
						_curatorIDList pushback (owner _owner);
					};
				} foreach allCurators;
				
				if ((count _curatorIDList) > 0) then {
					["Server FPS Notice: " + (_fps tofixed 1) +" FPS"] remoteexec ["systemchat",_curatorIDList,false];
				};
				private _time = CBA_missiontime + 30;
				[{[_this select 0] call aaf_fnc_serverFPS;}, [_time], 2] call CBA_fnc_waitAndExecute;
				
			} else {
				[{[_this select 0] call aaf_fnc_serverFPS;}, [_lastWarningTime], 2] call CBA_fnc_waitAndExecute;
			};
		} else {
			[{[_this select 0] call aaf_fnc_serverFPS;}, [_lastWarningTime], 2] call CBA_fnc_waitAndExecute;
		};
	};
};

//Client side showing server FPS marker is handled in curatorAddEH.sqf, as that runs when a curator is init'd, so it'll cover both JIPs and non-JIPs without shenanigans.
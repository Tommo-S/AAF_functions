
params ["_name","_markerName","_target"];
//Setting up event handler to delete marker if player disconnects.
//Also sending the EHID back to the player so if they are revived without disconnecting they can tell the server to remove it.

if (isserver || isdedicated) then {

	private _EHID = addMissionEventHandler ["HandleDisconnect",{
		private _markerName = "Revive_marker_"+(_this select 3); 
		//Deleting the old marker.
		//Don't need to check if marker still exists, as if the player doesn't disconnect they'll remove the marker and this eventhandler.
			deleteMarker _markerName;
			//Removing EH.
			removeMissionEventHandler ["HandleDisconnect",_thisEventHandler];
			//Removing command from JIP queue.
			remoteExec ["", _markername]; 
	}];
	
	//Sending the EHID to the client so they can tell the server to remove it when the player exits Revive.
	[_target, ["aaf_revive_marker_EHID",_EHID]] remoteExec ["setvariable", _target, false];

};

//Dedi & HC exit.
if !(hasInterface) exitWith {};


//Dead guy first creates the marker, then broadcasts it to everyone but themselves, including the server. Starts color & position updating function.
if (local _target) then {
	createMarker [_markerName, position player]; 
	_markerName setMarkerShape "ELLIPSE"; 
	_markerName setMarkerAlpha 0;
	_markerName setmarkersize [5,5];
	_markerName setMarkerColor "ColorWhite";
	_markerName setMarkerText "0";
	[_markername,_target] call aaf_fnc_reviveMarkerUpdater;
	[_name,_markerName,_target] remoteExec ["aaf_fnc_reviveMarkers", -(clientOwner), _markername];
};


//Need to use netID shenanigans here because the player object doesn't survive translation to string and back.
//Using a format command because you can't pass arguments to an event handler in the conventional way. So you need to assemble it as one big code block where the arguments are defined within the block of code and compile it.
//Note icon is rendered using AGL coordinates, but the surface intersection command relies on ASL coordinates.
//Other weirdness. Had to do minor adjustment to pos of the target when checking intersection, as sometimes they will be slightly in ground.
//Also need to make sure the vehicle the player and target are in are ignored for intersection, otherwise you'd only see someone's icon in a truck if you could draw LOS to them.
_target = _target call BIS_fnc_netId;
call compile format ["
	addMissionEventHandler ['Draw3d', {

		private _name = '%1';
		private _markerName = '%2';
		private _target = '%3' call BIS_fnc_objectFromNetId;
		private _pos = _target modelToWorldVisual [0,0,0];
		_pos set [2,((_pos select 2) + 0.75)];
		private _color = getMarkerColor _markerName;
		
		if (_color == '') exitWith {
			removeMissionEventHandler ['Draw3d',_thisEventHandler];
			aaf_revive_animationFrame = nil;
			aaf_revive_diagtickTime = nil;
		};
		
		switch _color do {
			case 'ColorWhite': 	{_color = [1,1,1,1];};
			case 'ColorGreen': 	{_color = [0,1,0,1];};
			case 'ColorYellow': {_color = [0.85,0.85,0,1];};
			case 'ColorOrange': {_color = [0.85,0.4,0,1];};
			case 'ColorRed': 	{_color = [1,0,0,1];};
			default 			{_color = [0.85,0.85,0,1];};
		};
		
		

		
		private _icon = '\aaf_functions\icons\medical\medcross';
		private _bleed = (markerText _markerName);
		
		if !((parseNumber _bleed) == 0) then {
		
			if isnil 'aaf_revive_animationFrame' then {
				aaf_revive_animationFrame = 0;
			};
		
			if isnil 'aaf_revive_diagtickTime' then {
				aaf_revive_diagtickTime = diag_tickTime + 0.25;
			};
		
			switch aaf_revive_animationFrame do {
			case  0 : {
					if (diag_tickTime > aaf_revive_diagtickTime) then {
						aaf_revive_animationFrame = 1;
						aaf_revive_diagtickTime = diag_tickTime + 0.25;
					};
				};
			case  1 : {
					_icon = _icon + _bleed + '_1'; 
					if (diag_tickTime >= aaf_revive_diagtickTime) then {
						aaf_revive_animationFrame = 2;
						aaf_revive_diagtickTime = diag_tickTime + 0.25;
					};
				};
			case  2 : {
					_icon = _icon + _bleed + '_2'; 
					if (diag_tickTime >= aaf_revive_diagtickTime) then {
						aaf_revive_animationFrame = 3;
						aaf_revive_diagtickTime = diag_tickTime + 0.25;
					};
				};
			case  3 : {
					_icon = _icon + _bleed + '_3'; 
					if (diag_tickTime >= aaf_revive_diagtickTime) then {
						aaf_revive_animationFrame = 0;
						aaf_revive_diagtickTime = diag_tickTime + 0.25;
					};
				};
			};	
		};
		

		
		_icon = _icon + '.paa';
		
		
		
		
		private _curatorCam = curatorCamera;
		if (isnull _curatorCam) then {
			if ((getPosWorld player) inarea _markerName) then {
				private _targetPos = visiblePositionASL _target;
				
				_targetPos set [2,(_targetPos select 2) + 0.5];
				private _intersects = lineIntersectsSurfaces [_targetPos,eyepos player, vehicle player, vehicle _target, true, 1, 'View', 'fire', true];
				if ((count _intersects) == 0) then {
					drawIcon3D [_icon, _color, _pos, 1, 1, 0, _name, 1, 0.0315, 'EtelkaMonospacePro'];
				};	
			};
		} else {
			drawIcon3D [_icon, _color, _pos, 1, 1, 0, _name, 1, 0.0315, 'EtelkaMonospacePro'];
		};
		

		}];
	",_name,_markerName,_target];

	
	//Color candidates
	/* dark orange [0.7,0.3,0,1];
	dark red [0.6,0,0,1]
	*/
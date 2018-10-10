
params ["_markerName","_target"];

//Exits
if !(hasInterface) exitWith {};
private _inRevive = _target getvariable ["ace_medical_inReviveState",nil];
if (isnil "_inRevive") exitWith {};

//Checking for deletion of marker.
private _markerColor = getMarkerColor _markerName;
if !(_markerColor in ["ColorWhite","ColorGreen","ColorYellow", "ColorOrange","ColorRed","Default"]) exitWith {};


//Update marker colour
private _reviveStart = _target getvariable ["ace_medical_reviveStartTime",nil];
if (isnil "_reviveStart") exitwith {};
private _maxRevive = missionnamespace getvariable ["ace_medical_maxReviveTime",nil];
if (isnil "_maxRevive") exitwith {};

private _percent = (CBA_missionTime - _reviveStart) / _maxRevive;

//Note - tested performance using Switch do vs nested if statements. Switch do was better except when the If statements took the first exit, and twice as fast when if took the last exit.

switch true do {
	case (_percent <= 0.25) : {
		if (_markerColor != "ColorWhite") then {
			_markerName setMarkerColor "ColorWhite";
		};
	};
	case ((_percent > 0.25) && (_percent <= 0.5)) : {
		if (_markerColor != "ColorYellow") then {
			_markerName setMarkerColor "ColorYellow";
		};
	};
	case ((_percent > 0.5) && (_percent <= 0.75)) : {
		if (_markerColor != "ColorOrange") then {
			_markerName setMarkerColor "ColorOrange";
		};
	};
	case (_percent > 0.75) : {
		if (_markerColor != "ColorRed") then {
			_markerName setMarkerColor "ColorRed";
		};
	};
};


//Update bleeding
private _openwounds = player getvariable ["ace_medical_openwounds",[]];
private _text = markerText _markerName;

	if ((count _openwounds) == 0) then {
		if (_text != "0") then {
			_markerName setMarkerText "0";
		};
	} else {
		private _bleedRate = 0;
		{
			_bleedRate = _bleedRate + ((_x select 3) * (_x select 4));
		} foreach _openwounds;
		
		
		switch true do {
			case (_bleedRate == 0) : {
				if (_text != "0") then {
					_markerName setMarkerText "0";
				};
			};
			case ((_bleedRate > 0) && (_bleedRate <= 0.051)) : {
				if (_text != "1") then {
					_markerName setMarkerText "1";
				};
			};
			case (_bleedRate > 0.051) : {
				if (_text != "2") then {
					_markerName setMarkerText "2";
				};
			};
		};
	};
		

//Update marker POS

	private _targetPOS = getPosWorld _target;
	_targetPOS set [2,0];
	private _markerPOS = getMarkerPos _markerName;
	
	//Need to use full isequalto to compare arrays, can't use != or ==
	if !(_targetPOS isequalto _markerPOS) then {
		_markerName setMarkerPos _targetPOS;
	};
	
[{_this call aaf_fnc_reviveMarkerUpdater;}, [_markerName,_target], 0.5] call CBA_fnc_waitAndExecute;
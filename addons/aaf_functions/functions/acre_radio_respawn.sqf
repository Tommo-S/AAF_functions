/*
	Final part of radio resetter on respawn.
	Works with a killed event handler to get radio settings on death, and an on respawn event handler to prepare new radios, which then calls this.
	
	Note with radio volume, the getter function returns volume ^ 3, i.e. if you use the get volume function on  a radio set to 20% volume, the result will be 0.008, which is 0.2 ^3.
	If you try and use 0.008 volume in the setter function, shit gets fucked fast, your radio is will be on less 1% volume.
	the line _volume = _volume ^ (1/3); is getting the cube root of that returned volume. e.g 0.008 ^ (1/3) = 0.2 (20%).
	Then put that through the setter, works fine.

*/
	//Find out radio IDs of new radios added after respawn.
	private _newRadios = [] call acre_api_fnc_getCurrentRadioList;
	
	//Get old info
	_radioList = missionNamespace getvariable ["aaf_var_acre_respawn",[]];
	
	
	{
		_x params ["_class","_volume","_spatial","_channel"];
		
		private _radio = _newRadios select _foreachIndex;
		
		[_radio,_spatial] call acre_api_fnc_setRadioSpatial;
		[_radio,_channel] call acre_api_fnc_setRadioChannel;
		_volume = _volume ^ (1/3);
		([_radio, "setVolume", _volume] call acre_sys_data_fnc_dataEvent)
		
	} foreach _radioList;
	
	//Wipe old info.
	missionNamespace setvariable ["aaf_var_acre_respawn",nil];
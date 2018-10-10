/*aaf_fnc_gear
*
*parameters [_varname,_action]
* 0: _varname (string): The name for the loadout to be saved/loaded to the profile namespace.
* 1: _action (string): "save" or "load"
*/

params ["_varname","_action"];

if (_action == "save") then {
    _temploadout = getUnitLoadout player;
	profileNamespace setVariable[_varname,_temploadout];
};


if (_action == "load") then {
	if !(isnil "TFAR_fnc_canspeak") then {
		//TFAR
		//The load function checks for if the player was carrying a TFAR radio, and if they were, replaces their specific radio with a generic one. Stops a bug where TFAR gets stuck in a loop trying to replace duplicate radios when you have lots of players loading at the same time.
		_temploadout = profileNamespace getVariable[_varname,[]];
		_index = (count _temploadout) - 1;
		_saveditems = _temploadout select _index;
		_radio = _saveditems select 2;

		if (isNumber (configfile >> "CfgWeapons" >> _radio >> "tf_radio")) then {
			_radio = getText (configfile >> "CfgWeapons" >> _radio >> "tf_parent");
			_saveditems set [2,_radio];
			_temploadout set [_index,_saveditems];
		};

		player setUnitLoadout _temploadout;
	};
	
	if !(isnil "acre_api_fnc_getCurrentRadioList") then {
		//ACRE
		//Gets the old loadout data, stanitizes the radio names from ACRE_prc343_id_1 to a generic radio. Also removes generic "itemradio" items from loadout.
		private _temploadout = profileNamespace getVariable[_varname,[]];
		{
			private _items = _temploadout select _x;
			//Selects data held in either uniform, vest or backpack arrays as _items.
			//Checks to see if the uniform, vest or backpack aren't present, i.e. an empty string.
			//Actually if the item is not present the whole thing is an empty array. Hooray for learning.
			if (count _items > 0) then {
				//Goes through all items held in container. Item data at this time would look like ["itemname",count], or possible ["itemname",ammo,count] if magazine.
				{
					_x params ["_item"];
					//Select item name. Checks if the first four letters are "ACRE", if so it's a typical radio "ACRE_prc343_id_1".
					if ((_item select [0,4]) == "ACRE") then {
						private _string = _item splitstring "_";
						//Splits the radio name by underscores in name. ["ACRE","prc343","id","1"].
						_string = [_string select 0, _string select 1] joinstring "_";
						//Joins the first two elements back together. Becomes a generic radio name. "ACRE_prc343"
						_item = _string;
						_string = nil;
						//Overwriting old data with new data.
						_x set [0,_item];
						
						
					};
				} foreach (_items select 1);
			};
		} foreach [3, 4, 5];
		//Indexes 3, 4, 5 for getunitloadout are uniform, vest, backpack. Data is further structured by ["container type",[["item1",count],["item2",count]]]
		
		//Below code is setting the "itemradio" slot on the loadout data to an empty string.
		private _items = _temploadout select 9;
		_items set [2,""];
		
		player setUnitLoadout _temploadout;

	};
	
	if ((isnil "acre_api_fnc_getCurrentRadioList") && (isnil "TFAR_fnc_canspeak")) then {
		//Just in case neither ACRE or TFAR are enabled.
		private _temploadout = profileNamespace getVariable[_varname,[]];
		player setUnitLoadout _temploadout;
	};
	
};
	//Composes notification message for player unit skills. I.e. medic level, engineer, UAV operator, EOD.
	//Added 10 second delay to get around ACRE connected messages.
	
	private _heading = parseText "<t size='2'>You are set as: </t>";
	private _text = [_heading,linebreak];
	if ([player,1] call ace_medical_fnc_isMedic) then {
		if ([player,2] call ace_medical_fnc_isMedic) then {
				_txt = parseText "<t size='2'>Doctor</t><br />";
				_text pushback _txt;
			} else {
				_txt = parseText "<t size='2'>Medic</t><br />";
				_text pushback _txt;
			};
	};

	if ([player] call ace_common_fnc_isEngineer) then {
		_txt = parseText "<t size='2'>Engineer</t><br />";
		_text pushback _txt;
	};

	if ([player] call ace_common_fnc_isEOD) then {
		_txt = parseText "<t size='2'>EOD</t><br />";
		_text pushback _txt;
	};

	 if ((getNumber (configfile >> "CfgVehicles" >> (typeof player) >> "uavHacker")) > 0) then {
		_txt = parseText "<t size='2'>UAV Hacker</t><br />";
		_text pushback _txt;
	};

	if ((count _text) > 2) then {
		_txt = composeText _text;
		//Adding a delay to hopefully get around the ACRE CONNECTED message that often overwrites it.
		[_txt] spawn {
			sleep 10;
			hintsilent (_this select 0);
			sleep 7;
			hintsilent "";
		};
	};
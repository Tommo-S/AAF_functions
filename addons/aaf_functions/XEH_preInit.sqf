//Post init disablers
[
	"aaf_disable_postinit",
	"CHECKBOX",
	"Completely disable post init",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_serverAI",
	"CHECKBOX",
	"Disable AI skill setter, group cleaner, resupplier",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_respawnLoadout",
	"CHECKBOX",
	"Disable loadout saving for respawn",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_CustomModules",
	"CHECKBOX",
	"Disable custom Ares modules",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_AI_DontShootUnco",
	"CHECKBOX",
	"Disable AI ignore unconscious players",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_randomDeath_ReviveMarkers",
	"CHECKBOX",
	"Disable random death & revive markers",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_JIPZeus",
	"CHECKBOX",
	"Disable repairing JIP Zeus slots",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_groupInsignia",
	"CHECKBOX",
	"Disable arm patches based on group names",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_skillNotification",
	"CHECKBOX",
	"Disable skill notifier (i.e. medic, engineer, EOD etc)",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_curatorEH",
	"CHECKBOX",
	"Disable Zeus init eventhandler",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_disable_HCTransferFix",
	"CHECKBOX",
	"Disable partial fix for naked units due to Headless",
	["AAF Extras","Post Init Disablers"],
	false,
	1,
	{}
] call CBA_Settings_fnc_init;


//Start Random Death settings
[
	"aaf_revive_MinimumRevives",
	"SLIDER",
	"Guaranteed Revives",
	["AAF Extras","Random Death Settings"],
	[0,100,1,0],
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_revive_MaximumRevives",
	"SLIDER",
	"Max Revives",
	["AAF Extras","Random Death Settings"],
	[0,100,5,0],
	1,
	{}
] call CBA_Settings_fnc_init;

[
	"aaf_revive_ChanceofDeath",
	"EDITBOX",
	"Chance at each unguaranteed revive (no spaces)",
	["AAF Extras","Random Death Settings"],
	"33,50,75,90",
	1,
	{
		params ["_values"];
		_value = "[" + _value + "]";
		_value = parseSimpleArray _value;
		missionnamespace setvariable ["aaf_revive_ChanceofDeath",_value];
		
	}
] call CBA_Settings_fnc_init;
//End Random death settings


//Start AI Skills - Regulars.
[
	"aaf_ai_aimingaccuracy2",
	"SLIDER",
	"Accuracy",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,0.15,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_aimingshake2",
	"SLIDER",
	"Aim Shake",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,0.15,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_aimingspeed2",
	"SLIDER",
	"Aiming Speed",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,0.6,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_reloadSpeed2",
	"SLIDER",
	"Reload Speed",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_spottime2",
	"SLIDER",
	"Spot Time",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_spotdistance2",
	"SLIDER",
	"Spot Distance",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_courage2",
	"SLIDER",
	"Courage",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_endurance2",
	"SLIDER",
	"Endurance",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_commanding2",
	"SLIDER",
	"Commanding",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_endurance2",
	"SLIDER",
	"Endurance",
	["AAF AI Settings","AI Skills - Regular"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

//End AI skills - Regular.

//Start AI Skills - SF.
[
	"aaf_ai_aimingaccuracy3",
	"SLIDER",
	"Accuracy",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,0.15,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_aimingshake3",
	"SLIDER",
	"Aim Shake",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,0.15,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_aimingspeed3",
	"SLIDER",
	"Aiming Speed",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,0.6,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_reloadSpeed3",
	"SLIDER",
	"Reload Speed",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_spottime3",
	"SLIDER",
	"Spot Time",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_spotdistance3",
	"SLIDER",
	"Spot Distance",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_courage3",
	"SLIDER",
	"Courage",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_endurance3",
	"SLIDER",
	"Endurance",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_commanding3",
	"SLIDER",
	"Commanding",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_endurance3",
	"SLIDER",
	"Endurance",
	["AAF AI Settings","AI Skills - SF"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

//End AI skills - SF.


//Start AI Skills - Conscripts.
[
	"aaf_ai_aimingaccuracy1",
	"SLIDER",
	"Accuracy",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,0.15,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_aimingshake1",
	"SLIDER",
	"Aim Shake",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,0.15,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_aimingspeed1",
	"SLIDER",
	"Aiming Speed",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,0.6,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_reloadSpeed1",
	"SLIDER",
	"Reload Speed",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_spottime1",
	"SLIDER",
	"Spot Time",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_spotdistance1",
	"SLIDER",
	"Spot Distance",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_courage1",
	"SLIDER",
	"Courage",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,0.7,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_endurance1",
	"SLIDER",
	"Endurance",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_commanding1",
	"SLIDER",
	"Commanding",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

[
	"aaf_ai_endurance1",
	"SLIDER",
	"Endurance",
	["AAF AI Settings","AI Skills - Conscript"],
	[0,1,1,2],
	1,
	{aaf_rebuildskills = true;}
] call CBA_Settings_fnc_init;

//End AI skills - Conscript.


if (!hasInterface) exitWith {};

[
	"AAF Extras",
	"AAF_HideHud",
	"Hide HUD",
	{
		[] call aaf_fnc_hideHUDkeybind;
	},
	{},
	[0x44,[false, false, false]],
	false,
	0, 
	true
] call CBA_fnc_addKeybind;



/*
[
	"AAF Extras", //Mod name
	"AAF_HideHud", //action ID
	"Hide HUD", //Display name
	{
		[] call aaf_fnc_hideHUDkeybind;
	}, //downcode
	{},//upcode
	[0x44,[false, false, false]], //default keybind in DIK code
	false, //Fire while being held
	0, //Delay in seconds
	true //overwrite key
] call CBA_fnc_addKeybind;
*/

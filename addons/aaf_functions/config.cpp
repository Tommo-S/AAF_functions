class CfgPatches
{
	class AAF
	{
		name = "AAF Functions";
		author = "Tommo";
		requiredVersion = 1.76;
		requiredAddons[] = {"ace_interaction","ace_zeus","cba_main"};
		units[] = {};
		weapons[] = {};
	};
};


class ctrlToolbox;

class Cfg3DEN {
    class Attributes {
        class Default;
        class Title: Default {
            class Controls {
                class Title;
            };
        };
        class aaf_AI_SkillsControl: Title {
            attributeLoad = "(_this controlsGroupCtrl 131) lbSetCurSel _value;";
            attributeSave = "(lbCurSel (_this controlsGroupCtrl 131))";
            class Controls: Controls {
                class Title: Title{};
                class Value: ctrlToolbox {
                    idc = 131;
                    style = "0x02";
                    x = "48 * (pixelW * pixelGrid * 0.50)";
                    w = "82 * (pixelW * pixelGrid * 0.50)";
                    h = "5 * (pixelH * pixelGrid * 0.50)";
                    rows = 1;
                    columns = 3;
                    strings[] = {"Conscript","Regular","Special Forces"};
                };
            };
        };
    };
    class Group {
        class AttributeCategories {
            class aaf_attributes {
				displayName = "AAF AI Skill Level";
				collapsed = 0;
                class Attributes {
                    class aaf_AI_Skill {
                        property = "aaf_ai_rank";
                        control = "aaf_AI_SkillsControl";
                        displayName = "Group Skill Level";
                        tooltip = "Set group's overall skill level.";
                        expression = "[{(_this select 0) setVariable ['aaf_ai_rank', _this select 1, true];},[_this,(_value + 1)]] call CBA_fnc_execNextFrame;";
                        typeName = "NUMBER";
                        defaultValue = "1";
                    };
                };
            };
        };
    };
};




class Extended_PreInit_EventHandlers {
    class AAF_CBA_Settings {
        init = "call compile preprocessFileLineNumbers '\aaf_functions\XEH_preInit.sqf'";
    };
};

class Extended_PostInit_EventHandlers {
	class AAF_CBA_Keybinds {
		Init = "call compile preprocessFileLineNumbers '\aaf_functions\XEH_postInit.sqf'";
	};
};


class CfgVehicles {
    class Man;
    class CAManBase: Man {
        class ACE_SelfActions {
            class fixVanillaDamage {
                displayName = "Fix Vanilla Damage";
                condition = "true";
                exceptions[] = 
				{
					"isNotInside",
					"isNotSitting"
				};
                statement = "[] call aaf_fnc_fixvanilladamage";
                icon = "\aaf_functions\medical_cross.paa";
			};
			class aaftoggleHUD {
				displayName = "Toggle HUD";
                condition = "true";
                exceptions[] = 
				{
					"isNotInside",
					"isNotSitting"
				};
                statement = "[] call aaf_fnc_hideHUDaceAction";
			};
			class aaf_Insignia {
				condition = "true";
				displayName = "Change Badge";
				exceptions[] = {"isNotSwimming","isNotInside","notOnMap","isNotSitting"};
				icon = "";
				priority = 1;
				statement = "";
				
				class aaf_persig {
				condition = "true";
				displayName = "Change Personal Badge";
				exceptions[] = {"isNotSwimming","isNotInside","notOnMap"};
				icon = "";
				priority = 1;
				statement = "[] call aaf_fnc_personalSigDialog";
				};
				class aaf_grpsig {
				condition = "_player == leader (group _player)";
				displayName = "Change Group Badge";
				exceptions[] = {"isNotSwimming","isNotInside","notOnMap"};
				icon = "";
				priority = 1;
				statement = "[] call aaf_fnc_groupSigDialog";						
				};
			};
		};
	};
   	class ModuleEmpty_F;
	class ACE_Module;
	class Logic;
	class Module_F: Logic
	{
		class EventHandlers;
	};
	class ModuleCurator_F: Module_F
	{
		function="aaf_fnc_ace_zeus_bi_moduleCurator";
		class EventHandlers: EventHandlers
		{
			class aaf_eventhandlers
			{
				init="[{[_this select 0] spawn aaf_fnc_curatorAddEH;}, [(_this select 0)], 15] call CBA_fnc_waitAndExecute";
			};
		};
	};
    //Making Zeus End Scenario & Countdown modules use edited functions for logging.
    class ModuleCountdown_F : Module_F
    {
        function = "aaf_fnc_modulecountdown";
    };
    class ModuleEndMission_F : Module_F
    {
        function = "aaf_fnc_moduleendmission";
    };    
};

class CfgFunctions
{
	class AAF
	{
		class Functions
		{
			tag = "AAF";
			class ace_zeus_bi_moduleCurator {file = "\aaf_functions\functions\ace_zeus_bi_moduleCurator.sqf";};
			class acre_radio_respawn {file = "\aaf_functions\functions\acre_radio_respawn.sqf";};
			class addSpectate {file = "\aaf_functions\functions\addSpectate.sqf";};
			class AAF_Init {
				file = "\aaf_functions\functions\AAF_Init.sqf";
				postInit = 1;
			};
			class AISkill {file = "\aaf_functions\functions\AISkill.sqf";};
			class aiSkillModule {file = "\aaf_functions\functions\aiSkillModule.sqf";};
			class curatorAddEH {file = "\aaf_functions\functions\curatorAddEH.sqf";};
			class curatorObjectEH {file = "\aaf_functions\functions\curatorObjectEH.sqf";};
			class dynGroupsReplacer {file = "\aaf_functions\functions\dynGroupsReplacer.sqf";};
			class dynSimAll {file = "\aaf_functions\functions\dynSimAll.sqf";};
			class dynSimExclude {file = "\aaf_functions\functions\dynSimExclude.sqf";};
			class dynSimExcludeModule {file = "\aaf_functions\functions\dynSimExcludeModule.sqf";};
			class dynSimServer {file = "\aaf_functions\functions\dynSimServer.sqf";};
			class dynSimSingle {file = "\aaf_functions\functions\dynSimSingle.sqf";};
			class endShootingLogger {file = "\aaf_functions\functions\endShootingLogger.sqf";};
			class fixVanillaDamage {file = "\aaf_functions\functions\fixVanillaDamage.sqf";};
			class gear {file = "\aaf_functions\functions\gear.sqf";};
			class grpclean {file = "\aaf_functions\functions\grpclean.sqf";};
			class hideHUDaceAction {file = "\aaf_functions\functions\hideHUDaceAction.sqf";};
			class hideHUDkeybind {file = "\aaf_functions\functions\hideHUDkeybind.sqf";};			
			class JIPZeusAssign {file = "\aaf_functions\functions\JIPZeusAssign.sqf";};
			class medicalDebug {file = "\aaf_functions\functions\medicalDebug.sqf";};
            class moduleCountdown {file = "\aaf_functions\functions\bi_modulecountdown.sqf";};
            class moduleEndMission {file = "\aaf_functions\functions\bi_moduleEndMission.sqf";};
			class randomDeath {file = "\aaf_functions\functions\randomDeath.sqf";};
			class reviveMarkers {file = "\aaf_functions\functions\reviveMarkers.sqf";};
			class reviveMarkerUpdater {file = "\aaf_functions\functions\reviveMarkerUpdater.sqf";};
			class resupply {file = "\aaf_functions\functions\resupply.sqf";};
			class serverFPS {file = "\aaf_functions\functions\serverFPS.sqf";};
			class setGroupSig {file = "\aaf_functions\functions\setGroupSig.sqf";};
			class setPersonalSig {file = "\aaf_functions\functions\setPersonalSig.sqf";};
			class skillNotification {file = "\aaf_functions\functions\skillNotification.sqf";};
			class vehRespawnCMD {file = "\aaf_functions\functions\vehRespawnCMD.sqf";};
			class vehRespawnEH {file = "\aaf_functions\functions\vehRespawnEH.sqf";};
			class vehicleDeath {file = "\aaf_functions\functions\vehicleDeath.sqf";};
            class zeusCleanOldEHs {file = "\aaf_functions\functions\zeusCleanOldEHs.sqf";};
			class groupSigDialog {file = "\aaf_functions\dialogs\groupSigDialog.sqf";};
			class personalSigDialog {file = "\aaf_functions\dialogs\personalSigDialog.sqf";};
		};
	};
};

class RscPicture;
class RscText;
class RscCombo;
class RscCheckbox;
class RscButton;
class RscButtonMenuCancel;
class aaf_insignia_personal
{
	idd = 8401;
	movingEnabled = false;
	class controls
	{
		class aaf_dialog_bg: RscPicture
		{
			idc = 1200;
			text = "aaf_functions\dialogs\Generic_1024_1024.paa";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.55 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {-1,-1,-1,0.5};
			colorActive[] = {-1,-1,-1,0.5};
		};
		class aaf_persig_preview_Border: RscPicture
		{
			idc = 1203;
			text = "#(argb,8,8,3)color(0,0,0,1)";
			x = 0.314375 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.242 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
		};
		class aaf_persig_header: RscText
		{
			idc = 1000;
			text = "Set Personal Badge"; //--- ToDo: Localize;
			style = ST_CENTER;
			x = 0.371094 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.232031 * safezoneW;
			h = 0.055 * safezoneH;
			colorBackground[] = {0,0,0,0};
			sizeEx = 3 * 0.04;
		};
		class aaf_persig_combo: RscCombo
		{
			idc = 2100;
			x = 0.314375 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.022 * safezoneH;
			onLBSelChanged = "[] call aaf_dlg_persigPreview";
		};
		class RscText_1001: RscText
		{
			idc = 1001;
			text = "Preview"; //--- ToDo: Localize;
			x = 0.350469 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 2 * 0.04;
		};
		class aaf_persig_preview_BG: RscPicture
		{
			idc = 1204;
			text = "#(argb,8,8,3)color(0.5,0.5,0.5,1)";
			x = 0.316405 * safezoneW + safezoneX;
			y = 0.360361 * safezoneH + safezoneY;
			w = 0.140312 * safezoneW;
			h = 0.235278 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
		};
		class aaf_persig_preview: RscPicture
		{
			idc = 1205;
			text = "";
			x = 0.324687 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.198 * safezoneH;
		};
		class RscText_1002: RscText
		{
			idc = 1002;
			text = "Options"; //--- ToDo: Localize;
			x = 0.551562 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 2 * 0.04;
		};
		class RscCheckbox_2800: RscCheckbox
		{
			idc = 2800;
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.374139 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Will wipe your saved badge when you click Save.";
			OnCheckedChanged = "[_this] call aaf_dlg_persigCheckboxPreview";
		};
		class RscCheckbox_2801: RscCheckbox
		{
			idc = 2801;
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.434 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Wear specialist badges before personal badges when available.";
		};
		class RscText_1003: RscText
		{
			idc = 1003;
			text = "Clear Saved Badge"; //--- ToDo: Localize;
			tooltip = "Will wipe your saved badge when you click Save.";
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.368 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 1 * 0.04;
		};
		class RscText_1004: RscText
		{
			idc = 1004;
			text = "Use Specialist Before Personal"; //--- ToDo: Localize;
			tooltip = "Wear specialist badges before personal badges when available.";
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.434 * safezoneH + safezoneY;
			w = 0.154687 * safezoneW;
			h = 0.033 * safezoneH;
			sizeEx = 1 * 0.04;
		};
		class RscButton_2600: RscButton
		{
			text = "Save"; //--- ToDo: Localize;
			x = 0.505156 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.033 * safezoneH;
			action = "[] call aaf_dlg_persigFinish";
		};
		class RscButtonMenuCancel_2700: RscButton
		{
			text = "Cancel"; //--- ToDo: Localize;
			x = 0.587656 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closedialog 0";
		};
	};
};
class aaf_insignia_group
{
	idd = 8402;
	movingEnabled = false;
	class controls 
	{
		class aaf_dialog_bg: RscPicture
		{
			idc = 1200;
			text = "aaf_functions\dialogs\Generic_1024_1024.paa";
			x = 0.29375 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.4125 * safezoneW;
			h = 0.55 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {-1,-1,-1,0.5};
			colorActive[] = {-1,-1,-1,0.5};
		};
		class aaf_persig_preview_Border: RscPicture
		{
			idc = 1203;
			text = "#(argb,8,8,3)color(0,0,0,1)";
			x = 0.314375 * safezoneW + safezoneX;
			y = 0.357 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.242 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
		};
		class aaf_persig_header: RscText
		{
			idc = 1000;
			text = "Set Group Badge"; //--- ToDo: Localize;
			style = ST_CENTER;
			x = 0.371094 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.232031 * safezoneW;
			h = 0.055 * safezoneH;
			colorBackground[] = {0,0,0,0};
			sizeEx = 3 * 0.04;
		};
		class RscText_1002: RscText
		{
			idc = 1002;
			text = "Options"; //--- ToDo: Localize;
			x = 0.551562 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 2 * 0.04;
		};
		class aaf_persig_combo: RscCombo
		{
			idc = 2100;
			x = 0.314375 * safezoneW + safezoneX;
			y = 0.621 * safezoneH + safezoneY;
			w = 0.144375 * safezoneW;
			h = 0.022 * safezoneH;
			onLBSelChanged = "[] call aaf_dlg_groupSigPreview";
		};
		class RscText_1001: RscText
		{
			idc = 1001;
			text = "Preview"; //--- ToDo: Localize;
			x = 0.350469 * safezoneW + safezoneX;
			y = 0.302 * safezoneH + safezoneY;
			w = 0.0825 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 2 * 0.04;
		};
		class aaf_persig_preview_BG: RscPicture
		{
			idc = 1204;
			text = "#(argb,8,8,3)color(0.5,0.5,0.5,1)";
			x = 0.316405 * safezoneW + safezoneX;
			y = 0.360361 * safezoneH + safezoneY;
			w = 0.140312 * safezoneW;
			h = 0.235278 * safezoneH;
			colorText[] = {1,1,1,1};
			colorBackground[] = {1,1,1,1};
		};
		class aaf_persig_preview: RscPicture
		{
			idc = 1205;
			text = "";
			x = 0.324687 * safezoneW + safezoneX;
			y = 0.379 * safezoneH + safezoneY;
			w = 0.12375 * safezoneW;
			h = 0.198 * safezoneH;
		};
		class RscButton_2600: RscButton
		{
			text = "Save"; //--- ToDo: Localize;
			x = 0.505156 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.033 * safezoneH;
			action = "[] call aaf_dlg_groupSigFinish";
		};
		class RscButtonMenuCancel_2700: RscButton
		{
			text = "Cancel"; //--- ToDo: Localize;
			x = 0.587656 * safezoneW + safezoneX;
			y = 0.599 * safezoneH + safezoneY;
			w = 0.04125 * safezoneW;
			h = 0.033 * safezoneH;
			action = "closedialog 0";
		};
		class RscCheckbox_2800: RscCheckbox
		{
			idc = 2800;
			x = 0.510312 * safezoneW + safezoneX;
			y = 0.374139 * safezoneH + safezoneY;
			w = 0.0154688 * safezoneW;
			h = 0.033 * safezoneH;
			tooltip = "Forces group members to use the group badge when enabled.";
		};
		class RscText_1003: RscText
		{
			idc = 1003;
			text = "Override Personal Badges"; //--- ToDo: Localize;
			tooltip = "Forces group members to use the group badge when enabled."; // Tooltip text
			x = 0.536094 * safezoneW + safezoneX;
			y = 0.368 * safezoneH + safezoneY;
			w = 0.0979687 * safezoneW;
			h = 0.044 * safezoneH;
			sizeEx = 1 * 0.04;
		};
	};
};
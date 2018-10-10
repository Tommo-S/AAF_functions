/*
Intention: To be used from an Ares custom Zeus module, this will generate a list of objects to enable dynamic simulation on. It then passes this list to the server to act on.

Usage:
Add the following line to initplayerlocal.sqf 
["Dynamic Simulation", "Enable for all objects.", { [] spawn fnc_dynSimAll; }] call Ares_fnc_RegisterCustomModule;

While in Zeus, go to modules, then the Dynamic Simulation tab, select enable for all objects module, place anywhere in world. 
*/

//_allMObjects = allMissionObjects "All";
//This picks up ambient objects like bees, rabbits, etc. Leaving this comment in for future reference.

private _list = [];

_list = allGroups;
//Any groups.

_list = _list + vehicles;
//All vehicles, both occupied and empty. Note: dynamic sim won't turn on for a vehicle that has a crew. The crew itself will have dynamic sim enabled.

_list = _list + allMissionObjects "Static";
//Buildings, walls, fences, etc. This doesn't return baked in map objects.

_list = _list + allMissionObjects "Thing";
//Props

["Dynamic simulation enabled for everything."] call Ares_fnc_ShowZeusMessage; //"Good job kiddo" message for Zeus.
[_list,true] remoteExec ["aaf_fnc_dynSimServer", 2, false];
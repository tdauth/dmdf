//! import "Game/Struct Buildings.j"
//! import "Game/Struct Camera Height.j"
//! import "Game/Struct Character.j"
//! import "Game/Struct Classes.j"
//! import "Game/Struct Class Selection.j"
//! import "Game/Struct Commands.j"
//! import "Game/Struct Dungeon.j"
//! import "Game/Struct Fellow.j"
//! import "Game/Struct Dmdf Hash Table.j"
//! import "Game/Struct Game Cheats.j"
//! import "Game/Struct Game.j"
//! import "Game/Struct Grimoire Spell.j"
//! import "Game/Struct Grimoire.j"
//! import "Game/Struct History.j"
//! import "Game/Struct Item Types.j"
//! import "Game/Struct Map Changer.j"
//! import "Game/Struct Map Settings.j"
//! import "Game/Struct Missions.j"
//! import "Game/Struct Npc Fellows.j"
//! import "Game/Struct Options.j"
//! import "Game/Struct Order Animations.j"
//! import "Game/Struct Quest Area.j"
static if (DMDF_NPC_ROUTINES) then
//! import "Game/Struct Routines.j"
endif
//! import "Game/Struct Save System.j"
//! import "Game/Struct Shop.j"
//! import "Game/Struct Shrine.j"
//! import "Game/Struct Spawn Point.j"
//! import "Game/Struct Spell.j"
//! import "Game/Struct Talk.j"
//! import "Game/Struct Tree Transparency.j"
//! import "Game/Struct Tutorial.j"
//! import "Game/Struct Zone.j"
//! import "Game/Library Language.j"

/**
 * \brief The game library contains all the core systems of The Power of Fire.
 * These systems are available in every map of the modification by default.
 */
library Game requires StructGameBuildings, StructGameCameraHeight, StructGameCharacter, StructGameClasses, StructGameClassSelection, StructGameCommands, StructGameFellow, StructGameDmdfHashTable, StructGameDungeon, StructGameGameCheats, StructGameGame, StructGameGrimoireSpell, StructGameGrimoire, StructGameHistory, StructGameItemTypes, StructGameMapChanger, StructGameMapSettings, StructGameMissions, StructGameNpcFellows, StructGameOptions, StructGameOrderAnimations, StructGameQuestArea, optional StructGameRoutines, StructSaveSystem, StructGameShop, StructGameShrine, StructGameSpawnPoint, StructGameSpell, StructGameTalk, StructGameTreeTransparency, StructGameTutorial, StructGameZone, LibraryGameLanguage
endlibrary
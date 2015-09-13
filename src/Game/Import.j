//! import "Game/Struct Character.j"
static if (DMDF_CHARACTER_STATS) then
//! import "Game/Struct Character Stats.j"
endif
//! import "Game/Struct Classes.j"
//! import "Game/Struct Class Selection.j"
//! import "Game/Struct Fellow.j"
//! import "Game/Struct Dmdf Hash Table.j"
//! import "Game/Struct Game.j"
//! import "Game/Struct Grimoire.j"
//! import "Game/Struct History.j"
//! import "Game/Struct Item Types.j"
//! import "Game/Interface Map Data Interface.j"
//! import "Game/Struct Quest Area.j"
static if (DMDF_NPC_ROUTINES) then
//! import "Game/Struct Routines.j"
endif
//! import "Game/Struct Shrine.j"
//! import "Game/Struct Spawn Point.j"
//! import "Game/Struct Spell.j"
//! import "Game/Struct Talk.j"
//! import "Game/Struct Tutorial.j"
//! import "Game/Library Language.j"

library Game requires StructGameCharacter, optional StructCharacterStats, StructGameClasses, StructGameClassSelection, StructGameFellow, StructGameDmdfHashTable, StructGameGame, StructGameGrimoire, StructGameHistory, StructGameItemTypes, InterfaceGameMapDataInterface, StructGameQuestArea, optional StructGameRoutines, StructGameShrine, StructGameSpawnPoint, StructGameSpell, StructGameTalk, StructGameTutorial, LibraryGameLanguage
endlibrary
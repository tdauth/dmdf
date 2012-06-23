//! import "Game/Struct Character.j"
static if (DMDF_CHARACTER_STATS) then
//! import "Game/Struct Character Stats.j"
endif
//! import "Game/Struct Classes.j"
//! import "Game/Struct Fellow.j"
//! import "Game/Struct Dmdf Hash Table.j"
//! import "Game/Struct Game.j"
//! import "Game/Struct Grimoire.j"
//! import "Game/Struct Item Types.j"
//! import "Game/Interface Map Data Interface.j"
//! import "Game/Struct Marker.j"
//! import "Game/Struct Npc Revival.j"
static if (DMDF_NPC_ROUTINES) then
//! import "Game/Struct Routines.j"
endif
//! import "Game/Struct Shrine.j"
//! import "Game/Struct Spell.j"
//! import "Game/Struct Tutorial.j"

library Game requires StructGameCharacter, optional StructCharacterStats, StructGameClasses, StructGameFellow, StructGameDmdfHashTable, StructGameGame, StructGameGrimoire, StructGameItemTypes, InterfaceGameMapDataInterface, StructGameMarker, StructGameNpcRevival, optional StructGameRoutines, StructGameShrine, StructGameSpell, StructGameTutorial
endlibrary
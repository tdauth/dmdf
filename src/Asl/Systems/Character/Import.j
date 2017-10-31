//! import "Systems/Character/Struct Characters Scheme.j"
//! import "Systems/Character/Struct Abstract Character System.j"
//! import "Systems/Character/Struct Abstract Quest.j"
//! import "Systems/Character/Struct Buff.j"
//! import "Systems/Character/Struct Character.j"
//! import "Systems/Character/Struct Class Selection.j"
//! import "Systems/Character/Struct Class.j"
//! import "Systems/Character/Struct Info.j"
//! import "Systems/Character/Struct Inventory.j"
//! import "Systems/Character/Struct Item Type.j"
//! import "Systems/Character/Struct Spell.j"
//! import "Systems/Character/Struct Quest.j"
//! import "Systems/Character/Struct Quest Item.j"
//! import "Systems/Character/Struct Revival.j"
//! import "Systems/Character/Struct Shrine.j"
//! import "Systems/Character/Struct Spell.j"
//! import "Systems/Character/Struct Talk.j"
//! import "Systems/Character/Struct View.j"
//! import "Systems/Character/Struct Video.j"

/**
 * \brief The character system allows you to create an RPG character per player (\ref ACharacter) with a custom class (\ref AClassSelection and \ref AClass), inventory (\ref ACharacterInventory), revival shrines (\ref AShrine), custom spells (\ref ASpell), custom quests (\ref AQuest), custom NPC dialogs (\ref ATalk), videos for all players (\ref AVideo) and a custom 3D view (\ref AView).
 * For RPG maps and mods it often is necessary to create a typical RPG like environment with player characters.
 * This library allows such a functionality and allows you to enable systems optionally for a player character.
 */
library ASystemsCharacter requires AStructSystemsCharacterCharactersScheme, AStructSystemsCharacterAbstractCharacterSystem, AStructSystemsCharacterAbstractQuest, AStructSystemsCharacterBuff, AStructSystemsCharacterCharacter, AStructSystemsCharacterClassSelection, AStructSystemsCharacterClass, AStructSystemsCharacterInfo, AStructSystemsCharacterInventory, AStructSystemsCharacterItemType, AStructSystemsCharacterQuest, AStructSystemsCharacterQuestItem, AStructSystemsCharacterRevival, AStructSystemsCharacterShrine, AStructSystemsCharacterSpell, AStructSystemsCharacterTalk, AStructSystemsCharacterView, AStructSystemsCharacterVideo
endlibrary
The Power of Fire <a name="introduction"></a>
======================

The Power of Fire (German "Die Macht des Feuers") is a cooperative RPG multiplayer modification of the realtime strategy game Warcraft III: The Frozen Throne.
It alters the game to a roleplay game which can either be played in multiplayer or in a singleplayer campaign which allows traveling between multiple maps.
All source code is put under the GPLv3.
The original language of the modification is German but there are English translations.

# Table of Contents
1. [Introduction](#introduction)
2. [Repository and Resources](#repository_and_resources)
3. [Installation](#installation)
4. [Dependencies](#dependencies)
5. [Formats](#formats)
    1. [JASS](#formats_jass)
    2. [vJass](#formats_vjass)
    3. [Wurst](#formats_wurst)
    4. [MPQ](#formats_mpq)
6. [Windows Setup](#windows)
7. [JassHelper Setup](#jasshelper_setup)
8. [JassNewGenPack or SharpCraft World Editor Extended Bundle](#jass_new_gen_pack)
9. [Source Code](#source_code)
    1. [Code Style](#source_code_code_style)
    2. [Testing](#source_code_testing)
10. [Advanced Script Library](#asl)
    1. [Code Integration](#asl_code_integration)
    2. [Bonus Mod Support](#asl_bonus_mod_support)
    3. [Containers](#asl_containers)
    4. [Wrappers](#asl_wrappers)
    5. [Strings](#asl_strings)
11. [Core Systems](#core_systems)
    1. [Fellows](#core_systems_fellows)
    2. [Inventory](#core_systems_inventory)
    3. [Custom Item Types](#core_systems_custom_item_types)
    4. [Dungeons](#core_systems_dungeons)
    5. [Spawn Points](#core_systems_spawn_points)
    6. [Tree Transparency](#core_systems_tree_transparency)
    7. [Zones](#core_systems_zones)
    8. [Map Transitions](#core_systems_map_transitions)
    9. [Buildings/Bases](#core_systems_buildings)
    10. [Classes](#core_systems_classes)
    11. [Class Selection](#core_systems_class_selection)
    12. [Characters](#core_systems_characters)
    13. [Spells](#core_systems_spells)
    14. [Quests](#core_systems_quests)
12. [Creating a new Map](#creating_a_new_map)
    1. [Directory Structure](#creating_a_new_map_directory_structure)
    2. [Importing Code](#creating_a_new_map_importing_code)
    3. [Import Object Data](#creating_a_new_map_importing_object_data)
    4. [Map Data](#creating_a_new_map_map_data)
    5. [GUI Triggers](#creating_a_new_map_gui_triggers)
    6. [Required Rects](#creating_a_new_map_required_rects)
    7. [Required Camera Setups](#creating_a_new_map_required_camera_setups)
    8. [Saving the Map](#creating_a_new_map_saving_the_map)
13. [Maps](#maps)
14. [Translation](#translation)
15. [Generating Level Icons for the Grimoire](#generating_level_icons_for_the_grimoire)
16. [Release Process](#release_process)
17. [Trigger Editor Integration](#trigger_editor_integration)
18. [Jenkins](#jenkins)
19. [Content](#content)
    1. [Plot](#content_plot)
    2. [Gameplay](#content_gameplay)
    3. [Background Story](#content_background_story)
    4. [Voices](#content_voices)
20. [Blog](#blog)
21. [YouTube Channel](#youtube_channel)
22. [Bugs](#bugs)
23. [Credits](#credits)

## Repository and Resources <a name="repository_and_resources"></a>
If cloning the repository takes too long, you can make a shallow clone or reduce the clone depth and not clone the whole history.
Since I have pushed the history of binary map and campaign files as well, the history became quite big.

The model, texture and sound resources are not part of this repository.

All releases are tagged in the repository: [GIT releases](https://github.com/tdauth/dmdf/releases).
Previous releases required versions with the same tags from the now deprecated repository: [asl](https://github.com/tdauth/asl).

## Installation <a name="installation"></a>
Download the installation setup from the [ModDB](http://www.moddb.com/mods/warcraft-iii-the-power-of-fire/downloads) to install the actual release of this modification.
The latest setups contain the development files, too.

## Dependencies <a name="dependencies"></a>
These are the development dependencies of this modification:
* Warcraft III: The Frozen Throne.
* JassHelper 0.A.2.A
* wc3mapoptimizer
* Batch environment
* wc3lib: For updating trigger data, trigger strings and map translations.

## Formats <a name="formats"></a>
Warcraft III brings several custom file formats which have to be understood to modify the game properly.

### JASS <a name="formats_jass"></a>
[JASS](https://en.wikipedia.org/wiki/JASS) is the scripting language used by Warcraft III to define the logic of a game. Warcraft III contains the two files `common.j` and `common.ai` which declare native functions which can be used in JASS scripts.
The script `Blizzard.j` contains JASS functions and variables which are used for Blizzard's own Warcraft III maps.
They are based on the native functions.
JASS is statically typed, event-driven and procedural.
It allows defining functions and global variables.
Types are only defined as native types.
Objects which have to be deleted manually extend the type `agent` since patch 1.24b.

### vJass <a name="formats_vjass"></a>
[vJass](http://www.wc3c.net/vexorian/jasshelpermanual.html) is a scripting language based on Warcraft III's scripting language JASS.
It adds new features like object oriented programming to the scripting language and is implemented by several compilers which translate the vJass code into JASS code.

The first and probably most popular compiler is the [JassHelper](http://www.wc3c.net/showthread.php?t=88142).
It has also been used for The Power of Fire.

By now other approaches with a better syntax exist like [WurstScript](https://wurstlang.org/) which has not been there when the project was started.
It is highly unlikely that the modification will change its core scripting language since too much code is based on it.
Besides, it has been tested with a specific version of the JassHelper, so there would be a risk of losing functionality or even missing features in the new scripting language.

The size of the modification helped to find the limits of vJass and to make usage of nearly all features.
I even wrote many posts on Wc3C.net to improve the language and to report bugs.

### Wurst <a name="formats_wurst"></a>
[Wurst](https://wurstlang.org) is another scripting language for Warcraft III.
It was created after vJass.
Therefore, this modification is not based on it.
Currently, it would be too much work to convert all vJass code into Wurst although Wurst has some nice features which are missing from vJass.

### MPQ <a name="formats_mpq"></a>
Warcraft III uses the format [MPQ](https://en.wikipedia.org/wiki/MPQ) for data archives.
There is several third-party libraries for accessing MPQ archives such as [StormLib](https://github.com/ladislav-zezula/StormLib) and [wc3lib](https://github.com/tdauth/wc3lib) (only reading).

The Power of Fire provides a custom directory called `War3Mod.mpq` in the Warcraft III installation directory with all required resources such as models, textures, icons and sound files.
This directory has previously been an MPQ archive but has been changed to a directory with patch 1.30.
The data from this directory is automatically loaded by Warcraft III.
It is also automatically loaded by the World Editor.

## Windows Setup <a name="windows"></a>
The batch scripts from the folder `src/Scripts` work on volume `F:` (previously on volume `E:`) and expect the following folders:
* `F:\wc3tools`
    * `F:\wc3tools\5.0wc3mapoptimizer` contains the file `VXJWTSOPT.exe`
    * `F:\wc3tools\Jass NewGen Pack Official` contains the JassNewGenPack 2 with the JassHelper.
* `F:\Projekte\dmdf` contains the content of this repository.
* `F:\Warcraft III` contains Warcraft III: The Frozen Throne.
    * `F:\Warcraft III\Maps\DMDF\` is the target folder for generated optimized maps.

## JassHelper Setup <a name="jasshelper_setup"></a>
JassHelper 0.A.2.A is required since there is an unknown bug in higher version (0.A.2.B) which prevents
code from being compiled correctly.
Read the following posts for further information:
* http://www.wc3c.net/showpost.php?p=1132707&postcount=3630
* http://www.wc3c.net/showpost.php?p=1132728&postcount=3632

The JassHelper binary is part of this repository in the directory [tools/JNGP/jasshelper](./tools/JNGP/jasshelper).

Options [forcemethodevaluate] and [noimplicitthis] are supported!

Edit "jasshelper.conf" in your Warcraft III directory which comes from the JassNewGenPack and set: [jasshelper.conf](./tools/JNGP/jasshelper/jasshelper.conf).

It uses [JassParserCLI](http://www.wc3c.net/showthread.php?t=105235).
It has to be used instead of pjass since there is a memory exhausted bug in "pjass" (http://www.wc3c.net/showpost.php?p=1115263&postcount=154).

## JassNewGenPack or SharpCraft World Editor Extended Bundle <a name="jass_new_gen_pack"></a>
Use either the [JassNewGenPack](https://www.hiveworkshop.com/threads/jass-newgen-pack-official.290525/) or the [SharpCraft World Editor Extended Bundle](https://www.hiveworkshop.com/threads/sharpcraft-world-editor-extended-bundle.292127) to create and modify maps of the modification.
These tools allow the usage of vJass and disable the Doodad limit of the World Editor.

## Source Code <a name="source_code"></a>
All source code of this project is placed in the directory [src](./src).


### Code Style <a name="source_code_code_style"></a>
The source code formatting follows a custom style guide:
* Structs are separated into files called "Struct <struct name>.j". The file contains a vJass library which requires all dependencies of the struct.
* Every directory contains a file called "Import.j" which imports all other code files of the directory. It does also contain a library which requires all libraries of the other files.
* Libraries are separated into files called "Library <library name>.j". The file contains a vJass library which requires all dependencies of the library.
* Identifiers use camel case.
* Struct member names start with lower case and a prefix: `m_myMember`.
* Use `thistype` whenever it is possible instead of the struct's name.
* Use always explicit type castings from integers to struct types etc. although it might not be necessary.
* Use `this.` explicitly to refer struct members.
* Make all struct members private and add getters and setters.
* Document all code with [vjassdoc](https://github.com/tdauth/vjassdoc) comments. It is basically the [Doxygen](http://www.stack.nl/~dimitri/doxygen/) syntax using the `\` character and not the `@` character.

Example code for the definition of a struct:
```
library StructMyTestStruct requires Asl, StructMyOtherTestStruct

	/**
	 * \brief This is my brief description.
	 * This is my detailed description.
	 * \todo This has to be done.
	 */
	struct TestStruct
		private MyOtherTestStruct m_myMember

		/**
		 * This method sets my member to the value of \p myMember.
		 * \param myMember The value to be set.
		 */
		public method setMyMember takes MyOtherTestStruct myMember returns nothing
			set this.m_myMember = myMember
		endmethod

		/**
		 * \return Returns the value of the struct attribute.
		 */
		public method myMember takes nothing returns MyOtherTestStruct
			return this.m_myMember
		endmethod

		public static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			return this
		endmethod
	endstruct
endlibrary
```

At the moment vjassdoc is very limited and generates basic HTML files for the API documentation.
It has to be improved to support more Doxygen keywords.

### Testing <a name="source_code_testing"></a>
Currently, there is no debugger for JASS. Patch 1.29 will bring debugging events and logging functionality which will help to find serious bugs.
There is some unit tests in the directory [Test](./src/Asl/Test) for the ASL.
Much more tests need to be added in the future.
The tests can be run with the following chat commands when the map has been saved with the debug mode of vJass:
* `debugstring`- Runs string debug.
* `debugmultiboardbar` - Runs multiboard bar debug.
* `debuglist` - Runs list debug.
* `debugtd` - Runs time of day debug.
* `debugtimer` - Runs timer debugging hook function.
* `debugdesync` - Runs desync test.
* `debugbonusmod` - Runs Bonus Mod test.
* `debugbash` - Tests ShowBashTextTagForPlayer().
* `debugimage` - Tests CreateImageForPlayer().
* `debugnatives` - Test if option A_DEBUG_NATIVES does work.

A new cheat command has to be added for each new unit test to the file [Library Utilities.j](./src/Asl/Systems/Debug/Library%20Utilities.j).

Cheats help manual testing when the map is saved in the debug mode of vJass.
The library [Library Utilities.j](./src/Asl/Systems/Debug/Library%20Utilities.j) and the struct [GameCheats](./src/Game/Struct%20Game%20Cheats.j) provide many custom cheat commands for testing the maps.

## Advanced Script Library <a name="asl"></a>
The Advanced Script Library (short ASL) is the core of this modification.
Its code can be found in the directory [src/ASL](./src/Asl).
It has formerly been a separate repository but is now merged into this repository.

### Code Integration <a name="asl_code_integration"></a>
Use the file [src/ASL/Import Asl.j](./src/Asl/Import%20Asl.j) to import all required code from the ASL.
This is done automatically when the file [src/Import Dmdf.j](./src/Import%20Dmdf.j) is imported.

The following list shows you which global constants have to be specified in your custom code that ASL works properly:
```
globals
	constant boolean A_DEBUG_HANDLES = false // not usable yet!
	constant boolean A_DEBUG_NATIVES = false
	constant real A_MAX_COLLISION_SIZE = 500.0 // used by function GetUnitCollisionSize
	constant integer A_MAX_COLLISION_SIZE_ITERATIONS = 10 // used by function GetUnitCollisionSize
	constant integer A_SPELL_RESISTANCE_CREEP_LEVEL = 6 // used by function IsUnitSpellResistant
	// used by function GetTimeString()
	constant string A_TEXT_TIME_VALUE = "0%1%"
	constant string A_TEXT_TIME_PAIR = "%1%:%2%"
	// used by ADialog
	constant string A_TEXT_DIALOG_BUTTON = "[%1%] %2%" // first one is the button short cut (integer), second one is the button text (string)
endglobals
```
These globals are defined in the file `src/Import Dmdf.j` with the values for the modification.

If you are using debug mode and ASL's debug utilities (`ASystemsDebug`) you will have to define a lot of cheat strings.
For default English strings you can import a pre-defined file using the following statement:
```
//! import "Systems/Debug/Text en.j"
```
This is also automatically done in the file `src/Import Dmdf.j`.

**WARNING:** Apparently, GetLocalizedString() in constant strings crashes the game in map selection!

**WARNING:** Using % chars in the custom map script in the trigger editor leads to unexpected results. You should define the globals somewhere else if possible!

### BonusMod Support <a name="asl_bonus_mod_support"></a>
For using Bonus Mod you have to make an entry in the "jasshelper.conf" file for the object merger tool.
It should always be named "ObjectMerger".
You have to import file `src/ASL/Systems/BonusMod/Creation Bonus Mod.j` once to create all object editor data required by Bonus Mod code.

### Containers <a name="asl_containers"></a>
The ASL provides container types similar to programming languages like Java and C++ for storing a number of elements.
Textmacros are used to provide them in a generic way.
These are the available container text macros:
* [A_VECTOR](./src/Asl/Core/General/Struct%20Vector.j) - Provides a random acess container for a number of elements. Appending and accessing elements if fast. Removing and inserting elements is slow.
* [A_LIST](./src/Asl/Core/General/Struct%20List.j) - A double linked list container for a number of elements. Removing and inserting elements is fast. Accessing elements is slow.

The ASL provides default text macro instances which generate structs which can be used for containers:
* AIntegerVector
* AStringVector
* ABooleanVector
* ARealVector
* AHandleVector
* ATriggerVector
* etc.

* AIntegerList
* AStringList
* ABooleanList
* ARealList
* AHandleList
* etc.

Note that the number of instances is limited to a fixed size.
Iterators can be used to access the elements of containers.
For example, the type `AIntegerList` provides the struct `AIntegerListIterator` which is returned by the method `begin`.
This is inspired by the standard library containers of C++.

### Wrappers <a name="asl_wrappers"></a>
The ASL provides wrapper types for native JASS types which provide more methods and allow them to be used easier:
* [AGroup](./src/Asl/Core/General/Struct%20Group.j) - Simplifies the access to the type `group` which stores a unit group. Allows accessing the units more easily.
* [AForce](./src/Asl/Core/General/Struct%20Force.j) - Simplifies the access to the type `force` which stores a player force.

### Strings <a name="asl_strings"></a>
The ASL provides additional structs and functions for handling strings and formatting them in its library `ACoreString`.

## Core Systems <a name="core_systems"></a>
The code of the modification is based on the Advanced Script Library.
It provides some basic systems which are used in every map of the modification.
The core systems are mostly placed in the folder `src/Game`.

### Fellows <a name="core_systems_fellows"></a>
An NPC fellow is a Warcraft III hero unit which can be shared with one or all players.
This means that the players can control the unit for some time.
The unit is also revived automatically when it dies.
The struct [Fellow](./src/Game/Struct%20Fellow.j) allows the creation of fellows.
Fellows have backpacks only which allow them to carry several items

### Inventory <a name="core_systems_inventory"></a>
The ASL provides the struct [AUnitInventory](./src/Asl/Systems/Inventory/Struct%20Unit%20Inventory.j).
It allows a hero with the inventory ability to carry more than six different items in a backpack.
It does also allow heroes to six different items equipped at the same time while carrying other items in the backpack.
Items in the backpack are not equipped but can be used (like potions).
Each equipable item must have certain equipment type.
Create different [AItemType](./src/Asl/Systems/Inventory/Struct%2Item%20Type.j) instances To support different item types from the object data and to specify their equipment type.
The Power of Fire extends this struct with custom types.

### Custom Item Types <a name="core_systems_custom_item_types"></a>
The struct [ItemTypes](./src/Game/Struct%20Item%20Types.j) stores all different custom item types globally.
All custom item types are created in the method `ItemTypes.init()` since they must be available in every map.

To hide the icon of an item ability when the backpack is open, the ability of the item should be added to a spellbook ability with the same ID as the spellbook of the character unit.
Then, the spellbook ability should be added to the item instead of the actual ability.
Disable the spellbook ability for all players in the method `ItemTypes.onInit()`.
The contained ability will still be enabled and when the backpack is enabled, the icon will be inside the spellbook of the character.
This avoids hiding favorite spells of the character.

To add range items like bows you have to create a custom item type.
The range items are realized by using a different unit type for every character class which has a range attack type.
When equipping a range item, the character's unit type is morphed into the other unit type with the help of passive hero transformation.
The struct `RangeItemType` realizes the passive hero transformation.
It should be used to creat custom range item types.

To use the proper attack animations the IDs of the item types have to added to methods like
`ItemTypes.itemTypeIdIsTwoHandedLance()` for example.

### Dungeons <a name="core_systems_dungeons"></a>
Some maps have areas which are use for interiors or dungeons which are separated from the actual playble map.
The struct `Dungeon` allows to specify such ares in form of rects and optionally fixed camera setups.
The player gets the sense of entering a separated area when the character enters a dungeon.

### Spawn Points <a name="core_systems_spawn_points"></a>
The Power of Fire allows you to respawn creeps and items on the map after being killd or picked up.
This should improve the gameplay experience since after clearing a map returning to this map would be less interesting without any new creeps or items to collect.
Besides, the player would get a disadvantage since he cannot level his character nor collect valuable stuff.

Usually the spawn points are created during the map initialization using existing units and items already placed on the map.

### Tree Transparency <a name="core_systems_tree_transparency"></a>
Since the modification uses bigger trees than Warcraft III (for immersion), it is necessary to make them transparent if the player looks at them or the character walks nearby.
The struct `TreeTransparency` handles this automatic transparency management for every player.

### Zones <a name="core_systems_zones"></a>
The modification allows traveling between maps in singleplayer like the Bonus Campaign of Warcraft III: The Frozen Throne.
For every map of the campaign, there has to be a zone.
A complete list of all zones is initialized by the methodd `Zone.initZones()`.
The struct `Zone` can be use to create map exits at certain rects to specified maps.

### Map Transitions <a name="core_systems_map_transitions"></a>
Map transitions allow traveling between maps in the singleplayer campaign.
The struct `MapChanger` provides several methods to store the characters and change to another map and restore the characters in the other map.
It saves the current map as savegame and loads the savegame if the player changes back to the map.
The characters are always stored and restored.

It is automatically detected if the current game is a singleplayer campaign with the help of the method `Game.isCampaign()`.
The method checks for the custom object `'h600'` with the name `"IsCampaign"`.
It has to be created in the custom object data of the campaign and must not exist in the single player maps.

It is important to mention some restrictions on campaign and savegame names in Warcraft III:
* No underscores in campaign names.
* Shorter file names for savegames.
* Probably no dots in savegames or campaign names.

Otherwise, the map transitions won't work.

### Buildings/Bases <a name="core_systems_buildings"></a>
Every player is allowed to have one single base per map when the player's character has reached level 30.
For builing a base the player must buy the item of his class building and construct the building on somewhere on the map.
The building allows to use several spells, recruit women and to be improved by researches.
It does also allow to build transporting horses which can collect gold from a market on the map.
Therefore, every map should have a market.
The amount of gold the horses collect from a market depends on the distance they have to move to it.
The system is implemented in the file [Struct Buildings.j](./src/Game/Struct%20Buildings.j).
It assures that when a building is destroyed the player can construct a new one.


### Classes <a name="core_systems_classes"></a>
The modification provides several different classes.
Each character can have exactly one class.
The class defines the start attributes and attributes per level of the character.
It does also define which spells can be learned by the character.
Some items can only be equipped by specific classes.
The class does also affect dialogues with NPCs.
The class can be changed after its initial selection with the `-repick` command.
The following classes are provided by the modification:
* Cleric
* Necromancer
* Druid
* Knight
* Dragon Slayer
* Ranger
* Elemental Mage
* Wizard

The struct [Classes](./src/Game/Struct%20Classes.j) provides static methods for accessing all these classes.
To support all other systems (like the equipment system) there has to be several hero unit types per class:
* Melee combat
* Range combat
* Melee combat on a sheep
* Range combat on a sheep
* Melee combat on a horse
* Range combat on a horse

The unit types (except for the horse) have to use the Villager255 model from Hive which provides all required animations.
Every class has its own spells.
However, some spells are shared between all classes:
* Attribute Bonus
* Ride a Horse

### Class Selection <a name="core_systems_class_selection"></a>
The class selection allows the players to choose a class in the beginning of the game and when repicking their class.
It shows a description, the attributes per level, the start attributes, start items and spells for every class.
In multiplayer games, the time to choose a class is limited since some players might be afk.
It does also recognize players who leave.
The game starts only when the timer triggers or when all players have chosen their class.
When the timer triggers, the currently shown class is chosen for players who have not chosen their class yet.
For computer-controlled players, the class is choosen randomly.
The struct [ClassSelection](./src/Game/Struct%20Class%20Selection.j) provides the implementation of the class selection.
It extends the ASL struct [AClassSelection](./src/ASL/Systems/Character/Struct%20Class%20Selection.j) and adds features such as change buttons and the spellbook.

### Characters <a name="core_systems_characters"></a>
Each player of the six players can control one character.
The character gets experience by killing enemies and solving quests.
For every level the character gets two skill points and attribute points depending on his class.
The character can learn new spells using the skill points.
When the character dies, he will be revived automatically at his currently enabled revival shrine.
The struct [Character](./src/Game/Struct%20Character.j) provides all functionality for a character.

### Spells <a name="core_systems_spells"></a>
The character can skill spells via the [Grimoire](./src/Game/Struct%20Grimoire.j).
It contains all learnable spells of his class.
It is necessary since hero abilities are limited to six in Warcraft III: The Frozen Throne.
The character can use four favorite spells and has a sub menu for the remaining learned spells.
This allows him to use up to 15 different spells at the same time.
There is one basic spell which is learned in the beginning and has only one level.
Besides, there is two ultimate spells: One at level 12 and one at level 25.
Both have only one level.
All other class spells have five different levels.
All spells which can be used in every map are stored in the directory [Spells](./src/Spells/).
Note that it does also contain unit spells which are not for characters only.
Many custom spells are based on the channel ability of Warcraft III (`ANcl`).
They have to use different base order IDs.
Otherwise, when a spell is cast which uses the same base order ID as another one, only one of them can be cast.
The following table shows important information of different spells:

| Spell Name    | Class          | Type          | ID            | Base Order ID      | Description        |
| ------------- | -------------  | ------------- | ------------- | ------------------ | ------------------ |
| Earth Prison  | Elemental Mage | Standard      | 'A01H'        | `ancestralspirit`  | Basic stun spell.  |

TODO Complete the table based on the German sheet [Zauber](doc/Planung/Spielinhalt/Klassen/Zauber.ods) and all current object data.

### Quests <a name="core_systems_quests"></a>
There is two different types of quests in this modification:
* Shared Quests - Must be solved together by all players.
* Character Quests - Can be solved once by each player.

The struct [AQuest](./src/ASL/Systems/Character/Struct%20Quest.j) can be used to implement quests.
Derive a new struct from it to create your custom quest.
Then implement either the module [CharacterQuest](./src/Quests/Module%20Character%20Quest.j) or [SharedQuest](./src/Quests/Module%20Quest.j) at the end of the struct to define the quest type.

## Creating a new Map <a name="creating_a_new_map"></a>

To create a new map for the modification, several things have to applied for the map to make it work with the modification.

### Directory Structure <a name="creating_a_new_map_directory_structure"></a>
It's highly recommended by me that you divide your map code into several files which are placed
in various directories.
Your map code folder should look like this:
* `Spells` - directory for map-specific spell structs
* `Map` - directory for default map structs
* `Videos` - directory for map video structs
* `Quests` - directory for map quest structs
* `Talks` - directory for map talk structs
* `Import.j` - file for map code library and import statements

### Import Code <a name="creating_a_new_map_importing_code"></a>
Every map has to import the vJass systems of the modification.
Simply add the following code snippet to the custom map script:
```
//! import "Import Dmdf.j"
```
The maps have to be saved with the help of the JassHelper which generates a JASS map script based on the vJass code.

### Import Object Data <a name="creating_a_new_map_importing_object_data"></a>
Import the object data from the latest version of the map [Chapter 1: Talras](./maps/Karte%201%20-%20Talras.w3x).
It should be contained by the file [ObjectData.w3o](./maps/ObjectData.w3o).
You can change all Doodads as you like but the other object data should be the same in all maps.

### MapData <a name="creating_a_new_map_map_data"></a>
Every map has to provide a struct called MapData with several methods and static constants which are used by the Game backend of the modification to run all required systems.
```
struct MapData
	/**
	 * Make the constructor and destructor private since the struct is static.
	 */
	private static method create takes nothing returns thistype
		return 0
	endmethod

	private method onDestroy takes nothing returns nothing
	endmethod

	/// Required by \ref Game.
	public static method initSettings takes nothing returns nothing
		call MapSettings.setMapName("AR")
		// Set all MapSettings properties here
	endmethod

	/// Required by \ref Game.
	public static method init takes nothing returns nothing
	endmethod

	/**
	 * Creates the starting items for the inventory of \p whichUnit depending on \p class .
	 * Required by \ref ClassSelection.
	 */
	public static method onCreateClassSelectionItems takes AClass class, unit whichUnit returns nothing
		call Classes.createDefaultClassSelectionItems(class, whichUnit)
	endmethod

	/// Required by \ref ClassSelection.
	public static method onCreateClassItems takes Character character returns nothing
		call Classes.createDefaultClassItems(character)
	endmethod

	/// Required by \ref Game.
	public static method onInitMapSpells takes ACharacter character returns nothing
		call initMapCharacterSpells.evaluate(character)
	endmethod

	/// Required by \ref Game.
	public static method onStart takes nothing returns nothing
	endmethod

	/// Required by \ref ClassSelection.
	public static method onSelectClass takes Character character, AClass class, boolean last returns nothing
	endmethod

	/// Required by \ref ClassSelection.
	public static method onRepick takes Character character returns nothing
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacter takes string zone, Character character returns nothing
	endmethod

	/// Required by \ref MapChanger.
	public static method onRestoreCharacters takes string zone returns nothing
	endmethod

	/**
	 * Required by \ref Game. Called by .evaluate()
	 * It is called when a video sequence is started.
	 */
	public static method onInitVideoSettings takes nothing returns nothing
	endmethod

	/**
	 * Required by \ref Game. Called by .evaluate()
	 * It is called when a video sequence is stopped.
	 */
	public static method onResetVideoSettings takes nothing returns nothing
	endmethod
endstruct
```

### GUI Triggers <a name="creating_a_new_map_gui_triggers"></a>
Instead of importing the code manually and providing a MapData struct, GUI triggers in the World Editor's trigger editor can be used.
TheNorth.w3x is one existing map which follows this approach rather than using vJass code.
The War3Mod.mpq directory has to exist in the Warcraft III directory to use the GUI trigger API provided by The Power of Fire.
When the World Editor is started it show new trigger functions in the trigger editor for the modification.
To use them the following code has to be used in the custom map script:
```
//! import "TriggerData/TPoF.j"
```

There has to be a map settings initialization trigger which looks like this:
```
Init Settings
    Events
        Map - Trigger Register Map Init Settings Event
    Conditions
    Actions
        Map - Set Map Settings Map Name to TN
        Map - Set Map Settings Allied Player to Spieler 7 (GrÃ¼n)
        Map - Set Map Settings Player Neutral feindlich Gives XP True
        Map - Set Map Settings Goldmine to Unit Marktplatz 0008 <gen>
        Map - Set Map Settings Music to Sound\Music\mp3Music\Pippin the Hunchback.mp3;Sound\Music\mp3Music\PippinTheHunchback.mp3
        Map - Set Map Settings Start Level To 60
```

### Required Rects <a name="creating_a_new_map_required_rects"></a>
Every map requires some specific rects for the systems of the modiciation:
* gg_rct_main_window_credits - This is the area where the credits are shown.
* gg_rct_class_selection - At the center of this rect the class selection unit is placed.

There is a list of color definitions for those various rect types which are used in maps:
* cheat rects - purple
* quest rects - white
* layer rects - orange
* main window rects - black
* shrine discover rects - yellow
* shrine revival rects - red
* spawn point rects - grey
* video rects - green
* waypoint rects - grey blue
* weather rects - dark green
* music rects - pink
* marker rects - magenta
* default map rects - lite blue

Besides there are some naming conventions:
* cheat rects - "cheat <cheat name>"
* quest rects - "quest <quest name> [quest item <quest item number> | <user-specific description>]"
* layer rects - "layer <layer name> [entry <entry number> | exit <exit number>]"
* main window rects - "main window <main window name>"
* shrine discover rects - "shrine <shrine number|shrine identifier> discover"
* shrine revival rects - "shrine <shrine number|shrine identifier> revival"
* spawn point rects - "spawn point <spawn point identifier|<spawn point creature name> <spawn point number of spawn points with same creature type>>"
* video rects - "video <video name> <rect identifier>"
* waypoint rects - "waypoint <npc name> <rect number|rect identifier>"
* weather rects - "weather <location name>"
* music rects - "music <location name>"
* marker rects - "marker <marker name>"
* default map rects - "<rect name>"

### Required Camera Setups <a name="creating_a_new_map_required_camera_setups"></a>
* gg_cam_class_selection - This camera setup is used for the view of the class selection in the beginning of the game.
* gg_cam_main_window - This camera setup is used for viewing the main windows of the custom GUI system.

### Saving the Map <a name="creating_a_new_map_saving_the_map"></a>
Usually, the map can be saved with the JassNewGenPack or SharpCraft World Editor Extended Bundle.
If the map cannot be saved with a similar tool, scripts like `src/Scripts/savemaps.bat` or `src/Scripts/savemap_talras_debug.bat` can be used to save it.
These scripts use exported map scripts for every map and call the JassHelper externally.
Therefore, the map script which imports the code has to be exported before and must be specified in the script.

## Maps <a name="maps"></a>
All maps are developed with their German version and share the same object data from the file [ObjectData.w3o](./maps/ObjectData.w3o) which is modified in and exported from the map Talras.
The modification has the following maps:
* [Tutorial Map Dornheim](./maps/Tutorial.w3x) - The tutorial map is the start of the character's journey. It is the home village of the character and called Dornheim. The character has to leave the village to start his journey.
* [Chapter 1: Talras](./maps/Karte%201%20-%20Talras.w3x) - Talras is a castle near the border of the kingdom of the Humans. This map has been the first and only map of the modifiation for a long time. It contains most of the modification's content.
* [Chapter 2: Gardonar](./maps/Karte%202%20-%20Gardonar.w3x) - The journey continues in a palace of the Demon lord Gardonar who offers the character his alliance if the character completes his test successfully.
* [Chapter 2.1: Gardonar's Hell](./maps/Karte%202.1%20-%20Gardonars%20Unterwelt.w3x) - Gardonar's test is that the character fights the Demons of his hell which happens in this map.
* [Chapter 2.2: Deranor's Death Swamp](./maps/Karte%205%20-%20Deranor.w3x) - The characer has to fight Deranor's Undead creatures as well to complete the test.
* [Chapter 3: Holzbruck](./maps/Karte%203%20-%20Holzbruck.w3x) - Finally, after completing the test, the character arrives in the rich town Holzbruck which is besieged later in the game by the Demons, Dark Elves, Orcs and Undead. This map is quite unfinished at this time.
* [Chapter 3.1: Holzbruck's Underworld](./maps/Karte%203.1%20-%20Holzbrucks%20Unterwelt.w3x) - The character has the choice to fight for the town Holzbruck or against it. The player can travel to the underworld of Holzbruck and work for the other side. This map is quite unfinished at this time.
* [Chapter 4: The North](./maps/TheNorth.w3x) - Wigbhert's home is the cold north where he fights the Orcs and other creatures. This map is the only map which is implemented with GUI triggers only and not JASS or vJass code. This map is quite unfinished at this time.
* [World Map](./maps/WorldMap.w3x) - This map is only used in the singleplayer campaign. The player can load it and select a destination map where he/she wants to travel to. It is similar to world maps in games like Skyrim which allow fast traveling.
* [Arena](./maps/Arena.w3x) - A 12 players PvP map where everyone fights vs. everyone and can use the classes of the modification.
* [Credits](./maps/Credits.w3x) - This map can be loaded in singleplayer to see all credits. It is similar to the credits maps of Reign of Chaos and Frozen Throne.

## Translation <a name="translation"></a>
To translate all maps as well as the campaign into different languages, one has to extract the `war3map.wts` files (before optimizing them out).
After extracting the files, the entries have to be replaced by strings in another language.
A copy of the unoptimized map must be created.
Then the modified `war3map.wts` files have to be readded to the copies of the maps.
If the maps are optimized afterwards (both, the one for the original language and the translated), they will differ and on online games won't be considered the same map only translated but the string entries will be optimized and the loading will become faster.

The campaign file has to be copied and uses the translated maps.
Besides, the information etc. has to be translated.

The file for the user interface `war3mapSkin.txt` must also be replaced.

The translation in the source code is done by the functions from the file [Library Language.j](./src/Game/Library%20Language.j).
The function `tre()` allows defining a German text and its English translation:
```
local string myText = tre("Hallo.", "Hello.")
```
The function ``trep()` allows the same but different strings for the plural version depending on a counter:
```
local integer counter = 10
local string myText = Format(trpe("%1% Wolf.", "%1% Wölfe.", "%1% wolf.", "%1% wolves.", counter)).i(counter).result()
```
If other languages than English and German should be supported, new versions of those two functions have to be added.
They depend on the function ``GetLanguage()` which returns the current language of the Warcraft III version of the local player.
Note that this may differ between the players since they might play versions with different languages.

## Generating Level Icons for the Grimoire <a name="generating_level_icons_for_the_grimoire"></a>
The grimoire icons require an icon with every level from 0 to 6. There is an ability per level for the grimoire since changing the icon of an ability cannot be done dynamically.
The script `Scripts/dmdf-all-grimoire-.sh` creates all those icons using ImageMagick.
Since ImageMagick cannot handle BLP files. The icons have to be converted into PNG or TGA files.

## Release Process <a name="release_process"></a>
To update the translations always add English translations to the file `maps/Talras/war3map_en.wts`.
To update all translations automatically use wc3trans from the [wc3lib](https://github.com/tdauth/wc3lib) project.
The script `src/Scripts/jenkins/dmdf_translation.sh` contains everything to automatically update the translations of all maps.

On Windows the project is expected in the directory `F:/Projekte/dmdf`.
On Windows the release process consists of the following steps:
* Export the latest object data from the map `maps/Karte 1 - Talras.w3x` and import it into all other maps (if they use custom Doodads, only import the other parts). This step could be automated by an MPQ tool in the future. The tool does also have to support correct object data importing.
* Extract all unmodified map scripts from all maps in the folder `maps` into their corresponding map script folders like the file `maps/Talras/war3map.j`. This step could be automated by an MPQ tool in the future.
* Save ALL maps with the latest object data and code version. Use `src/Scripts/savemaps.bat` to save the maps automatically. Make sure that the script saves the maps without the "--debug" option for a release. Make sure that no syntax errors are shown anymore and it is saved successfully. Warning: The script uses the exported map scripts of all maps. If they are outdated (files like `maps/Talras/war3map.j`), they have to be extracted from the maps after saving them without the JassHelper enabled.
* Run the script `src/Scripts/makereleasemaps.bat`. This script creates all German release versions of the maps and prepares the English ones.
* Open the prepared English maps (for example in `maps/releases/Arena/Arena<version>.w3x`) with an MPQ editor and replace the file war3map.wts in the archive by the file from the same directory. This step could be automated by an MPQ tool in the future.
* After having done this for ALL maps run the script `src/Scripts/makeenglishreleasemaps.bat` which creates the English optimized release maps.
* Update and import the latest German unit campaign data ([war3map.w3u](./maps/CampaignObjectData/de/war3map.w3u)) from the campaign object data into all optimized campaign release maps in the folder `archive_de/Maps/TPoF/Campaign%CAMPAIGN_VERSION%` (for example `TL.w3x`) with the help of an MPQ editor. It contains one minor difference for detecting the singleplayer campaign mode during the game. The file should be updated to the latest unit data from the German map Talras. This step could be automated by an MPQ tool in the future.
* Update and import the latest English unit campaign data ([war3map.w3u](./maps/CampaignObjectData/en/war3map.w3u)) from the campaign object data into all optimized campaign release maps in the folder `archive_en/Maps/TPoF/Campaign%CAMPAIGN_VERSION%` (for example `TL.w3x`) with the help of an MPQ editor. It contains one minor difference for detecting the singleplayer campaign mode during the game. The file should be updated to the latest unit data from the English map Talras. This step could be automated by an MPQ tool in the future.
* Execute the NSIS script `src/Scripts/installer_en.nsi` to create the English installer. It includes the development files. The installer is created into the folder `releases`.
* Execute the NSIS script `src/Scripts/installer_de.nsi` to create the German installer. It includes the development files. The installer is created into the folder `releases`.

Each map can be optimized using some standard routines.
First of all the wc3lib can be used (wc3object) to drop all object data modifications which are not required anymore.
This can happen when a hero ability is change to a unit ability but some hero only fields are still changed.
This optimization reduces the number of strings which have to be translated or optimized later.

Besides, all object data fields which are for the World Editor only can be optimized.
These are usually editor only suffixes.
The number of modifications (size of the object data) and string entries will be reduced by this which should improve the loading speed of the map.

## Trigger Editor Integration <a name="trigger_editor_integration"></a>
Trigger editor integration means that the trigger editor of the World Editor can be used instead of vJass code.
GUI triggers make it easier for non-programmers to define some logic of the game.
To provide the trigger editor integration, the two files `TriggerData.txt` and `TriggerStrings.txt` have to be generated.
The files `src/TriggerData/TriggerData.txt` and `src/TriggerData/TriggerStrings.txt` are automatically merged by the program wc3converter to generate the files `UI/TriggerData.txt` and `UI/TriggerStrings.txt` in the directory `War3Mod.mpq`.

The tool wc3converter is provided by the project [wc3lib](https://github.com/tdauth/wc3lib).
It can be used the following way to create a new trigger data file:
```
wc3converter --merge TriggerDataNew.txt <path to original TriggerData.txt from War3Patch.mpq> gui/UI/TriggerData.txt
```

Then import the file `TriggerDataNew.txt` as `UI\TriggerData.txt`.

The code file [TPoF.j](./src/TriggerData/TPoF.j) contains all JASS functions which are required for the custom trigger data.
All new JASS functions should be added to this file.
When the trigger editor functionality is used instead of vJass code, this file should be imported instead of `Import Dmdf.j`.
Use the following statement:
```
//! import "TPoF.j"
```

## Jenkins <a name="jenkins"></a>
The modification provides several scripts to setup jobs in Jenkins.
These scripts are located in the directory [src/Scripts/jenkins](./src/Scripts/jenkins).

## Content <a name="content"></a>
The content of this modification consists of items, creatures, spells, classes, story, quests, dialogues, NPCs etc.

### Plot <a name="content_plot"></a>
The plot has been planned in several documents which are part of this repository.
The directory [Spielinhalt](./doc/Planung/Spielinhalt) contains German planning documents of the plot.

### Gameplay <a name="content_gameplay"></a>
The class spells have been planned in a the German sheet [Zauber](doc/Planung/Spielinhalt/Klassen/Zauber.ods).
The sheet contains a list of all IDs which is important for the abilities which are based on the channel ability.
All IDs must be different for one class.
Otherwise, it might be the case that one spell casts another spell instead.
The sheet does also contain a list of all hotkeys for all spells which must also be different from each other.

### Background Story <a name="content_background_story"></a>
The whole background information about the fantasy world of The Power of Fire is stored in the directory [Hintergrunddefinition](./doc/Planung/Hintergrunddefinition).
There is an unfinished German book called "The Master" which describes the story of Baradé and how he became part of the alliance of Demons, Orcs, Undead and Dark Elves.
It is stored in the file [Band 1 - Der Meister.odt](./doc/Planung/Hintergrunddefinition/Mythen/Bücher/Band%201%20-%20Der%20Meister.odt).
It describes some of the background story of this modification.

The basic story of this modification is that the Dark Elves and Orcs invade the kingdom of the Humans.
The Humans are allied to and controlled by the High Elves. Therefore, the king of the High Elves who is called Dararos, comes to help the Humans and to face his brother Baradé who is the leader of the Dark Elves.

Some characters of the background story are described in the following list:
* Deranor - King of the Undead.
* Gardonar - Lord of the Demons.
* Baradé - King of the Dark Elves and human brother of Dararos (their mother was a human).
* Dararos - King of the High Elves and elvish brother of Baradé (their father was a High Elf).

### Voices <a name="content_voices"></a>
The German voices of the NPCs have been recorded by people from the website [hoer-talk.de](http://www.hoer-talk.de/).
[This thread](http://www.hoer-talk.de/threads/rollenspiel-mod-sucht-sprecher.22379/) has been created for the search for German voice actors.

## Blog <a name="blog"></a>
Visit the [Blog](https://diemachtdesfeuers.wordpress.com/) on WordPress for more information.

## YouTube Channel <a name="youtube_channel"></a>
Visit the [YouTube Channel](https://www.youtube.com/channel/UCzGcsuPfRVqdaE87JYCK5zw) to watch videos about the modification.

## Bugs <a name="bugs"></a>
Report bugs as issues in this repository.
Many bugs are listed in German in the file [TODO](./TODO) but opening an issue in the repository is preferred.
Since there is no debugger for Warcraft III and multiplayer tests are not that easy to run, there might be still many undetected bugs in the modification and it is recommended to make as many different savegames as possible.

## Credits <a name="credits"></a>
This modification has been created by Tamino Dauth.
There is many other people which contributed to the modification.
They are listed in the file [Credits.j](./src/Game/Credits.j).
The core team has been:
* Oliver T. - 3D graphics.
* Andreas B. - Much of the terrain of the maps Talras and Holzbruck, testing, design.
* Johanna W. - Testing.

The resources which are not part of this repository like models and textures are mainly from websites like [HIVE](https://www.hiveworkshop.com/) and [Warcraft 3 Campaigns](http://www.wc3c.net/).
They have been created by many different people.
The Power of Fire
======================

"Die Macht des Feuers" (engl. The Power of Fire) is a cooperative RPG multiplayer modification for Warcraft III: The Frozen Throne.
All source code is under the GPLv3.

If cloning the repository takes too long, you can make a shallow clone or reduce the clone depth and not clone the whole history.
Since I have pushed the history of binary map and campaign files as well, the history became quite big.

The model, texture and sound resources are not part of this repository.

# Dependencies
You need the Advanced Script Library to use this code. The ASL is the core of this modification's code.

# Introduction

The Power of Fire (German "Die Macht des Feuers") is a modification of the realtime strategy game Warcraft III: The Frozen Throne. It alters the game to a roleplay game which can either be played in multiplayer or in a singleplayer campaign traveling between multiple maps.


Why should you create a map using The Power of Fire instead of creating your own map?
Here are a few good reasons:
* Finished Roleplaygame systems: You have a complete roleplaying game which is tested and should work.
* Many great resources ready to use: Many great realtexture models are already implemented as Doodads and can be used. Besides many better looking ground textures can be used, too.
* Existing Content: There's a huge amount of spells and reference content in the original modification.
* Contribute to an Open Source project: Everything is Open Source. Your contribution may become part of the modification and might get improved. The project can grow with more contributors like you.

# vJass

vJass is a scripting language based on Warcraft III's scripting language JASS. It adds new features like object oriented programming to the scripting language and is implemented by several compilers which translate the vJass code into JASS code.

The first and probably most popular compiler is the JassHelper. It has also been used for The Power of Fire.

By now other approaches with a better syntax exist like Wurst which has not been there when the project was started. It is highly unlikely that the modification will change its core scripting language since too much code is based on it. Besides it has been tested with a specific version of the JassHelper, so there would be a risk of losing functionality or even missing features in the new scripting language.

The size of the modification helped to find the limits of vJass and to make usage of nearly all features. I even wrote many posts on Wc3C.net to improve the language and to report bugs.

# MPQ

Warcraft III uses the format MPQ for custom data archives. Therefore The Power of Fire provides a custom file called "TPoF.mpq" with all required resources such as models, textures, icons and sound files.

This file has to be loaded in the game and in the World Editor.

# JassNewGenPack

# Creating a new Map

## Globals

Every map has to provide several globals which configure the map's systems:
Available boolean constants which have to be defined in a globals block:
* DMDF_CREDITS enables credits (GUI)
* DMDF_INFO_LOG enables talk log system (GUI)
* DMDF_NPC_ROUTINES enables NPC routines
* DMDF_VIOLENCE enables blood effects in fights

## MapData

Every map has to provide a struct called MapData with several methods and static constants which are used by the Game backend of the modification to run all required systems.

## Required Rects

Every map requires some specific rects for the systems of the modiciation:
TODO add them all

## Required Camera Setups

# Spawn Points

The Power of Fire allows you to respawn creeps and items on the map after being killd or picked up. This should improve the gameplay experience since after clearing a map returning to this map would be less interesting without any new creeps or items to collect.
Besides the player would get a disadvantage since he cannot level his character nor collect valuable stuff.

Usually the spawn points are created during the map initialization using existing units and items already placed on the map.

# Translation

To translate all maps as well as the campaign into different languages, one has to extract the war3map.wts files (before optimizing them out). After extracting the files, the entries have to be replaced by strings in another language. A copy of the unoptimized map must be created. Then the modified war3map.wts files have to be readded to the copies of the maps. If the maps are optimized afterwards (both, the one for the original language and the translated), they will differ and on online games won't be considered the same map only translated but the string entries will be optimized and the loading will become faster.

The campaign file has to be copied and uses the translated maps. Besides the information etc. has to be translated.

Besides the file for the user interface has to be replaced.

# Icons

The grimoire icons require an icon with every level from 0 to 6. There is an ability per level for the grimoire since changing the icon of an ability cannot be done dynamically. The script `Scripts/dmdf-all-grimoire-icons` creates all those icons using ImageMagick. Since ImageMagick cannot handle BLP files. The icons have to be converted into PNG or TGA files.

# Release

To update the translations always add English translations to the file "maps/Talras/war3map_en.wts".
To update all translations automatically use wc3trans from the wc3lib project. The script "src/Scripts/jenkins/dmdf_translation.sh" contains everything.

On Windows the project is expected in the directory "E:/Projekte/dmdf".
On Windows the release process consists of the following steps:
* Create the archive TPoF.mpq from the directory "archive".
* Create the executable TPoF.exe with MPQraft using this MPQ archive into the directory "E:/Warcraft III/"
* Export the latest object data from the map "maps/Karte 1 - Talras.w3x" and import it into all other maps (if they use custom Doodads, only import the other parts).
* Save ALL maps with the latest object data and code version. Use `src/Scripts/savemaps.bat` to save the maps automatically. Make sure that the script saves the maps without the "--debug" option for a release.
* Run the script `src/Scripts/makereleasemaps.bat`. This script creates all German release versions of the maps and prepares the English ones.
* Open the prepared English maps (for example in "maps/releases/Arena/Arena<version>.w3x") with an MPQ editor and replace the file war3map.wts in the archive by the file from the same directory.
* After having done this for ALL maps run the script "src/Scripts/makeenglishreleasemaps.bat" which creates the English optimized release maps.
* Open the German campaign "TPoF10de.w3n" and replace all chapters by the maps from "maps/releases" (for example "TL.w3x") and save it.
* Open the English campaign "TPoF10en.w3n" and replace all chapters by the maps from "maps/releases/en" (for example "TL.w3x") and save it.
* Call the NSIS script "src/Scripts/installer.nsi" to create the installer. It includes the development files.

Each map can be optimized using some standard routines. First of all the wc3lib can be used (wc3object) to drop all object data modifications which are not required anymore. This can happen when a hero ability is change to a unit ability but some hero only fields are still changed. This optimization reduces the number of strings which have to be translated or optimized later.

Besides all object data fields which are for the World Editor only can be optimized. These are usually editor only suffixes. The number of modifications (size of the object data) and string entries will be reduced by this which should improve the loading speed of the map.

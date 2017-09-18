/**
* \file "Systems/BonusMod/Creation Bonus Mod.j" Contains all object editor ability creations for Bonus Mod. Should be imported manually into map (just one-time). Consider not to use ability ids starting at AZZ0 if you're using the Bonus Mod.
*/

//! textmacro A_BONUS_MOD_DAMAGE takes RAWCODE, NAME, VALUE
	//! external ObjectMerger w3a AItg $RAWCODE$ Iatt 1 $VALUE$ anam "$NAME$" ansf "ASL" aart ""
//! endtextmacro

//! textmacro A_BONUS_MOD_ARMOR takes RAWCODE, NAME, VALUE
	//! external ObjectMerger w3a AId1 $RAWCODE$ Idef 1 $VALUE$ anam "$NAME$" ansf "ASL" aart ""
//! endtextmacro

//! textmacro A_BONUS_MOD_LIFE takes RAWCODE, NAME, VALUE
	//! external ObjectMerger w3a AIl2 $RAWCODE$ Ilif 1 $VALUE$ anam "$NAME$" ansf "ASL" aart ""
//! endtextmacro

//! textmacro A_BONUS_MOD_MANA takes RAWCODE, NAME, VALUE
	//! external ObjectMerger w3a AImb $RAWCODE$ Iman 1 $VALUE$ anam "$NAME$" ansf "ASL" aart ""
//! endtextmacro

//! textmacro A_BONUS_MOD_SIGHT_RANGE takes RAWCODE, NAME, VALUE
	//! external ObjectMerger w3a AIsi $RAWCODE$ Isib 1 $VALUE$ anam "$NAME$" ansf "ASL" aart ""
//! endtextmacro

//! textmacro A_BONUS_MOD_LIFE_REGENERATION takes RAWCODE, NAME, VALUE
	//! external ObjectMerger w3a Arel $RAWCODE$ Ihpr 1 $VALUE$ anam "$NAME$" ansf "ASL" aart ""
//! endtextmacro

//! textmacro A_BONUS_MOD_MANA_REGENERATION takes RAWCODE, NAME, VALUE
	//! external ObjectMerger w3a AIrm $RAWCODE$ Imrp 1 $VALUE$ anam "$NAME$" ansf "ASL" aart ""
//! endtextmacro

// A1
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ0", "Damage +1", "1")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ1", "Damage +2", "2")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ2", "Damage +4", "4")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ3", "Damage +8", "8")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ4", "Damage +16", "16")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ5", "Damage +32", "32")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ6", "Damage +64", "64")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ7", "Damage +128", "128")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ8", "Damage +256", "256")
//! runtextmacro A_BONUS_MOD_DAMAGE("AZZ9", "Damage -512", "-512")

//! runtextmacro A_BONUS_MOD_ARMOR("AZY0", "Armor +1", "1")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY1", "Armor +2", "2")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY2", "Armor +4", "4")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY3", "Armor +8", "8")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY4", "Armor +16", "16")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY5", "Armor +32", "32")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY6", "Armor +64", "64")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY7", "Armor +128", "128")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY8", "Armor +256", "256")
//! runtextmacro A_BONUS_MOD_ARMOR("AZY9", "Armor -512", "-512")

//! runtextmacro A_BONUS_MOD_LIFE("AZX0", "Life +10", "10")
//! runtextmacro A_BONUS_MOD_LIFE("AZX1", "Life +20", "20")
//! runtextmacro A_BONUS_MOD_LIFE("AZX2", "Life +40", "40")
//! runtextmacro A_BONUS_MOD_LIFE("AZX3", "Life +80", "80")
//! runtextmacro A_BONUS_MOD_LIFE("AZX4", "Life +160", "160")
//! runtextmacro A_BONUS_MOD_LIFE("AZX5", "Life +320", "320")
//! runtextmacro A_BONUS_MOD_LIFE("AZX6", "Life +640", "640")
//! runtextmacro A_BONUS_MOD_LIFE("AZX7", "Life +1280", "1280")
//! runtextmacro A_BONUS_MOD_LIFE("AZX8", "Life +2560", "2560")
//! runtextmacro A_BONUS_MOD_LIFE("AZX9", "Life -5120", "-5120")

//! runtextmacro A_BONUS_MOD_MANA("AZW0", "Mana +10", "10")
//! runtextmacro A_BONUS_MOD_MANA("AZW1", "Mana +20", "20")
//! runtextmacro A_BONUS_MOD_MANA("AZW2", "Mana +40", "40")
//! runtextmacro A_BONUS_MOD_MANA("AZW3", "Mana +80", "80")
//! runtextmacro A_BONUS_MOD_MANA("AZW4", "Mana +160", "160")
//! runtextmacro A_BONUS_MOD_MANA("AZW5", "Mana +320", "320")
//! runtextmacro A_BONUS_MOD_MANA("AZW6", "Mana +640", "640")
//! runtextmacro A_BONUS_MOD_MANA("AZW7", "Mana +1280", "1280")
//! runtextmacro A_BONUS_MOD_MANA("AZW8", "Mana +2560", "2560")
//! runtextmacro A_BONUS_MOD_MANA("AZW9", "Mana -5120", "-5120")

//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV0", "Sight range +10", "10")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV1", "Sight range +20", "20")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV2", "Sight range +40", "40")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV3", "Sight range +80", "80")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV4", "Sight range +160", "160")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV5", "Sight range +320", "320")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV6", "Sight range +640", "640")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV7", "Sight range +1280", "1280")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV8", "Sight range +2560", "2560")
//! runtextmacro A_BONUS_MOD_SIGHT_RANGE("AZV9", "Sight range -5120", "-5120")

//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU0", "Life regeneration +1", "1")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU1", "Life regeneration +2", "2")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU2", "Life regeneration +4", "4")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU3", "Life regeneration +8", "8")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU4", "Life regeneration +16", "16")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU5", "Life regeneration +32", "32")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU6", "Life regeneration +64", "64")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU7", "Life regeneration +128", "128")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU8", "Life regeneration +256", "256")
//! runtextmacro A_BONUS_MOD_LIFE_REGENERATION("AZU9", "Life regeneration -512", "-512")

//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT0", "Mana regeneration +1", "1")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT1", "Mana regeneration +2", "2")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT2", "Mana regeneration +4", "4")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT3", "Mana regeneration +8", "8")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT4", "Mana regeneration +16", "16")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT5", "Mana regeneration +32", "32")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT6", "Mana regeneration +64", "64")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT7", "Mana regeneration +128", "128")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT8", "Mana regeneration +256", "256")
//! runtextmacro A_BONUS_MOD_MANA_REGENERATION("AZT9", "Mana regeneration -512", "-512")
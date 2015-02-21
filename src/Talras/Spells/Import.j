//! import "Talras/Spells/Struct Spell Amulet Of Foresight.j"
//! import "Talras/Spells/Struct Spell Aos Ring.j"
//! import "Talras/Spells/Struct Spell Magical Seed.j"
//! import "Talras/Spells/Struct Spell Scroll Of The Realm Of The Dead.j"
//! import "Talras/Spells/Struct Spell Unearth.j"

library MapSpells requires StructGameClasses, StructMapSpellsSpellAmuletOfForesight, StructMapSpellsSpellAosRing, StructMapSpellsSpellMagicalSeed, StructMapSpellsSpellScrollOfTheRealmOfTheDead, StructMapSpellsSpellUnearth

	/// Init non-character spells!
	function initMapSpells takes nothing returns nothing
		// add all ditch spider-like unit type ids and all dich spider-like units here
		call SpellUnearth.init()
		call SpellUnearth.addUnitTypeId('n01E')
		call SpellUnearth.addUnit(gg_unit_n01E_0075)
		call SpellUnearth.addUnit(gg_unit_n01E_0070)
		call SpellUnearth.addUnit(gg_unit_n01E_0074)
	endfunction

	function initMapCharacterSpells takes Character character returns nothing
		call SpellAmuletOfForesight.create(character)
		/// \todo Filter class for Baldars ring
		// Baldar's and Haldar's rings
		if (character.class() == Classes.astralModifier()) then
			call SpellAosRing.create(character, 'A04V', true) // Astral Modifier
			call SpellAosRing.create(character, 'A0BR', false) // Astral Modifier
		elseif (character.class() == Classes.dragonSlayer()) then
			call SpellAosRing.create(character, 'A0BL', true) // Dragon Slayer
			call SpellAosRing.create(character, 'A0BW', false) // Dragon Slayer
		elseif (character.class() == Classes.druid()) then
			call SpellAosRing.create(character, 'A0BJ', true) // Druid
			call SpellAosRing.create(character, 'A0BU', false) // Druid
		elseif (character.class() == Classes.elementalMage()) then
			call SpellAosRing.create(character, 'A0BN', true) // Elemental Mage
			call SpellAosRing.create(character, 'A0BY', false) // Elemental Mage
		elseif (character.class() == Classes.illusionist()) then
			call SpellAosRing.create(character, 'A0BO', true) // Illusionist
			call SpellAosRing.create(character, 'A0BZ', false) // Illusionist
		elseif (character.class() == Classes.cleric()) then
			call SpellAosRing.create(character, 'A0BH', true) // Cleric
			call SpellAosRing.create(character, 'A0BS', false) // Cleric
		elseif (character.class() == Classes.necromancer()) then
			call SpellAosRing.create(character, 'A0BI', true) // Necromancer
			call SpellAosRing.create(character, 'A0BT', false) // Necromancer
		elseif (character.class() == Classes.knight()) then
			call SpellAosRing.create(character, 'A0BK', true) // Knight
			call SpellAosRing.create(character, 'A0BV', false) // Knight
		elseif (character.class() == Classes.ranger()) then
			call SpellAosRing.create(character, 'A0BM', true) // Ranger
			call SpellAosRing.create(character, 'A0BX', false) // Ranger
		elseif (character.class() == Classes.wizard()) then
			call SpellAosRing.create(character, 'A0BP', true) // Wizard
			call SpellAosRing.create(character, 'A0C0', false) // Wizard
		endif

		call SpellMagicalSeed.create(character)
		call SpellScrollOfTheRealmOfTheDead.create(character)
	endfunction

endlibrary
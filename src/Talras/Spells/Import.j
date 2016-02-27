//! import "Talras/Spells/Struct Spell Aos Ring.j"
//! import "Talras/Spells/Struct Spell Magical Seed.j"
//! import "Talras/Spells/Struct Spell Missions.j"
//! import "Talras/Spells/Struct Spell Open Gate.j"

library MapSpells requires StructGameClasses, StructMapSpellsSpellAosRing, StructMapSpellsSpellMagicalSeed, StructMapSpellsSpellMissions, StructMapSpellsSpellOpenGate

	/**
	 * Init non-character spells.
	 * These non-charcter spells can only be used in the current map.
	 * Non-character spells for all maps should be initialized in \ref initSpells() instead.
	 */
	function initMapSpells takes nothing returns nothing
		call SpellUnearth.addUnit(gg_unit_n01E_0075)
		call SpellUnearth.addUnit(gg_unit_n01E_0070)
		call SpellUnearth.addUnit(gg_unit_n01E_0074)
	endfunction

	/**
	 * This function initializes map specific character spells for \p character.
	 * These spells can only be used in the current map.
	 * Character spells for all maps should be initialized in \ref initCharacterSpells() instead.
	 */
	function initMapCharacterSpells takes Character character returns nothing
		// Baldar's and Haldar's rings
		if (character.class() == Classes.dragonSlayer()) then
			call SpellAosRing.create(character, 'A146', 'A13Y', 'A0BL', true) // Dragon Slayer
			call SpellAosRing.create(character, 'A14M', 'A14E', 'A0BW', false) // Dragon Slayer
		elseif (character.class() == Classes.druid()) then
			call SpellAosRing.create(character, 'A14D', 'A13Z', 'A0BJ', true) // Druid
			call SpellAosRing.create(character, 'A14O', 'A14F', 'A0BU', false) // Druid
		elseif (character.class() == Classes.elementalMage()) then
			call SpellAosRing.create(character, 'A14C', 'A140', 'A0BN', true) // Elemental Mage
			call SpellAosRing.create(character, 'A14T', 'A14G', 'A0BY', false) // Elemental Mage
		elseif (character.class() == Classes.cleric()) then
			call SpellAosRing.create(character, 'A148', 'A141', 'A0BH', true) // Cleric
			call SpellAosRing.create(character, 'A14N', 'A14H', 'A0BS', false) // Cleric
		elseif (character.class() == Classes.necromancer()) then
			call SpellAosRing.create(character, 'A149', 'A142', 'A0BI', true) // Necromancer
			call SpellAosRing.create(character, 'A14P', 'A14I', 'A0BT', false) // Necromancer
		elseif (character.class() == Classes.knight()) then
			call SpellAosRing.create(character, 'A147', 'A143', 'A0BK', true) // Knight
			call SpellAosRing.create(character, 'A14Q', 'A14J', 'A0BV', false) // Knight
		elseif (character.class() == Classes.ranger()) then
			call SpellAosRing.create(character, 'A14A', 'A144', 'A0BM', true) // Ranger
			call SpellAosRing.create(character, 'A14R', 'A14K', 'A14K', false) // Ranger
		elseif (character.class() == Classes.wizard()) then
			call SpellAosRing.create(character, 'A14B', 'A145', 'A0BP', true) // Wizard
			call SpellAosRing.create(character, 'A14S', 'A14L', 'A14L', false) // Wizard
		endif
	
		call SpellMagicalSeed.create(character)
		call SpellMissionTalras.create(character)
		call SpellMissionTheNorsemen.create(character)
		call SpellMissionSlaughter.create(character)
		call SpellMissionWar.create(character)
		call SpellMissionANewAlliance.create(character)
		call SpellMissionTheDefenseOfTalras.create(character)
		call SpellMissionTheWayToHolzbruck.create(character)
	endfunction

endlibrary
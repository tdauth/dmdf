//! import "Talras/Spells/Struct Spell Amulet Of Foresight.j"
//! import "Talras/Spells/Struct Spell Aos Ring.j"
//! import "Talras/Spells/Struct Spell Book Of Magic.j"
//! import "Talras/Spells/Struct Spell Book Of Potions.j"
//! import "Talras/Spells/Struct Spell Book Of Smith Craft.j"
//! import "Talras/Spells/Struct Spell Magical Seed.j"
//! import "Talras/Spells/Struct Spell Missions.j"
//! import "Talras/Spells/Struct Spell Neck Stone.j"
//! import "Talras/Spells/Struct Spell Open Gate.j"
//! import "Talras/Spells/Struct Spell Ride Sheep.j"
//! import "Talras/Spells/Struct Spell Scroll Of Ancestors.j"
//! import "Talras/Spells/Struct Spell Scroll Of Collector.j"
//! import "Talras/Spells/Struct Spell Scroll Of The Realm Of The Dead.j"
//! import "Talras/Spells/Struct Spell Unearth.j"
//! import "Talras/Spells/Struct Spell Wings Of Deranors Guard.j"

library MapSpells requires StructGameClasses, StructMapSpellsSpellAmuletOfForesight, StructMapSpellsSpellAosRing, StructMapSpellsSpellBookOfMagic, StructMapSpellsSpellBookOfPotions, StructMapSpellsSpellBookOfSmithCraft, StructMapSpellsSpellMagicalSeed, StructMapSpellsSpellMissions, StructMapSpellsSpellNeckStone, StructMapSpellsSpellOpenGate, StructMapSpellsSpellRideSheep, StructMapSpellsSpellScrollOfAncestors, StructMapSpellsSpellScrollOfCollector, StructMapSpellsSpellScrollOfTheRealmOfTheDead, StructMapSpellsSpellUnearth, StructMapSpellsSpellWingsOfDeranorsGuard

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
		if (character.class() == Classes.dragonSlayer()) then
			call SpellAosRing.create(character, 'A146', 'A13Y', 'A0BL', true) // Dragon Slayer
			call SpellAosRing.create(character, 'A14M', 'A14E', 'A0BW', false) // Dragon Slayer
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A15S', 'A15T')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AM', 'A1AT')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1EN', 'A1EV')
		elseif (character.class() == Classes.druid()) then
			call SpellAosRing.create(character, 'A14D', 'A13Z', 'A0BJ', true) // Druid
			call SpellAosRing.create(character, 'A14O', 'A14F', 'A0BU', false) // Druid
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A16Z', 'A176')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AL', 'A1AS')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1EU', 'A1F2')
		elseif (character.class() == Classes.elementalMage()) then
			call SpellAosRing.create(character, 'A14C', 'A140', 'A0BN', true) // Elemental Mage
			call SpellAosRing.create(character, 'A14T', 'A14G', 'A0BY', false) // Elemental Mage
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A172', 'A179')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AP', 'A1AW')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1EQ', 'A1EY')
		elseif (character.class() == Classes.cleric()) then
			call SpellAosRing.create(character, 'A148', 'A141', 'A0BH', true) // Cleric
			call SpellAosRing.create(character, 'A14N', 'A14H', 'A0BS', false) // Cleric
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A16X', 'A174')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AI', 'A1AJ')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1ES', 'A1F0')
		elseif (character.class() == Classes.necromancer()) then
			call SpellAosRing.create(character, 'A149', 'A142', 'A0BI', true) // Necromancer
			call SpellAosRing.create(character, 'A14P', 'A14I', 'A0BT', false) // Necromancer
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A16Y', 'A175')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AK', 'A1AR')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1ET', 'A1F1')
		elseif (character.class() == Classes.knight()) then
			call SpellAosRing.create(character, 'A147', 'A143', 'A0BK', true) // Knight
			call SpellAosRing.create(character, 'A14Q', 'A14J', 'A0BV', false) // Knight
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A170', 'A177')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AN', 'A1AU')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1EO', 'A1EW')
		elseif (character.class() == Classes.ranger()) then
			call SpellAosRing.create(character, 'A14A', 'A144', 'A0BM', true) // Ranger
			call SpellAosRing.create(character, 'A14R', 'A14K', 'A14K', false) // Ranger
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A171', 'A178')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AO', 'A1AV')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1EP', 'A1EX')
		elseif (character.class() == Classes.wizard()) then
			call SpellAosRing.create(character, 'A14B', 'A145', 'A0BP', true) // Wizard
			call SpellAosRing.create(character, 'A14S', 'A14L', 'A14L', false) // Wizard
			// ride a sheep
			call SpellRideSheep.create(character, 'A15R', 'A173', 'A17A')
			// neck stone
			call SpellNeckStone.create(character, 'A1AH', 'A1AQ', 'A1AX')
			// wings of deranors guard
			call SpellWingsOfDeranorsGuard.create(character, 'A1EM', 'A1ER', 'A1EZ')
		endif

		call SpellBookOfMagicScrollOfHex.create(character)
		call SpellBookOfMagicScrollOfNecromancy.create(character)
		call SpellBookOfMagicScrollOfHealing.create(character)
		call SpellBookOfMagicScrollOfMana.create(character)
		call SpellBookOfMagicScrollOfAncestors.create(character)
		call SpellBookOfMagicScrollOfCollector.create(character)
		call SpellBookOfMagicScrollOfWay.create(character)
		call SpellBookOfPotionsHealPotion.create(character)
		call SpellBookOfPotionsManaPotion.create(character)
		call SpellBookOfPotionsPoison.create(character)
		call SpellBookOfPotionsBigHealPotion.create(character)
		call SpellBookOfPotionsBigManaPotion.create(character)
		call SpellBookOfSmithCraftIron.create(character)
		call SpellBookOfSmithCraftShortSword.create(character)
		call SpellBookOfSmithCraftLongSword.create(character)
		call SpellMagicalSeed.create(character)
		call SpellMissionTalras.create(character)
		call SpellMissionTheNorsemen.create(character)
		call SpellMissionSlaughter.create(character)
		call SpellMissionWar.create(character)
		call SpellMissionANewAlliance.create(character)
		call SpellMissionTheDefenseOfTalras.create(character)
		call SpellMissionTheWayToHolzbruck.create(character)
		call SpellScrollOfAncestors.create(character)
		call SpellScrollOfCollector.create(character)
		call SpellScrollOfTheRealmOfTheDead.create(character)
	endfunction

endlibrary
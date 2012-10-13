//! import "Talras/Spells/Struct Spell Amulet Of Foresight.j"
//! import "Talras/Spells/Struct Spell Amulet Of Terror.j"
//! import "Talras/Spells/Struct Spell Aos Ring.j"
//! import "Talras/Spells/Struct Spell Scroll Of The Realm Of The Dead.j"
//! import "Talras/Spells/Struct Spell Unearth.j"

library MapSpells requires StructMapSpellsSpellAmuletOfForesight, StructMapSpellsSpellAmuletOfTerror, StructMapSpellsSpellAosRing, StructMapSpellsSpellScrollOfTheRealmOfTheDead, StructMapSpellsSpellUnearth

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
		call SpellAmuletOfTerror.create(character)
		/// \todo Filter class for Baldars ring
		call SpellAosRing.create(character, 'A04V', true) // Astral Modifier
		call SpellScrollOfTheRealmOfTheDead.create(character)
	endfunction

endlibrary
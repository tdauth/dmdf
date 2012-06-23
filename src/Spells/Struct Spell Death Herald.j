/// Necromancer
library StructSpellsSpellDeathHerald requires Asl, StructGameClasses, StructGameSpell

	/**
	* Grundfähigkeit: Todesbote - Passiv. Der Nekromant beschwört alle X Sekunden den Kadaver eines Zombies. Es können maximal Y beschworene Kadaver transportiert werden.
	*/
	struct SpellDeathHerald extends Spell
		public static constant integer abilityId = 'A08K'
		public static constant integer favouriteAbilityId = 'A08G'
		public static constant integer maxLevel = 1

		public stub method onLearn takes nothing returns nothing
			debug call Print("Before learning ability with unit " + GetUnitName(this.character().unit()))
			call UnitAddAbility(this.character().unit(), 'S004')
			debug call Print("After learning ability with unit " + GetUnitName(this.character().unit()))
		endmethod

		public stub method onUnlearn takes nothing returns nothing
			call UnitRemoveAbility(this.character().unit(), 'S004')
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.necromancer(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary
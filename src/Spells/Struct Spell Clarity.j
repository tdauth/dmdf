/// Cleric
library StructSpellsSpellClarity requires Asl, StructGameClasses, StructGameSpell

	/**
	* Der Kleriker befreit sich selbst von einem negativen Effekt.
	*/
	struct SpellClarity extends Spell
		public static constant integer abilityId = 'A052'
		public static constant integer favouriteAbilityId = 'A053'
		public static constant integer maxLevel = 5

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AIntegerVector negativeBuffs = AIntegerVector.create()
			local integer index
			/// @todo Add all negative buffs of game -.-
			//if (GetUnitAbilityLevel(caster, '') > 0) then
			//	call negativeBuffs.pushBack('')
			//endif
			if (not negativeBuffs.empty()) then
				set index = GetRandomInt(0, negativeBuffs.backIndex())
				call UnitRemoveAbility(caster, negativeBuffs[index])
				debug call Print("Removed buff " + GetObjectName(negativeBuffs[index]))
			endif
			call negativeBuffs.destroy()
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary
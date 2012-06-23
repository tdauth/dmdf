/// Metamorphosis
library StructSpellsSpellMetamorphosis requires Asl, StructGameSpell

	/**
	 * \brief Generic abstract spell for metamorphosis.
	 */
	struct SpellMetamorphosis extends Spell
		private integer m_unitTypeId
		private real m_castTime
		
		public method setUnitTypeId takes integer unitTypeId returns nothing
			set this.m_unitTypeId = unitTypeId
		endmethod
		
		public method unitTypeId takes nothing returns integer
			return this.m_unitTypeId
		endmethod
		
		public method setCastTime takes real castTime returns nothing
			set this.m_castTime = castTime
		endmethod
		
		public method castTime takes nothing returns real
			return this.m_castTime
		endmethod
		
		/// Called after unit has morphed.
		public stub method onMorph takes nothing returns nothing
		endmethod
		
		/// Called after unit has been restored.
		public stub method onRestore takes nothing returns nothing
		endmethod
		
		public stub method onCastAction takes nothing returns nothing
			debug call Print("Morph: Before on cast.")
			call super.onCastAction()
			debug call Print("Morph: After on cast.")
			// morph
			if (GetUnitTypeId(this.character().unit()) == this.unitTypeId()) then
				debug call Print("Morph with spell: " + GetAbilityName(this.ability()))
				call Character(this.character()).morph(this.ability())
				call TriggerSleepAction(this.castTime()) // wait for metamorphosis
				call this.onMorph.execute()
			// restore
			else
				debug call Print("Restore from morph with spell: "  + GetAbilityName(this.ability()))
				call TriggerSleepAction(this.castTime()) // wait for finishing metamorphosis, at least 0 seconds before restoration!!!
				call Character(this.character()).restoreUnit()
				call this.onRestore.execute()
			endif
		endmethod

		
		public static method create takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction  returns thistype
			local thistype this = thistype.allocate(character, class, spellType, maxLevel, abilityId, favouriteAbility, upgradeAction, castCondition, castAction)
			set this.m_unitTypeId = 0
			set this.m_castTime = 0.0

			return this
		endmethod
	endstruct

endlibrary
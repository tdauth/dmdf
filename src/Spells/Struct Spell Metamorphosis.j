/// Metamorphosis
library StructSpellsSpellMetamorphosis requires Asl, StructGameSpell

	/**
	 * \brief Generic abstract spell for metamorphosis.
	 * 
	 * Uses \ref EVENT_UNIT_SPELL_CAST to be executed before the unit is morphed to successfully store the inventory items.
	 * 
	 * \note All morph spells need a short delay in which \ref Character#morph() can be called which stores spells and items safely! Pass the delay with \ref setCastTime().
	 */
	struct SpellMetamorphosis extends Spell
		private integer m_unitTypeId
		private trigger m_channelTrigger
		private trigger m_endCastTrigger
		private boolean m_isMorphed
		
		public method setUnitTypeId takes integer unitTypeId returns nothing
			set this.m_unitTypeId = unitTypeId
		endmethod
		
		public method unitTypeId takes nothing returns integer
			return this.m_unitTypeId
		endmethod
		
		public method isMorphed takes nothing returns boolean
			return this.m_isMorphed
		endmethod
		
		/// Called after unit has morphed.
		public stub method onMorph takes nothing returns nothing
		endmethod
		
		/// Called after unit has been restored.
		public stub method onRestore takes nothing returns nothing
		endmethod
		
		private static method triggerCondition takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetSpellAbilityId() == this.ability()
		endmethod
		
		private static method triggerActionChannel takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			// morph
			if (not this.isMorphed()) then
				debug call Print("Morph with spell: " + GetAbilityName(this.ability()))
				call Character(this.character()).morph(this.ability())
				set this.m_isMorphed = true
				call this.onMorph.execute()
			debug else
				debug call Print("Error: Unit is already morphed.")
			endif
		endmethod
		
		private static method triggerActionEndCast takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			debug call Print("Morph: Before on cast.")
			call super.onCastAction()
			debug call Print("Morph: After on cast.")
			// restore
			if (this.isMorphed()) then
				debug call Print("Restore from morph with spell: "  + GetAbilityName(this.ability()))
				call Character(this.character()).restoreUnit()
				set this.m_isMorphed = false
				call this.onRestore.execute()
			debug else
				debug call Print("Error: Unit is still morphed.")
			endif
		endmethod

		
		public static method create takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction  returns thistype
			local thistype this = thistype.allocate(character, class, spellType, maxLevel, abilityId, favouriteAbility, upgradeAction, castCondition, castAction)
			set this.m_unitTypeId = 0
			set this.m_channelTrigger = CreateTrigger()
			// register action before cast has finished!
			call TriggerRegisterUnitEvent(this.m_channelTrigger, this.character().unit(), EVENT_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerCondition))
			call TriggerAddAction(this.m_channelTrigger, function thistype.triggerActionChannel)
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, "this", this)

			call TriggerRegisterUnitEvent(this.m_endCastTrigger, this.character().unit(), EVENT_UNIT_SPELL_FINISH)
			call TriggerAddCondition(this.m_endCastTrigger, Condition(function thistype.triggerCondition))
			call TriggerAddAction(this.m_endCastTrigger, function thistype.triggerActionEndCast)
			call AHashTable.global().setHandleInteger(this.m_endCastTrigger, "this", this)
			
			return this
		endmethod
	endstruct

endlibrary
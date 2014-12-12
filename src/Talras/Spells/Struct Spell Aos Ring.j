/// Item
library StructMapSpellsSpellAosRing requires Asl, StructGameClasses, StructMapMapAos, StructSpellsSpellMetamorphosis

	/**
	 * Used for rings of Haldar and Baldar. There should be an two instances per class for the two brothers in \ref initMapCharacterSpells().
	 */
	struct SpellAosRing extends ASpell
		private boolean m_baldar
		private trigger m_channelTrigger
		
		/**
		 * Returns the morphed unit type id depending on the character's class.
		 */
		public method getUnitTypeIdHaldar takes nothing returns integer
			if (this.character().class() == Classes.cleric()) then
				return 'H00V'
			elseif (this.character().class() == Classes.necromancer()) then
				return 'H00W'
			elseif (this.character().class() == Classes.druid()) then
				return 'H00X'
			elseif (this.character().class() == Classes.knight()) then
				return 'H00Y'
			elseif (this.character().class() == Classes.dragonSlayer()) then
				return 'H00Z'
			elseif (this.character().class() == Classes.ranger()) then
				return 'H010'
			elseif (this.character().class() == Classes.elementalMage()) then
				return 'H011'
			elseif (this.character().class() == Classes.astralModifier()) then
				return 'H00U'
			elseif (this.character().class() == Classes.illusionist()) then
				return 'H013'
			elseif (this.character().class() == Classes.wizard()) then
				return 'H012'
			endif
			
			return 0
		endmethod
		
		/**
		 * Returns the morphed unit type id depending on the character's class.
		 */
		public method getUnitTypeIdBaldar takes nothing returns integer
			if (this.character().class() == Classes.cleric()) then
				return 'H00L'
			elseif (this.character().class() == Classes.necromancer()) then
				return 'H00M'
			elseif (this.character().class() == Classes.druid()) then
				return 'H00N'
			elseif (this.character().class() == Classes.knight()) then
				return 'H00O'
			elseif (this.character().class() == Classes.dragonSlayer()) then
				return 'H00P'
			elseif (this.character().class() == Classes.ranger()) then
				return 'H00Q'
			elseif (this.character().class() == Classes.elementalMage()) then
				return 'H00R'
			elseif (this.character().class() == Classes.astralModifier()) then
				return 'H00C'
			elseif (this.character().class() == Classes.illusionist()) then
				return 'H00S'
			elseif (this.character().class() == Classes.wizard()) then
				return 'H00T'
			endif
			
			return 0
		endmethod

		private static method triggerConditionStart takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			debug call Print("Condition Start!")
			return GetSpellAbilityId() == this.ability()
		endmethod
		
		private static method triggerActionStart takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local unit caster = this.character().unit()
			debug call Print("CAST ACTION")
			if (not Aos.areaContainsCharacter(this.character())) then
				debug call Print("Area does not contain character!")
				call IssueImmediateOrder(caster, "stop")
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie müssen sich in der Trommelhöhle befinden, um diesen Zauber wirken zu können."))
				set caster = null
				return
			endif
			if (this.m_baldar) then
				// shouldn't happen
				if (Aos.haldarContainsCharacter(this.character())) then
					debug call Print("Character is already in Haldar's group -> something is going wrongly.")
					call IssueImmediateOrder(caster, "stop")
					call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie befinden sich bereits in Haldars Gruppe."))
					set caster = null
					return
				endif
				if (Aos.baldarContainsCharacter(this.character())) then
					debug call Print("Leaves Baldar with ability id: " + I2S(this.ability()))
					call Aos.characterLeavesBaldar(this.character())
					call SpellMetamorphosis.waitForRestoration(this.character().unit(), this.getUnitTypeIdBaldar())
					call Character(this.character()).restoreUnit()
				else
					debug call Print("Joins Baldar with character " + I2S(this.character()) + " and ability id: " + I2S(this.ability()))
					call IssueImmediateOrder(caster, "stop")
					call Character(this.character()).morph(this.ability()) // removes item with ability
					call UnitAddAbility(this.character().unit(), this.ability())
					call DisableTrigger(GetTriggeringTrigger())
					debug call Print("1")
					call IssueImmediateOrder(this.character().unit(), "metamorphosis")
					debug call Print("2")
					call SpellMetamorphosis.waitForMorph(this.character().unit(), this.getUnitTypeIdBaldar())
					debug call Print("3")
					call EnableTrigger(GetTriggeringTrigger())
					debug call Print("4")
					call Aos.characterJoinsBaldar(this.character())
					debug call Print("5")
				endif
			else
				// shouldn't happen
				if (Aos.baldarContainsCharacter(this.character())) then
					debug call Print("Character is already in Baldar's group -> something is going wrongly.")
					call IssueImmediateOrder(caster, "stop")
					call this.character().displayMessage(ACharacter.messageTypeError, tr("Sie befinden sich bereits in Baldars Gruppe."))
					set caster = null
					return
				endif
				if (Aos.haldarContainsCharacter(this.character())) then
					debug call Print("Leaves Haldar.")
					call Aos.characterLeavesHaldar(this.character())
					call SpellMetamorphosis.waitForRestoration(this.character().unit(), this.getUnitTypeIdHaldar())
					call Character(this.character()).restoreUnit()
				else
					debug call Print("Joins Haldar with character " + I2S(this.character()) + " and ability id: " + I2S(this.ability()))
					call IssueImmediateOrder(caster, "stop")
					call Character(this.character()).morph(this.ability()) // removes item with ability
					call UnitAddAbility(this.character().unit(), this.ability())
					call DisableTrigger(GetTriggeringTrigger())
					call IssueImmediateOrder(this.character().unit(), "metamorphosis")
					call SpellMetamorphosis.waitForMorph(this.character().unit(), this.getUnitTypeIdBaldar())
					call EnableTrigger(GetTriggeringTrigger())
					call Aos.characterJoinsHaldar(this.character())
				endif
			endif
			set caster = null
		endmethod

		public static method create takes Character character, integer abilityId, boolean baldar returns thistype
			local thistype this = thistype.allocate(character, abilityId, 0, 0, 0)
			set this.m_baldar = baldar
			
			set this.m_channelTrigger = CreateTrigger()
			// register action before cast has finished!
			call TriggerRegisterUnitEvent(this.m_channelTrigger, this.character().unit(), EVENT_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerConditionStart))
			call TriggerAddAction(this.m_channelTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, "this", this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_channelTrigger)
			set this.m_channelTrigger = null
		endmethod
	endstruct

endlibrary
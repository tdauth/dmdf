/// Metamorphosis
library StructSpellsSpellMetamorphosis requires Asl, StructGameCharacter, StructGameGrimoire

	/**
	 * \brief Generic abstract spell for metamorphosis which allows specific behaviour on transformation and reset to the original unit.
	 * 
	 * Uses \ref EVENT_PLAYER_UNIT_SPELL_CHANNEL to be executed before the unit is morphed to successfully store the inventory items.
	 * 
	 * Besides it uses \ref EVENT_UNIT_HERO_REVIVE_FINISH to unmorph the character when being revived unmorphed.
	 * 
	 * \note All morph spells need a short delay in which \ref Character#morph() can be called which stores spells and items safely!
	 * 
	 * \todo Check out http://www.hiveworkshop.com/forums/general-mapping-tutorials-278/hero-passive-transformation-198482/ which might be a safer method.
	 */
	struct SpellMetamorphosis
		private Character m_character
		private integer m_abilityId
		private integer m_morphAbilityId
		private integer m_unmorphAbilityId
		private boolean m_disableGrimoire
		private boolean m_disableInventory
		private trigger m_channelTrigger
		private trigger m_revivalTrigger
		private boolean m_isMorphed
		
		public method character takes nothing returns Character
			return this.m_character
		endmethod
		
		/**
		 * \return Returns the ability which casts the unit transformation.
		 */
		public method abilityId takes nothing returns integer
			return this.m_abilityId
		endmethod
		
		public method morphAbilityId takes nothing returns integer
			return this.m_morphAbilityId
		endmethod
		
		public method unmorphAbilityId takes nothing returns integer
			return this.m_unmorphAbilityId
		endmethod
		
		public method setDisableGrimoire takes boolean disable returns nothing
			set this.m_disableGrimoire = disable
		endmethod
		
		public method disableGrimoire takes nothing returns boolean
			return this.m_disableGrimoire
		endmethod
		
		public method setDisableInventory takes boolean disable returns nothing
			set this.m_disableInventory = disable
		endmethod
		
		public method disableInventory takes nothing returns boolean
			return this.m_disableInventory
		endmethod

		/**
		 * \return Returns true if the unit is morphed with this specific spell.
		 */
		public method isMorphed takes nothing returns boolean
			return this.m_isMorphed
		endmethod
		
		/*
		 * Overwrite this method to allow the unit to morph only on specific conditions.
		 * If it returns false the unit is stopped immediately when casting the morph ability.
		 * Called with .evaluate()
		 */
		public stub method canMorph takes nothing returns boolean
			return true
		endmethod
		
		/// Called after unit has morphed with .evaluate().
		public stub method onMorph takes nothing returns nothing
		endmethod
		
		// Called with .evaluate()
		public stub method canRestore takes nothing returns boolean
			return true
		endmethod
		
		/// Called after unit has been restored with .evaluate().
		public stub method onRestore takes nothing returns nothing
		endmethod
		
		private static method triggerConditionStart takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local boolean result = GetTriggerUnit() == this.character().unit() and GetSpellAbilityId() != null and GetSpellAbilityId() == this.abilityId()
			return result
		endmethod
		
		/**
		 * Morphs the character.
		 */
		private method morph takes nothing returns nothing
			/*
			 * Only allow one metamorphosis at a time.
			 */
			if (not this.character().isMorphed()) then
				if (this.canMorph.evaluate()) then
					if (Character(this.character()).morph(this.disableInventory())) then	
						/*
						 * The ability is removed then made permanent and casted again that it will not be losed by the metamorphosis.	
						 * Removing all grimoire abilities including the ability itself is only done for safety to make sure that no grimoire
						 * ability is being cast which is in a spell book.
						 */
						if (this.disableGrimoire()) then
							call Character(this.character()).grimoire().removeAllSpellsFromUnit()
						endif
						
						/*
						 * These two lines of code do the passive transformation to another unit type.
						 */
						call UnitAddAbility(this.character().unit(), this.morphAbilityId())
						call UnitRemoveAbility(this.character().unit(), this.morphAbilityId())
						
						set this.m_isMorphed = true
						
						/**
						 * Grimoire spells need to be readded.
						 */
						if (not this.disableGrimoire()) then
							call this.character().updateGrimoireAfterPassiveTransformation()
							
							/*
							 * Add skill spell and abilities spell.
							 */
							if (GetUnitAbilityLevel(this.character().unit(), Grimoire.spellsAbilityId) == 0) then
								call UnitAddAbility(this.character().unit(), Grimoire.spellsAbilityId)
							endif
							if (GetUnitAbilityLevel(this.character().unit(), Grimoire.abilityId) == 0) then
								call UnitAddAbility(this.character().unit(), Grimoire.abilityId)
								call SetUnitAbilityLevel(this.character().unit(), Grimoire.abilityId, this.character().skillPoints())
							endif
						endif
						
						// add unmorph spell
						// there is always one free ability slot since disabling the rucksack is not allowed
						debug call Print("Adding ability " + GetObjectName(this.abilityId()) + " to unit " + GetUnitName(this.character().unit()))
						call UnitAddAbility(this.character().unit(), this.abilityId()) // TODO does not appear, make permanent?!
				
						// morph spells are expected to morph immediately
						call this.onMorph.evaluate()
					endif
				endif
			else
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Charakter ist bereits verwandelt.", "Character is already transformed."))
			endif
		endmethod
		
		/**
		 * Restores inventory and grimoire of a character.
		 * Calls \ref onRestore() with .evaluate() and changes \ref isMorphed()
		 * \note Does not issue any order/ability.
		 */
		private method restoreUnit takes nothing returns boolean
			/*
			 * If this overwritten method returns false restoration is canceled.
			 */
			if (this.canRestore.evaluate()) then
			
				/**
				 * Store the grimoire spell levels to restore them since non permanent abilities get lost.
				 * Only store them if the grimoire is active.
				 * Otherwise they should be stored by the morph before already.
				 */
				if (not this.disableGrimoire()) then
					call this.character().updateRealSpellLevels()
				endif
				
				/*
				 * These two lines of code do the passive transformation to a range fighting unit.
				 */
				call UnitAddAbility(this.character().unit(), this.unmorphAbilityId())
				call UnitRemoveAbility(this.character().unit(), this.unmorphAbilityId())
				/**
				 * Now readd all removed abilities and restory the inventory.
				 */
				if (Character(this.character()).restoreUnit(this.disableInventory())) then
					set this.m_isMorphed = false
					call this.onRestore.evaluate()
					
					return true
				endif
			endif
			
			return false
		endmethod
		
		private static method triggerActionStart takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local boolean result = false
			
			/*
			 * Disable trigger to make sure that it does not react on manually issued order in this trigger.
			 * Otherwise it would result in an endless loop.
			 */
			call DisableTrigger(this.m_channelTrigger)
			/*
			 * Stop the spell immediately since we have to check if morph or restoration is allowed.
			 * In case of morph we have to store spell levels and inventory and to remove it first.
			 */
			call IssueImmediateOrder(this.character().unit(), "stop") // stop spell immediately
			debug call Print("Start for spell: " + GetObjectName(this.abilityId()))
			
			// morph
			if (not Character(this.character()).isMorphed()) then
				call this.morph()
			// restore only if morphed with this spell
			elseif (this.isMorphed()) then
				/**
				 * Now readd all removed abilities and restory the inventory.
				 */
				call this.restoreUnit()
			else
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Charakter ist bereits verwandelt.", "Character is already transformed."))
			endif
			
			call EnableTrigger(this.m_channelTrigger)
		endmethod
		
		private static method triggerConditionRevival takes nothing returns boolean
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() == this.character().unit() and this.isMorphed()
		endmethod
		
		private static method triggerActionRevival takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			/**
			 * Now readd all removed abilities and restory the inventory.
			 */
			call this.restoreUnit()
		endmethod
		
		public static method create takes Character character, integer abilityId, integer morphAbilityId, integer unmorphAbilityId returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character
			set this.m_abilityId = abilityId
			set this.m_morphAbilityId = morphAbilityId
			set this.m_unmorphAbilityId = unmorphAbilityId
			set this.m_disableGrimoire = true
			set this.m_disableInventory = true
			
			set this.m_channelTrigger = CreateTrigger()
			// register action before cast has finished!
			call TriggerRegisterAnyUnitEventBJ(this.m_channelTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerConditionStart))
			call TriggerAddAction(this.m_channelTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, "this", this)
			
			// unmorph unit if it is being revived and has been morphed
			// when a character is revived it has automatically its original unit form but needs to be restored (skills etc.)
			set this.m_revivalTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_revivalTrigger, EVENT_PLAYER_HERO_REVIVE_FINISH)
			call TriggerAddCondition(this.m_revivalTrigger, Condition(function thistype.triggerConditionRevival))
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionRevival)
			call AHashTable.global().setHandleInteger(this.m_revivalTrigger, "this", this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_channelTrigger)
			set this.m_channelTrigger = null
			call AHashTable.global().destroyTrigger(this.m_revivalTrigger)
			set this.m_revivalTrigger = null
		endmethod
	endstruct

endlibrary
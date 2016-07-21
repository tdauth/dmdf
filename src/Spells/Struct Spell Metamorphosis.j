/// Metamorphosis
library StructSpellsSpellMetamorphosis requires Asl, StructGameCharacter, StructGameGrimoire

	/**
	 * \brief Generic abstract spell for metamorphosis which allows specific behaviour on transformation and reset to the original unit.
	 *
	 * Transformation is done by passive hero transformation which means the transforming ability is added and immediately removed to transform the hero
	 * into another unit type. The same is done when transforming the hero back to the original unit type.
	 * Therefore two abilities are required plus the ability which casts the spell which might be based on Channel.
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
		/// This flag has only an effect when the inventory is disabled. In this case the rucksack is still visible.
		private boolean m_enableOnlyRucksack
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
		
		/**
		 * \return Returns the ability ID of the ability which is used for the passive hero transformation into the other unit type.
		 */
		public method morphAbilityId takes nothing returns integer
			return this.m_morphAbilityId
		endmethod
		
		/**
		 * \return Returns the ability ID of the ability which is used for the passive hero transformation back to the original unit type.
		 */
		public method unmorphAbilityId takes nothing returns integer
			return this.m_unmorphAbilityId
		endmethod
		
		/**
		 * Specifies if the grimoire can still be used when transformed.
		 */
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
		
		public method setEnableOnlyRucksack takes boolean enable returns nothing
			set this.m_enableOnlyRucksack = enable
		endmethod
		
		public method enableOnlyRucksack takes nothing returns boolean
			return this.m_enableOnlyRucksack
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
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local boolean result = GetTriggerUnit() == this.character().unit() and GetSpellAbilityId() != null and GetSpellAbilityId() == this.abilityId()
			return result
		endmethod
		
		/**
		 * Morphs the character.
		 */
		private method morph takes nothing returns nothing
			local Character character = Character(this.character())
			/*
			 * Only allow one metamorphosis at a time.
			 */
			if (not character.isMorphed()) then
				if (this.canMorph.evaluate()) then
					if (character.morph(this.disableInventory(), this.enableOnlyRucksack())) then	
						/*
						 * The ability is removed then made permanent and casted again that it will not be losed by the metamorphosis.	
						 * Removing all grimoire abilities including the ability itself is only done for safety to make sure that no grimoire
						 * ability is being cast which is in a spell book.
						 */
						if (this.disableGrimoire()) then
							call character.grimoire().removeAllSpellsFromUnit()
						endif
						
						/*
						 * These two lines of code do the passive transformation to another unit type.
						 */
						call UnitAddAbility(character.unit(), this.morphAbilityId())
						call UnitRemoveAbility(character.unit(), this.morphAbilityId())
						
						set this.m_isMorphed = true
						
						/**
						 * Grimoire spells need to be readded.
						 */
						if (not this.disableGrimoire()) then
							call character.updateGrimoireAfterPassiveTransformation()
							
							/*
							 * Add skill spell and abilities spell.
							 */
							if (GetUnitAbilityLevel(character.unit(), Grimoire.spellsAbilityId) == 0) then
								call UnitAddAbility(character.unit(), Grimoire.spellsAbilityId)
							endif
							if (GetUnitAbilityLevel(character.unit(), Grimoire.abilityId) == 0) then
								call UnitAddAbility(character.unit(), Grimoire.abilityId)
								call SetUnitAbilityLevel(character.unit(), Grimoire.abilityId, character.skillPoints())
							endif
						endif
						
						// Add unmorph spell if at least one slot is free. Otherwise if you sell the item you cannot morph back.
						if (this.disableInventory() or this.disableGrimoire()) then
							// there is always one free ability slot since disabling the rucksack is not allowed
							debug call Print("Adding ability " + GetObjectName(this.abilityId()) + " to unit " + GetUnitName(character.unit()))
							if (not this.disableInventory()) then
								// disabling the inventory removes the item ability
								call character.inventory().disable()
							endif
							//call UnitRemoveAbility(character.unit(), this.abilityId()) // remove ability from item, the item can not be used for casting afterwards but the ability appears in the unit's UI
							call UnitAddAbility(character.unit(), this.abilityId()) // TODO does not appear, make permanent?!
							if (GetUnitAbilityLevel(character.unit(), this.abilityId()) > 0) then
								debug call Print("UNIT HAS ABILITY WTF!")
							endif
							if (not this.disableInventory()) then
								// no reenable the inventory to show the items as well
								call character.inventory().enable()
							endif
						endif
				
						// morph spells are expected to morph immediately
						call this.onMorph.evaluate()
						
						if (GetUnitAbilityLevel(character.unit(), this.abilityId()) > 0) then
							debug call Print("UNIT HAS ABILITY AFTERWARDS WTF!")
						endif
					endif
				endif
			else
				call character.displayMessage(ACharacter.messageTypeError, tre("Charakter ist bereits verwandelt.", "Character is already transformed."))
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
				if (Character(this.character()).restoreUnit(this.disableInventory(), this.enableOnlyRucksack())) then
					set this.m_isMorphed = false
					call this.onRestore.evaluate()
					
					return true
				endif
			endif
			
			return false
		endmethod
		
		private static method triggerActionStart takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
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
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetTriggerUnit() == this.character().unit() and this.isMorphed()
		endmethod
		
		private static method triggerActionRevival takes nothing returns nothing
			local thistype this = AHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
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
			// still show the whole inventory
			set this.m_enableOnlyRucksack = false
			set this.m_isMorphed = false
			
			set this.m_channelTrigger = CreateTrigger()
			// register action before cast has finished!
			call TriggerRegisterAnyUnitEventBJ(this.m_channelTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
			call TriggerAddCondition(this.m_channelTrigger, Condition(function thistype.triggerConditionStart))
			call TriggerAddAction(this.m_channelTrigger, function thistype.triggerActionStart)
			call AHashTable.global().setHandleInteger(this.m_channelTrigger, 0, this)
			
			// unmorph unit if it is being revived and has been morphed
			// when a character is revived it has automatically its original unit form but needs to be restored (skills etc.)
			set this.m_revivalTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_revivalTrigger, EVENT_PLAYER_HERO_REVIVE_FINISH)
			call TriggerAddCondition(this.m_revivalTrigger, Condition(function thistype.triggerConditionRevival))
			call TriggerAddAction(this.m_revivalTrigger, function thistype.triggerActionRevival)
			call AHashTable.global().setHandleInteger(this.m_revivalTrigger, 0, this)
			
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
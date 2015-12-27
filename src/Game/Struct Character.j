library StructGameCharacter requires Asl, StructGameDmdfHashTable

	/**
	 * This function interface can be used to react to crafting events.
	 * Functions which match to this interface can be registered via \ref Character#addOnCraftItemFunction() and will be called whenever the character crafts an item.
	 */
	function interface CharacterOnCraftItemFunction takes Character character, integer itemTypeId returns nothing

	/**
	 * \brief Customized character struct for characters in The Power of Fire.
	 * This additional specialized struct is required for interaction with \ref Grimoire, \ref MainMenu, \ref InfoLog and metamorphosis spells.
	 */
	struct Character extends ACharacter
		// dynamic members
		private boolean m_isInPvp
		private boolean m_showCharactersScheme
		private boolean m_showWorker
		private AIntegerVector m_onCraftItemFunctions
		// members
		private MainMenu m_mainMenu
static if (DMDF_CREDITS) then
		private Credits m_credits
endif
		private Grimoire m_grimoire
		private Tutorial m_tutorial
static if (DMDF_INFO_LOG) then
		private InfoLog m_infoLog
endif
		private AIntegerVector m_classSpells /// Only \ref Spell instances not \ref ASpell instances!
		
		/**
		 * Required for repicking.
		 * These instances won't be destroyed and therefore must be passed to the new character instance.
		 */
		private AIntegerVector m_quests
		private AIntegerVector m_fellows

		private boolean m_isMorphed
		/**
		 * Since the Villager255 model is used, animation indices have to be set manually depending on the weapon.
		 * In this trigger the attack animation of the character is determined.
		 */
		private trigger m_animationOrderTrigger
		
		private AHashTable m_realSpellLevels

		// dynamic members

		public method setIsInPvp takes boolean isInPvp returns nothing
			set this.m_isInPvp = isInPvp
		endmethod

		public method isInPvp takes nothing returns boolean
			return this.m_isInPvp
		endmethod

		public method setView takes boolean enabled returns nothing
			if (not enabled and this.view().enableAgain()) then
				call this.view().setEnableAgain(false)
				call this.view().disable()
				call ResetToGameCameraForPlayer(this.player(), 0.0)
			elseif (enabled and not this.view().enableAgain()) then
				call this.view().setEnableAgain(true)
				call this.view().enable()
			debug else
				debug call Print("Character: Error since view has already enabled state.")
			endif
		endmethod

		public method isViewEnabled takes nothing returns boolean
			return this.view().isEnabled()
		endmethod

		public method showCharactersScheme takes nothing returns boolean
			return this.m_showCharactersScheme
		endmethod

		public method setShowWorker takes boolean show returns nothing
			set this.m_showWorker = show
			call ShowUnit(Shrine.playerUnit.evaluate(GetPlayerId(this.player())), show)
		endmethod

		public method showWorker takes nothing returns boolean
			return this.m_showWorker
		endmethod
		
		public method addOnCraftItemFunction takes CharacterOnCraftItemFunction onCraftItemFunction returns nothing
			call this.m_onCraftItemFunctions.pushBack(onCraftItemFunction)
		endmethod
		
		public method removeOnCraftItemFunction takes CharacterOnCraftItemFunction onCraftItemFunction returns nothing
			call this.m_onCraftItemFunctions.remove(onCraftItemFunction)
		endmethod
		
		public method onCraftItemFunctionsCount takes nothing returns integer
			return this.m_onCraftItemFunctions.size()
		endmethod
		
		public method onCraftItemFunction takes integer index returns CharacterOnCraftItemFunction
			return this.m_onCraftItemFunctions[index]
		endmethod

		// members

		public method mainMenu takes nothing returns MainMenu
			return this.m_mainMenu
		endmethod

		public method credits takes nothing returns Credits
static if (DMDF_CREDITS) then
			return this.m_credits
else
			return 0
endif
		endmethod

		public method grimoire takes nothing returns Grimoire
			return this.m_grimoire
		endmethod

		public method tutorial takes nothing returns Tutorial
			return this.m_tutorial
		endmethod

/// @todo static ifs do not prevent import of files, otherwise info log wouldn't require this method
		public method infoLog takes nothing returns InfoLog
static if (DMDF_INFO_LOG) then
			return this.m_infoLog
else
			return 0
endif
		endmethod
		
		public method addClassSpell takes Spell spell returns nothing
			call this.m_classSpells.pushBack(spell)
		endmethod
		
		/**
		 * Since \ref ACharacter.spells() contains all spells belonging to the character it includes non class spells such as
		 * "Grimoire" or "Add to Favorites". This container stores only class spells which should be listed in the grimoire for example.
		 */
		public method classSpells takes nothing returns AIntegerVector
			return this.m_classSpells
		endmethod
		
		public method addQuest takes AQuest whichQuest returns nothing
			call this.m_quests.pushBack(whichQuest)
		endmethod
		
		public method quests takes nothing returns AIntegerVector
			return this.m_quests
		endmethod
		
		public method addFellow takes Fellow fellow returns nothing
			call this.m_fellows.pushBack(fellow)
		endmethod
		
		public method removeFellow takes Fellow fellow returns nothing
			call this.m_fellows.remove(fellow)
		endmethod
		
		public method fellows takes nothing returns AIntegerVector
			return this.m_fellows
		endmethod

		/**
		* Shows characters scheme to characer's player if enabled.
		* \sa thistype#showCharactersScheme, thistype#setShowCharactersScheme, thistype#showCharactersSchemeToAll
		*/
		public method showCharactersSchemeToPlayer takes nothing returns nothing
			// is disabled in GUI
			if (not AGui.playerGui(this.player()).isShown()) then
				if (this.showCharactersScheme()) then
					call ACharactersScheme.showForPlayer(this.player())
					call MultiboardSuppressDisplayForPlayer(this.player(), false)
				else
					call ACharactersScheme.hideForPlayer(this.player())
				endif
			endif
		endmethod

		/**
		* Hides characters scheme for characer's player if enabled.
		* \sa thistype#showCharactersScheme, thistype#setShowCharactersScheme, thistype#showCharactersSchemeToAll
		*/
		public method hideCharactersSchemeForPlayer takes nothing returns nothing
			if (this.showCharactersScheme()) then
				call ACharactersScheme.hideForPlayer(this.player())
			endif
		endmethod

		public method setShowCharactersScheme takes boolean showCharactersScheme returns nothing
			set this.m_showCharactersScheme = showCharactersScheme
			call this.showCharactersSchemeToPlayer()
		endmethod
		
		public stub method onRevival takes nothing returns nothing
			call SetUnitLifePercentBJ(this.unit(), MapData.revivalLifePercentage)
			call SetUnitManaPercentBJ(this.unit(), MapData.revivalManaPercentage)
		endmethod
		
		private method hasRealSpellLevels takes nothing returns boolean
			return this.m_realSpellLevels != 0
		endmethod
		
		/**
		 * \return Returns the stored hash table with ability id - level pairs (parent key - 0, child key - ability id, value - level).
		 * \sa Grimoire#spellLevels
		 */
		public method realSpellLevels takes nothing returns AHashTable
			debug if (this.m_realSpellLevels == 0) then
			debug call Print("No spell levels stored!")
			debug endif
			return this.m_realSpellLevels
		endmethod
		
		private method clearRealSpellLevels takes nothing returns boolean
			debug call Print("Clearing real spell levels")
			if (this.hasRealSpellLevels()) then
				call this.realSpellLevels().destroy()
				set this.m_realSpellLevels = 0
				
				return true
			endif
			
			return false
		endmethod
		
		/**
		 * Stores all grimoire spell levels for later restoration by \ref restoreRealSpellLevels().
		 * This has to be done for unit transformations since non permanent abilities get lost.
		 */
		public method updateRealSpellLevels takes nothing returns nothing
			call this.clearRealSpellLevels()
			set this.m_realSpellLevels = this.grimoire().spellLevels.evaluate()
		endmethod
		
		public method restoreRealSpellLevels takes nothing returns boolean
			if (this.hasRealSpellLevels()) then
				call this.grimoire().readd.evaluate(this.realSpellLevels())
				
				return true
			endif
			
			return false
		endmethod
		
		public method isMorphed takes nothing returns boolean
			return this.m_isMorphed
		endmethod
		
		/**
		 * Usually on passive hero transformation the grimoire abilities get lost, so they must be readded.
		 */
		public method updateGrimoireAfterPassiveTransformation takes nothing returns nothing
			/*
			 * Now the spell levels have to be readded and the grimoire needs to be updated since all abilities are gone.
			 */
			call this.restoreRealSpellLevels()
			call this.clearRealSpellLevels()
			call this.grimoire().updateUi.evaluate()
		endmethod

		/**
		 * Restores spells and inventory of the character after he has been morphed into another creature with other abilities and without inventory.
		 * The spell levels has been stored in \ref realSpellLevels() while calling \ref morph().
		 * \note Has to be called just after the character's unit restores from morphing.
		 */
		public method restoreUnit takes boolean disableInventory returns boolean
			if (not this.hasRealSpellLevels()) then
				debug call Print("Has not been morphed before!")
				return false
			endif
			
			if (disableInventory) then
				debug call Print("Enabling inventory again")
				call this.inventory().setEnableAgain(true)
				call this.inventory().enable()
			else
				call this.inventory().enableOnlyRucksack(false)
			endif
			
			call this.updateGrimoireAfterPassiveTransformation()
			
			set this.m_isMorphed = false
			debug call this.print("RESTORED")
			
			return true
		endmethod

		/**
		* When a character morphes there has to be some remorph functionality e. g. when the character dies and is being revived.
		* Besides he has to be restored when unmorphing (\ref Character#restoreUnit).
		* \note Has to be called just before the character's unit morphes.
		* \param abilityId Id of the ability which has to be casted to morph the character.
		*/
		public method morph takes boolean disableInventory returns boolean
			debug if (GetUnitAbilityLevel(this.unit(), 'AInv') == 0) then
			debug call Print("It is too late to store the items! Add a delay for the morphing ability!")
			debug endif
			
			call this.updateRealSpellLevels()
			
			// Make sure it won't be enabled again when the character is set movable.
			if (disableInventory) then
				/*
				 * Make sure it is a melee character before it morphes since all morph spells are based on melee characters.
				 * Otherwise one would have to create morph abilities for range and melee characters.
				 */
				call UnitAddAbility(this.unit(), Classes.classMeleeAbilityIdByCharacter.evaluate(this))
				call UnitRemoveAbility(this.unit(), Classes.classMeleeAbilityIdByCharacter.evaluate(this))
			
				call this.inventory().setEnableAgain(false)
				debug call Print("Disabling inventory")
				// Should remove but store all items and their permanently added abilities if the rucksack is open!
				call this.inventory().disable()
				debug call Print("After disabling inventory")
			else
				// unequipping leads to melee unit, always!
				call this.inventory().enableOnlyRucksack(true)
			endif
			
			set this.m_isMorphed = true
			debug call this.print("MORPHED")
			
			return true
		endmethod
		
		public method craftItem takes integer itemTypeId returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.onCraftItemFunctionsCount())
				call this.onCraftItemFunction(i).evaluate(this, itemTypeId)
				set i = i + 1
			endloop
		endmethod

		private method displayQuestMessage takes integer messageType, string message returns nothing
			local force whichForce = GetForceOfPlayer(this.player())
			call QuestMessageBJ(whichForce, messageType, message)
			call DestroyForce(whichForce)
			set whichForce = null
		endmethod

		public method displayHint takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tre("|cff00ff00TIPP|r - %1%", "|cff00ff00HINT|r - %1%")).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayUnitAcquired takes string unitName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_UNITACQUIRED, Format(tre("|cff87ceebNEUE EINHEIT ERHALTEN|r\n%1% - %2%", "|cff87ceebNEW UNIT ACQUIRED|r\n%1% - %2%")).s(unitName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayItemAcquired takes string itemName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_ITEMACQUIRED, Format(tre("|cff87ceebNEUEN GEGENSTAND ERHALTEN|r\n%1% - %2%", "|cff87ceebNEW ITEM ACQUIRED|r\n%1% - %2%")).s(itemName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayAbilityAcquired takes string abilityName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tre("|cff87ceebNEUE FÄHIGKEIT ERHALTEN|r\n%1% - %2%", "|cff87ceebNEW ABILITY ACQUIRED|r\n%1% - %2%")).s(abilityName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		/// \todo How to display/format warnings?
		public method displayWarning takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_WARNING, Format(tre("%1%", "%1%")).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questWarningSound)
		endmethod

		public method displayDifficulty takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tre("|cff00ff00SCHWIERIGKEITSGRAD|r - %1%", "|cff00ff00DIFFICULTY|r - %1%")).s(message).result())
		endmethod

		public method displayFinalLevel takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tre("|cff00ff00LETZTE STUFE|r - %1%", "|cff00ff00LAST LEVEL|r - %1%")).s(message).result())
		endmethod

		public method displayFinalLevelToAllOthers takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0 and i != GetPlayerId(this.player())) then
					call thistype(thistype.playerCharacter(Player(i))).displayFinalLevel(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public method displayXPBonus takes integer xp, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tre("|cff87ceebERFAHRUNGSBONUS ERHALTEN|r\n%1% - %2%", "|cff87ceebACQUIRED EXPERIENCE BONUS|r\n%1% - %2%")).i(xp).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method xpBonus takes integer xp, string message returns nothing
			call this.displayXPBonus(xp, message)
			call this.addExperience(xp, true)
		endmethod

		public method giveItem takes integer itemTypeId returns nothing
			local item whichItem = CreateItem(itemTypeId, GetUnitX(this.unit()), GetUnitY(this.unit()))
			call SetItemPlayer(whichItem, this.player(), true)
			// make sure it is put into the rucksack if possible and that it works even if the character is morphed and has no inventory ability.
			call this.inventory().addItem(whichItem)
			//call UnitAddItem(this.unit(), whichItem)
		endmethod

		/**
		 * Makes item invulnerable, changes its owner to owner of character, makes it unpawnable and gives it to the character automatically.
		 */
		public method giveQuestItem takes integer itemTypeId returns nothing
			local item whichItem = CreateItem(itemTypeId, GetUnitX(this.unit()), GetUnitY(this.unit()))
			call SetItemPawnable(whichItem, false)
			call SetItemInvulnerable(whichItem, true)
			call SetItemPlayer(whichItem, this.player(), true)
			// make sure it is put into the rucksack if possible and that it works even if the character is morphed and has no inventory ability.
			call this.inventory().addItem(whichItem)
			//call UnitAddItem(this.unit(), whichItem)
		endmethod

		private static method triggerConditionWorker takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerPlayer() == this.player() and ACharacter.playerCharacter(GetTriggerPlayer()).shrine() != 0
		endmethod

		private static method triggerActionWorker takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			//call ACharacter.playerCharacter(GetTriggerPlayer()).select()
			call SmartCameraPanWithZForPlayer(this.player(), GetDestructableX(this.shrine().destructable()), GetDestructableY(this.shrine().destructable()), 0.0, 0.0)
			call SelectUnitForPlayerSingle(this.unit(), this.player())
			debug call Print("Selected worker")
		endmethod

		private static method triggerConditionOrder takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return this.unit() == GetAttacker()
		endmethod
		
		private static method triggerActionOrder takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local AIntegerVector values = 0
			if (not this.isMorphed()) then
				// Attack 1 - 15, no weapon
				if (this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) == 0 and this.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(13, 20))
					debug call Print("Attack without weapon")
				// Attack Alternate 1 - 9, two handed sword
				elseif (false) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(27, 29))
				// Attack Defend 1 - 2, attack with buckler
				// basically this should be already provided by the animation tag "defend"
				elseif (this.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0 and ItemTypes.itemTypeIdIsBuckler.evaluate(this.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 112)
					debug call Print("Attack with buckler")
				// Attack throw 6 - 7, bow
				elseif (this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsBow.evaluate(this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(122, 123))
					debug call Print("Attack with bow")
				// throwing spear
				elseif (this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsThrowingSpear.evaluate(this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 119)
					debug call Print("Attack with a throwing spear")
				// attacking with spear in melee
				elseif (this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsMeleeSpear.evaluate(this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 117)
					debug call Print("Attack with spear in melee")
				// attacking with two handed lance
				elseif (this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsTwoHandedLance.evaluate(this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 61)
					debug call Print("Attack with two handed lance")
				// attacking with two handed hammer
				elseif (this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsTwoHandedHammer.evaluate(this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 62)
					debug call Print("Attack with two handed hammer")
				// Attack with one left handed weapon
				elseif (this.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and this.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0) then
					set values = AIntegerVector.create()
					call values.pushBack(21)
					call values.pushBack(40)
					call values.pushBack(23)
					call values.pushBack(25)
					call SetUnitAnimationByIndex(GetAttacker(), values.random())
					call values.destroy()
					debug call Print("Attack with one left handed weapon")
				endif
			endif
		endmethod

		/**
		 * \param quests Set to 0 on first creation but set to old quests on repick creation.
		 * \param fellows Set to 0 on first creation but set to old quests on repick creation.
		 */
		public static method create takes player whichPlayer, unit whichUnit, AIntegerVector quests, AIntegerVector fellows returns thistype
			local thistype this = thistype.allocate(whichPlayer, whichUnit)
			
			call this.inventory().setEquipmentTypePlaceholder(AItemType.equipmentTypeHeaddress, 'I06C')
			call this.inventory().setEquipmentTypePlaceholder(AItemType.equipmentTypeArmour, 'I06D')
			call this.inventory().setEquipmentTypePlaceholder(AItemType.equipmentTypePrimaryWeapon, 'I06E')
			call this.inventory().setEquipmentTypePlaceholder(AItemType.equipmentTypeSecondaryWeapon, 'I06F')
			call this.inventory().setEquipmentTypePlaceholder(AItemType.equipmentTypeAmulet, 'I06G')
			call this.inventory().setEquipmentTypePlaceholder(AItemType.equipmentTypeAmulet + 1, 'I06G')
			call this.inventory().updateEquipmentTypePlaceholders()
			
			// dynamic members
			set this.m_isInPvp = false
			set this.m_showCharactersScheme = true
			set this.m_showWorker = true
			set this.m_onCraftItemFunctions = AIntegerVector.create()
			// members
			set this.m_mainMenu = MainMenu.create.evaluate(this)
static if (DMDF_CREDITS) then
			set this.m_credits = Credits.create.evaluate(this)
endif
			set this.m_grimoire = Grimoire.create.evaluate(this)
			set this.m_tutorial = Tutorial.create.evaluate(this)
static if (DMDF_INFO_LOG) then
			set this.m_infoLog = InfoLog.create.evaluate(this)
endif

			set this.m_classSpells = AIntegerVector.create()
			set this.m_quests = quests
			if (this.m_quests == 0) then
				set this.m_quests = AIntegerVector.create()
			endif
			set this.m_fellows = fellows
			if (this.m_fellows == 0) then
				set this.m_fellows = AIntegerVector.create()
			endif
			set this.m_isMorphed = false
			set this.m_animationOrderTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_animationOrderTrigger, EVENT_PLAYER_UNIT_ATTACKED)
			call TriggerAddCondition(this.m_animationOrderTrigger, Condition(function thistype.triggerConditionOrder))
			call TriggerAddAction(this.m_animationOrderTrigger, function thistype.triggerActionOrder)
			call DmdfHashTable.global().setHandleInteger(this.m_animationOrderTrigger, "this", this)

			set this.m_realSpellLevels = 0
			
			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_onCraftItemFunctions.destroy()
		
			call this.m_mainMenu.destroy.evaluate()
static if (DMDF_CREDITS) then
			call this.m_grimoire.destroy.evaluate()
endif
			call this.m_tutorial.destroy.evaluate()
static if (DMDF_INFO_LOG) then
			call this.m_infoLog.destroy.evaluate()
endif
			call this.m_classSpells.destroy()
			set this.m_classSpells = 0
			call DmdfHashTable.global().destroyTrigger(this.m_animationOrderTrigger)
			set this.m_animationOrderTrigger = null
			
			if (this.hasRealSpellLevels()) then
				call this.clearRealSpellLevels()
			endif
		endmethod

		/**
		 * \sa thistype#showCharactersSchemeToPlayer
		 */
		public static method showCharactersSchemeToAll takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).showCharactersSchemeToPlayer()
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayHintToAll takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayHint(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayUnitAcquiredToAll takes string unitName, string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayUnitAcquired(unitName, message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayItemAcquiredToAll takes string itemName, string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayItemAcquired(itemName, message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayAbilityAcquiredToAll takes string abilityName, string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayAbilityAcquired(abilityName, message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayWarningToAll takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayWarning(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method displayDifficultyToAll takes string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).displayDifficulty(message)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setViewForAll takes boolean enabled returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).setView(enabled)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setTutorialForAll takes boolean enabled returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).tutorial().setEnabled.evaluate(enabled)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method addSkillGrimoirePointsToAll takes integer skillPoints returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).grimoire().addSkillPoints.evaluate(skillPoints)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary
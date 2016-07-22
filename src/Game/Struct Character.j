library StructGameCharacter requires Asl, StructGameDmdfHashTable

	/**
	 * \brief Handles attack animations of the Villager255 model. Whenever the unit attacks the attack animation is replaced depending on the equipped items.
	 *
	 * This can be used for copies of a character unit as well as illusions.
	 * Otherwise animations of the copy in videos and illusions from spells won't be played properly!
	 */
	struct OrderAnimations
		private Character m_character
		private unit m_unit
		
		public method unit takes nothing returns unit
			return this.m_unit
		endmethod
		
		/**
		 * Since the Villager255 model is used, animation indices have to be set manually depending on the weapon.
		 * In this trigger the attack animation of the character is determined.
		 */
		private trigger m_animationOrderTrigger
		
		private static method triggerConditionOrder takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return this.unit() == GetAttacker()
		endmethod
		
		private static method triggerActionOrder takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local AInventory inventory = this.m_character.inventory()
			local AIntegerVector values = 0
			/*
			 * If the character is morphed it has not the villager255 model.
			 * Illusions are only created from non-morphed characters.
			 */
			if (not this.m_character.isMorphed.evaluate() or IsUnitIllusion(this.unit())) then
				// Attack 1 - 15, no weapon
				if (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) == 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(13, 20))
					debug call Print("Attack without weapon")
				// Attack Alternate 1 - 9, two handed sword
				elseif (false) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(27, 29))
				// Attack Defend 1 - 2, attack with buckler
				// basically this should be already provided by the animation tag "defend"
				elseif (inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0 and ItemTypes.itemTypeIdIsBuckler.evaluate(inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 112)
					debug call Print("Attack with buckler")
				// Attack throw 6 - 7, bow
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsBow.evaluate(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), GetRandomInt(122, 123))
					debug call Print("Attack with bow")
				// throwing spear
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsThrowingSpear.evaluate(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 118) //  119
					debug call Print("Attack with a throwing spear")
				// attacking with spear in melee
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsMeleeSpear.evaluate(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 117)
					debug call Print("Attack with spear in melee")
				// attacking with two handed lance
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsTwoHandedLance.evaluate(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 61)
					debug call Print("Attack with two handed lance")
				// attacking with two handed hammer
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and ItemTypes.itemTypeIdIsTwoHandedHammer.evaluate(inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())) then
					call SetUnitAnimationByIndex(GetAttacker(), 62)
					debug call Print("Attack with two handed hammer")
				// attack with a weapon in each hand -> no buckler in right hand
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0 and not ItemTypes.itemTypeIdIsBuckler.evaluate(inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
					// attack either with left or right hand TODO animation for both hands?
					set values = AIntegerVector.create()
					call values.pushBack(21)
					call values.pushBack(22)
					call values.pushBack(40)
					call values.pushBack(41)
					call values.pushBack(23)
					call values.pushBack(24)
					call values.pushBack(25)
					call values.pushBack(26)
					call SetUnitAnimationByIndex(GetAttacker(), values.random())
					call values.destroy()
					debug call Print("Attack with two weapons")
				// Attack with one left handed weapon
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) == 0) then
					set values = AIntegerVector.create()
					call values.pushBack(21)
					call values.pushBack(40)
					call values.pushBack(23)
					call values.pushBack(25)
					call SetUnitAnimationByIndex(GetAttacker(), values.random())
					call values.destroy()
					debug call Print("Attack with one left handed weapon")
				// Attack with one right handed weapon
				elseif (inventory.equipmentItemData(AItemType.equipmentTypePrimaryWeapon) == 0 and inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0 and not ItemTypes.itemTypeIdIsBuckler.evaluate(inventory.equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())) then
					set values = AIntegerVector.create()
					call values.pushBack(22)
					call values.pushBack(41)
					call values.pushBack(24)
					call values.pushBack(26)
					call SetUnitAnimationByIndex(GetAttacker(), values.random())
					call values.destroy()
					debug call Print("Attack with one right handed weapon")
				debug else
					debug call Print("Unknown attack style! Implement animation!")
				endif
			endif
		endmethod
		
		public static method create takes Character character, unit whichUnit returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character
			set this.m_unit = whichUnit
			
			set this.m_animationOrderTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_animationOrderTrigger, EVENT_PLAYER_UNIT_ATTACKED)
			call TriggerAddCondition(this.m_animationOrderTrigger, Condition(function thistype.triggerConditionOrder))
			call TriggerAddAction(this.m_animationOrderTrigger, function thistype.triggerActionOrder)
			call DmdfHashTable.global().setHandleInteger(this.m_animationOrderTrigger, 0, this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_animationOrderTrigger)
			set this.m_animationOrderTrigger = null
		endmethod
	endstruct

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
		/**
		 * The default camera distance for every character if the 3rd person view is not used.
		 */
		public static constant real defaultCameraDistance = bj_CAMERA_DEFAULT_DISTANCE + 250.0
		/**
		 * The maximum character distance for every character if the 3rd person view is not used.
		 */
		public static constant real maxCameraDistance =  bj_CAMERA_DEFAULT_DISTANCE + 750.0
		/**
		 * The minimum character distance for every character if the 3rd person view is not used.
		 */
		public static constant real minCameraDistance =  bj_CAMERA_DEFAULT_DISTANCE
		/**
		 * The periodic refresh interval in seconds which is used to refresh the camera distance to every character if the 3rd person view is not used.
		 */
		public static constant real cameraTimerInterval = 0.01
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
		
		/**
		 * Allows setting a custom camera distance.
		 * The initial camera distance is different from the camera distance of Warcraft III which is \ref bj_CAMERA_DEFAULT_DISTANCE because the Doodads are much bigger.
		 */
		private real m_cameraDistance
		private timer m_cameraTimer
		private boolean m_cameraTimerEnabled

		private boolean m_isMorphed
		
		/**
		 * Handles Villager255 animations on attacking other units.
		 */
		private OrderAnimations m_orderAnimations
		/**
		 * Handles attacking animations of all summoned illusions.
		 */
		private AIntegerList m_illusionOrderAnimations
		/**
		 * Triggers whenever a new illusion is spawned.
		 */
		private trigger m_spawnIllusionTrigger
		/**
		 * Triggers whenever an illusion dies.
		 */
		private trigger m_illusionDiesTrigger
		/**
		 * Emotes trigger which allows playing character animations via chat commands.
		 */
		private trigger m_danceTrigger
		private trigger m_clearTrigger
		
		private AHashTable m_realSpellLevels

		// dynamic members

		public method setIsInPvp takes boolean isInPvp returns nothing
			set this.m_isInPvp = isInPvp
		endmethod

		public method isInPvp takes nothing returns boolean
			return this.m_isInPvp
		endmethod

		/**
		 * Enables or disables the 3rd person camera view.
		 * \param enabled If this value is true the 3rd person camera view will be enabled. Otherwise it will be disabled.
		 * \note If it gets disabled the camera timer applying the custom camera distance will be started again.
		 */
		public method setView takes boolean enabled returns nothing
			if (not enabled and this.view().enableAgain()) then
				call this.view().setEnableAgain(false)
				call this.view().disable()
				call ResetToGameCameraForPlayer(this.player(), 0.0)
				call this.setCameraTimer.evaluate(true)
			elseif (enabled and not this.view().enableAgain()) then
				call this.setCameraTimer.evaluate(false)
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
					call Game.charactersScheme.evaluate().showForPlayer(this.player())
					call MultiboardSuppressDisplayForPlayer(this.player(), false)
				else
					call Game.charactersScheme.evaluate().hideForPlayer(this.player())
				endif
			endif
		endmethod

		/**
		* Hides characters scheme for characer's player if enabled.
		* \sa thistype#showCharactersScheme, thistype#setShowCharactersScheme, thistype#showCharactersSchemeToAll
		*/
		public method hideCharactersSchemeForPlayer takes nothing returns nothing
			if (this.showCharactersScheme()) then
				call Game.charactersScheme.evaluate().hideForPlayer(this.player())
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
		public method restoreUnit takes boolean disableInventory, boolean enableRucksackOnly returns boolean
			if (not this.hasRealSpellLevels()) then
				debug call Print("Has not been morphed before!")
				return false
			endif
			
			if (disableInventory) then
				debug call Print("Enabling inventory again")
				call this.inventory().setEnableAgain(true)
				call this.inventory().enable()
			elseif (enableRucksackOnly) then
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
		public method morph takes boolean disableInventory, boolean enableRucksackOnly returns boolean
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
			elseif (enableRucksackOnly) then
				// unequipping leads to melee unit, always!
				call this.inventory().enableOnlyRucksack(true)
			endif
			
			set this.m_isMorphed = true
			debug call this.print("MORPHED")
			
			return true
		endmethod
		
		public method setCameraDistance takes real cameraDistance returns nothing
			set this.m_cameraDistance = cameraDistance
			call SetCameraFieldForPlayer(this.player(), CAMERA_FIELD_TARGET_DISTANCE, this.m_cameraDistance, 0.0)
		endmethod
		
		public method cameraDistance takes nothing returns real
			return this.m_cameraDistance
		endmethod
		
		private static method timerFunctionCamera takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			if (not this.isViewEnabled() and AVideo.runningVideo() == 0 and not AGui.playerGui(this.player()).isShown() and AClassSelection.playerClassSelection(this.player()) == 0) then
				call SetCameraFieldForPlayer(this.player(), CAMERA_FIELD_TARGET_DISTANCE, this.m_cameraDistance, thistype.cameraTimerInterval)
			endif
		endmethod
		
		/**
		 * Enables or disables the camera timer which applies the custom camera distance.
		 * \param enabled If this value is true and the 3rd person view is not enbaled, the camera distance timer is started. Otherwise it is paused.
		 */
		public method setCameraTimer takes boolean enabled returns nothing
			if (enabled and this.isViewEnabled()) then
				return
			endif
			set this.m_cameraTimerEnabled = enabled
			if (enabled) then
				call TimerStart(this.m_cameraTimer, thistype.cameraTimerInterval, true, function thistype.timerFunctionCamera)
			else
				call PauseTimer(this.m_cameraTimer)
			endif
		endmethod
		
		/**
		 * The character crafts an item of item type \p itemTypeId which calls all registered \ref onCraftItemFunction() instances with .evaluate.
		 */
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

		/**
		 * Creates an item of type \p itemTypeId and adds it to the inventory of the character.
		 * Sets the owner of the item to the owner of the character.
		 */
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
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			return GetTriggerPlayer() == this.player() and ACharacter.playerCharacter(GetTriggerPlayer()).shrine() != 0
		endmethod

		private static method triggerActionWorker takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			//call ACharacter.playerCharacter(GetTriggerPlayer()).select()
			call SmartCameraPanWithZForPlayer(this.player(), GetDestructableX(this.shrine().destructable()), GetDestructableY(this.shrine().destructable()), 0.0, 0.0)
			call SelectUnitForPlayerSingle(this.unit(), this.player())
			debug call Print("Selected worker")
		endmethod
		
		private static method triggerConditionSpawnIllusion takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			
			return GetSummoningUnit() == this.unit() and IsUnitIllusion(GetSummonedUnit()) and not this.isMorphed()
		endmethod
		
		private static method triggerActionSpawnIllusion takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			debug call Print("Spawning illusion")
			call this.m_illusionOrderAnimations.pushBack(OrderAnimations.create(this, GetSummonedUnit()))
		endmethod
		
		private static method triggerConditionIllusionDies takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local AIntegerListIterator iterator = 0
			if (IsUnitIllusion(GetTriggerUnit())) then
				set iterator = this.m_illusionOrderAnimations.begin()
				loop
					exitwhen (not iterator.isValid())
					if (GetTriggerUnit() == OrderAnimations(iterator.data()).unit()) then
						debug call Print("Removing order for illusion")
						call OrderAnimations(iterator.data()).destroy()
						set iterator = this.m_illusionOrderAnimations.erase(iterator)
						exitwhen (true)
					endif
					call iterator.next()
				endloop
				call iterator.destroy()
			endif
			
			return false
		endmethod
		
		private static method chatEmote takes player whichPlayer, string message returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Player(i) != whichPlayer) then
					call DisplayTimedTextToPlayer(Player(i), 0.0, 0.0, 4.0, Format(message).p(whichPlayer).result())
				endif
				set i = i + 1
			endloop
		endmethod
		
		private static method triggerActionDance takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			if (not IsUnitDeadBJ(this.unit())) then
				if (GetEventPlayerChatString() == "-dance") then
					call thistype.chatEmote(GetTriggerPlayer(), tre("%1% tanzt.", "%1% is dancing"))
					call SetUnitAnimationByIndex(this.unit(), 187)
				elseif (GetEventPlayerChatString() == "-pray") then
					call thistype.chatEmote(GetTriggerPlayer(), tre("%1% betet.", "%1% is praying"))
					call SetUnitAnimationByIndex(this.unit(), 195)
				elseif (GetEventPlayerChatString() == "-magic") then
					call thistype.chatEmote(GetTriggerPlayer(), tre("%1% zaubert.", "%1% is using magic"))
					call SetUnitAnimationByIndex(this.unit(), GetRandomInt(85, 87))
				endif
			endif
		endmethod
		
		private static method triggerActionClear takes nothing returns nothing
			if (GetTriggerPlayer() == GetLocalPlayer()) then
				call ClearTextMessages()
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
			
			/*
			 * We need a larger distance since the Doodads are much bigger in this modification than in the usual Warcraft III.
			 */
			set this.m_cameraDistance = thistype.defaultCameraDistance // NOTE updated UI/MiscData.txt
			set this.m_cameraTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_cameraTimer, 0, this)
			set this.m_cameraTimerEnabled = false
			// dont start the timer since the character might be created during map initialization
			
			set this.m_orderAnimations = OrderAnimations.create(this, this.unit())
			set this.m_illusionOrderAnimations = AIntegerList.create()
			
			set this.m_spawnIllusionTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_spawnIllusionTrigger, EVENT_PLAYER_UNIT_SUMMON)
			call TriggerAddCondition(this.m_spawnIllusionTrigger, Condition(function thistype.triggerConditionSpawnIllusion))
			call TriggerAddAction(this.m_spawnIllusionTrigger, function thistype.triggerActionSpawnIllusion)
			call DmdfHashTable.global().setHandleInteger(this.m_spawnIllusionTrigger, 0, this)
			
			set this.m_illusionDiesTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_illusionDiesTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_illusionDiesTrigger, Condition(function thistype.triggerConditionIllusionDies))
			call DmdfHashTable.global().setHandleInteger(this.m_illusionDiesTrigger, 0, this)
			
			set this.m_danceTrigger = CreateTrigger()
			call TriggerRegisterPlayerChatEvent(this.m_danceTrigger, whichPlayer, "-", false)
			call TriggerAddAction(this.m_danceTrigger, function thistype.triggerActionDance)
			call DmdfHashTable.global().setHandleInteger(this.m_danceTrigger, 0, this)
			
			set this.m_clearTrigger = CreateTrigger()
			call TriggerRegisterPlayerChatEvent(this.m_clearTrigger, whichPlayer, "-clear", true)
			call TriggerAddAction(this.m_clearTrigger, function thistype.triggerActionClear)
			call DmdfHashTable.global().setHandleInteger(this.m_clearTrigger, 0, this)

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
			
			call PauseTimer(this.m_cameraTimer)
			call DmdfHashTable.global().destroyTimer(this.m_cameraTimer)
			set this.m_cameraTimer = null
			
			call this.m_orderAnimations.destroy()
			call this.m_illusionOrderAnimations.destroy()
			call DmdfHashTable.global().destroyTrigger(this.m_spawnIllusionTrigger)
			set this.m_spawnIllusionTrigger = null
			call DmdfHashTable.global().destroyTrigger(this.m_illusionDiesTrigger)
			set this.m_illusionDiesTrigger = null
			call DmdfHashTable.global().destroyTrigger(this.m_danceTrigger)
			set this.m_danceTrigger = null
			
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
library StructGameCharacter requires Asl, StructGameDmdfHashTable

	struct Character extends ACharacter
		// constant members
		public static constant real heroIconRefreshTime = 1.0
		// dynamic members
		private boolean m_isInPvp
		private boolean m_showCharactersScheme
		private boolean m_showCharacters
		private boolean m_showWorker
		// members
		private MainMenu m_mainMenu
static if (DMDF_CREDITS) then
		private Credits m_credits
endif
		private Grimoire m_grimoire
		private Tutorial m_tutorial
static if (DMDF_CHARACTER_STATS) then
		private CharacterStats m_characterStats
endif
static if (DMDF_INFO_LOG) then
		private InfoLog m_infoLog
endif
		private AIntegerVector m_classSpells /// Only \ref Spell instances not \ref ASpell instances!

		private trigger m_workerTrigger
		private AIntegerVector m_heroIcons
		private unit m_worker
		private integer m_morphAbilityId
		private boolean m_isMorphed

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

		public method setShowCharacters takes boolean showCharacters returns nothing
			local integer i
			set this.m_showCharacters = showCharacters
			set i = 0
			loop
				exitwhen (i == this.m_heroIcons.size())
				call AHeroIcon(this.m_heroIcons[i]).setEnabled(showCharacters)
				set i = i + 1
			endloop
		endmethod

		public method showCharacters takes nothing returns boolean
			return this.m_showCharacters
		endmethod

		public method setShowWorker takes boolean show returns nothing
			set this.m_showWorker = show
			call ShowUnit(this.m_worker, show)
		endmethod

		public method showWorker takes nothing returns boolean
			return this.m_showWorker
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

/// @todo static ifs do not prevent import of files, otherwise this wouldn't be required
		public method characterStats takes nothing returns CharacterStats
static if (DMDF_CHARACTER_STATS) then
			return this.m_characterStats
else
			return 0
endif
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
		
		/**
		 * \return Returns the stored hash table with ability id - level pairs (parent key - 0, child key - ability id, value - level).
		 * \sa Grimoire#spellLevels
		 */
		public method realSpellLevels takes nothing returns AHashTable
			return AHashTable(DmdfHashTable.global().handleInteger(this.unit(), "SpellLevels"))
		endmethod
		
		public method clearRealSpellLevels takes nothing returns boolean
			if (DmdfHashTable.global().hasHandleInteger(this.unit(), "SpellLevels")) then
				call this.realSpellLevels().destroy()
				call DmdfHashTable.global().removeHandleInteger(this.unit(), "SpellLevels")
				
				return true
			endif
			
			return false
		endmethod
		
		public method updateRealSpellLevels takes nothing returns nothing
			call this.clearRealSpellLevels()
			call DmdfHashTable.global().setHandleInteger(this.unit(), "SpellLevels", this.grimoire().spellLevels.evaluate())
		endmethod
		
		public method restoreRealSpellLevels takes nothing returns boolean
			if (DmdfHashTable.global().hasHandleInteger(this.unit(), "SpellLevels")) then
				call this.grimoire().readd.evaluate(this.realSpellLevels())
				
				return true
			endif
			
			return false
		endmethod
		
		public method isMorphed takes nothing returns boolean
			return this.m_isMorphed
		endmethod

		/**
		 * Restores spells and inventory of the character after he has been morphed into another creature with other abilities and without inventory.
		 * The spell levels has been stored in \ref realSpellLevels() while calling \ref morph().
		 * \note Has to be called just after the character's unit restores from morphing.
		 */
		public method restoreUnit takes integer abilityId returns boolean
			if (not DmdfHashTable.global().hasHandleInteger(this.unit(), "SpellLevels")) then
				debug call Print("Has not been morphed before!")
				return false
			endif
			if (abilityId != this.m_morphAbilityId) then
				debug call Print("Restoring from ability " + GetAbilityName(abilityId) + " while being morphed with ability " + GetAbilityName(this.m_morphAbilityId))
				return false
			endif
			debug call Print("Readding spell levels")
			call this.restoreRealSpellLevels()
			call this.clearRealSpellLevels()
			debug call Print("Enabling inventory again")
			call this.inventory().setEnableAgain(true)
			call this.inventory().enable()
			debug call Print("Restoring Grimoire UI")
			call this.grimoire().updateUi.evaluate()
			set this.m_isMorphed = false
			
			return true
		endmethod

		/**
		* When a character morphes there has to be some remorph functionality e. g. when the character dies and is being revived.
		* Besides he has to be restored when unmorphing (\ref Character#restoreUnit).
		* \note Has to be called just before the character's unit morphes.
		* \param abilityId Id of the ability which has to be casted to morph the character.
		*/
		public method morph takes integer abilityId returns boolean
			if (this.isMorphed()) then
				debug call Print("Morphing with ability: " + GetAbilityName(abilityId) + " is already morphed.")
			
				return false
			endif
		
			debug call Print("Morphing with ability: " + GetAbilityName(abilityId))
			
			debug if (GetUnitAbilityLevel(this.unit(), 'AInv') == 0) then
			debug call Print("It is too late to store the items! Add a delay for the morphing ability!")
			debug endif
			
			debug call Print("Storing spell levels")
			call this.updateRealSpellLevels()
			
			// Make sure it won't be enabled again when the character is set movable.
			call this.inventory().setEnableAgain(false)
			debug call Print("Disabling inventory")
			// Should remove but store all items.
			call this.inventory().disable()
			
			set this.m_isMorphed = true
			set this.m_morphAbilityId = abilityId
			
			return true
		endmethod

		private method displayQuestMessage takes integer messageType, string message returns nothing
			local force whichForce = GetForceOfPlayer(this.player())
			call QuestMessageBJ(whichForce, messageType, message)
			call DestroyForce(whichForce)
			set whichForce = null
		endmethod

		public method displayHint takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff00ff00TIPP|r - %1%")).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayUnitAcquired takes string unitName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_UNITACQUIRED, Format(tr("|cff87ceebNEUE EINHEIT ERHALTEN|r|n%1% - %2%")).s(unitName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayItemAcquired takes string itemName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_ITEMACQUIRED, Format(tr("|cff87ceebNEUEN GEGENSTAND ERHALTEN|r|n%1% - %2%")).s(itemName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method displayAbilityAcquired takes string abilityName, string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff87ceebNEUE FÄHIGKEIT ERHALTEN|r|n%1% - %2%")).s(abilityName).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		/// \todo How to display/format warnings?
		public method displayWarning takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_WARNING, Format(tr("%1%")).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questWarningSound)
		endmethod

		public method displayDifficulty takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff00ff00SCHWIERIGKEITSGRAD|r - %1%")).s(message).result())
		endmethod

		public method displayFinalLevel takes string message returns nothing
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff00ff00LETZTE STUFE|r - %1%")).s(message).result())
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
			call this.displayQuestMessage(bj_QUESTMESSAGE_HINT, Format(tr("|cff87ceebERFAHRUNGSBONUS ERHALTEN|r|n%1% - %2%")).i(xp).s(message).result())
			//call PlaySoundForPlayer(this.player(), bj_questHintSound)
		endmethod

		public method xpBonus takes integer xp, string message returns nothing
			call this.displayXPBonus(xp, message)
			call this.addExperience(xp, true)
		endmethod

		public method giveItem takes integer itemTypeId returns nothing
			local item whichItem = CreateItem(itemTypeId, GetUnitX(this.unit()), GetUnitY(this.unit()))
			call SetItemPlayer(whichItem, this.player(), true)
			call UnitAddItem(this.unit(), whichItem)
		endmethod

		/**
		* Makes item invulnerable, changes its owner to owner of character, makes it unpawnable and gives it to the character automatically.
		*/
		public method giveQuestItem takes integer itemTypeId returns nothing
			local item whichItem = CreateItem(itemTypeId, GetUnitX(this.unit()), GetUnitY(this.unit()))
			call SetItemPawnable(whichItem, false)
			call SetItemInvulnerable(whichItem, true)
			call SetItemPlayer(whichItem, this.player(), true)
			call UnitAddItem(this.unit(), whichItem)
		endmethod

		public method createHeroIcons takes nothing returns nothing
			local integer i
			if (this.m_heroIcons != 0 or GetPlayerController(this.player()) == MAP_CONTROL_COMPUTER) then // don't create for computer controlled players
				return
			endif
			set this.m_heroIcons = AIntegerVector.createWithSize(Game.playingPlayers.evaluate(), 0)
			set i = 0
			loop
				exitwhen (i == this.m_heroIcons.size())
				if (i != GetPlayerId(this.player())) then
					set this.m_heroIcons[i] = AHeroIcon.create(thistype.playerCharacter(Player(i)).unit(), this.player(), thistype.heroIconRefreshTime, GetRectCenterX(gg_rct_character), GetRectCenterY(gg_rct_character), 0.0)
				endif
				set i = i + 1
			endloop
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

		private method createWorkerTrigger takes nothing returns nothing
			set this.m_worker = CreateUnit(this.player(), MapData.workerUnitTypeId, GetRectCenterX(gg_rct_worker), GetRectCenterY(gg_rct_worker), 0.0)
			// Do not hide and pause!
			//call PauseUnit(this.m_worker, true)
			call SetUnitInvulnerable(this.m_worker, true)
			call SetUnitPathing(this.m_worker, false)
			//call ShowUnit(this.m_worker, false)
			set this.m_workerTrigger = CreateTrigger()
			call TriggerRegisterUnitEvent(this.m_workerTrigger, this.m_worker, EVENT_UNIT_SELECTED)
			call TriggerAddCondition(this.m_workerTrigger, Condition(function thistype.triggerConditionWorker))
			call TriggerAddAction(this.m_workerTrigger, function thistype.triggerActionWorker)
			call DmdfHashTable.global().setHandleInteger(this.m_workerTrigger, "this", this)
		endmethod

		public static method create takes player whichPlayer, unit whichUnit returns thistype
			local thistype this = thistype.allocate(whichPlayer, whichUnit)
			// dynamic members
			set this.m_isInPvp = false
			set this.m_showCharactersScheme = false
			set this.m_showCharacters = true
			set this.m_showWorker = true
			// members
			set this.m_mainMenu = MainMenu.create.evaluate(this)
static if (DMDF_CREDITS) then
			set this.m_credits = Credits.create.evaluate(this)
endif
			set this.m_grimoire = Grimoire.create.evaluate(this)
			set this.m_tutorial = Tutorial.create.evaluate(this)
static if (DMDF_CHARACTER_STATS) then
			set this.m_characterStats = CharacterStats.create.evaluate(this)
endif
static if (DMDF_INFO_LOG) then
			set this.m_infoLog = InfoLog.create.evaluate(this)
endif

			set this.m_classSpells = AIntegerVector.create()
			set this.m_heroIcons = 0
			call this.createWorkerTrigger()
			set this.m_isMorphed = false

			return this
		endmethod

		private method destroyHeroIcons takes nothing returns nothing
			if (this.m_heroIcons == 0) then
				return
			endif
			loop
				exitwhen (this.m_heroIcons.empty())
				call AHeroIcon(this.m_heroIcons.back()).destroy()
				call this.m_heroIcons.popBack()
			endloop
			call this.m_heroIcons.destroy()
		endmethod

		private method destroyWorkerTrigger takes nothing returns nothing
			call RemoveUnit(this.m_worker)
			set this.m_worker = null
			call DmdfHashTable.global().destroyTrigger(this.m_workerTrigger)
			set this.m_workerTrigger = null
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_mainMenu.destroy.evaluate()
static if (DMDF_CREDITS) then
			call this.m_grimoire.destroy.evaluate()
endif
			call this.m_tutorial.destroy.evaluate()
static if (DMDF_CHARACTER_STATS) then
			call this.m_characterStats.destroy.evaluate()
endif
static if (DMDF_INFO_LOG) then
			call this.m_infoLog.destroy.evaluate()
endif
			call this.m_classSpells.destroy()
			set this.m_classSpells = 0
			call this.destroyHeroIcons()
			call this.destroyWorkerTrigger()
		endmethod

		public static method createHeroIconsForAll takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (thistype.playerCharacter(Player(i)) != 0) then
					call thistype(thistype.playerCharacter(Player(i))).createHeroIcons()
				endif
				set i = i + 1
			endloop
		endmethod

		public static method attributesStartBonus takes nothing returns integer
			return Game.missingPlayers.evaluate() * MapData.difficultyStartAttributeBonus
		endmethod

		public static method attributesLevelBonus takes nothing returns integer
			return Game.missingPlayers.evaluate() * MapData.difficultyLevelAttributeBonus
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
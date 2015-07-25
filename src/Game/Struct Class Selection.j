library StructGameClassSelection requires Asl, StructGameClasses, StructGameCharacter, StructGameGrimoire, Spells, StructMapMapMapData

	/**
	 * Class selection allows change of class through abilities of the unit as well as displaying
	 * all available class spells in a spell book.
	 * Besides it adds start items to the corresponding class.
	 *
	 * This advanced class selection therefore allows the user to get much more information about the selected class.
	 * Fore safety it displays a confirmation dialog when selecting the class.
	 */
	struct ClassSelection extends AClassSelection
		public static constant integer spellsPerPage = 9
		public static constant real infoDuration = 40.0
		private trigger m_classChangeTrigger
		private integer m_page = 0
		private trigger m_spellPagesTrigger
		
		/**
		 * Displays message \p message to all players except \p excludingPlayer for \p time seconds.
		 */
		public static method displayMessageToAllPlayingUsers takes real time, string message, player excludingPlayer returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (GetPlayerSlotState(Player(i)) != PLAYER_SLOT_STATE_EMPTY and GetPlayerController(Player(i)) == MAP_CONTROL_USER and Player(i) != excludingPlayer) then
					call DisplayTimedTextToPlayer(Player(i), 0.0, 0.0, time, message)
				endif
				set i = i + 1
			endloop
		endmethod
		
		public stub method onSelectClass takes Character character, AClass class, boolean last returns nothing
			local integer i
			local integer j
			/**
			 * Create all spells depending on the selected class.
			 */
			// cleric spells
			if (class == Classes.cleric()) then
				// deprecated
				//call SpellAstralSource.create(character)
				call SpellMaertyrer.create(character)
				call SpellAbatement.create(character)
				call SpellBlind.create(character)
				call SpellClarity.create(character)
				call SpellHolyPower.create(character)
				call SpellImpendingDisaster.create(character)
				call SpellPreventIll.create(character)
				call SpellProtect.create(character)
				call SpellRecovery.create(character)
				call SpellRevive.create(character)
				// deprecated
				//call SpellTorment.create(character)
				call SpellBlessing.create(character)
				call SpellConversion.create(character)
				call SpellGodsFavor.create(character)
				
				// ultimates on page 2
				call SpellExorcizeEvil.create(character)
				call SpellHolyWill.create(character)
			elseif (class == Classes.necromancer()) then
				call SpellAncestorPact.create(character)
				call SpellConsume.create(character)
				call SpellDarkServant.create(character)
				call SpellDarkSpell.create(character)
				call SpellDeathHerald.create(character)
				call SpellDemonServant.create(character)
				call SpellSoulThievery.create(character)
				// deprecated
				//call SpellViolentDeath.create(character)
				call SpellWorldsPortal.create(character)
				call SpellNecromancy.create(character)
				call SpellPlague.create(character)
				call SpellParasite.create(character)
				call SpellMasterOfNecromancy.create(character)
				call SpellEpidemic.create(character)
			elseif (class == Classes.druid()) then
				call SpellAwakeningOfTheForest.create(character)
				call SpellCrowForm.create(character)
				call SpellDryadSource.create(character)
				call SpellBearForm.create(character)
				call SpellForestFaeriesSpell.create(character)
				call SpellHerbalCure.create(character)
				call SpellRelief.create(character)
				call SpellZoology.create(character)
				call SpellGrove.create(character)
				call SpellTreefolk.create(character)
				call SpellForestWoodFists.create(character)
				call SpellTendrils.create(character)
				call SpellWrathOfTheForest.create(character)
				call SpellForestCastle.create(character)
				call SpellAlpha.create(character)
			elseif (class == Classes.knight()) then
				call SpellBlock.create(character)
				call SpellConcentration.create(character)
				call SpellLivingWill.create(character)
				call SpellResolution.create(character)
				call SpellRigidity.create(character)
				call SpellRush.create(character)
				call SpellSelflessness.create(character)
				call SpellStab.create(character)
				call SpellTaunt.create(character)
				call SpellAuraOfRedemption.create(character)
				call SpellAuraOfAuthority.create(character)
				call SpellAuraOfIronSkin.create(character)
			elseif (class == Classes.dragonSlayer()) then
				call SpellBeastHunter.create(character)
				call SpellDaunt.create(character)
				call SpellFuriousBloodthirstiness.create(character)
				call SpellSlash.create(character)
				call SpellSupremacy.create(character)
				call SpellWeakPoint.create(character)
				call SpellColossus.create(character)
			elseif (class == Classes.ranger()) then
				call SpellAgility.create(character)
				call SpellEagleEye.create(character)
				call SpellHailOfArrows.create(character)
				call SpellLieInWait.create(character)
				call SpellShooter.create(character)
				call SpellShotIntoHeart.create(character)
				call SpellSprint.create(character)
				call SpellPoisonedArrows.create(character)
				call SpellBurningArrows.create(character)
				call SpellFrozenArrows.create(character)
			elseif (class == Classes.elementalMage()) then
				call SpellBlaze.create(character)
				call SpellEarthPrison.create(character)
				call SpellElementalForce.create(character)
				call SpellEmblaze.create(character)
				call SpellFireMissile.create(character)
				call SpellFreeze.create(character)
				call SpellGlisteningLight.create(character)
				call SpellIceMissile.create(character)
				call SpellInferno.create(character)
				call SpellLightning.create(character)
				call SpellMastery.create(character)
				call SpellRageOfElements.create(character)
				call SpellPureEnergy.create(character)
				call SpellTeleportation.create(character)
				call SpellUndermine.create(character)
			elseif (class == Classes.wizard()) then
				call SpellAbsorbation.create(character)
				//deprecated call SpellAdduction.create(character)
				//deprecated call SpellArcaneBinding.create(character)
				call SpellArcaneHunger.create(character)
				call SpellArcaneProtection.create(character)
				call SpellArcaneRuse.create(character)
				call SpellArcaneTime.create(character)
				call SpellBan.create(character)
				call SpellControlledTimeFlow.create(character)
				call SpellCurb.create(character)
				call SpellFeedBack.create(character)
				call SpellMagicalShockWaves.create(character)
				call SpellManaExplosion.create(character)
				call SpellManaShield.create(character)
				call SpellManaStream.create(character)
				call SpellMultiply.create(character)
				call SpellTransfer.create(character)
				// deprecated call SpellRepulsion.create(character)
			endif
			
			// evaluate this calls since it may exceed the operations limit. Each time a spell is being added it updates the whole grimoire UI which takes many operations.
			call character.grimoire().addClassSpellsFromCharacter.evaluate(character)
			

			call SpellCowNova.create(character) /// @todo test

			call initCharacterSpells(character)
			call MapData.createClassItems(class, character.unit())
			call character.setMovable(false)
			call character.revival().setTime(MapData.revivalTime)
			//call SetUserInterfaceForPlayer(character.player(), false, false)
			//call CameraSetupApplyForPlayer(false, gg_cam_class_selection, character.player(), 0.0)
			call MapData.setCameraBoundsToPlayableAreaForPlayer(character.player())
			call character.panCamera()
			call thistype.displayMessageToAllPlayingUsers(bj_TEXT_DELAY_HINT, Format(tre("%s hat die Klasse \"%s\" gewählt.", "%s has choosen the class \"%s\".")).s(character.name()).s(GetUnitName(character.unit())).result(), character.player())
			
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (i != GetPlayerId(this.player())) then
					if (GetPlayerController(this.player()) == MAP_CONTROL_USER and GetPlayerSlotState(this.player()) == PLAYER_SLOT_STATE_PLAYING) then
						call SetPlayerAllianceStateBJ(this.player(), Player(i), bj_ALLIANCE_ALLIED_VISION)
					else
						call SetPlayerAllianceStateBJ(this.player(), Player(i), bj_ALLIANCE_ALLIED_ADVUNITS)
					endif
				endif
				set i = i + 1
			endloop
			
			/*
			 * Add hero glow.
			 */
			call UnitAddAbility(character.unit(), 'A13E')
			call UnitMakeAbilityPermanent(character.unit(), true, 'A13E')
			
			if (not last) then
				debug call Print("Do not start the game")
				call character.displayMessage(ACharacter.messageTypeInfo, tre("Warten Sie bis alle anderen Spieler ihre Klasse gewählt haben.", "Wait until all other players have choosen their class."))
			else
				debug call Print("Start game")
				call thistype.endTimer()
				 call Game.start.execute()
			endif
		endmethod
		
		public stub method onCharacterCreation takes AClassSelection classSelection, unit whichUnit returns ACharacter
			return Character.create(classSelection.player(), whichUnit)
		endmethod
		
		public stub method onCreate takes unit whichUnit returns nothing
			local integer i
			// remove standard abilities
			call UnitRemoveAbility(whichUnit, 'AInv')
			call UnitRemoveAbility(whichUnit, 'A02Z')
			call UnitRemoveAbility(whichUnit, 'A015')
			call UnitRemoveAbility(whichUnit, 'A0AP')
		
			// inventory
			call UnitAddAbility(whichUnit, 'A0R3')
		
			/*
			 * Adds the start items of the current class to the inventory.
			 * This helps to inform the player about start items since he can see them but not use them.
			 * The inventory ability should not allow to drop any of the items nor to use them.
			 */
			call MapData.createClassItems(this.class(), whichUnit)
			
			// change classes and select class
			call UnitAddAbility(whichUnit, 'A0NB')
			call UnitAddAbility(whichUnit, 'A0R0')
			// select class
			call UnitAddAbility(whichUnit, 'A0R1')
			// grimoire
			call UnitAddAbility(whichUnit, 'A0R2')
			
			// remove shared vision
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call SetPlayerAllianceStateBJ(this.player(), Player(i), bj_ALLIANCE_UNALLIED)
				set i = i + 1
			endloop
			
			/*
			 * Adds all class grimoire spells of the first grimoire page.
			 */
			set this.m_page = 0
			call Classes.createClassAbilities(this.class(), whichUnit, this.m_page, thistype.spellsPerPage)
		endmethod
		
		/*
		 * If a player leaves during the class selection it must be made sure that if he is the last player the game starts immediately.
		 * Otherwise it would never start because of one leaving player.
		 */
		public stub method onPlayerLeaves takes player whichPlayer, boolean last returns nothing
			if (last) then
				call Game.start.execute()
			endif
		endmethod
		
		private static method triggerConditionChange takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() == this.classUnit() and (GetSpellAbilityId() == 'A0R0' or GetSpellAbilityId() == 'A0NB' or GetSpellAbilityId() == 'A0R1')
		endmethod
		
		/**
		 * Confirms the class selection and actually selects the class.
		 */
		private static method dialogButtonActionSelectClass takes ADialogButton dialogButton returns nothing
			local thistype this = AClassSelection.playerClassSelection(dialogButton.dialog().player())
			call this.selectClass()
		endmethod
		
		private static method triggerActionChange takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			if (GetSpellAbilityId() == 'A0NB') then
				call this.changeToNext()
			elseif (GetSpellAbilityId() == 'A0R0') then
				call this.changeToPrevious()
			/*
			 * Select class.
			 */
			elseif (GetSpellAbilityId() == 'A0R1') then
				/*
				 * Pop up a confirmation dialog in case the player selected a class by mistake.
				 */
				call AGui.playerGui(this.player()).dialog().clear()
				call AGui.playerGui(this.player()).dialog().setMessage(tre("Klasse auswählen?", "Choose class?"))
				call AGui.playerGui(this.player()).dialog().addDialogButtonIndex(tre("OK", "OK"), thistype.dialogButtonActionSelectClass)
				call AGui.playerGui(this.player()).dialog().addSimpleDialogButtonIndex(tre("Abbrechen", "Cancel"))
				call AGui.playerGui(this.player()).dialog().show()
			endif
		endmethod
		
		private static method triggerConditionChangeSpellsPage takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() == this.classUnit() and (GetSpellAbilityId() == Classes.classAbilitiesNextPageAbilityId() or GetSpellAbilityId() == Classes.classAbilitiesPreviousPageAbilityId())
		endmethod
		
		private static method triggerActionChangeSpellsPage takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			
			if (GetSpellAbilityId() == Classes.classAbilitiesNextPageAbilityId()) then
				if (this.m_page == Classes.maxClassAbilitiesPages(this.class(), thistype.spellsPerPage) - 1) then
					set this.m_page = 0
				else
					set this.m_page = this.m_page + 1
				endif
			elseif (GetSpellAbilityId() == Classes.classAbilitiesPreviousPageAbilityId()) then
				if (this.m_page == 0) then
					set this.m_page = Classes.maxClassAbilitiesPages(this.class(), thistype.spellsPerPage) - 1
				else
					set this.m_page = this.m_page - 1
				endif
			endif
			
			call Classes.createClassAbilities(this.class(), this.classUnit(), this.m_page, thistype.spellsPerPage)
			call ForceUIKeyBJ(GetTriggerPlayer(), "Z") // WORKAROUND: whenever an ability is being removed it closes grimoire
		endmethod
		
		public static method create takes player user returns thistype
			local thistype this = thistype.allocate(user)
			
			set this.m_classChangeTrigger = CreateTrigger()
			call TriggerRegisterPlayerUnitEvent(this.m_classChangeTrigger, user, EVENT_PLAYER_UNIT_SPELL_CHANNEL, null)
			call TriggerAddCondition(this.m_classChangeTrigger, Condition(function thistype.triggerConditionChange))
			call TriggerAddAction(this.m_classChangeTrigger, function thistype.triggerActionChange)
			call DmdfHashTable.global().setHandleInteger(this.m_classChangeTrigger, "this", this)
			
			set this.m_spellPagesTrigger = CreateTrigger()
			call TriggerRegisterPlayerUnitEvent(this.m_spellPagesTrigger, user, EVENT_PLAYER_UNIT_SPELL_CHANNEL, null)
			call TriggerAddCondition(this.m_spellPagesTrigger, Condition(function thistype.triggerConditionChangeSpellsPage))
			call TriggerAddAction(this.m_spellPagesTrigger, function thistype.triggerActionChangeSpellsPage)
			call DmdfHashTable.global().setHandleInteger(this.m_spellPagesTrigger, "this", this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_classChangeTrigger)
			set this.m_classChangeTrigger = null
			call DmdfHashTable.global().destroyTrigger(this.m_spellPagesTrigger)
			set this.m_spellPagesTrigger = null
		endmethod
		
		/**
		 * Initializes and shows the class selection to all playing players even computer players. 
		 *
		 * Since \ref AClassSelection.init is called which creates a multiboard, this method
		 * mustn't be called during map initialization beside you use a \ref TriggerSleepAction call.
		 */
		public static method showClassSelection takes nothing returns nothing
			local ClassSelection classSelection
			local integer i
			local player whichPlayer

			call AClassSelection.init(gg_cam_class_selection, false, GetRectCenterX(gg_rct_class_selection), GetRectCenterY(gg_rct_class_selection), 270.0, 0.01, 2.0, Classes.cleric(), Classes.wizard(), "UI\\Widgets\\Console\\Human\\infocard-heroattributes-str.blp", "UI\\Widgets\\Console\\Human\\infocard-heroattributes-agi.blp", "UI\\Widgets\\Console\\Human\\infocard-heroattributes-int.blp", tre("%s (%i/%i)", "%s (%i/%i)"), tre("Stärke pro Stufe: %r", "Strength per level: %r"), tre("Geschick pro Stufe: %r", "Dexterity per level: %r"), tre("Wissen pro Stufe: %r", "Lore per level: %r"))

			call SuspendTimeOfDay(true)
			call SetTimeOfDay(0.0)
			call ForceCinematicSubtitles(true)
			call Game.setMapMusic("Music\\CharacterSelection.mp3")

			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set whichPlayer = Player(i)

				if (GetPlayerSlotState(whichPlayer) != PLAYER_SLOT_STATE_EMPTY) then
					set classSelection = ClassSelection.create(whichPlayer)
					call classSelection.setStartX(MapData.startX(i))
					call classSelection.setStartY(MapData.startY(i))
					call classSelection.setStartFacing(0.0)
					call classSelection.setShowAttributes(true)
					call classSelection.enableArrowKeySelection(false)
					call classSelection.enableEscapeKeySelection(false)
					call classSelection.show()
				endif

				set whichPlayer = null
				set i = i + 1
			endloop
			
			debug call Print("Starting timer")
			call ClassSelection.startTimer(tr("Klassenauswahl:"), 120.0)
			
			/*
			 * Wait until players are ready to realize.
			 * Then display informations about how to select the class as long as possible to keep players informed.
			 */
			call TriggerSleepAction(4.0)
			call thistype.displayMessageToAllPlayingUsers(thistype.infoDuration, tre("Wählen Sie zunächst Ihre Charakterklasse aus. Diese Auswahl ist für die restliche Spielzeit unwiderruflich!", "Choose your character class first. This selection is irrevocable for the rest of the game."), null)
			call thistype.displayMessageToAllPlayingUsers(thistype.infoDuration, tre("- Drücken Sie die Pfeilsymbole rechts unten, um die angezeigte Charakterklasse zu wechseln.", "- Press the arrow key icons at the bottom right to change the shown character class."), null)
			call thistype.displayMessageToAllPlayingUsers(thistype.infoDuration, tre("- Drücken Sie das Charaktersymbol rechts unten, um die angezeigte Charakterklasse auszuwählen.", "- Press the character icon at the bottom right to select the shown character class."), null)
			call thistype.displayMessageToAllPlayingUsers(thistype.infoDuration, tre("- Auf dem Zauberbuchsymbol rechts unten, können die Klassenzauber betrachtet werden.", "- At the grimoire icon at the bottom right the class spells can be viewed."), null)
			call thistype.displayMessageToAllPlayingUsers(thistype.infoDuration, tre("- Im Inventar befinden sich die Anfangsgegenstände der Klasse.", "- In the inventory are the start items of the class."), null)
		endmethod
		
	endstruct

endlibrary
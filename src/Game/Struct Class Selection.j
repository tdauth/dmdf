library StructGameClassSelection requires Asl, StructGameClasses, StructGameCharacter, StructGameGrimoire, Spells, StructMapMapMapData

	/**
	 * Class selection allows change of class through abilities of the unit as well as displaying
	 * all available class spells in a spell book.
	 * Besides it adds start items to the corresponding class.
	 */
	struct ClassSelection extends AClassSelection
		public static constant integer maxPages = 2
		private trigger m_classChangeTrigger
		private integer m_spellPage = 0
		private trigger m_spellPagesTrigger
		
		public stub method onSelectClass takes Character character, AClass class, boolean last returns nothing
			/**
			 * Create all class spells for each character in debug mode.
			 */
			// cleric spells
			if (class == Classes.cleric()) then
				call SpellAstralSource.create(character)
				call SpellMaertyrer.create(character)
				call SpellAbatement.create(character)
				call SpellBlind.create(character)
				call SpellClarity.create(character)
				call SpellExorcizeEvil.create(character)
				call SpellHolyPower.create(character)
				call SpellHolyWill.create(character)
				call SpellImpendingDisaster.create(character)
				call SpellPreventIll.create(character)
				call SpellProtect.create(character)
				call SpellRecovery.create(character)
				call SpellRevive.create(character)
				call SpellTorment.create(character)
				call SpellBlessing.create(character)
				call SpellConversion.create(character)
				call SpellGodsFavor.create(character)
			elseif (class == Classes.necromancer()) then
				call SpellAncestorPact.create(character)
				call SpellConsume.create(character)
				call SpellDarkServant.create(character)
				call SpellDarkSpell.create(character)
				call SpellDeathHerald.create(character)
				call SpellDemonServant.create(character)
				call SpellSoulThievery.create(character)
				call SpellViolentDeath.create(character)
				call SpellWorldsPortal.create(character)
				call SpellNecromancy.create(character)
				call SpellPlague.create(character)
				call SpellParasite.create(character)
				call SpellMasterOfNecromancy.create(character)
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
				call SpellRigidity.create(character)
				call SpellRush.create(character)
				call SpellSelflessness.create(character)
				call SpellStab.create(character)
				call SpellTaunt.create(character)
				call SpellAuraOfRedemption.create(character)
				call SpellAuraOfAuthority.create(character)
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
				debug call Print("Before Pure Energy")
				call SpellPureEnergy.create(character)
				debug call Print("Before Teleportation")
				call SpellTeleportation.create(character)
				debug call Print("Before Undermine")
				call SpellUndermine.create(character)
			elseif (class == Classes.wizard()) then
				call SpellAbsorbation.create(character)
				call SpellAdduction.create(character)
				call SpellArcaneBinding.create(character)
				call SpellArcaneHunger.create(character)
				call SpellArcaneProtection.create(character)
				call SpellArcaneRuse.create(character)
				call SpellArcaneTime.create(character)
				call SpellBan.create(character)
				call SpellControlledTimeFlow.create(character)
				call SpellCurb.create(character)
				call SpellMagicalShockWaves.create(character)
				call SpellManaExplosion.create(character)
				call SpellManaShield.create(character)
				call SpellManaStream.create(character)
				call SpellRepulsion.create(character)
			endif
			
			debug if (class != character.class()) then
			debug call Print("Error!!!!!!!!!!!!")
			debug return
			debug endif
			
			// evaluate this calls since it may exceed the operations limit. Each time a spell is being added it updates the whole grimoire UI which takes many operations.
			// TODO add spells without massive UI updates to improve the performance.
			call character.grimoire().addClassSpellsFromCharacter.evaluate(character)
			
			debug call Print("Added class spells for class " + I2S(class))
			debug call Print("Druid class is " + I2S(Classes.druid()))
			debug if (IsUnitPaused(character.unit())) then
			debug call Print("Character is already paused!")
			debug endif

			call SpellCowNova.create(character) /// @todo test

			call MapData.createClassItems(class, character.unit())
			call character.setMovable(false)
			call character.revival().setTime(MapData.revivalTime)
			call SetUserInterfaceForPlayer(character.player(), false, false)
			call CameraSetupApplyForPlayer(false, gg_cam_class_selection, character.player(), 0.0)
			call MapData.setCameraBoundsToPlayableAreaForPlayer(character.player())
			call Classes.displayMessageToAllPlayingUsers(bj_TEXT_DELAY_HINT, StringArg(StringArg(tr("%s hat die Klasse \"%s\" gewählt."), character.name()), GetUnitName(character.unit())), character.player())
			if (not last) then
				debug call Print("Do not start the game")
				call character.displayMessage(ACharacter.messageTypeInfo, tr("Warten Sie bis alle anderen Spieler ihre Klasse gewählt haben."))
			else
				debug call Print("Start game")
				 call Game.start.execute()
			endif
		endmethod
		
		public stub method onCharacterCreation takes AClassSelection classSelection, unit whichUnit returns ACharacter
			return Character.create(classSelection.player(), whichUnit)
		endmethod
		
		public stub method onCreate takes unit whichUnit returns nothing
			// remove standard abilities
			call UnitRemoveAbility(whichUnit, 'AInv')
			call UnitRemoveAbility(whichUnit, 'A02Z')
			call UnitRemoveAbility(whichUnit, 'A015')
			call UnitRemoveAbility(whichUnit, 'A0AP')
		
			// inventory
			call UnitAddAbility(whichUnit, 'A0R3')
		
			call MapData.createClassItems(this.class(), whichUnit)
			
			// change classes and select class
			call UnitAddAbility(whichUnit, 'A0NB')
			call UnitAddAbility(whichUnit, 'A0R0')
			call UnitAddAbility(whichUnit, 'A0R1')
			// grimoire
			call UnitAddAbility(whichUnit, 'A0R2')
			// TODO add two abilities two change the grimoire pages
			// TODO add trigger which handles the grimoire pages change
			
			call Classes.createClassAbilities(this.class(), whichUnit)
		endmethod
		
		public stub method onPlayerLeaves takes player whichPlayer, boolean last returns nothing
			if (last) then
				call Game.start.execute()
			endif
		endmethod
		
		private static method triggerConditionChange takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			return GetTriggerUnit() == this.classUnit() and (GetSpellAbilityId() == 'A0R0' or GetSpellAbilityId() == 'A0NB' or GetSpellAbilityId() == 'A0R1')
		endmethod
		
		private static method triggerActionChange takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			if (GetSpellAbilityId() == 'A0NB') then
				call this.changeToNext()
			elseif (GetSpellAbilityId() == 'A0R0') then
				call this.changeToPrevious()
			elseif (GetSpellAbilityId() == 'A0R1') then
				call this.selectClass()
			endif
		endmethod
		
		public static method create takes player user returns thistype
			local thistype this = thistype.allocate(user)
			
			set this.m_classChangeTrigger = CreateTrigger()
			call TriggerRegisterPlayerUnitEvent(this.m_classChangeTrigger, user, EVENT_PLAYER_UNIT_SPELL_CHANNEL, null)
			call TriggerAddCondition(this.m_classChangeTrigger, Condition(function thistype.triggerConditionChange))
			call TriggerAddAction(this.m_classChangeTrigger, function thistype.triggerActionChange)
			call DmdfHashTable.global().setHandleInteger(this.m_classChangeTrigger, "this", this)
			
			return this
		endmethod
		
	endstruct

endlibrary
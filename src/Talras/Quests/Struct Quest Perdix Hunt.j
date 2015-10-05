library StructMapQuestsQuestPerdixHunt requires Asl, StructGameCharacter

	private struct HuntTimer
		public static constant real time = 30.0
		private player m_player
		private timer m_timer
		private timerdialog m_timerDialog
		private unit m_unit
		
		private static method timerFunction takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this")
			
			call RemoveUnit(this.m_unit)
			set this.m_unit = null
			
			call QuestPerdixHunt.characterQuest.evaluate(ACharacter.playerCharacter(this.m_player)).displayUpdateMessage(tr("Das Rebhuhn ist weggeflogen!"))
			
			call this.destroy()
			
		endmethod
		
		public static method create takes player whichPlayer, unit whichUnit returns thistype
			local thistype this = thistype.allocate()
			set this.m_timer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_timer, "this", this)
			call TimerStart(this.m_timer, thistype.time, false, function thistype.timerFunction)
			set this.m_timerDialog = CreateTimerDialog(this.m_timer)
			call TimerDialogSetTitle(this.m_timerDialog, tr("Zeit bis das Rebhuhn wegfliegt"))
			call TimerDialogDisplayForPlayerBJ(true, this.m_timerDialog, whichPlayer)
			set this.m_unit = whichUnit
			set this.m_player = whichPlayer
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call DestroyTimerDialog(this.m_timerDialog)
			set this.m_timerDialog = null
			call PauseTimer(this.m_timer)
			call DmdfHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
			set this.m_unit = null
			set this.m_player = null
		endmethod
	endstruct

	struct QuestPerdixHunt extends AQuest
		public static integer maxAnimals = 5
		private integer m_counter
		private trigger m_hintTrigger

		implement CharacterQuest
		
		private static method triggerConditionHint takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this"))
			if (GetTriggerUnit() == this.character().unit()) then
				call Character(this.character()).displayHint(tr("In diesem Gebiet befinden sich Rebhühner."))
			endif
		
			return false
		endmethod

		public stub method enable takes nothing returns boolean
			set this.m_hintTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_hintTrigger, gg_rct_quest_perdix_hunt)
			call TriggerAddCondition(this.m_hintTrigger, Condition(function thistype.triggerConditionHint))
			call DmdfHashTable.global().setHandleInteger(this.m_hintTrigger, "this", this)
			
			return super.enable()
		endmethod
		
		private static method stateEventCompletedHunt takes AQuestItem questItem, trigger whichTrigger returns nothing
			call TriggerRegisterAnyUnitEventBJ(whichTrigger, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
		
		private static method stateConditionCompletedHunt takes AQuestItem questItem returns boolean
			local thistype this = thistype(questItem.quest())
			local unit animal
			/*
			 * Run the quest only for the current character.
			 * Otherwise animal will be spawned twice etc.
			 */
			if (GetOwningPlayer(GetTriggerUnit()) == this.character().player()) then
				// Wild aufspüren
				if (GetSpellAbilityId() == 'A17E') then
					if (RectContainsUnit(gg_rct_quest_perdix_hunt, GetTriggerUnit())) then
						if (GetRandomInt(0, 100) <= 80) then
							set animal = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), 'n04N', GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 0.0)
							call DmdfHashTable.global().setHandleInteger(animal, "timer", HuntTimer.create(this.character().player(), animal))
							call this.displayUpdateMessage(tr("Scheuche das Rebhuhn auf!"))
						else
							call this.displayUpdateMessage(tr("Kein Wild aufgespürt. Versuche es noch einmal."))
						endif
					else
						call this.displayUpdateMessage(tr("Kein Wild aufgespürt. Hier scheint es keine Rebhühner zu geben. Versuche es woanders."))
					endif
				// Wild aufscheuchen
				elseif (GetSpellAbilityId() == 'A17F') then
					if (GetUnitTypeId(GetSpellTargetUnit()) == 'n04N') then
						call IssueImmediateOrder(GetSpellTargetUnit(), "ravenform") // abheben
						call this.displayUpdateMessage(tr("Greife das Rebhuhn mit dem Jagdfalken!"))
					endif
				// Wild greifen
				elseif (GetSpellAbilityId() == 'A17G') then
					if (GetUnitTypeId(GetSpellTargetUnit()) == 'n04O') then
						call HuntTimer(DmdfHashTable.global().handleInteger(GetSpellTargetUnit(), "timer")).destroy()
						call DmdfHashTable.global().destroyUnit(GetSpellTargetUnit())
						
						call Character(this.character()).giveQuestItem('I059')
						
						set this.m_counter = this.m_counter + 1
						
						call this.displayUpdateMessage(Format(tr("%1%/%2% Rebhühnern.")).i(this.m_counter).i(thistype.maxAnimals).result())
						
						return this.m_counter == thistype.maxAnimals
					endif
				endif
			endif
			
			return false
		endmethod
		
		private static method stateActionCompletedHunt takes AQuestItem questItem returns nothing
			local thistype this = thistype(questItem.quest())
			call DmdfHashTable.global().destroyTrigger(this.m_hintTrigger)
			set this.m_hintTrigger = null
			call this.displayUpdate()
		endmethod

		private static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, tr("Rebhuhnjagd"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNWarEagle.blp")
			call this.setDescription(tr("Der Jäger Björn aus Talras benötigt Rebhühner für den Herzog Heimrich. Um Rebhühner zu jagen braucht man einen Vorstehhund und einen Jagdfalken. Der Vorstehhund muss das Rebhuhn aufspüren und der Falke muss darüber abwarten. Sobald der Vorstehhund das Rebhuhn aufgescheucht hat und es losfliegt, stürzt der Falke sich darauf. Rebhühner befinden sich meist auf der Wiese neben dem Friedhof beim Bauernhof."))
			call this.setReward(AAbstractQuest.rewardExperience, 400)
			call this.setReward(AAbstractQuest.rewardGold, 200)
			
			set this.m_counter = 0
			// item 0
			set questItem = AQuestItem.create(this, tr("Jage fünf Rebhühner."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompletedHunt)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompletedHunt)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompletedHunt)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_perdix_hunt)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			// item 0
			set questItem = AQuestItem.create(this, tr("Bringe die Rebhühner zu Björn."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.bjoern())
			call questItem.setPingColour(100.0, 100.0, 100.0)
			
			
			return this
		endmethod
	endstruct

endlibrary
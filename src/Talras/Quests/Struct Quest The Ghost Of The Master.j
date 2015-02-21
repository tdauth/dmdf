library StructMapQuestsQuestTheGhostOfTheMaster requires Asl, StructGameCharacter, StructMapMapNpcs, StructMapMapFellows

	struct QuestTheGhostOfTheMaster extends AQuest
		private static constant integer masterUnitTypeId = 'u009'

		implement CharacterQuest

		public stub method enable takes nothing returns boolean
			return super.enableUntil(0)
		endmethod
		
		private static method stateEventCompleted0 takes AQuestItem questItem, trigger usedTrigger returns nothing
			call TriggerRegisterEnterRectSimple(usedTrigger, gg_rct_quest_the_ghost_of_the_master_graveyard)
		endmethod

		private static method stateConditionCompleted0 takes AQuestItem questItem returns boolean
			return GetTriggerUnit() == Npcs.sisgard() and Fellows.sisgard().isShared() and Fellows.sisgard().character() == questItem.character()
		endmethod
		
		private static method stateActionCompleted0 takes AQuestItem questItem returns nothing
			local unit master
			local effect whichEffect
			call TalkSisgard.talk.evaluate().disable() // prevent any talks which would lead to side effects
			call PauseUnit(Npcs.sisgard(), true)
			call SetUnitInvulnerable(Npcs.sisgard(), true)
			call TransmissionFromUnit(Npcs.sisgard(), tr("Da sind wir, nun lasse ich den Zauber wirken!"), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call QueueUnitAnimation(Npcs.sisgard(), "Spell")
			set whichEffect = AddSpecialEffect("Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl", GetRectCenterX(gg_rct_quest_the_ghost_of_the_master_graveyard_spell), GetRectCenterY(gg_rct_quest_the_ghost_of_the_master_graveyard_spell))
			call TriggerSleepAction(2.0)
			call DestroyEffect(whichEffect)
			set whichEffect = null
			call TriggerSleepAction(2.0)
			set master = CreateUnit(Player(PLAYER_NEUTRAL_PASSIVE), thistype.masterUnitTypeId, GetRectCenterX(gg_rct_quest_the_ghost_of_the_master_graveyard_spell), GetRectCenterY(gg_rct_quest_the_ghost_of_the_master_graveyard_spell), 0.0)
			call PauseUnit(master, true)
			call SetUnitInvulnerable(master, true)
			call SetUnitFacingToFaceUnit(master, Npcs.sisgard())
			call SetUnitFacingToFaceUnit(Npcs.sisgard(), master)
			call TriggerSleepAction(2.0)
			call TransmissionFromUnit(master, tr("Wer hat mich aus den Tiefen der Finsternis geweckt? Seid Ihr es Sisgard meine Schülerin?"), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call TransmissionFromUnit(Npcs.sisgard(), tr("Meister! Ihr seid es tatsächlich! Ich fasse es nicht Euch nach so langer Zeit wiederzusehen!"), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call TransmissionFromUnit(master, tr("Ich bin es Sisgard und ich muss sagen du hättest dich ruhig ein bisschen beeilen können. In der Finsternis ist es nicht gerade spannend und ich hätte eigentlich gedacht ..."), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call TransmissionFromUnit(master, tr("Nun gut, jetzt bist du ja hier und wir sehen uns endlich wieder. Ich denke wir haben uns viel zu erzählen, doch besser ohne fremde Augen und Ohren in der Nähe."), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call TransmissionFromUnit(Npcs.sisgard(), tr("Ihr habt Recht Meister, wie immer! Ich kann Euch nicht sagen wie sehr Ihr mir gefehlt habt."), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call TransmissionFromUnit(master, tr("Nicht jetzt mein Kind, ein andermal! Nun weißt du ja wo und wie du mich finden kannst."), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call TransmissionFromUnit(master, tr("Lebe wohl!"), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call QueueUnitAnimation(master, "Spell")
			call TriggerSleepAction(4.0)
			call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl", GetRectCenterX(gg_rct_quest_the_ghost_of_the_master_graveyard_spell), GetRectCenterY(gg_rct_quest_the_ghost_of_the_master_graveyard_spell)))
			call RemoveUnit(master)
			set master = null
			call TriggerSleepAction(2.0)
			call TransmissionFromUnit(Npcs.sisgard(), tr("Meister? Das ist doch wieder typisch für ihn! Er ist eben einfach zu menschenscheu."), null)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call PauseUnit(Npcs.sisgard(), false)
			call SetUnitInvulnerable(Npcs.sisgard(), false)
			call TalkSisgard.talk.evaluate().enable()
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tr("Der Geist des Meisters"))
			local AQuestItem questItem
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNUrnOfKelThuzad.blp")
			call this.setDescription(tr("Sisgard kennt eine Zauberspruchformel, mit der sich Geister herbeirufen lassen. Da ihr Meister vor langer Zeit gestorben ist, will sie versuchen dessen Geist herbeizurufen, um wieder mit ihm in Kontakt zu treten. Ihr Meister wurde auf dem Friedhof nahe des Bauernhofs begraben."))
			call this.setReward(AAbstractQuest.rewardExperience, 800)
			// item 0
			set questItem = AQuestItem.create(this, tr("Begib dich mit Sisgard zum Friedhof nahe des Bauernhofs."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_ghost_of_the_master_graveyard)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tr("Sprich mit Sisgard über die Beschwörung."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sisgard())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod
	endstruct

endlibrary
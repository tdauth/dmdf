library StructMapQuestsQuestTheGhostOfTheMaster requires Asl, StructGameCharacter, StructMapMapNpcs, StructMapMapFellows

	struct QuestTheGhostOfTheMaster extends AQuest
		private static constant integer masterUnitTypeId = 'u009'

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
			call TransmissionFromUnitForPlayer(questItem.character().player(), Npcs.sisgard(), tre("Da sind wir, nun lasse ich den Zauber wirken!", "Here we are, now I will cast the spell!"), gg_snd_Sisgard64)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Sisgard64))
			call waitForVideo(Game.videoWaitInterval)
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
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnitForPlayer(questItem.character().player(), master, tre("Wer hat mich aus den Tiefen der Finsternis geweckt? Seid Ihr es Sisgard, meine Schülerin?", "Who woke me up from the depths of darkness? Is it you Sigard my student?"), gg_snd_Meister1)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Meister1))
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnitForPlayer(questItem.character().player(), Npcs.sisgard(), tre("Meister! Ihr seid es tatsächlich! Ich fasse es nicht Euch nach so langer Zeit wiederzusehen!", "Master! It is you indeed! I cannot believe to see you again after such a long time!"), gg_snd_Sisgard61)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Sisgard61))
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnitForPlayer(questItem.character().player(), master, tre("Ich bin es, Sisgard, und ich muss sagen du hättest dich ruhig ein bisschen beeilen können. In der Finsternis ist es nicht gerade spannend und ich hätte eigentlich gedacht ...", "I'm him Sisgard and I must say you could have hurried quite a bit. In the darkness it is not really exciting and I would have thought ..."), gg_snd_Meister2)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Meister2))
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnit(master, tre("Nun gut, jetzt bist du ja hier und wir sehen uns endlich wieder. Ich denke wir haben uns viel zu erzählen, doch besser ohne fremde Augen und Ohren in der Nähe.", "Well, now you're here and we'll see each other at last. I think we have a lot to tell to each other, but better without somebody else's eyes and ears nearby."), gg_snd_Meister3)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Meister3))
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnitForPlayer(questItem.character().player(), Npcs.sisgard(), tre("Ihr habt Recht Meister, wie immer! Ich kann Euch nicht sagen wie sehr Ihr mir gefehlt habt.", "You are right master, as always! I cannot tell you how much I've been missing you."), gg_snd_Sisgard62)
			call TriggerSleepAction(GetSimpleTransmissionDuration(null))
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnitForPlayer(questItem.character().player(), master, tre("Nicht jetzt mein Kind, ein andermal! Nun weißt du ja wo und wie du mich finden kannst.", "Not now my child, another time! Now you know where and how to find me."), gg_snd_Meister4)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Meister4))
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnitForPlayer(questItem.character().player(), master, tre("Lebe wohl!", "Farewell!"), gg_snd_Meister5)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Meister5))
			call waitForVideo(Game.videoWaitInterval)
			call QueueUnitAnimation(master, "Spell")
			call TriggerSleepAction(4.0)
			call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Undead\\Darksummoning\\DarkSummonTarget.mdl", GetRectCenterX(gg_rct_quest_the_ghost_of_the_master_graveyard_spell), GetRectCenterY(gg_rct_quest_the_ghost_of_the_master_graveyard_spell)))
			call RemoveUnit(master)
			set master = null
			call TriggerSleepAction(2.0)
			call waitForVideo(Game.videoWaitInterval)
			call TransmissionFromUnitForPlayer(questItem.character().player(), Npcs.sisgard(), tre("Meister? Das ist doch wieder typisch für ihn! Er ist eben einfach zu menschenscheu.", "Master? That is again typical for him! He's just simply unsociable."), gg_snd_Sisgard63)
			call TriggerSleepAction(GetSimpleTransmissionDuration(gg_snd_Sisgard63))
			call waitForVideo(Game.videoWaitInterval)
			call PauseUnit(Npcs.sisgard(), false)
			call SetUnitInvulnerable(Npcs.sisgard(), false)
			call TalkSisgard.talk.evaluate().enable()
			call questItem.quest().questItem(1).enable()
		endmethod

		private static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, tre("Der Geist des Meisters", "The Ghost of the Master"))
			local AQuestItem questItem = 0
			call this.setIconPath("ReplaceableTextures\\CommandButtons\\BTNUrnOfKelThuzad.blp")
			call this.setDescription(tre("Sisgard kennt eine Zauberspruchformel, mit der sich Geister herbeirufen lassen. Da ihr Meister vor langer Zeit gestorben ist, will sie versuchen dessen Geist herbeizurufen, um wieder mit ihm in Kontakt zu treten. Ihr Meister wurde auf dem Friedhof nahe des Bauernhofs begraben.", "Sisgard knows a spell formula that can summon spirits. Since her master died long ago, she wants to try to summon his ghost to return to contact with him. Her master was buried in the graveyard next to the farm."))
			call this.setReward(thistype.rewardExperience, 800)
			// item 0
			set questItem = AQuestItem.create(this, tre("Begib dich mit Sisgard zum Friedhof nahe des Bauernhofs.", "Go with Sisgard to the graveyard next to the farm."))
			call questItem.setStateEvent(thistype.stateCompleted, thistype.stateEventCompleted0)
			call questItem.setStateCondition(thistype.stateCompleted, thistype.stateConditionCompleted0)
			call questItem.setStateAction(thistype.stateCompleted, thistype.stateActionCompleted0)
			call questItem.setPing(true)
			call questItem.setPingRect(gg_rct_quest_the_ghost_of_the_master_graveyard)
			call questItem.setPingColour(100.0, 100.0, 100.0)
			// item 1
			set questItem = AQuestItem.create(this, tre("Sprich mit Sisgard über die Beschwörung.", "Talk to Sisgard about the summoning."))
			call questItem.setPing(true)
			call questItem.setPingUnit(Npcs.sisgard())
			call questItem.setPingColour(100.0, 100.0, 100.0)

			return this
		endmethod

		implement CharacterQuest
	endstruct

endlibrary
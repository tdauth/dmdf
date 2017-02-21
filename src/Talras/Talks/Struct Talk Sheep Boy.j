library StructMapTalksTalkSheepBoy requires Asl, StructMapMapNpcRoutines, StructMapMapNpcs, StructMapQuestsQuestWolvesHunt, StructMapQuestsQuestStormingTheMill

	struct TalkSheepBoy extends Talk
		private AInfo m_hi
		private AInfo m_whoAreYou
		private AInfo m_fear
		private AInfo m_help
		private AInfo m_whereAreWolves
		private AInfo m_wolvesDead
		private AInfo m_moreHelp
		private AInfo m_banditsDead
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			if (this.infoHasBeenShownToCharacter(this.m_hi.index(), character) or not this.showInfo(this.m_hi.index(), character)) then
				call this.showRange(this.m_whoAreYou.index(), this.m_exit.index(), character)
			endif
		endmethod

		// (Automatisch)
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("Was machst du hier? Willst du etwa ein Schaf stehlen? Sieh dich bloß vor, sonst kriegst du es mit mir zu tun!", "What are you doing here? Do you want to steal a sheep? Just be careful, or you'll get it done with me!"), gg_snd_Schafshirte_01)
			call info.talk().showStartPage(character)
		endmethod

		// Wer bist du?
		private static method infoActionWhoAreYou takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer bist du?", "Who are you?"), null)
			call speech(info, character, true, tre("Ich bin der Schafshirte auf dem Bauernhof.", "I am the shepherd on the farm."), gg_snd_Schafshirte_02)
			call speech(info, character, true, tre("Ich bewache Manfreds Schafe, damit sie ungestört grasen können und bis zum Winter ordentlich fett werden und gesund bleiben.", "I guard Manfred's sheep so that they can graze undisturbed and get properly fat and remain healthy until winter."), gg_snd_Schafshirte_03)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionFear takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Hast du keine Angst ganz alleine hier?
		private static method infoActionFear takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hast du keine Angst ganz alleine hier?", "Are you not afraid all alone here?"), null)
			call speech(info, character, true, tre("Du meinst wie der alte Guntrich dort hinten? Nein, ich glaube nicht an irgendwelche Gespenstergeschichten. Ich fürchte mich vor gar nichts!", "You mean like the old Gunrich back there? No, I do not believe in any ghost stories. I'm afraid of nothing!"), gg_snd_Schafshirte_04)
			call speech(info, character, false, tre("Wirklich?", "Really?"), null)
			call speech(info, character, true, tre("Ja sicher, ob Wegelagerer, Orks oder Dunkelelfen. Die Männer auf dem Bauernhof sind doch allesamt Feiglinge. Ich würde es mit einer ganzen Armee aufnehmen wenn es sein muss.", "Yeah, sure, if you're a roadside, Orcs or Dark Elves. The men on the farm are all cowards. I would fight a whole army if it had to be."), gg_snd_Schafshirte_05)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		// Kann ich dir irgendwie helfen?
		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kann ich dir irgendwie helfen?", "Can I help you?"), null)
			call speech(info, character, true, tre("Quatsch, ich brauche sicher keine Hilfe und schon gar nicht von dir!", "Nonsense, I certainly need no help and certainly not from you!"), gg_snd_Schafshirte_06)
			call speech(info, character, false, tre("Sicher?", "For sure?"), null)
			call speech(info, character, true, tre("Ja, sicher! Außer … sag mal bist du ein guter Jäger?", "Yes sure! Except ... tell me, are you a good hunter?"), gg_snd_Schafshirte_07)
			call speech(info, character, false, tre("Sicher.", "For sure."), null)
			call speech(info, character, true, tre("In dieser Gegend wimmelt es von Wölfen. Sie haben wahrscheinlich mitbekommen, dass hier das fette Vieh grast und wollen sich die Bäuche vollschlagen.", "In this area it is teeming with wolves. They have probably noticed that the fat cattle are grazing here and want to eat something."), gg_snd_Schafshirte_08)
			call speech(info, character, true, tre("Wenn sie sich den Schafen nähern sollten, dann schlage ich sie in die Flucht.", "If they approach the sheep, I will put them in flight."), gg_snd_Schafshirte_09)
			call speech(info, character, true, tre("Leider kann ich die Schafe nicht alleine lassen, sonst würde ich diesen Wölfen mal gehörig das Fell über die Ohren ziehen!", "Unfortunately, I cannot leave the sheep alone, otherwise I would pull these wolves once properly the fur over the ears!"), gg_snd_Schafshirte_10)
			call speech(info, character, false, tre("Und das soll ich jetzt für dich tun?", "And this is what am I going to do for you?"), null)
			call speech(info, character, true, tre("Genau, außer du bist so feige wie die anderen hier. Töte am besten ihre Rudelführer, dann sind sie erst mal mit sich selbst beschäftigt.", "Exactly, except you are as cowardly as the others here. Kill their pack leaders best, then they are first busy with themselves for the moment."), gg_snd_Schafshirte_11)
			call speech(info, character, true, tre("Und denke daran, dass sich nicht nur Wölfe in der Nähe aufhalten. Sie verbreiten sich überall in Talras, schlimmer als die Pest!", "And remember that there are not only wolves nearby. They spread everywhere in Talras, worse than the plague!"), gg_snd_Schafshirte_12)
			// Neuer Auftrag „Wolfsjagd“
			call QuestWolvesHunt.characterQuest(character).enable()

			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Wolfsjagd“ ist aktiv)
		private static method infoConditionWhereAreWolves takes AInfo info, ACharacter character returns boolean
			return QuestWolvesHunt.characterQuest(character).isNew()
		endmethod

		// Wo finde ich die Rudelführer?
		private static method infoActionWhereAreWolves takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wo finde ich die Rudelführer?", "Where can I fin the pack leaders?"), null)
			call speech(info, character, true, tre("Einen habe ich neulich am Rande dieses Berges gesehen. Weiter nördlich vom Aufstieg.", "One I have seen recently on the edge of this mountain. Further north of the ascent."), gg_snd_Schafshirte_13)
			call speech(info, character, true, tre("Ich habe auch von Angriffen weit im Südwesten gehört. Reisende auf dem Weg nach Talras sollen dort Vieh an Wölfe verloren haben.", "I have also heard of attacks far in the southwest. Travelers on the way to Talras are said to have lost cattle to wolves."), gg_snd_Schafshirte_14)
			call speech(info, character, true, tre("Töte sie alle!", "Kill them all!"), gg_snd_Schafshirte_15)

			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Wolfsjagd“ ist abgeschlossen)
		private static method infoConditionWolvesDead takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return QuestWolvesHunt.characterQuest(character).questItem(0).isCompleted() and QuestWolvesHunt.characterQuest(character).questItem(1).isNew()
		endmethod

		// Die Rudelführer sind tot.
		private static method infoActionWolvesDead takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Die Rudelführer sind tot.", "The pack leaders are dead."), null)
			call speech(info, character, true, tre("Du bist also kein Feigling? Das hätte ich auch alleine geschafft … wenn ich nicht dauernd hier aufpassen müsste.", "So you're not a coward? I would have done it alone ... if I do not have to be constantly watching here."), gg_snd_Schafshirte_16)
			call speech(info, character, false, tre("Bestimmt.", "Certainly."), null)
			call speech(info, character, true, tre("Hier hast du etwas von den Schafen, zum Dank.", "Here you have something from the sheep to thank you."), gg_snd_Schafshirte_17)
			// Auftrag „Wolfsjagd“ abgeschlossen
			call QuestWolvesHunt.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Die Rudelführer sind tot“)
		private static method infoConditionMoreHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_wolvesDead.index(), character)
		endmethod

		// Und sonst ist alles in Ordnung?
		private static method infoActionMoreHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Und sonst ist alles in Ordnung?", "And everything else is alright?"), null)

			call speech(info, character, true, tre("Nicht wirklich. Seit Guntrich nicht mehr zu seiner Mühle geht, haben sich dort hinten Wegelagerer breit gemacht.", "Not really. Since Guntrich no longer goes to his mill, highwaymen have spread out there."), gg_snd_Schafshirte_18)
			call speech(info, character, true, tre("Die sitzen dort und fressen sich satt an unserem Korn. Wenn Guntrich nichts unternimmt, sind bald unsere gesamten Vorräte weg.", "They sit there eating our grain. If Guntrich is not doing anything, all our spplies will soon be gone."), gg_snd_Schafshirte_19)
			call speech(info, character, true, tre("Aber er glaubt ja es würde spuken, also muss ich mich wieder darum kümmern.", "But he thinks it would haunt, so I have to take care of it again."), gg_snd_Schafshirte_20)
			call speech(info, character, false, tre("Und was willst du tun?", "And what do you want to do?"), null)
			call speech(info, character, true, tre("Sie alle töten, diese verdammten Räuber … aber ich darf die Schafe nicht im Stich lassen.", "Kill them all, those damn robbers ... but I cannot let the sheep down."), gg_snd_Schafshirte_21)
			call speech(info, character, true, tre("Du bist doch …", "You're ..."), gg_snd_Schafshirte_22)
			call speech(info, character, false, tre("Verstehe schon, ich soll sie für dich erledigen.", "I get it, I'm supposed to do it for you."), null)
			call speech(info, character, true, tre("Ja, aber nicht einfach so. Sie sollen wissen, wem dieser Berg gehört und wer ihnen ein Ende bereitet.", "Yes, but not just like that. They shall know to whom this mountain belongs, and who will put an end to them."), gg_snd_Schafshirte_23)
			call speech(info, character, false, tre("Und das heißt?", "And that means?"), null)
			call speech(info, character, true, tre("Die Schafe grasen hier in Frieden. Wir können keine Eindringlinge gebrauchen. Die Schafe werden sich rächen!", "The sheep graze here in peace. We cannot use intruders. The sheep will avenge themselves!"), gg_snd_Schafshirte_24)
			call speech(info, character, true, tre("Du musst sie gemeinsam mit den Schafen angreifen!", "You must attack them with the sheep!"), gg_snd_Schafshirte_25)
			call speech(info, character, false, tre("Was?!", "What?!"), null)
			call speech(info, character, true, tre("Ja, nur nicht mit allen Schafen, falls die Verluste zu hoch werden. Ansonsten bleiben uns keine Tiere mehr.", "Yes, just not with all the sheep, if the losses become too high. Otherwise we will not be left with any animals."), gg_snd_Schafshirte_26)
			call speech(info, character, true, tre("Sagen wir ich verkaufe dir ein Schaf. Darauf kannst du dann in die Schlacht reiten.", "Let's say I'll sell you a sheep. Then you can ride into the batlle on it."), gg_snd_Schafshirte_27)
			call speech(info, character, false, tre("WAS?!", "WHAT?!"), null)
			call speech(info, character, true, tre("Keine Angst, es ist nicht so teuer wie du denkst. Ich mache dir einen Freundschaftspreis.", "Do not worry, it's not as expensive as you think. I'll make you a friendship price."), gg_snd_Schafshirte_28)
			call speech(info, character, true, tre("Nun denn, ziehe dahin für Ruhm und Ehre auf dass die Schafe diesen Berg für sich behaupten können!", "Now, for glory and honor, go up there for the sheep to assert this mountain for themselves!"), gg_snd_Schafshirte_29)

			// Neuer Auftrag „Sturm auf die Mühle“
			call QuestStormingTheMill.characterQuest(character).enable()

			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 2 des Auftrags „Sturm auf die Mühle“ ist abgeschlossen)
		private static method infoConditionBanditsDead takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return QuestStormingTheMill.characterQuest(character).questItem(1).isCompleted() and QuestStormingTheMill.characterQuest(character).questItem(2).isNew()
		endmethod

		// Die Wegelagerer sind tot.
		private static method infoActionBanditsDead takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Die Wegelagerer sind tot.", "The highwaymen are dead."), null)
			call speech(info, character, true, tre("Tatsächlich? Ich hoffe dein Schaf hat dir als Schlachtross treue Dienste geleistet.", "Indeed? I hope your sheep has served you faithfully as battle horse."), gg_snd_Schafshirte_30)
			call speech(info, character, false, tre("Natürlich …", "Of course ..."), null)
			call speech(info, character, true, tre("Die Schafe danken dir für deine Ritterlichkeit. Endlich gehört der Berg wieder uns!", "The sheep thank you for your chivalry. Finally the mountain belongs to us again!"), gg_snd_Schafshirte_31)

			// Auftrag „Sturm auf die Mühle“ abgeschlossen.
			call QuestStormingTheMill.characterQuest(character).complete()

			call info.talk().showStartPage(character)
		endmethod

		// TODO gg_snd_Schafshirte_32

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.sheepBoy(), thistype.startPageAction)

			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoActionHi, null) // (Automatisch)
			set this.m_whoAreYou = this.addInfo(false, false, 0, thistype.infoActionWhoAreYou, tre("Wer bist du?", "Who are you?"))
			set this.m_fear = this.addInfo(true, false, thistype.infoConditionFear, thistype.infoActionFear, tre("Hast du keine Angst ganz alleine hier?", "Are you not afraid all alone here?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tre("Kann ich dir irgendwie helfen?", "Can I help you?"))
			set this.m_whereAreWolves = this.addInfo(true, false, thistype.infoConditionWhereAreWolves, thistype.infoActionWhereAreWolves, tre("Wo finde ich die Rudelführer?", "Where can I fin the pack leaders?"))
			set this.m_wolvesDead = this.addInfo(false, false, thistype.infoConditionWolvesDead, thistype.infoActionWolvesDead, tre("Die Rudelführer sind tot.", "The pack leaders are dead."))
			set this.m_moreHelp = this.addInfo(false, false, thistype.infoConditionMoreHelp, thistype.infoActionMoreHelp, tre("Und sonst ist alles in Ordnung?", "And everything else is alright?"))
			set this.m_banditsDead = this.addInfo(false, false, thistype.infoConditionBanditsDead, thistype.infoActionBanditsDead, tre("Die Wegelagerer sind tot.", "The highwaymen are dead."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
library StructMapTalksTalkSheepBoy requires Asl, StructMapMapNpcRoutines, StructMapMapNpcs, StructMapQuestsQuestWolvesHunt, StructMapQuestsQuestStormingTheMill

	struct TalkSheepBoy extends Talk
	
		implement Talk
		
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
			call speech(info, character, true, tr("Was machst du hier? Willst du etwa ein Schaf stehlen? Sieh dich bloß vor, sonst kriegst du es mit mir zu tun!"), gg_snd_Schafshirte_01)
			call info.talk().showStartPage(character)
		endmethod
		
		// Wer bist du?
		private static method infoActionWhoAreYou takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Ich bin der Schafshirte auf dem Bauernhof."), gg_snd_Schafshirte_02)
			call speech(info, character, true, tr("Ich bewache Manfreds Schafe, damit sie ungestört grasen können und bis zum Winter ordentlich fett werden und gesund bleiben."), gg_snd_Schafshirte_03)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionFear takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Hast du keine Angst ganz alleine hier?
		private static method infoActionFear takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hast du keine Angst ganz alleine hier?"), null)
			call speech(info, character, true, tr("Du meinst wie der alte Guntrich dort hinten? Nein, ich glaube nicht an irgendwelche Gespenstergeschichten. Ich fürchte mich vor gar nichts!"), gg_snd_Schafshirte_04)
			call speech(info, character, false, tr("Wirklich?"), null)
			call speech(info, character, true, tr("Ja sicher, ob Wegelagerer, Orks oder Dunkelelfen. Die Männer auf dem Bauernhof sind doch allesamt Feiglinge. Ich würde es mit einer ganzen Armee aufnehmen wenn es sein muss."), gg_snd_Schafshirte_05)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Nach Begrüßung)
		private static method infoConditionHelp takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return info.talk().infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod
		
		// Kann ich dir irgendwie helfen?
		private static method infoActionHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kann ich dir irgendwie helfen?"), null)
			call speech(info, character, true, tr("Quatsch, ich brauche sicher keine Hilfe und schon gar nicht von dir!"), gg_snd_Schafshirte_06)
			call speech(info, character, false, tr("Sicher?"), null)
			call speech(info, character, true, tr("Ja, sicher! Außer … sag mal bist du ein guter Jäger?"), gg_snd_Schafshirte_07)
			call speech(info, character, false, tr("Sicher."), null)
			call speech(info, character, true, tr("In dieser Gegend wimmelt es von Wölfen. Sie haben wahrscheinlich mitbekommen, dass hier das fette Vieh grast und wollen sich die Bäuche vollschlagen."), gg_snd_Schafshirte_08)
			call speech(info, character, true, tr("Wenn sie sich den Schafen nähern sollten, dann schlage ich sie in die Flucht."), gg_snd_Schafshirte_09)
			call speech(info, character, true, tr("Leider kann ich die Schafe nicht alleine lassen, sonst würde ich diesen Wölfen mal gehörig das Fell über die Ohren ziehen!"), gg_snd_Schafshirte_10)
			call speech(info, character, false, tr("Und das soll ich jetzt für dich tun?"), null)
			call speech(info, character, true, tr("Genau, außer du bist so feige wie die anderen hier. Töte am besten ihre Rudelführer, dann sind sie erst mal mit sich selbst beschäftigt."), gg_snd_Schafshirte_11)
			call speech(info, character, true, tr("Und denke daran, dass sich nicht nur Wölfe in der Nähe aufhalten. Sie verbreiten sich überall in Talras, schlimmer als die Pest!"), gg_snd_Schafshirte_12)
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
			call speech(info, character, false, tr("Wo finde ich die Rudelführer?"), null)
			call speech(info, character, true, tr("Einen habe ich neulich am Rande dieses Berges gesehen. Weiter nördlich vom Aufstieg."), gg_snd_Schafshirte_13)
			call speech(info, character, true, tr("Ich habe auch von Angriffen weit im Südwesten gehört. Reisende auf dem Weg nach Talras sollen dort Vieh an Wölfe verloren haben."), gg_snd_Schafshirte_14)
			call speech(info, character, true, tr("Töte sie alle!"), gg_snd_Schafshirte_15)
		
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Wolfsjagd“ ist abgeschlossen)
		private static method infoConditionWolvesDead takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return QuestWolvesHunt.characterQuest(character).questItem(0).isCompleted() and QuestWolvesHunt.characterQuest(character).questItem(1).isNew()
		endmethod

		// Die Rudelführer sind tot.
		private static method infoActionWolvesDead takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Die Rudelführer sind tot."), null)
			call speech(info, character, true, tr("Du bist also kein Feigling? Das hätte ich auch alleine geschafft … wenn ich nicht dauernd hier aufpassen müsste."), gg_snd_Schafshirte_16)
			call speech(info, character, false, tr("Bestimmt."), null)
			call speech(info, character, true, tr("Hier hast du etwas von den Schafen, zum Dank."), gg_snd_Schafshirte_17)
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
			call speech(info, character, false, tr("Und sonst ist alles in Ordnung?"), null)
			
			call speech(info, character, true, tr("Nicht wirklich. Seit Guntrich nicht mehr zu seiner Mühle geht, haben sich dort hinten Wegelagerer breit gemacht."), gg_snd_Schafshirte_18)
			call speech(info, character, true, tr("Die sitzen dort und fressen sich satt an unserem Korn. Wenn Guntrich nichts unternimmt, sind bald unsere gesamten Vorräte weg."), gg_snd_Schafshirte_19)
			call speech(info, character, true, tr("Aber er glaubt ja es würde spuken, also muss ich mich wieder darum kümmern."), gg_snd_Schafshirte_20)
			call speech(info, character, false, tr("Und was willst du tun?"), null)
			call speech(info, character, true, tr("Sie alle töten, diese verdammten Räuber … aber ich darf die Schafe nicht im Stich lassen."), gg_snd_Schafshirte_21)
			call speech(info, character, true, tr("Du bist doch …"), gg_snd_Schafshirte_22)
			call speech(info, character, false, tr("Verstehe schon, ich soll sie für dich erledigen."), null)
			call speech(info, character, true, tr("Ja, aber nicht einfach so. Sie sollen wissen, wem dieser Berg gehört und wer ihnen ein Ende bereitet."), gg_snd_Schafshirte_23)
			call speech(info, character, false, tr("Und das heißt?"), null)
			call speech(info, character, true, tr("Die Schafe grasen hier in Frieden. Wir können keine Eindringlinge gebrauchen. Die Schafe werden sich rächen!"), gg_snd_Schafshirte_24)
			call speech(info, character, true, tr("Du musst sie gemeinsam mit den Schafen angreifen!"), gg_snd_Schafshirte_25)
			call speech(info, character, false, tr("Was?!"), null)
			call speech(info, character, true, tr("Ja, nur nicht mit allen Schafen, falls die Verluste zu hoch werden. Ansonsten bleiben uns keine Tiere mehr."), gg_snd_Schafshirte_26)
			call speech(info, character, true, tr("Sagen wir ich verkaufe dir ein Schaf. Darauf kannst du dann in die Schlacht reiten."), gg_snd_Schafshirte_27)
			call speech(info, character, false, tr("WAS?!"), null)
			call speech(info, character, true, tr("Keine Angst, es ist nicht so teuer wie du denkst. Ich mache dir einen Freundschaftspreis."), gg_snd_Schafshirte_28)
			call speech(info, character, true, tr("Nun denn, ziehe dahin für Ruhm und Ehre auf dass die Schafe diesen Berg für sich behaupten können!"), gg_snd_Schafshirte_29)
			
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
			call speech(info, character, false, tr("Die Wegelagerer sind tot."), null)
			call speech(info, character, true, tr("Tatsächlich? Ich hoffe dein Schaf hat dir als Schlachtross treue Dienste geleistet."), gg_snd_Schafshirte_30)
			call speech(info, character, false, tr("Natürlich …"), null)
			call speech(info, character, true, tr("Die Schafe danken dir für deine Ritterlichkeit. Endlich gehört der Berg wieder uns!"), gg_snd_Schafshirte_31)
			
			// Auftrag „Sturm auf die Mühle“ abgeschlossen.
			call QuestStormingTheMill.characterQuest(character).complete()
			
			call info.talk().showStartPage(character)
		endmethod
		
		// TODO gg_snd_Schafshirte_32

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.sheepBoy(), thistype.startPageAction)
			
			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoActionHi, null) // (Automatisch)
			set this.m_whoAreYou = this.addInfo(false, false, 0, thistype.infoActionWhoAreYou, tr("Wer bist du?"))
			set this.m_fear = this.addInfo(true, false, thistype.infoConditionFear, thistype.infoActionFear, tr("Hast du keine Angst ganz alleine hier?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tr("Kann ich dir irgendwie helfen?"))
			set this.m_whereAreWolves = this.addInfo(true, false, thistype.infoConditionWhereAreWolves, thistype.infoActionWhereAreWolves, tr("Wo finde ich die Rudelführer."))
			set this.m_wolvesDead = this.addInfo(false, false, thistype.infoConditionWolvesDead, thistype.infoActionWolvesDead, tr("Die Rudelführer sind tot."))
			set this.m_moreHelp = this.addInfo(false, false, thistype.infoConditionMoreHelp, thistype.infoActionMoreHelp, tr("Und sonst ist alles in Ordnung?"))
			set this.m_banditsDead = this.addInfo(false, false, thistype.infoConditionBanditsDead, thistype.infoActionBanditsDead, tr("Die Wegelagerer sind tot."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary
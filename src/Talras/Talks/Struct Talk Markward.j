library StructMapTalksTalkMarkward requires Asl, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestSupplyForTalras, StructMapQuestsQuestReinforcementForTalras

	struct TalkMarkward extends ATalk
		private AInfo m_hi
		private AInfo m_whatsUp
		private AInfo m_whereFrom
		private AInfo m_whatAreYouDoing
		private AInfo m_heyKnight
		private AInfo m_firstHelp
		private AInfo m_firstHelpDone
		private AInfo m_secondHelp
		private AInfo m_secondHelpDoneWood
		private AInfo m_secondHelpDoneArrows
		private AInfo m_secondHelpDone
		private AInfo m_exit

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(this.m_hi.index(), character)) then
				call this.showRange(this.m_whatsUp.index(), this.m_exit.index(), character)
			endif
		endmethod

		// (Automatisch)
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Gegrüßt seist du! Ich hoffe du und deine Leute, ihr benehmt euch anständig in der Burg und gegenüber dem Herzog, nun, da ihr ihm immerhin eure Treue geschworen habt."), null)
			call speech(info, character, false, tr("Sicher."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wie ist die Lage?
		private static method infoActionWhatsUp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wie ist die Lage?"), null)
			// (Auftrag „Die Nordmänner“ ist aktiv)
			if (QuestTheNorsemen.quest().isNew()) then
				call speech(info, character, true, tr("Heikel. Ihr solltet die Nordmänner um Unterstützung bitten, damit wir alle wieder ruhiger schlafen können."), null)
			// (Auftrag „Die Nordmänner“ ist abgeschlossen)
			else
				call speech(info, character, true, tr("Besser. Wenn ihr Verstärkung aus Holzbruck herbeischaffen könnt, haben wir eine echte Chance und durch den Sieg der Nordmänner über die Dunkelefen und Orks, haben wir zunächst etwas Ruhe und Zeit, um uns auf weitere Gefechte vorzubereiten."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Woher kommst du?
		private static method infoActionWhereFrom takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Woher kommst du?"), null)
			call speech(info, character, true, tr("Meine Burg befindet sich südwestlich von hier. Sie ist selbstverständlich kleiner als diese, aber macht auch Einiges her."), null)
			call speech(info, character, true, tr("Wie auch der Herzog, habe ich mein Lehen von meinem Vater geerbt. Mir unterstehen einige Knechte, Bauern und Leibeigene. Meine Besitztümer …"), null)
			call speech(info, character, false, tr("Schon gut."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was genau machst du hier?
		private static method infoActionWhatAreYouDoing takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was genau machst du hier?"), null)
			call speech(info, character, true, tr("Ich unterstütze den Herzog so gut ich kann bei seinem Kampf gegen den Feind. Wenn es nach mir ginge, müsste hier eine ganze Schar von Rittern stehen, aber die scheinen dieser Tage wohl etwas Besseres mit ihrer Zeit anfangen zu wissen."), null)
			call speech(info, character, true, tr("Vermutlich kümmern sie sich um ihre eigenen Ländereien und sind viel zu feige, dem Feind an der Front ins Auge zu blicken."), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// (Charakter ist Ritter)
		private static method infoConditionHeyKnight takes AInfo info, ACharacter character returns boolean
			return character.class() == Classes.knight()
		endmethod
		
		// He da Rittersmann!
		private static method infoActionHeyKnight takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("He da Rittersmann!"), null)
			call speech(info, character, true, tr("Selten trifft man dieser Tage seinesgleichen in einer bedrohlichen Gegend wie dieser."), null)
			call speech(info, character, true, tr("Ich hoffe nur du hast dich nicht von den noblen Werten abgewandt und dienst jetzt einem niederen Verlangen wie der Gier."), null)
			call speech(info, character, true, tr("Nimm dieses Schwert Waffenbruder auf dass es dir in deinen bevorstehenden Kämpfen von Nutzen sein möge."), null)
			// Charakter erhält Schwert
			call character.giveItem('I03R')
			call info.talk().showStartPage(character)
		endmethod
		
		// Kann ich sonst noch etwas tun?
		private static method infoActionFirstHelp takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Kann ich sonst noch etwas tun?"), null)
			call speech(info, character, true, tr("Sicher, es gibt sehr viel zu tun. Sollte der Feind zahlmäßig überlegen sein, so müssen wir uns in der Burg verschanzen und auf Hilfe hoffen."), null)
			call speech(info, character, true, tr("Eine Belagerung ist eine ernste Sache. Haben sie uns erst umzingelt, so müssen wir mit den Vorräten auskommen, die wir eingelagert haben."), null)
			call speech(info, character, true, tr("Das sind aber nicht gerade viele. Die meisten unserer Männer sind mit anderen Sachen beschäftigt. Du könntest mit dem Bauern Manfred sprechen und dafür sorgen, dass er Karren mit Vorräten in die Burg schickt."), null)
			// Neuer Auftrag „Die Versorgung von Talras“
			call QuestSupplyForTalras.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 1 des Auftrags „Die Versorgung von Talras“ ist abgeschlossen und Auftrag ist noch aktiv)
		private static method infoConditionFirstHelpDone takes AInfo info, ACharacter character returns boolean
			return QuestSupplyForTalras.characterQuest(character).questItem(0).isCompleted() and  QuestSupplyForTalras.characterQuest(character).questItem(1).isNew()
		endmethod
		
		// Manfred schickt Vorräte in die Burg.
		private static method infoActionFirstHelpDone takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Manfred schickt Vorräte in die Burg."), null)
			call speech(info, character, true, tr("Das freut mich zu hören. Hoffen wir dass alles rechtzeitig die Burg erreicht."), null)
			call speech(info, character, true, tr("Hier hast du ein paar Goldmünzen und Tränke."), null)
			// Charakter erhält Tränke
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			// Auftrag „Die Versorgung von Talras“ abgeschlossen
			call QuestSupplyForTalras.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftrag „Die Versorgung von Talras“ ist abgeschlossen)
		private static method infoConditionSecondHelp takes AInfo info, ACharacter character returns boolean
			return QuestSupplyForTalras.characterQuest(character).isCompleted()
		endmethod
		
		// Gibt es noch etwas zu tun?
		private static method infoActionSecondHelp takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Gibt es noch etwas zu tun?"), null)
			call speech(info, character, true, tr("Ich sehe schon du bist ein zuverlässiger Mann. Leute wie dich können wir sehr gut gebrauchen."), null)
			call speech(info, character, true, tr("Um der Belagerung besser standzuhalten würde es nicht Schaden die Befestigungen dieser doch schon alten Burg zu verstärken."), null)
			call speech(info, character, true, tr("Außerdem sollten auf den Mauern in Türmen genügend Pfeile für die Bogenschützen platziert werden."), null)
			call speech(info, character, true, tr("Wegen den Befestigungen kannst du mit dem Holzfäller Kuno sprechen. Er lebt im Nordosten etwas abgeschieden im Wald. Sag ihm, dass er uns über Manfred Holz liefern muss."), null)
			call speech(info, character, true, tr("Wegen der Pfeile würde ich mit den Jägern der Burg sprechen. Das sind Dago und Björn."), null)
			// Neuer Auftrag „Die Befestigung von Talras“
			call QuestReinforcementForTalras.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 2 des Auftrags „Die Befestigung von Talras“ ist abgeschlossen)
		private static method infoConditionSecondHelpDoneWood takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(1).isCompleted()
		endmethod
		
		// Manfred schickt Holz.
		private static method infoActionSecondHelpDoneWood takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Manfred schickt Holz."), null)
			call speech(info, character, true, tr("Sehr gut. Nimm diese Tränke als Belohnung."), null)
			// Charakter erhält Tränke.
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call info.talk().showStartPage(character)
		endmethod
		
		// (Auftragsziel 5 des Auftrags „Die Befestigung von Talras“ ist abgeschlossen)
		private static method infoConditionSecondHelpDoneArrows takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(4).isCompleted()
		endmethod
		
		// Ich habe die Pfeile platziert.
		private static method infoActionSecondHelpDoneArrows takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Ich habe die Pfeile platziert."), null)
			call speech(info, character, true, tr("Tatsächlich? Du scheinst dich ja um alles zu kümmern."), null)
			call speech(info, character, true, tr("Hier, nimm diese Tränke."), null)
			// Charakter erhält Tränke.
			call character.giveItem('I00A')
			call character.giveItem('I00A')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call info.talk().showStartPage(character)
		endmethod
		
		// (Beide Infos wurden angeklickt)
		private static method infoConditionSecondHelpDone takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_secondHelpDoneWood.index(), character) and this.infoHasBeenShownToCharacter(this.m_secondHelpDoneArrows.index(), character)
		endmethod
		
		// Ihr seid nun bereit für eine Belagerung.
		private static method infoActionSecondHelpDone takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Ihr seid nun bereit für eine Belagerung."), null)
			call speech(info, character, true, tr("Das stimmt hoffentlich. Wir stehen schwer in deiner Schuld dafür. Nimm diesen Gegenstand als Belohnung."), null)
			// TODO Charakter erhält besonderen klassenabhängigen Gegenstand.
			//call character.giveItem('I03R')
			// Auftrag „Die Befestigung von Talras“ abgeschlossen
			call QuestReinforcementForTalras.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.markward(), thistype.startPageAction)

			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoActionHi, null) // 0
			set this.m_whatsUp = this.addInfo(true, false, 0, thistype.infoActionWhatsUp, tr("Wie ist die Lage?")) // 1
			set this.m_whereFrom = this.addInfo(false, false, 0, thistype.infoActionWhereFrom, tr("Woher kommst du?")) // 2
			set this.m_whatAreYouDoing = this.addInfo(false, false, 0, thistype.infoActionWhatAreYouDoing, tr("Was genau machst du hier?")) // 3
			
			set this.m_heyKnight = this.addInfo(false, false, thistype.infoConditionHeyKnight, thistype.infoActionHeyKnight, tr("He da Rittersmann!")) // 1
			set this.m_firstHelp = this.addInfo(false, false, 0, thistype.infoActionFirstHelp, tr("Kann ich sonst noch etwas tun?")) // 1
			set this.m_firstHelpDone = this.addInfo(false, false, thistype.infoConditionFirstHelpDone, thistype.infoActionFirstHelpDone, tr("Manfred schickt Vorräte in die Burg.")) // 1
			set this.m_secondHelp = this.addInfo(false, false, thistype.infoConditionSecondHelp, thistype.infoActionSecondHelp, tr("Gibt es noch etwas zu tun?")) // 1
			set this.m_secondHelpDoneWood = this.addInfo(false, false, thistype.infoConditionSecondHelpDoneWood, thistype.infoActionSecondHelpDoneWood, tr("Manfred schickt Holz.")) // 1
			set this.m_secondHelpDoneArrows = this.addInfo(false, false, thistype.infoConditionSecondHelpDoneArrows, thistype.infoActionSecondHelpDoneArrows, tr("Ich habe die Pfeile platziert.")) // 1
			set this.m_secondHelpDone = this.addInfo(false, false, thistype.infoConditionSecondHelpDone, thistype.infoActionSecondHelpDone, tr("Ihr seid nun bereit für eine Belagerung.")) // 1
			
			set this.m_exit = this.addExitButton() // 4

			return this
		endmethod
	endstruct

endlibrary
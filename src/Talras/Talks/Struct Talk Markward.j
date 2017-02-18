library StructMapTalksTalkMarkward requires Asl, StructMapMapNpcs, StructMapQuestsQuestANewAlliance, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestSupplyForTalras, StructMapQuestsQuestReinforcementForTalras, StructMapQuestsQuestWar

	struct TalkMarkward extends Talk
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

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(this.m_hi.index(), character)) then
				call this.showRange(this.m_whatsUp.index(), this.m_exit.index(), character)
			endif
		endmethod

		// (Automatisch)
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("Gegrüßt seist du! Ich hoffe du und deine Leute, ihr benehmt euch anständig in der Burg und gegenüber dem Herzog, nun, da ihr ihm immerhin eure Treue geschworen habt.", "Hail! I hope you and your people, you behave decently in the castle and in front of the duke, now that you have after all sworn him your loyality."), gg_snd_Markward1)
			call speech(info, character, false, tre("Sicher.", "Sure."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Wie ist die Lage?
		private static method infoActionWhatsUp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wie ist die Lage?", "How is the situation?"), null)
			// (Auftrag „Die Nordmänner“ ist aktiv)
			if (QuestTheNorsemen.quest().isNew()) then
				call speech(info, character, true, tre("Heikel. Ihr solltet die Nordmänner um Unterstützung bitten, damit wir alle wieder ruhiger schlafen können.", "Tricky. You should ask the Northmen for assistance, so that we can all sleep peacefully again."), gg_snd_Markward2)
			// (Auftrag „Ein neues Bündnis“ ist aktiv)
			elseif (QuestANewAlliance.quest().isNew()) then
				call speech(info, character, true, tre("Schlecht. Wir brauchen dringend Verstärkung. Sollten die Orks und Dunkelelfen hier eintreffen, können wir sie mit unseren wenigen Männern kaum aufhalten.", "Bad. We need reinforcement urgently. If the Orcs and Dark Elves arrive here, we an hardly stop them with our few men."), gg_snd_Markward3)
				call speech(info, character, true, tre("Ihr müsst die Hochelfin ausfindig machen. Vielleicht kann sie uns weiterhelfen.", "You have to find the High Elf. Maybe she can help us."), gg_snd_Markward5)
			// (Auftrag „Krieg“ ist aktiv)
			elseif (QuestWar.quest().isNew()) then
				call speech(info, character, true, tre("Schlecht. Helft uns den Außenposten zu befestigen. Wenn wir ihn gegen einen Teil der feindlichen Truppen halten können, verschafft uns das die nötige Zeit auch die Burg zu verteidigen.", "Bad. Help us to fix the outpost. If we can keep it against a part of the enemy troops, this gives us the necessary time to defend the castle."), gg_snd_Markward6)
				call speech(info, character, true, tre("Vielleicht schaffen wir es, die ersten Wellen der Orks und Dunkelelfen abzuwehren, aber nur wenn der Außenposten tatsächlich gut befestigt ist. Unser Schicksal liegt in euren Händen.", "Perhaps we will be able to ward off the first waves of the Orcs and Dark Elves, but only if the outpost is actually well fortified. Our destiny is in your hands."), gg_snd_Markward7)
			// (Auftrag „Die Nordmänner“ ist abgeschlossen)
			else
				call speech(info, character, true, tre("Besser. Wenn ihr Verstärkung aus Holzbruck herbeischaffen könnt, haben wir eine echte Chance und durch den Sieg der Hochelfen und Nordmänner über die Dunkelefen und Orks, haben wir zunächst etwas Ruhe und Zeit, um uns auf weitere Gefechte vorzubereiten.", "Better. If you can get reinforcements from Holzbruck, we have a real chance and through the victory of the High Elves and Northmen over the Dark Elves and Orcs, we have some rest and time to prepare ourselves for further battles."), gg_snd_Markward8)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Woher kommst du?
		private static method infoActionWhereFrom takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Woher kommst du?", "Where are you from?"), null)
			call speech(info, character, true, tre("Meine Burg befindet sich südwestlich von hier. Sie ist selbstverständlich kleiner als diese, aber macht auch Einiges her.", "My castle is located southwest of here. It is, of course, smaller than this, but also is not that small at all."), gg_snd_Markward9)
			call speech(info, character, true, tre("Wie auch der Herzog, habe ich mein Lehen von meinem Vater geerbt. Mir unterstehen einige Knechte, Bauern und Leibeigene. Meine Besitztümer …", "Like the duke, I inherited my fief from my father. There are some servants, peasants and the serfs. My propery ..."), gg_snd_Markward10)
			call speech(info, character, false, tre("Schon gut.", "All right."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was genau machst du hier?
		private static method infoActionWhatAreYouDoing takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was genau machst du hier?", "What exactly are you doing here?"), null)
			call speech(info, character, true, tre("Ich unterstütze den Herzog so gut ich kann bei seinem Kampf gegen den Feind. Wenn es nach mir ginge, müsste hier eine ganze Schar von Rittern stehen, aber die scheinen dieser Tage wohl etwas Besseres mit ihrer Zeit anfangen zu wissen.", "I support the duke as well as I can in his fight against the enemy. If it were for me, a whole host of knights would have to be here, but they seem to know something better about their time."), gg_snd_Markward11)
			call speech(info, character, true, tre("Vermutlich kümmern sie sich um ihre eigenen Ländereien und sind viel zu feige, dem Feind direkt ins Auge zu blicken.", "They probably take care of their own lands and are too cowardly to face the enemy directly."), gg_snd_Markward12)
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter ist Ritter)
		private static method infoConditionHeyKnight takes AInfo info, ACharacter character returns boolean
			return character.class() == Classes.knight()
		endmethod

		// He da Rittersmann!
		private static method infoActionHeyKnight takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("He da Rittersmann!", "Hey, you there, knight!"), null)
			call speech(info, character, true, tre("Selten trifft man dieser Tage seinesgleichen in einer bedrohlichen Gegend wie dieser.", "Rarely one does meet the same in a menacing region like this one."), gg_snd_Markward13)
			call speech(info, character, true, tre("Ich hoffe nur du hast dich nicht von den noblen Werten abgewandt und dienst jetzt einem niederen Verlangen wie der Gier.", "I hope only you have not turned away from the noble values and now serve a low desire like greed."), gg_snd_Markward14)
			call speech(info, character, true, tre("Nimm dieses Schwert Waffenbruder auf dass es dir in deinen bevorstehenden Kämpfen von Nutzen sein möge.", "Take this sword weapon brother to your advantage in your forthcoming battles."), gg_snd_Markward15)
			// Charakter erhält Schwert
			call character.giveItem('I03R')
			call character.displayItemAcquired(GetObjectName('I03R'), "")
			call info.talk().showStartPage(character)
		endmethod

		// Kann ich sonst noch etwas tun?
		private static method infoActionFirstHelp takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Kann ich sonst noch etwas tun?", "Can I do aynthing else?"), null)
			call speech(info, character, true, tre("Sicher, es gibt sehr viel zu tun. Sollte der Feind zahlenmäßig überlegen sein, so müssen wir uns in der Burg verschanzen und auf Hilfe hoffen.", "Sure, there's a lot to do. If the enemy is superior in numbers, we must be entrenched in the castle and hope for help."), gg_snd_Markward16)
			call speech(info, character, true, tre("Eine Belagerung ist eine ernste Sache. Haben sie uns erst umzingelt, so müssen wir mit den Vorräten auskommen, die wir eingelagert haben.", "A siege is a serious thing. If they have first surrounded us, we must get along with the supplies we have stored."), gg_snd_Markward17)
			call speech(info, character, true, tre("Das sind aber nicht gerade viele. Die meisten unserer Männer sind mit anderen Sachen beschäftigt. Du könntest mit dem Bauern Manfred sprechen und dafür sorgen, dass er Karren mit Vorräten in die Burg schickt.", "But these are not exactly many. Most of our men are busy with other things. You can talk to the farmer Manfred and make sure he sends carts with supplies to the castle."), gg_snd_Markward18)
			// Neuer Auftrag „Die Versorgung von Talras“
			call QuestSupplyForTalras.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Die Versorgung von Talras“ ist abgeschlossen und Auftrag ist noch aktiv)
		private static method infoConditionFirstHelpDone takes AInfo info, ACharacter character returns boolean
			return QuestSupplyForTalras.characterQuest(character).questItem(0).isCompleted() and  QuestSupplyForTalras.characterQuest(character).isNew()
		endmethod

		// Manfred schickt Vorräte in die Burg.
		private static method infoActionFirstHelpDone takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Manfred schickt Vorräte in die Burg.", "Manfred sends supplies to the castle."), null)
			call speech(info, character, true, tre("Das freut mich zu hören. Hoffen wir dass alles rechtzeitig die Burg erreicht.", "I am glad to hear that. Let's hope that everything has reached the castle in time."), gg_snd_Markward19)
			call speech(info, character, true, tre("Hier hast du ein paar Goldmünzen und Tränke.", "Here are some gold coins and potions."), gg_snd_Markward20)
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
			call speech(info, character, false, tre("Gibt es noch etwas zu tun?", "Is there anything else to do?"), null)
			call speech(info, character, true, tre("Ich sehe schon du bist ein zuverlässiger Mann. Leute wie dich können wir sehr gut gebrauchen.", "I already see you are a reliable man. People like you we an use very well."), gg_snd_Markward21)
			call speech(info, character, true, tre("Um der Belagerung besser standzuhalten, würde es nicht schaden die Befestigungen dieser doch schon alten Burg zu verstärken.", "In order to withstand the siege better, it would not hurt to strengthen the fortifications of this ancient castle."), gg_snd_Markward22)
			call speech(info, character, true, tre("Außerdem sollten auf den Mauern und in den Türmen genügend Pfeile für die Bogenschützen platziert werden.", "In addition, enough arrows should be placed on the walls and in the towers for the archers."), gg_snd_Markward23)
			call speech(info, character, true, tre("Wegen den Befestigungen kannst du mit dem Holzfäller Kuno sprechen. Er lebt im Nordosten etwas abgeschieden im Wald. Sag ihm, dass er uns über Manfred Holz liefern muss.", "About of the fortifications you can talk to the woodcutter Kuno. He lives in the north-east somewhat secluded in the forest. Tell him that he has to deliver us wood through Manfred."), gg_snd_Markward50)
			call speech(info, character, true, tre("Wegen der Pfeile würde ich mit den Jägern der Burg sprechen. Das sind Dago und Björn.", "About the arrows I would talk to the hunters of the castle. THese are Dago and Björn."), gg_snd_Markward24)
			// Neuer Auftrag „Die Befestigung von Talras“
			call QuestReinforcementForTalras.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 2 des Auftrags „Die Befestigung von Talras“ ist abgeschlossen)
		private static method infoConditionSecondHelpDoneWood takes AInfo info, ACharacter character returns boolean
			return QuestReinforcementForTalras.characterQuest(character).questItem(1).isCompleted()
		endmethod

		// Manfred schickt Holz.
		private static method infoActionSecondHelpDoneWood takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Manfred schickt Holz.", "Manfred sends wood."), null)
			call speech(info, character, true, tre("Sehr gut. Nimm diese Tränke als Belohnung.", "Very good. Take these potions as a reward."), gg_snd_Markward25)
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
			call speech(info, character, false, tre("Ich habe die Pfeile platziert.", "I've placed the arrows."), null)
			call speech(info, character, true, tre("Tatsächlich? Du scheinst dich ja um alles zu kümmern.", "Indeed? You seem to care about everything."), gg_snd_Markward26)
			call speech(info, character, true, tre("Hier, nimm diese Tränke.", "Here, take these potions."), gg_snd_Markward27)
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
			call speech(info, character, false, tre("Ihr seid nun bereit für eine Belagerung.", "You are now ready for a siege."), null)
			call speech(info, character, true, tre("Das stimmt hoffentlich. Wir stehen schwer in deiner Schuld dafür. Nimm diesen Gegenstand als Belohnung.", "Hopefully, that's true. We are hard at your fault. Take this item as a reward."), gg_snd_Markward28)
			// Charakter erhält besonderen klassenabhängigen Gegenstand.
			if (character.class() == Classes.cleric() or character.class() == Classes.necromancer() or character.class() == Classes.druid() or character.class() == Classes.elementalMage() or character.class() == Classes.ranger()) then
				call character.giveItem('I052')
			elseif (character.class() == Classes.dragonSlayer()) then
				call character.giveItem('I053')
			elseif (character.class() == Classes.knight()) then
				call character.giveItem('I055')
			elseif (character.class() == Classes.ranger()) then
				call character.giveItem('I054')
			endif
			// Auftrag „Die Befestigung von Talras“ abgeschlossen
			call QuestReinforcementForTalras.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.markward(), thistype.startPageAction)

			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoActionHi, null) // 0
			set this.m_whatsUp = this.addInfo(true, false, 0, thistype.infoActionWhatsUp, tre("Wie ist die Lage?", "How is the situation?")) // 1
			set this.m_whereFrom = this.addInfo(false, false, 0, thistype.infoActionWhereFrom, tre("Woher kommst du?", "Where are you from?")) // 2
			set this.m_whatAreYouDoing = this.addInfo(false, false, 0, thistype.infoActionWhatAreYouDoing, tre("Was genau machst du hier?", "What exactly are you doing here?")) // 3

			set this.m_heyKnight = this.addInfo(false, false, thistype.infoConditionHeyKnight, thistype.infoActionHeyKnight, tre("He da Rittersmann!", "Hey, you there, knight!")) // 1
			set this.m_firstHelp = this.addInfo(false, false, 0, thistype.infoActionFirstHelp, tre("Kann ich sonst noch etwas tun?", "Can I do aynthing else?")) // 1
			set this.m_firstHelpDone = this.addInfo(false, false, thistype.infoConditionFirstHelpDone, thistype.infoActionFirstHelpDone, tre("Manfred schickt Vorräte in die Burg.", "Manfred sends supplies to the castle.")) // 1
			set this.m_secondHelp = this.addInfo(false, false, thistype.infoConditionSecondHelp, thistype.infoActionSecondHelp,tre("Gibt es noch etwas zu tun?", "Is there anything else to do?")) // 1
			set this.m_secondHelpDoneWood = this.addInfo(false, false, thistype.infoConditionSecondHelpDoneWood, thistype.infoActionSecondHelpDoneWood, tre("Manfred schickt Holz.", "Manfred sends wood.")) // 1
			set this.m_secondHelpDoneArrows = this.addInfo(false, false, thistype.infoConditionSecondHelpDoneArrows, thistype.infoActionSecondHelpDoneArrows, tre("Ich habe die Pfeile platziert.", "I've placed the arrows.")) // 1
			set this.m_secondHelpDone = this.addInfo(false, false, thistype.infoConditionSecondHelpDone, thistype.infoActionSecondHelpDone, tre("Manfred schickt Holz.", "Manfred sends wood.")) // 1

			set this.m_exit = this.addExitButton() // 4

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
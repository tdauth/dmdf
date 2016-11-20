library StructMapTalksTalkIrmina requires Asl, StructGameDmdfHashTable, StructMapQuestsQuestTheBraveArmourerOfTalras, StructMapQuestsQuestTheWayToHolzbruck

	struct TalkIrmina extends Talk
		private static constant real potionTime = 30.0
		private static constant integer strengthPotion = 'I01T'
		private static constant integer dexterityPotion = 'I01U'
		private static constant integer purificationPotion = 'I01V'
		private static constant integer characterKey = 0
		private static constant integer potionKey = 1
		private timer array m_potionTimer[12] // MapSettings.maxPlayers()

		private method showPotionInfo takes Character character returns nothing
			if (TimerGetRemaining(this.m_potionTimer[GetPlayerId(character.player())]) > 0.0) then
				call character.displayHint(Format(tre("Irminas %1% benötigt noch %2% Sekunden bis zur Fertigstellung.", "Irmina's %1% still takes %2% seconds until it is finished.")).s(GetObjectName(DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], thistype.potionKey))).time(R2I(TimerGetRemaining(this.m_potionTimer[GetPlayerId(character.player())]))).result())
			else
				call character.displayItemAcquired(GetItemTypeIdName(DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], thistype.potionKey)), Format(tre("Irminas %1% wurde fertiggestellt.", "Irmina's %1% has been finished.")).s(GetObjectName(DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], thistype.potionKey))).result())
			endif
		endmethod

		private method createsPotion takes Character character returns boolean
			return this.m_potionTimer[GetPlayerId(character.player())] != null and TimerGetRemaining(this.m_potionTimer[GetPlayerId(character.player())]) > 0.0
		endmethod

		private method finishedPotion takes Character character returns boolean
			return this.m_potionTimer[GetPlayerId(character.player())] != null and TimerGetRemaining(this.m_potionTimer[GetPlayerId(character.player())]) == 0.0
		endmethod

		private method potion takes Character character returns integer
			if (this.m_potionTimer[GetPlayerId(character.player())] == null) then
				return 0
			endif
			return DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], thistype.potionKey)
		endmethod

		private static method timerFunctionPotion takes nothing returns nothing
			local Character character = DmdfHashTable.global().handleInteger(GetExpiredTimer(), thistype.characterKey)
			call thistype(thistype.talk.evaluate()).showPotionInfo(character)
		endmethod

		private method startPotionCreation takes Character character, integer potion returns nothing
			if (this.m_potionTimer[GetPlayerId(character.player())] != null) then
				return
			endif
			set this.m_potionTimer[GetPlayerId(character.player())] = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_potionTimer[GetPlayerId(character.player())], thistype.characterKey, character)
			call DmdfHashTable.global().setHandleInteger(this.m_potionTimer[GetPlayerId(character.player())], thistype.potionKey, potion)
			call TimerStart(this.m_potionTimer[GetPlayerId(character.player())], thistype.potionTime, false, function thistype.timerFunctionPotion)
		endmethod

		/// @return Returns an integer vector with all necessary ressource item types. Do not forget to destroy it!
		private static method potionRessources takes integer potion returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			if (potion == thistype.strengthPotion) then
				// Fliegenpilz
				call result.pushBack('I03Y')
				// Fleischkeule
				call result.pushBack('I017')
				return result
			elseif (potion == thistype.dexterityPotion) then
				// Steinpilz
				call result.pushBack('I01L')
				// Apfel
				call result.pushBack('I03O')
				return result
			elseif (potion == thistype.purificationPotion) then
				// Reinigungstrank
				call result.pushBack('I041')
				return result
			endif
			return result
		endmethod

		private method hasPotionRessources takes Character character, integer potion returns boolean
			local AIntegerVector itemTypes = thistype.potionRessources(potion)
			local boolean result = true
			local integer i = 0
			loop
				exitwhen (i == itemTypes.size())
				if (not character.inventory().hasItemType(itemTypes[i])) then
					set result = false
					exitwhen (true)
				endif
				set i = i + 1
			endloop
			call itemTypes.destroy()
			return result
		endmethod

		private static method potionMoney takes integer potion returns integer
			if (potion == thistype.strengthPotion) then
				return 900
			elseif (potion == thistype.dexterityPotion) then
				return 900
			elseif (potion == thistype.purificationPotion) then
				return 500
			endif
			return 0
		endmethod

		private method hasPotionMoney takes Character character, integer potion returns boolean
			return GetPlayerState(character.player(), PLAYER_STATE_RESOURCE_GOLD) >= thistype.potionMoney(potion)
		endmethod

		private method finishPotionCreation takes Character character returns nothing
			if (not this.finishedPotion(character)) then
				return
			endif
			call UnitAddItemById(character.unit(), DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], thistype.potionKey))
			call DmdfHashTable.global().destroyTimer(this.m_potionTimer[GetPlayerId(character.player())])
			set this.m_potionTimer[GetPlayerId(character.player())] = null
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(8, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo. Möchtest du zufällig etwas bei mir kaufen?", "Hello. Would you like to buy something from me?"), gg_snd_Irmina1)
			call info.talk().showRange(9, 10, character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wer bist du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer bist du?", "Who are you?"), null)
			call speech(info, character, true, tre("Ich bin Irmina und sowohl der Stand hier als auch das Haus daneben gehören meinem Mann und mir. Ich verkaufe hier meine Ware, also falls du was brauchst ...", "I am Irmina and both the stall here and the house next to it belong to my husband and me. I am selling my merchandise, so if you need anything ..."), gg_snd_Irmina5)
			call speech(info, character, true, tre("Ich kenne mich mit Kräutern und anderen Pflanzen bestens aus und weiß, wie man sich alle möglichen nützlichen Dinge zusammenmischt. Man könnte fast sagen, ich sei eine Alchemistin.", "I am well familiar with herbs and other plants and know how all sorts of useful things can be mixed together. One could almost say that I am an alchemist."), gg_snd_Irmina6)
			call speech(info, character, false, tre("Klingt gut.", "Sounds good."), null)
			call speech(info, character, true, tre("Das will ich doch meinen. Ich mache auch gerechte Preise, denn ich habe selbst genug zum Leben und wenn mein Mann wieder aus Holzbruck zurückkehrt, dann werde ich vermutlich mein Geschäft schließen und mich meinen Studien widmen.", "I certainly think so. I also make fair prices because I myself have enough to live on, and when my husband returns from Holzbruck, then I'll probably close my business and devote myself to my studies."), gg_snd_Irmina7)
			call speech(info, character, true, tre("Das bringt nämlich letztlich mehr als die harte Arbeit hier.", "That ultimately gives me more than the hard work here."), gg_snd_Irmina8)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“)
		private static method infoCondition2And3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Kannst du mir auch was Spezielles brauen oder mischen?
		private static method infoAction2 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Kannst du mir auch was Spezielles brauen oder mischen?", "Can you brew or mix me something special?"), null)
			call speech(info, character, true, tre("Natürlich, aber das kostet dich auch ein wenig und du musst mir die Zutaten beschaffen.", "Of course, but that will cost you a bit and you have to get me the ingredients."), gg_snd_Irmina9)
			call speech(info, character, true, tre("Ich muss hier nämlich meinen Laden führen und ich habe keine Lust mich noch um einen Bauern oder Jäger zu kümmern, der das für mich macht.", "I have to run my shop here and I have no desire even to look after a farmer or hunter who does that for me."), gg_snd_Irmina10)
			call speech(info, character, true, tre("Am besten gebe ich dir Abschriften meiner Zutaten- und Preislisten für besondere Tränke. Manche Zutaten sind sehr selten, was ja auch erklärt, warum ich sie nicht in meinem Sortiment habe.", "Best I give you my copies of ingriedents and price lists for special potions. Some ingredients are very rare, which indeed explains why I do not have them in my range."), gg_snd_Irmina11)
			/**
			 * Charakter erhält Zutatenliste.
			 */
			call character.giveQuestItem('I050')
			call character.displayItemAcquired(GetObjectName('I050'), tre("Listet alle Zutaten für Tränke von Irmina auf.", "Lists all ingredients of potions of Irmina."))
			call info.talk().showStartPage(character)
		endmethod

		// Was macht dein Mann in Holzbruck?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was macht dein Mann in Holzbruck?", "What does you husband do in Holzbruck?"), null)
			call speech(info, character, true, tre("Er hat dort Geschäfte zu erledigen. Er ist ein wohlhabender Kaufmann und handelt mit Salz, dem weißen Gold. Vor ein paar Monaten ist er mit einigen Wagen aufgebrochen, um sein Salz in Holzbruck zu verkaufen.", "He has to do business there. He is a wealthy businessman and trades with salt, the white gold. A few months ago he has started with some carts to sell his salt in Holzbruck."), gg_snd_Irmina12)
			call speech(info, character, true, tre("Du musst wissen, dass er ursprünglich aus Holzbruck kommt und sich hier nur meinetwegen niedergelassen hat.", "You have to know that he is orignally from Holzbruck and has settled here only because of me."), gg_snd_Irmina13)
			call speech(info, character, true, tre("Ich bin froh, einen solchen Mann getroffen und geheiratet zu haben. Meine Eltern waren einfache Leute und mussten noch viel härter arbeiten als ich und nun haben wir unser eigenes Haus hier und mir geht’s eigentlich recht gut.", "I'm glad to have married a man like that. My parents were simple people and had to work a lot harder than me and now we have our own house here and I feel actually pretty good."), gg_snd_Irmina14)
			call speech(info, character, true, tre("Na ja, jetzt da Krieg herrschen wird, sollten wir vielleicht woanders hingehen. Holzbruck gefällt mir zwar, aber das ist ja noch näher an der Grenze. Ich hoffe nur, dass meinem Mann nichts passiert.", "Well, now that the war will reign, maybe we should go somewhere else. I like Holzbruck but that's een closer to the border. I just hope that nothing happens to my husband."), gg_snd_Irmina15)
			call speech(info, character, true, tre("Er ist zwar ein netter Kerl, aber kein besonders starker. Ich glaube, er würde den Feinden, die in unser Königreich einfallen eher einen Handel vorschlagen als ihnen mit dem Schwert entgegenzutreten. Ganz anders als Agihard … (seufzt)", "Although he is a nice guy, he is not particularly strong. I think he would rather suggest the enemies who invade our kingdom a trade than face them with the sword. Quite unlike Agihard ... (sighs)"), gg_snd_Irmina16)
			call speech(info, character, false, tre("Agihard?", "Agihard?"), null)
			call speech(info, character, true, tre("Ja, der Waffenmeister von Talras. Das ist ein starker Krieger. Egal was andere von ihm denken, ich weiß, dass er ein gutes Herz hat und Mut noch dazu. Ich glaube, er ist nur etwas einsam.", "Yes, armorer of Talras. This is a strong warrior. No matter what others think of him, I know that he has a good heart and courage at that. I think he's just a little lonely."), gg_snd_Irmina17)
			call info.talk().showRange(11, 12, character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ ist abgeschlossen)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestTheBraveArmourerOfTalras.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Agihard mag dich.
		private static method infoAction4 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Agihard mag dich.", "Agihard likes you."), null)
			call speech(info, character, true, tre("Was … äh … wie bitte? Hast du etwa mit ihm gesprochen?", "What ... uh ... what? Did you talk with him?"), gg_snd_Irmina21)
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Du hast ihm doch nicht erzählt, was ich dir gesagt habe, oder?", "You did not tell him what I told you, right?"), gg_snd_Irmina22)
			call speech(info, character, false, tre("Also …", "So …"), null)
			call speech(info, character, true, tre("Wie konntest du nur? Jetzt denkt er bestimmt etwas Falsches von mir.", "How could you? Now he probably thinks something wrong of me."), gg_snd_Irmina23)
			call speech(info, character, false, tre("…", "…"), null)
			call speech(info, character, true, tre("Was … also was hat er denn gesagt, also was genau?", "What … so what did he say, so what exactly?"), gg_snd_Irmina24)
			call speech(info, character, false, tre("Er meinte nur, dass er dich sehr gerne hat und vielleicht mal in nächster Zeit bei dir vorbeischaut.", "He just said that he likes you very much and maybe in the near future will come around at you."), null)
			call speech(info, character, true, tre("Tatsächlich! Ich meine, tatsächlich? Das wäre toll. Endlich mal eine gute Neuigkeit. Hier hast du ein paar Salben, danke!", "Indeed! I mean, indeed? That would be great. Finally a good news. Here you have a few ointments, thank you!"), gg_snd_Irmina25)
			// Salben geben
			call character.giveItem('I070')
			call character.giveItem('I070')
			call character.giveItem('I070')
			call character.giveItem('I070')
			call character.giveItem('I071')
			call character.giveItem('I071')
			call character.giveItem('I071')
			call character.giveItem('I071')
			// Auftrag „Talras' mutiger Waffenmeister“ abgeschlossen
			call QuestTheBraveArmourerOfTalras.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung und Auftrag „Der Weg nach Holzbruck“ ist aktiv)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and QuestTheWayToHolzbruck.quest().isNew()
		endmethod

		// Ich gehe nach Holzbruck.
		private static method infoAction5 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Ich gehe nach Holzbruck.", "I'm going to Holzbruck."), null)
			call speech(info, character, true, tre("Tatsächlich? Nun, ich wünsche dir viel Glück und bitte sieh nach meinem Mann! Sein Name ist Lambert. Hier, nimm noch diese Tränke! Ich hoffe, sie werden dir von Nutzen sein.", "Indeed? Well, I wish you good luck and please look for my husband! His name is Lambert. Here, have these potions! I hope they will be useful to you."), gg_snd_Irmina26)
			// Charakter erhält Heiltränke
			call character.giveItem('I00B')
			call character.giveItem('I00B')
			call character.giveItem('I00B')
			call info.talk().showStartPage(character)
		endmethod

		// (Nachdem der Charakter danach gefragt hat)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(2, character)
		endmethod

		// Braue mir einen speziellen Trank!
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Braue mir einen speziellen Trank!", "Make me a special potion!"), null)
			// (Irmina braut keinen speziellen Trank für den Charakter)
			if (not this.createsPotion(character)) then
				call speech(info, character, true, tre("Gut, wenn du die Zutaten und Goldmünzen hast. Welcher darf's denn sein?", "Well, if you have the ingredients and gold coins. What'll it be?"), gg_snd_Irmina27)
				call this.showRange(13, 16, character)
			elseif (this.createsPotion(character)) then
			// (Irmina braut bereits einen speziellen Trank für den Charakter)
				call speech(info, character, true, tre("Ich braue dir doch bereits einen. Warte erst mal bis der fertig ist, dann sehen wir weiter!", "But I'll already making one for you. Just wait until that is done, then we'll see!"), gg_snd_Irmina31)
				call this.showPotionInfo(character)
				call this.showStartPage(character)
			// (Irmina braut keinen speziellen Trank, der Charakter hat sich den letzten aber noch nicht abgeholt)
			elseif (this.finishedPotion(character)) then
				call speech(info, character, true, tre("Gut, hier hast du noch deinen letzten Trank und welcher darf's als Nächstes sein?", "Well, here you still have your last potion and which must be the next?"), gg_snd_Irmina32)
				call this.finishPotionCreation(character)
				call this.showRange(13, 16, character)
			endif
		endmethod

		// (Irmina braut einen Trank für den Charakter oder ist bereits fertig damit)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			local thistype this = thistype(info.talk())
			return this.createsPotion(character) or this.finishedPotion(character)
		endmethod

		// Hast du den Trank für mich?
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hast du den Trank für mich?", "Do you have the potion for me?"), null)
			// (Der Trank ist fertig)
			if (this.finishedPotion(character)) then
				call speech(info, character, true, tre("Ja. Bitteschön, hier hast du ihn.", "Yes. Here you go, here you have it."), gg_snd_Irmina33)
				call this.finishPotionCreation(character)
			// (Der Trank ist noch nicht fertig)
			else
				call speech(info, character, false, tre("Nein. Es dauert noch eine Weile.", "No. It takes a while."), gg_snd_Irmina34)
				call this.showPotionInfo(character)
			endif
			call this.showStartPage(character)
		endmethod

		// Was verkaufst du denn?
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was verkaufst du denn?", "What are you selling?"), null)
			call speech(info, character, true, tre("Alles was man braucht, um den Alltag, ob nun den eines gewöhnlichen Bürgers oder eines Kriegers, gut zu überstehen. Tränke, Salben, Kräuter, Lebensmittel und noch ein paar andere Sachen.", "Everything you need to survive the everyday life well, whether it is one of an ordinary citizen or a warrior. Potions, salves, herbals, food and a few other things."), gg_snd_Irmina2)
			call speech(info, character, true, tre("Sieh's dir einfach mal an!", "Just take a look at it!"), gg_snd_Irmina3)
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "Nein."), null)
			call speech(info, character, true, tre("Toll, sind den Leuten auf einmal die Goldmünzen ausgegangen oder was? Plötzlich, bei Kriegsgefahr sparen sie alle, dabei sollten sie es doch lieber jetzt noch mal ausgeben. Wie auch immer, ist ja deine Sache.", "Great, have people suddenly no more gold coins or what? Suddenly when the threaf of war is there they all save their gold, while they should rather spend it now. Anyway, this is your thing."), gg_snd_Irmina4)
			call info.talk().showStartPage(character)
		endmethod

		// Also Agihard, der mutige Waffenmeister!
		private static method infoAction3_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Also Agihard, der mutige Waffenmeister!", "So Agihard, the brave armourer!"), null)
			call speech(info, character, true, tre("Ich weiß, ich sollte nicht so daherreden, aber was ich empfinde, ist nun mal da. Ich wünschte nur, er käme eines Tages mal zu mir, um etwas zu kaufen, dann könnte ich mich nett mit ihm unterhalten.", "I know I should not start talking like that but what I feel happens to be there. I just wish he would someday come to be to buy something, then I could be having a pleasant conversation with him."), gg_snd_Irmina18)
			call speech(info, character, false, tre("Unterhalten ...", "Having a conversation ..."), null)
			call speech(info, character, true, tre("Ja! Ich würde ihm auch was umsonst geben.", "Yes! I would give him something for free."), gg_snd_Irmina19)
			call speech(info, character, false, tre("Genau.", "Exactly."), null)
			// Neuer Auftrag: „Talras' mutiger Waffenmeister“
			call QuestTheBraveArmourerOfTalras.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Glückwunsch!
		private static method infoAction3_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Glückwunsch!", "Congratulations!"), null)
			call speech(info, character, true, tre("Ja, Glück wünsche ich ihm wahrlich (seufzt).", "Yes, I really wish him luck (sighs)."), gg_snd_Irmina20)
			call info.talk().showStartPage(character)
		endmethod

		private static method potionAction takes AInfo info, ACharacter character, integer potion returns nothing
			local AIntegerVector ressources
			local integer i
			// (Charakter hat die nötigen Zutaten und die geforderten Goldmünzen)
			if (thistype(info.talk()).hasPotionRessources(character, potion) and thistype(info.talk()).hasPotionMoney(character, potion)) then
				call speech(info, character, true, tre("Gut, komm in ein paar Minuten wieder!", "Well, come back in a few minutes!"), gg_snd_Irmina28)
				// Charakter gibt Irmina die Zutaten.
				call character.removeGold(thistype.potionMoney(potion)) // remove gold
				set ressources = thistype.potionRessources(potion)
				set i = 0
				loop
					exitwhen (i == ressources.size())
					call character.inventory().removeItemType(ressources[i])
					set i = i + 1
				endloop
				call ressources.destroy()
				call thistype(info.talk()).startPotionCreation(character, potion)
				call info.talk().showStartPage(character) // return to start page
			// (Dem Charakter fehlen die nötigen Zutaten)
			elseif (not thistype(info.talk()).hasPotionRessources(character, potion)) then
				call speech(info, character, true, tre("Und wie ohne die nötigen Zutaten?", "And how without the necessary ingredients?"), gg_snd_Irmina29)
				call info.talk().showRange(13, 16, character)
			// (Dem Charakter fehlen die geforderten Goldmünzen)
			else
				call speech(info, character, true, tre("Ohne Bezahlung sicher nicht!", "Without payment certainly not!"), gg_snd_Irmina30)
				call info.talk().showRange(13, 16, character)
			endif
		endmethod

		// Ein Stärketrank.
		private static method infoAction6_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ein Stärketrank.", "A strength potion."), null)
			call thistype.potionAction(info, character, thistype.strengthPotion)
		endmethod

		// Ein Geschicklichkeitstrank.
		private static method infoAction6_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ein Geschicklichkeitstrank.", "A dexterity potion."), null)
			call thistype.potionAction(info, character, thistype.dexterityPotion)
		endmethod

		// Ein Reinigungstrank.
		private static method infoAction6_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ein Reinigungstrank.", "A clarity potion."), null)
			call thistype.potionAction(info, character, thistype.purificationPotion)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01S_0201, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tre("Wer bist du?", "Who are you?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2And3, thistype.infoAction2, tre("Kannst du mir auch was Spezielles brauen oder mischen?", "Can you brew or mix me something special?")) // 2
			call this.addInfo(false, false, thistype.infoCondition2And3, thistype.infoAction3, tre("Was macht dein Mann in Holzbruck?", "What does you husband do in Holzbruck?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Agihard mag dich.", "Agihard likes you.")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tre("Ich gehe nach Holzbruck.", "I'm going to Holzbruck.")) // 5
			call this.addInfo(true, false, thistype.infoCondition6, thistype.infoAction6, tre("Braue mir einen speziellen Trank!", "Make me a special potion!")) // 6
			call this.addInfo(true, false, thistype.infoCondition7, thistype.infoAction7, tre("Hast du den Trank für mich?", "Do you have the potion for me?")) // 7
			call this.addExitButton() // 8

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tre("Was verkaufst du denn?", "What are you selling?")) // 9
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Nein.", "No.")) // 10

			// info 3
			call this.addInfo(false, false, 0, thistype.infoAction3_0, tre("Also Agihard, der mutige Waffenmeister!", "So Agihard, the brave armourer!")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction3_1, tre("Glückwunsch!", "Congratulations!")) // 12

			// info 6
			call this.addInfo(true, false, 0, thistype.infoAction6_0, Format(tre("Ein Stärketrank (%1% Goldmünzen).", "A strength potion (%1% gold coins).")).i(thistype.potionMoney(thistype.strengthPotion)).result()) // 13
			call this.addInfo(true, false, 0, thistype.infoAction6_1, Format(tre("Ein Geschicklichkeitstrank (%1% Goldmünzen).", "A dexterity potion (%1% gold coins).")).i(thistype.potionMoney(thistype.dexterityPotion)).result()) // 14
			call this.addInfo(true, false, 0, thistype.infoAction6_2, Format(tre("Ein Reinigungstrank (%1% Goldmünzen).", "A clarity potion (%1% gold coins).")).i(thistype.potionMoney(thistype.purificationPotion)).result()) // 15
			call this.addBackToStartPageButton() // 16

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
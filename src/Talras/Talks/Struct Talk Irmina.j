library StructMapTalksTalkIrmina requires Asl, StructGameDmdfHashTable, StructMapQuestsQuestTheBraveArmourerOfTalras, StructMapQuestsQuestTheWayToHolzbruck

	struct TalkIrmina extends Talk
		private static constant real potionTime = 30.0
		private static constant integer strengthPotion = 'I01T'
		private static constant integer dexterityPotion = 'I01U'
		private static constant integer purificationPotion = 'I01V'
		private timer array m_potionTimer[6] // MapData.maxPlayers

		implement Talk

		private method showPotionInfo takes Character character returns nothing
			if (TimerGetRemaining(this.m_potionTimer[GetPlayerId(character.player())]) > 0.0) then
				call character.displayHint(Format(tr("Irminas %1% benötigt noch %2% Sekunden bis zur Fertigstellung.")).s(GetObjectName(DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], "Potion"))).time(R2I(TimerGetRemaining(this.m_potionTimer[GetPlayerId(character.player())]))).result())
			else
				call character.displayItemAcquired(GetItemTypeIdName(DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], "Potion")), Format(tr("Irminas %1% wurde fertiggestellt.")).s(GetObjectName(DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], "Potion"))).result())
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
			return DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], "Potion")
		endmethod

		private static method timerFunctionPotion takes nothing returns nothing
			local Character character = DmdfHashTable.global().handleInteger(GetExpiredTimer(), "Character")
			call thistype(thistype.talk()).showPotionInfo(character)
		endmethod

		private method startPotionCreation takes Character character, integer potion returns nothing
			if (this.m_potionTimer[GetPlayerId(character.player())] != null) then
				return
			endif
			set this.m_potionTimer[GetPlayerId(character.player())] = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_potionTimer[GetPlayerId(character.player())], "Character", character)
			call DmdfHashTable.global().setHandleInteger(this.m_potionTimer[GetPlayerId(character.player())], "Potion", potion)
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
			call UnitAddItemById(character.unit(), DmdfHashTable.global().handleInteger(this.m_potionTimer[GetPlayerId(character.player())], "Potion"))
			call DmdfHashTable.global().destroyTimer(this.m_potionTimer[GetPlayerId(character.player())])
			set this.m_potionTimer[GetPlayerId(character.player())] = null
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(8, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo. Möchtest du zufällig etwas bei mir kaufen?"), gg_snd_Irmina1)
			call info.talk().showRange(9, 10, character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wer bist du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Ich bin Irmina und sowohl der Stand hier als auch das Haus daneben gehören meinem Mann und mir. Ich verkaufe hier meine Ware, also falls du was brauchst ..."), gg_snd_Irmina5)
			call speech(info, character, true, tr("Ich kenne mich mit Kräutern und anderen Pflanzen bestens aus und weiß, wie man sich alle möglichen nützlichen Dinge zusammenmischt. Man könnte fast sagen, ich sei eine Alchemistin."), gg_snd_Irmina6)
			call speech(info, character, false, tr("Klingt gut."), null)
			call speech(info, character, true, tr("Das will ich doch meinen. Ich mache auch gerechte Preise, denn ich habe selbst genug zum Leben und wenn mein Mann wieder aus Holzbruck zurückkehrt, dann werde ich vermutlich mein Geschäft schließen und mich meinen Studien widmen."), gg_snd_Irmina7)
			call speech(info, character, true, tr("Das bringt nämlich letztlich mehr als die harte Arbeit hier."), gg_snd_Irmina8)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“)
		private static method infoCondition2And3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Kannst du mir auch was Spezielles brauen oder mischen?
		private static method infoAction2 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Kannst du mir auch was Spezielles brauen oder mischen?"), null)
			call speech(info, character, true, tr("Natürlich, aber das kostet dich auch ein wenig und du musst mir die Zutaten beschaffen."), gg_snd_Irmina9)
			call speech(info, character, true, tr("Ich muss hier nämlich meinen Laden führen und ich habe keine Lust mich noch um einen Bauern oder Jäger zu kümmern, der das für mich macht."), gg_snd_Irmina10)
			call speech(info, character, true, tr("Am besten gebe ich dir Abschriften meiner Zutaten- und Preislisten für besondere Tränke. Manche Zutaten sind sehr selten, was ja auch erklärt, warum ich sie nicht in meinem Sortiment habe."), gg_snd_Irmina11)
			/**
			 * Charakter erhält Zutatenliste.
			 */
			call character.giveQuestItem('I050')
			call character.displayItemAcquired(GetObjectName('I050'), tr("Listet alle Zutaten für Tränke von Irmina auf."))
			call info.talk().showStartPage(character)
		endmethod

		// Was macht dein Mann in Holzbruck?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Was macht dein Mann in Holzbruck?"), null)
			call speech(info, character, false, tr("Er hat dort Geschäfte zu erledigen. Er ist ein wohlhabender Kaufmann und handelt mit Salz, dem weißen Gold. Vor ein paar Monaten ist er mit einigen Wagen aufgebrochen, um sein Salz in Holzbruck zu verkaufen."), gg_snd_Irmina12)
			call speech(info, character, true, tr("Du musst wissen, dass er ursprünglich aus Holzbruck kommt und sich hier nur meinetwegen niedergelassen hat."), gg_snd_Irmina13)
			call speech(info, character, true, tr("Ich bin froh, einen solchen Mann getroffen und geheiratet zu haben. Meine Eltern waren einfache Leute und mussten noch viel härter arbeiten als ich und nun haben wir unser eigenes Haus hier und mir geht’s eigentlich recht gut."), gg_snd_Irmina14)
			call speech(info, character, true, tr("Na ja, jetzt da Krieg herrschen wird, sollten wir vielleicht woanders hingehen. Holzbruck gefällt mir zwar, aber das ist ja noch näher an der Grenze. Ich hoffe nur, dass meinem Mann nichts passiert."), gg_snd_Irmina15)
			call speech(info, character, true, tr("Er ist zwar ein netter Kerl, aber kein besonders starker. Ich glaube, er würde den Feinden, die in unser Königreich einfallen eher einen Handel vorschlagen als ihnen mit dem Schwert entgegenzutreten. Ganz anders als Agihard … (seufzt)"), gg_snd_Irmina16)
			call speech(info, character, false, tr("Agihard?"), null)
			call speech(info, character, true, tr("Ja, der Waffenmeister von Talras. Das ist ein starker Krieger. Egal was andere von ihm denken, ich weiß, dass er ein gutes Herz hat und Mut noch dazu. Ich glaube, er ist nur etwas einsam."), gg_snd_Irmina17)
			call info.talk().showRange(11, 12, character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ ist abgeschlossen)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestTheBraveArmourerOfTalras.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Agihard mag dich.
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Agihard mag dich."), null)
			call speech(info, character, true, tr("Was … äh .. wie bitte? Hast du etwa mit ihm gesprochen?"), gg_snd_Irmina21)
			call speech(info, character, false, tr("Ja."), null)
			call speech(info, character, true, tr("Du hast ihm doch nicht erzählt, was ich dir gesagt habe, oder?"), gg_snd_Irmina22)
			call speech(info, character, false, tr("Also …"), null)
			call speech(info, character, true, tr("Wie konntest du nur? Jetzt denkt er bestimmt etwas Falsches von mir."), gg_snd_Irmina23)
			call speech(info, character, false, tr("…"), null)
			call speech(info, character, true, tr("Was … also was hat er denn gesagt, also was genau?"), gg_snd_Irmina24)
			call speech(info, character, false, tr("Er meinte nur, dass er dich sehr gerne hat und vielleicht mal in nächster Zeit bei dir vorbeischaut."), null)
			call speech(info, character, true, tr("Tatsächlich! Ich meine, tatsächlich? Das wäre toll. Endlich mal eine gute Neuigkeit. Hier hast du ein paar Salben, danke!"), gg_snd_Irmina25)
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
			call speech(info, character, false, tr("Ich gehe nach Holzbruck."), null)
			call speech(info, character, true, tr("Tatsächlich? Nun, ich wünsche dir viel Glück und bitte sieh nach meinem Mann! Sein Name ist Lambert. Hier, nimm noch diese Tränke! Ich hoffe, sie werden dir von Nutzen sein."), gg_snd_Irmina26)
			// Charakter erhält Heiltränke
			call character.giveItem('I00B')
			call character.giveItem('I00B')
			call character.giveItem('I00B')
			call info.talk().showStartPage(character)
		endmethod

		// (Nachdem der Charakter danach gefragt hat)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(2, character)
		endmethod

		// Braue mir einen speziellen Trank!
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Braue mir einen speziellen Trank!"), null)
			// (Irmina braut keinen speziellen Trank für den Charakter)
			if (not thistype(info.talk()).createsPotion(character)) then
				call speech(info, character, true, tr("Gut, wenn du die Zutaten und Goldmünzen hast. Welcher darf's denn sein?"), gg_snd_Irmina27)
				call info.talk().showRange(13, 16, character)
			elseif (thistype(info.talk()).createsPotion(character)) then
			// (Irmina braut bereits einen speziellen Trank für den Charakter)
				call speech(info, character, true, tr("Ich braue dir doch bereits einen. Warte erst mal bis der fertig ist, dann sehen wir weiter!"), gg_snd_Irmina31)
				call thistype(thistype.talk()).showPotionInfo(character)
				call info.talk().showStartPage(character)
			// (Irmina braut keinen speziellen Trank, der Charakter hat sich den letzten aber noch nicht abgeholt)
			elseif (thistype(info.talk()).finishedPotion(character)) then
				call speech(info, character, true, tr("Gut, hier hast du noch deinen letzten Trank und welcher darf's als Nächstes sein?"), gg_snd_Irmina32)
				call thistype(info.talk()).finishPotionCreation(character)
				call info.talk().showRange(13, 16, character)
			endif
		endmethod

		// (Irmina braut einen Trank für den Charakter oder ist bereits fertig damit)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).createsPotion(character) or thistype(info.talk()).finishedPotion(character)
		endmethod

		// Hast du den Trank für mich?
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hast du den Trank für mich?"), null)
			// (Der Trank ist fertig)
			if (thistype(thistype.talk()).finishedPotion(character)) then
				call speech(info, character, true, tr("Ja. Bitteschön, hier hast du ihn."), gg_snd_Irmina33)
				call thistype(thistype.talk()).finishPotionCreation(character)
			// (Der Trank ist noch nicht fertig)
			else
				call speech(info, character, false, tr("Nein. Es dauert noch eine Weile."), gg_snd_Irmina34)
				call thistype(thistype.talk()).showPotionInfo(character)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// Was verkaufst du denn?
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was verkaufst du denn?"), null)
			call speech(info, character, true, tr("Alles was man braucht, um den Alltag, ob nun den eines gewöhnlichen Bürgers oder eines Kriegers, gut zu überstehen. Tränke, Salben, Kräuter, Lebensmittel und noch ein paar andere Sachen."), gg_snd_Irmina2)
			call speech(info, character, true, tr("Sieh's dir einfach mal an!"), gg_snd_Irmina3)
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("Toll, sind den Leuten auf einmal die Goldmünzen ausgegangen oder was? Plötzlich, bei Kriegsgefahr sparen sie alle, dabei sollten sie es doch lieber jetzt noch mal ausgeben. Wie auch immer, ist ja deine Sache."), gg_snd_Irmina4)
			call info.talk().showStartPage(character)
		endmethod

		// Also Agihard, der mutige Waffenmeister!
		private static method infoAction3_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Also Agihard, der mutige Waffenmeister!"), null)
			call speech(info, character, true, tr("Ich weiß, ich sollte nicht so daherreden, aber was ich empfinde, ist nun mal da. Ich wünschte nur, er käme eines Tages mal zu mir, um etwas zu kaufen, dann könnte ich mich nett mit ihm unterhalten."), gg_snd_Irmina18)
			call speech(info, character, false, tr("Unterhalten ..."), null)
			call speech(info, character, true, tr("Ja! Ich würde ihm auch was umsonst geben."), gg_snd_Irmina19)
			call speech(info, character, false, tr("Genau."), null)
			// Neuer Auftrag: „Talras' mutiger Waffenmeister“
			call QuestTheBraveArmourerOfTalras.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Glückwunsch!
		private static method infoAction3_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Ja, Glück wünsche ich ihm wahrlich (seufzt)."), gg_snd_Irmina20)
			call info.talk().showStartPage(character)
		endmethod

		private static method potionAction takes AInfo info, ACharacter character, integer potion returns nothing
			local AIntegerVector ressources
			local integer i
			// (Charakter hat die nötigen Zutaten und die geforderten Goldmünzen)
			if (thistype(info.talk()).hasPotionRessources(character, potion) and thistype(info.talk()).hasPotionMoney(character, potion)) then
				call speech(info, character, true, tr("Gut, komm in ein paar Minuten wieder!"), gg_snd_Irmina28)
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
				call speech(info, character, true, tr("Und wie ohne die nötigen Zutaten?"), gg_snd_Irmina29)
				call info.talk().showRange(13, 16, character)
			// (Dem Charakter fehlen die geforderten Goldmünzen)
			else
				call speech(info, character, true, tr("Ohne Bezahlung sicher nicht!"), gg_snd_Irmina30)
				call info.talk().showRange(13, 16, character)
			endif
		endmethod

		// Ein Stärketrank.
		private static method infoAction6_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ein Stärketrank."), null)
			call thistype.potionAction(info, character, thistype.strengthPotion)
		endmethod

		// Ein Geschicklichkeitstrank.
		private static method infoAction6_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ein Geschicklichkeitstrank."), null)
			call thistype.potionAction(info, character, thistype.dexterityPotion)
		endmethod

		// Ein Reinigungstrank.
		private static method infoAction6_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ein Reinigungstrank."), null)
			call thistype.potionAction(info, character, thistype.purificationPotion)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01S_0201, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Wer bist du?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2And3, thistype.infoAction2, tr("Kannst du mir auch was Spezielles brauen oder mischen?")) // 2
			call this.addInfo(false, false, thistype.infoCondition2And3, thistype.infoAction3, tr("Was macht dein Mann in Holzbruck?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Agihard mag dich.")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Ich gehe nach Holzbruck.")) // 5
			call this.addInfo(true, false, thistype.infoCondition6, thistype.infoAction6, tr("Braue mir einen speziellen Trank!")) // 6
			call this.addInfo(true, false, thistype.infoCondition7, thistype.infoAction7, tr("Hast du den Trank für mich?")) // 7
			call this.addExitButton() // 8

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tr("Was verkaufst du denn?")) // 9
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tr("Nein.")) // 10

			// info 3
			call this.addInfo(false, false, 0, thistype.infoAction3_0, tr("Also Agihard, der mutige Waffenmeister!")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction3_1, tr("Glückwunsch!")) // 12

			// info 6
			call this.addInfo(true, false, 0, thistype.infoAction6_0, Format(tr("Ein Stärketrank (%1% Goldmünzen).")).i(thistype.potionMoney(thistype.strengthPotion)).result()) // 13
			call this.addInfo(true, false, 0, thistype.infoAction6_1, Format(tr("Ein Geschicklichkeitstrank (%1% Goldmünzen).")).i(thistype.potionMoney(thistype.dexterityPotion)).result()) // 14
			call this.addInfo(true, false, 0, thistype.infoAction6_2, Format(tr("Ein Reinigungstrank (%1% Goldmünzen).")).i(thistype.potionMoney(thistype.purificationPotion)).result()) // 15
			call this.addBackToStartPageButton() // 16

			return this
		endmethod
	endstruct

endlibrary
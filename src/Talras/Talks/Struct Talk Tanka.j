library StructMapTalksTalkTanka requires Asl, StructMapTalksTalkBrogo, StructMapQuestsQuestShamansInTalras

	struct TalkTanka extends ATalk
		private static constant integer rewardGold = 30
		private integer array m_hints[6] /// @todo @member MapData.maxPlayers, vJass bug

		implement Talk

		private method addHint takes player whichPlayer returns nothing
			set this.m_hints[GetPlayerId(whichPlayer)] = this.m_hints[GetPlayerId(whichPlayer)] + 1
		endmethod

		private method hints takes player whichPlayer returns integer
			return this.m_hints[GetPlayerId(whichPlayer)]
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(12, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Hallo."), null)
			call speech(info, character, true, tr("Hallo. Scheint ja einiges los zu sein in dieser Gegend. Du bist nicht der Erste, der mir begegnet. Wie ich es geahnt habe, tut sich so einiges, wenn die Leute Angst bekommen."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wer bist du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Wer bist du?"), null)
			call speech(info, character, true, tr("Mein Name ist Tanka. Ich bin eine Schamanin und versuch ja nicht mich übers Ohr zu hauen, sonst haut mein Gefährte Brogo dich um."), null)
			// (Charakter hat noch nicht mit Brogo gesprochen)
			if (not TalkBrogo.talk().characterHasTalkedTo(character)) then
				call speech(info, character, false, tr("Wer ist Brogo?"), null)
				call speech(info, character, true, tr("Na das haarige Viech da neben mir. Er ist mein treuer Gefährte und beschützt mich vor den gröbsten Gefahren dieser Gegend."), null)
			// (Charakter hat bereits mit Brogo gesprochen)
			else
				call speech(info, character, false ,tr("Schon klar."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Und was machst du hier?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Und was machst du hier?"), null)
			call speech(info, character, true, tr("Die Frage sollte wohl eher lauten „Und was macht ihr hier?“. Wir jagen eine starke Bestie. Dieses Ungeheuer hat Brogos Stamm angegriffen und diesen so gut wie ausgerottet. Nur Brogo hier hat überlebt."), null)
			call speech(info, character, true, tr("Ich habe ihn gefunden und mich um seine Verletzungen gekümmert und nun jagen wir gemeinsam die Bestie."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“, Auftrag „Die Bestie“ ist noch nicht abgeschlossen)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character) and not QuestTheBeast.characterQuest(character).isCompleted()
		endmethod

		// Kannst du mir was beibringen?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kannst du mir was beibringen?"), null)
			call speech(info, character, true, tr("Können schon, aber wollen nicht unbedingt, sonst setzt du das Erlernte am Ende noch gegen mich ein und das fände ich nicht so toll."), null)
			call speech(info, character, true, tr("Sobald ich der Meinung bin, dass du in Ordnung bist, bringe ich dir vielleicht etwas Nützliches bei."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Handelst du auch mit irgendwas?
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Handelst du auch mit irgendwas?"), null)
			call speech(info, character, true, tr("Allerdings. Als Schamanin kann man seine Freizeit ganz gut nutzen, um diverse Zaubergegenstände und Tränke herzustellen, wenn man das nötige Wissen und die benötigten Zutaten hat."), null)
			call speech(info, character, true, tr("Also wenn du lustige Sachen mit deinen Gegnern anstellen willst, bist du bei mir genau richtig. Aber ich warne dich Fremder: Mit diesen einfachen Zaubertricks wirst du nichts gegen mich ausrichten können!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Und was machst du hier?“)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Was für ein Ungeheuer war das?
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Was für ein Ungeheuer war das?"), null)
			call speech(info, character, true, tr("Na, ein ziemlich großes eben. Diese Bestie ist verdammt blutrünstig und verdammt stark. Du musst wissen, dass Brogos Stamm nicht gerade klein war. Das Viech hat bestimmt zwanzig oder mehr Bärenmenschen getötet und da waren auch voll ausgewachsene dabei."), null)
			call speech(info, character, true, tr("Brogo ist ja noch recht jung, so ein ausgewachsener Bärenmensch ist wesentlich größer und stärker, also kannst du dir ausrechnen, wie stark die Bestie ist."), null)
			call speech(info, character, true, tr("Wir folgten der Fährte dieser Bestie bis hier her. Aber hier sind die Spuren zu undeutlich und Brogo konnte die Fährte nicht wieder aufnehmen. Vermutlich hat es zu lange gedauert, bis wir uns auf die Suche nach ihr machten."), null)
			call speech(info, character, true, tr("Brogo war ja auch schwer verwundet. Na ja, wenn du irgendeinen Hinweis in der Umgebung findest, dann gib mir einfach Bescheid."), null)
			call QuestTheBeast.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		private static method completeHints takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tr("Ich denke, dass reicht schon mit den Hinweisen. Wir werden uns wohl bald möglichst in Richtung Süden aufmachen, um die Bestie zu jagen. Hier hast du ein paar Flammengemische zur Belohnung. Ich hoffe, sie werden sich dir im Kampf als nützlich erweisen und hier sind natürlich noch ein paar Goldmünzen."), null)
			/// @todo Charakter erhält 6 Flammengemische
			call QuestTheBeast.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Bestie“ aktiv, Charakter war bei den Blutspuren)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return QuestTheBeast.characterQuest(character).isNew() and QuestTheBeast.characterQuest(character).foundTracks()
		endmethod

		// Ich habe einen Hinweis entdeckt.
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Ich habe einen Hinweis entdeckt."), null)
			call speech(info, character, true, tr("Welchen denn?"), null)
			call speech(info, character, false, tr("Weiter südlich von hier sind einige Blutspuren und tote Tiere. Könnte die Bestie gewesen sein."), null)
			call speech(info, character, true, tr("Ja, das wäre gut möglich. Ich danke dir. Hier hast du ein paar Goldmünzen zur Belohnung."), null)
			call character.addGold(thistype.rewardGold)
			call character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("%i Goldmünzen erhalten."), thistype.rewardGold))
			call thistype(info.talk()).addHint(character.player())
			// (Beide Hinweise wurden angesprochen)
			if (thistype(info.talk()).hints(character.player()) == 2) then
				call thistype.completeHints(info, character)
			else
				call info.talk().showStartPage(character)
			endif
		endmethod

		// (Auftrag „Die Bestie“ aktiv, Charakter hat mit Kuno darüber gesprochen)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return QuestTheBeast.characterQuest(character).isNew() and QuestTheBeast.characterQuest(character).talkedToKuno()
		endmethod

		// Der Holzfäller Kuno hat die Bestie gesehen.
		private static method infoAction7 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Der Holzfäller Kuno hat die Bestie gesehen."), null)
			call speech(info, character, true, tr("Und wo?"), null)
			call speech(info, character, false, tr("Weiter südlich. Vor ein paar Tagen ist sie an seiner Hütte vorbeigekommen während er im Bett lag."), null)
			call speech(info, character, true, tr("Und er ist sich sicher, dass es die Bestie war?"), null)
			call speech(info, character, false, tr("Na ja, er sprach von einem riesigen, haarigen Viech, welches nach Tod und Verderben stank."), null)
			call speech(info, character, true, tr("Das kann nur die Bestie gewesen sein. Hier hast du ein paar Goldmünzen zur Belohnung."), null)
			call character.addGold(thistype.rewardGold)
			call character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tr("%i Goldmünzen erhalten."), thistype.rewardGold))
			call thistype(info.talk()).addHint(character.player())
			// (Beide Hinweise wurden angesprochen)
			if (thistype(info.talk()).hints(character.player()) == 2) then
				call thistype.completeHints(info, character)
			else
				call info.talk().showStartPage(character)
			endif
		endmethod

		// (Nach „Kannst du mir was beibringen?“, Auftrag „Die Bestie“ ist abgeschlossen)
		private static method infoCondition8 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(3, character) and QuestTheBeast.characterQuest(character).isCompleted()
		endmethod

		// Bring mir was bei!
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Bring mir was bei!"), null)
			call speech(info, character, true, tr("Du hast die Spur der Bestie gefunden."), null)
			// (Auftrag „Katzen für Brogo“ ist abgeschlossen)
			if (QuestCatsForBrogo.characterQuest(character).isCompleted()) then
				call speech(info, character, true, tr("Außerdem hast du Brogo Katzen geschenkt."), null)
				call speech(info, character, true, tr("Du bist ein wahrer Freund und ich werde dich alles lehren, was ich weiß. Dennoch verlange ich ein paar Goldmünzen dafür. Ich muss schließlich auch von etwas leben, also nimm's bitte nicht persönlich."), null)
			// (Auftrag „Katzen für Brogo“ ist nicht abgeschlossen)
			else
				call speech(info, character, true, tr("Das reicht mir als Beweis, dass du in Ordnung bist. Gut, ich werde dir ein paar Sachen beibringen. Aber die wirklich nützlichen Dinge erfährst du erst, wenn ich dir wie einem guten Freund vertraue. Das Ganze kostet dich allerdings auch eine Kleinigkeit."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Bring mir was bei!“)
		private static method infoCondition9 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(8, character)
		endmethod

		// Zeig mir wie man …
		private static method infoAction9 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Zeig mir wie man …"), null)
			call info.talk().showRange(13, 17, character)
		endmethod
		
		// (Nach „Hallo“ und Charakter hat mit Tellborn gesprochen und Auftrag „Schamanen in Talras“ noch nicht erhalten)
		private static method infoConditionYouKnowTellborn takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and TalkTellborn.talk.evaluate().infoHasBeenShownToCharacter(0, character) and QuestShamansInTalras.characterQuest(character).isNotUsed()
		endmethod
		
		// Kennst du Tellborn?
		private static method infoActionYouKnowTellborn takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Kennst du Tellborn?"), null)
			call speech(info, character, true, tr("Wen?"), null)
			call speech(info, character, false, tr("Tellborn, einen Schamanen, der sich weiter südlich von hier aufhält."), null)
			call speech(info, character, true, tr("Ich bin ja nicht gerade lange in dieser Gegend, daher kenne ich auch niemanden hier."), null)
			call speech(info, character, true, tr("Aber sag, ist er wirklich ein Schamane oder behauptet er das nur von sich?"), null)
			call speech(info, character, false, tr("Also …"), null)
			call speech(info, character, true, tr("Es ist immer wieder ein Ereignis seinesgleichen in den entlegensten Teilen dieser Welt anzutreffen. Vielleicht sollte ich mich einmal mit ihm unterhalten."), null)
			call speech(info, character, true, tr("Leider kann ich Brogo hier nicht einfach sitzen lassen. Willst du vielleicht diesem „Tellborn“ ein Schreiben von mir überbringen?"), null)
			
			call info.talk().showRange(18, 19, character)
		endmethod
		
		// (Charakter hat „Brief an Tanka“ dabei)
		private static method infoConditionLetterFromTellborn  takes AInfo info, ACharacter character returns boolean
			return character.inventory().hasItemType('I03K')
		endmethod
		
		// Hier ist ein Brief von Tellborn.
		private static method infoActionLetterFromTellborn takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Hier ist ein Brief von Tellborn."), null)
			// (Charakter hat zuvor das Schreiben für Tellborn an diesen geliefert)
			if (QuestShamansInTalras.characterQuest(character).questItem(1).isCompleted()) then
				call speech(info, character, true, tr("Er hat sich also die Mühe gemacht zu antworten. Immerhin! Nun gib schon her, ich will wissen, was er schreibt."), null)
				call speech(info, character, false, tr("Hier hast du den Brief."), null)
				// „Brief an Tanka“ übergeben
				call character.inventory().removeItemType('I03K')
				call speech(info, character, true, tr(" Vielen Dank! Zu gerne will ich wissen, was hinter ihm steckt. Hier nimm dies als Belohnung."), null)
				// Auftrag „Schamanen in Talras“ abgeschlossen
				call QuestShamansInTalras.characterQuest(character).complete()
				// Tankas Belohnung überreichen
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I03L')
			// (Charakter kommt zum ersten Mal im Aufrag von Tellborn)
			else
				call speech(info, character, true, tr("Von wem?"), null)
				call speech(info, character, false, tr("Von Tellborn, einem Schamanen südlich von hier. Ich habe ihm von dir erzählt, da ihr offensichtlich beide Schamanen seid."), null)
				call speech(info, character, true, tr("Wie bitte? Wie konntest du … was schreibt er denn?"), null)
				call speech(info, character, false, tr("Hier, lies selbst."), null)
				// „Brief an Tanka“ übergeben
				call character.inventory().removeItemType('I03K')
				call speech(info, character, true, tr("(Liest) Aha, unglaublich! Ich muss ihm sofort antworten. Lauf ja nicht weg!"), null)
				call speech(info, character, false, tr("Schon gut."), null)
				call speech(info, character, true, tr("(Verfasst ein Schreiben)"), null)
				call speech(info, character, true, tr("So, da hast du ein Schreiben für ihn. Bring es ihm so schnell wie möglich!"), null)
				// Auftragsziel 1 des Auftrags „Schamanen in Talras“ abgeschlossen
				call QuestShamansInTalras.characterQuest(character).questItem(0).complete()
				// Auftragsziel 2 des Auftrags „Schamanen in Talras“ aktiviert
				call QuestShamansInTalras.characterQuest(character).questItem(1).enable()
				// „Schreiben für Tellborn“ erhalten
				call character.giveQuestItem('I03J')
			endif
			call info.talk().showStartPage(character)
		endmethod
		

		// (Auftrag „Die Bestie“ ist abgeschlossen)
		private static method infoCondition8_0and1 takes AInfo info, ACharacter character returns boolean
			return QuestTheBeast.characterQuest(character).isCompleted()
		endmethod

		// … seine Waffen vergiftet.
		private static method infoAction8_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("… seine Waffen vergiftet."), null)
			/// @todo Charakter erhält Gegenstand „Angriffs-Totem“
			call speech(info, character, true, tr("Tja, der Entwickler dieser Mod sollte das mal einbauen!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// … seinen Körper entflammt.
		private static method infoAction8_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("… seinen Körper entflammt."), null)
			/// @todo Charakter erhält Gegenstand „Verteidigungs-Totem“
			call speech(info, character, true, tr("Tja, der Entwickler dieser Mod sollte das mal einbauen!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Bestie“ und Auftrag „Katzen für Brogo“ sind abgeschlossen)
		private static method infoCondition8_2and3 takes AInfo info, ACharacter character returns boolean
			return QuestTheBeast.characterQuest(character).isCompleted() and QuestCatsForBrogo.characterQuest(character).isCompleted()
		endmethod

		// … seinen Schmerz teilt.
		private static method infoAction8_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("… seinen Schmerz teilt."), null)
			/// @todo Charakter erhält Gegenstand „Geistes-Totem“
			call speech(info, character, true, tr("Tja, der Entwickler dieser Mod sollte das mal einbauen!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// … seinen Körper vervielfacht.
		private static method infoAction8_3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("… seinen Körper vervielfacht."), null)
			/// @todo Charakter erhält Gegenstand „Körper-Totem“
			call speech(info, character, true, tr("Tja, der Entwickler dieser Mod sollte das mal einbauen!"), null)
			call info.talk().showStartPage(character)
		endmethod
		
		// Klar.
		private static method infoActionYouKnowTellborn_Sure  takes AInfo info, Character character returns nothing
			call speech(info, character, false, tr("Klar."), null)
			call speech(info, character, true, tr("Ich danke dir! Warte kurz bis ich das Schreiben aufgesetzt habe."), null)
			call speech(info, character, true, tr("(Setzt ein Schreiben auf)"), null)
			call speech(info, character, true, tr("So, hier hast du es. Mal sehen, was er dazu sagt …"), null)
			// Neuer Auftrag „Schamanen in Talras“
			call QuestShamansInTalras.characterQuest(character).enable()
			// Auftragsziel 2 aktiviert
			call QuestShamansInTalras.characterQuest(character).questItem(1).enable()
			// „Schreiben für Tellborn“ erhalten
			call character.giveQuestItem('I03J')
			call info.talk().showStartPage(character)
		endmethod
		
		// Nein.
		private static method infoActionYouKnowTellborn_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Nein."), null)
			call speech(info, character, true, tr("chade, überlege es dir doch noch einmal."), null)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n023_0011, thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_hints[i] = 0
				set i = i + 1
			endloop
			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tr("Hallo.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tr("Wer bist du?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tr("Und was machst du hier?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tr("Kannst du mir was beibringen?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tr("Handelst du auch mit irgendwas?")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tr("Was für ein Ungeheuer war das?")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tr("Ich habe einen Hinweis entdeckt.")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tr("Der Holzfäller Kuno hat die Bestie gesehen.")) // 7
			call this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tr("Bring mir was bei!")) // 8
			call this.addInfo(true, false, thistype.infoCondition9, thistype.infoAction9, tr("Zeig mir wie man …")) // 9
			call this.addInfo(true, false, thistype.infoConditionYouKnowTellborn, thistype.infoActionYouKnowTellborn, tr("Kennst du Tellborn?")) // 10
			call this.addInfo(false, false, thistype.infoConditionLetterFromTellborn, thistype.infoActionLetterFromTellborn, tr("Hier ist ein Brief von Tellborn.")) // 11
			call this.addExitButton() // 12

			// info 8
			call this.addInfo(true, false, thistype.infoCondition8_0and1, thistype.infoAction8_0, tr("… seine Waffen vergiftet.")) // 13
			call this.addInfo(true, false, thistype.infoCondition8_0and1, thistype.infoAction8_1, tr("… seinen Körper entflammt.")) // 14
			call this.addInfo(true, false, thistype.infoCondition8_2and3, thistype.infoAction8_2, tr("… seinen Schmerz teilt.")) // 15
			call this.addInfo(true, false, thistype.infoCondition8_2and3, thistype.infoAction8_3, tr("… seinen Körper vervielfacht.")) // 16
			call this.addBackToStartPageButton() // 17
			
			// info 10
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTellborn_Sure, tr("Klar.")) // 18
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTellborn_No, tr("Nein.")) // 19

			return this
		endmethod
	endstruct

endlibrary
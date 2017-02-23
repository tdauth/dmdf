library StructMapTalksTalkTellborn requires Asl, StructMapTalksTalkFulco, StructMapTalksTalkTanka, StructMapQuestsQuestShamansInTalras

	struct TalkTellborn extends Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(7, character)
		endmethod

		// Hallo.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo, werter Herr. Bist du auch auf der Durchreise oder was treibt dich in diese Gegend?", "Hello, my dear sir. Are you on the road or what drives you to this area?"), gg_snd_Tellborn1)
			call speech(info, character, false, tre("Durchreise?", "On the road?"), null)
			call speech(info, character, true, tre("Ja, mein Freund Fulco und ich sind auf dem Weg in den Süden, vielleicht auch Osten. Das wissen wir noch nicht so genau.", "Yes, my friend Fulco and I are on the way to the south, maybe also east. We do not know yet."), gg_snd_Tellborn2)
			call speech(info, character, true, tre("Hier soll es ja bald zu Kämpfen kommen und da verziehen wir uns lieber.", "Here, soon, there will be fights and therefore we'd better leave."), gg_snd_Tellborn3)
			call speech(info, character, true, tre("Meinen Freund Fulco hast du sicherlich schon bemerkt. Das ist der Bär da in der Ecke. Aber keine Angst, eigentlich ist er ein Mensch.", "My friend Fulco you certainly have already noticed. THis is the bear in the corner. But do not worry, actually he is a human being."), gg_snd_Tellborn4)
			call speech(info, character, true, tre("Du musst wissen, mir ist da ein kleines Missgeschick passiert.", "You must know, a little misfortune happened because of me."), gg_snd_Tellborn5)
			// (Fulco hats erzählt)
			if (TalkFulco.talk().infoHasBeenShownToCharacter(0, character)) then
				call speech(info, character, false, tre("Ja, Fulco hat's mir schon erzählt.", "Yes, Fulco told me."), null)
				call speech(info, character, true, tre("Dann weißt du ja Bescheid. Es tut mir wirklich schrecklich leid, das Ganze.", "Then you know, I'm really terribly sorry for the whole thing."), gg_snd_Tellborn6)
			else
				call speech(info, character, false, tre("Missgeschick?", "Misfortune?"), null)
				call speech(info, character, true, tre("Ja, mein Freund bekam vor einigen Tagen Fieber und da ich ja selbst ein Schamane bin, wollte ich ihm natürlich dabei helfen, die Krankheit zu besiegen.", "Yes, my friend got fever a few days ago, and since I am a shaman myself, I naturally wanted to help him to defeat the disease."), gg_snd_Tellborn7)
				call speech(info, character, true, tre("Also habe ich einen Zauber auf ihn gesprochen, nur hat das dann irgendwie nicht so ganz geklappt und er verwandelte sich plötzlich in einen Bären.", "So I spoke a spell on him, but it did not work out quite well and suddenly he turned into a bear."), gg_snd_Tellborn8)
				call speech(info, character, true, tre("Das wollte ich wirklich nicht, das musst du mir glauben! Was sollen wir denn jetzt bloß tun? Am Ende wird er noch von einem Jäger erlegt.", "I really did not want that, you must believe me! What are we going to do now? In the end, he might be even killed by a hunter."), gg_snd_Tellborn9)
				/// @todo Charakter lacht/grinst, irgendeine Freudenanimation
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Kann ich dir irgendwie bei deinem Missgeschick helfen?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kann ich dir irgendwie bei deinem Missgeschick helfen?", "Can I help you somehow in your misfortune?"), null)
			call speech(info, character, true, tre("Ja, das könntest du tatsächlich.", "Yes, you could."), gg_snd_Tellborn10)
			call speech(info, character, true, tre("Es gäbe da eine Möglichkeit, meinen Freund von dem bösen Zauber zu befreien. Ich bräuchte nur die richtigen Zutaten und ...", "There would be a way to free my friend from the evil spell. I need only the right ingredients and ..."), gg_snd_Tellborn11)
			call speech(info, character, true, tre("Pass auf, wenn du mir wirklich helfen willst, dann gebe ich dir eine Liste mit Zutaten. Falls du es schaffen solltest, mir die zu besorgen, werde ich dich reich belohnen!", "Watch out if you really want to help me, I'll give you a list of ingredients. If you could manage to get me this, I'll reward you richly!"), gg_snd_Tellborn12)
			call info.talk().showRange(8, 9, character)
		endmethod

		// (Auftrag „Mein Freund der Bär“ ist aktiv und Charakter hat alle Zutaten im Inventar)
		private static method infoCondition2 takes AInfo info, Character character returns boolean
			return QuestMyFriendTheBear.characterQuest(character).isNew() and character.inventory().hasItemType('I03F') and character.inventory().hasItemType('I03G') and character.inventory().hasItemType('I03H')
		endmethod

		// Hier hast du deine Zutaten.
		private static method infoAction2 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Hier hast du deine Zutaten.", "Here you have your ingredients."), gg_snd_Tellborn13)
			/// Zutaten geben
			call character.inventory().removeItemType('I03F')
			call character.inventory().removeItemType('I03G')
			call character.inventory().removeItemType('I03H')
			call speech(info, character, true, tre("Danke! Du hast es tatsächlich geschafft. Ich bin begeistert. Leider fehlen mir doch noch ein paar weitere Zutaten, um den Trank brauen zu können, der meinen Freund zurückverwandelt.", "Thank you! You actually did it. I'm excited. Unfortunately, I still lack a few more ingredients to brew the potion that will convert my friend back."), gg_snd_Tellborn15)
			call speech(info, character, true, tre("Aber es sollte kein Problem sein, die selbst zusammenzusuchen.", "But it should not be a problem to collect them by myself."), gg_snd_Tellborn16)
			call speech(info, character, true, tre("Hier hast du deine Belohnung, hast sie dir wirklich verdient!", "Here you have your reward, you really deserve it!"), gg_snd_Tellborn17)
			call QuestMyFriendTheBear.characterQuest(character).complete()
			// 4 Spruchrollen der Geborgenheit
			call character.giveItem('I00U')
			call character.giveItem('I00U')
			call character.giveItem('I00U')
			call character.giveItem('I00U')
			// Tellborns Geisterrune
			call character.giveItem('I03I')
			call info.talk().showStartPage(character)
		endmethod

		// Was trägst du da für eine Kleidung?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was trägst du da für eine Kleidung?", "What kind of clothes are you wearing?"), null)
			call speech(info, character, true, tre("Das ist die Schamanentracht von uns Trollen und ich bin, wie dur denken kannst, Schamane.", "That is the shaman's clothing of us trolls an I am, as you can guess, a shaman."), gg_snd_Tellborn18)
			call speech(info, character, true, tre("Also wenn du Zauber, Tränke oder Sonstiges brauchst: Ich handele auch gerne.", "So if you need spells, potions or other things: I also like to trade."), gg_snd_Tellborn19)
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat negative Zaubereffekte an sich)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			local unit characterUnit = character.unit()
			local boolean result = UnitCountBuffsEx(characterUnit, true, false, true, false, false, false, false) > 0
			set characterUnit = null
			return result
		endmethod

		// Böse Geister plagen mich!
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			local unit npc = info.talk().unit()
			local unit characterUnit = character.unit()
			call speech(info, character, false, tre("Böse Geister plagen mich!", "Evil spirits plague me!"), null)
			call SetUnitAnimation(npc, "Spell")
			call ResetUnitAnimation(npc)
			call speech(info, character, true, tre("Verschwindet ihr Geister und lasst diesen Körper frei!", "Disappear you spirits and release this body!"), gg_snd_Tellborn20)
			call UnitRemoveBuffsEx(characterUnit, false, true, true, false, false, false, false)
			set npc = null
			set characterUnit = null
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo“ und Charakter hat mit Tanka gesprochen und Auftrag „Schamanen in Talras“ noch nicht erhalten)
		private static method infoConditionYouKnowTanka takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and TalkTanka.talk().infoHasBeenShownToCharacter(0, character) and QuestShamansInTalras.characterQuest(character).isNotUsed()
		endmethod

		// Kennst du Tanka?
		private static method infoActionYouKnowTanka  takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kennst du Tanka?", "Do you know Tanka?"), null)
			call speech(info, character, true, tre("Verzeihung, wen soll ich kennen?", "Excuse me, who should I know?"), gg_snd_Tellborn21)
			call speech(info, character, false, tre("Tanka, eine Schamanin. Sie befindet sich weiter nördlich von hier und hat einen ähnlichen Freund wie du.", "Tanka, a shaman, she is further north of here and has a similar friend as you."), null)
			call speech(info, character, true, tre("Tanka … nein das sagt mir tatsächlich nichts. Du behauptest sie ist eine Schamanin? Sehr interessant … Ich muss sagen man trifft doch seltener auf unseresgleichen als man vielleicht annehmen würde.", "Tanka ... no, that actually tells me nothing. You say she is a shaman? Very interesting ... I have to say you are less likely to meet your own kind than you might think."), gg_snd_Tellborn22)
			call speech(info, character, true, tre("Und sie hat auch einen Bären als Freund? Sehr merkwürdig …", "And she also has a bear as a friend? Very strange ..."), gg_snd_Tellborn23)
			call speech(info, character, false, tre("Sowas in der Art.", "Something like that."), null)
			call speech(info, character, true, tre("Vielleicht sollte ich diese Chance nutzen. Es kann nie schaden das eigene Wissen zu erweitern und die Welt aus der Sicht einer anderen Person zu betrachten.", "Maybe I should take advantage of this opportunity. It can never hurt to expand one's own knowledge and look at the world from the perspective of another person."), gg_snd_Tellborn24)
			call speech(info, character, true, tre("Sag wärst du bereit dieser Tanka einen Brief von mir zu bringen?", "Tell me, are you ready to get this Tanka a letter from me?"), gg_snd_Tellborn25)

			call info.talk().showRange(10, 11, character)
		endmethod

		// (Auftragsziel 2 des Auftrags „Schamanen in Talras“ ist aktiv und Charakter hat „Schreiben für Tellborn“ dabei)
		private static method infoConditionLetterFromTanka takes AInfo info, ACharacter character returns boolean
			return QuestShamansInTalras.characterQuest(character).questItem(1).isNew() and character.inventory().hasItemType('I03J')
		endmethod

		// Hier ist ein Schreiben von Tanka.
		private static method infoActionLetterFromTanka  takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Hier ist ein Schreiben von Tanka.", "Here is a letter from Tanka."), null)
			// (Charakter hat zuvor einen Brief an Tanka gebracht)
			if (QuestShamansInTalras.characterQuest(character).questItem(0).isCompleted()) then
				call speech(info, character, true, tre("Und, was hat sie gesagt?", "And what did she say?"), gg_snd_Tellborn30)
				call speech(info, character, false, tre("Nun lies doch einfach.", "Just read it now."), null)
				call speech(info, character, true, tre("Ich traue mich fast gar nicht. Na gut, gib her!", "I almost do not trust dare to. Well, give it!"), gg_snd_Tellborn31)
				// „Schreiben für Tellborn“ übergeben
				call character.inventory().removeItemType('I03J')
				call speech(info, character, false, tre("Hier.", "Here."), null)
				call speech(info, character, true, tre("Unglaublich! Ich freue mich wie ein kleines Kind darauf den Inhalt zu lesen. Hab vielen Dank, du hast mir einen großen Dienst erwiesen.", "Incredible! I am looking forward to reading the content like a small child. Thank you very much, you have given me a great service."), gg_snd_Tellborn32)
				call speech(info, character, true, tre("Hier nimm dies als Belohnung.", "Here, take this reward."), gg_snd_Tellborn33)
				// Auftrag „Schamanen in Talras“ abgeschlossen
				call QuestShamansInTalras.characterQuest(character).complete()
				// Tellborns Belohnung überreichen
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00B')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I00C')
				call character.giveItem('I03M')
			// (Charakter bringt einen Brief von Tanka mit ohne dass Tellborn einen Brief geschickt hat)
			else
				call speech(info, character, true, tre("Ein Schreiben von wem?", "A letter from whom?"), gg_snd_Tellborn34)
				call speech(info, character, false, tre("Von Tanka, einer Schamanin nördlich von hier. Ich habe ihr von dir erzählt, da ihr beide Schamanen seid.", "From Tanka, a shaman from the north. I told her about you, since you are both shamans."), null)
				call speech(info, character, true, tre("Tatsächlich? Eine andere Schamanin hier in Talras? Das gibt es doch gar nicht. Nun rück schon raus mit dem Schreiben!", "Really? There is another shaman here in Talras? This is impossible. Now give me the letter finally!"), gg_snd_Tellborn35)
				// „Schreiben für Tellborn“ übergeben
				call character.inventory().removeItemType('I03J')
				call speech(info, character, false, tre("Hier.", "Here."), null)
				call speech(info, character, true, tre("(Liest) Faszinierend! Warte, ich werde ihr eine Antwort schreiben.", "(Reads) Fascinating! Wait, I'll write her a reply."), gg_snd_Tellborn36)
				call speech(info, character, true, tre("(Schreibt einen Brief)", "(Write a letter)"), null)
				call speech(info, character, true, tre("Hier hast du den Brief und verliere ihn bloß nicht! Hoffentlich werde ich sie damit nicht verärgern.", "Here you have the letter and do not lose it! I hope I will not upset her."), gg_snd_Tellborn37)
				// „Brief an Tanka“ erhalten
				call character.giveQuestItem('I03K')
				// Auftragsziel 2 des Auftrags „Schamanen in Talras“ abgeschlossen
				call QuestShamansInTalras.characterQuest(character).questItem(1).complete()
				// Auftragsziel 1 des Auftrags „Schamanen in Talras“ aktiviert
				call QuestShamansInTalras.characterQuest(character).questItem(0).enable()
			endif

			call info.talk().showStartPage(character)
		endmethod

		// Immer doch. Nur her mit der Liste!
		private static method infoAction1_0 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Immer doch. Nur her mit der Liste!", "Always. Just come up with the list!"), null)
			call speech(info, character, true, tre("Hier hast du sie.", "Here you have them."), null)
			call character.giveQuestItem('I00X')
			call QuestMyFriendTheBear.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär.
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär.", "Actually, I like your frined quite well, just as he is. Nice fluffy, the bear."), null)
			call speech(info, character, true, tre("Ja ja, mach dich nur über mich lustig!", "Yes, just make fun of me!"), gg_snd_Tellborn14)
			call info.talk().showStartPage(character)
		endmethod

		// Klar.
		private static method infoActionYouKnowTanka_Sure takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Klar.", "Sure."), null)
			call speech(info, character, true, tre("Beim Felle meines behaarten Freundes! Hab vielen Dank dafür, ich werde dich natürlich auch entsprechend belohnen.", "In the skins of my hairy friend! Thanks for that, I will also reward you of course."), gg_snd_Tellborn26)
			call speech(info, character, false, tre("Der Brief …", "The letter ..."), null)
			call speech(info, character, true, tre("Aber natürlich, warte einen kurzen Moment.", "Of course, wait a moment."), gg_snd_Tellborn27)
			call speech(info, character, true, tre("(Schreibt einen Brief)", "(Writes a letter)"), null)
			call speech(info, character, true, tre("Da hast du ihn. Ich hoffe ich habe den richtigen Ton gewählt.", "There you have it. I hope I have chosen the right tone."), gg_snd_Tellborn28)
			// Neuer Auftrag „Schamanen in Talras“
			call QuestShamansInTalras.characterQuest(character).enable()
			// Auftragsziel 1 aktiviert
			call QuestShamansInTalras.characterQuest(character).questItem(0).enable()
			// „Brief an Tanka“ erhalten
			call character.giveQuestItem('I03K')
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionYouKnowTanka_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Schade, vielleicht überlegst du es dir noch mal.", "Too bad, maybe you think about it again."), gg_snd_Tellborn29)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.tellborn(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tre("Kann ich dir irgendwie bei deinem Missgeschick helfen?", "Can I help you somehow in your misfortune?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tre("Hier hast du deine Zutaten.", "Here you have your ingredients.")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tre("Was trägst du da für eine Kleidung?", "What kind of clothes are you wearing?")) // 3
			call this.addInfo(true, false, thistype.infoCondition4, thistype.infoAction4, tre("Böse Geister plagen mich!", "Evil spirits plague me!")) // 4
			call this.addInfo(true, false, thistype.infoConditionYouKnowTanka, thistype.infoActionYouKnowTanka, tre("Kennst du Tanka?", "Do you know Tanka?")) // 5
			call this.addInfo(false, false, thistype.infoConditionLetterFromTanka, thistype.infoActionLetterFromTanka, tre("Hier ist ein Schreiben von Tanka.", "Here is a letter from Tanka.")) // 6
			call this.addExitButton() // 7

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tre("Immer doch. Nur her mit der Liste!", "Always. Just come up with the list!")) // 8
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tre("Eigentlich gefällt mir dein Freund ganz gut, so wie er ist. Schön flauschig, der Bär.", "Actually, I like your frined quite well, just as he is. Nice fluffy, the bear.")) // 9

			// info 5
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTanka_Sure, tre("Klar.", "Sure.")) // 10
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTanka_No, tre("Nein.", "No.")) // 11

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
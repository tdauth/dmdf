library StructMapTalksTalkFulco requires Asl, StructGameClasses, StructMapQuestsQuestMyFriendTheBear

	struct TalkFulco extends Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(4, character)
		endmethod

		// Hallo Bär.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo Bär.", "Hello bear."), null)
			call speech(info, character, true, tre("￼Ja ja, mach dich nur lustig über mich! Es ist ja auch so zum Lachen, wenn man aussieht wie ein Bär.", "Hey, hey, just make fun of me! It is quite funny if you look like a bear."), gg_snd_Fulco1)
			call speech(info, character, false, tre("Allerdings.", "Certainly."), null)
			call info.talk().showRange(5, 6, character)
		endmethod

		// (Auftrag „Mein Freund der Bär“ abgeschlossen)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return QuestMyFriendTheBear.characterQuest(character).isCompleted()
		endmethod

		// Ich habe gehört, du hast Tellborn einige Zutaten für seinen Trank besorgt
		private static method infoAction1 takes AInfo info, Character character returns nothing
			call speech(info, character, true, tre("Ich habe gehört, du hast Tellborn einige Zutaten für seinen Trank besorgt.", "I heard you got a few ingredients for Tellborn for his potion."), gg_snd_Fulco5)
			call speech(info, character, true, tre("Ich danke dir vielmals. Bald werde ich wieder aussehen wie ein Mensch! Hier hast du ein paar Gegenstände.", "I thank you very much. Soon I will look again like a man! Here you have a few items."), gg_snd_Fulco6)
			// Charakter erhält 3 Manatränke und 1 Ring der Verborgenheit.
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00V')
			call info.talk().showStartPage(character)
		endmethod

		// Du siehst aus wie ein Magier.
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Du siehst aus wie ein Magier.", "You look like a magician."), null)
			call speech(info, character, true, tre("￼￼Zauberer, wenn ich bitten darf. Das ist die korrekte Bezeichnung. Ich bin nicht irgendein Hokuspokusmöchtegernmagier, der Feuerbälle auf seine Feinde wirft. Ich suche nach Wissen.", "Wizard, if you please. This is the correct name. I'm not some hocus pocus magician throwing fireballs at his enemies. I'm looking for knowledge."), gg_snd_Fulco7)
			// (Charakter ist Zauberer)
			if (character.class() == Classes.wizard()) then
				call speech(info, character, true, tre("Das solltest du selbst aber am besten wissen.", "But that you should know yourself."), gg_snd_Fulco8)
			endif
			call info.talk().showStartPage(character)
		endmethod

		//  (Nach der Feststellung, dass Fulco ein Zauberer ist)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(2, character)
		endmethod

		// ￼Meine Zauberkraft ist fast erloschen!
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			local effect whichEffect
			call speech(info, character, false, tre("￼Meine Zauberkraft ist fast erloschen!", "My magic power is almost out!"), null)
			// Fulco macht Bewegungen.
			call QueueUnitAnimation(Npcs.fulco(), "Spell Channel")
			set whichEffect = AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIma\\AImaTarget.mdl", character.unit(), "chest")
			call speech(info, character, true, tre("Da hast du sie wieder.", "There you have it again."), gg_snd_Fulco9)
			// Das Mana des Charakters wird aufgefüllt.
			call SetUnitState(character.unit(), UNIT_STATE_MANA, GetUnitState(character.unit(), UNIT_STATE_MAX_MANA))
			call DestroyEffect(whichEffect)
			set whichEffect = null
			call info.talk().showStartPage(character)
		endmethod

		// Was ist passiert?
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was ist passiert?", "What happened?"), null)
			call speech(info, character, true, tre("Mein werter Freund Tellborn hat mich geheilt! Zumindest wollte er mich heilen, aber das hat wohl nicht so ganz geklappt.", "My dear friend Tellborn healed me! At least he wanted to heal me, but probably it did not quite work out."), gg_snd_Fulco2)
			call speech(info, character, true, tre("Kann ja mal passieren, dass man den falschen Zauber anwendet, aber wieso zum Teufel gerade ein Zauber, der mich in einen Bären verwandelt?", "It can happen even once that one applies the wrong spell, but why the hell just a spell that turned me into a bear?"), gg_snd_Fulco3)
			call speech(info, character, true, tre("So kann man sich doch nirgendwo mehr blicken lassen ohne gleich gejagt und erschlagen zu werden!", "So you cannot show yourself anywhere without being hunted and killed immediately."), gg_snd_Fulco4)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n012_0115, thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo Bär.", "Hello bear.")) // 0
			call this.addInfo(false, true, thistype.infoCondition1, thistype.infoAction1, null) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tre("Du siehst aus wie ein Magier.", "You look like a magician.")) // 2
			call this.addInfo(true, false, thistype.infoCondition3, thistype.infoAction3, tre("￼Meine Zauberkraft ist fast erloschen!", "My magic power is almost out!")) // 3
			call this.addExitButton() // 4

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Was ist passiert?", "What happened?")) // 5
			call this.addBackToStartPageButton() // 6

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
library StructMapTalksTalkRalph requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother, StructMapQuestsQuestRalphsGarden, StructMapQuestsQuestShitOnTheThrone

	struct TalkRalph extends Talk

		implement Talk

		private AInfo m_hi
		private AInfo m_howAreYou
		private AInfo m_help
		private AInfo m_ruke
		private AInfo m_garden
		private AInfo m_exit

		private AInfo m_hi_yes
		private AInfo m_hi_no

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo Ralph!", "Hello Ralph!"), null)
			call speech(info, character, true, tre("Hallo, alles klar?", "Hello, is everything fine?"), null)

			call this.showRange(this.m_hi_yes.index(), this.m_hi_no.index(), character)
		endmethod

		private static method infoConditionHowAreYou takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		private static method infoActionHowAreYou takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tr("Und wie gehts dir so?"), null)
			call speech(info, character, true, tr("Ach ich weiß nicht. Die Feldarbeit macht mir zu schaffen und wir müssen ernten bevor es zu spät ist. Einen guten Pflug bräuchten wir, aber der Bauer hat natürlich kein Geld, du kennst ihn ja."), null)
			call speech(info, character, true, tr("Ich beneide dich darum, dass du hier bald weggehst. Den ganzen Tag arbeiten arbeiten arbeiten, da wird man doch verrückt. Jetzt stell dir mal vor, dass Orks und Dunkelelfen dieses Dorf niederbrennen. Dann war alles umsonst."), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionHelp takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_howAreYou.index(), character)
		endmethod

		private static method infoActionHelp takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tr("Kann ich dir noch irgendwie helfen?"), null)
			call speech(info, character, true, tr("Willst du dir das wirklich antun? Wenn du mir noch helfen willst, besorg dir eine Harke und grab den Garten hier um. Das würde mir schon sehr viel Arbeit abnehmen."), null)

			call QuestRalphsGarden.characterQuest(character).enable()

			call this.showStartPage(character)
		endmethod

		private static method infoConditionRuke takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return QuestRalphsGarden.characterQuest(character).questItem(QuestRalphsGarden.questItemGarden).isNew() and character.inventory().totalItemTypeCharges('I02F') >= 1
		endmethod

		private static method infoActionRuke takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tr("Ich habe die Harke."), null)
			call speech(info, character, true, tr("Sehr gut. Geh damit einfach in den Garten hier und grabe ihn um."), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionGarden takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return QuestRalphsGarden.characterQuest(character).questItem(QuestRalphsGarden.questItemGarden).isCompleted() and QuestRalphsGarden.characterQuest(character).questItem(QuestRalphsGarden.questItemReport).isNew()
		endmethod

		private static method infoActionGarden takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tr("Der Garten ist umgegraben."), null)
			call speech(info, character, true, tr("Du bist echt der Beste! Hier hast du ein paar Sachen für deine Reise. Also da wäre noch ..."), null)

			call QuestRalphsGarden.characterQuest(character).complete()

			call speech(info, character, false, tr("Was?"), null)
			call speech(info, character, true, tr("Na du kennst doch Wotan, unseren irren Dorfältesten?"), null)
			call speech(info, character, false, tr("Was ist mit ihm?"), null)
			call speech(info, character, true, tr("Jetzt da du ja sowieso weggehst, könntest du ihm doch noch einen ordentlichen Denkzettel verpassen oder? Ach, war doch eine dumme Idee."), null)
			call speech(info, character, false, tr("Sag doch einfach, was du vor hast."), null)
			call speech(info, character, true, tr("Du weißt doch wie sehr er seinen Thron auf der Insel liebt. Na, ich würde einfach auf seinen Thron scheißen."), null)
			call speech(info, character, false, tr("Was?!"), null)
			call speech(info, character, true, tr("Ja! Damit ihm ein für alle mal klar ist, wer hier das sagen hat. Ich habe auch schon einen Lederbeutel mit Scheiße gefüllt. Das Problem ist nur, dass ich mich das nicht traue. Immerhin arbeite ich ja noch mein halbes Leben für ihn, bis er endlich abgkratzt."), null)
			call speech(info, character, false, tr("Gib mir den Beutel."), null)
			call speech(info, character, true, tr("Bist du sicher?"), null)
			call speech(info, character, false, tr("Ja, aber wie komme ich auf die Insel?"), null)
			call speech(info, character, true, tr("Tja, da musst selbst schauen wie Wotan dort hin kommt. Er steht immer recht früh auf. Aber wenn du das durchziehst, dann hast du meinen größten Respekt. Ich wäre gerne dabei, wenn er sich auf seinen Thron setzt und in Scheiße landet."), null)

			call QuestShitOnTheThrone.characterQuest(character).enable()

			call this.showStartPage(character)
		endmethod

		private static method giveQuest takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tre("Ich glaube deine Mutter wollte noch mit dir sprechen, bevor du aufbrichst.", "I believe your mother wanted to talk to you before you start off."), null)
			call QuestMother.characterQuest(character).enable()
			call this.showStartPage(character)
		endmethod

		private static method infoActionHi_Yes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Schön, das freut mich.", "Great, I am glad for you."), null)
			call thistype.giveQuest(info, character)
		endmethod

		private static method infoActionHi_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Ach das wird schon.", "Oh, it's gonna be alright."), null)
			call thistype.giveQuest(info, character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.ralph(), thistype.startPageAction)
			call this.setName(tre("Ralph", "Ralph"))

			// start page
			set this.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tre("Hallo Ralph!", "Hello Ralph!"))
			set this.m_howAreYou = this.addInfo(false, false, thistype.infoConditionHowAreYou, thistype.infoActionHowAreYou, tr("Und wie gehts dir so?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tr("Kann ich dir noch irgendwie helfen?"))
			set this.m_ruke = this.addInfo(false, false, thistype.infoConditionRuke, thistype.infoActionRuke, tr("Ich habe die Harke."))
			set this.m_garden = this.addInfo(false, false, thistype.infoConditionGarden, thistype.infoActionGarden, tr("Der Garten ist umgegraben."))
			set this.m_exit = this.addExitButton()

			set this.m_hi_yes =  this.addInfo(true, false, 0, thistype.infoActionHi_Yes, tre("Ja.", "Yes."))
			set this.m_hi_no =  this.addInfo(true, false, 0, thistype.infoActionHi_No, tre("Nein.", "No."))

			return this
		endmethod
	endstruct

endlibrary
library StructMapTalksTalkRalph requires Asl, StructMapMapNpcs, StructMapQuestsQuestMother, StructMapQuestsQuestRalphsGarden, StructMapQuestsQuestShitOnTheThrone

	struct TalkRalph extends Talk
		private AInfo m_hi
		private AInfo m_howAreYou
		private AInfo m_help
		private AInfo m_ruke
		private AInfo m_garden
		private AInfo m_shit
		private AInfo m_exit

		private AInfo m_hi_yes
		private AInfo m_hi_no

		private method startPageAction takes ACharacter character returns nothing
			if (not this.m_hi.show(character)) then
				call this.showRange(this.m_howAreYou.index(), this.m_exit.index(), character)
			endif
		endmethod

		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, false, tre("Hallo Ralph!", "Hello Ralph!"), gg_snd_RalphCharacter1)
			call speech(info, character, true, tre("Hallo, alles klar?", "Hello, is everything fine?"), null)

			call this.showRange(this.m_hi_yes.index(), this.m_hi_no.index(), character)
		endmethod

		private static method infoConditionHowAreYou takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_hi.index(), character)
		endmethod

		private static method infoActionHowAreYou takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tre("Und wie gehts dir so?", "So, how are you?"), gg_snd_RalphCharacter2)
			call speech(info, character, true, tre("Ach ich weiß nicht. Die Feldarbeit macht mir zu schaffen und wir müssen ernten bevor es zu spät ist. Einen guten Pflug bräuchten wir, aber der Bauer hat natürlich kein Geld, du kennst ihn ja.", "Oh, I do not know. The field work is very hard and  we have to harvest before it's too late. We need a good plow, but the farmer of course has no money, you know him."), null)
			call speech(info, character, true, tre("Ich beneide dich darum, dass du hier bald weggehst. Den ganzen Tag arbeiten, arbeiten, arbeiten, da wird man doch verrückt. Jetzt stell dir mal vor, dass Orks und Dunkelelfen dieses Dorf niederbrennen. Dann war alles umsonst.", "I envy you that you will leave here soon. All day working, working, working, you get crazy. Now imagine that Orcs and Dark Elves burn down this village. Then everything was in vain."), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionHelp takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return this.infoHasBeenShownToCharacter(this.m_howAreYou.index(), character)
		endmethod

		private static method infoActionHelp takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tre("Kann ich dir noch irgendwie helfen?", "Can I help you?"), gg_snd_RalphCharacter3)
			call speech(info, character, true, tre("Willst du dir das wirklich antun? Wenn du mir noch helfen willst, besorg dir eine Harke und grab den Garten hier um. Das würde mir schon sehr viel Arbeit abnehmen.", "Do you really want to do this? If you want to help me, get a rake and dig the garden here. That would take a lot of work from me."), null)
			call speech(info, character, true, tre("Natürlich gebe ich dir auch die Goldmünzen dafür, aber verschwende sie nicht für irgendetwas anderes!", "Of course, I give you gold coins for it, but do not waste it for anything else!"), null)
			call character.addGold(10)

			call QuestRalphsGarden.characterQuest(character).enable()

			call this.showStartPage(character)
		endmethod

		private static method infoConditionRuke takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return QuestRalphsGarden.characterQuest(character).questItem(QuestRalphsGarden.questItemGarden).isNew() and character.inventory().totalItemTypeCharges('I02F') >= 1
		endmethod

		private static method infoActionRuke takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tre("Ich habe die Harke.", "I have the rake."), gg_snd_RalphCharacter4)
			call speech(info, character, true, tre("Sehr gut. Geh damit einfach in den Garten hier und grabe ihn um.", "Very good. Just go into the garden here and dig it."), null)

			call this.showStartPage(character)
		endmethod

		private static method infoConditionGarden takes AInfo info, Character character returns boolean
			local thistype this = thistype(info.talk())
			return QuestRalphsGarden.characterQuest(character).questItem(QuestRalphsGarden.questItemGarden).isCompleted() and QuestRalphsGarden.characterQuest(character).questItem(QuestRalphsGarden.questItemReport).isNew()
		endmethod

		private static method infoActionGarden takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())

			call speech(info, character, false, tre("Der Garten ist umgegraben.", "The garden is dug."), gg_snd_RalphCharacter5)
			call speech(info, character, true, tre("Du bist echt der Beste! Hier hast du ein paar Sachen für deine Reise. Also da wäre noch ...", "You're the best! Here are some things for your trip. So there would still be ..."), null)

			call QuestRalphsGarden.characterQuest(character).complete()

			call speech(info, character, false, tre("Was?", "What?"), gg_snd_RalphCharacter6)
			call speech(info, character, true, tre("Na du kennst doch Wotan, unseren irren Dorfältesten?", "Well, you know Wotan, our crazy village elders?"), null)
			call speech(info, character, false, tre("Was ist mit ihm?", "What about him?"), gg_snd_RalphCharacter7)
			call speech(info, character, true, tre("Jetzt da du ja sowieso weggehst, könntest du ihm doch noch einen ordentlichen Denkzettel verpassen oder? Ach, war doch eine dumme Idee.", "Now that you leave anyway, can you still give him a proper memorandum? Oh, it was a stupid idea."), null)
			call speech(info, character, false, tre("Sag doch einfach, was du vor hast.", "Just tell me what you're up to."), gg_snd_RalphCharacter8)
			call speech(info, character, true, tre("Du weißt doch wie sehr er seinen Thron auf der Insel liebt. Na, ich würde einfach auf seinen Thron scheißen.", "You know how much he loves this throne on the islandd. Well, I would just shit on this throne."), null)
			call speech(info, character, false, tre("Was?!", "What?!"), gg_snd_RalphCharacter9)
			call speech(info, character, true, tre("Ja! Damit ihm ein für alle mal klar ist, wer hier das sagen hat. Ich habe auch schon einen Lederbeutel mit Scheiße gefüllt. Das Problem ist nur, dass ich mich das nicht traue. Immerhin arbeite ich ja noch mein halbes Leben für ihn, bis er endlich abgkratzt.", "Yes! So that it is clear to him once and for all who has the power here. I have already filled a leather bag with shit. The problem is that I do not dare. After all, I still work my half life for him until he finally dies."), null)
			call speech(info, character, false, tre("Gib mir den Beutel.", "Give me the bag."), gg_snd_RalphCharacter10)
			call speech(info, character, true, tre("Bist du sicher?", "Are you sure?"), null)
			call speech(info, character, false, tre("Ja, aber wie komme ich auf die Insel?", "Yes, but how do I get to the island?"), gg_snd_RalphCharacter11)
			call speech(info, character, true, tre("Tja, da musst selbst schauen wie Wotan dort hin kommt. Er steht immer recht früh auf. Aber wenn du das durchziehst, dann hast du meinen größten Respekt. Ich wäre gerne dabei, wenn er sich auf seinen Thron setzt und in Scheiße landet.", "Well, you have to look yourself how Wotan gets there. He always gets up early. But if you go through it, you have my greatest respect. I'd like to be there when he sits down on his throne and lands in shit."), null)

			call QuestShitOnTheThrone.characterQuest(character).enable()

			call this.showStartPage(character)
		endmethod

		private static method infoConditionShit takes AInfo info, ACharacter character returns boolean
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)
			return characterQuest.questItem(QuestShitOnTheThrone.questItemTalkToWotan).isCompleted() and characterQuest.questItem(QuestShitOnTheThrone.questItemReport).isNew()
		endmethod

		private static method infoActionShit takes AInfo info, ACharacter character returns nothing
			local thistype this = thistype(info.talk())
			local QuestShitOnTheThrone characterQuest = QuestShitOnTheThrone.characterQuest(character)

			call speech(info, character, false, tre("Wotan hat sich auf den Beutel gesetzt.", "Wotan has put himself on the bag."), gg_snd_RalphCharacter12)
			call speech(info, character, true, tre("Hervorragend. Du hast es wirklich drauf! Mann, ich hätte gerne sein Gesicht gesehen. Dieses arrogante Arschloch. Kumpel, ich werde dich echt vermissen!", "Outstanding. You really got it! Man, I would have liked to see his face. This arrogant asshole. Buddy, I'll really miss you!"), null)
			call speech(info, character, true, tre("Hier hast du noch was zum Abschied. Mach's gut und pass auf dich auf!", "Here you have something to say goodbye. Goodbye and take care of yourself!"), null)

			call characterQuest.complete()

			call this.showStartPage(character)
		endmethod

		private static method giveQuest takes AInfo info, Character character returns nothing
			local thistype this = thistype(info.talk())
			call speech(info, character, true, tre("Ich glaube deine Mutter wollte noch mit dir sprechen, bevor du aufbrichst.", "I believe your mother wanted to talk to you before you start off."), null)
			call QuestMother.characterQuest(character).enable()

			call speech(info, character, true, tre("Ich habe hier noch einen sehr nützlichen Gegenstand für dich. Ich habe ihn vom Dorfältesten gestohlen, aber erzähle es ihm bloß nicht. Du kannst dich mit dieser Rune zu einem magischen Schrein teleportieren. Ich hoffe er wird dir auf deiner Reise von Nutzen sein.", "I have a very useful item for you. I stole it from the village elders, but do not tell him. You can use this rune to teleport to a magical shrine. I hope it will be of service to you on your journey."), null)
			call character.giveItem('I01N')

			call this.showStartPage(character)
		endmethod

		private static method infoActionHi_Yes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ja.", "Yes."), gg_snd_RalphCharacter13)
			call speech(info, character, true, tre("Schön, das freut mich.", "Great, I am glad for you."), null)
			call thistype.giveQuest(info, character)
		endmethod

		private static method infoActionHi_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), gg_snd_RalphCharacter14)
			call speech(info, character, true, tre("Ach das wird schon.", "Oh, it's gonna be alright."), null)
			call thistype.giveQuest(info, character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.ralph(), thistype.startPageAction)
			call this.setName(tre("Ralph", "Ralph"))

			// start page
			set this.m_hi = this.addInfo(false, true, 0, thistype.infoActionHi, null)
			set this.m_howAreYou = this.addInfo(false, false, thistype.infoConditionHowAreYou, thistype.infoActionHowAreYou, tre("Und wie gehts dir so?", "So, how are you?"))
			set this.m_help = this.addInfo(false, false, thistype.infoConditionHelp, thistype.infoActionHelp, tre("Kann ich dir noch irgendwie helfen?", "Can I help you?"))
			set this.m_ruke = this.addInfo(false, false, thistype.infoConditionRuke, thistype.infoActionRuke, tre("Ich habe die Harke.", "I have the rake."))
			set this.m_garden = this.addInfo(false, false, thistype.infoConditionGarden, thistype.infoActionGarden, tre("Der Garten ist umgegraben.", "The garden is dug."))
			set this.m_shit = this.addInfo(false, false, thistype.infoConditionShit, thistype.infoActionShit, tre("Wotan hat sich auf den Beutel gesetzt.", "Wotan has put himself on the bag."))
			set this.m_exit = this.addExitButton()

			set this.m_hi_yes =  this.addInfo(true, false, 0, thistype.infoActionHi_Yes, tre("Ja.", "Yes."))
			set this.m_hi_no =  this.addInfo(true, false, 0, thistype.infoActionHi_No, tre("Nein.", "No."))

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
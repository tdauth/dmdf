library StructMapTalksTalkAgihard requires Asl, StructGameClasses, StructMapMapArena, StructMapMapNpcs

	struct TalkAgihard extends Talk
		public static constant integer xpBonus = 25
		private AInfo m_hello
		private AInfo m_whichArena
		private AInfo m_anyRules
		private AInfo m_whatToWin
		private AInfo m_letMeIn
		private AInfo m_iCompleted
		private AInfo m_servantOfDuke
		private AInfo m_aboutWeapons
		private AInfo m_whatDoYouKnow
		private AInfo m_irminaLikesYou
		private AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Hallo.
		private static method infoActionHello takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Ich grüße dich. Du bist nicht zufällig im Umgang mit Waffen geübt?", "I greet you. Are you proficient weapons?"), gg_snd_Agihard1)
			call speech(info, character, false, tre("Warum?", "Why?"), null)
			call speech(info, character, true, tre("Ich suche noch Leute, für meine Arena.", "I'm still looking for people for my arena."), gg_snd_Agihard2)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoConditionAfterHello takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).m_hello.hasBeenShownToCharacter(character)
		endmethod

		// (Nach Begrüßung, bevor „Lass mich in die Arena!“)
		private static method infoConditionBeforeArena takes AInfo info, ACharacter character returns boolean
			return thistype.infoConditionAfterHello(info, character) and not thistype(info.talk()).m_letMeIn.hasBeenShownToCharacter(character)
		endmethod

		// Welche Arena?
		private static method infoActionWhichArena takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Welche Arena?", "Which arena?"), null)
			call speech(info, character, true, tre("Eben eine ganz normale Arena. Man kämpft und wer gewinnt, bekommt Goldmünzen.", "Just a normal arena. You fight and whoever wins gets gold coins."), gg_snd_Agihard3)
			call speech(info, character, true, tre("Die Kämpfe finden immer zwischen genau zwei Leuten statt.", "The fights always take place between just two people."), gg_snd_Agihard3)
			call info.talk().showStartPage(character)
		endmethod

		// Gibt es bestimmte Regeln in der Arena?
		private static method infoActionAnyRules takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Gibt es bestimmte Regeln in der Arena?", "Are there certain rules in the arena?"), null)
			call speech(info, character, true, tre("Ja, allerdings. Ich will nicht, dass das am Ende in einem Massaker endet. Wir wollen ja fair bleiben. Also ...", "Yes, indeed. I do no want it to end in a massacre finally. We want to be fair. So ..."), gg_snd_Agihard4)
			call speech(info, character, true, tre("1. Es ist nur ein Wettkampf, daher werden keine Gegner getötet oder sonst aufs Brutalste verstümmelt. Liegt ein Gegner am Boden, so ist der Kampf zu Ende.", "1. It is only a competition, so no opponents are killed or otherwise mutilated on brutally. If an opponent lies on the ground, so the fight is over."), gg_snd_Agihard5)
			call speech(info, character, true, tre("2. Es kämpfen immer genau zwei Leute gegeneinander. Niemand hat sich da einzumischen!", "2. It will always fight exactly two people against each other. Nobody has to intervene here!"), gg_snd_Agihard6)
			call speech(info, character, true, tre("3. Wer die Arena verlässt, hat verloren.", "3. Who leaves the arena, has lost."), gg_snd_Agihard7)
			call speech(info, character, false, tre("Was passiert wenn ich gegen eine dieser Regeln verstoße?", "What happens if I violate one of these rules?"), null)
			call speech(info, character, true, tre("Probiere es erst gar nicht! Wenn du gegen die zweite Regel verstößt, wird wohl kaum noch jemand in die Arena kommen, verstößt du gegen die erste, hast du ein ernsthaftes Problem!", "Do not even try it! If you violate the second rule, hardly anyone will come to the arena, if you violate the first, you have a serious problem!"), gg_snd_Agihard8)
			call info.talk().showStartPage(character)
		endmethod

		// Was gibt es zu gewinnen?
		private static method infoActionWhatToWin takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was gibt es zu gewinnen?", "What is there to win?"), null)
			call speech(info, character, true, tre("War ja wieder klar, dass du das wissen willst. Ein wahrer Krieger kämpft ohne Aussicht auf Belohnung!", "Sure you want to know that. A true warrior fights with no prospect of a reward!"), gg_snd_Agihard10)
			call speech(info, character, false, tre("Interessant.", "Interesting."), null)
			call speech(info, character, true, tre("Ja, ja, schon gut. Also, du kriegst deine Belohnung sobald der Kampf vorbei ist und du deinen Gegner besiegt hast.", "Yes, yes all right. So, you get your reward when the fight is over and you have beaten your opponent."), gg_snd_Agihard11)
			call speech(info, character, true, tre("Für jeden Sieg bekommst du ein paar Goldmünzen. Wenn du jedoch öfter als fünfmal gewinnst, erhältst du einen besonderen Preis.", "For every win you get a few gold coins. However, if you win more than five times, you get a special reward."), gg_snd_Agihard12) // gg_snd_Agihard17
			call speech(info, character, true, tre("Allerdings will ich noch nicht verraten, um was genau es sich dabei handelt. Mitmachen lohnt sich aber auf jeden Fall!", "However, I don't want to tell you yet what exactly the reward is. Taking part is worth in any case!"), gg_snd_Agihard13) // gg_snd_Agihard18
			call speech(info, character, true, tre("Ach ja, den Preis gibt es natürlich nur einmal für jeden, der das schafft. Sonst werde ich ja noch arm (Lacht).", "Oh, of course there is only one award for anyone who gets it. Otherwise I will become poor (Laughs)."), gg_snd_Agihard14) // gg_snd_Agihard19
			if (QuestArenaChampion.characterQuest(character).isNotUsed()) then
				call QuestArenaChampion.characterQuest(character).enable()
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung, Agihard befindet sich in der Nähe der Arena)
		private static method infoConditionAfterHelloNearArena takes AInfo info, ACharacter character returns boolean
			return thistype.infoConditionAfterHello(info, character) and GetDistanceBetweenPointsWithoutZ(GetUnitX(Npcs.agihard()), GetUnitY(Npcs.agihard()), GetRectCenterX(gg_rct_arena), GetRectCenterY(gg_rct_arena)) < 1200.0
		endmethod

		// Lass mich in die Arena!
		private static method infoActionLetMeIn takes AInfo info, ACharacter character returns nothing
			local unit arenaEnemy
			call speech(info, character, false, tre("Lass mich in die Arena!", "Let me in the arena!"), null)
			if (not Arena.isFree()) then
				call speech(info, character, true, tre("Tut mir leid, aber die Arena ist gerade belegt.", "Sorry, but the arena is currently occupied."), gg_snd_Agihard15)
				call info.talk().showStartPage(character)
			else
				call speech(info, character, true, tre("Gut, und halte dich an die Regeln!", "Good, and stick to the rules!"), gg_snd_Agihard16)
				call info.talk().close(character)
				set arenaEnemy = Arena.getRandomEnemy(character)
				call Arena.addUnit(arenaEnemy)
				set arenaEnemy = null
				call Arena.addCharacter(character)
			endif
		endmethod

		// (Falls das erste Auftragsziel des Auftrags "Arenameister" abgeschlossen und das zweite noch aktiv ist)
		private static method infoConditionICompleted takes AInfo info, ACharacter character returns boolean
			return QuestArenaChampion.characterQuest(character).questItem(0).isCompleted() and QuestArenaChampion.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich habe fünfmal gewonnen!
		private static method infoActionICompleted takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Ich habe fünfmal gewonnen!", "I won five times!"), null)
			call speech(info, character, true, tre("Tatsächlich! Du scheinst mir ein sehr starker Kämpfer zu sein. Nun gut, du hast dir deine Belohnung ehrenhaft verdient. Hier hast du sie.", "Really! You seem to be a very strong fighter. Well, you've earned your reward honorably. Here you have it."), gg_snd_Agihard21)
			call QuestArenaChampion.characterQuest(character).questItem(1).complete()
			call character.giveItem('I06K') // amulet of power which increases the attack speed
			call character.displayItemAcquired(GetObjectName('I06K'), tre("Erhöhen das Angriffstempo.", "Increases the attack speed."))
			call info.talk().showStartPage(character)
		endmethod

		// Dienst du dem Herzog?
		private static method infoActionServantOfDuke takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Dienst du dem Herzog?", "Do you serve the duke?"), null)
			call speech(info, character, true, tre("Wegen meiner Rüstung oder was? Ja, ich bin der Waffenmeister der Burg. Schon mein Vater diente Heimrichs Vater und ich bin stolz, sein Erbe weiterzutragen.", "Because of my armour or what? Yes, I am the weapons master of the castle. My father served Heimrich's father and I am proud to carry on his legacy."), gg_snd_Agihard22)
			call speech(info, character, false, tre("Dein Vater?", "Your father?"), null)
			call speech(info, character, true, tre("Ja, er war ein großer Mann. Er war der beste Waffenmeister weit und breit und lehrte viele große Krieger das Kämpfen.", "Yes, he was a great man. He was the best weapons master far and wide, and taught many greate warriors fighting."), gg_snd_Agihard23)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Dienst du dem Herzog?“)
		private static method infoConditionAboutWeapons takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).m_servantOfDuke.hasBeenShownToCharacter(character)
		endmethod

		// Kennst du dich mit Waffen aus?
		private static method infoActionAboutWeapons takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kennst du dich mit Waffen aus?", "Are you familiar with weapons?"), null)
			call speech(info, character, true, tre("Natürlich, worum geht's denn?", "Of course, what's it about?"), gg_snd_Agihard24)
			call speech(info, character, false, tre("Wo finde ich gute Waffen?", "Where can I find good weapons?"), null)
			call speech(info, character, true, tre("(Lachend) Bei mir natürlich. Nein, im Ernst. Einar verkauft auch ganz gute Waffen und Wieland, der Burgschmied, verkauft sehr gute Rüstungen und Helme.", "(Laughing) Of course with me. No, seriously. Einar also sells very good weapons and Wieland, the castle's blacksmith, sells very good armours and helmets."), gg_snd_Agihard25)
			call speech(info, character, true, tre("Ich selbst verkaufe ganz gute Schilde.", "I myself sell very good bucklers."), gg_snd_Agihard26)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Dienst du dem Herzog?“)
		private static method infoConditionWhatDoYouKnow takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).m_servantOfDuke.hasBeenShownToCharacter(character)
		endmethod

		// Was weißt du über die Lage?
		private static method infoActionWhatDoYouKnow takes AInfo info, ACharacter character returns nothing
			local boolean sayIt = false
			call speech(info, character, false, tre("Was weißt du über die Lage?", "What do you know about the situation?"), null)
			call speech(info, character, true, tre("Über welche Lage? Meinst du die bevorstehenden Kämpfe?", "About which situation? Are you talking about the upcoming fights?"), gg_snd_Agihard27)
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Tut mir leid, aber darüber darf ich nicht sprechen.", "I am sory, but I'm not allowed to speak about that."), gg_snd_Agihard28)
			call speech(info, character, true, tre("Uns wurde das Reden über solche Angelegenheiten strengstens untersagt. Dadurch bekommen die Leute nur noch mehr Angst.", "It was strictly prohibited that we talk about such matters. This gives people even more fear."), gg_snd_Agihard29)
			if (Classes.isChaplain(character.class())) then
				call speech(info, character, false, tre("Ich bin ein Geistlicher. Nicht einmal mir willst du etwas erzählen?!", "I am aclergyman. You don't even want to tell me anything?"), null)
				call speech(info, character, true, tre("Na ja ...", "Well ..."), gg_snd_Agihard30)
				call speech(info, character, false, tre("Mein Glaube verbietet mir, Unfrieden unter den Leuten zu stiften.", "My faith forbids me to cause mischief among the people."), null)
				set sayIt = true
			elseif (character.class() == Classes.knight()) then
				call speech(info, character, false, tre("Ich bin ein Ritter, ein treuer Diener des Königs, genau wie du. Mir kannst du es ruhig erzählen.", "I am a knight, a faithful servant of the king, just like you. You can tell it calmly to me."), null)
				set sayIt = true
			elseif (character.class() == Classes.dragonSlayer()) then
				call speech(info, character, false, tre("Kannst du nicht mal eine Ausnahme machen?", "Can't you even make an exception?"), null)
				call speech(info, character, true, tre("Nein, ich würde damit gegen meinen Eid verstoßen!", "No, I would violate my oath by that!"), gg_snd_Agihard31)
				call speech(info, character, false, tre("Ach was ist schon so ein Eid, ich erzähls auch bestimmt keinem.", "Oh who cares about such an oath, I certainly won't tell it to anybody."), null)
				call speech(info, character, true, tre("Schluss jetzt! Entweder du bist hier, um zu kämpfen oder du verschwindest besser!", "Stop it now! Either you're here to fight or you better leave!"), gg_snd_Agihard32)
			endif
			if (sayIt) then
				call speech(info, character, true, tre("Also gut ... aber du darfst es niemandem erzählen!", "All right ... but you must not tell anyone!"), gg_snd_Agihard33)
				call speech(info, character, false, tre("Keine Sorge!", "Don't worry!"), null)
				call speech(info, character, true, tre("Ich glaube Markward, der treue Ritter unseres Herzogs Heimrich, würde dem Feind lieber mutig entgegenziehen, als hier in der Burg zu verrotten.", "I think Markward, the faithful knight of our duke Heimrich, would prefer to bravely move against the enemy than rotting here in the castle."), gg_snd_Agihard34)
				call speech(info, character, true, tre("Doch Heimrich ist anderer Meinung. Loyal wie er nun mal ist, unterwirft sich Markward natürlich dem Willen des Herzogs.", "But Heimrich disagrees. Loyal as he happens to be, Markward of course submits to the will of the duke."), gg_snd_Agihard35)
				call speech(info, character, true, tre("Manche glauben, dass Heimrich auf irgendetwas Bestimmtes wartet. Das ist allerdings nur ein Gerücht und erzähl niemandem, dass du das von mir hast!", "Some believe that Heimrich is waiting for anything in particular. Howerver, this is only a rumor and don't tell anyone that you have this information from me."), gg_snd_Agihard36)
				// Erfahrungsbonus
				call Character(character).xpBonus(thistype.xpBonus, tre("Informationen erhalten.", "Received Information"))
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung, Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ ist aktiv)
		private static method infoConditionIrminaLikesYou takes AInfo info, ACharacter character returns boolean
			return thistype.infoConditionAfterHello(info, character) and QuestTheBraveArmourerOfTalras.characterQuest(character).questItem(0).isNew()
		endmethod

		// Irmina mag dich.
		private static method infoActionIrminaLikesYou takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Irmina mag dich.", "Irmina likes you."), null)
			call speech(info, character, true, tre("Was?", "What?"), gg_snd_Agihard37)
			call speech(info, character, false, tre("…", "..."), null)
			call speech(info, character, true, tre("Irmina, die Händlerin? Wieso das denn?", "Irmina, the merchant? Why is that?"), gg_snd_Agihard38)
			call speech(info, character, false, tre("Ich wette, du wusstest es.", "I bet you knew."), null)
			call speech(info, character, true, tre("Na ja, ich dachte … vielleicht, aber ich war mir nicht sicher. Vielleicht sollte ich mal bei ihr vorbeischauen.", "Well, I thought ... maybe, but I was not sure. Maybe I should look in on her."), gg_snd_Agihard39)
			call speech(info, character, true, tre("Mal unter uns, ich mag sie auch sehr. Erzähl das aber keinem, sonst schlage ich dir den Kopf ab!", "Among us, I like her much, too. Don't tell this anyone or I cut off your head!"), gg_snd_Agihard40)
			// Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ abgeschlossen
			call QuestTheBraveArmourerOfTalras.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.agihard(), thistype.startPageAction)
			// start page
			set this.m_hello = this.addInfo(false, false, 0, thistype.infoActionHello, tre("Hallo.", "Hello."))
			set this.m_whichArena = this.addInfo(false, false, thistype.infoConditionBeforeArena, thistype.infoActionWhichArena, tre("Welche Arena?", "Which arena?"))
			set this.m_anyRules = this.addInfo(true, false, thistype.infoConditionAfterHello, thistype.infoActionAnyRules, tre("Gibt es bestimmte Regeln in der Arena?", "Are there certain rules in the arena?"))
			set this.m_whatToWin = this.addInfo(true, false, thistype.infoConditionAfterHello, thistype.infoActionWhatToWin, tre("Was gibt es zu gewinnen?", "What is there to win?"))
			set this.m_letMeIn = this.addInfo(true, false, thistype.infoConditionAfterHelloNearArena, thistype.infoActionLetMeIn, tre("Lass mich in die Arena!", "Let me in the arena!"))
			set this.m_iCompleted = this.addInfo(true, false, thistype.infoConditionICompleted, thistype.infoActionICompleted, tre("Ich habe fünfmal gewonnen!", "I won five times!"))
			set this.m_servantOfDuke = this.addInfo(false, false, thistype.infoConditionAfterHello, thistype.infoActionServantOfDuke, tre("Dienst du dem Herzog?", "Do you serve the duke?"))
			set this.m_aboutWeapons = this.addInfo(true, false, thistype.infoConditionAboutWeapons, thistype.infoActionAboutWeapons, tre("Kennst du dich mit Waffen aus?", "Are you familiar with weapons?"))
			set this.m_whatDoYouKnow = this.addInfo(false, false, thistype.infoConditionWhatDoYouKnow, thistype.infoActionWhatDoYouKnow, tre("Was weißt du über die Lage?", "What do you know about the situation?"))
			set this.m_irminaLikesYou = this.addInfo(false, false, thistype.infoConditionIrminaLikesYou, thistype.infoActionIrminaLikesYou, tre("Irmina mag dich.", "Irmina likes you."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary

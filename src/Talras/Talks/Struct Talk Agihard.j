library StructMapTalksTalkAgihard requires Asl, StructGameClasses, StructMapMapArena, StructMapMapNpcs

	struct TalkAgihard extends Talk
		public static constant integer xpBonus = 100
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

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(this.m_exit.index(), character)
		endmethod

		// Hallo.
		private static method infoActionHello takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Ich grüße dich. Du bist nicht zufällig im Umgang mit Waffen geübt?", "I greet you. Are you proficient weapons?"), null)
			call speech(info, character, false, tre("Warum?", "Why?"), null)
			call speech(info, character, true, tre("Ich suche noch Leute, für meine Arena.", "I'm still looking for people for my arena."), null)
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
			call speech(info, character, true, tre("Eben eine ganz normale Arena. Man kämpft und wer gewinnt, bekommt Goldmünzen.", "Just a normal arena. You fight and whoever wins gets gold coins."), null)
			call speech(info, character, true, tre("Die Kämpfe finden immer zwischen genau zwei Leuten statt.", "The fights always take place between just two people."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Gibt es bestimmte Regeln in der Arena?
		private static method infoActionAnyRules takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Gibt es bestimmte Regeln in der Arena?", "Are there certain rules in the arena?"), null)
			call speech(info, character, true, tre("Ja, allerdings. Ich will nicht, dass das am Ende in einem Massaker endet. Wir wollen ja fair bleiben. Also ...", "Yes, indeed. I do no want it to end in a massacre finally. We want to be fair. So ..."), null)
			call speech(info, character, true, tre("1. Es ist nur ein Wettkampf, daher werden keine Gegner getötet oder sonst aufs Brutalste verstümmelt. Liegt ein Gegner am Boden, so ist der Kampf zu Ende.", "1. It is only a competition, so no opponents are killed or otherwise mutilated on brutally. If an opponent lies on the ground, so the fight is over."), null)
			call speech(info, character, true, tre("2. Es kämpfen immer genau zwei Leute gegeneinander. Niemand hat sich da einzumischen!", "2. It will always fight exactly two people against each other. Nobody has to intervene here!"), null)
			call speech(info, character, true, tre("3. Wer die Arena verlässt, hat verloren.", "3. Who leaves the arena, has lost."), null)
			call speech(info, character, false, tre("Was passiert wenn ich gegen eine dieser Regeln verstoße?", "What happens if I violate one of these rules?"), null)
			call speech(info, character, true, tre("Probiere es erst gar nicht! Wenn du gegen die zweite Regel verstößt, wird wohl kaum noch jemand in die Arena kommen, verstößt du gegen die erste, hast du ein ernsthaftes Problem!", "Do not even try it! If you violate the second rule, hardly anyone will come to the arena, if you violate the first, you have a serious problem!"), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was gibt es zu gewinnen?
		private static method infoActionWhatToWin takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was gibt es zu gewinnen?", "What is there to win?"), null)
			call speech(info, character, true, tre("War ja wieder klar, dass du das wissen willst. Ein wahrer Krieger kämpft ohne Aussicht auf Belohnung!", "Sure you want to know that. A true warrior fights with no prospect of a reward!"), null)
			call speech(info, character, false, tre("Interessant.", "Interesting."), null)
			call speech(info, character, true, tre("Ja, ja, schon gut. Also, du kriegst deine Belohnung sobald der Kampf vorbei ist und du deinen Gegner besiegt hast.", "Yes, yes all right. So, you get your reward when the fight is over and you have beaten your opponent."), null)
			call speech(info, character, true, tre("Für jeden Sieg bekommst du ein paar Goldmünzen. Wenn du jedoch öfter als fünfmal gewinnst, erhältst du einen besonderen Preis.", "For every win you get a few gold coins. However, if you win more than five times, you get a special reward."), null)
			call speech(info, character, true, tre("Allerdings will ich noch nicht verraten, um was genau es sich dabei handelt. Mitmachen lohnt sich aber auf jeden Fall!", "However, I don't want to tell you yet what exactly the reward is. Taking part is worth in any case!"), null)
			call speech(info, character, true, tre("Ach ja, den Preis gibt es natürlich nur einmal für jeden, der das schafft. Sonst werde ich ja noch arm (Lacht).", "Oh, of course there is only one award for anyone who gets it. Otherwise I will become poor (Laughs)."), null)
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
				call speech(info, character, true, tre("Tut mir leid, aber die Arena ist gerade belegt.", "Sorry, but the arena is currently occupied."), null)
				call info.talk().showStartPage(character)
			else
				call speech(info, character, true, tre("Gut, und halte dich an die Regeln!", "Good, and stick to the rules!"), null)
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
		private static method infoActionICompleted takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich habe fünfmal gewonnen!", "I won five times!"), null)
			call speech(info, character, true, tre("Tatsächlich! Du scheinst mir ein sehr starker Kämpfer zu sein. Nun gut, du hast dir deine Belohnung ehrenhaft verdient. Hier hast du sie.", "Really! You seem to be a very strong fighter. Well, you've earned your reward honorably. Here you have it."), null)
			// TODO besondere Belohnung, Gegenstand
			call QuestArenaChampion.characterQuest(character).questItem(1).complete()
			call info.talk().showStartPage(character)
		endmethod

		// Dienst du dem Herzog?
		private static method infoActionServantOfDuke takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Dienst du dem Herzog?", "Do you serve the duke?"), null)
			call speech(info, character, true, tre("Wegen meiner Rüstung oder was? Ja, ich bin der Waffenmeister der Burg. Schon mein Vater diente Heimrichs Vater und ich bin stolz, sein Erbe weiterzutragen.", "Because of my armour or what? Yes, I am the weapons master of the castle. My father served Heimrich's father and I am proud to carry on his legacy."), null)
			call speech(info, character, false, tre("Dein Vater?", "Your father?"), null)
			call speech(info, character, true, tre("Ja, er war ein großer Mann. Er war der beste Waffenmeister weit und breit und lehrte viele große Krieger das Kämpfen.", "Yes, he was a great man. He was the best weapons master far and wide, and taught many greate warriors fighting."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Dienst du dem Herzog?“)
		private static method infoConditionAboutWeapons takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).m_servantOfDuke.hasBeenShownToCharacter(character)
		endmethod

		// Kennst du dich mit Waffen aus?
		private static method infoActionAboutWeapons takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kennst du dich mit Waffen aus?", "Are you familiar with weapons?"), null)
			call speech(info, character, true, tre("Natürlich, worum geht's denn?", "Of course, what's it about?"), null)
			call speech(info, character, false, tre("Wo finde ich gute Waffen?", "Where can I find good weapons?"), null)
			call speech(info, character, true, tr("(Lachend) Bei mir natürlich. Nein, im Ernst. Einar verkauft auch ganz gute Waffen und Wieland, der Burgschmied, verkauft sehr gute Rüstungen und Helme."), null)
			call speech(info, character, true, tr("Ich selbst verkaufe ganz gute Schilde."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Dienst du dem Herzog?“)
		private static method infoConditionWhatDoYouKnow takes AInfo info, ACharacter character returns boolean
			return thistype(info.talk()).m_servantOfDuke.hasBeenShownToCharacter(character)
		endmethod

		// Was weißt du über die Lage?
		private static method infoActionWhatDoYouKnow takes AInfo info, ACharacter character returns nothing
			local boolean sayIt = false
			call speech(info, character, false, tr("Was weißt du über die Lage?"), null)
			call speech(info, character, true, tr("Über welche Lage? Meinst du die bevorstehenden Kämpfe?"), null)
			call speech(info, character, false, tr("Ja."), null)
			call speech(info, character, true, tr("Tut mir leid, aber darüber darf ich nicht sprechen."), null)
			call speech(info, character, true, tr("Uns wurde das Reden über solche Angelegenheiten strengstens untersagt. Dadurch bekommen die Leute nur noch mehr Angst."), null)
			if (Classes.isChaplain(character.class())) then
				call speech(info, character, false, tr("Ich bin ein Geistlicher. Nicht einmal mir willst du etwas erzählen?!"), null)
				call speech(info, character, true, tr("Na ja ..."), null)
				call speech(info, character, false, tr("Mein Glaube verbietet mir, Unfrieden unter den Leuten zu stiften."), null)
				set sayIt = true
			elseif (character.class() == Classes.knight()) then
				call speech(info, character, false, tr("Ich bin ein Ritter, ein treuer Diener des Königs, genau wie du. Mir kannst du es ruhig erzählen."), null)
				set sayIt = true
			elseif (character.class() == Classes.dragonSlayer()) then
				call speech(info, character, false, tr("Kannst du nicht mal eine Ausnahme machen?"), null)
				call speech(info, character, true, tr("Nein, ich würde damit gegen meinen Eid verstoßen!"), null)
				call speech(info, character, false, tr("Ach was ist schon so ein Eid, ich erzähls auch bestimmt keinem."), null)
				call speech(info, character, true, tr("Schluss jetzt! Entweder du bist hier, um zu kämpfen oder du verschwindest besser!"), null)
			endif
			if (sayIt) then
				call speech(info, character, true, tr("Also gut ... aber du darfst es niemandem erzählen!"), null)
				call speech(info, character, false, tr("Keine Sorge!"), null)
				call speech(info, character, true, tr("Ich glaube Markward, der treue Ritter unseres Herzogs Heimrich, würde dem Feind lieber mutig entgegenziehen, als hier in der Burg zu verrotten."), null)
				call speech(info, character, true, tr("Doch Heimrich ist anderer Meinung. Loyal wie er nun mal ist, unterwirft sich Markward natürlich dem Willen des Herzogs."), null)
				call speech(info, character, true, tr("Manche glauben, dass Heimrich auf irgendetwas Bestimmtes wartet. Das ist allerdings nur ein Gerücht und erzähl niemandem, dass du das von mir hast!"), null)
				// Erfahrungsbonus
				call Character(character).xpBonus(thistype.xpBonus, tr("Informationen erhalten."))
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung, Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ ist aktiv)
		private static method infoConditionIrminaLikesYou takes AInfo info, ACharacter character returns boolean
			return thistype.infoConditionAfterHello(info, character) and QuestTheBraveArmourerOfTalras.characterQuest(character).questItem(0).isNew()
		endmethod

		// Irmina mag dich.
		private static method infoActionIrminaLikesYou takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tr("Irmina mag dich."), null)
			call speech(info, character, true, tr("Was?"), null)
			call speech(info, character, false, tr("…"), null)
			call speech(info, character, true, tr("Irmina, die Händlerin? Wieso das denn?"), null)
			call speech(info, character, false, tr("Ich wette, du wusstest es."), null)
			call speech(info, character, true, tr("Na ja, ich dachte … vielleicht, aber ich war mir nicht sicher. Vielleicht sollte ich mal bei ihr vorbeischauen."), null)
			call speech(info, character, true, tr("Mal unter uns, ich mag sie auch sehr. Erzähl das aber keinem, sonst schlage ich dir den Kopf ab!"), null)
			// Auftragsziel 1 des Auftrags „Talras' mutiger Waffenmeister“ abgeschlossen
			call QuestTheBraveArmourerOfTalras.characterQuest(character).questItem(0).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.agihard(), thistype.startPageAction)
			// start page
			set this.m_hello = this.addInfo(false, false, 0, thistype.infoActionHello, tr("Hallo."))
			set this.m_whichArena = this.addInfo(false, false, thistype.infoConditionBeforeArena, thistype.infoActionWhichArena, tr("Welche Arena?"))
			set this.m_anyRules = this.addInfo(true, false, thistype.infoConditionAfterHello, thistype.infoActionAnyRules, tr("Gibt es bestimmte Regeln in der Arena?"))
			set this.m_whatToWin = this.addInfo(true, false, thistype.infoConditionAfterHello, thistype.infoActionWhatToWin, tr("Was gibt es zu gewinnen?"))
			set this.m_letMeIn = this.addInfo(true, false, thistype.infoConditionAfterHelloNearArena, thistype.infoActionLetMeIn, tr("Lass mich in die Arena!"))
			set this.m_iCompleted = this.addInfo(true, false, thistype.infoConditionICompleted, thistype.infoActionICompleted, tr("Ich habe fünfmal gewonnen!"))
			set this.m_servantOfDuke = this.addInfo(false, false, thistype.infoConditionAfterHello, thistype.infoActionServantOfDuke, tr("Dienst du dem Herzog?"))
			set this.m_aboutWeapons = this.addInfo(true, false, thistype.infoConditionAboutWeapons, thistype.infoActionAboutWeapons, tr("Kennst du dich mit Waffen aus?"))
			set this.m_whatDoYouKnow = this.addInfo(false, false, thistype.infoConditionWhatDoYouKnow, thistype.infoActionWhatDoYouKnow, tr("Was weißt du über die Lage?"))
			set this.m_irminaLikesYou = this.addInfo(false, false, thistype.infoConditionIrminaLikesYou, thistype.infoActionIrminaLikesYou, tr("Irmina mag dich."))
			set this.m_exit = this.addExitButton()

			return this
		endmethod
	endstruct

endlibrary

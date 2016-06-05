library StructMapTalksTalkHeimrich requires Asl, StructMapMapNpcs, StructMapQuestsQuestANewAlliance, StructMapQuestsQuestTheDefenseOfTalras, StructMapQuestsQuestTheNorsemen, StructMapQuestsQuestWar

	struct TalkHeimrich extends Talk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			call this.showUntil(4, character)
		endmethod

		// Ich grüße Euch.
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich grüße Euch.", "I greet you."), null)
			call speech(info, character, true, tre("Hat Er nicht einen Auftrag? Falls es Schwierigkeiten gibt, sollte Er sich zunächst an meinen getreuen Ritter Markward oder meinen Vogt Ferdinand wenden.", "Does He not have a job? If there are difficulties, He should first contact my loyal knight Markward or my steward Ferdinand."), gg_snd_Heimrich1)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach Begrüßung)
		private static method infoCondition1And2And3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Was ist mit Eurer Frau und Euren Nachkommen?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was ist mit Eurer Frau und Euren Nachkommen?", "What about your wife and children?"), null)
			call speech(info, character, true, tre("Sie befinden sich bei meinem Vetter, in Sicherheit. Ich würde sie niemals der Gefahr hier aussetzen. Aber Er soll mir erklären, weshalb es Ihn interessiert.", "They are at my cosin, in safety. I would never expose them the danger here. But he should explain to me why it interested him."), gg_snd_Heimrich2)
			call speech(info, character, false, tre("Ich war nur besorgt um Euch …", "I was just worried about you ..."), null)
			call speech(info, character, true, tre("So? Dann danke ich Ihm für Seine Anteilnahme, jedoch sollte Er sich nun wieder um die benötigte Verstärkung kümmern.", "So? Then I thank him for his sympathy, but he should take care of the required reinforcement again."), gg_snd_Heimrich3)
			call info.talk().showStartPage(character)
		endmethod

		// Habt Ihr diese Burg errichtet?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Habt Ihr diese Burg errichtet?", "Have you built this castle?"), null)
			call speech(info, character, true, tre("Talras wird von meinem Geschlecht seit drei Generationen bewohnt. Mein Großvater bekam dieses Land und den Titel eines Ritters vom König für seine Tapferkeit im Krieg.", "Talras is inhabited by my family for three generations. My grandfather got this land and the title of a knight from the king for his bravery in the war."), gg_snd_Heimrich4)
			call speech(info, character, true, tre("Er ließ die einfache Holzbefestigung ausbauen, mit Stein und heute ist es eine stattliche Burg. Zusammen mit der Zeit vor meinem Großvater ist sie fast zweihundert Jahre alt.", "He had converted the simple wooden monting, with stone and today it is a stately castle. Along with the time before my grandfather is is nearly two hundred years old."), gg_snd_Heimrich5)
			call speech(info, character, true, tre("Ebenfalls ein stattliches Alter. Ich fürchte jedoch dieser Tage um mein Erbe. Falls die Feinde es mir nehmen sollten, bin ich ein armer Mann, wie es einst mein Großvater war.", "Also a stately age. However, I'm afraid these days to my heritage. If the enemy should take it from me, I am a poor man, as it once was my grandfather."), gg_snd_Heimrich6)
			call speech(info, character, false, tre("So so …", "So so ..."), null)
			call info.talk().showStartPage(character)
		endmethod

		// Was geschieht nun?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was geschieht nun?", "What happens now?"), null)
			// (Auftrag „Die Nordmänner“ ist aktiv)
			if (QuestTheNorsemen.quest().isNew()) then
				call speech(info, character, true, tre("Sorgt Er nur dafür, dass jene wilden Nordmänner sich meiner anschließen, damit wir aus dem Krieg als Sieger hervorgehen.", "He should only ensure that those wild northmen join me so that we emerge from the war as the winners."), gg_snd_Heimrich7)
			// (Auftrag „Ein neues Bündnis“ ist aktiv)
			elseif (QuestANewAlliance.quest().isNew()) then
				call speech(info, character, true, tre("Er muss die Hochelfin ausfindig machen, die sich irgendwo in Talras aufhält und sie hierher bringen. Ich benötige noch mehr Unterstützung gegen den Feind.", "He has to find the high elf who resides somewhere in Talras and bring her here. I need more support against the enemy."), gg_snd_Heimrich8)
			// (Auftrag „Krieg“ ist aktiv)
			elseif (QuestWar.quest().isNew()) then
				call speech(info, character, true, tre("Er muss den eroberten Außenposten befestigen lassen. Der Außenposten wird uns hoffentlich eine Zeit lang vor den Angriffen des Feindes schützen.", "He must fortify the conquered outpost. The outpost will protect us hopefully for some time from the attacks of the enemy."), gg_snd_Heimrich9)
			// (Auftrag „Die Verteidigung von Talras ist aktiv)
			elseif (QuestTheDefenseOfTalras.quest().isNew()) then
				call speech(info, character, true, tre("Er muss den Außenposten gegen die Orks und Dunkelelfen verteidigen. Sie dürfen die Burg nicht erreichen!", "He has to defend the outpost against the Orcs and Dark Elves. They shall not reach the castle!"), gg_snd_Heimrich10)
			// (Auftrag „Der Weg nach Holzbruck“ ist aktiv)
			else
				call speech(info, character, true, tre("Er muss mit den Seefahrern in Richtung Norden nach Holzbruck ziehen, um dort mehr Kriegsfähige zu finden, damit wir eine Chance gegen den Feind haben.", "He needs to go with the sea men towards north to Holzbruck, on order to find more fighting men, so that we have a chance against the enemy."), gg_snd_Heimrich11)
			endif

			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.heimrich(), thistype.startPageAction)

			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Ich grüße Euch.", "I greet you.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1And2And3, thistype.infoAction1, tre("Was ist mit Eurer Frau und Euren Nachkommen?", "What about your wife and children?")) // 1
			call this.addInfo(false, false, thistype.infoCondition1And2And3, thistype.infoAction2, tre("Habt Ihr diese Burg errichtet?", "Have you built this castle?")) // 2
			call this.addInfo(true, false, thistype.infoCondition1And2And3, thistype.infoAction3, tre("Was geschieht nun?", "What happens now?")) // 3
			call this.addExitButton() // 4

			return this
		endmethod
	endstruct

endlibrary
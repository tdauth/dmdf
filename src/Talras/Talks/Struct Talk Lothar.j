library StructMapTalksTalkLothar requires Asl, StructGameCharacter, StructMapMapNpcs, StructMapQuestsQuestABigPresent, StructMapQuestsQuestALittlePresent

	// TODO add missing sound files and sentences from talk file
	struct TalkLothar extends Talk
		private boolean array m_saidTruth[12] /// \todo MapData.maxplayers

		implement Talk

		public method saidTruth takes Character character returns boolean
			return this.m_saidTruth[GetPlayerId(character.player())]
		endmethod

		private method sayTruth takes Character character returns nothing
			set this.m_saidTruth[GetPlayerId(character.player())] = true
		endmethod

		private method startPageAction takes ACharacter character returns nothing
			if (not this.showInfo(0, character)) then
				call this.showRange(1, 9, character)
			endif
		endmethod

		// (Automatisch)
		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("Gegrüßt seist du, fremder Reisender! Kann ich dich vielleicht für einen leckeren Topf voll Honig von den glücklichsten Bienen im ganzen Königreich oder einen köstlichen Becher voll wunderbarem Wein begeistern?", "Greetings foreign taveler! Can I impress you perhaps for a delicious pot of honey from the happiest bees in the kingdom or a delicious cup full of wonderful wine?"), gg_snd_Lothar1)
			call speech(info, character, true, tre("Greif zu solange noch Ware da ist! Ich kann für nichts garantieren. Vielleicht kommt gleich ein anderer Interessierter, der dir alles vor der Nase wegschnappt.", "Take it as long as merchandise is here! I cannot guarantee anything. Perhaps another one comes along now who snaps off everything in front of you."), gg_snd_Lothar2)
			call info.talk().showStartPage(character)
		endmethod

		// Wer bist du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer bist du?", "Who are you?"), null)
			call speech(info, character, true, tre("Mein Name ist Lothar und ich bin zweifellos der erfolgreichste Händler im ganzen Königreich und zudem noch der glücklichste.", "My name is Lothar and I am without a doubt the most successful merchant in the whole kingdom and besides the happiest, too."), gg_snd_Lothar3)
			call speech(info, character, true, tre("Ich verkaufe selbst hergestellten Wein und Honig. Die schönsten und genussvollsten Dinge des bescheidenen Lebens in dieser Welt!", "I sell wine and honey which I made by myself. The most beautiful and most delicious things of the modest life in this world!"), gg_snd_Lothar4)
			call info.talk().showRange(10, 13, character)
		endmethod

		// Woher kommst du?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Woher kommst du?", "Where are you from?"), null)
			call speech(info, character, true, tre("Ach, ähm, ja … es spielt doch keine Rolle woher wir kommen, vielmehr wohin wir gehen! Aber wenn du es unbedingt wissen willst, ich komme aus dem Südwesten des Königreichs.", "Oh, um, yes ... it really does not matter where we come from, but where we are going! But if you want to know it absolutely, I'm from the south-west of the kingdom."), gg_snd_Lothar8)
			call speech(info, character, true, tre("Vor vielen Jahren zog es mich nach Talras und zufälligerweise fehlte auf dem Bauernhof ein echter Händler, der geschickt seine Ware unters Volk bringt.", "Many years ago I moved to Talras and coincidentally a real trader was missing on the farm who brings his goods to the people cleverly."), gg_snd_Lothar9)
			call speech(info, character, true, tre("Also zog ich in die Hütte des Totengräbers.", "So I moved into the hut of the gravedigger."), gg_snd_Lothar10)
			call speech(info, character, false, tre("Des Totengräbers?", "Of the gravedigger?"), null)
			call speech(info, character, true, tre("Ähm, ja, ja des Totengräbers. Archibald war sein Name, wenn ich mich recht erinnere. Er war ein Mönch oder sowas und starb kurz bevor ich kam. Woran weiß ich nicht, ist mir auch egal.", "Um, yes, yes of the gravedigger. Archibald was his name, if I remember it correctly. He was a monk or something like that and died shortly before I came. I don't know why and I don't care."), gg_snd_Lothar11)
			call info.talk().showStartPage(character)
		endmethod

		// Was hältst du vom Bauernhof?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was hältst du vom Bauernhof?", "What do you think about the farm?"), null)
			call speech(info, character, true, tre("Wieso fragst du?", "Why do you ask?"), gg_snd_Lothar12)
			call speech(info, character, true, tre("Dich schickt doch nicht etwa Manfred, oder Mathilda?", "But Manfred is not sending you, or Mathilda?"), gg_snd_Lothar13)
			call speech(info, character, true, tre("Mathilda … hat sie, nein das kann nicht sein! Oder doch?", "Mathilda ... has she, no, that can not be! Or can it?"), gg_snd_Lothar14)
			call speech(info, character, false, tre("Was?", "What?"), null)
			call speech(info, character, true, tre("Mein Herz gehört ihr, auf ewig! Aber ich werde es ihr niemals sagen können …", "My heart belongs to her, forever! But I will never be able to tell it to her ..."), gg_snd_Lothar15)
			call speech(info, character, true, tre("Du bist doch sicher mutig?", "You are surely brave?"), gg_snd_Lothar16)
			call speech(info, character, false, tre("Also …", "Um ..."), null)
			call speech(info, character, true, tre("Bitte, du musst mir einen Gefallen tun! Gib ihr diesen Topf mit meinem besten Honig als Zeichen meiner Liebe. Sag ihr aber auf keinen Fall von wem er ist!", "Please, you have to do me a favor! Give her this pot with my best honey as a sign of my love. But definetly do not tell here from whom it is!"), gg_snd_Lothar17)
			call speech(info, character, false, tre("Ähm, du bist der einzige Imker auf dem …", "Um, you're the only beekeeper in the ..."), null)
			call speech(info, character, true, tre("Bitte!", "Please!"), gg_snd_Lothar18)
			call info.talk().showRange(14, 16, character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein kleines Geschenk“ ist abgeschlossen, Auftrag ist noch aktiv)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestALittlePresent.characterQuest(character).questItem(0).isCompleted() and QuestALittlePresent.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich habe Mathilda deinen Honigtopf gegeben.
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich habe Mathilda deinen Honigtopf gegeben.", "I gave Mathilda the honey pot."), null)

			call speech(info, character, true, tre("Danke, mein Freund! Wie hat sie reagiert? War sie erfreut, entzückt?", "Thank you my friend! Was she pleased, delighted?"), gg_snd_Lothar24)
			call speech(info, character, false, tre("Na ja …", "Well ..."), null)
			// Auftrag „Ein kleines Geschenk“ abgeschlossen
			call QuestALittlePresent.characterQuest(character).complete()
			call speech(info, character, true, tre("Oh nein, ich habe es geahnt! Ich muss mir einfach mehr Mühe geben. Hier, überreiche ihr diesen großen Honigtopf. Das muss ihr einfach gefallen.", "Oh no, I've guessed it! I just have to put more effort into it. Here, give her this big honeypot. She just has to like this!"), gg_snd_Lothar25)

			call info.talk().showRange(17, 19, character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Ein großes Geschenk“ ist abgeschlossen, Auftrag ist noch aktiv)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return QuestABigPresent.characterQuest(character).questItem(0).isCompleted() and QuestABigPresent.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich habe Mathilda deinen großen Honigtopf gegeben.
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich habe Mathilda deinen großen Honigtopf gegeben.", "I gave Matilda the big honey pot."), null)
			call speech(info, character, true, tre("Hat sie sich diesmal wenigstens gefreut?", "Was she at least pleased this time?"), gg_snd_Lothar31)
			call speech(info, character, false, tre("Na ja …", "Well ..."), null)
			// Auftrag „Ein großes Geschenk“ abgeschlossen
			call QuestABigPresent.characterQuest(character).complete()
			call speech(info, character, true, tre("Nun sag schon!", "Now, tell me!"), gg_snd_Lothar32)
			call info.talk().showRange(20, 22, character)
		endmethod

		// Wie läuft das Geschäft?
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wie läuft das Geschäft?", "How does the business go?"), null)
			call speech(info, character, true, tre("Sehr gut, sehr gut, danke der Nachfrage! Also …", "Very good, very good, thanks for asking! So ..."), gg_snd_Lothar37)
			call speech(info, character, false, tre("Also was?", "So what?"), null)
			call speech(info, character, true, tre("Na ja, da ist so eine Sache …", "Well, there is such a thing ..."), gg_snd_Lothar38)
			call speech(info, character, false, tre("Spucks aus!", "Just tell me!"), null)
			call speech(info, character, true, tre("Also, es geht um meine Weinreben, oben auf dem Mühlberg, wo auch der Müller Guntrich seine Mühle stehen hat. Vor einer Weile hat er mir von diesem Trommeln im Berg erzählt.", "So, it is about my vines, on the top of the Mill Hill where the miller Guntrich has also his mill. A while ago he told me about these drums in the mountain."), gg_snd_Lothar39)
			call speech(info, character, true, tre("Als kämpfe ein ganzes Heer gegen ein anderes, hat er gesagt. Ich bin sicher kein Feigling, aber jetzt traue selbst ich mich nicht mehr auf den Berg.", "As there was fighting an army against another, he said. I'm surely not a coward, but now even I don't dare to go to the mountain anymore."), gg_snd_Lothar40)
			call speech(info, character, true, tre("So kann ich aber meine Trauben nicht pflücken und mir entgeht eine Menge Goldmünzen. Natürlich ist es vor allem zum Nachteil der armen Bauern, die keinen Wein mehr an ruhigen Abenden genießen können, diese Armen.", "So I can't pick my grapes and I am missing a lot of gold coins. Of course, it is mainly to the detriment of the ppor farmers who cannot enjoy anymore wine in calm evenings, these poors."), gg_snd_Lothar41)
			call speech(info, character, false, tre("Natürlich.", "Of course."), null)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wie läuft das Geschäft?“, Auftrag „Geisterstunde“ ist abgeschlossen)
		private static method infoCondition7 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(6, character) and QuestWitchingHour.characterQuest(character).isCompleted()
		endmethod

		// Du kannst wieder Trauben pflücken gehen.
		private static method infoAction7 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Du kannst wieder Trauben pflücken gehen.", "You can go pick grapes again."), null)
			call speech(info, character, true, tre("Wie bitte?", "I beg your pardon?"), gg_snd_Lothar42)
			call speech(info, character, false, tre("Da gibt es keine Geister. Ich habe nachgesehen.", "There are no ghosts. I checked."), null)
			call speech(info, character, true, tre("Bist du sicher? Aber ich dachte selbst, ich hätte mal die Trommeln gehört, als ich gerade bei der Arbeit war. Ich …", "Are you sure? But I thought myself, I would have heard the drums when I was at work. I ..."), gg_snd_Lothar43)
			call speech(info, character, false, tre("Da gibt es nichts, frag einfach Guntrich!", "There is nothing, just ask Guntrich!"), null)
			call speech(info, character, true, tre("Na gut, ich vertraue dir mal. Hier hast du einen Topf mit feinstem Honig. Erzähl aber bitte keinem davon, vor allem nicht Mathilda!", "Well, I trust you once. Here you have a pot of the finest honey. But please don't tell anyone, especially not Mathilda!"), gg_snd_Lothar44)
			call speech(info, character, false, tre("Keine Sorge.", "Don't worry."), null)
			// Charakter erhält einen Honigtopf
			call character.giveItem('I065')
			// Charakter erhält einen Erfahrungsbonus
			call Character(character).xpBonus(50, tre("Geisterstunde", "Witching Hour"))
			call info.talk().showStartPage(character)
		endmethod

		// Was genau verkaufst du?
		private static method infoAction8 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was genau verkaufst du?", "What exactly are you selling?"), null)
			call speech(info, character, true, tre("Wie ich es dir schon angeboten habe, Wein und Honig, aber auch andere Lebensmittel und Gebrauchsgegenstände. Aber sicher keinen Ramsch, sondern nur das Beste vom Besten!", "As I have already offered you, wine and honey, as well as other food and utensils. But certainly not junk, rather only the best of the best!"), gg_snd_Lothar45)
			call speech(info, character, false, tre("Schon klar.", "I got it."), null)
			call speech(info, character, true, tre("Wissen kann ich dir leider nicht anbieten (sarkastisch). Dafür ist die alte Schreckschraube Ursula da (grinst).", "Knowledge I can not offer you unfortunately (sarcastic). For this the old hag Ursula exists (grins)."), gg_snd_Lothar46)
			call speech(info, character, true, tre("Das ist so eine alte Hexe und Einsiedlerin, die im Süden ihre Grotte hat und glaubt, sie sei weise (lacht). Mich lässt schon der Gedanke an sie erschaudern.", "This is such an old hag and reculse, who has here grotto in the south and thinks she would be wise (laughs). Only thinking of her lets me cringe."), gg_snd_Lothar47)
			call info.talk().showStartPage(character)
		endmethod

		// Fettsack!
		private static method infoAction1_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Fettsack!", "Fatso!"), null)
			call speech(info, character, true, tre("Was redest du da? Ist das etwa eine gebührliche Art, mit einem Fremden umzugehen?", "What are you talking about? Is that a duly way of dealing with a stranger?"), gg_snd_Lothar5)
			call info.talk().showStartPage(character)
		endmethod

		// Du laberst ganz schön viel.
		private static method infoAction1_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Du laberst ganz schön viel.", "You are talking quite a lot."), null)
			call speech(info, character, true, tre("Männer meines Standes müssen ihre Ware an den Mann bringen. Ich kann es mir nicht leisten, darauf zu warten, dass sich meine Ware von selbst verkauft.", "Men of my class have to bring their goods to the man. I can not afford to wait for my goods getting sold by themselves."), gg_snd_Lothar6)
			call info.talk().showStartPage(character)
		endmethod

		// Gib mir eine Kostprobe.
		private static method infoAction1_2 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Gib mir eine Kostprobe.", "Give me a taste."), null)
			call speech(info, character, true, tre("Wie du wünschst, mein weiser Freund. Hier ist ein Krug voll köstlichem Wein, ganz umsonst für dich!", "As you wish, my wise friend. Here is a pitcher full of excellent wine, all in vain for you!"), gg_snd_Lothar7)
			// Charakter erhält einen Weinkrug
			call character.giveItem('I066')
			call info.talk().showStartPage(character)
		endmethod

		// Na gut.
		private static method infoAction3_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Na gut.", "Okay."), null)
			call speech(info, character, true, tre("Vielen Dank. Es wird nicht dein Schaden sein, ich werde dich selbstverständlich angemessen dafür entlohnen.", "Thank you very much. It will not be your loss, I will of course pay adequately for it."), gg_snd_Lothar19)
			call speech(info, character, true, tre("Hier hast du den Honigtopf.", "Here you have the honeypot."), gg_snd_Lothar20)
			// Neuer Auftrag „Ein kleines Geschenk“
			call QuestALittlePresent.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Friss deinen Honig doch selbst, du dummer Fettsack!
		private static method infoAction3_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Friss deinen Honig doch selbst, du dummer Fettsack!", "Eat your honey yourself, you stupid fatso!"), null)
			call speech(info, character, true, tre("Was? Unerhört, dieses törichte Verhalten! Du solltest solange du hier bist besser gut auf dich aufpassen!", "What? Unheard, this foolish behavior! You should better take good care of you as long as you're here!"), gg_snd_Lothar21)
			call speech(info, character, false, tre("Willst du mich überrollen oder was?", "Do you want to run over me or what?"), null)
			call speech(info, character, true, tre("Bitte, nimm doch etwas Rücksicht auf mich (schluchzt)!", "Please, take some consideration on me (sob)!"), gg_snd_Lothar22)
			// Charakter erhält Erfahrungsbonus aufgrund seiner beleidigenden Art.
			call Character(character).xpBonus(50, tre("Beleidigungsbonus", "Insult Bonus"))
			call info.talk().showStartPage(character)
		endmethod

		// Kein Interesse.
		private static method infoAction3_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kein Interesse.", "No interest."), null)
			call speech(info, character, true, tre("Zu schade. So wird sie es nie erfahren.", "Too bad. So she will never know."), gg_snd_Lothar23)
			call info.talk().showStartPage(character)
		endmethod

		// In Ordnung.
		private static method infoAction4_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("In Ordnung.", "Agreed."), null)
			call speech(info, character, true, tre("Gut. Vergiss aber nicht, meinen Namen nicht zu erwähnen!", "Good. But do not forget not to mention my name!"), gg_snd_Lothar26)
			// Neuer Auftrag „Ein großes Geschenk“
			call QuestABigPresent.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Deine extreme Fettleibigkeit gefällt dagegen mir nicht!
		private static method infoAction4_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Deine extreme Fettleibigkeit gefällt dagegen mir nicht!", "On the other hand I don't like you're extreme obesity!"), null)
			call speech(info, character, true, tre("Wie kannst du es …", "How can you ..."), gg_snd_Lothar27)
			call speech(info, character, false, tre("Du bist einfach fett und jetzt halt die Fresse! Du wirst nie bei ihr landen, niemals!", "You're fat and now shut up! You will never get her, never!"), null)
			call speech(info, character, true, tre("Bitte tritt nicht auf meine Träume (schluchzt)!", "Please do not step on my dreams (sobs)!"), gg_snd_Lothar28)
			// Charakter erhält Erfahrungsbonus aufgrund seiner beleidigenden Art.
			call Character(character).xpBonus(50, tre("Beleidigungsbonus.
			", "Insult Bonus"))
			call info.talk().showStartPage(character)
		endmethod

		// Wie wärs eigentlich mal mit Blumen oder einem netten Gespräch?
		private static method infoAction4_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wie wärs eigentlich mal mit Blumen oder einem netten Gespräch?", "How about some flowers or a nice conversation?"), null)
			call speech(info, character, true, tre("Ich unterhalte mich mit ihr so gut wie jeden Tag, aber sie scheint nichts für mich zu empfinden.", "I talk to her almost every day, but she seems to feel nothing for me."), gg_snd_Lothar29)
			call speech(info, character, false, tre("Und zwei Honigtöpfe sollen das ändern?", "And two honeypots should change that?"), null)
			call speech(info, character, true, tre("Wenn du mich so fragst, ja. Blumen gibt es hier in der Nähe ja kaum und ich gehe sicher nicht den weiten Weg in den Wald, nur um Gestrüpp zu pflücken.", "If you keep asking me, yes. Flowers are hardly ardound here and I'm certainly not walking all the way into the forest, only to pick scrub."), gg_snd_Lothar30)
			call speech(info, character, false, tre("Alles klar!", "All right!"), null)
			// Charakter erhält Erfahrungsbonus aufgrund seiner weisen Art.
			call Character(character).xpBonus(50, tre("Weisheitsbonus.", "Wisdom Bonus"))
			// Achtung: Hier wird wieder die Seite mit „In Ordnung“ angezeigt. Diese Auswahl verhindert nicht, dass der Auftrag angenommen werden kann.
			call info.talk().showRange(17, 19, character)
		endmethod

		// Sie hat sich sehr gefreut.
		private static method infoAction5_0 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Sie hat sich sehr gefreut.", "She was very happy."), null)
			call speech(info, character, true, tre("Tatsächlich? Das ist ja großartig! Hier hast du Goldmünzen und Wein. Ich werde mich heute erstmal kräftig zulaufen lassen, zur Feier des Tages!", "Really? That's great! Here you have gold coins and wine. I'll now first drink vigorously to celebrate the day!"), gg_snd_Lothar33)
			// Charakter erhält 100 Goldmünzen und 2 Krüge Wein
			call character.addGold(100)
			call character.giveItem('I066')
			call character.giveItem('I066')
			call info.talk().showStartPage(character)
		endmethod

		// Sie war eher genervt.
		private static method infoAction5_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Sie war eher genervt.", "She was rather annoyed."), null)
			// (Erfahrungsoption bei Mathilda freigeschaltet)
			call thistype(info.talk()).sayTruth(character)
			call speech(info, character, true, tre("Oh nein! Was habe ich getan? In Zukunft werde ich vorsichtiger bei ihr sein, das wollte ich wirklich nicht!", "Oh no! What have I done? In future I will be more careful with her, I realldy did not want that!"), gg_snd_Lothar34)
			call info.talk().showStartPage(character)
		endmethod

		// Sie meinte nur, du seist extrem fett.
		private static method infoAction5_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Sie meinte nur, du seist extrem fett.", "She just said you were extremely fat."), null)
			call speech(info, character, true, tre("Ich bin nicht fett, ich habe nur …", "I'm not fat, I only ..."), gg_snd_Lothar35)
			call speech(info, character, false, tre("… drei Riesen gefressen?", "... ate three giants?"), null)
			call speech(info, character, true, tre("Sehr lustig (zynisch)!", "Very funny (cynical)!"), gg_snd_Lothar36)
			// Charakter erhält Erfahrungsbonus aufgrund seiner beleidigenden Art.
			call Character(character).xpBonus(50, tre("Beleidigungsbonus.", "Insult Bonus"))
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.lothar(), thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_saidTruth[i] = false
				set i = i + 1
			endloop

			// start page
			call this.addInfo(false, true, 0, thistype.infoAction0, null) // 0
			call this.addInfo(false, false, 0, thistype.infoAction1, tre("Wer bist du?", "Who are you?")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tre("Woher kommst du?", "Where are you from?")) // 2
			call this.addInfo(false, false, 0, thistype.infoAction3, tre("Was hältst du vom Bauernhof?", "What do you think about the farm?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Ich habe Mathilda deinen Honigtopf gegeben.", "I gave Mathilda the honey pot.")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tre("Ich habe Mathilda deinen großen Honigtopf gegeben.", "I gave Matilda the big honey pot.")) // 5
			call this.addInfo(false, false, 0, thistype.infoAction6, tre("Wie läuft das Geschäft?", "How does the business go?")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tre("Du kannst wieder Trauben pflücken gehen.", "You can go pick grapes again.")) // 7
			call this.addInfo(true, false, 0, thistype.infoAction8, tre("Was genau verkaufst du?", "What exactly are you selling?")) // 8
			call this.addExitButton() // 9

			// info 1
			call this.addInfo(false, false, 0, thistype.infoAction1_0, tre("Fettsack!", "Fatso!")) // 10
			call this.addInfo(false, false, 0, thistype.infoAction1_1, tre("Du laberst ganz schön viel.", "You are talking quite a lot.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction1_2, tre("Gib mir eine Kostprobe.", "Give me a taste.")) // 12
			call this.addBackToStartPageButton() // 13

			// info 3
			call this.addInfo(false, false, 0, thistype.infoAction3_0, tre("Na gut.", "Okay.")) // 14
			call this.addInfo(false, false, 0, thistype.infoAction3_1, tre("Friss deinen Honig doch selbst, du dummer Fettsack!", "Eat your honey yourself, you stupid fatso!")) // 15
			call this.addInfo(false, false, 0, thistype.infoAction3_2, tre("Kein Interesse.", "No interest.")) // 16

			// info 4
			call this.addInfo(false, false, 0, thistype.infoAction4_0, tre("In Ordnung.", "Agreed.")) // 17
			call this.addInfo(false, false, 0, thistype.infoAction4_1, tre("Deine extreme Fettleibigkeit gefällt dagegen mir nicht!", "On the other hand I don't like you're extreme obesity!")) // 18
			call this.addInfo(false, false, 0, thistype.infoAction4_2, tre("Wie wärs eigentlich mal mit Blumen oder einem netten Gespräch?", "How about some flowers or a nice conversation?")) // 19

			// info 5
			call this.addInfo(false, false, 0, thistype.infoAction5_0, tre("Sie hat sich sehr gefreut.", "She was very happy.")) // 20
			call this.addInfo(false, false, 0, thistype.infoAction5_1, tre("Sie war eher genervt.", "She was rather annoyed.")) // 21
			call this.addInfo(false, false, 0, thistype.infoAction5_2, tre("Sie meinte nur, du seist extrem fett.", "She just said you were extremely fat.")) // 22

			return this
		endmethod
	endstruct

endlibrary

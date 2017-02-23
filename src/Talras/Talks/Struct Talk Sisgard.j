library StructMapTalksTalkSisgard requires Asl, StructGameCharacter, StructGameClasses, StructMapMapNpcs, StructMapMapFellows, StructMapQuestsQuestTheMagic, StructMapQuestsQuestTheMagicalShield, StructMapQuestsQuestTheGhostOfTheMaster

	struct TalkSisgard extends Talk
		private static AInfo m_hi
		private static AInfo m_hi_whyNot
		private static AInfo m_hi_no
		private static AInfo m_yourHouse
		private static AInfo m_whatDoYouSell
		private static AInfo m_aboutYourMaster
		private static AInfo m_youAreAWizard
		private static AInfo m_comeWithMe
		private static AInfo m_beenAtTheRunes
		private static AInfo m_beenAtTheRunes_magic
		private static AInfo m_beenAtTheRunes_nothing
		private static AInfo m_makeGood
		private static AInfo m_triedTheShield
		private static AInfo m_moreHelp
		private static AInfo m_metYourMaster
		private static AInfo m_letsGo
		private static AInfo m_onMyOwn
		private static AInfo m_busy
		private static AInfo m_exit

		private method startPageAction takes ACharacter character returns nothing
			call thistype.m_hi.show(character)
			call thistype.m_yourHouse.show(character)
			call thistype.m_whatDoYouSell.show(character)
			call thistype.m_aboutYourMaster.show(character)
			call thistype.m_youAreAWizard.show(character)
			call thistype.m_comeWithMe.show(character)
			call thistype.m_beenAtTheRunes.show(character)
			call thistype.m_makeGood.show(character)
			call thistype.m_triedTheShield.show(character)
			call thistype.m_moreHelp.show(character)
			call thistype.m_metYourMaster.show(character)
			call thistype.m_letsGo.show(character)
			call thistype.m_onMyOwn.show(character)
			call thistype.m_busy.show(character)
			call thistype.m_exit.show(character)
			call this.show(character.player())
		endmethod

		// Hallo.
		private static method infoActionHi takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo. Bist du vielleicht an einigen Zaubern oder Tränken interessiert?", "Hello. Are you interested in some spells or potions?"), gg_snd_Sisgard1)
			call info.talk().showRange(thistype.m_hi_whyNot.index(), thistype.m_hi_no.index(), character)
		endmethod

		// Wieso nicht?
		private static method infoActionHi_WhyNot takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso nicht?", "Why not?"), null)
			call speech(info, character, true, tre("Oh, das freut mich aber. In diesen schweren Zeiten trifft man nur noch selten Kauffreudige.", "Oh, I'm glad about that. In these difficult times you rarely meet people anymore who want to buy stuff."), gg_snd_Sisgard2)
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoActionHi_No takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Schade, na ja, vielleicht überlegst du es dir ja noch.", "Too bad, well, maybe you still think about it."), gg_snd_Sisgard3)
			call info.talk().showStartPage(character)
		endmethod

		private static method infoConditionGreeting takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(thistype.m_hi.index(), character)
		endmethod

		// Ist das dein Haus?
		private static method infoActionYourHouse takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ist das dein Haus?", "Is this your house?"), null)
			call speech(info, character, true, tre("Ja, ich habe es für einen guten Preis erworben. Ich ließ mich hier nieder nachdem mein Meister vor einigen Jahren mit mir nach Talras ging und bald darauf starb.", "Yes, I bought it for a good price. I settled down here after my master went with me to Talras a few years ago and died soon after."), gg_snd_Sisgard4)
			call speech(info, character, true, tre("Er war schon sehr alt und diese Gegend hier war seine Heimat. Er erinnerte sich sogar an die Zeit als hier noch keine Burg stand.", "He was already very old and this area was his home. He even remembered the time when there was no castle here."), gg_snd_Sisgard5)
			call info.talk().showStartPage(character)
		endmethod

		// Was genau verkaufst du?
		private static method infoActionWhatDoYouSell takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was genau verkaufst du?", "What exactly do you sell?"), null)
			call speech(info, character, true, tre("Tränke und magische Gegenstände aller Art. Falls du ein Zauberer oder Magier bist, wirst du bei mir genau das Richtige finden.", "Potions and magical objects of all kinds. If you are a wizard or magician, you will find exactly the right thing with me."), gg_snd_Sisgard6)
			call speech(info, character, true, tre("Ich biete nur das Beste an, was ich auch selbst verwenden würde.", "I offer only the best, which I would use myself."), gg_snd_Sisgard7)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Ist das dein Haus“, dauerhaft)
		private static method infoConditionAboutYourMaster takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(thistype.m_yourHouse.index(), character)
		endmethod

		// Erzähl mir mehr von deinem Meister.
		private static method infoActionAboutYourMaster takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Erzähl mir mehr von deinem Meister.", "Tell me about your master."), null)
			call speech(info, character, true, tre("So, dich interessiert das also? Hmm, die meisten Leute würgen mich irgendwann ab, wenn ich mal wieder das Schwärmen von alten Zeiten anfange.", "So, you're interested in this? Hmm, most people choke me off as soon as I start becoming enthusiastic about ancient times."), gg_snd_Sisgard8)
			call speech(info, character, true, tre("Mein Meister war ein großer Zauberer und sein Wissen war so umfassend, dass er selbst bei den Magiern der Hochelfen, welche sich eher mit den Elementen als mit der magischen Kraft und deren Beherrschung beschäftigen, ein hohes Ansehen genoss.", "My master was a great wizard and his knowledge was so comprehensive that he was highly respected even among the magicians of the High Elves, who were more concerned with the elements than with the magicial power and their mastery."), gg_snd_Sisgard9)
			call speech(info, character, true, tre("Das erste Mal traf ich ihn im Kloster eines Klerikerordens, in welches mich meine Eltern geschickt hatten. Leider ist das oft die einzige Möglichkeit an Bildung heranzukommen und auch wenn sie es gut meinten, dieses ganze Beten und Huldigen war todlangweilig.", "The first time I met him in the monastery of the clerical order, to which my parents had sent me. Unfortunately, this is often the only way to get education, and even if they meant well, all this prayer and homage was dull."), gg_snd_Sisgard10)
			call speech(info, character, true, tre("Mein Meister war also auf der Durchreise und suchte einen Ort zum Übernachten. Ich war neugierig und fragte ihn über alles aus und da er schon lange keinen Schüler mehr gehabt hatte, bot ich mich ihm als solchen an.", "So my master was on the way through and was looking for a place to stay. I was curious and asked him about everything, and since he had not had a student for a long time, I offered myself to him as such."), gg_snd_Sisgard10_1)
			call speech(info, character, true, tre("Schließlich willigte er gegen meine Erwartungen ein und von diesem Zeitpunkt an war ich eine Schülerin der Zauberkunst.", "Finally, he agreed against my expectations, and from that time on I was a student of magic."), gg_snd_Sisgard11)
			call speech(info, character, true, tre("Er hat mich vieles gelehrt und ihm verdanke ich so ziemlich alles, was ich heute bin. Er nahm mich mit ins Königreich der Hochelfen und Zwerge und selbst durch die Gebirge der Orks zogen wir. Wir trotzten allen Gefahren ...", "He taught me a lot and I owe him almost everything I am today. He took me with him into the kingdom of the High Elves and Dwarves and even through the mountains of the Orcs we moved. We defied all dangers ..."), gg_snd_Sisgard12)
			call speech(info, character, true, tre("Doch was rede ich da. Das ist längst Vergangenheit und nun bin ich nicht mehr als eine einfache Händlerin, die ihre verbliebene Zeit weiterhin für die Studien der Zauberkünste nutzt.", "But what am I saying? This is long past and now I am no more than a simple trader who continues to use her remaining time for the studies of the magic arts."), gg_snd_Sisgard13)
			call speech(info, character, true, tre("Ich wünschte, ich könnte erneut losziehen, wie damals und gemeinsam mit Gleichgesinnten Abenteuer erleben und allen Feinden trotzen.", "I wish I could go again, as I did at that time and together with the like-minded experience adventures, and defy all the enemies."), gg_snd_Sisgard14)
			call info.talk().showStartPage(character)
		endmethod

		// Du bist wohl eine Zauberin?
		private static method infoActionYouAreAWizard takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Du bist wohl eine Zauberin?", "You're probably a sorceress?"), null)
			if (character.class() == Classes.wizard()) then
				call speech(info, character, true, tre("Und du bist wohl ein Zauberer. Freut mich dich kennenzulernen. Hier trifft man nicht oft andere Zauberer.", "And you're probably a wizard. I am pleased to meet you. You do not often meet other wizards."), gg_snd_Sisgard15)
				call speech(info, character, true, tre("Pass auf, ich schenke dir einige Zauberspruchrollen.", "Look, I'll give you some spell scrolls."), gg_snd_Sisgard16)
				// TODO gg_snd_Sisgard17 ???
				// TODO gg_snd_Sisgard18??
				/// Charakter erhält Zauberspruchrollen
				call character.giveItem('I049')
				call character.giveItem('I049')
				call character.giveItem('I00F')
				call character.giveItem('I00F')
				call character.giveItem('I00G')
				call character.giveItem('I00G')
			else
				call speech(info, character, true, tre("Ja, ich bin eine Zauberin. Deshalb verkaufe ich ja auch Zauber und Tränke. Alles was das Magier- oder Zaubererherz begehrt.", "Yes, I am a sorceress. That's why I'm selling spells and potions. Everything the magician or wizard heart desires."), gg_snd_Sisgard19)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat sich das Gelaber über ihren Meister angehört)
		private static method infoConditionComeWithMe takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(thistype.m_aboutYourMaster.index(), character)
		endmethod

		// Zieh mit mir in den Kampf!
		private static method infoActionComeWithMe takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Zieh mit mir in den Kampf!", "Go into battle with me!"), null)
			call speech(info, character, true, tre("Ich soll mit dir in den Kampf ziehen? Hmm, so wie damals mit meinem Meister. Das waren noch Zeiten ...", "I should go into battle with you? Hmm, as I did with my master. Those were the days ..."), gg_snd_Sisgard20)
			call speech(info, character, true, tre("Beherrscht du denn auch die Zauberkunst?", "Do you master the magical art?"), gg_snd_Sisgard21)
			call speech(info, character, false, tre("Sicher.", "For sure."), null)
			call speech(info, character, true, tre("Beweise es mir! In der Nähe gibt es einen Wald, wir nennen ihn den Dunkelwald. In diesem Wald stehen einige Runensteine, die dort vor einer Ewigkeit errichtet wurden. Mein Meister sprach von einer außergewöhnlichen Aura, welche diese Steine umgibt.", "Prove it to me! Nearby there is a forest, we call it the Dark Forest. In this forest there are some rune stones that were built there an enternity ago. My master spoke of an extraordinary aura surrounding these stones."), gg_snd_Sisgard22)
			call speech(info, character, true, tre("Er gab mir vor seinem Tod einige Zauberspruchrollen, mit welchen es mir möglich sein sollte, jene Aura zu nutzen. Nimm eine dieser Zauberspruchrollen, geh zu den Runensteinen und probiere aus, was passiert wenn du sie wirken lässt, dann komm wieder und berichte mir davon.", "He gave me a few spells to cast before his death, so I could use that aura. Take one of these spells, go to the rune stones and try what happens when you cast them, then come back and tell me about it."), gg_snd_Sisgard23)
			call QuestTheMagic.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Charakter hat die Zauberspruchrolle bei den Runensteinen benutzt)
		private static method infoConditionBeenAtTheRunes takes AInfo info, ACharacter character returns boolean
			return QuestTheMagic.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Ich war bei den Runensteinen.
		private static method infoActionBeenAtTheRunes takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich war bei den Runensteinen.", "I was at the rune stones."), null)
			call speech(info, character, true, tre("Und, was ist passiert?", "And what happened?"), gg_snd_Sisgard24)
			call info.talk().showRange(thistype.m_beenAtTheRunes_magic.index(), thistype.m_beenAtTheRunes_nothing.index(), character)
		endmethod

		// Ich spürte, wie die magischen Kräfte mich durchflossen.
		private static method infoActionBeenAtTheRunes_Magic takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich spürte, wie die magischen Kräfte mich durchflossen.", "I could feel the magical powers running through me."), null)
			call speech(info, character, true, tre("Hmm, dann solltest du mal einen Heiler aufsuchen.", "Hmm, then you should visit a healer."), gg_snd_Sisgard25)
			call speech(info, character, true, tre("Tut mir leid, aber ich habe dich belogen, um zu sehen, ob du eine ehrliche Haut bist. Mit unehrlichen Leuten werde ich sicherlich nicht gemeinsam umher ziehen.", "I'm sorry but I've lied to you to see if you're an honest man. I will certainly not go together with dishonest people."), gg_snd_Sisgard26)
			call QuestTheMagic.characterQuest(character).fail()
			call info.talk().showStartPage(character)
		endmethod

		// Gar nichts.
		private static method infoActionBeenAtTheRunes_Nothing takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Gar nichts.", "Nothing at all."), null)
			call speech(info, character, true, tre("Ich hatte nichts anderes erwartet. Das war nur ein Test, um zu sehen, ob du eine ehrliche Haut bist.", "I expected nothing else. This was just a test to see if you're an honest man."), gg_snd_Sisgard27)
			call speech(info, character, true, tre("Von mir aus können wir jederzeit gemeinsam losziehen.", "From me, we can go together at any time."), gg_snd_Sisgard28)
			call QuestTheMagic.characterQuest(character).complete()
			// Belohung übergeben
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00E')
			call character.giveItem('I00E')
			call character.giveItem('I00E')
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Zauberkunst“ ist fehlgeschlagen)
		private static method infoConditionMakeGood takes AInfo info, ACharacter character returns boolean
			return QuestTheMagic.characterQuest(character).isFailed()
		endmethod

		// Kann ich es wieder gut machen?
		private static method infoActionMakeGood takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kann ich es wieder gut machen?", "Can I make up for it?"), null)
			call speech(info, character, true, tre("Vielleicht, immerhin will ich nicht nachtragend da stehen auch wenn du mich schwer enttäuscht hast.", "Perhaps, after all, I do want to stand behind it, even if you have disappointed me."), gg_snd_Sisgard29)
			call speech(info, character, true, tre("Ist es dir dies mal wenigstens ernst?", "Is it at least serious to you this time?"), gg_snd_Sisgard30)
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Gut, ich gebe dir eine zweite und aller letzte Chance mein Vertrauen zu gewinnen. Es gibt da eine wichtige Sache, die ich noch erledigen müsste.", "Well, I give you a second and final chancee to win my trust. There is an important thing that I would have to do."), gg_snd_Sisgard31)
			call speech(info, character, true, tre("Wie du sicherlich weißt, steht uns ein Krieg gegen die Orks und Dunkelelfen unmittelbar bevor. Ganz Talras spricht von nichts anderem mehr und ich als „angesehene“ Bürgerin möchte natürlich meinen Beitrag zur Verteidigung leisten.", "As you certainly know, a war against the Orcs and Dark Elves is imminent. All Talras speaks of nothing else and I as a \"respected\" citizen would like to make my contribution to the defense."), gg_snd_Sisgard32)
			call speech(info, character, true, tre("Ich habe einen neuen Zauber kreiert, der einen mächtigen magischen Schild erschaffen soll, welcher uns vor Pfeilangriffen schützt. Um ihn auszuprobieren, müsstest du dich allerdings von echten Pfeilen beschießen lassen.", "I've created a new spell to create a powerful magic shield that protects us from arrow attacks. In order to try it out, however, you should be bombarded by real arrows."), gg_snd_Sisgard33)
			call speech(info, character, false, tre("Ist das dein Ernst?", "Are you serious?"), null)
			call speech(info, character, true, tre("Tja, vielleicht hättest du mich nicht belügen sollen …", "Well, maybe you should not have lied to me ..."), gg_snd_Sisgard34)
			call speech(info, character, false, tre("Schon gut, also was genau muss ich tun?", "Alright, so what exactly do I have to do?"), null)
			call speech(info, character, true, tre("Du wirkst zunächst den Zauber, der den magischen Schild erzeugt und dann einen weiteren Zauber, der Pfeile auf dich los lässt und dann wartest du einfach ab was passiert.", "You first have to cast the spell that creates the magic shield and then another spell which shoots the arrows on you and then you just wait for what happens."), gg_snd_Sisgard35)
			call speech(info, character, false, tre("Das hört sich gefährlich an.", "This sounds dangerous."), null)
			call speech(info, character, true, tre("Das ist es auch, deshalb habe ich den Zauber noch nicht ausprobiert. Sei aber nicht so dumm und wirke die Zauber in falscher Reihenfolge. Hier hast du die beiden Zauberspruchrollen.", "It is dangerous, therefore I have not tried the spell yet. But do not be that stupid and cast the spells in the wrong order. Here you have the two magic spells."), gg_snd_Sisgard36)
			call speech(info, character, true, tre("Wenn du diesen Auftrag erfüllst, hast du mein Vertrauen wieder erlangt, aber belüge mich dies mal nicht!", "If you complete this mission, you have regained my trust, but do not lie to me this time!"), gg_snd_Sisgard37)
			call speech(info, character, false, tre("Wenn der Zauber nicht funktioniert dann sehen wir uns wohl kaum wieder.", "If the spell does not work, then we will harly see each other again."), null)
			call speech(info, character, true, tre("Habe etwas mehr Vertrauen in meine Zauberkünste!", "Have more confidence in my magic!"), gg_snd_Sisgard38)
			// Neuer Auftrag „Der magische Schild“
			call QuestTheMagicalShield.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Der magische Schild“ ist abgeschlossen und Auftragsziel 2 ist noch aktiv)
		private static method infoConditionTriedTheShield takes AInfo info, ACharacter character returns boolean
			return QuestTheMagicalShield.characterQuest(character).questItem(0).isCompleted() and QuestTheMagicalShield.characterQuest(character).questItem(1).isNew()
		endmethod

		// Ich habe den magischen Schild ausprobiert.
		private static method infoActionTriedTheShield takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Ich habe den magischen Schild ausprobiert.", "I tried the magic shield."), null)
			call speech(info, character, true, tre("Und du lebst noch, also muss es funktioniert haben!", "And you still live, so it must have worked!"), gg_snd_Sisgard39)
			call speech(info, character, false, tre("Ja, das hat es. Ein Glück für mich!", "Yes, it has. Luck for me!"), null)
			call speech(info, character, true, tre("Mein Meister wäre sicher stolz auf mich, verdanke ich es doch seiner Weisheit diesen Zauber erschaffen zu haben. Wir werden es diesen Orks und Dunkelelfen zeigen, das sage ich dir!", "My master would certainly be proud of me, but I owe it to his wisdom to have created this spell. We'll show it to these Orcs and Dark Elves, I tell you!"), gg_snd_Sisgard40)
			call speech(info, character, false, tre("Und ziehst du jetzt mit mir in den Kampf?", "So are you going into battle with me now?"), null)
			call speech(info, character, true, tre("Selbstverständlich, du hast mein Vertrauen wieder erlangt. Aber glaube ja nicht, dass du mich hättest belügen können!", "Of course, you have regained my confidence. But do not think you could have lied to me!"), gg_snd_Sisgard41)
			call speech(info, character, true, tre("Ich habe die Zauberspruchrollen natürlich präpariert, um zu erfahren, ob du sie richtig gewirkt hast und wie ich sehe hast du mich nicht belogen. Von mir aus können wir jederzeit gemeinsam losziehen.", "I've prepared the spells of course, to find out if you have cast them properly and as I see you have not lied to me. From me, we can go together at any time."), gg_snd_Sisgard42)
			// Auftrag „Der magische Schild“ abgeschlossen
			call QuestTheMagicalShield.characterQuest(character).complete()
			// Belohung übergeben
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00D')
			call character.giveItem('I00E')
			call character.giveItem('I00E')
			call character.giveItem('I00E')
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Zauberkunst“ abgeschlossen oder Auftrag „Der magische Schild“ ist abgeschlossen)
		private static method infoConditionMoreHelp takes AInfo info, ACharacter character returns boolean
			return QuestTheMagic.characterQuest(character).isCompleted() or QuestTheMagicalShield.characterQuest(character).isCompleted()
		endmethod

		// Kann ich dir sonst noch irgendwie helfen?
		private static method infoActionMoreHelp takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kann ich dir sonst noch irgendwie helfen?", "Can I help you?"), null)
			call speech(info, character, true, tre("Hm, ich weiß nicht ob ich dich damit belasten oder dir das überhaupt anvertrauen kann aber …", "Hm, I do not know if I can burden you with it or trust you at all but ..."), gg_snd_Sisgard43)
			call speech(info, character, false, tre("Nun komm schon.", "Now come on."), null)
			call speech(info, character, true, tre("Also … ich weiß nicht so recht.", "So ... I do not really know."), gg_snd_Sisgard44)
			call speech(info, character, false, tre("…", "..."), null)
			call speech(info, character, true, tre("Ich habe dir doch von meinem Meister erzählt und davon wie viel er mir bedeutet hat und ja eigentlich immer noch bedeutet.", "I have told you about my master and how much he has meant to me and actually still means."), gg_snd_Sisgard45)
			call speech(info, character, false, tre("Ja?", "Yes?"), null)
			call speech(info, character, true, tre("Du musst wissen auf unseren Reisen begegneten wir vielen eigenartigen Gestalten. Darunter war auch ein Nekromant, ein Diener Deranors des Schrecklichen. Wir begegneten dem Nekromanten auf unserer Reise vorbei an den Todessümpfen, dort wo Deranors Reich beginnt.", "You must know on our travels we met many peculiar figures. Among them was a necromancer, a servant of Deranor the Terrible. We met the necromancer on our journey past the Death Swamps, where Deranor's kingdom begins."), gg_snd_Sisgard46)
			call speech(info, character, true, tre("Es war ein mächtiger Nekromant, der auch unter Deranor gedient und von ihm gelernt hatte. Da wir ihn vor einer üblen Kreatur beschützten, schenkte er uns aus Dankbarkeit einige wertvolle Artefakte und …", "It was a powerful necromancer who had also served and learned from Deranor. Since we portected him from a bad creature, he gave us some precious artifacts from gratitude and ..."), gg_snd_Sisgard47)
			call speech(info, character, false, tre("Und was?", "And what?"), null)
			call speech(info, character, true, tre("Er brachte uns eine Zauberformel bei, die Geister herbeirufen konnte. Ich weiß nicht, ob er damals in die Zukunft sehen konnte, denn kurze Zeit später kamen wir nach Talras und mein Meister starb schließlich.", "He taught us a magic formula, which could summon spirits. I do not know if he could see the future, because shortly afterwards we came to Talras and my master finally died."), gg_snd_Sisgard48)
			call speech(info, character, false, tre("Du willst also den Geist deines Meisters herbeirufen? Wieso hast du es noch nicht getan?", "So you want to summon the spirit of your master? Why haven't you done it yet?"), null)
			call speech(info, character, true, tre("Ich weiß es nicht. Ehrlich gesagt fürchte ich mich davor. Es ist inzwischen so viel Zeit vergangen und ich fürchte es würde meine guten Erinnerungen an ihn zerstören.", "I don't know. Honestly, I am afraid of it. In the meantime so much time has passed and I fear it would destroy my good memories of him."), gg_snd_Sisgard49)
			call speech(info, character, true, tre("Stell dir nur mal vor was passieren würde, wenn der Zauber nicht funktioniert oder dem Geist meines Meisters Schaden zufügt? Das könnte ich mir nie verzeihen!", "Just imagine what would happen if the spell did not work or harm the spirit of my master?"), gg_snd_Sisgard50)
			call speech(info, character, false, tre("Aber so wirst du ihn nie wieder sehen.", "But you will never see him again."), null)
			call speech(info, character, true, tre("Ich weiß, ach du hast die Erinnerungen in mir wach gerufen. Jetzt kann ich an nichts anderes mehr denken!", "I know, oh you have woken up the memories in me. Now I can think of nothing else."), gg_snd_Sisgard51)
			call speech(info, character, false, tre("Dann probieren wir es doch aus!", "Then we try it out!"), null)
			call speech(info, character, true, tre("Vielleicht hast du Recht. Du hattest auch damit Recht, dass ich wieder los ziehen sollte Abenteuer zu erleben.", "Maybe you are right. You were right, too, that I should go back to adventure."), gg_snd_Sisgard52)
			call speech(info, character, true, tre("Also gut wir probieren es aus, wenn du willst. Mein Meister liegt begraben auf dem kleinen Friedhof unten beim Bauernhof, dort wo alle Leute aus Talras begraben werden, bis auf die Familie des Herzogs.", "So well we try it out if you want. My master is buried in the small cemetery below the farm, where all the people from Talras are buried, except for the duke's family."), gg_snd_Sisgard53)
			call speech(info, character, true, tre("Geh mit mir zum Friedhof und ich werde die Zauberformel ausprobieren.", "Go with me to the cemetery and I will try the magic formula."), gg_snd_Sisgard54)
			call speech(info, character, false, tre("Einverstanden.", "Agreed."), null)
			// Neuer Auftrag „Der Geist des Meisters“
			call QuestTheGhostOfTheMaster.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftragsziel 1 des Auftrags „Der Geist des Meisters“ ist abgeschlossen und Auftrag ist noch aktiv)
		private static method infoConditionMetYourMaster takes AInfo info, ACharacter character returns boolean
			return QuestTheGhostOfTheMaster.characterQuest(character).questItem(0).isCompleted() and QuestTheGhostOfTheMaster.characterQuest(character).questItem(1).isNew()
		endmethod

		// Du hast deinen Meister wieder getroffen!
		private static method infoActionMetYourMaster takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Du hast deinen Meister wieder getroffen!", "You met your master again!"), null)
			call speech(info, character, true, tre("Ja, das habe ich! Ich kann dir gar nicht sagen wie sehr ich nun in deiner Schuld stehe Fremder.", "Yes I have! I cannot tell you how much I am now in your debt stranger."), gg_snd_Sisgard55)
			call speech(info, character, true, tre("Ich schenke dir zum Dank dieses mächtige Artefakt, das uns der Nekromant damals überreichte. Es soll von nun an dir gehören.", "I give you this powerful artefact that the necromancer gave us for thanking you. It shall be yours from now on."), gg_snd_Sisgard56)
			call speech(info, character, true, tre("Du hast mir Erlösung gebracht und dafür danke ich dir auf ewig!", "You have brought me salvation and I thank you forever!"), gg_snd_Sisgard57)
			// Auftrag „Der Geist des Meisters“ abgeschlossen
			call QuestTheGhostOfTheMaster.characterQuest(character).complete()
			// Belohungsgegenstände
			call character.giveItem('I045')
			call character.giveItem('I045')
			call character.giveItem('I0FF')
			call character.giveItem('I0FF')
			call character.giveItem('I00G')
			call character.giveItem('I00G')
			// Artefakt übergeben
			call character.giveItem('I044')
			call character.displayItemAcquired(GetObjectName('I044'), tre("Gewährt einen Rüstungs- und einen Wissensbonus sowie die Fähigkeit einem Gegner Leben zu entziehen und auf den Träger zu übertragen.", "Grants an armour and a lore bonus as well as the ability to drain life from an opponent and to transfer it to the carrying unit."))
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Zauberkunst“ abgeschlossen oder Auftrag „Der magische Schild“ ist abgeschlossen)
		private static method infoConditionLetsGo takes AInfo info, ACharacter character returns boolean
			debug if (Fellows.sisgard().isShared()) then
				debug call Print("Is shared.")
			debug endif
			return (QuestTheMagic.characterQuest(character).isCompleted() or QuestTheMagicalShield.characterQuest(character).isCompleted()) and not Fellows.sisgard().isShared()
		endmethod

		// Gehen wir.
		private static method infoActionLetsGo takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Gehen wir.", "Let's go."), null)
			// (Unterhält sich noch mit anderen Charakteren)
			if (info.talk().characters().size() > 1) then
				call speech(info, character, true, tre("Ich unterhalte mich gerade noch. Danach kann ich dir folgen.", "I'm just talking. Then I can follow you."), null) // TODO missing sound
				call info.talk().showStartPage(character)
			// (Unterhält sich nur mit dem aktuellen Charakter)
			else
				call speech(info, character, true, tre("Na wenn du mich so nett bittest. Kann's gar nicht erwarten. Gehe voraus, ich folge dir.", "Well, if you ask me so kindly. I cannot wait for it. GO ahead, I'll follow you."), gg_snd_Sisgard58)
				call info.talk().close(character)
				call Fellows.sisgard().shareWith(character)
				call IssueTargetOrder(info.talk().unit(), "move", character.unit())
			endif
		endmethod

		// (Folgt dem Charakter)
		private static method infoConditionOnMyOwn takes AInfo info, ACharacter character returns boolean
			return Fellows.sisgard().isShared() and Fellows.sisgard().character() == character
		endmethod

		// Ich komm alleine klar.
		private static method infoActionOnMyOwn takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich komm alleine klar.", "I'm clear on my own."), null)
			call speech(info, character, true, tre("Gut, du weißt ja, wo du mich findest.", "Well, you know where to find me."), gg_snd_Sisgard59)
			call info.talk().close(character)
			call Fellows.sisgard().reset()
		endmethod

		// (Folgt einem Charakter und wird von einem anderen angesprochen)
		private static method infoConditionBusy takes AInfo info, ACharacter character returns boolean
			return Fellows.sisgard().isShared() and Fellows.sisgard().character() != character
		endmethod

		// Ich habe zu tun.
		private static method infoActionBusy takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("Ich habe zu tun.", "I'm busy."), gg_snd_Sisgard60)
			call info.talk().close(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(Npcs.sisgard(), thistype.startPageAction)
			call this.setName(tre("Sisgard", "Sisgard"))

			set thistype.m_hi = this.addInfo(false, false, 0, thistype.infoActionHi, tre("Hallo.", "Hello."))
			set thistype.m_hi_whyNot = this.addInfo(false, false, 0, thistype.infoActionHi_WhyNot, tre("Wieso nicht?", "Why not?"))
			set thistype.m_hi_no = this.addInfo(false, false, 0, thistype.infoActionHi_No, tre("Nein.", "No."))
			set thistype.m_yourHouse = this.addInfo(false, false, thistype.infoConditionGreeting, thistype.infoActionYourHouse, tre("Ist das dein Haus?", "Is this your house?"))
			set thistype.m_whatDoYouSell = this.addInfo(true, false, thistype.infoConditionGreeting, thistype.infoActionWhatDoYouSell, tre("Was genau verkaufst du?", "What exactly do you sell?"))
			set thistype.m_aboutYourMaster = this.addInfo(true, false, thistype.infoConditionAboutYourMaster, thistype.infoActionAboutYourMaster, tre("Erzähl mir mehr von deinem Meister.", "Tell me about your master."))
			set thistype.m_youAreAWizard = this.addInfo(false, false, thistype.infoConditionGreeting, thistype.infoActionYouAreAWizard, tre("Du bist wohl eine Zauberin?", "You're probably a sorceress?"))
			set thistype.m_comeWithMe = this.addInfo(false, false, thistype.infoConditionComeWithMe, thistype.infoActionComeWithMe, tre("Zieh mit mir in den Kampf!", "Go into battle with me!"))
			set thistype.m_beenAtTheRunes = this.addInfo(false, false, thistype.infoConditionBeenAtTheRunes, thistype.infoActionBeenAtTheRunes, tre("Ich war bei den Runensteinen.", "I was at the rune stones."))
			set thistype.m_beenAtTheRunes_magic = this.addInfo(false, false, 0, thistype.infoActionBeenAtTheRunes_Magic, tre("Ich spürte, wie die magischen Kräfte mich durchflossen.", "I could feel the magical powers running through me."))
			set thistype.m_beenAtTheRunes_nothing = this.addInfo(false, false, 0, thistype.infoActionBeenAtTheRunes_Nothing, tre("Gar nichts.", "Nothing at all."))
			set thistype.m_makeGood = this.addInfo(false, false, thistype.infoConditionMakeGood, thistype.infoActionMakeGood, tre("Kann ich es wieder gut machen?", "Can I make up for it?"))
			set thistype.m_triedTheShield = this.addInfo(false, false, thistype.infoConditionTriedTheShield, thistype.infoActionTriedTheShield, tre("Ich habe den magischen Schild ausprobiert.", "I tried the magic shield."))
			set thistype.m_moreHelp = this.addInfo(false, false, thistype.infoConditionMoreHelp, thistype.infoActionMoreHelp, tre("Kann ich dir sonst noch irgendwie helfen?", "Can I help you?"))
			set thistype.m_metYourMaster = this.addInfo(false, false, thistype.infoConditionMetYourMaster, thistype.infoActionMetYourMaster, tre("Du hast deinen Meister wieder getroffen!", "You met your master again!"))
			set thistype.m_letsGo = this.addInfo(true, false, thistype.infoConditionLetsGo, thistype.infoActionLetsGo, tre("Gehen wir.", "Let's go."))
			set thistype.m_onMyOwn = this.addInfo(true, false, thistype.infoConditionOnMyOwn, thistype.infoActionOnMyOwn, tre("Ich komm alleine klar.", "I'm clear on my own."))
			set thistype.m_busy = this.addInfo(true, true, thistype.infoConditionBusy, thistype.infoActionBusy, null)
			set thistype.m_exit = this.addExitButton()

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
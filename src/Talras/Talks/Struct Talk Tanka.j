library StructMapTalksTalkTanka requires Asl, StructMapTalksTalkBrogo, StructMapQuestsQuestShamansInTalras

	struct TalkTanka extends Talk
		private static constant integer rewardGold = 30
		private integer array m_hints[12] /// @todo @member MapSettings.maxPlayers(), vJass bug

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
			call speech(info, character, false, tre("Hallo.", "Hello."), null)
			call speech(info, character, true, tre("Hallo. Scheint ja einiges los zu sein in dieser Gegend. Du bist nicht der Erste, der mir begegnet. Wie ich es geahnt habe, tut sich so einiges, wenn die Leute Angst bekommen.", "Hello. Seems to be a lot going on in this area. You are not the first to meet me. As I've guessed, there's a lot going on when people get scared."), gg_snd_Tanka1)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Hallo.“)
		private static method infoCondition1 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character)
		endmethod

		// Wer bist du?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wer bist du?", "Who are you?"), null)
			call speech(info, character, true, tre("Mein Name ist Tanka. Ich bin eine Schamanin und versuche ja nicht mich übers Ohr zu hauen, sonst haut mein Gefährte Brogo dich um.", "My name is Tanka. I'm a shaman, and do not try to hurt myself, or my fellow Brogo will kill you."), gg_snd_Tanka2)
			// (Charakter hat noch nicht mit Brogo gesprochen)
			if (not TalkBrogo.talk().characterHasTalkedTo(character)) then
				call speech(info, character, false, tre("Wer ist Brogo?", "Who is Brogo?"), null)
				call speech(info, character, true, tre("Na der große Bärenmensch da neben mir. Er ist mein treuer Gefährte und beschützt mich vor den größten Gefahren dieser Gegend.", "Well ,the big bear man beside me. He is my faithful companion and protects me from the greatest dangers of this region."), gg_snd_Tanka3)
			// (Charakter hat bereits mit Brogo gesprochen)
			else
				call speech(info, character, false, tre("Schon klar.", "Alright."), null)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“)
		private static method infoCondition2 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Und was machst du hier?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Und was machst du hier?", "And what are you doing here?"), null)
			call speech(info, character, true, tre("Die Frage sollte wohl eher lauten „Und was macht ihr hier?“. Wir jagen eine starke Bestie. Dieses Ungeheuer hat Brogos Stamm angegriffen und diesen so gut wie ausgerottet. Nur Brogo hier hat überlebt.", "The question should rather be \"And what are you both doing here?\". We hut a strong beast. This monster attacked Brogo's tribe and exterminated it. Only Brogo here has survived."), gg_snd_Tanka4)
			call speech(info, character, true, tre("Ich habe ihn gefunden und mich um seine Verletzungen gekümmert und nun jagen wir gemeinsam die Bestie.", "I found him and took care of his injuries, and now we hunt together the beast."), gg_snd_Tanka5)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“, Auftrag „Die Bestie“ ist noch nicht abgeschlossen)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character) and not QuestTheBeast.characterQuest(character).isCompleted()
		endmethod

		// Kannst du mir was beibringen?
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kannst du mir was beibringen?", "Can you teach me something?"), null)
			call speech(info, character, true, tre("Können schon, aber wollen nicht unbedingt, sonst setzt du das Erlernte am Ende noch gegen mich ein und das fände ich nicht so toll.", "Sure I can but do not necessarily want to, otherwise you put the learned in the end against me and I wouldn't really like that."), gg_snd_Tanka6)
			call speech(info, character, true, tre("Sobald ich der Meinung bin, dass du in Ordnung bist, bringe ich dir vielleicht etwas Nützliches bei.", "As soon as I feel that you're alright, I'll teach you something useful."), gg_snd_Tanka7)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Wer bist du?“)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Handelst du auch mit irgendwas?
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Handelst du auch mit irgendwas?", "Do you trade with anything?"), null)
			call speech(info, character, true, tre("Allerdings. Als Schamanin kann man seine Freizeit ganz gut nutzen, um diverse Zaubergegenstände und Tränke herzustellen, wenn man das nötige Wissen und die benötigten Zutaten hat.", "Indeed. As a shaman you can use your leisure time to create various magic objects and potions, if you have the necessary knowledge and the necessary ingredients."), gg_snd_Tanka8)
			call speech(info, character, true, tre("Also wenn du verrückte Sachen mit deinen Gegnern anstellen willst, bist du bei mir genau richtig. Aber ich warne dich Fremder: Mit diesen einfachen Zaubertricks wirst du nichts gegen mich ausrichten können!", "So if you want to do crazy things with your opponents, you are exactly right with me. BUt I warn you stranger. With these simple magic tricks, you will not be able to do anything against me!"), gg_snd_Tanka9)
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Und was machst du hier?“)
		private static method infoCondition5 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(1, character)
		endmethod

		// Was für ein Ungeheuer war das?
		private static method infoAction5 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Was für ein Ungeheuer war das?", "What kind of monster was that?"), null)
			call speech(info, character, true, tre("Na, ein ziemlich großes eben. Diese Bestie ist verdammt blutrünstig und verdammt stark. Du musst wissen, dass Brogos Stamm nicht gerade klein war. Dieses Untier hat bestimmt zwanzig oder mehr Bärenmenschen getötet und da waren auch voll ausgewachsene dabei.", "Well, a pretty big one. This beast is damned bloodthirsty and damn strong. You must know that Brogo's tribe was not exactly small. This monster had killed twenty or more bear men, and there were also grown-ups."), gg_snd_Tanka10)
			call speech(info, character, true, tre("Brogo ist ja noch recht jung, so ein ausgewachsener Bärenmensch ist wesentlich größer und stärker, also kannst du dir ausrechnen, wie stark die Bestie ist.", "Brogo is still very young, a grown bear man is much bigger and stronger, so you can calculate how strong the beast is."), gg_snd_Tanka11)
			call speech(info, character, true, tre("Wir folgten der Fährte dieser Bestie bis hier her. Aber hier sind die Spuren zu undeutlich und Brogo konnte die Fährte nicht wieder aufnehmen. Vermutlich hat es zu lange gedauert, bis wir uns auf die Suche nach ihr machten.", "We followed the trail of this beast to here. But here the tracks are too vague and Brogo could not resume the track. It probably took too long for us to look for it."), gg_snd_Tanka12)
			call speech(info, character, true, tre("Brogo war ja auch schwer verwundet. Na ja, wenn du irgendeinen Hinweis in der Umgebung findest, dann gib mir einfach Bescheid.", "Brogo was also seriously wounded. Well, if you find any hint in the area, just let me know."), gg_snd_Tanka13)
			call QuestTheBeast.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		private static method completeHints takes AInfo info, Character character returns nothing
			call speech(info, character, true, tre("Ich denke, dass reicht schon mit den Hinweisen. Wir werden uns wohl bald möglichst in Richtung Süden aufmachen, um die Bestie zu jagen. Hier hast du ein paar Flammengemische zur Belohnung. Ich hoffe, sie werden sich dir im Kampf als nützlich erweisen und hier sind natürlich noch ein paar Goldmünzen.", "I think that is enough with the hints. We'll probably heading south as soon as possible to hunt the beast. Here you have a few flames to reward. I hope they will be useful to you in the fight and here are of course a few gold coins."), gg_snd_Tanka16)
			/// Charakter erhält 6 Flammengemische
			call character.giveItem('I01F')
			call character.giveItem('I01F')
			call character.giveItem('I01F')
			call character.giveItem('I01F')
			call character.giveItem('I01F')
			call character.giveItem('I01F')
			call QuestTheBeast.characterQuest(character).complete()
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Bestie“ aktiv, Charakter war bei den Blutspuren)
		private static method infoCondition6 takes AInfo info, ACharacter character returns boolean
			return QuestTheBeast.characterQuest(character).isNew() and QuestTheBeast.characterQuest(character).foundTracks()
		endmethod

		// Ich habe einen Hinweis entdeckt.
		private static method infoAction6 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich habe einen Hinweis entdeckt.", "I've discovered a clue."), null)
			call speech(info, character, true, tre("Welchen denn?", "Which one?"), gg_snd_Tanka14)
			call speech(info, character, false, tre("Weiter südlich von hier sind einige Blutspuren und tote Tiere. Könnte die Bestie gewesen sein.", "Further south from here are some blood trails and dead animals. Could have been the beast."), null)
			call speech(info, character, true, tre("Ja, das wäre gut möglich. Ich danke dir. Hier hast du ein paar Goldmünzen zur Belohnung.", "Yes, that would be possible. I thank you. Here you have a few gold coins to reward."), gg_snd_Tanka15)
			call character.addGold(thistype.rewardGold)
			call character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tre("%i Goldmünzen erhalten.", "Got %i gold coins."), thistype.rewardGold))
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
			call speech(info, character, false, tre("Der Holzfäller Kuno hat die Bestie gesehen.", "THe woodcutter Kuno saw the beast."), null)
			call speech(info, character, true, tre("Und wo?", "And where?"), gg_snd_Tanka17)
			call speech(info, character, false, tre("Weiter südlich. Vor ein paar Tagen ist sie an seiner Hütte vorbeigekommen während er im Bett lag.", "Further south. A few days ago, it passed his hut while he was lying in bed."), null)
			call speech(info, character, true, tre("Und er ist sich sicher, dass es die Bestie war?", "And he is sure that it was the beast?"), gg_snd_Tanka18)
			call speech(info, character, false, tre("Na ja, er sprach von einem riesigen, haarigen Viech, welches nach Tod und Verderben stank.", "Well, he was talking about a huge, hairy creature stinking of death and destruction."), null)
			call speech(info, character, true, tre("Das kann nur die Bestie gewesen sein. Hier hast du ein paar Goldmünzen zur Belohnung.", "This can only have been the beast. Here you have a few gold coins to reward."), gg_snd_Tanka19)
			call character.addGold(thistype.rewardGold)
			call character.displayMessage(ACharacter.messageTypeInfo, IntegerArg(tre("%i Goldmünzen erhalten.", "Got %i gold coins."), thistype.rewardGold))
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
			call speech(info, character, false, tre("Bring mir was bei!", "Teach me something!"), null)
			call speech(info, character, true, tre("Du hast die Spur der Bestie gefunden.", "You've found the trail of the beast!"), gg_snd_Tanka21)
			// (Auftrag „Katzen für Brogo“ ist abgeschlossen)
			if (QuestCatsForBrogo.characterQuest(character).isCompleted()) then
				call speech(info, character, true, tre("Außerdem hast du Brogo Katzen geschenkt.", "Besides, you gave Brogo cats."), gg_snd_Tanka22)
				call speech(info, character, true, tre("Du bist ein wahrer Freund und ich werde dich alles lehren, was ich weiß. Dennoch verlange ich ein paar Goldmünzen dafür. Ich muss schließlich auch von etwas leben, also nimm's bitte nicht persönlich.", "You are a true friend and I will teach you everything I know. Nevertheless, I demand a few gold coins for it. I have to live by something, so do not take it personally."), gg_snd_Tanka23)
			// (Auftrag „Katzen für Brogo“ ist nicht abgeschlossen)
			else
				call speech(info, character, true, tre("Das reicht mir als Beweis, dass du in Ordnung bist. Gut, ich werde dir ein paar Sachen beibringen. Aber die wirklich nützlichen Dinge erfährst du erst, wenn ich dir wie einem guten Freund vertraue. Das Ganze kostet dich allerdings auch eine Kleinigkeit.", "That's enough for me to prove you're alright. Well, I'll teach you a few things. But you will not find the really useful things until I trust you as a good friend. The whole thing does also cost you something."), gg_snd_Tanka24)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Nach „Bring mir was bei!“)
		private static method infoCondition9 takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(8, character)
		endmethod

		// Zeig mir wie man …
		private static method infoAction9 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Zeig mir wie man …", "Show me how to ..."), null)
			call info.talk().showRange(13, 17, character)
		endmethod

		// (Nach „Hallo“ und Charakter hat mit Tellborn gesprochen und Auftrag „Schamanen in Talras“ noch nicht erhalten)
		private static method infoConditionYouKnowTellborn takes AInfo info, ACharacter character returns boolean
			return info.talk().infoHasBeenShownToCharacter(0, character) and TalkTellborn.talk.evaluate().infoHasBeenShownToCharacter(0, character) and QuestShamansInTalras.characterQuest(character).isNotUsed()
		endmethod

		// Kennst du Tellborn?
		private static method infoActionYouKnowTellborn takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kennst du Tellborn?", "Do you know Tellborn?"), null)
			call speech(info, character, true, tre("Wen?", "Whom?"), gg_snd_Tanka29)
			call speech(info, character, false, tre("Tellborn, einen Schamanen, der sich weiter südlich von hier aufhält.", "Tellborn, a shaman who is further south from here."), null)
			call speech(info, character, true, tre("Ich bin ja nicht gerade lange in dieser Gegend, daher kenne ich auch niemanden hier.", "I'm not very long in this area, so I know no one here."), gg_snd_Tanka30)
			call speech(info, character, true, tre("Aber sag, ist er wirklich ein Schamane oder behauptet er das nur von sich?", "But say, is he really a shaman or does he just claim that of himself?"), gg_snd_Tanka31)
			call speech(info, character, false, tre("Also …", "Well ..."), null)
			call speech(info, character, true, tre("Es ist immer wieder ein Ereignis seinesgleichen in den entlegensten Teilen dieser Welt anzutreffen. Vielleicht sollte ich mich einmal mit ihm unterhalten.", "There is always an event to meet one of her kind in the most remote parts of this world. Maybe I should talk to him once."), gg_snd_Tanka32)
			call speech(info, character, true, tre("Leider kann ich Brogo hier nicht einfach sitzen lassen. Willst du vielleicht diesem „Tellborn“ ein Schreiben von mir überbringen?", "Unfortunately, I cannot let Brogo sit here. Would you like to bring this \"Tellborn\" a letter from me?"), gg_snd_Tanka33)

			call info.talk().showRange(18, 19, character)
		endmethod

		// (Charakter hat „Brief an Tanka“ dabei)
		private static method infoConditionLetterFromTellborn  takes AInfo info, ACharacter character returns boolean
			return character.inventory().hasItemType('I03K')
		endmethod

		// Hier ist ein Brief von Tellborn.
		private static method infoActionLetterFromTellborn takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Hier ist ein Brief von Tellborn.", "Here is a letter from Tellborn."), null)
			// (Charakter hat zuvor das Schreiben für Tellborn an diesen geliefert)
			if (QuestShamansInTalras.characterQuest(character).questItem(1).isCompleted()) then
				call speech(info, character, true, tre("Er hat sich also die Mühe gemacht zu antworten. Immerhin! Nun gib schon her, ich will wissen, was er schreibt.", "So he took the trouble to answer. After all! Now, give it to me, I want to know what he is writing."), gg_snd_Tanka37)
				call speech(info, character, false, tre("Hier hast du den Brief.", "Here you have the letter."), null)
				// „Brief an Tanka“ übergeben
				call character.inventory().removeItemType('I03K')
				call speech(info, character, true, tre("Vielen Dank! Zu gerne will ich wissen, was hinter ihm steckt. Hier nimm dies als Belohnung.", "Many thanks! I want to know what is behind him. Take this as a reward."), gg_snd_Tanka38)
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
				call speech(info, character, true, tre("Von wem?", "From whom?"), gg_snd_Tanka39)
				call speech(info, character, false, tre("Von Tellborn, einem Schamanen südlich von hier. Ich habe ihm von dir erzählt, da ihr offensichtlich beide Schamanen seid.", "From Tellborn, a shaman south of here. I told him about you, as you are obviously both shamans."), null)
				call speech(info, character, true, tre("Wie bitte? Wie konntest du … was schreibt er denn?", "I beg your pardon? How could you ... what does he write?"), gg_snd_Tanka40)
				call speech(info, character, false, tre("Hier, lies selbst.", "Here, read yourself."), null)
				// „Brief an Tanka“ übergeben
				call character.inventory().removeItemType('I03K')
				call speech(info, character, true, tre("(Liest) Aha, unglaublich! Ich muss ihm sofort antworten. Lauf ja nicht weg!", "(Reads) Ah, incredible! I must answer him immediately. Do not run away!"), gg_snd_Tanka41)
				call speech(info, character, false, tre("Schon gut.", "All right."), null)
				call speech(info, character, true, tre("(Verfasst ein Schreiben)", "(Writes a letter)"), null)
				call speech(info, character, true, tre("So, da hast du ein Schreiben für ihn. Bring es ihm so schnell wie möglich!", "So, there you have a letter for him. Bring it to him as soon as possible!"), gg_snd_Tanka42)
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
		private static method infoAction8_0 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("… seine Waffen vergiftet.", "... poison his weapons."), null)
			/// Charakter erhält Gegenstand „Angriffs-Totem“
			call character.giveItem('I085')
			call speech(info, character, true, tre("Sieh zu und lerne!", "Watch and learn!"), gg_snd_Tanka25)
			call info.talk().showStartPage(character)
		endmethod

		// … seinen Körper entflammt.
		private static method infoAction8_1 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("… seinen Körper entflammt.", "... inflame his body."), null)
			/// Charakter erhält Gegenstand „Verteidigungs-Totem“
			call character.giveItem('I086')
			call speech(info, character, true, tre("Sieh zu und lerne!", "Watch and learn!"), gg_snd_Tanka25)
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Die Bestie“ und Auftrag „Katzen für Brogo“ sind abgeschlossen)
		private static method infoCondition8_2and3 takes AInfo info, ACharacter character returns boolean
			return QuestTheBeast.characterQuest(character).isCompleted() and QuestCatsForBrogo.characterQuest(character).isCompleted()
		endmethod

		// … seinen Schmerz teilt.
		private static method infoAction8_2 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("… seinen Schmerz teilt.", "... share his pain."), null)
			/// Charakter erhält Gegenstand „Geistes-Totem“
			call character.giveItem('I087')
			call speech(info, character, true, tre("Sieh zu und lerne!", "Watch and learn!"), gg_snd_Tanka25)
			call info.talk().showStartPage(character)
		endmethod

		// … seinen Körper vervielfacht.
		private static method infoAction8_3 takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("… seinen Körper vervielfacht.", "... multiply his body."), null)
			/// Charakter erhält Gegenstand „Körper-Totem“
			call character.giveItem('I088')
			call speech(info, character, true, tre("Sieh zu und lerne!", "Watch and learn!"), gg_snd_Tanka25)
			call info.talk().showStartPage(character)
		endmethod

		// Klar.
		private static method infoActionYouKnowTellborn_Sure  takes AInfo info, Character character returns nothing
			call speech(info, character, false, tre("Klar.", "Sure."), null)
			call speech(info, character, true, tre("Ich danke dir! Warte kurz bis ich das Schreiben aufgesetzt habe.", "I thank you! Wait a moment until I wrote the letter."), gg_snd_Tanka34)
			call speech(info, character, true, tre("(Setzt ein Schreiben auf)", "(Sets a letter)"), null)
			call speech(info, character, true, tre("So, hier hast du es. Mal sehen, was er dazu sagt …", "So, here you have it. Let's see what he says about it ..."), gg_snd_Tanka35)
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
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Schade, überlege es dir doch noch einmal.", "Too bad, think about it again."), gg_snd_Tanka36)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n023_0011, thistype.startPageAction)
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				set this.m_hints[i] = 0
				set i = i + 1
			endloop
			// start page
			call this.addInfo(false, false, 0, thistype.infoAction0, tre("Hallo.", "Hello.")) // 0
			call this.addInfo(false, false, thistype.infoCondition1, thistype.infoAction1, tre("Wer bist du?", "Who are you?")) // 1
			call this.addInfo(false, false, thistype.infoCondition2, thistype.infoAction2, tre("Und was machst du hier?", "And what are you doing here?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Kannst du mir was beibringen?", "Can you teach me something?")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Handelst du auch mit irgendwas?", "Do you trade with anything?")) // 4
			call this.addInfo(false, false, thistype.infoCondition5, thistype.infoAction5, tre("Was für ein Ungeheuer war das?", "What kind of monster was that?")) // 5
			call this.addInfo(false, false, thistype.infoCondition6, thistype.infoAction6, tre("Ich habe einen Hinweis entdeckt.", "I've discovered a clue.")) // 6
			call this.addInfo(false, false, thistype.infoCondition7, thistype.infoAction7, tre("Der Holzfäller Kuno hat die Bestie gesehen.", "THe woodcutter Kuno saw the beast.")) // 7
			call this.addInfo(false, false, thistype.infoCondition8, thistype.infoAction8, tre("Bring mir was bei!", "Teach me something!")) // 8
			call this.addInfo(true, false, thistype.infoCondition9, thistype.infoAction9, tre("Zeig mir wie man …", "Show me how to ...")) // 9
			call this.addInfo(true, false, thistype.infoConditionYouKnowTellborn, thistype.infoActionYouKnowTellborn, tre("Kennst du Tellborn?", "Do you know Tellborn?")) // 10
			call this.addInfo(false, false, thistype.infoConditionLetterFromTellborn, thistype.infoActionLetterFromTellborn, tre("Hier ist ein Brief von Tellborn.", "Here is a letter from Tellborn.")) // 11
			call this.addExitButton() // 12

			// info 8
			call this.addInfo(true, false, thistype.infoCondition8_0and1, thistype.infoAction8_0, tre("… seine Waffen vergiftet.", "... poison his weapons.")) // 13
			call this.addInfo(true, false, thistype.infoCondition8_0and1, thistype.infoAction8_1, tre("… seinen Körper entflammt.", "... inflame his body.")) // 14
			call this.addInfo(true, false, thistype.infoCondition8_2and3, thistype.infoAction8_2, tre("… seinen Schmerz teilt.", "... share his pain.")) // 15
			call this.addInfo(true, false, thistype.infoCondition8_2and3, thistype.infoAction8_3, tre("… seinen Körper vervielfacht.", "... multiply his body.")) // 16
			call this.addBackToStartPageButton() // 17

			// info 10
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTellborn_Sure, tre("Klar.", "Sure.")) // 18
			call this.addInfo(true, false, 0, thistype.infoActionYouKnowTellborn_No, tre("Nein.", "No.")) // 19

			return this
		endmethod

		implement Talk
	endstruct

endlibrary
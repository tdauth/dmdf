library StructMapTalksTalkWieland requires Asl, StructGameClasses, StructMapQuestsQuestTheKingsCrown, StructMapQuestsQuestWielandsSword

	struct TalkWieland extends Talk

		implement Talk

		private method startPageAction takes ACharacter character returns nothing
			if  (not this.showInfo(0, character)) then
				call this.showRange(1, 5, character)
			endif
		endmethod

		private static method infoAction0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("He du! Bist du ein tapferer Krieger?", "Hey you! Are you a brave warrior?"), gg_snd_Wieland1)
			call info.talk().showRange(6, 7, character)
		endmethod

		// Kannst du mir das Schmieden beibringen?
		private static method infoAction1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Kannst du mir das Schmieden beibringen?", "Can you teach me how to forge?"), null)
			call speech(info, character, true, tre("Sonst noch was? Weißt du, wie lange es dauert, jemandem das beizubringen? Mein Sohn übernimmt das hier mal und da kann er keine Konkurrenz gebrauchen.", "Is there anything else? Do you know how long it takes someone to teach it? My son takes this over some day and then there is no use in competetion."), gg_snd_Wieland17)
			call speech(info, character, true, tre("Allerdings kann ich dir ein Buch mit Anleitungen verkaufen. Vielleicht bringst du es dir ja selbst bei (lacht höhnisch)!", "However, I can sell you a book with instructions. Perhaps you learn it yourself (laughs mockingly)!"), gg_snd_Wieland18)
			call info.talk().showStartPage(character)
		endmethod

		// Verkaufst du auch Waffen?
		private static method infoAction2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Verkaufst du auch Waffen?", "Do you sell weapons as well?"), null)
			call speech(info, character, true, tre("Nein, ich stelle sie nur her. Einar verkauft welche am Tor zur Innenburg. Ich glaube, Agihard verkauft auch welche. Den findest du bei seiner Arena im Norden der Burg.", "No, I only carft them. Einar sells some at the gate to the inner castle. I think, Agihard sells some as well. You find him at his arena in the north of the castle."), gg_snd_Wieland19)
			call speech(info, character, true, tre("Allerdings verkaufe ich wertvolle, selbst angefertigte Rüstungen und Helme.", "However, I sell valuable, self-made armours and helmets."), gg_snd_Wieland20)
			if (Classes.isMage(character) or Classes.isChaplain(character)) then // (Charakter ist Geistlicher oder Magier)
				call speech(info, character, true, tre("Vermutlich nichts für dich.", "Probably not for you."), gg_snd_Wieland21)
			elseif (character.class() == Classes.knight()) then // (Charakter ist Ritter)
				call speech(info, character, true, tre("Genau das Richtige für einen tapferen Rittersmann wie dich.", "Just the right thing for a brave knight man like you."), gg_snd_Wieland22)
			elseif (character.class() == Classes.ranger()) then // (Charakter ist Waldläufer)
				call speech(info, character, true, tre("Vermutlich zu schwer für dich.", "Probably too heavy for you."), gg_snd_Wieland23)
			else // (Charakter ist Drachentöter)
				call speech(info, character, true, tre("Nichts für einen dahergelaufenen Burschen.", "Not for a guy running up."), gg_snd_Wieland24)
			endif
			call info.talk().showStartPage(character)
		endmethod

		// (Auftrag „Des Königs Krone“ ist aktiv und Auftragsziel 1 ist abgeschlossen)
		private static method infoCondition3 takes AInfo info, ACharacter character returns boolean
			return QuestTheKingsCrown.characterQuest(character).isNew() and QuestTheKingsCrown.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Hier ist die Krone.
		private static method infoAction3 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Hier ist die Krone.", "Here is the crown."), null)
			call speech(info, character, true, tre("Gib her!", "Give it to me!"), gg_snd_Wieland25)
			call character.inventory().removeItemType(QuestTheKingsCrown.crownItemTypeId) // Krone geben
			call speech(info, character, true, tre("Tatsächlich! Das ist die Krone aus den Sagen. Sprich, was hast du mit dem König angestellt?", "Fact! This is the crown of the legends. Tell me, what have you done with the king?"), gg_snd_Wieland26)
			call speech(info, character, false, tre("Rate mal.", "Guess what."), null)
			call speech(info, character, true, tre("So so, dann ist er also tot? Na ja, vielleicht findet er so seinen Frieden, kann mir eigentlich egal sein. Ich danke dir, das ist mir wirklich einige Goldmünzen wert!", "So, he's dead? Well, maybe he finds his peace then, actually I don't have to care. Thank you, that's really worth a few gold coins to me!"), gg_snd_Wieland27)
			call QuestTheKingsCrown.characterQuest(character).questItem(1).complete()
			call speech(info, character, true, tre("Sag, kannst du mir noch einen Gefallen tun?", "Tell me, can you do me a favor?"), gg_snd_Wieland28)
			call info.talk().showRange(8, 9, character)
		endmethod

		// (Auftrag „Wielands Schwert“ ist aktiv und Auftragsziel 1 ist abgeschlossen)
		private static method infoCondition4 takes AInfo info, ACharacter character returns boolean
			return QuestWielandsSword.characterQuest(character).isNew() and QuestWielandsSword.characterQuest(character).questItem(0).isCompleted()
		endmethod

		// Ich habe mit Einar gesprochen.
		private static method infoAction4 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ich habe mit Einar gesprochen.", "I talked to Einar."), null)
			call speech(info, character, true, tre("Gut, wie viel verlangt er?", "Well, how much does he want?"), gg_snd_Wieland34)
			call speech(info, character, false, tre("2000 Goldmünzen.", "2000 gold coins."), null)
			call speech(info, character, true, tre("Was? Verdammter Hundesohn! Bist du dir sicher?", "What? Damn son of a bitch! Are you sure?"), gg_snd_Wieland35)
			call speech(info, character, false, tre("Ja.", "Yes."), null)
			call speech(info, character, true, tre("Dieser Halsabschneider! Nächstes Mal kann er mir 2000 Goldmünzen bezahlen, damit ich ihn nicht umhaue! Danke, die Sache war mir sehr wichtig. Pass auf, ich gebe dir eine gute Waffe, weil du mir geholfen hast, schon zweimal.", "THis cut-throat! Next time he can pay me 2000 gold coins, so that I do not beat him down! Thank you, this matter was very important to me. Look, I'll give you a good weapon, because you have helped me twice already."), gg_snd_Wieland36)
			call speech(info, character, true, tre("Achte gut darauf, es ist ein sehr gutes Schwert und pass auf dich auf, aber ich glaube, dass wohl eher deine Feinde auf sich aufpassen sollten.", "Take good care of it, it is a very good sword and take care of yourself, but I think probably your enemies should take care of themselves."), gg_snd_Wieland37)
			call QuestWielandsSword.characterQuest(character).questItem(1).complete()
			call info.talk().showStartPage(character)
		endmethod

		private static method info0_0Talk takes AInfo info, ACharacter character returns nothing
			call speech(info, character, true, tre("Also erst mal hallo, ich bin Wieland, der Schmied von Talras. Wenn du irgendwas geschmiedet haben willst, bin ich dein Mann.", "So, first of all hello, I am Wieland, the smith of Talras. If you want to have something forged, I'm your man."), gg_snd_Wieland4)
			call speech(info, character, true, tre("Nun zu meinem Problem: Mein Sohn Wieland ist gerade irgendwo im Norden bei einem Ritter und dient diesem als Krieger. Wenn er zurückkommt, dann will ich, dass er für mich arbeitet.", "Now to my problem: My son Wieland is just somewhere in the north with a knight and serves him as a warrior. When he comes back, I want him to work for me."), gg_snd_Wieland5)
			call speech(info, character, true, tre("Leider hat's ihm die Schmiedekunst nicht so angetan, wie ich mir das erhofft hatte. Wir haben uns im Streit getrennt und er meinte noch zu mir \"Ich werde für dich arbeiten, wenn du mir die Krone eines Königs schenkst\".", "Unfortunately, he is not as impressed with blacksmithing as I had hoped for. We broke up in dispute and said to me \"I'll work for you if you give me the crown of a king\"."), gg_snd_Wieland6)
			call speech(info, character, true, tre("Das war nur aus Zorn heraus als schlechter Scherz gemeint, aber ich will ihm zeigen, wie ernst es mir mit ihm ist.", "It was meant only out of anger as a bad joke, but I wwant to show him how serious I am about him."), gg_snd_Wieland7)
			call speech(info, character, true, tre("Die alten Sagen, die mir mein Vater erzählte, als ich noch selbst ein junger Bursche war, handelten oft von den Untoten. Wiederauferstandene Tote, die keinen Frieden finden konnten und nun alles töten wollen, was noch atmet.", "The old legends which my father told me wehen I was a young lad myself often were about undead. Resurrected dead who couldn't find peace and now wanted to kill everything still breathing."), gg_snd_Wieland8)
			call speech(info, character, true, tre("Diese Untoten haben auch einen König. Man sagt, er streife irgendwo außerhalb von Talras umher und mache die Gegend mit seinen Kriegern unsicher.", "These undead have a king. They say he stripes somewhere around outside of Talras and makes this area unsafe with his warriors."), gg_snd_Wieland9)
			call speech(info, character, true, tre("Ein König, der einst über dieses Land hier herrschte. Für dich hört sich das vielleicht nach Gespenstergeschichten an, aber ich glaube daran, denn mein Vater hat ihn selbst gesehen.", "A king who once ruled about this land here. For you it perhaps sounds like ghost stories but I believe in it because my father has seen him by himself."), gg_snd_Wieland10)
			call speech(info, character, true, tre("Ich möchte, dass du mir seine Krone bringst, damit ich sie meinem Sohn überreichen kann, wenn er zurückkehrt.", "I want you to bring me his crown, so that I can hand it over to my son when he returns."), gg_snd_Wieland11)
			call info.talk().showRange(10, 12, character)
		endmethod

		// Ja, natürlich.
		private static method infoAction0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Ja, natürlich.", "Yes, of course."), null)
			call speech(info, character, true, tre("Das trifft sich gut, ich brauche nämlich Hilfe.", "That's good, because I need some help."), gg_snd_Wieland2)
			call thistype.info0_0Talk.execute(info, character)
		endmethod

		// Wohl eher nicht.
		private static method infoAction0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wohl eher nicht.", "Probably not."), null)
			call speech(info, character, true, tre("Schade, aber vielleicht kannst du mir trotzdem weiterhelfen.", "Too bad, but maybe you can help me anyway."), gg_snd_Wieland3)
			call thistype.info0_0Talk.execute(info, character)
		endmethod

		// Wieso nicht?
		private static method infoAction3_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso nicht?", "Why not?"), null)
			call speech(info, character, true, tre("Du scheinst ja wirklich einer von der hilfsbereiten Sorte zu sein.", "You really seem to be one of the helpful variety."), gg_snd_Wieland29)
			call speech(info, character, true, tre("Also es geht um Einar, den Waffenhändler vor dem Tor der Innenburg. Ich habe vor kurzem ein gutes Schwert für ihm geschmiedet.", "So it's about Einar the arms merchant at the gate of the inner castle. I have forged a good sword for him recently."), gg_snd_Wieland30)
			call speech(info, character, true, tre("Er hat's mir für 800 Goldmünzen abgekauft. Ich möchte jetzt aber wissen, wie viel er dafür verlangt. Das würde mich brennend interessieren, denn nachher haut der Typ noch alle übers Ohr.", "He has bought it for 800 gold coins from me. I want to know now how much he asks for it. That would really interest me because the guy skins me all over the ear in the end."), gg_snd_Wieland31)
			call speech(info, character, true, tre("Also frag ihn nach einem besonders guten Schwert, der Preis sei dir egal, dann wird er es dir schon anbieten. Danach kommst du zu mir und sagst mir den Preis.", "So as k him for a particularly good sword, the price does not matter to you, then he'll offer it to you probably. Then you come to me and tell me the price."), gg_snd_Wieland32)
			call speech(info, character, false, tre("In Ordnung.", "Agreed."), null)
			call QuestWielandsSword.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Nein.
		private static method infoAction3_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Nein.", "No."), null)
			call speech(info, character, true, tre("Na ja, macht nichts, trotzdem danke für deine Hilfe. Leute wie dich kann man hier brauchen. Hoffentlich bist du noch da, wenn der Feind hier einfällt.", "Well, it does not matter, anyway thanks for your help. People like you we do always need here. Hopefully, you'll still be here when the enemy is attacking."), gg_snd_Wieland33)
			call info.talk().showStartPage(character)
		endmethod

		// Wieso gehst du nicht selbst?
		private static method infoAction0_0_0 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Wieso gehst du nicht selbst?", "Why do you not go yourself?"), null)
			call speech(info, character, true, tre("Sieh dich doch mal hier um. Ich bin der einzige Schmied in Talras. Wenn ich nicht wäre, dann würde hier doch das reinste Chaos ausbrechen.", "Look around here. I am the only blacksmith in Talras. If would not be there, then pure chaos would break out here."), gg_snd_Wieland12)
			call speech(info, character, true, tre("Glaub mir, ich würde gehen, denn an Mut fehlt es mir wahrlich nicht, aber ich habe zu tun. Also was ist nun?", "Believe me, I would go, because there is truly no lack of courage to me but I am busy. So what is now?"), gg_snd_Wieland13)
			call info.talk().showRange(11, 12, character)
		endmethod

		// Gut, ich werde sehen, was ich tun kann.
		private static method infoAction0_0_1 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Gut, ich werde sehen, was ich tun kann.", "Well, I'll see what I can do."), null)
			call speech(info, character, true, tre("Ich danke dir und wenn er die Krone nicht freiwillig rausrückt, wovon ich mal ausgehe, dann spalte ihm halt den Schädel, diesem alten Knochengeist.", "Thank you, and if he does not give it to you by himself which I expect, just break the skull of this old ghost of bones."), gg_snd_Wieland14)
			call QuestTheKingsCrown.characterQuest(character).enable()
			call info.talk().showStartPage(character)
		endmethod

		// Willst du mich verarschen?
		private static method infoAction0_0_2 takes AInfo info, ACharacter character returns nothing
			call speech(info, character, false, tre("Willst du mich verarschen?", "Are you kidding me?"), null)
			call speech(info, character, true, tre("Nein. Wenn du mir nicht glaubst, dann eben nicht. Aber wenn du ihn triffst, dann behaupte nicht, dass ich dich nicht gewarnt hätte.", "No. If you do not believe me, then don't. But when you meet him, do not pretend that I did not warn you."), gg_snd_Wieland15)
			call speech(info, character, true, tre("Er ist der Schrecken selbst.", "He is the nightmare himself."), gg_snd_Wieland16)
			call info.talk().showStartPage(character)
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(gg_unit_n01Y_0006, thistype.startPageAction)

			// start page
			call this.addInfo(false, true, 0, thistype.infoAction0, null) // 0
			call this.addInfo(false, false, 0, thistype.infoAction1, tre("Kannst du mir das Schmieden beibringen?", "Can you teach me how to forge?")) // 1
			call this.addInfo(false, false, 0, thistype.infoAction2, tre("Verkaufst du auch Waffen?", "Do you sell weapons as well?")) // 2
			call this.addInfo(false, false, thistype.infoCondition3, thistype.infoAction3, tre("Hier ist die Krone.", "Here is the crown.")) // 3
			call this.addInfo(false, false, thistype.infoCondition4, thistype.infoAction4, tre("Ich habe mit Einar gesprochen.", "I talked to Einar.")) // 4
			call this.addExitButton() // 5

			// info 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0, tre("Ja, natürlich.", "Yes, of course.")) // 6
			call this.addInfo(false, false, 0, thistype.infoAction0_1, tre("Wohl eher nicht.", "Probably not.")) // 7

			// info 3
			call this.addInfo(false, false, 0, thistype.infoAction3_0, tre("Wieso nicht?", "Why not?")) // 8
			call this.addInfo(false, false, 0, thistype.infoAction3_1, tre("Nein.", "No.")) // 9

			// info 0 0
			call this.addInfo(false, false, 0, thistype.infoAction0_0_0, tre("Wieso gehst du nicht selbst?", "Why do you not go yourself?")) // 10
			call this.addInfo(false, false, 0, thistype.infoAction0_0_1, tre("Gut, ich werde sehen, was ich tun kann.", "Well, I'll see what I can do.")) // 11
			call this.addInfo(false, false, 0, thistype.infoAction0_0_2, tre("Willst du mich verarschen?", "Are you kidding me?")) // 12

			return this
		endmethod
	endstruct

endlibrary
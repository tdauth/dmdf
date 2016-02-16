library StructMapVideosVideoTheChief requires Asl, StructGameGame, StructMapMapNpcs

	struct VideoTheChief extends AVideo
		private unit m_actorWigberht
		private unit m_actorRicman
		private unit m_actorNorseman0
		private unit m_actorNorseman1

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(6.00)
			call PlayThematicMusic("Music\\TheChief.mp3")
			call CameraSetupApplyForceDuration(gg_cam_the_chief_0, true, 0.0)

			set this.m_actorWigberht = thistype.unitActor(thistype.saveUnitActor(Npcs.wigberht()))
			call SetUnitPositionRect(this.m_actorWigberht, gg_rct_video_the_chief_wigberhts_position)
			call SetUnitFacing(this.m_actorWigberht, 257.38)

			set this.m_actorRicman = thistype.unitActor(thistype.saveUnitActor(Npcs.ricman()))
			call SetUnitPositionRect(this.m_actorRicman, gg_rct_video_the_chief_ricmans_position)
			call SetUnitFacing(this.m_actorRicman, 299.92)
			call UnitRemoveAbility(this.m_actorRicman, 'Aneu') // disable arrow

			set this.m_actorNorseman0 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n01I_0150))
			call SetUnitPositionRect(this.m_actorNorseman0, gg_rct_video_the_chief_norseman_0)
			call SetUnitFacing(this.m_actorNorseman0, 303.74)

			set this.m_actorNorseman1 = thistype.unitActor(thistype.saveUnitActor(gg_unit_n01I_0151))
			call SetUnitPositionRect(this.m_actorNorseman1, gg_rct_video_the_chief_norseman_1)
			call SetUnitFacing(this.m_actorNorseman1, 168.10)


			// hide other norsemen
			call ShowUnit(gg_unit_n01I_0153, false)
			call ShowUnit(gg_unit_n01I_0152, false)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_the_chief_actors_position)
			call SetUnitFacing(thistype.actor(), 123.64)
			call SetUnitMoveSpeed(thistype.actor(), 200.0)
			
			call CameraSetupApplyForceDuration(gg_cam_the_chief_1, true, 10.0)
			call IssueRectOrder(thistype.actor(), "move", gg_rct_video_the_chief_actors_target)
		endmethod

		private static method conditionActorIsInTargetRect takes AVideo this returns boolean
			return RectContainsUnit(gg_rct_video_the_chief_actors_target, AVideo.actor())
		endmethod

		private static method conditionWigberhtIsInRicmansRect takes thistype this returns boolean
			return RectContainsUnit(gg_rct_video_the_chief_ricmans_position,this.m_actorWigberht)
		endmethod

		public stub method onPlayAction takes nothing returns nothing

			if (waitForCondition(1.0, thistype.conditionActorIsInTargetRect)) then
				return
			endif
			call SetUnitFacingToFaceUnit(this.m_actorRicman, thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorRicman)
			
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_2, true, 0.0)
			call TransmissionFromUnitWithName(this.m_actorRicman, tre("Ricman", "Ricman"), tre("Was wollt ihr hier?", "What do you want here?"), gg_snd_RicmanTheChiefRicman1)
			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanTheChiefRicman1))) then
				return
			endif
			call TransmissionFromUnit(AVideo.actor(), tre("Wir wollen mit Eurem Anführer sprechen. Der Herzog von Talras schickt uns.", "We want to speak to your leader. The duke of Talras semds us."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call TransmissionFromUnitWithName(this.m_actorRicman, tre("Ricman", "Ricman"), tre("Der Herzog von Talras? Wieso kommt er nicht persönlich? Macht dass ihr wegkommt!", "The duke of Talras? Why doesn't he come himself? Get yourselves out of here!"), gg_snd_RicmanTheChiefRicman2)
			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanTheChiefRicman2) + 1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_chief_3, true, 3.0)
			
			if (wait(3.50)) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Lass sie!", "Let them!"), gg_snd_Wigberht29)
			call SetUnitAnimation(this.m_actorWigberht, "Spell")
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht29))) then
				return
			endif
			call SetUnitFacingToFaceUnit(this.m_actorWigberht,  this.m_actorRicman)
			call CameraSetupApplyForceDuration(gg_cam_the_chief_4, true, 3.0)
			if (wait(3.0)) then
				return
			endif
			call IssueRectOrder(this.m_actorRicman, "move", gg_rct_video_the_chief_ricmans_new_position)
			if (wait(2.0)) then
				return
			endif
			call IssueRectOrder(this.m_actorWigberht, "move", gg_rct_video_the_chief_ricmans_position)
			call CameraSetupApplyForceDuration(gg_cam_the_chief_5, true, 5.0)
			if (waitForCondition(1.0, thistype.conditionWigberhtIsInRicmansRect)) then
				return
			endif
			call SetUnitFacingToFaceUnit(this.m_actorRicman, this.m_actorWigberht)
			call SetUnitFacingToFaceUnit(this.m_actorWigberht, thistype.actor())
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Was wollt ihr von mir?", "What do you want from me?"), gg_snd_Wigberht30)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht30))) then
				return
			endif

			call TransmissionFromUnit(thistype.actor(), tre("Heimrich, der Herzog von Talras, möchte wissen, ob er ein Bündnis mit Euch und Euren Männern eingehen kann. Er braucht Unterstützung im Kampf gegen den Feind.", "Heimrich, the duke of Talras wants to know if he can enter into an alliance with you and your men. He need support in the fight against the enemy."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Wieso sollte ich ein Bündnis mit ihm eingehen?", "Why should I form an alliance with him?"), gg_snd_Wigberht31)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht31))) then
				return
			endif

			call TransmissionFromUnit(thistype.actor(), tre("Gemeinsam habt ihr eine größere Chance den Feind zu bezwingen.", "Toghether you have a greater chance to defeat the enemy."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Den Feind zu bezwingen? Seht, ich werde euch erklären, warum meine Männer und ich hier sind. Mein Vater, ein Kriegsherr des Nordens, wurde von Dunkelfelfen verschleppt. Wir folgten ihnen bis hier her.", "To defeat the enemy? Look, I'll tell you why my men and I are here. My father, a warlord of the north, was abducted by the Dark Elves. We followed them, until here."), gg_snd_Wigberht32)
			
			call Game.fadeOutWithWait()
			// at night
			call SetTimeOfDay(0.00)
			call CameraSetupApplyForceDuration(gg_cam_the_chief_raid_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_the_chief_raid_1, true, 4.0)
			call Game.fadeInWithWait()
			
			if (wait(2.0)) then
			endif
			
			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_the_chief_raid_2, true, 0.0)
			call Game.fadeInWithWait()
			
			call QueueUnitAnimationBJ(gg_unit_H01C_0407, "Spell")
			
			if (wait(2.0)) then
			endif
			
			if (wait(RMaxBJ(GetSimpleTransmissionDuration(gg_snd_Wigberht32) - 10.0, 0.0))) then
				return
			endif
			
			call Game.fadeOutWithWait()
			call SetTimeOfDay(6.00)
			call CameraSetupApplyForceDuration(gg_cam_the_chief_6, true, 0.0)
			call Game.fadeInWithWait()
			
			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Wir machen hier Rast, um herauszufinden wie groß das Heer der Orks ist, das in dieses Land eingefallen ist und dann greifen wir es an. Wir müssen uns durch ihre Linien schlagen, um den Dunkelelfen weiter folgen zu können.", "We must take a stop to figure out how big the army of the Orcs is that invaded this land and then we attack it. We have to fight us through their lines in order to follow the Dark Elves further."), gg_snd_Wigberht33)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht33))) then
				return
			endif

			call TransmissionFromUnit(thistype.actor(), tre("Ihr paar wollt das Heer der Orks angreifen? Das ist Wahnsinn.", "You few want to attack the army of Orcs? This is madness."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Der einzige Weg führt durch die Reihen der Orks. Wir haben keine Wahl. Dieser Herzog, der euch schickt, harrt in seiner Burg aus bis der Feind ihn angreift oder aushungern lässt. Wir sind keine Feiglinge, wir stellen uns dem Feind.", "The only way goes through the ranks of the Orcs. We have no choice. This duke who sends you waits in his castle until the enemy is attacking him or let's him starve. We are no cowards, we face the enemy."), gg_snd_Wigberht34)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht34))) then
				return
			endif

			call TransmissionFromUnit(thistype.actor(), tre("Und wann wollt ihr angreifen?", "And when you will attack?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Einer unserer Späher hat gestern eine Vorhut der Orks entdeckt. Sie befindet sich irgendwo im nördlichen Wald. Sobald wir bereit sind, schlagen wir zu. Wenn es euch beliebt dann kommt mit. Ihr seht aus, als würdet ihr gerne ein paar Orks abschlachten.", "One of our scouts discovered a vanguard of Orcs yesterday. It is located somewhere in the northern forest. Once we are ready, we attack. If it pleases you, then come with us. You look as though you like to slaughter a few Orcs."), gg_snd_Wigberht35)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht35))) then
				return
			endif

			call TransmissionFromUnit(thistype.actor(), tre("Und was wird aus dem Bündnis?", "And is with the alliance?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Beweist mir, dass ihr kampfstark seid und ich werde mir überlegen, ob wir noch eine Weile hier bleiben, um den Herzog zu unterstützen.", "Prove to me that you are strong in the battle and I will think about whether we stay here for a while to help the duke."), gg_snd_Wigberht36)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht36))) then
				return
			endif

			call TransmissionFromUnit(thistype.actor(), tre("Sieht aus als hätten wir keine Wahl.", "Looks like we have no choice."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.m_actorWigberht, tre("Wigberht", "Wigberht"), tre("Exakt.", "Exactly."), gg_snd_Wigberht37)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht37))) then
				return
			endif
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorWigberht = null
			set this.m_actorRicman = null

			// show other norsemen
			call ShowUnit(gg_unit_n01I_0153, true)
			call ShowUnit(gg_unit_n01I_0152, true)

			call Game.resetVideoSettings()
			call QuestTheNorsemen.quest.evaluate().questItem(1).setState(AAbstractQuest.stateNew)
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary
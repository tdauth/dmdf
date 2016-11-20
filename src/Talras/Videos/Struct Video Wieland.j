library StructMapVideosVideoWieland requires Asl, StructGameGame

	struct VideoWieland extends AVideo
		private unit m_actorWieland

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_wieland_forge_view, true, 0.0)

			set this.m_actorWieland = this.unitActor(this.saveUnitActor(Npcs.wieland()))
			call SetUnitPositionRect(this.m_actorWieland, gg_rct_video_wieland_wieland)
			call SetUnitFacing(this.m_actorWieland, 227.57)
			call QueueUnitAnimation(this.m_actorWieland, "Attack First")

			call SetUnitPositionRect(this.actor(), gg_rct_video_wieland_actor)
			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorWieland)
			call IssueRectOrder(this.actor(), "move", gg_rct_video_wieland_actor_target)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_wieland_forge_view)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_wieland_actor_target, this.actor()))
				if (wait(1.0)) then
					return
				endif
			endloop

			call TransmissionFromUnit(this.actor(), tre("Schmied Wieland!", "Blacksmith Wieland!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call ResetUnitAnimation(this.m_actorWieland)
			call SetUnitFacingToFaceUnit(this.m_actorWieland, this.actor())


			if (wait(1.0)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wieland_wieland_view, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("Was gibt es?", "What is it?"), gg_snd_Wieland_a)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_a))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Der Herzog braucht Waffen für einen eroberten Außenposten der Orks und Dunkelelfen.", "The duke needs weapons for a conquered outpost of the Orcs and Dark Elves."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("Der Herzog braucht immer Waffen! Wie stellt er sich das vor, bin ich doch der einzige Schmied in Talras? Ich habe jetzt schon genug zu tun.", "The duke always needs weapons! How does he imagine that when I am the only blacksmith in Talras? I already have to do enough at the moment."), gg_snd_Wieland_b)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_b))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Markward schickt mich. Der Außenposten muss befestigt werden um die Orks und Dunkelelfen abzuwehren.", "Markward sends me. The outpost has to be fortified to defend it from the Orcs and Dark Elves."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("Ja ja schon gut, ich werde die Waffen herstellen. Allerdings braucht man dafür selbstverständlich auch Eisen und daran mangelt es in Talras.", "Yes okay, okay, I will make the weapons. However, you need for this of course iron and this is missing in Talras."), gg_snd_Wieland_c)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_c))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("Wenn der Herzog die Waffen will, dann soll er mir das Eisen dafür geben. Zaubern kann ich leider nicht.", "If the duke wants the weapons, then he should give me the iron for it. Unfortunately, I can't do magic."), gg_snd_Wieland_d)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_d))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Wo finde ich Eisen in dieser Gegend?", "Where can I find iron in this area?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("In Talras? Keine Ahnung, nirgendwo?! Hmm man erzählt sich die Legende von unterirdischen Gewölben im Mühlberg. Vielleicht birgt dieser Berg ja Eisen. Falls nicht musst du wohl nach Holzbruck aufbrechen. Dafür kannst du dich dann beim Herzog bedanken.", "In Talras? No idea, nowhere?! Hmm, people tell the legend of underground vaults in the Mill Hill. Perhaps this hill holds iron. If not you will have to leave for Holzbruck. Then you can thank the duke for that."), gg_snd_Wieland_e)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_e))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorWieland, tre("Bringt mir das Eisen und ich schmiede euch die besten Waffen in ganz Talras, mit denen ihr die verfluchten Orks und Dunkelelfen aufschlitzen könnt wie gemestetes Vieh. Die Bezahlung werde ich noch mit dem Vogt aushandeln. Ich will dabei ja nicht leer ausgehen.", "Bring me the iron and I forge you the best weapons throughout Talras, with which you can rip up the cursed Orcs and Dark Elves like fattened cattles. I will negotiate the payment with the steward. I do not want to get nothing from this."), gg_snd_Wieland_f)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wieland_f))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorWieland = null

			call Game.resetVideoSettings()
			call QuestWarWeaponsFromWieland.quest.evaluate().enableIronFromTheDrumCave.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary
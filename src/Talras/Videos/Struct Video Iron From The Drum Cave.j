library StructMapVideosVideoIronFromTheDrumCave requires Asl, StructGameGame

	struct VideoIronFromTheDrumCave extends AVideo
		private unit m_actorBaldar
		private unit m_actorImp

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_baldar, true, 0.0)

			set this.m_actorBaldar = this.unitActor(this.saveUnitActor(Npcs.baldar()))
			call SetUnitPositionRect(this.m_actorBaldar, gg_rct_video_iron_from_the_drum_cave_baldar)

			set this.m_actorImp = this.unitActor(this.saveUnitActor(gg_unit_u001_0190))
			call SetUnitPositionRect(this.m_actorImp, gg_rct_video_iron_from_the_drum_cave_imp)
			call QueueUnitAnimation(this.m_actorImp , "Attack")

			call SetUnitPositionRect(this.actor(), gg_rct_video_iron_from_the_drum_cave_actor)
			call SetUnitFacingToFaceUnit(this.actor(), this.m_actorBaldar)
			call SetUnitFacingToFaceUnit(this.m_actorBaldar, this.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_iron_from_the_drum_cave_baldar)

			call TransmissionFromUnit(this.m_actorBaldar, tre("Was sagst du? Du brauchst Eisen aus meinen Minen?", "What are you saying? You need iron from my mines?"), gg_snd_Baldar33)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Baldar33))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("So ist es.", "That's the way it is."), null)


			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBaldar, tre("Was habe ich davon mein Eisen dir zu geben anstatt meine eigenen Krieger damit auszurüsten, um meinen Bruder endlich zu besiegen?", "What do I get from giving you my iron instead of equipping my own warriors in order to defeat my brother finally?"), gg_snd_Baldar34)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Baldar34))) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Die Orks und Dunkelelfen werden sonst bald hier einfallen und alles dem Erdboden gleich machen. Ist Euch das lieber?", "The Orcs and Dark Elves will otherwise come here soon and make everything to the ground. Would you prefere that?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBaldar, tre("Nein. Die Menschen lassen uns zumindest in Ruhe. Sie haben vermutlich viel zu viel Angst als dass sie diese Höhle betreten würden. Alle bis auf euch.", "No. The humans at least let us at rest. They probably are too scared than they would enter this cave. All except you."), gg_snd_Baldar35)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Baldar35))) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 0.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.0)) then
				return
			endif
			// TODO working imps?
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_1,  true, 4.00)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 0.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.0)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBaldar, tre("Ich kann dir einen Teil meines Eisens geben. Meine Imps können es für dich zur Burg transportieren, jedoch brauche ich die kräftigsten Imps hier bei mir. Ich schicke dir also die schwachen Imps. Du musst sie auf ihrem Weg beschützen, ansonsten werden sie vermutlich von wilden Kreaturen umgebracht.", "I can give you some of my iron. My imps can transport it for you to the castle, but I need the strongest imps here with me. So I'm sending you the weak imps. You have to protect them on their way, otherwise they will probably be killed by wild creatures."), gg_snd_Baldar36)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Baldar36))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBaldar, tre("Hör gut zu, ich möchte dir ein kleines Geheimnis anvertrauen. Diese Imps sind nicht das, was ich mir unter fürchterlichen Dämonen vorgestellt habe. Sie sind schwach, faul, ja es sind armselige Kreaturen.", "Listen carefully, I would like to share a little secret with you. These imps are not what I expected from terrible demons. They are weak, lazy, yes, they are poor creatures."), gg_snd_Baldar37)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Baldar37))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorBaldar, tre("Es ist wohl besser sie umgehend loszuwerden, aber töten nein! Sie sind meine Schöpfung, das würde ich nicht über's ... über mich bringen. Verschaffe ihnen eine Bleibe nachdem sie ihren Dienst für dich getan haben, dann sind wir quitt.", "It is probably better to get rid as soon as possible of them, but killing them, no! They are my creation, I would not have it ... bring  myself. Procure them a place to live after they have served their purpose for you, then we're even."), gg_snd_Baldar38) // TODO Wortspiel mit übers Herz bringen ins Englische übersetzen

			if (wait(GetSimpleTransmissionDuration(gg_snd_Baldar38))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_2, true, 4.00)

			if (wait(3.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_3, true, 4.00)

			if (wait(3.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_4, true, 4.00)

			if (wait(3.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_iron_from_the_drum_cave_mine_5, true, 4.00)

			if (wait(3.50)) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorBaldar = null
			set this.m_actorImp = null

			call Game.resetVideoSettings()

			call QuestWarWeaponsFromWieland.quest.evaluate().enableImpSpawn.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary
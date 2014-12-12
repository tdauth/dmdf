/// @todo Finish this video.
library StructMapVideosVideoUpstream requires Asl, StructGameGame

	struct VideoUpstream extends AVideo
		private integer m_actorBoat
	
		implement Video

		private static method playMusic takes nothing returns nothing
			call PlayThematicMusic("Music\\Upstream.mp3")
			call TriggerSleepAction(228.0) /// @todo Replace by WaitForMusic or something else (more exact).
			loop
				call PlayThematicMusic("Music\\Credits.mp3")
				call TriggerSleepAction(415.0) /// @todo Replace by WaitForMusic or something else (more exact).
			endloop
		endmethod

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(19.0)
			
			set this.m_actorBoat = AVideo.saveUnitActor(gg_unit_n02E_0103)
			
			call thistype.playMusic.execute()
			call CameraSetupApplyForceDuration(gg_cam_upstream_0, true, 0.0)
		endmethod

		private method continueShipRoute takes nothing returns nothing
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_2,  thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_3)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_3, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_4)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_4, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_5)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_5, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_6)
		endmethod

		private static method showMovingTextTag takes string text, real size, integer red, integer green, integer blue, integer alpha returns nothing
			local texttag textTag = CreateTextTag()
			call SetTextTagTextBJ(textTag, text, size)
			call SetTextTagVelocityBJ(textTag, 10.0, 90.0)
			call SetTextTagColor(textTag, red, green, blue, alpha)
			call SetTextTagVisibility(textTag, true)
			call SetTextTagFadepoint(textTag, 10.0)
			call SetTextTagLifespan(textTag, 11.0)
			call SetTextTagPermanent(textTag, false)
			set textTag = null
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local integer i
			call CameraSetupApplyForceDuration(gg_cam_upstream_1, true, 6.0)

			if (wait(5.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_upstream_2, true, 6.0)

			if (wait(5.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_upstream_3, true, 6.0)

			if (wait(5.0)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_upstream_4, true, 0.0)
			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_0)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_0, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call CameraSetupApplyForceDuration(gg_cam_upstream_5, true, 0.0)
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_1)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_1, thistype.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call CameraSetupApplyForceDuration(gg_cam_upstream_6, true, 0.0)
			call IssueRectOrder(thistype.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_2)

			call this.continueShipRoute.execute()

			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Wird das Video übersprungen, so endet das Spiel für alle Spieler."))

			call thistype.showMovingTextTag("Die Macht des Feuers", 16, 255, 0, 0, 0)

			if (wait(3.0)) then
				return
			endif

			set i = 0
			loop
				exitwhen (i == Credits.contributors)
				call thistype.showMovingTextTag(Credits.contributorName.evaluate(i), 14.0, 255, 255, 255, 0)

				if (wait(3.0)) then
					return
				endif

				call thistype.showMovingTextTag(Credits.contributorDescription.evaluate(i), 14.0, 255, 255, 255, 0)

				if (wait(3.0)) then
					return
				endif

				set i = i + 1
			endloop

			call thistype.showMovingTextTag(tr("Vielen Dank fürs Spielen."), 16, 255, 255, 255, 0)

			if (wait(3.0)) then
				return
			endif

			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tr("Das Spiel wird in 8 Sekunden automatisch beendet."))

			if (wait(8.0)) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call EndGame(true)
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary
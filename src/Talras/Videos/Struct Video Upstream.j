library StructMapVideosVideoUpstream requires Asl, StructGameGame, StructGameMapChanger, StructGuisCredits

	struct VideoUpstream extends AVideo
		private integer m_actorBoat
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		private integer m_actorNarrator
		private integer m_actorNorseman0
		private integer m_actorNorseman1
		private integer m_actorKuno
		private integer m_actorKunosDaughter
		private integer m_actorGiant
		private AGroup m_group

		implement Video

		private static method playMusic takes nothing returns nothing
			call PlayThematicMusic("Music\\Upstream.mp3")
			call TriggerSleepAction(228.0) /// @todo Replace by WaitForMusic or something else (more exact).
			loop
				call PlayThematicMusic("Music\\Credits.mp3")
				call TriggerSleepAction(415.0) /// @todo Replace by WaitForMusic or something else (more exact).
			endloop
		endmethod

		private static method endGame takes player whichPlayer returns nothing
			// in single player campaigns the player can continue the game in the next level
			if (bj_isSinglePlayer and Game.isCampaign()) then
				// from now on the player can change to the next map whenever he wants to
				call MapData.enableWayToGardonar.evaluate()
				call MapChanger.changeMap("GA")
			elseif (whichPlayer == GetLocalPlayer()) then
				call EndGame(true)
			endif
		endmethod

		private static method endGameForAll takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call thistype.endGame(Player(i))
				set i = i + 1
			endloop
		endmethod

		private static method dialogButtonActionYes takes ADialogButton dialogButton returns nothing
			call thistype.endGame(dialogButton.dialog().player())
		endmethod

		private static method dialogButtonActionNo takes ADialogButton dialogButton returns nothing
			if (dialogButton.dialog().player() == GetLocalPlayer()) then
				call ShowInterface(false, 1.0)
				call EnableUserControl(false)
				call thistype.resetSkippingPlayers() // player can skip again
			endif
		endmethod

		public stub method onSkipCondition takes player skippingPlayer, integer skipablePlayers returns boolean
			if (not bj_isSinglePlayer or not Game.isCampaign.evaluate()) then
				if (skippingPlayer == GetLocalPlayer()) then
					call ShowInterface(true, 1.0)
					call EnableUserControl(true)
				endif
				call AGui.playerGui(skippingPlayer).dialog().clear()
				call AGui.playerGui(skippingPlayer).dialog().setMessage(tre("Spiel verlassen?", "Leave game?"))
				call AGui.playerGui(skippingPlayer).dialog().addDialogButtonIndex(tre("Ja", "Yes"), thistype.dialogButtonActionYes)
				call AGui.playerGui(skippingPlayer).dialog().addDialogButtonIndex(tre("Nein", "No"), thistype.dialogButtonActionNo)
				call AGui.playerGui(skippingPlayer).dialog().show()

				return false
			endif

			return true
		endmethod

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(19.0)

			// hide old norseman
			call ShowUnit(gg_unit_n01I_0150, false)
			call ShowUnit(gg_unit_n01I_0151, false)
			call ShowUnit(gg_unit_n01I_0152, false)
			call ShowUnit(gg_unit_n01I_0153, false)

			set this.m_actorBoat = this.saveUnitActor(gg_unit_n02E_0103)

			call SetUnitPositionRect(this.actor(), gg_rct_video_upstream_actor)
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorBoat))

			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_upstream_wigberht)
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorBoat))

			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(this.unitActor(this.m_actorRicman), gg_rct_video_upstream_ricman)
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.unitActor(this.m_actorBoat))

			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(this.unitActor(this.m_actorDragonSlayer), gg_rct_video_upstream_dragon_slayer)
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDragonSlayer), this.unitActor(this.m_actorBoat))

			set this.m_actorNarrator = this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n06V', gg_rct_video_upstream_narrator, GetRandomFacing())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorNarrator), this.unitActor(this.m_actorBoat))

			set this.m_actorNorseman0 = this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.norseman, gg_rct_video_upstream_norseman_0, GetRandomFacing())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorNorseman0), this.unitActor(this.m_actorBoat))
			set this.m_actorNorseman1 = this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), UnitTypes.norseman, gg_rct_video_upstream_norseman_1, GetRandomFacing())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorNorseman1), this.unitActor(this.m_actorBoat))

			set this.m_actorKuno = this.saveUnitActor(Npcs.kuno())
			call SetUnitPositionRect(this.unitActor(this.m_actorKuno), gg_rct_video_upstream_kuno)
			call SetUnitFacing(this.unitActor(this.m_actorKuno), 106.44)

			set this.m_actorKunosDaughter = this.saveUnitActor(Npcs.kunosDaughter())
			call SetUnitPositionRect(this.unitActor(this.m_actorKunosDaughter), gg_rct_video_upstream_kunos_daughter)
			call SetUnitFacing(this.unitActor(this.m_actorKunosDaughter), 106.44)

			set this.m_actorGiant = this.createUnitActorAtRect(MapData.alliedPlayer, UnitTypes.giant, gg_rct_video_upstream_giant_start, 272.22)
			call SetUnitColor(this.unitActor(this.m_actorGiant), GetPlayerColor(Player(PLAYER_NEUTRAL_PASSIVE)))

			set this.m_group = AGroup.create()
			call this.m_group.units().pushBack(this.actor())
			call this.m_group.units().pushBack(this.unitActor(this.m_actorWigberht))
			call this.m_group.units().pushBack(this.unitActor(this.m_actorRicman))
			call this.m_group.units().pushBack(this.unitActor(this.m_actorDragonSlayer))
			call this.m_group.units().pushBack(this.unitActor(this.m_actorNorseman0))
			call this.m_group.units().pushBack(this.unitActor(this.m_actorNorseman1))

			call thistype.playMusic.execute()
			call CameraSetupApplyForceDuration(gg_cam_upstream_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_upstream_1, true, 8.0)
		endmethod

		private method continueShipRoute takes nothing returns nothing
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_2,  this.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(this.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_3)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_3, this.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(this.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_4)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_4, this.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(this.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_5)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_5, this.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueRectOrder(this.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_6)
		endmethod

		private static method showMovingTextTag takes string text, real size, integer red, integer green, integer blue, integer alpha returns nothing
			local texttag textTag = CreateTextTag()
			call SetTextTagText(textTag, text, 0.023)
			call SetTextTagPos(textTag, CameraSetupGetDestPositionX(gg_cam_upstream_6), CameraSetupGetDestPositionY(gg_cam_upstream_6), CameraSetupGetField(gg_cam_upstream_6, CAMERA_FIELD_ZOFFSET) + 16.0)
			call SetTextTagColor(textTag, red, green, blue, alpha)
			call SetTextTagVisibility(textTag, true)
			call SetTextTagVelocity(textTag, 0.0, 0.040)
			set textTag = null
		endmethod

		private static method slowDown takes unit whichUnit returns nothing
			call SetUnitMoveSpeed(whichUnit, 100.0)
		endmethod

		private static method hide takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local integer i

			if (wait(5.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_upstream_2, true, 6.0)

			if (wait(5.0)) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorNarrator), tre("Erzähler", "Narrator"), tre("So segelten sie gemeinsam mit den Nordmännern nach Holzbruck. Doch was dort geschah ist eine andere Geschichte ...", "So they sailed together with the norsemen to Holzbruck. But what happened there is a different story ..."), gg_snd_ErzaehlerFlussaufwaerts1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerFlussaufwaerts1))) then
				return
			endif

			call this.m_group.forGroup(thistype.slowDown)
			call this.m_group.pointOrder("move", GetRectCenterX(gg_rct_video_upstream_enter_boat), GetRectCenterY(gg_rct_video_upstream_enter_boat))


			call CameraSetupApplyForceDuration(gg_cam_upstream_3, true, 6.0)

			if (wait(5.0)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call TriggerSleepAction(2.50)
			call CameraSetupApplyForceDuration(gg_cam_upstream_4, true, 0.0)

			call this.m_group.forGroup(thistype.hide)

			call TriggerSleepAction(0.50)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 2.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			call IssueRectOrder(this.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_0)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_0, this.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call CameraSetupApplyForceDuration(gg_cam_upstream_5, true, 0.0)
			call IssueRectOrder(this.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_1)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_ship_before_1, this.unitActor(this.m_actorBoat)))
				if (wait(1.0)) then
					return
				endif
			endloop

			call CameraSetupApplyForceDuration(gg_cam_upstream_6, true, 0.0)
			call IssueRectOrder(this.unitActor(this.m_actorBoat), "move", gg_rct_video_upstream_ship_2)

			call this.continueShipRoute.execute()

			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call DisplayTimedTextToPlayer(Player(i), 0.0, 0.0, 25.0, tre("Wenn Sie das Video überspringen, können Sie das Spiel verlassen.", "If you skip the video, you can leave the game."))
				set i = i + 1
			endloop

			if (wait(3.0)) then
				return
			endif

			call thistype.showMovingTextTag("Die Macht des Feuers", 16.0, 255, 0, 0, 0)

			if (wait(3.0)) then
				return
			endif

			set i = 0
			loop
				exitwhen (i == Credits.contributors())

				if (not Credits.contributorIsTitle(i)) then
					call thistype.showMovingTextTag(Credits.contributorDescription(i), 14.0, 255, 255, 255, 0)

					if (wait(1.00)) then
						return
					endif
				endif


				if (not Credits.contributorIsTitle(i)) then
					call thistype.showMovingTextTag(Credits.contributorName(i), 14.0, 255, 255, 255, 0)
				else
					call thistype.showMovingTextTag(Credits.contributorName(i), 16.0, 255, 0, 0, 0)
				endif

				if (wait(2.5)) then
					return
				endif

				set i = i + 1
			endloop

			call thistype.showMovingTextTag(tre("Vielen Dank fürs Spielen.", "Thanks for playing."), 16.0, 255, 255, 255, 0)

			if (wait(4.0)) then
				return
			endif

			call ACharacter.displayMessageToAll(ACharacter.messageTypeInfo, tre("Überspringen Sie das Video, um das Spiel zu verlassen.", "Skip the video to leave the game."))

			call IssueRectOrder(this.unitActor(this.m_actorGiant), "move", gg_rct_video_upstream_giant_target)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_giant_target, this.unitActor(this.m_actorGiant)))

				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorGiant), this.unitActor(this.m_actorBoat))

			call SetUnitAnimation(this.unitActor(this.m_actorGiant), "Attack Slam")

			call TransmissionFromUnit(this.unitActor(this.m_actorGiant), tre("Haaalt! Wartet doch! Ich will auch mit, nehmt mich mit! Diese Karte ist langweilig!", "Stoop! Wait! I also want to go with you, take me with you! This map is boring!"), gg_snd_Giant1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Giant1))) then
				return
			endif

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorKuno), this.unitActor(this.m_actorGiant))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorKunosDaughter), this.unitActor(this.m_actorGiant))

			call TransmissionFromUnit(this.unitActor(this.m_actorKuno), tre("Was soll denn das? Verschwinde! Ich sehe überhaupt nichts!", "What are you doing? Get out of here! I don't see anything!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorKunosDaughter), tre("Ja, wir sehen gar nichts! Du stehst in unserem Sichtfeld.", "Yes, we see nothing! You are standing in our field of view."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorGiant), this.unitActor(this.m_actorKuno))

			if (wait(1.0)) then
				return
			endif

			call SetUnitAnimation(this.unitActor(this.m_actorGiant), "Stand")
			call SetUnitAnimationByIndex(this.unitActor(this.m_actorGiant), 3)
			call TransmissionFromUnit(this.unitActor(this.m_actorGiant), tre("Oh, ich bitte um Verzeihung.", "Oh, I beg your pardon."), gg_snd_Giant2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Giant2))) then
				return
			endif

			call IssueRectOrder(this.unitActor(this.m_actorGiant), "move", gg_rct_video_upstream_giant_start)

			loop
				exitwhen (RectContainsUnit(gg_rct_video_upstream_giant_start, this.unitActor(this.m_actorGiant)))

				if (wait(1.0)) then
					return
				endif
			endloop

			call thistype.endGameForAll()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call this.m_group.destroy()
			call thistype.endGameForAll()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)

			return this
		endmethod
	endstruct

endlibrary
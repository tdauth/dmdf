library StructMapVideosVideoDeranor requires Asl, StructGameGame

	struct VideoDeranor extends AVideo
		private unit m_actorDragonSlayer
		private unit m_actorDeranor
		private AGroup m_summonedUnits = 0

		private static method filterShadowGiant takes nothing returns boolean
			return GetUnitTypeId(GetFilterUnit()) == 'n039'
		endmethod

		private static method forGroupHide takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
		endmethod

		private static method forGroupRemove takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(0.0)
			call CameraSetupApplyForceDuration(gg_cam_deranor_0, true, 0.0)

			set this.m_actorDragonSlayer = this.unitActor(this.saveUnitActor(Npcs.dragonSlayer()))
			call SetUnitPositionRect(this.m_actorDragonSlayer, gg_rct_video_deranor_dragon_slayer)
			call SetUnitOwner(this.m_actorDragonSlayer, Player(PLAYER_NEUTRAL_PASSIVE), false)
			call SetUnitColor(this.m_actorDragonSlayer, GetPlayerColor(MapSettings.alliedPlayer()))
			call SetUnitFacing(this.m_actorDragonSlayer, 270.0)
			call ShowUnit(this.m_actorDragonSlayer, false)
			call IssueImmediateOrder(this.m_actorDragonSlayer, "stop")

			set this.m_actorDeranor = this.unitActor(this.saveUnitActor(gg_unit_u00A_0353))


			call SetUnitPositionRect(this.actor(), gg_rct_video_deranor_actor)
			call SetUnitFacing(this.actor(), 270.0)
			call ShowUnit(this.actor(), false)
			call IssueImmediateOrder(this.actor(), "stop")

			call PlayThematicMusic("Sound\\Music\\mp3Music\\Doom.mp3")
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_deranor_0)

			if (wait(1.00)) then
				return
			endif

			call ShowUnit(this.m_actorDragonSlayer, true)
			call IssueImmediateOrder(this.m_actorDragonSlayer, "stop")
			call ShowUnit(this.actor(), true)
			call IssueImmediateOrder(this.actor(), "stop")

			if (wait(2.0)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Seht euch das an! In diesem mächtigen unterirdischen Gewölbe muss er sich versteckt halten. Nun werden wir Deranor dem Schrecklichen ein ebenso schreckliches Ende bereiten.", "Look at that! In this mighty underground vault he must be hiding. Now we will put an equally terrible end to Deranor the Terrible."), gg_snd_DragonSlayerDeranor1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranor1))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Eine halbe Ewigkeit trieb er sein Unwesen in den Todessümpfen und kein Mensch wagte es je diese Sümpfe zu betreten. Nur zu gut wissen die Menschen, dass irgendwo dort seine finstere Burg stehen muss. Die Burg von der aus er das Land mit Tod und Verfall überzieht.", "Half an eternity he did his worst in the Dead Marshes and no man dared ever to enter the marshes. Only too well people know that somewhere there his dark castle is located. The castel from where he covers the land with death and decay."), gg_snd_DragonSlayerDeranor2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranor2))) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDragonSlayer, tre("Um diesen \"Menschen\", oder was er auch gewesen sein mag, ist es nicht schade. Lasst uns in unser letztes Gefecht ziehen und mögen euch die Götter vor seinem Fluch beschützen!", "To this \"human\" or what he may have been it is not too bad. Let us go into our last battle and may the gods protect you from his curse!"), gg_snd_DragonSlayerDeranor3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerDeranor3))) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_deranor_1, true, 0)

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)

			call CameraSetupApplyForceDuration(gg_cam_deranor_2, true, 3.00)
			if (wait(2.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_deranor_3, true, 3.00)
			if (wait(2.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_deranor_4, true, 3.00)
			if (wait(3.50)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_deranor_5, true, 0.00)
			if (wait(2.0)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_deranor_8, true, 0.00)

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call IssuePointOrder(this.m_actorDeranor, "rainofchaos", GetRectCenterX(gg_rct_video_deranor_rain), GetRectCenterY(gg_rct_video_deranor_rain))

			if (wait(5.00)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			set this.m_summonedUnits = AGroup.create()
			call this.m_summonedUnits.addUnitsInRect(gg_rct_area_tomb, Filter(function thistype.filterShadowGiant))
			call this.m_summonedUnits.forGroup(thistype.forGroupHide)
			call CameraSetupApplyForceDuration(gg_cam_deranor_5, true, 0.00)

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif

			call TransmissionFromUnit(this.m_actorDeranor, tre("Wer wagt es mich zu stören?! Seid ihr etwa gekommen, um mich aus diesem dem Untergang geweihten Land zu vertreiben? Ich werde euch lehren, was Untergang bedeutet ihr Narren!", "Who dares to interfere with me?! Have you come to expel me from this doomed land? I will teach you what doom means you fools!"), gg_snd_Deranor1Mod)
			call QueueUnitAnimation(this.m_actorDeranor, "Spell Channel")

			if (wait(GetSimpleTransmissionDuration(gg_snd_Deranor1Mod))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()

			if (this.m_summonedUnits != 0) then
				// remove them, otherwise he will summon them twice!
				call this.m_summonedUnits.forGroup(thistype.forGroupRemove)
				call this.m_summonedUnits.destroy()
				set this.m_summonedUnits = 0
			endif
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary
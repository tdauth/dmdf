/// @todo Finish this video.
library StructMapVideosVideoWigberht requires Asl, StructGameGame

	struct VideoWigberht extends AVideo
		private static constant real wigberhtMoveSpeed = 200.0
		private static constant real orcMoveSpeed = 300.0
		private integer m_actorWigberht
		private integer m_actorRicman
		private unit m_actorOrcLeader
		private AGroup m_staticActors
		private AGroup m_orcGuardians

		implement Video

		public stub method onInitAction takes nothing returns nothing
			debug call Print("Init 1")
			call Game.initVideoSettings()
			call SetTimeOfDay(20.00)
			call PlayThematicMusic("Music\\Wigberht.mp3")
			call CameraSetupApplyForceDuration(gg_cam_wigberht_0, true, 0.0)
			debug call Print("Init 2")
			set this.m_actorWigberht = thistype.saveUnitActor(gg_unit_n004_0038)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWigberht), gg_rct_video_wigberht_wigberhts_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorWigberht), 90.0)
			debug call Print("Init 3")
			set this.m_actorRicman = thistype.saveUnitActor(gg_unit_n016_0016)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorRicman), gg_rct_video_wigberht_ricmans_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorRicman), 342.35)
			debug call Print("Init 4")
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_wigberht_actors_position)
			call SetUnitFacing(thistype.actor(), 206.90)

			set this.m_staticActors = AGroup.create()
			set this.m_orcGuardians = AGroup.create()
			debug call Print("Init 5")
			// create norsemen
			// create rangers
			// create farmers

			// create corpses
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.alliedPlayer(), UnitTypes.norseman, gg_rct_video_wigberht_corpse_0_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.alliedPlayer(), UnitTypes.norseman, gg_rct_video_wigberht_corpse_1_position, GetRandomFacing()))
			debug call Print("Init 6")
			// create orcs
			set this.m_actorOrcLeader = CreateUnitAtRect(Game.hostilePlayer(), UnitTypes.orcLeader, gg_rct_video_wigberht_orc_leaders_position, 237.39)
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(Game.hostilePlayer(), UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_0, 308.79))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(Game.hostilePlayer(), UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_1, 200.36))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(Game.hostilePlayer(), UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_2, 327.94))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(Game.hostilePlayer(), UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_3, 160.66))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(Game.hostilePlayer(), UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_4, 250.86))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(Game.hostilePlayer(), UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_5, 215.00))
			debug call Print("Init 7")
		endmethod

		private static method setMoveSpeed takes unit whichUnit returns nothing
			call SetUnitMoveSpeed(whichUnit, thistype.orcMoveSpeed)
		endmethod

		private static method kill takes unit whichUnit returns nothing
			call SetUnitExploded(whichUnit, true)
			call KillUnit(whichUnit)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local terraindeformation terrainDeformation
			local AJump jump
			/// @todo Do some fights on battlefield?
			if (wait(4.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_1, true, 0.0)
			if (wait(4.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_2, true, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_3, true, 0.0)
			if (wait(3.0)) then
				return
			endif
			// orc guardian views
			call CameraSetupApplyForceDuration(gg_cam_wigberht_4, true, 0.0)
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_5, true, 0.0)
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_6, true, 0.0)
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_7, true, 0.0)
			if (wait(1.0)) then
				return
			endif
			// orc leader view
			call CameraSetupApplyForceDuration(gg_cam_wigberht_8, true, 0.0)
			if (wait(1.0)) then
				return
			endif
			call QueueUnitAnimation(this.m_actorOrcLeader, "Attack")
			call TransmissionFromUnit(this.m_actorOrcLeader, tr("Du elender Hund, dieses Königreich ist dem Untergang geweiht! Was willst du mit deiner kleinen Heerschar schon erreichen?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_3, true, 0.0)
			if (wait(0.50)) then
				return
			endif
			call SetUnitAnimation(AVideo.unitActor(this.m_actorWigberht), "Stand Ready")
			call TransmissionFromUnit(AVideo.unitActor(this.m_actorWigberht), tr("Geh mir aus dem Weg Untier, du bist kein würdiger Gegner für mich!"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_8, true, 0.0)
			call TransmissionFromUnit(this.m_actorOrcLeader, tr("Würdig? Was verstehst du schon von Würde, Mensch?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call SetUnitFacingToFaceUnit(this.m_actorOrcLeader, this.m_orcGuardians.units()[0])
			if (wait(0.50)) then
				return
			endif
			call TransmissionFromUnit(this.m_actorOrcLeader, tr("Tötet den Bastard!"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			// view from sky
			call CameraSetupApplyForceDuration(gg_cam_wigberht_9, true, 0.0)
			call this.m_orcGuardians.forGroup(thistype.setMoveSpeed)
			call SetUnitMoveSpeed(thistype.unitActor(this.m_actorWigberht), thistype.wigberhtMoveSpeed)
			call this.m_orcGuardians.pointOrder("move", GetRectCenterX(gg_rct_video_wigberht_orc_target), GetRectCenterY(gg_rct_video_wigberht_orc_target))
			call IssueRectOrder(AVideo.unitActor(this.m_actorWigberht), "move", gg_rct_video_wigberht_wigberht_target)
			/// @todo Hit them!
			loop
				exitwhen (RectContainsUnit(gg_rct_video_wigberht_wigberht_target, thistype.unitActor(this.m_actorWigberht)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call CameraSetupApplyForceDuration(gg_cam_wigberht_10, true, 0.0)
			call QueueUnitAnimation(thistype.unitActor(this.m_actorWigberht), "Attack Slam")
			if (wait(1.50)) then
				return
			endif
			call QueueUnitAnimation(thistype.unitActor(this.m_actorWigberht), "Stand Ready")
			call CameraSetupApplyForceDuration(gg_cam_wigberht_11, true, 0.0)
			set terrainDeformation = TerrainDeformCrater(GetRectCenterX(gg_rct_video_wigberht_orc_target), GetRectCenterY(gg_rct_video_wigberht_orc_target), 400.0, 200.0, 5, false)
			if (wait(3.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_12, true, 0.0)
			call this.m_orcGuardians.forGroup(thistype.kill)
			if (wait(2.0)) then
				return
			endif
			call TerrainDeformStop(terrainDeformation, 0)
			set terrainDeformation = null
			// move to leader
			call CameraSetupApplyForceDuration(gg_cam_wigberht_8, true, 4.0)
			if (wait(4.0)) then
				return
			endif
			call SetUnitTimeScale(this.m_actorOrcLeader, 0.40)
			call QueueUnitAnimation(this.m_actorOrcLeader, "Attack") // duration (1.0) = 0.40
			call TransmissionFromUnit(this.m_actorOrcLeader, tr("AHHHH!"), null)
			call CameraSetupApplyForceDuration(gg_cam_wigberht_13, true, 4.0)
			if (wait(1.0)) then
				return
			endif
			call SetUnitTimeScale(this.m_actorOrcLeader, 1.0)
			call SetUnitMoveSpeed(this.m_actorOrcLeader, thistype.wigberhtMoveSpeed * 2.0) // faster
			call IssueRectOrder(thistype.unitActor(this.m_actorWigberht), "move", gg_rct_video_wigberht_wigberht_target_2)
			call IssueRectOrder(this.m_actorOrcLeader, "move", gg_rct_video_wigberht_orc_leader_target)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_wigberht_wigberht_target_2, thistype.unitActor(this.m_actorWigberht)))
				if (wait(1.0)) then
					return
				endif
			endloop
			// wigberhts fire attack
			call QueueUnitAnimation(thistype.unitActor(this.m_actorWigberht), "Attack Slam")
			set jump = AJump.create(thistype.unitActor(this.m_actorWigberht), 400.0, GetRectCenterX(gg_rct_video_wigberht_wigberht_target_3), GetRectCenterY(gg_rct_video_wigberht_wigberht_target_3), 0)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_wigberht_wigberht_target_3, thistype.unitActor(this.m_actorWigberht)))
				if (wait(1.0)) then
					return
				endif
			endloop
			
			// flames and kill
			call DestroyEffect(AddSpecialEffect("Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdx", GetRectCenterX(gg_rct_video_wigberht_wigberht_target_3), GetRectCenterY(gg_rct_video_wigberht_wigberht_target_3))) /// \todo direction of orc leader!
			call SetUnitExploded(this.m_actorOrcLeader, true)
			call KillUnit(this.m_actorOrcLeader)
			
			// talk with characters
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.0)) then
				return
			endif
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_wigberht_actor_end)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWigberht), gg_rct_video_wigberht_wigberht_end)
			
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorWigberht))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorWigberht), thistype.actor())

			call CameraSetupApplyForceDuration(gg_cam_wigberht_14, true, 0.0)
			
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.50)) then
				return
			endif

			call TransmissionFromUnit(thistype.unitActor(this.m_actorWigberht), tr("Ihr habt mir bewiesen, dass ihr kämpfen könnt und Mut besitzt. Berichtet dem Herzog, dass wir ihn gegen die Dunkelelfen und Orks unterstützen werden."), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			// TEST
			if (wait(5.0)) then
				return
			endif
			debug call Print("before stop")
			call this.stop()
			debug call Print("After stop")
		endmethod

		private static method groupFunctionRemove takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod

		public stub method onStopAction takes nothing returns nothing
			debug call Print("Wigberht 1")
			call RemoveUnit(this.m_actorOrcLeader)
			debug call Print("Wigberht 2")
			set this.m_actorOrcLeader = null
			debug call Print("Wigberht 3")
			call this.m_staticActors.units().forEach(thistype.groupFunctionRemove)
			debug call Print("Wigberht 4")
			call this.m_staticActors.destroy()
			debug call Print("Wigberht 5")
			call this.m_orcGuardians.units().forEach(thistype.groupFunctionRemove)
			debug call Print("Wigberht 6")
			call this.m_orcGuardians.destroy()
			debug call Print("Wigberht 7")
			debug call Print("Wigberht 8")
			call Game.resetVideoSettings()
			debug call Print("Wigberht 9")
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary
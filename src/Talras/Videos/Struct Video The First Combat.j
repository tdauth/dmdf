/// @todo Finish this video.
library StructMapVideosVideoTheFirstCombat requires Asl, StructGameGame, StructMapMapNpcs, StructMapQuestsQuestTheNorsemen

	struct VideoTheFirstCombat extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private group m_firstActorGroup
		private group m_secondActorGroup
		private group m_firstAllyGroup
		private group m_firstEnemyGroup

		implement Video

		public stub method onInitAction takes nothing returns nothing
			local unit createdUnit
			call Game.initVideoSettings()
			call SetTimeOfDay(5.00)
			call PlayThematicMusic("Music\\TheFirstCombat.mp3")
			call SetSkyModel("Environment\\Sky\\LordaeronSummerSky\\LordaeronSummerSky.mdl")
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_0, true, 0.0)
			
			call SetPlayerAllianceStateBJ(MapData.haldarPlayer, MapData.baldarPlayer, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapData.baldarPlayer, MapData.haldarPlayer, bj_ALLIANCE_UNALLIED)
			
			set this.m_firstActorGroup = CreateGroup()
			set this.m_firstAllyGroup = CreateGroup()
			// Wigberht, 0
			set this.m_actorWigberht = AVideo.saveUnitActor(Npcs.wigberht())
			call SetUnitX(AVideo.unitActor(this.m_actorWigberht), GetRectCenterX(gg_rct_video_the_first_combat_wigberhts_position))
			call SetUnitY(AVideo.unitActor(this.m_actorWigberht), GetRectCenterY(gg_rct_video_the_first_combat_wigberhts_position))
			call SetUnitFacing(AVideo.unitActor(this.m_actorWigberht), 144.91)
			call GroupAddUnit(this.m_firstActorGroup, AVideo.unitActor(this.m_actorWigberht))
			call GroupAddUnit(this.m_firstAllyGroup, Npcs.wigberht())
			// Ricman, 1
			set this.m_actorRicman = AVideo.saveUnitActor(Npcs.ricman())
			call SetUnitX(AVideo.unitActor(this.m_actorRicman), GetRectCenterX(gg_rct_video_the_first_combat_ricmans_position))
			call SetUnitY(AVideo.unitActor(this.m_actorRicman), GetRectCenterY(gg_rct_video_the_first_combat_ricmans_position))
			call SetUnitFacing(AVideo.unitActor(this.m_actorRicman), 151.33)
			call GroupAddUnit(this.m_firstActorGroup, AVideo.unitActor(this.m_actorRicman))
			call GroupAddUnit(this.m_firstAllyGroup, Npcs.ricman())
			//actor, do not add to first ally group!
			call SetUnitX(AVideo.actor(), GetRectCenterX(gg_rct_video_the_first_combat_actors_position))
			call SetUnitY(AVideo.actor(), GetRectCenterY(gg_rct_video_the_first_combat_actors_position))
			call SetUnitFacing(AVideo.actor(), 154.36)
			call GroupAddUnit(this.m_firstActorGroup, AVideo.actor())
			//norseman 0, 2
			call AVideo.saveUnitActor(gg_unit_n01I_0150)
			call SetUnitX(AVideo.unitActor(2), GetRectCenterX(gg_rct_video_the_first_combat_norseman_0_position))
			call SetUnitY(AVideo.unitActor(2), GetRectCenterY(gg_rct_video_the_first_combat_norseman_0_position))
			call SetUnitFacing(AVideo.unitActor(2), 144.28)
			call GroupAddUnit(this.m_firstActorGroup, AVideo.unitActor(2))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0150)
			//norseman 1, 3
			call AVideo.saveUnitActor(gg_unit_n01I_0151)
			call SetUnitX(AVideo.unitActor(3), GetRectCenterX(gg_rct_video_the_first_combat_norseman_1_position))
			call SetUnitY(AVideo.unitActor(3), GetRectCenterY(gg_rct_video_the_first_combat_norseman_1_position))
			call SetUnitFacing(AVideo.unitActor(3), 147.53)
			call GroupAddUnit(this.m_firstActorGroup, AVideo.unitActor(3))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0151)
			//norseman 2, 4
			call AVideo.saveUnitActor(gg_unit_n01I_0152)
			call SetUnitX(AVideo.unitActor(4), GetRectCenterX(gg_rct_video_the_first_combat_norseman_2_position))
			call SetUnitY(AVideo.unitActor(4), GetRectCenterY(gg_rct_video_the_first_combat_norseman_2_position))
			call SetUnitFacing(AVideo.unitActor(4), 131.23)
			call GroupAddUnit(this.m_firstActorGroup, AVideo.unitActor(4))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0152)
			//norseman 3, 5
			call AVideo.saveUnitActor(gg_unit_n01I_0153)
			call SetUnitX(AVideo.unitActor(5), GetRectCenterX(gg_rct_video_the_first_combat_norseman_3_position))
			call SetUnitY(AVideo.unitActor(5), GetRectCenterY(gg_rct_video_the_first_combat_norseman_3_position))
			call SetUnitFacing(AVideo.unitActor(5), 160.94)
			call GroupAddUnit(this.m_firstActorGroup, AVideo.unitActor(5))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0153)

			call AVideo.setActorsMoveSpeed(200.0) // gleich schnell für normale Bewegung
			call thistype.setActorsOwner(MapData.haldarPlayer) // change player to make sure that units do not walk back!
			//orcs and dark elves
			set this.m_secondActorGroup = CreateGroup()
			set this.m_firstEnemyGroup = CreateGroup()
			//orc leader, 6
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01F', gg_rct_video_the_first_combat_orc_leader, 107.04)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(6))
			//orc 0, 7 - Armbrustschütze
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01A', gg_rct_video_the_first_combat_orc_0, 56.55)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(7))
			//orc 1, 8 - Hexer
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n018', gg_rct_video_the_first_combat_orc_1, 224.73)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(8))
			//orc 2, 9 - Krieger
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n019', gg_rct_video_the_first_combat_orc_2, 139.98)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(9))
			//orc 3, 10 - Krieger
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n019', gg_rct_video_the_first_combat_orc_3, 25.90)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(10))
			//orc 4, 11 - Armbrustschütze
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01A', gg_rct_video_the_first_combat_orc_4, 125.81)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(11))
			//orc 5, 12 - Berserkerin
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01G', gg_rct_video_the_first_combat_orc_5, 331.54)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(12))
			//orc 6, 13 - Armbrustschütze
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01A', gg_rct_video_the_first_combat_orc_6, 297.26)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(13))
			//orc 7, 14 - Krieger
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n019', gg_rct_video_the_first_combat_orc_7, 267.69)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(14))
			//dark elf 0, 15 - Waldgeist (männlich)
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01W', gg_rct_video_the_first_combat_dark_elf_0, 316.95)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(15))
			//dark elf 1, 16 - Botin
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01V', gg_rct_video_the_first_combat_dark_elf_1, 99.77)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(16))
			//dark elf 2, 17 - Satyr
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n02O', gg_rct_video_the_first_combat_dark_elf_2, 240.36)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(17))
			//dark elf 3, 18 - Waldgeist (weiblich)
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01X', gg_rct_video_the_first_combat_dark_elf_3, 17.00)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			call AVideo.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, AVideo.unitActor(18))

			call GroupPointOrder(this.m_firstActorGroup, "move", GetRectCenterX(gg_rct_video_the_first_combat_first_target), GetRectCenterY(gg_rct_video_the_first_combat_first_target))
		endmethod
		
		private static method groupFunctionSetHaldar takes nothing returns nothing
			local unit enumUnit = GetEnumUnit()
			call SetUnitOwner(enumUnit, MapData.haldarPlayer, false)
			call SetUnitInvulnerable(enumUnit, false)
			set enumUnit = null
		endmethod
		
		private static method groupFunctionSetBaldar takes nothing returns nothing
			local unit enumUnit = GetEnumUnit()
			call SetUnitOwner(enumUnit, MapData.baldarPlayer, false)
			call SetUnitInvulnerable(enumUnit, false)
			set enumUnit = null
		endmethod

		private static method groupFunctionMoveBehindHill takes nothing returns nothing
			local unit enumUnit = GetEnumUnit()
			call SetUnitX(enumUnit, GetRectCenterX(gg_rct_video_the_first_combat_hill_waiting))
			call SetUnitY(enumUnit, GetRectCenterY(gg_rct_video_the_first_combat_hill_waiting))
			call SetUnitFacing(enumUnit, 270.0)
			set enumUnit = null
		endmethod

		private static method groupFunctionStandVictory takes nothing returns nothing
			local unit enumUnit = GetEnumUnit()
			call SetUnitAnimation(enumUnit, "Stand Victory")
			set enumUnit = null
		endmethod

		private static method groupFunctionLookAtHill takes nothing returns nothing
			local unit enumUnit = GetEnumUnit()
			call SetUnitFacingToFaceRectTimed(enumUnit, gg_rct_video_the_first_combat_battle_field, 3.0)
			set enumUnit = null
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call ForGroup(this.m_firstActorGroup, function thistype.groupFunctionSetHaldar)
			call ForGroup(this.m_secondActorGroup, function thistype.groupFunctionSetBaldar)
			if (wait(3.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_1, true, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_2, true, 0.0)
			if (wait(3.0)) then
				return
			endif
			//filter
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_3, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_4, true, 6.0)
			if (wait(5.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_5, true, 6.0)
			if (wait(5.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_6, true, 6.0)
			if (wait(4.0)) then
				return
			endif
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call ForGroup(this.m_firstActorGroup, function thistype.groupFunctionMoveBehindHill)
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_7, true, 0.0)
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.50, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(2.0)) then
				return
			endif
			call SetUnitMoveSpeed(AVideo.unitActor(this.m_actorWigberht), GetUnitMoveSpeed(AVideo.unitActor(this.m_actorWigberht)) + 50.0)
			call IssuePointOrder(AVideo.unitActor(this.m_actorWigberht), "move", GetRectCenterX(gg_rct_video_the_first_combat_wigberhts_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_wigberhts_hill_target))
			call IssuePointOrder(AVideo.unitActor(this.m_actorRicman), "move", GetRectCenterX(gg_rct_video_the_first_combat_ricmans_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_ricmans_hill_target))
			call IssuePointOrder(AVideo.actor(), "move", GetRectCenterX(gg_rct_video_the_first_combat_actors_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_actors_hill_target))
			call IssuePointOrder(AVideo.unitActor(2), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_0_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_0_hill_target))
			call IssuePointOrder(AVideo.unitActor(3), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_1_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_1_hill_target))
			call IssuePointOrder(AVideo.unitActor(4), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_2_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_2_hill_target))
			call IssuePointOrder(AVideo.unitActor(5), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_3_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_3_hill_target))
			loop
				exitwhen (RectContainsUnit(gg_rct_video_the_first_combat_wigberhts_hill_target, AVideo.unitActor(this.m_actorWigberht)))
				if (wait(1.0)) then
					return
				endif
			endloop
			if (wait(4.0)) then
				return
			endif
			call SetUnitAnimation(AVideo.unitActor(this.m_actorWigberht), "Spell")
			call TransmissionFromUnit(AVideo.unitActor(this.m_actorWigberht), tr("Heil dir, Vater!"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			// Waffen heben und brüllen
			call ForGroup(this.m_firstActorGroup, function thistype.groupFunctionStandVictory)
			call SetUnitAnimation(AVideo.actor(), "Stand Victory 21")
			if (wait(2.0)) then
				return
			endif
			call thistype.setActorsMoveSpeed(200.0)
			call GroupPointOrder(this.m_firstActorGroup, "attack", GetRectCenterX(gg_rct_video_the_first_combat_battle_field), GetRectCenterY(gg_rct_video_the_first_combat_battle_field))
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_8, true, 0.0)
			call ForGroup(this.m_secondActorGroup, function thistype.groupFunctionLookAtHill)
			if (wait(3.0)) then
				return
			endif
			call GroupPointOrder(this.m_secondActorGroup, "attack", GetRectCenterX(gg_rct_video_the_first_combat_battle_field), GetRectCenterY(gg_rct_video_the_first_combat_battle_field))
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_9, true, 0.0)
			if (wait(10.0)) then
				return
			endif
			/// @todo Kampfsequenz so spektakulär wie möglich und nötig machen
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			local AGroup firstAllyGroup = AGroup.create()
			local AGroup firstEnemyGroup = AGroup.create()
			call firstAllyGroup.addGroup(this.m_firstAllyGroup, true, false)
			call firstEnemyGroup.addGroup(this.m_firstEnemyGroup, true, false)
			set this.m_firstActorGroup = null
			set this.m_firstEnemyGroup = null
			// camera bounds reset is unnecessary
			call Game.resetVideoSettings()
			call QuestTheNorsemen.quest().startSpawns(firstAllyGroup, firstEnemyGroup) // don't destroy groups!
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate()
		endmethod
	endstruct

endlibrary
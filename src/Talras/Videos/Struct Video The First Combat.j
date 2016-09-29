library StructMapVideosVideoTheFirstCombat requires Asl, StructGameGame, StructMapMapFellows, StructMapMapNpcs

	struct VideoTheFirstCombat extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		private integer m_actorNorseman0
		private integer m_actorNorseman1
		private integer m_actorNorseman2
		private integer m_actorNorseman3
		private group m_firstActorGroup
		private group m_secondActorGroup
		private group m_firstAllyGroup
		private group m_firstEnemyGroup

		implement Video

		public stub method onInitAction takes nothing returns nothing
			local unit createdUnit
			local integer index
			call Game.initVideoSettings(this)
			call SetTimeOfDay(5.00)
			//call PlayThematicMusic("Music\\TheFirstCombat.mp3")
			call PlayThematicMusic("Music\\mp3Music\\Theyre-Closing-In_Looping.mp3")
			call SetSkyModel("Environment\\Sky\\LordaeronSummerSky\\LordaeronSummerSky.mdl")
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_0, true, 0.0)

			call Fellows.hideDragonSlayerInVideo(this)

			call SetPlayerAllianceStateBJ(MapData.haldarPlayer, MapData.baldarPlayer, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapData.baldarPlayer, MapData.haldarPlayer, bj_ALLIANCE_UNALLIED)

			set this.m_firstActorGroup = CreateGroup()
			set this.m_firstAllyGroup = CreateGroup()
			// Wigberht, 0
			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			call SetUnitX(this.unitActor(this.m_actorWigberht), GetRectCenterX(gg_rct_video_the_first_combat_wigberhts_position))
			call SetUnitY(this.unitActor(this.m_actorWigberht), GetRectCenterY(gg_rct_video_the_first_combat_wigberhts_position))
			call SetUnitFacing(this.unitActor(this.m_actorWigberht), 144.91)
			call GroupAddUnit(this.m_firstActorGroup, this.unitActor(this.m_actorWigberht))
			call GroupAddUnit(this.m_firstAllyGroup, Npcs.wigberht())
			// Ricman, 1
			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())
			call SetUnitX(this.unitActor(this.m_actorRicman), GetRectCenterX(gg_rct_video_the_first_combat_ricmans_position))
			call SetUnitY(this.unitActor(this.m_actorRicman), GetRectCenterY(gg_rct_video_the_first_combat_ricmans_position))
			call SetUnitFacing(this.unitActor(this.m_actorRicman), 151.33)
			call GroupAddUnit(this.m_firstActorGroup, this.unitActor(this.m_actorRicman))
			call GroupAddUnit(this.m_firstAllyGroup, Npcs.ricman())
			// actor, do not add to first ally group!
			call SetUnitX(this.actor(), GetRectCenterX(gg_rct_video_the_first_combat_actors_position))
			call SetUnitY(this.actor(), GetRectCenterY(gg_rct_video_the_first_combat_actors_position))
			call SetUnitFacing(this.actor(), 154.36)
			call GroupAddUnit(this.m_firstActorGroup, this.actor())
			// norseman 0, 2
			set index = this.saveUnitActor(gg_unit_n01I_0150)
			set this.m_actorNorseman0 = index
			call SetUnitX(this.unitActor(index), GetRectCenterX(gg_rct_video_the_first_combat_norseman_0_position))
			call SetUnitY(this.unitActor(index), GetRectCenterY(gg_rct_video_the_first_combat_norseman_0_position))
			call SetUnitFacing(this.unitActor(index), 144.28)
			call GroupAddUnit(this.m_firstActorGroup, this.unitActor(index))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0150)
			// norseman 1, 3
			set index = this.saveUnitActor(gg_unit_n01I_0151)
			set this.m_actorNorseman1 = index
			call SetUnitX(this.unitActor(index), GetRectCenterX(gg_rct_video_the_first_combat_norseman_1_position))
			call SetUnitY(this.unitActor(index), GetRectCenterY(gg_rct_video_the_first_combat_norseman_1_position))
			call SetUnitFacing(this.unitActor(index), 147.53)
			call GroupAddUnit(this.m_firstActorGroup, this.unitActor(index))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0151)
			// norseman 2, 4
			set index = this.saveUnitActor(gg_unit_n01I_0152)
			set this.m_actorNorseman2 = index
			call SetUnitX(this.unitActor(index), GetRectCenterX(gg_rct_video_the_first_combat_norseman_2_position))
			call SetUnitY(this.unitActor(index), GetRectCenterY(gg_rct_video_the_first_combat_norseman_2_position))
			call SetUnitFacing(this.unitActor(index), 131.23)
			call GroupAddUnit(this.m_firstActorGroup, this.unitActor(index))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0152)
			// norseman 3, 5
			set index = this.saveUnitActor(gg_unit_n01I_0153)
			set this.m_actorNorseman3 = index
			call SetUnitX(this.unitActor(index), GetRectCenterX(gg_rct_video_the_first_combat_norseman_3_position))
			call SetUnitY(this.unitActor(index), GetRectCenterY(gg_rct_video_the_first_combat_norseman_3_position))
			call SetUnitFacing(this.unitActor(index), 160.94)
			call GroupAddUnit(this.m_firstActorGroup, this.unitActor(index))
			call GroupAddUnit(this.m_firstAllyGroup, gg_unit_n01I_0153)

			call this.setActorsMoveSpeed(200.0) // gleich schnell für normale Bewegung
			call this.setActorsOwner(MapData.haldarPlayer) // change player to make sure that units do not walk back!
			// orcs and dark elves
			set this.m_secondActorGroup = CreateGroup()
			set this.m_firstEnemyGroup = CreateGroup()
			// orc leader, 6
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01F', gg_rct_video_the_first_combat_orc_leader, 107.04)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 0, 7 - Armbrustschütze
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01A', gg_rct_video_the_first_combat_orc_0, 56.55)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 1, 8 - Hexer
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n018', gg_rct_video_the_first_combat_orc_1, 224.73)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 2, 9 - Krieger
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n019', gg_rct_video_the_first_combat_orc_2, 139.98)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 3, 10 - Krieger
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n019', gg_rct_video_the_first_combat_orc_3, 25.90)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 4, 11 - Armbrustschütze
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01A', gg_rct_video_the_first_combat_orc_4, 125.81)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 5, 12 - Berserkerin
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01G', gg_rct_video_the_first_combat_orc_5, 331.54)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 6, 13 - Armbrustschütze
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01A', gg_rct_video_the_first_combat_orc_6, 297.26)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// orc 7, 14 - Krieger
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n019', gg_rct_video_the_first_combat_orc_7, 267.69)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// dark elf 0, 15 - Waldgeist (männlich)
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01W', gg_rct_video_the_first_combat_dark_elf_0, 316.95)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// dark elf 1, 16 - Botin
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01V', gg_rct_video_the_first_combat_dark_elf_1, 99.77)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// dark elf 2, 17 - Satyr
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n02O', gg_rct_video_the_first_combat_dark_elf_2, 240.36)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))
			// dark elf 3, 18 - Waldgeist (weiblich)
			set createdUnit = CreateUnitAtRect(MapData.baldarPlayer, 'n01X', gg_rct_video_the_first_combat_dark_elf_3, 17.00)
			call GroupAddUnit(this.m_firstEnemyGroup, createdUnit)
			set index = this.saveUnitActor(createdUnit)
			set createdUnit = null
			call GroupAddUnit(this.m_secondActorGroup, this.unitActor(index))

			call GroupPointOrder(this.m_firstActorGroup, "move", GetRectCenterX(gg_rct_video_the_first_combat_first_target), GetRectCenterY(gg_rct_video_the_first_combat_first_target))
		endmethod

		private static method groupFunctionSetHaldar takes nothing returns nothing
			call SetUnitOwner(GetEnumUnit(), MapData.haldarPlayer, false)
			call SetUnitInvulnerable(GetEnumUnit(), false)
		endmethod

		private static method groupFunctionSetBaldar takes nothing returns nothing
			call SetUnitOwner(GetEnumUnit(), MapData.baldarPlayer, false)
			call SetUnitInvulnerable(GetEnumUnit(), false)
		endmethod

		private static method groupFunctionStandVictory takes nothing returns nothing
			call SetUnitAnimation(GetEnumUnit(), "Stand Victory")
			call PlaySoundBJ(gg_snd_BattleRoar)
		endmethod

		private static method groupFunctionLookAtHill takes nothing returns nothing
			call SetUnitFacingToFaceRectTimed(GetEnumUnit(), gg_rct_video_the_first_combat_battle_field, 1.30)
		endmethod

		private static method groupFunctionAttack takes nothing returns nothing
			call SetUnitAnimation(GetEnumUnit(), "Attack")
			call PlaySoundBJ(gg_snd_BattleRoar)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call thistype.fixCamera(gg_cam_the_first_combat_0)

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
			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_3, true, 0.0)
			call Game.fadeIn()
			if (wait(3.0)) then
				return
			endif

			call Game.fadeOutWithWait()

			// place everyone at distinct position to prevent blocking each other
			call SetUnitPositionRectFacing(this.unitActor(this.m_actorNorseman0), gg_rct_video_the_first_combat_norseman_0_hill_waiting, 270.0)
			call SetUnitPositionRectFacing(this.unitActor(this.m_actorNorseman1), gg_rct_video_the_first_combat_norseman_1_hill_waiting, 270.0)
			call SetUnitPositionRectFacing(this.actor(), gg_rct_video_the_first_combat_actors_hill_waiting, 270.0)
			call SetUnitPositionRectFacing(this.unitActor(this.m_actorWigberht), gg_rct_video_the_first_combat_wigberhts_hill_waiting, 270.0)
			call SetUnitPositionRectFacing(this.unitActor(this.m_actorRicman), gg_rct_video_the_first_combat_ricmans_hill_waiting, 270.0)
			call SetUnitPositionRectFacing(this.unitActor(this.m_actorNorseman2), gg_rct_video_the_first_combat_norseman_2_hill_waiting, 270.0)
			call SetUnitPositionRectFacing(this.unitActor(this.m_actorNorseman3), gg_rct_video_the_first_combat_norseman_3_hill_waiting, 270.0)

			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_7, true, 0.0)
			call Game.fadeIn()
			if (wait(2.0)) then
				return
			endif
			/*
			 * Make Wigberht the first to be standing on the hill.
			 */
			call SetUnitMoveSpeed(this.unitActor(this.m_actorWigberht), GetUnitMoveSpeed(this.unitActor(this.m_actorWigberht)) + 50.0)
			call IssuePointOrder(this.unitActor(this.m_actorWigberht), "move", GetRectCenterX(gg_rct_video_the_first_combat_wigberhts_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_wigberhts_hill_target))
			// TODO ricman or someone runs back
			call IssuePointOrder(this.unitActor(this.m_actorRicman), "move", GetRectCenterX(gg_rct_video_the_first_combat_ricmans_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_ricmans_hill_target))
			call IssuePointOrder(this.actor(), "move", GetRectCenterX(gg_rct_video_the_first_combat_actors_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_actors_hill_target))
			call IssuePointOrder(this.unitActor(this.m_actorNorseman0), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_0_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_0_hill_target))
			call IssuePointOrder(this.unitActor(this.m_actorNorseman1), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_1_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_1_hill_target))
			call IssuePointOrder(this.unitActor(this.m_actorNorseman2), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_2_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_2_hill_target))
			call IssuePointOrder(this.unitActor(this.m_actorNorseman3), "move", GetRectCenterX(gg_rct_video_the_first_combat_norseman_3_hill_target), GetRectCenterY(gg_rct_video_the_first_combat_norseman_3_hill_target))
			loop
				exitwhen (RectContainsUnit(gg_rct_video_the_first_combat_wigberhts_hill_target, this.unitActor(this.m_actorWigberht)))
				if (wait(1.0)) then
					return
				endif
			endloop
			if (wait(4.0)) then
				return
			endif
			call SetUnitAnimation(this.unitActor(this.m_actorWigberht), "Spell")
			call TransmissionFromUnit(this.unitActor(this.m_actorWigberht), tre("Heil dir, Vater!", "Hail father!"), gg_snd_Wigberht38)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht38))) then
				return
			endif
			// Waffen heben und brüllen
			call ForGroup(this.m_firstActorGroup, function thistype.groupFunctionStandVictory)
			//call SetUnitAnimation(this.actor(), "Stand Victory 21")
			call SetUnitAnimationByIndex(this.actor(), 21)
			if (wait(GetSoundDurationBJ(gg_snd_BattleRoar))) then
				return
			endif
			call this.setActorsMoveSpeed(200.0)
			call GroupPointOrder(this.m_firstActorGroup, "attack", GetRectCenterX(gg_rct_video_the_first_combat_battle_field), GetRectCenterY(gg_rct_video_the_first_combat_battle_field))
			if (wait(1.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_8, true, 0.0)
			call ForGroup(this.m_secondActorGroup, function thistype.groupFunctionLookAtHill)
			if (wait(2.0)) then
				return
			endif

			call ForGroup(this.m_secondActorGroup, function thistype.groupFunctionAttack)
			if (wait(GetSoundDurationBJ(gg_snd_BattleRoar))) then
				return
			endif

			// make sure the players can hear the battle
			call VolumeGroupSetVolumeBJ(SOUND_VOLUMEGROUP_COMBAT, 100.0)
			call VolumeGroupSetVolumeBJ(SOUND_VOLUMEGROUP_SPELLS, 100.0)
			call GroupPointOrder(this.m_secondActorGroup, "attack", GetRectCenterX(gg_rct_video_the_first_combat_battle_field), GetRectCenterY(gg_rct_video_the_first_combat_battle_field))
			if (wait(2.0)) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_the_first_combat_9, true, 0.0)
			if (wait(10.0)) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			local AGroup firstAllyGroup = AGroup.create()
			local AGroup firstEnemyGroup = AGroup.create()
			call firstAllyGroup.addGroup(this.m_firstAllyGroup, true, false)
			call firstEnemyGroup.addGroup(this.m_firstEnemyGroup, true, false)
			set this.m_firstActorGroup = null
			set this.m_firstEnemyGroup = null

			call SetUnitInvulnerable(gg_unit_n01I_0150, false)
			call SetUnitInvulnerable(gg_unit_n01I_0151, false)
			call SetUnitInvulnerable(gg_unit_n01I_0152, false)
			call SetUnitInvulnerable(gg_unit_n01I_0153, false)

			// camera bounds reset is unnecessary
			call Game.resetVideoSettings()
			call QuestTheNorsemen.quest.evaluate().startSpawns.evaluate(firstAllyGroup, firstEnemyGroup) // don't destroy groups!
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapData.neutralPassivePlayer)

			return this
		endmethod
	endstruct

endlibrary
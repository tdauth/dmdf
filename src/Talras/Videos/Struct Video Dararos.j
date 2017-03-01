library StructMapVideosVideoDararos requires Asl, StructGameGame

	// TODO Dararos erscheint mit einer Armee von Hochelfen im letzten Moment.
	struct VideoDararos extends AVideo
		private unit m_actorDararos
		private AGroup m_highElfWarriors
		private AGroup m_highElfArchers
		private unit m_norseman0
		private unit m_orc0

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(24.0)

			set this.m_actorDararos = this.unitActor(this.saveUnitActor(Npcs.dararos()))
			call SetUnitPositionRect(this.m_actorDararos, gg_rct_video_dararos_dararos)
			call SetUnitFacing(this.m_actorDararos, 0.0)

			// 12 like for the quest
			set this.m_highElfWarriors = AGroup.create()
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))
			call this.m_highElfWarriors.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'h02H', gg_rct_video_dararos_high_elves_warriors, 0.0)))

			set this.m_highElfArchers = AGroup.create()
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))
			call this.m_highElfArchers.units().pushBack(this.unitActor(this.createUnitActorAtRect(MapSettings.alliedPlayer(), 'n05I', gg_rct_video_dararos_high_elves_archers, 0.0)))

			call CameraSetupApplyForceDuration(gg_cam_dararos_0, true, 0.0)
			call CameraSetupApplyForceDuration(gg_cam_dararos_1, true, 4.0)

			// TODO the final ultimate battle
			set this.m_norseman0 = this.unitActor(this.createUnitActorAtRect(MapData.haldarPlayer, 'n01I', gg_rct_video_dararos_norseman_0, 0.0))
			call SetUnitInvulnerable(this.m_norseman0, false)
			set this.m_orc0 = this.unitActor(this.createUnitActorAtRect(MapData.baldarPlayer, 'n058', gg_rct_video_dararos_orc_0, 0.0))
			call SetUnitInvulnerable(this.m_orc0, false)
			call IssueTargetOrder(this.m_norseman0, "attack", this.m_orc0)
			call IssueTargetOrder(this.m_orc0, "attack", this.m_norseman0)
			call UnitAddAbility(this.m_norseman0, 'AZU7')
			call UnitAddAbility(this.m_orc0, 'AZU7')
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_dararos_0)
			call CameraSetupApplyForceDuration(gg_cam_dararos_1, true, 4.0)

			if (wait(2.0)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dararos_2, true, 4.0)

			if (wait(3.50)) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_dararos_3, true, 4.0)

			if (wait(3.50)) then
				return
			endif

			// TODO arrival of the highelves

			call QueueUnitAnimation(this.m_actorDararos, "Spell")

			call TransmissionFromUnitWithName(this.m_actorDararos, tre("Dararos", "Dararos"), tre("Auf meine Krieger, auf ihr Hochelfen! Helft unseren Brüdern in ihrer Not und vertreibt die abtrünnigen Dunkelelfen und die Horden der Orks aus diesem Königreich!", "On my warriors, on you High Elves! Help our brothers in their distress and drive out the renegade Dark Elves and the horde of Orcs from this kingdom!"), gg_snd_Dararos1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Dararos1))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary
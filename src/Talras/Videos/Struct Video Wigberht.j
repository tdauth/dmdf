/// @todo Finish this video.
library StructMapVideosVideoWigberht requires Asl, StructGameGame, StructMapMapFellows

	struct VideoWigberht extends AVideo
		private static constant real wigberhtMoveSpeed = 200.0
		private static constant real orcMoveSpeed = 120.0 // make them much slower than Wigberht
		private integer m_actorWigberht
		private integer m_actorRicman
		private unit m_actorOrcLeader
		private AGroup m_staticActors
		private AGroup m_orcGuardians
		private AGroup m_hiddenCorpses
		private trigger m_killTrigger

		implement Video
		
		private static method filterIsDead takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit())
		endmethod
		
		private static method groupFunctionHide takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, false)
		endmethod
		
		private static method holdPosition takes unit whichUnit returns nothing
			call IssueImmediateOrder(whichUnit, "holdposition")
		endmethod
		
		private method allGuardsAreDead takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_orcGuardians.units().size())
				if (not IsUnitDeadBJ(this.m_orcGuardians.units()[i])) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod
		
		private static method triggerConditionKill takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this"))
			if (this.m_orcGuardians.units().contains(GetTriggerUnit()) and GetEventDamageSource() == thistype.unitActor(this.m_actorWigberht)) then
				call KillUnit(GetTriggerUnit())
				call DestroyEffect(AddSpecialEffect("Models\\Effects\\BloodExplosionSpecial1.mdx", GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit())))
				/*
				 * Don't run further.
				 */
				if (this.allGuardsAreDead()) then
					call IssueImmediateOrder(thistype.unitActor(this.m_actorWigberht), "holdposition")
				endif
			endif
			
			return false
		endmethod

		public stub method onInitAction takes nothing returns nothing
			local integer i
			call Game.initVideoSettings()
			
			// it should be destroyed at this point but not when debugging, make sure it is hidden
			if (SpawnPoints.orcs0() != 0) then
				call SpawnPoints.orcs0().disable()
				set i = 0
				loop
					exitwhen (i == SpawnPoints.orcs0().countUnits())
					debug call Print("Pausing and hiding orc spawn point unit: " + GetUnitName(SpawnPoints.orcs0().unit(i)))
					call PauseUnit(SpawnPoints.orcs0().unit(i), true)
					call ShowUnit(SpawnPoints.orcs0().unit(i), false)
					set i = i + 1
				endloop
			endif
			
			call SetTimeOfDay(20.00)
			call PlayThematicMusic("Music\\Wigberht.mp3")
			call CameraSetupApplyForceDuration(gg_cam_wigberht_0, true, 0.0)
			
			call Fellows.hideDragonSlayerInVideo()
			
			call SetPlayerAllianceStateBJ(MapData.haldarPlayer, MapData.baldarPlayer, bj_ALLIANCE_UNALLIED)
			call SetPlayerAllianceStateBJ(MapData.baldarPlayer, MapData.haldarPlayer, bj_ALLIANCE_UNALLIED)
			
			set this.m_hiddenCorpses = AGroup.create()
			call this.m_hiddenCorpses.addUnitsInRect(gg_rct_video_wigberht_corpse_free_area, Filter(function thistype.filterIsDead))
			call this.m_hiddenCorpses.forGroup(thistype.groupFunctionHide)
			
			set this.m_actorWigberht = thistype.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWigberht), gg_rct_video_wigberht_wigberhts_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorWigberht), 90.0)
			call SetUnitOwner(thistype.unitActor(this.m_actorWigberht), MapData.haldarPlayer, false)
			call PauseUnit(thistype.unitActor(this.m_actorWigberht), true)
			call SetUnitAnimation(thistype.unitActor(this.m_actorWigberht), "Stand Ready")
			
			set this.m_actorRicman = thistype.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorRicman), gg_rct_video_wigberht_ricmans_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorRicman), 342.35)
			call UnitRemoveAbility(thistype.unitActor(this.m_actorRicman), 'Aneu') // disable arrow
			call SetUnitOwner(thistype.unitActor(this.m_actorRicman), MapData.haldarPlayer, false)
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_wigberht_actors_position)
			call SetUnitFacing(thistype.actor(), 206.90)
			call IssueImmediateOrder(thistype.actor(), "holdposition")

			set this.m_staticActors = AGroup.create()
			set this.m_orcGuardians = AGroup.create()
			
			// create norsemen
			// create rangers
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.haldarPlayer, UnitTypes.ranger, gg_rct_video_wigberht_ranger_0_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.haldarPlayer, UnitTypes.ranger, gg_rct_video_wigberht_ranger_1_position, GetRandomFacing()))
			// create farmers
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.haldarPlayer, UnitTypes.armedVillager, gg_rct_video_wigberht_farmer_0_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.haldarPlayer, UnitTypes.armedVillager, gg_rct_video_wigberht_farmer_1_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.haldarPlayer, UnitTypes.armedVillager, gg_rct_video_wigberht_farmer_2_position, GetRandomFacing()))

			// create corpses
			// NOTE norsemen and orcs have no decay animations! Corpses do not work.
			// Following types have decay animations: orcCrossbow, ranger, armedVillager
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.haldarPlayer, UnitTypes.ranger, gg_rct_video_wigberht_corpse_0_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.haldarPlayer, UnitTypes.ranger, gg_rct_video_wigberht_corpse_1_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.haldarPlayer, UnitTypes.armedVillager, gg_rct_video_wigberht_corpse_2_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.haldarPlayer, UnitTypes.armedVillager, gg_rct_video_wigberht_corpse_3_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.haldarPlayer, UnitTypes.armedVillager, gg_rct_video_wigberht_corpse_4_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.haldarPlayer, UnitTypes.armedVillager, gg_rct_video_wigberht_corpse_5_position, GetRandomFacing()))
			
			// change the owner of actor and ricman to haldar that they participate in fighting
			call thistype.setActorsOwner(MapData.haldarPlayer) // change player to make sure that units do not walk back!
			
			// create fighting orcs
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_fighting_position_0, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_fighting_position_1, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_fighting_position_2, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_fighting_position_3, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_fighting_position_4, GetRandomFacing()))
			
			// create corpses
			// NOTE norsemen and orcs have no decay animations! Corpses do not work.
			// Following types have decay animations: orcCrossbow, ranger, armedVillager
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_6_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_7_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_8_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_9_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_10_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_11_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_12_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_13_position, GetRandomFacing()))
			call this.m_staticActors.units().pushBack(CreateCorpseAtRect(MapData.baldarPlayer, UnitTypes.orcCrossbow, gg_rct_video_wigberht_corpse_14_position, GetRandomFacing()))
			
			// create orcs with leader
			set this.m_actorOrcLeader = CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcLeader, gg_rct_video_wigberht_orc_leaders_position, 237.39)
			call IssueImmediateOrder(this.m_actorOrcLeader, "holdposition")
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_0, 308.79))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_1, 200.36))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_2, 327.94))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_3, 160.66))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_4, 250.86))
			call this.m_orcGuardians.units().pushBack(CreateUnitAtRect(MapData.baldarPlayer, UnitTypes.orcWarrior, gg_rct_video_wigberht_orc_guardian_5, 215.00))
			call this.m_orcGuardians.forGroup(thistype.holdPosition)
			set this.m_killTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == this.m_orcGuardians.units().size())
				call SetUnitFacingToFaceUnit(this.m_orcGuardians.units()[i], thistype.unitActor(this.m_actorWigberht))
				call TriggerRegisterUnitEvent(this.m_killTrigger, this.m_orcGuardians.units()[i], EVENT_UNIT_DAMAGED)
				set i = i + 1
			endloop
			call TriggerAddCondition(this.m_killTrigger, Condition(function thistype.triggerConditionKill))
			call DmdfHashTable.global().setHandleInteger(this.m_killTrigger, "this", this)
		endmethod

		private static method setMoveSpeed takes unit whichUnit returns nothing
			call SetUnitMoveSpeed(whichUnit, thistype.orcMoveSpeed)
		endmethod

		private method firstLivingGuard takes nothing returns unit
			local integer i = 0
			loop
				exitwhen (i == this.m_orcGuardians.units().size())
				if (not IsUnitDeadBJ(this.m_orcGuardians.units()[i])) then
					return this.m_orcGuardians.units()[i]
				endif
				set i = i + 1
			endloop
			
			return null
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			local effect whichEffect // TODO leaks on stop
			local AJump jump // TODO leaks on stop
			
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
			call TransmissionFromUnit(this.m_actorOrcLeader, tre("Du elender Hund, dieses Königreich ist dem Untergang geweiht! Was willst du mit deiner kleinen Heerschar schon erreichen?", "You miserable dog, this kingdom is doomed! What do you want to achieve with your little army?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_3, true, 0.0)
			if (wait(0.50)) then
				return
			endif
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorWigberht), tr("Wigberht"), tre("Geh mir aus dem Weg Untier, du bist kein würdiger Gegner für mich!", "Get out of my way beast, you're not a dignified opponent for me!"), gg_snd_Wigberht39)
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht39))) then
				return
			endif
			call CameraSetupApplyForceDuration(gg_cam_wigberht_8, true, 0.0)
			call TransmissionFromUnit(this.m_actorOrcLeader, tre("Was verstehst du schon von Würde, Mensch?", "What do you know about dignity, human?"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			call SetUnitFacingToFaceUnitTimed(this.m_actorOrcLeader, this.m_orcGuardians.units()[0], 0.30)
			if (wait(0.50)) then
				return
			endif
			call TransmissionFromUnit(this.m_actorOrcLeader, tre("Tötet den Bastard!", "Kill the bastard!"), null)
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			// view from sky
			call CameraSetupApplyForceDuration(gg_cam_wigberht_9, true, 0.0)
			// make them much slower than Wigberht that he reaches his target before tham and makes his attack
			call this.m_orcGuardians.forGroup(thistype.setMoveSpeed)
			call PauseUnit(thistype.unitActor(this.m_actorWigberht), false)
			call SetUnitInvulnerable(thistype.unitActor(this.m_actorWigberht), false)
			call SetUnitMoveSpeed(thistype.unitActor(this.m_actorWigberht), thistype.wigberhtMoveSpeed)
			if (not this.m_orcGuardians.targetOrder("attack", thistype.unitActor(this.m_actorWigberht))) then
				debug call Print("ORDER FAIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIILED")
			endif
			call IssueTargetOrder(thistype.unitActor(this.m_actorWigberht), "attack",  this.m_orcGuardians.units().front())

			loop
				exitwhen (this.allGuardsAreDead())
				
				if (GetUnitCurrentOrder(thistype.unitActor(this.m_actorWigberht)) != OrderId("attack")) then
					call IssueTargetOrder(thistype.unitActor(this.m_actorWigberht), "attack",  this.firstLivingGuard())
				endif
				if (wait(1.0)) then
					return
				endif
			endloop
			
			call CameraSetupApplyForceDuration(gg_cam_wigberht_10, true, 0.0)
			
			if (wait(1.0)) then
				return
			endif
			// face back to wigberht before attacking
			call SetUnitFacingToFaceUnit(this.m_actorOrcLeader, thistype.unitActor(this.m_actorWigberht))
			// move to leader
			call CameraSetupApplyForceDuration(gg_cam_wigberht_8, true, 4.0)
			if (wait(4.0)) then
				return
			endif
			call SetUnitTimeScale(this.m_actorOrcLeader, 0.40)
			call QueueUnitAnimation(this.m_actorOrcLeader, "Attack") // duration (1.0) = 0.40
			call TransmissionFromUnit(this.m_actorOrcLeader, tre("AHHHH!", "AHHHH!"), null)
			call CameraSetupApplyForceDuration(gg_cam_wigberht_13, true, 4.0)
			if (wait(1.0)) then
				return
			endif
			call SetUnitTimeScale(this.m_actorOrcLeader, 1.0)
			call SetUnitMoveSpeed(this.m_actorOrcLeader, thistype.wigberhtMoveSpeed * 1.2) // faster
			call IssueRectOrder(thistype.unitActor(this.m_actorWigberht), "move", gg_rct_video_wigberht_wigberht_target_2)
			call IssueRectOrder(this.m_actorOrcLeader, "move", gg_rct_video_wigberht_orc_leader_target)
			loop
				exitwhen (RectContainsUnit(gg_rct_video_wigberht_wigberht_target_2, thistype.unitActor(this.m_actorWigberht)))
				if (wait(1.0)) then
					return
				endif
			endloop
			call IssueImmediateOrder(thistype.unitActor(this.m_actorWigberht), "holdposition")
			call IssueImmediateOrder(this.m_actorOrcLeader, "holdposition")
			// wigberhts fire attack
			call SetUnitTimeScale(thistype.unitActor(this.m_actorWigberht), 0.80)
			call SetUnitTimeScale(this.m_actorOrcLeader, 0.80)
			set jump = AJump.create(thistype.unitActor(this.m_actorWigberht), 400.0, GetRectCenterX(gg_rct_video_wigberht_wigberht_target_3), GetRectCenterY(gg_rct_video_wigberht_wigberht_target_3), 0, 100.0)
			call SetUnitAnimation(thistype.unitActor(this.m_actorWigberht), "Attack Slam")
			loop
				exitwhen (RectContainsUnit(gg_rct_video_wigberht_wigberht_target_3, thistype.unitActor(this.m_actorWigberht)))
				if (wait(1.0)) then
					return
				endif
			endloop
			
			if (wait(1.0)) then
				return
			endif

			call QueueUnitAnimation(thistype.unitActor(this.m_actorWigberht), "Spell Alternate")
			
			// flames and kill
			set whichEffect = AddSpecialEffect("Abilities\\Spells\\Other\\BreathOfFire\\BreathOfFireMissile.mdx", GetRectCenterX(gg_rct_video_wigberht_wigberht_target_3), GetRectCenterY(gg_rct_video_wigberht_wigberht_target_3)) /// \todo direction of orc leader!
			//call SetUnitExploded(this.m_actorOrcLeader, true)
			call KillUnit(this.m_actorOrcLeader)
			
			if (wait(2.0)) then
				return
			endif
			
			call DestroyEffect(whichEffect)
			set whichEffect = null
			call QueueUnitAnimation(thistype.unitActor(this.m_actorWigberht), "Spell")
			
			if (wait(2.0)) then
				return
			endif

			// talk with characters
			call CinematicFadeBJ(bj_CINEFADETYPE_FADEOUT, 1.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			if (wait(1.0)) then
				return
			endif
			
			call SetUnitPositionRect(thistype.actor(), gg_rct_video_wigberht_actor_end)
			call IssueImmediateOrder(thistype.actor(), "holdposition")
			call SetUnitPositionRect(thistype.unitActor(this.m_actorRicman), gg_rct_video_wigberht_ricman_end)
			call IssueImmediateOrder(thistype.unitActor(this.m_actorRicman), "holdposition")
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWigberht), gg_rct_video_wigberht_wigberht_end)
			call IssueImmediateOrder(thistype.unitActor(this.m_actorWigberht), "holdposition")
			call ResetUnitAnimation(thistype.unitActor(this.m_actorWigberht))

			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorWigberht))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorWigberht), thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorRicman), thistype.actor())

			call CameraSetupApplyForceDuration(gg_cam_wigberht_14, true, 0.0)
			
			if (wait(1.0)) then
				return
			endif

			call CinematicFadeBJ(bj_CINEFADETYPE_FADEIN, 1.0, "ReplaceableTextures\\CameraMasks\\Black_mask.blp", 100.00, 100.00, 100.00, 0.0)
			
			if (wait(1.50)) then
				return
			endif

			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorWigberht), tr("Wigberht"), tr("Ihr habt mir bewiesen, dass ihr kämpfen könnt und Mut besitzt. Berichtet dem Herzog, dass wir ihn gegen die Dunkelelfen und Orks unterstützen werden."), gg_snd_Wigberht40)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht40))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorWigberht), tr("Wigberht"), tr("Danach begeben wir uns weiter auf die Suche nach meinem Vater. Sollten jedoch keine Feinde eintreffen, so müssen wir irgendwann aufbrechen."), gg_snd_Wigberht41)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht41))) then
				return
			endif

			call this.stop()
		endmethod

		private static method groupFunctionRemove takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod
		
		private static method groupFunctionShow takes unit whichUnit returns nothing
			call ShowUnit(whichUnit, true)
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call this.m_hiddenCorpses.forGroup(thistype.groupFunctionShow)
			call this.m_hiddenCorpses.destroy()
			set this.m_hiddenCorpses = 0
		
			call RemoveUnit(this.m_actorOrcLeader)
			set this.m_actorOrcLeader = null
			call this.m_staticActors.forGroup(thistype.groupFunctionRemove)
			call this.m_staticActors.destroy()
			call this.m_orcGuardians.forGroup(thistype.groupFunctionRemove)
			call this.m_orcGuardians.destroy()
			call DmdfHashTable.global().destroyTrigger(this.m_killTrigger)
			set this.m_killTrigger = null
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary
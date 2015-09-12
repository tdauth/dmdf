/*
Ricman: Männer, macht euch bereit für euer letztes Gefecht. Heute mag der Tag gekommen sein, da wir allesamt das Zeitliche segnen, doch vorher zahlen wir es diesen Bastarden heim.
Ricman: Wenn ihr sterben solltet, seid euch gewiss ihr seid ehrenvoll gestorben wenn eure Klinge vom Blute von mindestens zwanzig Dunkelelfen bedeckt ist.
Ricman: Ihr wisst sie haben uns unseren König genommen, dafür nehmen wir ihnen das Leben! Schlachtet sie ab, lasst keinen am Leben!
Ricman: Auf dann, ein letztes Mal vor dem Morgengrauen! Kämpft für euren König, für seinen Sohn Wigberht, für die Ehre und für den Norden!
*/
library StructMapVideosVideoTheDefenseOfTalras requires Asl, StructGameGame

	struct VideoTheDefenseOfTalras extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		private AGroup m_warriors
		private unit m_villager0
		private unit m_villager1

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			/*
			 * Abenddämmerung
			 */
			call SetTimeOfDay(20.0)
			
			set this.m_actorWigberht = thistype.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWigberht), gg_rct_video_the_defense_of_talras_wigberht)
			set this.m_actorRicman = thistype.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorRicman), gg_rct_video_the_defense_of_talras_ricman)
			set this.m_actorDragonSlayer = thistype.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorDragonSlayer), gg_rct_video_the_defense_of_talras_dragon_slayer)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_the_defense_of_talras_actor)
			
			set this.m_warriors = AGroup.create()
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n01I', MapData.baldarPlayer, gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n015', MapData.baldarPlayer, gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n005', MapData.baldarPlayer, gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n03H', MapData.baldarPlayer, gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			set this.m_villager0 = this.m_warriors.units().back()
			set this.m_villager1 = this.m_warriors.units()[this.m_warriors.units().size() - 2]
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n03F', MapData.baldarPlayer, gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorRicman), this.m_warriors.units().front())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorWigberht), thistype.unitActor(this.m_actorRicman))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorDragonSlayer), thistype.unitActor(this.m_actorRicman))
			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorRicman))
		
			call CameraSetupApplyForceDuration(gg_cam_the_defense_of_talras_0, true, 0.0)
		endmethod
		
		private static method forGroupRoar takes unit whichUnit returns nothing
			call PlaySoundBJ(gg_snd_BattleRoar)
			call SetUnitAnimation(whichUnit, "Stand Victory")
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			// TODO Finish this video
			
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorRicman), tr("Ricman"), tr("Männer, macht euch bereit für euer letztes Gefecht. Heute mag der Tag gekommen sein, da wir allesamt das Zeitliche segnen, doch vorher zahlen wir es diesen Bastarden heim."), gg_snd_RicmanTheDefenseOfTalrasRicman1)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			/*
			 * Battle roar
			 */
			call this.m_warriors.forGroup(thistype.forGroupRoar)

			
			if (wait(GetSoundDurationBJ(gg_snd_BattleRoar) + 2.0)) then // wait until end
				return
			endif
			
			call TransmissionFromUnit(this.m_villager0, tr("Wo ist der Herzog?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_villager0, tr("Ich will nach Hause! Wir werden sowieso nicht bezahlt!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(this.m_villager1, tr("Ruhe!"), null)
			
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod
		
		private static method forGroupRemove takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_villager0 = null
			set this.m_villager1 = null
			call this.m_warriors.forGroup(thistype.forGroupRemove)
			call this.m_warriors.destroy()
			set this.m_warriors = 0
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary
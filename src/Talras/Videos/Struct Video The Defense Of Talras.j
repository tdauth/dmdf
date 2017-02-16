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

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			/*
			 * Abenddämmerung
			 */
			call SetTimeOfDay(20.0)

			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_the_defense_of_talras_wigberht)
			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(this.unitActor(this.m_actorRicman), gg_rct_video_the_defense_of_talras_ricman)
			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(this.unitActor(this.m_actorDragonSlayer), gg_rct_video_the_defense_of_talras_dragon_slayer)

			call SetUnitPositionRect(this.actor(), gg_rct_video_the_defense_of_talras_actor)

			set this.m_warriors = AGroup.create()
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n01I', MapSettings.neutralPassivePlayer(), gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n015', MapSettings.neutralPassivePlayer(), gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n005', MapSettings.neutralPassivePlayer(), gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n03H', MapSettings.neutralPassivePlayer(), gg_rct_video_the_defense_of_talras_warriors, 270), true, false)
			set this.m_villager0 = this.m_warriors.units().back()
			set this.m_villager1 = this.m_warriors.units()[this.m_warriors.units().size() - 2]
			call this.m_warriors.addGroup(CreateUnitsAtRect(3, 'n03F', MapSettings.neutralPassivePlayer(), gg_rct_video_the_defense_of_talras_warriors, 270), true, false)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.m_warriors.units().front())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorRicman))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDragonSlayer), this.unitActor(this.m_actorRicman))
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorRicman))

			call CameraSetupApplyForceDuration(gg_cam_the_defense_of_talras_0, true, 0.0)
		endmethod

		private static method forGroupRoar takes unit whichUnit returns nothing
			call PlaySoundBJ(gg_snd_BattleRoar)
			call SetUnitAnimation(whichUnit, "Stand Victory")
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_the_defense_of_talras_0)

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorRicman), tre("Ricman", "Ricman"), tre("Männer, macht euch bereit für euer letztes Gefecht. Heute mag der Tag gekommen sein, da wir allesamt das Zeitliche segnen, doch vorher zahlen wir es diesen Bastarden heim.", "Men, get ready for your last battle. Today the day may have come that we all will die but before that we pay it back to these bastards."), gg_snd_RicmanTheDefenseOfTalrasRicman1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanTheDefenseOfTalrasRicman1))) then
				return
			endif

			/*
			 * Battle roar
			 */
			call this.m_warriors.forGroup(thistype.forGroupRoar)


			if (wait(GetSoundDurationBJ(gg_snd_BattleRoar) + 2.0)) then // wait until end
				return
			endif

			call TransmissionFromUnit(this.m_villager0, tre("Wo ist der Herzog?", "Where is the duke?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.m_villager0, tre("Ich will nach Hause! Wir werden sowieso nicht bezahlt!", "I want to go home! We won't be paid anyway!"), gg_snd_Mercenary1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Mercenary1))) then
				return
			endif

			call TransmissionFromUnit(this.m_villager1, tre("Ruhe!", "Silence!"), null)


			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			/*
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorRicman), tr("Ricman"), tr("Wenn ihr sterben solltet, seid euch gewiss ihr seid ehrenvoll gestorben wenn eure Klinge vom Blute von mindestens zwanzig Dunkelelfen bedeckt ist."), gg_snd_RicmanTheDefenseOfTalrasRicman2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanTheDefenseOfTalrasRicman2))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorRicman), tr("Ricman"), tr("Ihr wisst sie haben uns unseren König genommen, dafür nehmen wir ihnen das Leben! Schlachtet sie ab, lasst keinen am Leben!"), gg_snd_RicmanTheDefenseOfTalrasRicman3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanTheDefenseOfTalrasRicman3))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorRicman), tr("Ricman"), tr("Auf dann, ein letztes Mal vor dem Morgengrauen! Kämpft für euren König, für seinen Sohn Wigberht, für die Ehre und für den Norden!"), gg_snd_RicmanTheDefenseOfTalrasRicman4)

			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanTheDefenseOfTalrasRicman4))) then
				return
			endif
			*/

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
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary
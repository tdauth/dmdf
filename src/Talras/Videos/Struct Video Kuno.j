library StructMapVideosVideoKuno requires Asl, StructGameGame

	struct VideoKuno extends AVideo
		private unit m_actorKuno
		private unit m_actorKunosDaughter

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			//call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_kuno_initial_view, true, 0.0)

			set this.m_actorKuno = thistype.unitActor(thistype.saveUnitActor(Npcs.kuno()))
			call SetUnitPositionRect(this.m_actorKuno, gg_rct_video_kuno_kuno)
			
			set this.m_actorKunosDaughter = thistype.unitActor(thistype.saveUnitActor(Npcs.kunosDaughter()))
			call SetUnitPositionRect(this.m_actorKunosDaughter, gg_rct_video_kuno_kunos_daughter)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_kuno_actor)
			
			call SetUnitFacingToFaceUnit(thistype.actor(), this.m_actorKuno)
			call SetUnitFacingToFaceUnit(this.m_actorKuno, thistype.actor())
			call SetUnitFacingToFaceUnit(this.m_actorKunosDaughter, thistype.actor())
		endmethod

		public stub method onPlayAction takes nothing returns nothing
		
			call TransmissionFromUnit(thistype.actor(), tr("Holzfäller Kuno!"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Was ist?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Der Herzog benötigt Holz für die Befestigung eines eroberten Außenpostens."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Also hat der Krieg schon begonnen? Bei den Göttern das wird kein gutes Ende haben. Aber wieso sollte ich den Herzog dabei unterstützen? Was habe ich davon?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Hör zu, der Herzog bittet nicht darum und Markward auch nicht. Willst du lieber von den Orks und Dunkelelfen überrannt werden? Denk doch an deine Tochter."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Schon gut schon gut, ich darf mich doch wenigstens noch aufregen über diesen Herzog. Aber eines sage ich dir, einfach so bekommt er mein Holz nicht."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Was verlangst du?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Pass auf, dieser Wald hier ist das Grauen geworden. Kein Ort an dem ein Kind aufwachsen sollte und schon gar nicht meine Tochter."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Im Süden leben bärenstarke Riesen und im Norden ..."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Im Norden habe ich grausame Hexen gesehen. Sie werden meine Tochter entführen oder verhexen wenn ich gerade nicht aufpasse. Das könnte ich nicht ertragen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnit(thistype.actor(), tr("Du willst dass wir die Hexen vertreiben."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Genau. Tötet sie alle! Diese verlorenen Seelen haben ihr Recht auf ein Leben verwirkt, indem sie in meinem Wald Unfrieden stifteten. Danach kannst du das Holz haben."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.m_actorKuno, tr("Kuno"), tr("Allerdings musst du es alleine wegbringen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			set this.m_actorKuno = null
			set this.m_actorKunosDaughter = null

			call Game.resetVideoSettings()
			call QuestWar.quest.evaluate().enableKillTheWitches.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary
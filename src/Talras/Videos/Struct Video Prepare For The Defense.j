library StructMapVideosVideoPrepareForTheDefense requires Asl, StructGameGame

	struct VideoPrepareForTheDefense extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			// TODO custom music
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			// TODO custom cam
			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_0, true, 0.0)

			set this.m_actorHeimrich = thistype.saveUnitActor(gg_unit_n013_0116)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorHeimrich), gg_rct_video_the_duke_of_talras_heimrichs_position)

			set this.m_actorMarkward = thistype.saveUnitActor(gg_unit_n014_0117)
			call SetUnitPositionRect(thistype.unitActor(this.m_actorMarkward), gg_rct_video_the_duke_of_talras_markwards_position)
			
			set this.m_actorOsman = thistype.saveUnitActor(Npcs.osman())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorOsman), gg_rct_video_the_duke_of_talras_osmans_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorOsman), 290.39)
			
			set this.m_actorFerdinand = thistype.saveUnitActor(Npcs.ferdinand())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorFerdinand), gg_rct_video_the_duke_of_talras_ferdinands_position)
			call SetUnitFacing(thistype.unitActor(this.m_actorFerdinand), 257.48)
			
			
			set this.m_actorWigberht = thistype.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorWigberht), gg_rct_video_prepare_for_the_defense_wigberht)
			set this.m_actorRicman = thistype.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorRicman), gg_rct_video_prepare_for_the_defense_ricman)
			set this.m_actorDragonSlayer = thistype.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(thistype.unitActor(this.m_actorDragonSlayer), gg_rct_video_prepare_for_the_defense_dragon_slayer)

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_the_duke_of_talras_actors_position)

			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorHeimrich), thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorMarkward), thistype.actor())

			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorHeimrich))
			call SetUnitLookAt(thistype.actor(), "bone_head", thistype.unitActor(this.m_actorHeimrich), 0.0, 0.0, 90.0)
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorWigberht), thistype.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorRicman), thistype.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorDragonSlayer), thistype.unitActor(this.m_actorHeimrich))
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(thistype.actor(), tr("Wir haben den Auftrag erfüllt."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
		
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("Sehr gut! Es ist nun an ihnen den Feind aufzuhalten."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("Markward berichtete mir von Truppenbewegungen im Norden. Die Orks und Dunkelelfen nahen und uns bleibt keine Zeit mehr. Sie werden zunächst den Außenposten angreifen, ich hoffe sie haben ihn gut befestigt."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("Der Feind darf auf keinen Fall die Burg erreichen. Das wäre unser Ende! Sie müssen diese Truppen aufhalten, um jeden Preis."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorHeimrich), thistype.unitActor(this.m_actorDragonSlayer))
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("Werte Drachentöterin! Hat sie etwas mit ihrem Schreiben erreicht?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorDragonSlayer), tr("Drachentöterin"), tr("In der Tat. Es kam eine Antwort. Der König selbst, Dararos, hat mir ein Eilschreiben zugesandt. Er schreibt, dass er Hilfe schicken wird, jedoch konnte er mir nicht versichern, wie lange diese Hilfe brauchen wird, bis sie hier eintrifft."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("Der König der Hochelfen? Das hört sich besser an als erwartet. So lasst uns keine Zeit verschwenden. Machen sie sich bereit!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorDragonSlayer), tr("Drachentöterin"), tr("Ich muss zugeben, dass es mich selbst ein wenig überrascht, dass mein König ein so großes Interesse an der Sache hat. Nichtsdestotrotz können uns die Truppen der Hochelfen von großem Nutzen sein, wenn sie rechtzeitig eintreffen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorDragonSlayer), tr("Drachentöterin"), tr("Verzeiht mir die Frage, aber wo werdet IHR euch postieren, verehrter Herzog?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("Ich? Also ... ich, ich werde hier mit Markward ausharren. Wir halten die letzte Bastion gemeinsam. Erst wenn das Dorf gefallen ist und die tapferen Dorfbewohner ihr letztes Blut vergossen haben, wird der Feind sich mit uns anlegen müssen. Nicht wahr Markward (ängstlich)?"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(thistype.unitActor(this.m_actorHeimrich), tr("Heimrich"), tr("... natrürlich schicke ich Männer zum Außenposten und sie haben ja selbst bereits Männer angeworben. Es ist nun an der Zeit aufzubrechen. Ich wünsche ihnen viel Glück!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
			
			call QuestWar.quest.evaluate().complete()
			call QuestTheDefenseOfTalras.quest.evaluate().enable.evaluate()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary
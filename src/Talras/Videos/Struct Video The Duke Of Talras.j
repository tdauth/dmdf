library StructMapVideosVideoTheDukeOfTalras requires Asl, StructGameGame

	struct VideoTheDukeOfTalras extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand

		implement Video

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings()
			call SetTimeOfDay(12.0)
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
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

			call SetUnitPositionRect(thistype.actor(), gg_rct_video_the_duke_of_talras_actors_position)

			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorHeimrich), thistype.actor())
			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorMarkward), thistype.actor())

			call SetUnitFacingToFaceUnit(thistype.actor(), thistype.unitActor(this.m_actorHeimrich))
			call SetUnitLookAt(thistype.actor(), "bone_head", thistype.unitActor(this.m_actorHeimrich), 0.0, 0.0, 90.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Nun, sie sind also die Vasallen von denen mir berichtet wurde. Sie sollen rasch sprechen. Was treibt sie in diese Gegend?"), gg_snd_Heimrich16)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich16))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_1, true, 0.0)
			call TransmissionFromUnit(thistype.actor(), tr("Wir wollen Euch bei Eurem Kampf gegen die Orks und Dunkelelfen unterstützen. Das ist der Grund, warum wir kamen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_0, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Es freut mich zu hören in ihnen weitere Verbündete gegen den Feind gefunden zu haben. Wir benötigen jeden verfügbaren Mann. Sie sollen mir die Treue für das bevorstehende Gefecht schwören und sie werden eine Aufgabe erhalten."), gg_snd_Heimrich17)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich17))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_2, true, 0.0)

			if (wait(1.0)) then
				return
			endif

			// 25
			//call SetUnitAnimation(thistype.actor(), "Stand Victory")
			call SetUnitAnimationByIndex(thistype.actor(), 25)

			if (wait(1.0)) then
				return
			endif

			call TransmissionFromUnit(thistype.actor(), tr("Wir schwören Euch die Treue und werden Euch im bevorstehenden Kampf zur Seite stehen."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_0, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorHeimrich), tr("Auf dann! Mein getreuer Ritter Markward wird sie mit ihrer Aufgabe vertraut machen und sie ein wenig über die Situation aufklären."), gg_snd_Heimrich18)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich18) + 2.0)) then
				return
			endif

			call IssueRectOrder(thistype.unitActor(this.m_actorHeimrich), "move", gg_rct_video_the_duke_of_talras_heimrichs_new_position)

			if (wait(2.0)) then
				return
			endif

			call IssueRectOrder(thistype.unitActor(this.m_actorMarkward), "move", gg_rct_video_the_duke_of_talras_heimrichs_position)
			debug call Print("Actor looks at Markward.")
			if (wait(1.0)) then
				return
			endif
			call SetUnitLookAt(thistype.actor(), "bone_head", thistype.unitActor(this.m_actorMarkward), 0.0, 0.0, 90.0)
			debug call Print("Starting loop.")
			loop
				exitwhen (RectContainsUnit(gg_rct_video_the_duke_of_talras_heimrichs_position, thistype.unitActor(this.m_actorMarkward)))

				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitFacingToFaceUnit(thistype.unitActor(this.m_actorMarkward), thistype.actor())
			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_3, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Wie ihr wisst sind die Dunkelelfen mit einem Heer von Orks ins Königreich eingefallen. Es ist nur noch eine Frage der Zeit bis sie auch Talras angreifen werden."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_2, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Wir brauchen jeden Kampffähigen, den wir finden können. Vor einer Weile sind einige merkwürdig aussehende Krieger nach Talras gekommen. Sie kamen von weit her, aus dem Norden, mit einem Schiff."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_1, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Der Herzog ist sich sicher, dass sie wegen des bevorstehenden Krieges hier sind. Eure Aufgabe wird es sein, herauszufinden, ob der Herzog mit ihnen ein Bündnis eingehen kann."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_3, true, 0.0)
			call TransmissionFromUnit(thistype.unitActor(this.m_actorMarkward), tr("Sie haben ihr Lager nicht weit vor der Burg errichtet. Ihr werdet den Weg schon finden. Viel Glück!"), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call this.stop()
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()
		endmethod

		private static method create takes nothing returns thistype
			return thistype.allocate(true)
		endmethod
	endstruct

endlibrary
library StructMapVideosVideoTheDukeOfTalras requires Asl, StructGameGame

	struct VideoTheDukeOfTalras extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_0, true, 0.0)

			set this.m_actorHeimrich = this.saveUnitActor(gg_unit_n013_0116)
			call SetUnitPositionRect(this.unitActor(this.m_actorHeimrich), gg_rct_video_the_duke_of_talras_heimrichs_position)

			set this.m_actorMarkward = this.saveUnitActor(gg_unit_n014_0117)
			call SetUnitPositionRect(this.unitActor(this.m_actorMarkward), gg_rct_video_the_duke_of_talras_markwards_position)

			set this.m_actorOsman = this.saveUnitActor(Npcs.osman())
			call SetUnitPositionRect(this.unitActor(this.m_actorOsman), gg_rct_video_the_duke_of_talras_osmans_position)
			call SetUnitFacing(this.unitActor(this.m_actorOsman), 290.39)

			set this.m_actorFerdinand = this.saveUnitActor(Npcs.ferdinand())
			call SetUnitPositionRect(this.unitActor(this.m_actorFerdinand), gg_rct_video_the_duke_of_talras_ferdinands_position)
			call SetUnitFacing(this.unitActor(this.m_actorFerdinand), 257.48)

			call SetUnitPositionRect(this.actor(), gg_rct_video_the_duke_of_talras_actors_position)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorHeimrich), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.actor())

			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorHeimrich))
			call SetUnitLookAt(this.actor(), "bone_head", this.unitActor(this.m_actorHeimrich), 0.0, 0.0, 90.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_the_duke_of_talras_0)

			call TransmissionFromUnit(this.unitActor(this.m_actorHeimrich), tre("Nun, sie sind also die Vasallen von denen mir berichtet wurde. Sie sollen rasch sprechen. Was treibt sie in diese Gegend?", "So, they are the vassals of whom was reported to me. They shall speak fast. What drives them to this area?"), gg_snd_Heimrich16)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich16))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_1, true, 0.0)
			call TransmissionFromUnit(this.actor(), tre("Wir wollen Euch bei Eurem Kampf gegen die Orks und Dunkelelfen unterstützen. Das ist der Grund, warum wir kamen.", "We want to support you in your fight against the Orcs and Dark Elves. This is the reason why we came."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_0, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorHeimrich), tre("Es freut mich zu hören in ihnen weitere Verbündete gegen den Feind gefunden zu haben. Wir benötigen jeden verfügbaren Mann. Sie sollen mir die Treue für das bevorstehende Gefecht schwören und sie werden eine Aufgabe erhalten.", "It is my pleasure to hear that I found new allies against the enemy in them. We need every available man. They shall pledge loyality to me for the upcoming battle and they will receive a task."), gg_snd_Heimrich17)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich17))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_2, true, 0.0)

			if (wait(1.0)) then
				return
			endif

			// 25
			//call SetUnitAnimation(this.actor(), "Stand Victory")
			call SetUnitAnimationByIndex(this.actor(), 25)

			if (wait(1.0)) then
				return
			endif

			call TransmissionFromUnit(this.actor(), tre("Wir schwören Euch die Treue und werden Euch im bevorstehenden Kampf zur Seite stehen.", "We pledge loyality to you and will stand next to you in the upcoming battle."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_0, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorHeimrich), tre("Auf dann! Mein getreuer Ritter Markward wird sie mit ihrer Aufgabe vertraut machen und sie ein wenig über die Situation aufklären.", "On then! My faithful knight Markward will familiarize them with their job and explain them a little about the situation."), gg_snd_Heimrich18)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich18) + 2.0)) then
				return
			endif

			call IssueRectOrder(this.unitActor(this.m_actorHeimrich), "move", gg_rct_video_the_duke_of_talras_heimrichs_new_position)

			if (wait(2.0)) then
				return
			endif

			call IssueRectOrder(this.unitActor(this.m_actorMarkward), "move", gg_rct_video_the_duke_of_talras_heimrichs_position)
			debug call Print("Actor looks at Markward.")
			if (wait(1.0)) then
				return
			endif
			call SetUnitLookAt(this.actor(), "bone_head", this.unitActor(this.m_actorMarkward), 0.0, 0.0, 90.0)
			debug call Print("Starting loop.")
			loop
				exitwhen (RectContainsUnit(gg_rct_video_the_duke_of_talras_heimrichs_position, this.unitActor(this.m_actorMarkward)))

				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.actor())
			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_3, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Wie ihr wisst sind die Dunkelelfen mit einem Heer von Orks ins Königreich eingefallen. Es ist nur noch eine Frage der Zeit bis sie auch Talras angreifen werden.", "As you know the Dark Elves have invaded the kingdom with an army of Orcs. It is only a matter of time until they will attack Talras as well."), gg_snd_Markward29)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward29))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_2, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Wir brauchen jeden Kampffähigen, den wir finden können. Vor einer Weile sind einige merkwürdig aussehende Krieger nach Talras gekommen. Sie kamen von weit her, aus dem Norden, mit einem Langboot.", "We need everyone we can find who is able to fight. A while agon some strange looking warriors came to Talras. They came from far away, from the north, with a long tail boat."), gg_snd_Markward30)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward30))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_1, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Der Herzog ist sich sicher, dass sie wegen des bevorstehenden Krieges hier sind. Eure Aufgabe wird es sein, herauszufinden, ob der Herzog mit ihnen ein Bündnis eingehen kann.", "The duke is sure that they are here because of the impending war. Your task will be to find out if the duke can enter into an alliance with them."), gg_snd_Markward31)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward31))) then
				return
			endif

			call CameraSetupApplyForceDuration(gg_cam_the_duke_of_talras_3, true, 0.0)
			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Sie haben ihr Lager nicht weit vor der Burg errichtet. Verlasst die Burg durch das Osttor, geht den Weg hinunter und dann weiter östlich des Aufstiegs in Richtung Norden. Ihr werdet den Weg schon finden. Viel Glück!", "They have built their camp not far in front of the castle. Leave the castle through the east gate, go down the path and further east from the climb to the north. You will find the way. Good luck!"), gg_snd_Markward32)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward32))) then
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
library StructMapVideosVideoPrepareForTheDefense requires Asl, StructGameGame

	struct VideoPrepareForTheDefense extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(12.0)
			// TODO custom music
			call PlayThematicMusic("Music\\TheDukeOfTalras.mp3")
			// TODO custom cam
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


			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_prepare_for_the_defense_wigberht)
			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(this.unitActor(this.m_actorRicman), gg_rct_video_prepare_for_the_defense_ricman)
			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(this.unitActor(this.m_actorDragonSlayer), gg_rct_video_prepare_for_the_defense_dragon_slayer)

			call SetUnitPositionRect(this.actor(), gg_rct_video_the_duke_of_talras_actors_position)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorHeimrich), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.actor())

			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorHeimrich))
			call SetUnitLookAt(this.actor(), "bone_head", this.unitActor(this.m_actorHeimrich), 0.0, 0.0, 90.0)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDragonSlayer), this.unitActor(this.m_actorHeimrich))
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_the_duke_of_talras_0)

			call TransmissionFromUnit(this.actor(), tre("Wir haben den Auftrag erfüllt.", "We have completed the mission."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorHeimrich), tre("Heimrich", "Heimrich"), tre("Sehr gut! Es ist nun an ihnen den Feind aufzuhalten.", "Very good! It is now on them to reside the enemy."), gg_snd_Heimrich23)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorHeimrich), tre("Heimrich", "Heimrich"), tre("Markward berichtete mir von Truppenbewegungen im Norden. Die Orks und Dunkelelfen nahen und uns bleibt keine Zeit mehr. Sie werden zunächst den Außenposten angreifen, ich hoffe sie haben ihn gut befestigt.", "Markward told me about troop movements in the north. The Orcs and Dark Elves are near and we have no more time. They will first attack the outpost, I hope they have it fixed well."), gg_snd_Heimrich24)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich24))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorHeimrich), tre("Heimrich", "Heimrich"), tre("Der Feind darf auf keinen Fall die Burg erreichen. Das wäre unser Ende! Sie müssen diese Truppen aufhalten, um jeden Preis.", "The enemy may never reach the castle. That would be the end of us! You must stop these troops, at any cost."), gg_snd_Heimrich25)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich25))) then
				return
			endif

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorHeimrich), this.unitActor(this.m_actorDragonSlayer))

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorHeimrich), tre("Heimrich", "Heimrich"), tre("Werte Drachentöterin! Hat sie etwas mit ihrem Schreiben erreicht?", "Valuable Dragon Slayer! Has she achieved anything with her letter?"), gg_snd_Heimrich26)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich26))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("In der Tat. Es kam eine Antwort. Der König selbst, Dararos, hat mir ein Eilschreiben zugesandt. Er schreibt, dass er Hilfe schicken wird, jedoch konnte er mir nicht versichern, wie lange diese Hilfe brauchen wird, bis sie hier eintrifft.", "As a matter of fact. There was an answer. The king himself Dararos has sent me a dispatch. He writes that he will send help, but he could not assure me how long this help will take until it gets here."), gg_snd_DragonSlayerPrepareForTheDefense1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerPrepareForTheDefense1))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorHeimrich), tre("Heimrich", "Heimrich"), tre("Der König der Hochelfen? Das hört sich besser an als erwartet. So lasst uns keine Zeit verschwenden. Machen sie sich bereit!", "The king of the High Elves? That sounds better than expected. So let's not waste time. Get ready!"), gg_snd_Heimrich27)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich27))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Ich muss zugeben, dass es mich selbst ein wenig überrascht, dass mein König ein so großes Interesse an der Sache hat. Nichtsdestotrotz können uns die Truppen der Hochelfen von großem Nutzen sein, wenn sie rechtzeitig eintreffen.", "I must admit that it surprises me a little that my king has such a great interest in the matter. Nevertheless, the troops of the High Elves can be of much use if they arrive on time."), gg_snd_DragonSlayerPrepareForTheDefense2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerPrepareForTheDefense2))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Verzeiht mir die Frage, aber wo werdet IHR euch postieren, verehrter Herzog?", "Pardon my asking, but where will YOU place yourself, dear duke?"), gg_snd_DragonSlayerPrepareForTheDefense3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerPrepareForTheDefense3))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorHeimrich), tre("Heimrich", "Heimrich"), tre("Ich? Also ... ich, ich werde hier mit Markward ausharren. Wir halten die letzte Bastion gemeinsam. Erst wenn das Dorf gefallen ist und die tapferen Dorfbewohner ihr letztes Blut vergossen haben, wird der Feind sich mit uns anlegen müssen. Nicht wahr Markward (ängstlich)?", "I? So ... I, I'll presevere here with Markward. We keep the last bastion together. Only when the village has fallend and the brave villagers have shed their last blood, the enemy will have to mess with us. Huh Markward (anxious)?"), gg_snd_Heimrich28)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich28))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorHeimrich), tre("Heimrich", "Heimrich"), tre("... natrürlich schicke ich Männer zum Außenposten und sie haben ja selbst bereits Männer angeworben. Es ist nun an der Zeit aufzubrechen. Ich wünsche ihnen viel Glück!", "... of course I will send men to the outpost and they have even enlisted men themselves. It is now time to start. I wish them good luck!"), gg_snd_Heimrich29)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich29))) then
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
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary
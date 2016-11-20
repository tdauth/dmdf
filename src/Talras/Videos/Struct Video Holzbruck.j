library StructMapVideosVideoHolzbruck requires Asl, StructGameGame

/*
Szene 5 - Der Charakter und der Herzog:
C: Wir haben den Außenposten erfolgreich verteidigt.
Heimrich: Freude, Jubel, jauchzet und frohlocket, es ist vollbracht! Der Feind ist niedergestreckt, besiegt, die Hochelfen sind eingetroffen. Es hätte nicht schöner ausgehen können. Markward wird ihnen alle erdenklichen Wünsche erfüllen und sie mit ihrer nächsten Mission vertraut machen. Das war wirklich ausgezeichnete Arbeit! gg_snd_Heimrich30

Markward: Ausgezeichnete Arbeit. Von dieser Schlacht wird man noch sehr lange in Talras sprechen. Ihr habt dem Herzog und allen anderen in Talras neue Hoffung geschenkt. gg_snd_Markward44
Markward: Leider ist die Gefahr damit nur vorerst gebannt. Uns kam von weiteren Truppenbewegungen zu Ohren. Anscheinend haben die Orks und Dunkelelfen nun vor, die weiter nördlich gelegene Stadt Holzbruck anzugreifen. gg_snd_Markward45
Markward: Ich konnte den Herzog davon überzeugen euch nach Holzbruck zu schicken, um die Stadt bei ihrem Kampf zu unterstützen. Da die Nordmänner sowieso weiter in Richtung Norden segeln wollen, können sie euch sicherlich dorthin bringen. gg_snd_Markward46
Markward: Wir sind dank der Hochelfen erst einmal sicher. gg_snd_Markward47

Drachentöterin: Mein König hat mir gestattet euch auf eurer weiteren Reise zu begleiten. Er sieht großen Nutzen darin, mehr über die Orks und Dunkelelfen in Erfahrung zu bringen. Das bedeutet, wir werden gemeinsam nach Holzbruck aufbrechen.

Markward: Sehr gut. Wenn ihr Holzbruck erfolgreich verteidigt habt, könnt ihr zurückkehren. Der Herzog wird euch reich belohnen, die Bewohner von Holzbruck selbst jedoch vermutlich noch reicher. Es handelt sich um eine sehr wohlhabende Stadt. Ich hoffe, wir verlieren euch nicht an sie. gg_snd_Markward48
Markward: Hier habt ihr noch die Belohnung für den zuletzt erfolgreich abgeschlossenen Auftrag. Es war mir eine große Ehre euch zu treffen. Ich wünsche euch viel Glück auf eurer Reise! gg_snd_Markward49
*/
	struct VideoHolzbruck extends AVideo
		private integer m_actorHeimrich
		private integer m_actorMarkward
		private integer m_actorOsman
		private integer m_actorFerdinand
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(20.0)

			set this.m_actorHeimrich = this.saveUnitActor(Npcs.heimrich())
			call SetUnitPositionRect(this.unitActor(this.m_actorHeimrich), gg_rct_video_holzbruck_heimrich)

			set this.m_actorMarkward = this.saveUnitActor(Npcs.markward())
			call SetUnitPositionRect(this.unitActor(this.m_actorMarkward), gg_rct_video_holzbruck_markward)

			set this.m_actorOsman = this.saveUnitActor(Npcs.osman())
			call SetUnitPositionRect(this.unitActor(this.m_actorOsman), gg_rct_video_holzbruck_osman)

			set this.m_actorFerdinand = this.saveUnitActor(Npcs.ferdinand())
			call SetUnitPositionRect(this.unitActor(this.m_actorFerdinand), gg_rct_video_holzbruck_ferdinand)

			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_holzbruck_wigberht)

			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(this.unitActor(this.m_actorRicman), gg_rct_video_holzbruck_ricman)

			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(this.unitActor(this.m_actorDragonSlayer), gg_rct_video_holzbruck_dragon_slayer)

			call SetUnitPositionRect(this.actor(), gg_rct_video_holzbruck_actor)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorHeimrich), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.actor())

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorOsman), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorFerdinand), this.actor())

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDragonSlayer), this.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.unitActor(this.m_actorHeimrich))
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorHeimrich))

			call CameraSetupApplyForceDuration(gg_cam_holzbruck_0, true, 0.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_holzbruck_0)

			call TransmissionFromUnit(this.actor(), tre("Wir haben den Außenposten erfolgreich verteidigt.", "We have successfully defended the outpost."), null)

			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorHeimrich), tre("Freude, Jubel, jauchzet und frohlocket, es ist vollbracht! Der Feind ist niedergestreckt, besiegt, die Hochelfen sind eingetroffen. Es hätte nicht schöner ausgehen können. Markward wird ihnen alle erdenklichen Wünsche erfüllen und sie mit ihrer nächsten Mission vertraut machen. Das war wirklich ausgezeichnete Arbeit!", "Joy, cheering, shout and rejoice, it's done! The enemy is struck down, defeated, the High Elves have arrived. It could not have run out nicer. Markward will fulfill them all possible wishes and familiarize them with their next mission. This was truly excellent work!"), gg_snd_Heimrich30)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Heimrich30))) then
				return
			endif

			call IssueRectOrder(this.unitActor(this.m_actorHeimrich), "move", gg_rct_video_holzbruck_heimrichs_new_position)
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorMarkward))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDragonSlayer), this.unitActor(this.m_actorMarkward))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.unitActor(this.m_actorMarkward))
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorMarkward))
			call CameraSetupApplyForceDuration(gg_cam_holzbruck_1, true, 0.0)

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Ausgezeichnete Arbeit. Von dieser Schlacht wird man noch sehr lange in Talras sprechen. Ihr habt dem Herzog und allen anderen in Talras neue Hoffung geschenkt.", "Excellent work. About this battle people will speak for a long time in Talras. You have given new hope to the duke and all others in Talras."), gg_snd_Markward44)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward44))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Leider ist die Gefahr damit nur vorerst gebannt. Uns kam von weiteren Truppenbewegungen zu Ohren. Anscheinend haben die Orks und Dunkelelfen nun vor, die weiter nördlich gelegene Stadt Holzbruck anzugreifen.", "Unfortunately, the danger is only averted for the time being. It came to our ears that there is further troop movements. Apparently the Orcs and Dark Elves want to attack now the town further north, Holzbruck."), gg_snd_Markward45)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward45))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Ich konnte den Herzog davon überzeugen euch nach Holzbruck zu schicken, um die Stadt bei ihrem Kampf zu unterstützen. Da die Nordmänner sowieso weiter in Richtung Norden segeln wollen, können sie euch sicherlich dorthin bringen.", "I was able to convince the duke to send you to Holzbruck to support the town in its fight. Since the Northmen continue sailing towards the north anyway, they can certainly take you there."), gg_snd_Markward46)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward46))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Wir sind dank der Hochelfen erst einmal sicher.", "We safe for once thanks to the High Elves."), gg_snd_Markward47)
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.unitActor(this.m_actorDragonSlayer))

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward47))) then
				return
			endif

			//call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorMarkward), this.actor())

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Mein König hat mir gestattet euch auf eurer weiteren Reise zu begleiten. Er sieht großen Nutzen darin, mehr über die Orks und Dunkelelfen in Erfahrung zu bringen. Das bedeutet, wir werden gemeinsam nach Holzbruck aufbrechen.", "My king has allowed me to accompany you on your further travel. He sees great benefit in getting more information about the Orcs and Dark Elves. This means that we will leave together for Holzbruck."), gg_snd_DragonSlayerHolzbruck1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerHolzbruck1))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Sehr gut. Wenn ihr Holzbruck erfolgreich verteidigt habt, könnt ihr zurückkehren. Der Herzog wird euch reich belohnen, die Bewohner von Holzbruck selbst jedoch vermutlich noch reicher. Es handelt sich um eine sehr wohlhabende Stadt. Ich hoffe, wir verlieren euch nicht an sie.", "Excellent. If you have successfully defended Holzbruck you can return. The duke will reward you richly, the residents of Holzbruck themselves probably even richer. It is a very prosperous town. I hope we do not lose you to it."), gg_snd_Markward48)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward48))) then
				return
			endif

			call TransmissionFromUnit(this.unitActor(this.m_actorMarkward), tre("Hier habt ihr noch die Belohnung für den zuletzt erfolgreich abgeschlossenen Auftrag. Es war mir eine große Ehre euch zu treffen. Ich wünsche euch viel Glück auf eurer Reise!", "Here you have the reward for the last successfully completed mission. It was a great honour to me to meet you. If wish you good luck on your journey!"), gg_snd_Markward49)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Markward49))) then
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
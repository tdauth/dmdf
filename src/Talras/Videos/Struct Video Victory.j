/*

Szene 1 - Wigberht der Schlächter:
Wigberht: Du denkst, du könntest mir Angst machen? Höre, ich habe den Tod gesehen und er ließ mich kalt. Ich sah den Schrecken, den deine Sippe über mein Volk brachte, doch er ließ mich kalt. Dein Tod aber wird mir Freude bereiten!

Szene 2 - Dararos und die Drachentöterin:
Drachentöterin: Mein König, ich wusste nicht, dass Ihr Euch persönlich auf den Weg macht.
Dararos: Es musste sein. Deranors Verschwinden hat den Fürsten der Dunkelelfen aus seiner Festung gelockt. Ich konnte nicht zögern mir diese Chance entgehen zu lassen.
Dararos: Wir werden jedoch erst mehr Männer sammeln und dann in Richtung Norden ziehen. Vielleicht können wir ihn auf offenem Felde stellen.
Drachentöterin: Ihr wollt Euren Bruder ... ich meine ihren Fürsten schließlich angreifen?
Dararos: So ist es. Du hast sehr gute Dienste geleistet. Deranor war eine große Bedrohung für uns. Nun da er sich vermutlich für sehr lange Zeit erst einmal zurückziehen musste, ist mein Bruder geschwächt.
Dararos: Deine Verbündeten hier haben sehr tapfer gekämpft. Mir scheint ich habe die Menschen unterschätzt. Wenn Sie nur wüssten, dass der König der Dunkelelfen selbst ein Mensch ist, dann ...
Dararos: Nun denn, ich habe entschieden, dass du die Menschen weiter unterstützt. Mir kam zu Ohren, dass die Nordmänner ebenfalls in Richtung Norden ziehen wollen. Vielleicht kannst du schon einiges in Erfahrung bringen lange bevor mein Heer aufgestellt ist.
Dararos: Schließ dich den Nordmännern an und berichte mir von Zeit zu Zeit weiter wie bisher.
Drachentöterin: Wie Ihr wünscht mein König.


Szene 2 - Wigberht, die Nordmänner und die Charaktere:
Wigberht: Ihr habt Tapfer gekämpft. Diese Schlacht hätte auch anders ausgehen können. Wir kehren nun zu unserem Lager zurück.
Wigberht: Warten wir ab, ob der Herzog noch unsere Hilfe braucht. Ricman kümmere dich darum, dass wir bald aufbrechen können!
Ricman: Ich werde das Boot beladen lassen, mein Herr.


Szene 3 - Das Schlachtfeld und der Fürst der Dunkelelfen:
Erzähler: So siegten die Menschen über die Orks und Dunkelelfen in einer Schlacht von der man sich in Talras noch lange danach erzählen wird, wenn sich die Nachricht erst verbreitet hat.

Erzähler: Ich aber hatte die Verwundeten zu versorgen, die Verwundeten meiner Artgenossen - den Dunkelelfen. Doch genug von mir.
*/
library StructMapVideosVideoVictory requires Asl, StructGameGame

	struct VideoVictory extends AVideo
		private integer m_actorWigberht
		private integer m_actorRicman
		private integer m_actorDragonSlayer
		private integer m_actorDararos
		private integer m_actorOrc
		private trigger m_hitTrigger
		private integer m_actorNarrator
		private integer m_actorWounded
		private AGroup m_corpses

		private static method triggerActionKill takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			if (GetTriggerUnit() == this.unitActor(this.m_actorWigberht)) then
				call SetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE, GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) + GetEventDamage())
			else
				call SetUnitExploded(GetTriggerUnit(), true)
				call KillUnit(GetTriggerUnit())
			endif
		endmethod

		public stub method onInitAction takes nothing returns nothing
			call Game.initVideoSettings(this)
			call SetTimeOfDay(20.0)

			set this.m_actorWigberht = this.saveUnitActor(Npcs.wigberht())
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_victory_wigberht)
			call SetUnitInvulnerable(this.unitActor(this.m_actorWigberht), false)

			set this.m_actorOrc = this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'o005', gg_rct_video_victory_orc, 180.0)
			call SetUnitInvulnerable(this.unitActor(this.m_actorOrc), false)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorOrc))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorOrc), this.unitActor(this.m_actorWigberht))

			set this.m_hitTrigger = CreateTrigger()
			call DmdfHashTable.global().setHandleInteger(this.m_hitTrigger, 0, this)
			call TriggerRegisterUnitEvent(this.m_hitTrigger, this.unitActor(this.m_actorOrc), EVENT_UNIT_DAMAGED)
			call TriggerRegisterUnitEvent(this.m_hitTrigger, this.unitActor(this.m_actorWigberht), EVENT_UNIT_DAMAGED)
			call TriggerAddAction(this.m_hitTrigger, function thistype.triggerActionKill)

			set this.m_actorDararos = this.saveUnitActor(Npcs.dararos())
			call SetUnitPositionRect(this.unitActor(this.m_actorDararos), gg_rct_video_victory_dararos)

			set this.m_actorDragonSlayer = this.saveUnitActor(Npcs.dragonSlayer())
			call SetUnitPositionRect(this.unitActor(this.m_actorDragonSlayer), gg_rct_video_victory_dragon_slayer)

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDragonSlayer), this.unitActor(this.m_actorDararos))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorDararos), this.unitActor(this.m_actorDragonSlayer))

			set this.m_actorRicman = this.saveUnitActor(Npcs.ricman())
			call SetUnitPositionRect(this.unitActor(this.m_actorRicman), gg_rct_video_victory_ricman)

			call SetUnitPositionRect(this.actor(), gg_rct_video_victory_actor)

			set this.m_actorNarrator = this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n06V', gg_rct_video_victory_narrator, 282.79)
			set this.m_actorWounded = this.createUnitActorAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n02O', gg_rct_video_victory_wounded, 356.25)
			call SetUnitAnimation(this.unitActor(this.m_actorWounded), "Death")

			set this.m_corpses = AGroup.create()

			call CameraSetupApplyForceDuration(gg_cam_victory_0, true, 0.0)
		endmethod

		private static method setDead takes unit whichUnit returns nothing
			call SetUnitAnimation(whichUnit, "Death")
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			call FixVideoCamera(gg_cam_victory_0)
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tre("Du denkst, du könntest mir Angst machen? Höre, ich habe den Tod gesehen und er ließ mich kalt. Ich sah den Schrecken, den deine Sippe über mein Volk brachte, doch er ließ mich kalt. Dein Tod aber wird mir Freude bereiten!", "You think you could scare me? Listen, I've seen death and it left me cold. I saw the terror your clan brought over my people but it left me cold. But your death will delight me!"), gg_snd_Wigberht43)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht43))) then
				return
			endif

			call PlaySoundBJ(gg_snd_HowlOfTerror)
			call QueueUnitAnimation(this.unitActor(this.m_actorOrc), "Spell Slam")
			call QueueUnitAnimation(this.unitActor(this.m_actorWigberht), "Attack Slam")

			if (wait(2.0)) then // wait for animation
				return
			endif

			call IssueTargetOrder(this.unitActor(this.m_actorWigberht), "attack", this.unitActor(this.m_actorOrc))
			call IssueTargetOrder(this.unitActor(this.m_actorOrc), "attack", this.unitActor(this.m_actorWigberht))

			debug call Print("Starting loop.")
			loop
				exitwhen (IsUnitDeadBJ(this.unitActor(this.m_actorOrc)))

				if (wait(1.0)) then
					return
				endif
			endloop

			call SetUnitInvulnerable(this.unitActor(this.m_actorWigberht), true)

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_victory_dararos_and_dragon_slayer, true, 0.0)
			call Game.fadeInWithWait()

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Mein König, ich wusste nicht, dass Ihr Euch persönlich auf den Weg macht.", "My king, I did not know that you make yourself personally on the way."), gg_snd_DragonSlayerVictory1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerVictory1))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tre("Es musste sein. Deranors Verschwinden hat den Fürsten der Dunkelelfen aus seiner Festung gelockt. Ich konnte nicht zögern mir diese Chance entgehen zu lassen.", "It had to be. Deranor's disappearance lured the prince of the Dark Elves from his fortress. I could not hesitate myself to miss this opportunity."), gg_snd_Dararos2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Dararos2))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tre("Wir werden jedoch erst mehr Männer sammeln und dann in Richtung Norden ziehen. Vielleicht können wir ihn auf offenem Felde stellen.", "However, we will first collect more men and then move northwards. Perhaps we can attack him on the open field."), gg_snd_Dararos3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Dararos3))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Ihr wollt Euren Bruder ... ich meine ihren Fürsten schließlich angreifen?", " You want to attack your brother ... I mean finally attack their prince?"), gg_snd_DragonSlayerVictory2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerVictory2))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tre("So ist es. Du hast sehr gute Dienste geleistet. Deranor war eine große Bedrohung für uns. Nun da er sich vermutlich für sehr lange Zeit erst einmal zurückziehen musste, ist mein Bruder geschwächt.", "That's the way it is. You have done a very good service. Deranor was a great threat to us. Now that he had to retire for a very long time, my brother is weakened."), gg_snd_Dararos4)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Dararos4))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tre("Deine Verbündeten hier haben sehr tapfer gekämpft. Mir scheint ich habe die Menschen unterschätzt. Wenn sie nur wüssten, dass der König der Dunkelelfen selbst ein Mensch ist, dann ...", "Your allies here have fought very bravely. I seem to have underestimated the humans. If they only knew that the king of the dark elves is a human himself, then ..."), gg_snd_Dararos5)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Dararos5))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tre("Nun denn, ich habe entschieden, dass du die Menschen weiter unterstützt. Mir kam zu Ohren, dass die Nordmänner ebenfalls in Richtung Norden ziehen wollen. Vielleicht kannst du schon einiges in Erfahrung bringen lange bevor mein Heer aufgestellt ist.", "Well, I've decided that you continue to support the people. I heard that the Northmen also want to move to the north. Maybe you can find out a lot before my army is raised."), gg_snd_Dararos6)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Dararos6))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tre("Schließ dich den Nordmännern an und berichte mir von Zeit zu Zeit weiter wie bisher.", "Join the Northmen and report to me from time to time."), gg_snd_Dararos7)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Dararos7))) then
				return
			endif

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tre("Wie Ihr wünscht mein König.", "As you wish my king."), gg_snd_DragonSlayerVictory3)

			if (wait(GetSimpleTransmissionDuration(gg_snd_DragonSlayerVictory3))) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_victory_wigberht_and_ricman, true, 0.0)
			call SetUnitPositionRect(this.unitActor(this.m_actorWigberht), gg_rct_video_victory_wigberht_2)
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.actor())
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.actor())
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorWigberht))
			call SetUnitFacingToFaceUnit(this.actor(), this.unitActor(this.m_actorRicman))
			call Game.fadeInWithWait()

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tre("Ihr habt tapfer gekämpft. Diese Schlacht hätte auch anders ausgehen können. Wir kehren nun zu unserem Lager zurück.", "You have fought bravely. This battle could have ended differently. We are now returning to our camp."), gg_snd_Wigberht44)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht44))) then
				return
			endif

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorRicman))

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tre("Warten wir ab, ob der Herzog noch unsere Hilfe braucht. Ricman kümmere dich darum, dass wir bald aufbrechen können!", "Let us wait to see if the duke needs our help. Ricman, take care of everything that we can leave soon!"), gg_snd_Wigberht45)

			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht45))) then
				return
			endif

			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.unitActor(this.m_actorWigberht))

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorRicman), tre("Ricman", "Ricman"), tre("Ich werde das Boot beladen lassen, mein Herr.", "I'll have the boat loaded, sir."), gg_snd_RicmanVictoryRicman1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanVictoryRicman1))) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_victory_battlefield, true, 0.0)
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01A', gg_rct_video_victory_corpse_0, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01V', gg_rct_video_victory_corpse_1, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n018', gg_rct_video_victory_corpse_2, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n019', gg_rct_video_victory_corpse_3, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01W', gg_rct_video_victory_corpse_4, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01X', gg_rct_video_victory_corpse_5, GetRandomFacing()))
			//call this.m_corpses.forGroup(thistype.setDead) why should this be necessary?
			call Game.fadeInWithWait()

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorNarrator), tre("Erzähler", "Narrator"), tre("So siegten die Menschen über die Orks und Dunkelelfen in einer Schlacht von der man sich in Talras noch lange danach erzählen wird, wenn sich die Nachricht erst verbreitet hat.", "So the Humans won over the Orcs and Dark Elves in a battle which will be told in Talras long after the news has spread."), gg_snd_ErzaehlerSieg1)

			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerSieg1))) then
				return
			endif

			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_victory_wounded, true, 0.0)
			call Game.fadeInWithWait()

			call TransmissionFromUnitWithName(this.unitActor(this.m_actorNarrator), tre("Erzähler", "Narrator"), tre("Ich aber hatte die Verwundeten zu versorgen, die Verwundeten meiner Artgenossen - den Dunkelelfen. Doch genug von mir.", "But I had to provide for the wounded, the wounded of my kind - the Dark Elves. But enough from me."), gg_snd_ErzaehlerSieg2)

			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerSieg2))) then
				return
			endif

			call this.stop()
		endmethod

		private static method removeUnit takes unit whichUnit returns nothing
			call RemoveUnit(whichUnit)
		endmethod

		public stub method onStopAction takes nothing returns nothing
			call Game.resetVideoSettings()

			call DmdfHashTable.global().destroyTrigger(this.m_hitTrigger)
			set this.m_hitTrigger = null

			call this.m_corpses.forGroup(thistype.removeUnit)
			call this.m_corpses.destroy()
		endmethod

		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate(true)
			call this.setActorOwner(MapSettings.neutralPassivePlayer())

			return this
		endmethod

		implement Video
	endstruct

endlibrary
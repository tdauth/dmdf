/*

Szene 1 - Wigberht der Schlächter:
Wigberht: Du denkst, du könntest mir Angst machen? Höre, ich habe den Tod gesehen und er ließ mich kalt. Ich sah den Schrecken, den deine Sippe über mein Volk brachte, doch er ließ mich kalt. Dein Tod aber wird mir Freude bereiten!

Szene 2 - Dararos und die Drachentöterin:
Drachentöterin: Mein König, ich wusste nicht, dass Ihr Euch persönlich auf den Weg macht.
Dararos: <Name> (aus Buch) es musste sein. Deranors Verschwinden hat den Fürsten der Dunkelelfen aus seiner Festung gelockt. Ich konnte nicht zögern mir diese Chance entgehen zu lassen.
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
Ricman: Ich werde das Boot beladen lassen, mein Heer.


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

		implement Video
		
		private static method triggerActionKill takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this"))
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
			
			set this.m_actorOrc = this.createUnitActorAtRect(MapData.alliedPlayer, 'o005', gg_rct_video_victory_orc, 180.0)
			call SetUnitInvulnerable(this.unitActor(this.m_actorOrc), false)
			
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorOrc))
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorOrc), this.unitActor(this.m_actorWigberht))
			
			set this.m_hitTrigger = CreateTrigger()
			call DmdfHashTable.global().setHandleInteger(this.m_hitTrigger, "this", this)
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
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01A', gg_rct_video_victory_corpse_0, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01V', gg_rct_video_victory_corpse_1, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n018', gg_rct_video_victory_corpse_2, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n019', gg_rct_video_victory_corpse_3, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01W', gg_rct_video_victory_corpse_4, GetRandomFacing()))
			call this.m_corpses.units().pushBack(CreateCorpseAtRect(Player(PLAYER_NEUTRAL_PASSIVE), 'n01X', gg_rct_video_victory_corpse_5, GetRandomFacing()))
			
			call CameraSetupApplyForceDuration(gg_cam_victory_0, true, 0.0)
		endmethod

		public stub method onPlayAction takes nothing returns nothing
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tr("Du denkst, du könntest mir Angst machen? Höre, ich habe den Tod gesehen und er ließ mich kalt. Ich sah den Schrecken, den deine Sippe über mein Volk brachte, doch er ließ mich kalt. Dein Tod aber wird mir Freude bereiten!"), gg_snd_Wigberht43)
			
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
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tr("Mein König, ich wusste nicht, dass Ihr Euch persönlich auf den Weg macht."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tr("<Name> (aus Buch) es musste sein. Deranors Verschwinden hat den Fürsten der Dunkelelfen aus seiner Festung gelockt. Ich konnte nicht zögern mir diese Chance entgehen zu lassen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tr("Wir werden jedoch erst mehr Männer sammeln und dann in Richtung Norden ziehen. Vielleicht können wir ihn auf offenem Felde stellen."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tr("Ihr wollt Euren Bruder ... ich meine ihren Fürsten schließlich angreifen?"), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tr("So ist es. Du hast sehr gute Dienste geleistet. Deranor war eine große Bedrohung für uns. Nun da er sich vermutlich für sehr lange Zeit erst einmal zurückziehen musste, ist mein Bruder geschwächt."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tr("Deine Verbündeten hier haben sehr tapfer gekämpft. Mir scheint ich habe die Menschen unterschätzt. Wenn Sie nur wüssten, dass der König der Dunkelelfen selbst ein Mensch ist, dann ..."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tr("Nun denn, ich habe entschieden, dass du die Menschen weiter unterstützt. Mir kam zu Ohren, dass die Nordmänner ebenfalls in Richtung Norden ziehen wollen. Vielleicht kannst du schon einiges in Erfahrung bringen lange bevor mein Heer aufgestellt ist."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDararos), tre("Dararos", "Dararos"), tr(" Schließ dich den Nordmännern an und berichte mir von Zeit zu Zeit weiter wie bisher."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
				return
			endif
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorDragonSlayer), tre("Drachentöterin", "Dragon Slayer"), tr("Wie Ihr wünscht mein König."), null)
			
			if (wait(GetSimpleTransmissionDuration(null))) then
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
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tr("Ihr habt tapfer gekämpft. Diese Schlacht hätte auch anders ausgehen können. Wir kehren nun zu unserem Lager zurück."), gg_snd_Wigberht44)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht44))) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorWigberht), this.unitActor(this.m_actorRicman))
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorWigberht), tre("Wigberht", "Wigberht"), tr("Warten wir ab, ob der Herzog noch unsere Hilfe braucht. Ricman kümmere dich darum, dass wir bald aufbrechen können!"), gg_snd_Wigberht45)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_Wigberht45))) then
				return
			endif
			
			call SetUnitFacingToFaceUnit(this.unitActor(this.m_actorRicman), this.unitActor(this.m_actorWigberht))
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorRicman), tre("Ricman", "Ricman"), tr("Ich werde das Boot beladen lassen, mein Heer."), gg_snd_RicmanVictoryRicman1)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_RicmanVictoryRicman1))) then
				return
			endif
			
			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_victory_battlefield, true, 0.0)
			call Game.fadeInWithWait()
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorNarrator), tre("Erzähler", "Narrator"), tr("So siegten die Menschen über die Orks und Dunkelelfen in einer Schlacht von der man sich in Talras noch lange danach erzählen wird, wenn sich die Nachricht erst verbreitet hat."), gg_snd_ErzaehlerSieg1)
			
			if (wait(GetSimpleTransmissionDuration(gg_snd_ErzaehlerSieg1))) then
				return
			endif
			
			call Game.fadeOutWithWait()
			call CameraSetupApplyForceDuration(gg_cam_victory_wounded, true, 0.0)
			call Game.fadeInWithWait()
			
			call TransmissionFromUnitWithName(this.unitActor(this.m_actorNarrator), tre("Erzähler", "Narrator"), tr("Ich aber hatte die Verwundeten zu versorgen, die Verwundeten meiner Artgenossen - den Dunkelelfen. Doch genug von mir."), gg_snd_ErzaehlerSieg2)
			
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
			call this.setActorOwner(MapData.neutralPassivePlayer)
			
			return this
		endmethod
	endstruct

endlibrary
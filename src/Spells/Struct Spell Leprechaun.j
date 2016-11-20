/// Ranger
library StructSpellsSpellLeprechaun requires Asl, StructGameClasses, StructGameSpell

	private struct Buff
		public static constant real periodicTimeout = 0.01
		public static constant real rainBowDistance = 600.0
		public static constant integer gold = 250
		private SpellLeprechaun m_spell
		private real m_startX
		private real m_startY
		private real m_startFace
		private destructable m_rainbowBridge
		private unit m_unit
		private timer m_timer
		private sound m_sound

		private method finish takes nothing returns nothing
			local integer i
			// Sound: Abilities\\Spells\\Items\\ResourceItems\\ReceiveGold.wav
			local effect whichEffect
			//Abilities\Spells\Items\ResourceItems\ResourceEffectTarget.mdl
			// start gold effect
			call IssueImmediateOrder(this.m_unit, "stop")
			call SetUnitAnimationByIndex(this.m_unit, 6) // greet
			call TriggerSleepAction(2.0)
			set whichEffect = AddSpecialEffectTarget("Abilities\\Spells\\Other\\Transmute\\PileofGold.mdl", this.m_unit, "overhead")
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (Character.playerCharacter(Player(i)) != 0) then
					call Bounty(Player(i), GetUnitX(Character.playerCharacter(Player(i)).unit()), GetUnitY(Character.playerCharacter(Player(i)).unit()), thistype.gold)
					call SetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD, GetPlayerState(Player(i), PLAYER_STATE_RESOURCE_GOLD) + thistype.gold)
				endif
				set i = i + 1
			endloop
			call TriggerSleepAction(2.0)
			call DestroyEffect(whichEffect)
			set whichEffect = null
			set whichEffect = AddSpecialEffectTarget("Abilities\\Spells\\Orc\\FeralSpirit\\feralspiritdone.mdl", this.m_rainbowBridge, "origin")
			debug call Print("Before destroy")
			call this.destroy()
			call TriggerSleepAction(2.0)
			call DestroyEffect(whichEffect)
			set whichEffect = null
		endmethod

		private static method timerFunction takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			call this.finish.execute() // without execute TriggerSleepAction() seems not to work properly
		endmethod

		public method start takes nothing returns nothing
			call PlaySoundOnUnitBJ(this.m_sound, 100.0, this.m_unit)
			call SetDestructableAnimation(this.m_rainbowBridge, "Morph")
			call TriggerSleepAction(0.134)
			call SetDestructableAnimation(this.m_rainbowBridge, "Stand Alternate")
			call UnitAddAbility(this.m_unit, 'A1IO')
			// heals, restores mana and adds armour bonus
			call IssueImmediateOrderById(this.m_unit, 852269) // OrderId2String('A1IO')
			call TriggerSleepAction(2.0)

			call IssuePointOrder(this.m_unit, "move", GetPolarProjectionX(this.m_startX, this.m_startFace, thistype.rainBowDistance), GetPolarProjectionY(this.m_startY, this.m_startFace, thistype.rainBowDistance))
			call TimerStart(this.m_timer, 6.0, false, function thistype.timerFunction)
		endmethod

		public static method create takes SpellLeprechaun spell, real x, real y, real face returns thistype
			local thistype this = thistype.allocate()

			set this.m_spell = spell

			set this.m_startX = x
			set this.m_startY = y
			set this.m_startFace = 90.0 // always use this direction

			// place it at some distance since the bridge is big and the character should not land on the bridge
			set this.m_rainbowBridge = CreateDestructable('B00Y', GetPolarProjectionX(GetSpellTargetX(), this.m_startFace, 200.0), GetPolarProjectionY(GetSpellTargetY(), this.m_startFace, 200.0), this.m_startFace, 1.50, 0)
			call SetDestructableInvulnerable(this.m_rainbowBridge, true)

			/*
			set this.m_rainbowBridge = CreateUnit(spell.character().player(), 'h02R', x, y, face - 90.0) // bridge has wrong standard facing
			call SetUnitPathing(this.m_rainbowBridge, false)
			call SetUnitInvulnerable(this.m_rainbowBridge, true)
			call PauseUnit(this.m_rainbowBridge, true)
			call MakeUnitSelectable(this.m_rainbowBridge, false)
			*/

			set this.m_unit = CreateUnit(spell.character().player(), 'h02S', x, y, this.m_startFace)
			call SetUnitPathing(this.m_unit, false)
			call SetUnitInvulnerable(this.m_unit, true)
			call SetUnitPathing(this.m_unit, false)
			call MakeUnitSelectable(this.m_unit, false)

			set this.m_timer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_timer, 0, this)

			set this.m_sound = CreateSound("Sound\\Spells\\Leprechaun\\leprechaun.mp3", false, false, true, 12700, 12700, "")
			call SetSoundChannel(this.m_sound, GetHandleId(SOUND_VOLUMEGROUP_SPELLS))

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call RemoveDestructable(this.m_rainbowBridge)
			set this.m_rainbowBridge = null
			call RemoveUnit(this.m_unit)
			set this.m_unit = null
			call PauseTimer(this.m_timer)
			call DmdfHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
			call StopSound(this.m_sound, true, false)
			set this.m_sound = null
		endmethod
	endstruct

	struct SpellLeprechaun extends Spell
		public static constant integer abilityId = 'A1IM'
		public static constant integer favouriteAbilityId = 'A1IN'
		public static constant integer classSelectionAbilityId = 'A1LX'
		public static constant integer classSelectionGrimoireAbilityId = 'A1LY'
		public static constant integer maxLevel = 1

		private method action takes nothing returns nothing
			call Buff.create(this, GetSpellTargetX(), GetSpellTargetY(), GetUnitFacing(this.character().unit())).start()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.ranger(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1LX', 'A1LY')
			call this.addGrimoireEntry('A1IP', 'A1IQ')

			return this
		endmethod
	endstruct

endlibrary
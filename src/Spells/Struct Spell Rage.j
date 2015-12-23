/// Dragon Slayer
library StructSpellsSpellRage requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Drachentöter staut Wut für bis zu X getötete Gegner an. Bei Aktivierung wird sein Schaden um Y% pro Gegner erhöht. Hält 5 Sekunden für jeden getöteten Gegner an.
	struct SpellRage extends Spell
		public static constant integer abilityId = 'A1FF'
		public static constant integer favouriteAbilityId = 'A1FG'
		public static constant integer classSelectionAbilityId = 'A1FH'
		public static constant integer classSelectionGrimoireAbilityId = 'A1FM'
		public static constant integer maxLevel = 5
		private static constant real damageBonusPerCountLevelValue = 10.0
		private static constant string enabledKey = "SpellRage:IsEnabled"
		private static constant string damageKey = "SpellRage:Damage"
		private trigger m_killTrigger
		private static integer array m_counter
		private timer m_timer

		/// Called by globan damage detection system.
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local real damage
			// works on neutral and unallied units for the character but only if the ability is learned
			if (GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) == 0) then
				debug call Print("Rage not learned")
				return
			endif
			// check class and ability
			if (not DmdfHashTable.global().hasHandleBoolean(GetEventDamageSource(), thistype.enabledKey) or DmdfHashTable.global().handleBoolean(GetEventDamageSource(), thistype.damageKey)) then
				debug call Print("Recursive call or not enabled")
				return
			endif

			set damage = GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) * thistype.damageBonusPerCountLevelValue * thistype.m_counter[GetPlayerId(GetOwningPlayer(GetEventDamageSource()))]
			debug call Print(R2S(damage) + " is damage.")
			// prevents endless damage loop
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, true)
			call UnitDamageTargetBJ(GetEventDamageSource(), GetTriggerUnit(), damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, false)
			call Spell.showDamageTextTag(GetTriggerUnit(), damage)
		endmethod
		
		private method condition takes nothing returns boolean
			if (thistype.m_counter[GetPlayerId(this.character().player())] == 0) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Keine Gegner getötet."))
				
				return false
			endif
			
			if (DmdfHashTable.global().handleBoolean(this.character().unit(), thistype.enabledKey)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Zauber ist bereits aktiv."))
				
				return false
			endif
			
			return true
		endmethod
		
		private static method timerFunctionDisable takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this")
			call DmdfHashTable.global().setHandleBoolean(this.character().unit(), thistype.enabledKey, false)
			set thistype.m_counter[GetPlayerId(this.character().player())] = 0
			debug call Print("Disable rage!")
		endmethod

		private method action takes nothing returns nothing
			call DmdfHashTable.global().setHandleBoolean(this.character().unit(), thistype.enabledKey, true)
			call TimerStart(this.m_timer, 5.0, false, function thistype.timerFunctionDisable)
			call DmdfHashTable.global().setHandleInteger(this.m_timer, "this", this)
			debug call Print("Enable rage")
		endmethod
		
		private static method triggerConditionKill takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this"))
			if (GetKillingUnit() == this.character().unit() and thistype.m_counter[GetPlayerId(this.character().player())] < GetUnitAbilityLevel(this.character().unit(), thistype.abilityId) * 2) then
				debug call Print("Rage increase counter")
				set thistype.m_counter[GetPlayerId(this.character().player())] = thistype.m_counter[GetPlayerId(this.character().player())] + 1
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("Rage: %i"), thistype.m_counter[GetPlayerId(this.character().player())]), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 139, 131, 134, 255)
			endif
			
			return false
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1FH', 'A1FM')
			call this.addGrimoireEntry('A1FI', 'A1FN')
			call this.addGrimoireEntry('A1FJ', 'A1FO')
			call this.addGrimoireEntry('A1FK', 'A1FP')
			call this.addGrimoireEntry('A1FL', 'A1FQ')
			
			set this.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_killTrigger, Condition(function thistype.triggerConditionKill))
			call DmdfHashTable.global().setHandleInteger(this.m_killTrigger, "this", this)
			
			set this.m_timer = CreateTimer()
			set thistype.m_counter[GetPlayerId(this.character().player())] = 0
			
			call Game.registerOnDamageActionOnce(thistype.onDamageAction)
			
			return this
		endmethod
		
		private method onDestroy takes nothing returns nothing
			call DmdfHashTable.global().destroyTrigger(this.m_killTrigger)
			set this.m_killTrigger = null
			call PauseTimer(this.m_timer)
			call DmdfHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
		endmethod
	endstruct

endlibrary
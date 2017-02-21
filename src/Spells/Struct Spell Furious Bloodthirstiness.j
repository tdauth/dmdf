/// Dragon Slayer
library StructSpellsSpellFuriousBloodthirstiness requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Drachentöter schlägt in blinder Wut zu. Jeder Schlag verbraucht X% seiner maximalen Lebensenergie und fügt einen Schadensbonus von Y% seiner maximalen Lebensenergie zu. Kann nur eingesetzt werden bis noch mindestens Z% der maximalen Gesundheit übrig sind. 4 Minuten Abklingzeit.
	struct SpellFuriousBloodthirstiness extends Spell
		public static constant integer abilityId = 'A06S'
		public static constant integer favouriteAbilityId = 'A06T'
		public static constant integer classSelectionAbilityId = 'A1L7'
		public static constant integer classSelectionGrimoireAbilityId = 'A1L8'
		public static constant integer maxLevel = 1
		public static constant integer buffId = 'A1WB'
		private static constant real lifeUsagePercentage = 0.03 // mustn't be bigger than life min value
		private static constant real damageBonusPercentage = 0.25
		private static constant real lifeMinPercentage = 0.10
		private static constant integer enabledKey = DMDF_HASHTABLE_KEY_FURIOUSBLOODTHIRSTINESS_ENABLED
		private static constant integer damageKey = DMDF_HASHTABLE_KEY_FURIOUSBLOODTHIRSTINESS_DAMAGE
		private effect m_effect

		/// Called by globan damage detection system.
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local Character character = 0
			local real life = 0.0
			local real damage = 0.0
			// works on neutral and unallied units for the character but only if the ability is learned
			if (GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) == 0 or GetUnitAllianceStateToUnit(GetEventDamageSource(), GetTriggerUnit()) == bj_ALLIANCE_ALLIED or not Character.isUnitCharacter(GetEventDamageSource())) then
				return
			endif
			set character = Character.getCharacterByUnit(GetEventDamageSource())
			// check class and ability
			if (not DmdfHashTable.global().hasHandleBoolean(GetEventDamageSource(), thistype.enabledKey) or not DmdfHashTable.global().handleBoolean(GetEventDamageSource(), thistype.enabledKey) or not DmdfHashTable.global().handleBoolean(GetEventDamageSource(), thistype.damageKey)) then
				return
			endif
			// when reached the minimum life stop the ability, otherwise he would die
			if (GetUnitState(GetEventDamageSource(), UNIT_STATE_LIFE) <= GetUnitState(GetEventDamageSource(), UNIT_STATE_MAX_LIFE) * thistype.lifeMinPercentage) then
				// end cast
				debug call Print("End cast")
				call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.enabledKey, false)
				return
			endif
			set life = GetUnitState(GetEventDamageSource(), UNIT_STATE_MAX_LIFE) * thistype.lifeUsagePercentage
			set damage = GetUnitState(GetEventDamageSource(), UNIT_STATE_MAX_LIFE) * thistype.damageBonusPercentage
			debug call Print(R2S(life) + " is life and " + R2S(damage) + " is damage.")
			// prevents endless damage loop
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, true)
			call UnitDamageTargetBJ(GetEventDamageSource(), GetTriggerUnit(), damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, false)
			call SetUnitState(GetEventDamageSource(), UNIT_STATE_LIFE, GetUnitState(GetEventDamageSource(), UNIT_STATE_LIFE) - life)
			call Spell.showLifeCostTextTag(GetEventDamageSource(), life)
			call Spell.showDamageTextTag(GetTriggerUnit(), damage)
		endmethod

		private method action takes nothing returns nothing
			local boolean isEnabled = DmdfHashTable.global().handleBoolean(this.character().unit(), thistype.enabledKey)
			if (isEnabled) then
				debug call Print("Is enabled")
				call DmdfHashTable.global().setHandleBoolean(this.character().unit(), thistype.enabledKey, false)
				call DestroyEffect(this.m_effect)
				set this.m_effect = null
				call UnitRemoveAbility(this.character().unit(), thistype.buffId)
			else
				debug call Print("Is not enabled")
				call DmdfHashTable.global().setHandleBoolean(this.character().unit(), thistype.enabledKey, true)
				// The effect helps to mark that the spell is enabled at the moment.
				set this.m_effect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, this.character().unit(), "chest")
				call UnitAddAbility(this.character().unit(), thistype.buffId)
				call UnitMakeAbilityPermanent(this.character().unit(), true, thistype.buffId)
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1L7', 'A1L8')
			call this.addGrimoireEntry('A0YW', 'A0YX')

			call Game.registerOnDamageActionOnce(thistype.onDamageAction)

			return this
		endmethod
	endstruct

endlibrary
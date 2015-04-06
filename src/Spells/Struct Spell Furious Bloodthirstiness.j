/// Dragon Slayer
library StructSpellsSpellFuriousBloodthirstiness requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Drachentöter schlägt in blinder Wut zu. Jeder Schlag verbraucht X% seiner maximalen Lebensenergie und fügt einen Schadensbonus von Y% seiner maximalen Lebensenergie zu. Kann nur eingesetzt werden bis noch mindestens Z% der maximalen Gesundheit übrig sind. 4 Minuten Abklingzeit.
	struct SpellFuriousBloodthirstiness extends Spell
		public static constant integer abilityId = 'A06S'
		public static constant integer favouriteAbilityId = 'A06T'
		public static constant integer maxLevel = 1
		private static constant real lifeUsagePercentage = 0.03 // mustn't be bigger than life min value
		private static constant real damageBonusPercentage = 0.25
		private static constant real lifeMinPercentage = 0.10

		/// Called by globan damage detection system.
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local Character character
			local real life
			local real damage
			// works on neutral and unallied units
			if (GetUnitAllianceStateToUnit(GetEventDamageSource(), GetTriggerUnit()) == bj_ALLIANCE_ALLIED or not Character.isUnitCharacter(GetEventDamageSource())) then
				//debug call Print("Allied or " + GetUnitName(GetEventDamageSource()) + " is no character.")
				return
			endif
			set character = Character.getCharacterByUnit(GetEventDamageSource())
			//debug call Print("Is character " + character.name() + " and target " + GetUnitName(GetTriggerUnit()))
			// check class and ability
			if (not DmdfHashTable.global().handleBoolean(GetEventDamageSource(), "SpellFuriousBloodthirstiness:IsEnabled") or DmdfHashTable.global().handleBoolean(GetEventDamageSource(), "SpellFuriousBloodthirstiness:Damage")) then
				//debug call Print("Is not enabled.")
				return
			endif
			if (GetUnitState(GetEventDamageSource(), UNIT_STATE_LIFE) < GetUnitState(GetEventDamageSource(), UNIT_STATE_MAX_LIFE) * thistype.lifeMinPercentage) then
				// end cast
				debug call Print("End cast")
				call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), "SpellFuriousBloodthirstiness:IsEnabled", false)
				return
			endif
			set life = GetUnitState(GetEventDamageSource(), UNIT_STATE_MAX_LIFE) * thistype.lifeUsagePercentage
			set damage = GetUnitState(GetEventDamageSource(), UNIT_STATE_MAX_LIFE) * thistype.damageBonusPercentage
			debug call Print(R2S(life) + " is life and " + R2S(damage) + " is damage.")
			call SetUnitState(GetEventDamageSource(), UNIT_STATE_LIFE, GetUnitState(GetEventDamageSource(), UNIT_STATE_LIFE) - life)
			// prevents endless damage loop
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), "SpellFuriousBloodthirstiness:Damage", true)
			call UnitDamageTargetBJ(GetEventDamageSource(), GetTriggerUnit(), damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), "SpellFuriousBloodthirstiness:Damage", false)
			call Spell.showLifeCostTextTag(GetEventDamageSource(), life)
			call Spell.showDamageTextTag(GetTriggerUnit(), damage)
		endmethod

		private method action takes nothing returns nothing
			local boolean isEnabled = DmdfHashTable.global().handleBoolean(this.character().unit(), "SpellFuriousBloodthirstiness:IsEnabled")
			if (isEnabled) then
				debug call Print("Is enabled")
				call DmdfHashTable.global().setHandleBoolean(this.character().unit(), "SpellFuriousBloodthirstiness:IsEnabled", false)
			else
				debug call Print("Is not enabled")
				call DmdfHashTable.global().setHandleBoolean(this.character().unit(), "SpellFuriousBloodthirstiness:IsEnabled", true)
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0YW', 'A0YX')
			
			call Game.registerOnDamageActionOnce(thistype.onDamageAction)
			
			return this
		endmethod
	endstruct

endlibrary
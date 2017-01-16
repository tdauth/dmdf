/// Dragon Slayer
library StructSpellsSpellMercilessness requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Passiv. Fällt die Lebensenergie des Gegners des Drachentöters unter 50%, wird der Schaden des Drachentöters gegen dieses Ziel um X * Heldenstufe erhöht.
	struct SpellMercilessness extends Spell
		public static constant integer abilityId = 'A1F3'
		public static constant integer favouriteAbilityId = 'A1F4'
		public static constant integer classSelectionAbilityId = 'A1MJ'
		public static constant integer classSelectionGrimoireAbilityId = 'A1MK'
		public static constant integer maxLevel = 5
		private static constant real lifePercentage = 0.30
		private static constant real damageLevelValue = 10.0
		private static constant integer damageKey = DMDF_HASHTABLE_KEY_MERCILESSNESS_DAMAGE

		/// Called by globan damage detection system.
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local Character character
			local real life
			local real damage
			// works on neutral and unallied units for the character but only if the ability is learned
			if (GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) == 0) then
				return
			endif

			if (GetUnitState(GetTriggerUnit(), UNIT_STATE_LIFE) > GetUnitState(GetTriggerUnit(), UNIT_STATE_MAX_LIFE) * thistype.lifePercentage) then
				debug call Print("Mercilessness too much life")
				return
			endif

			if (DmdfHashTable.global().handleBoolean(GetEventDamageSource(), thistype.damageKey)) then
				debug call Print("Mercilessness: No double damage bonus.")
				return
			endif
			set damage = thistype.damageLevelValue * GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) * GetHeroLevel(GetEventDamageSource())
			debug call Print("Mercilessness " + R2S(damage) + " is damage.")
			// prevents endless damage loop
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, true)
			call UnitDamageTargetBJ(GetEventDamageSource(), GetTriggerUnit(), damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
			call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, false)
			call Spell.showDamageTextTag(GetTriggerUnit(), damage)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1MJ', 'A1MK')
			call this.addGrimoireEntry('A1F5', 'A1FA')
			call this.addGrimoireEntry('A1F6', 'A1FB')
			call this.addGrimoireEntry('A1F7', 'A1FC')
			call this.addGrimoireEntry('A1F8', 'A1FD')
			call this.addGrimoireEntry('A1F9', 'A1FE')

			call this.setIsPassive(true)

			call DmdfHashTable.global().setHandleBoolean(character.unit(), thistype.damageKey, false)
			call Game.registerOnDamageActionOnce(thistype.onDamageAction)

			return this
		endmethod
	endstruct

endlibrary
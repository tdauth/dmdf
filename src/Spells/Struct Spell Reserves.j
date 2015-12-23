/// Dragon Slayer
library StructSpellsSpellReserves requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Passiv. Schlägt der Drachentöter einen Gegner X mal am Stück, wird sein Schaden um Y % erhöht.
	struct SpellReserves extends Spell
		public static constant integer abilityId = 'A1FV'
		public static constant integer favouriteAbilityId = 'A1FW'
		public static constant integer classSelectionAbilityId = 'A1FY'
		public static constant integer classSelectionGrimoireAbilityId = 'A1G3'
		public static constant integer maxLevel = 5
		private static constant integer counterStartValue = 7
		private static constant integer counterLevelValue = -1
		private static constant real damagePercentageLevelValue = 0.05
		private static constant string damageKey = "SpellReserves:Damage"
		private static unit array target[6] // TODO MapData.maxPlayers
		private static integer array counter[6] // TODO MapData.maxPlayers

		/// Called by globan damage detection system.
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local integer playerIndex
			local real damage
			// works on neutral and unallied units for the character but only if the ability is learned
			if (GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) == 0) then
				debug call Print("Reserves not learned")
				return
			endif
			
			if (DmdfHashTable.global().handleBoolean(GetEventDamageSource(), thistype.damageKey)) then
				debug call Print("Reserves recursive call")
				return
			endif
			
			set playerIndex = GetPlayerId(GetOwningPlayer(GetEventDamageSource()))
			
			if (GetTriggerUnit() != thistype.target[playerIndex]) then
				set thistype.target[playerIndex] = GetTriggerUnit()
				set thistype.counter[playerIndex] = 1
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("Reserven: %i"), thistype.counter[playerIndex]), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 139, 131, 134, 255)
			elseif (thistype.counter[playerIndex] < thistype.counterStartValue + GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) * thistype.counterLevelValue) then
				set thistype.counter[playerIndex] = thistype.counter[playerIndex] + 1
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("Reserven: %i"), thistype.counter[playerIndex]), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 139, 131, 134, 255)
			endif
			
			if (thistype.counter[playerIndex] == thistype.counterStartValue + GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) * thistype.counterLevelValue) then
				// don't reset counter, continue improvement until the counter is reset by attacking another opponent
				set damage = thistype.damagePercentageLevelValue * GetEventDamage() *  GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId)
				debug call Print(R2S(damage) + " is damage.")
				// prevents endless damage loop
				call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, true)
				call UnitDamageTargetBJ(GetEventDamageSource(), GetTriggerUnit(), damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
				call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, false)
				call Spell.showDamageTextTag(GetTriggerUnit(), damage)
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A1FY', 'A1G3')
			call this.addGrimoireEntry('A1FZ', 'A1G4')
			call this.addGrimoireEntry('A1G0', 'A1G5')
			call this.addGrimoireEntry('A1G1', 'A1G6')
			call this.addGrimoireEntry('A1G2', 'A1G7')
			
			call DmdfHashTable.global().setHandleBoolean(character.unit(), thistype.damageKey, false)
			call Game.registerOnDamageActionOnce(thistype.onDamageAction)
			
			return this
		endmethod
	endstruct

endlibrary
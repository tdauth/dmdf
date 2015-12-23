/// Dragon Slayer
library StructSpellsSpellThrillOfVictory requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Passiv. Schaden gegen Gegner wird um X % * die Anzahl der verbliebenen Gegner im Umkreis erhöht.
	struct SpellThrillOfVictory extends Spell
		public static constant integer abilityId = 'A1FR'
		public static constant integer favouriteAbilityId = 'A1FS'
		public static constant integer classSelectionAbilityId = 'A1FT'
		public static constant integer classSelectionGrimoireAbilityId = 'A1FU'
		public static constant integer maxLevel = 1
		private static constant real damageOpponentPercentage = 0.05
		private static constant string damageKey = "SpellThrillOfVictory:Damage"
		
		private static method filterIsNotDead takes nothing returns boolean
			return not IsUnitDeadBJ(GetFilterUnit())
		endmethod

		/// Called by globan damage detection system.
		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local AGroup opponents
			local integer i
			local real damage
			// works on neutral and unallied units for the character but only if the ability is learned
			if (GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) == 0) then
				debug call Print("Thrill of Victory not learned")
				return
			endif
			
			if (DmdfHashTable.global().handleBoolean(GetEventDamageSource(), thistype.damageKey)) then
				debug call Print("Mercilessness recursive call")
				return
			endif
			
			set opponents = AGroup.create()
			call opponents.addUnitsInRange(GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()), 900.0, Filter(function thistype.filterIsNotDead))
			set i = 0
			loop
				exitwhen (i == opponents.units().size())
				if (opponents.units()[i] == GetTriggerUnit() or not IsUnitEnemy(opponents.units()[i], GetOwningPlayer(GetEventDamageSource()))) then
					call opponents.units().erase(i)
				else
					set i = i + 1
				endif
			endloop
			
			if (not opponents.units().isEmpty()) then
				set damage = thistype.damageOpponentPercentage * GetEventDamage() * opponents.units().size()
				debug call Print(R2S(damage) + " is damage with " + I2S(opponents.units().size()) + " enemies in range.")
				// prevents endless damage loop
				call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, true)
				call UnitDamageTargetBJ(GetEventDamageSource(), GetTriggerUnit(), damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
				call DmdfHashTable.global().setHandleBoolean(GetEventDamageSource(), thistype.damageKey, false)
				call Spell.showDamageTextTag(GetTriggerUnit(), damage)
			endif
			
			call opponents.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A1FT', 'A1FU')
			
			call DmdfHashTable.global().setHandleBoolean(character.unit(), thistype.damageKey, false)
			call Game.registerOnDamageActionOnce(thistype.onDamageAction)
			
			return this
		endmethod
	endstruct

endlibrary
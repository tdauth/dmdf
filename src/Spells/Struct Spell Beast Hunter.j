/// Dragon Slayer
library StructSpellsSpellBeastHunter requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Grundfähigkeit: Bestienjäger - Passiv. Schaden gegen wilde Kreaturen wird um 10% erhöht.
	struct SpellBeastHunter extends Spell
		public static constant integer abilityId = 'A075'
		public static constant integer favouriteAbilityId = 'A076'
		public static constant integer maxLevel = 1
		private static constant real damageBonusPercentage = 0.10

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local real damageBonus
			if (GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) > 0 and GetUnitRace(GetTriggerUnit()) == RACE_OTHER) then
				set damageBonus = GetEventDamage() * thistype.damageBonusPercentage
				call UnitDamageTargetBJ(GetEventDamageSource(), GetTriggerUnit(), damageBonus, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
				call Spell.showDamageTextTag(GetTriggerUnit(), damageBonus)
			//debug elseif (GetUnitAbilityLevel(GetEventDamageSource(), thistype.abilityId) == 0) then
				//debug call Print("Beast Hunter: Has no ability")
			//debug else
				//debug call Print("Beast Hunter: Wrong target race with id " + I2S(GetHandleId(GetUnitRace(GetTriggerUnit()))))
			endif
		endmethod

		public static method create takes Character character returns thistype
			call Game.registerOnDamageActionOnce(thistype.onDamageAction)
			return thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
		endmethod
	endstruct

endlibrary
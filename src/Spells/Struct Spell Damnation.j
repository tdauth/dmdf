/// Necromancer
library StructSpellsSpellDamnation requires Asl, StructGameClasses, StructGameSpell

	struct SpellDamnation extends Spell
		public static constant integer abilityId = 'A1QD'
		public static constant integer favouriteAbilityId = 'A1QE'
		public static constant integer classSelectionAbilityId = 'A1QF'
		public static constant integer classSelectionGrimoireAbilityId = 'A1QH'
		public static constant integer maxLevel = 1
		private static constant real damagePercentage = 0.80
		private static constant real radius = 600.0
		private static constant integer count = 6
		private static constant real time = 30.0
		private static sound whichSound

		private static method filter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit()) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_MECHANICAL)
		endmethod

		private static method corpseTargets takes real x, real y returns AGroup
			local AGroup whichGroup = AGroup.create()
			call whichGroup.addUnitsInRangeCounted(x, y, thistype.radius, Filter(function thistype.filter), thistype.count)

			return whichGroup
		endmethod

		private method condition takes nothing returns boolean
			return true
		endmethod

		private method action takes nothing returns nothing
			local real damage = GetUnitState(GetSpellTargetUnit(), UNIT_STATE_MAX_LIFE) * thistype.damagePercentage
			local effect targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, GetSpellTargetUnit(), "origin")
			local AEffectVector summonEffects = AEffectVector.create()
			local AGroup targets = thistype.corpseTargets(GetUnitX(GetSpellTargetUnit()), GetUnitY(GetSpellTargetUnit()))
			local integer i = 0
			local unit summonedUnit = null
			call PlaySoundOnUnitBJ(thistype.whichSound, 60.0, GetTriggerUnit())
			call UnitDamageTargetBJ(GetTriggerUnit(), GetSpellTargetUnit(), damage, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_NORMAL)
			call ShowBashTextTagForPlayer(null, GetUnitX(GetSpellTargetUnit()), GetUnitY(GetSpellTargetUnit()), R2I(damage))
			set i = 0
			loop
				exitwhen (i == targets.units().size())
				call summonEffects.pushBack(AddSpecialEffect("Abilities\\Spells\\Undead\\AnimateDead\\AnimateDeadTarget.mdl",  GetUnitX(targets.units()[i]), GetUnitY(targets.units()[i])))
				set summonedUnit = CreateUnit(this.character().player(), 'n07F', GetUnitX(targets.units()[i]), GetUnitY(targets.units()[i]), GetUnitFacing(targets.units()[i]))

				// make sure Master of Necromancy affects these units too
				if (GetUnitAbilityLevel(this.character().unit(), SpellMasterOfNecromancy.abilityId) > 0) then
					call UnitAddAbility(summonedUnit, SpellMasterOfNecromancy.damageAbilityId)
					call SetUnitAbilityLevel(summonedUnit, SpellMasterOfNecromancy.damageAbilityId, GetUnitAbilityLevel(this.character().unit(), SpellMasterOfNecromancy.abilityId))

					call UnitAddAbility(summonedUnit, SpellMasterOfNecromancy.defenseAbilityId)
					call SetUnitAbilityLevel(summonedUnit, SpellMasterOfNecromancy.defenseAbilityId, GetUnitAbilityLevel(this.character().unit(), SpellMasterOfNecromancy.abilityId))
				endif

				call UnitApplyTimedLife(summonedUnit, 'B032', thistype.time)
				set summonedUnit = null
				call RemoveUnit(targets.units()[i])
				set i = i + 1
			endloop
			call TriggerSleepAction(2.0)
			call DestroyEffect(targetEffect)
			set targetEffect = null
			call targets.destroy()
			set i = 0
			loop
				exitwhen (i == summonEffects.size())
				call DestroyEffect(summonEffects[i])
				set summonEffects[i] = null
				set i = i + 1
			endloop
			call summonEffects.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithEvent(character, Classes.necromancer(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action, EVENT_PLAYER_UNIT_SPELL_EFFECT) // if the event channel is used, the cooldown and mana costs are ignored if UnitDamageTargetBJ() kills the target

			call this.addGrimoireEntry('A1QF', 'A1QH')
			call this.addGrimoireEntry('A1QG', 'A1QI')

			return this
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.whichSound = CreateSound("Abilities\\Spells\\Undead\\ReviveUndead\\ReviveUndead.wav", false, false, true, 12700, 12700, "")
		endmethod
	endstruct

endlibrary
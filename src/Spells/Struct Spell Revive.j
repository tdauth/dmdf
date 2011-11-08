/// Cleric
library StructSpellsSpellRevive requires Asl, StructGameClasses, StructGameSpell

	/**
	* Lässt eine befreundete Einheit mit X% ihrer Lebens- und Y% ihrer Manapunkte wieder auferstehen.
	* Since dead units can't be selected in Warcraft, you have to select the target point.
	* All dead units in range will be checked by using priorities:
	* 1. Ally heroes (nearest)
	* 2. Allies (nearest)
	* 3. Neutrals (nearest)
	* For example if there is an hero with bigger distance to target point it will be favoured over an ally unit which has a smaller distance to target point.
	*/
	struct SpellRevive extends Spell
		public static constant integer abilityId = 'A056'
		public static constant integer favouriteAbilityId = 'A057'
		public static constant integer maxLevel = 5
		private static constant real radius = 800.0
		private static constant real lifeStartValue = 0.50
		private static constant real lifeLevelValue = 0.10
		private static constant real manaStartValue = 0.30
		private static constant real manaLevelValue = 0.10

		private static method filter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit())
		endmethod

		private method action takes nothing returns nothing
			local group whichGroup = CreateGroup()
			local AGroup unitGroup = AGroup.create()
			local unit caster
			local integer i
			local real oldDistance
			local boolean isHero
			local boolean isAlly
			local real distance
			local unit target
			local effect targetEffect
			local real life
			local real mana
			call GroupEnumUnitsInRange(whichGroup, GetSpellTargetX(), GetSpellTargetY(), thistype.radius, Filter(function thistype.filter))
			call unitGroup.addGroup(whichGroup, true, false) // destroys groupA
			set whichGroup = null

			if (not unitGroup.units().empty()) then
				set caster = this.character().unit()
				call unitGroup.removeEnemiesOfUnit(caster)
				if (not unitGroup.units().empty()) then
					set oldDistance = 99999999999999.0
					set isHero = false
					set isAlly = false
					set target = null
					set i = 0
					loop
						exitwhen (i == unitGroup.units().size())
						set distance = GetDistanceBetweenUnits(caster, unitGroup.units()[i], 0.0, 0.0)
						if (distance < oldDistance) then
							if ((distance < oldDistance and (target == null or (GetUnitAllianceStateToUnit(caster, unitGroup.units()[i]) == bj_ALLIANCE_ALLIED or not isAlly or (GetUnitAllianceStateToUnit(caster, unitGroup.units()[i]) == bj_ALLIANCE_ALLIED and IsUnitType(unitGroup.units()[i], UNIT_TYPE_HERO)) or (not isAlly and IsUnitType(unitGroup.units()[i], UNIT_TYPE_HERO)))) or (target == null or (GetUnitAllianceStateToUnit(caster, unitGroup.units()[i]) == bj_ALLIANCE_ALLIED and not isAlly) or ((GetUnitAllianceStateToUnit(caster, unitGroup.units()[i]) == bj_ALLIANCE_ALLIED or (GetUnitAllianceStateToUnit(caster, unitGroup.units()[i]) != bj_ALLIANCE_ALLIED and not isAlly)) and IsUnitType(unitGroup.units()[i], UNIT_TYPE_HERO) and not isHero)))) then
								set oldDistance = distance
								set isHero = IsUnitType(unitGroup.units()[i], UNIT_TYPE_HERO)
								set isAlly = GetUnitAllianceStateToUnit(caster, unitGroup.units()[i]) == bj_ALLIANCE_ALLIED
								set target = null
								set target = unitGroup.units()[i]
							endif
						endif
						set i = i + 1
					endloop
					debug if (target == null) then
						debug call Print("Revive error, no target")
					debug endif
					set targetEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "origin")
					set life = GetUnitState(target, UNIT_STATE_MAX_LIFE) * (thistype.lifeStartValue + this.level() * thistype.lifeLevelValue)
					set mana = GetUnitState(target, UNIT_STATE_MAX_MANA) * (thistype.manaStartValue + this.level() * thistype.manaLevelValue)
					debug call Print("Revive unit " + GetUnitName(target) + ".")
					call SetUnitState(target, UNIT_STATE_LIFE, life)
					call SetUnitState(target, UNIT_STATE_MANA, mana)
					call TriggerSleepAction(1.0)
					set target = null
					call DestroyEffect(targetEffect)
					set targetEffect = null
				else
					call this.character().displayMessage(ACharacter.messageTypeError, tr("Kein totes Ziel gefunden."))
				endif
				set caster = null
			else
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Kein totes Ziel gefunden."))
			endif
			call unitGroup.destroy()
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary
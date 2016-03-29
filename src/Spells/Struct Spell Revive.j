/// Cleric
library StructSpellsSpellRevive requires Asl, StructGameClasses, StructGameSpell, StructGameFellow

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
		public static constant integer classSelectionAbilityId = 'A1NH'
		public static constant integer classSelectionGrimoireAbilityId = 'A1NI'
		public static constant integer maxLevel = 5
		private static constant real radius = 800.0
		private static constant real lifeStartValue = 0.50
		private static constant real lifeLevelValue = 0.10
		private static constant real manaStartValue = 0.30
		private static constant real manaLevelValue = 0.10
		private static constant integer ressurectAbilityId = 'A0O2'
		private static constant integer reviverUnitTypeId = 'h01B'

		/**
		 * Summoned or structure units should not be revived.
		 */
		private static method filter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit()) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_SUMMONED)
		endmethod
		
		private method targets takes nothing returns AGroup
			local AGroup unitGroup = AGroup.create()
			call unitGroup.addUnitsInRange(GetSpellTargetX(), GetSpellTargetY(), thistype.radius, Filter(function thistype.filter))
			call unitGroup.removeEnemiesOfUnit(this.character().unit())
			
			return unitGroup
		endmethod
		
		private method getFirstTarget takes unit caster, AGroup unitGroup returns unit
			local unit member = null
			local real oldDistance = 0.0
			local boolean isHero = false
			local boolean isAlly = false
			local boolean smallerDistance = false
			local real distance = 0.0
			local unit target = null
			local integer i = 0
			loop
				exitwhen (i == unitGroup.units().size())
				set member = unitGroup.units()[i]
				set distance = GetDistanceBetweenUnitsWithoutZ(caster, member)
				set smallerDistance = distance < oldDistance
				if (target == null or (GetUnitAllianceStateToUnit(caster, member) == bj_ALLIANCE_ALLIED and (not isAlly or smallerDistance or (IsUnitType(member, UNIT_TYPE_HERO) and not isHero))) or (GetUnitAllianceStateToUnit(caster, member) != bj_ALLIANCE_ALLIED and not isAlly and (smallerDistance or (IsUnitType(member, UNIT_TYPE_HERO) and not isHero)))) then
					set oldDistance = distance
					set isHero = IsUnitType(member, UNIT_TYPE_HERO)
					set isAlly = GetUnitAllianceStateToUnit(caster, member) == bj_ALLIANCE_ALLIED
					set target = null
					set target = member
				endif
				set member = null
				set i = i + 1
			endloop
			
			return target
		endmethod

		private method condition takes nothing returns boolean
			local AGroup targets = this.targets()
			local boolean result = true
			
			if (targets.units().empty()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Kein totes Ziel gefunden.", "No dead target found."))
				
				set result = false
			endif
			
			call targets.destroy()
			
			return result
		endmethod
		
		private static method revivalAt takes real x, real y returns boolean
			local boolean result = false
			local unit dummy = CreateUnit(Player(15), thistype.reviverUnitTypeId, x, y, 0)
			call SetUnitPathing(dummy, false)
			call SetUnitInvulnerable(dummy, true)
			call ShowUnit(dummy, false)
			call UnitAddAbility(dummy, thistype.ressurectAbilityId)
			call SetUnitX(dummy, x)
			call SetUnitY(dummy, y)
			set result = IssueImmediateOrder(dummy, "resurrection")
			call TriggerSleepAction(1.0) // TODO necessary?
			
			return result
		endmethod
		
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AGroup targets = this.targets()
			local unit target = this.getFirstTarget(caster, targets)
			local effect targetEffect
			local boolean success = false
			local real life
			local real mana
			debug call Print("Possible targets " + I2S(targets.units().size()))
			debug if (target == null) then
				debug call Print("Revive error, no target")
			debug endif
			
			debug call Print("Target is: " + GetUnitName(target))
			
			// uses the following system as inspiration: http://www.hiveworkshop.com/forums/jass-resources-412/snippet-reviveunit-186696/
			// is hero
			if (IsUnitType(target, UNIT_TYPE_HERO) == true) then
				set success = ReviveHero(target, GetUnitX(target), GetUnitY(target), false)
			// is no hero: use dummy caster
			else
				set success = thistype.revivalAt(GetUnitX(target), GetUnitY(target))
			endif
			
			// make sure that automatic revivals are canceled or hidden
			if (success) then
				if (ACharacter.isUnitCharacter(target)) then
					call ACharacter.getCharacterByUnit(target).revival().end()
				elseif (Fellow.getByUnit(target) != 0) then
					call Fellow.getByUnit(target).endRevival()
				endif
			debug else
				debug call Print("Error on revival order!")
			endif
			
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
				
			set caster = null
			call targets.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1NH', 'A1NI')
			call this.addGrimoireEntry('A0O3', 'A0O8')
			call this.addGrimoireEntry('A0O4', 'A0O9')
			call this.addGrimoireEntry('A0O5', 'A0OA')
			call this.addGrimoireEntry('A0O6', 'A0OB')
			call this.addGrimoireEntry('A0O7', 'A0OC')
			
			return this
		endmethod
	endstruct

endlibrary
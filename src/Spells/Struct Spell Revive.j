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
		public static constant integer classSelectionAbilityId = 'A0O3'
		public static constant integer classSelectionGrimoireAbilityId = 'A0O8'
		public static constant integer maxLevel = 5
		private static constant real radius = 800.0
		private static constant real lifeStartValue = 0.50
		private static constant real lifeLevelValue = 0.10
		private static constant real manaStartValue = 0.30
		private static constant real manaLevelValue = 0.10
		private static constant integer ressurectAbilityId = 'A0O2'
		private static constant integer reviverUnitTypeId = 'h01B'
		private static unit reviver

		/**
		 * Summoned or structure units should not be revived.
		 */
		private static method filter takes nothing returns boolean
			return IsUnitDeadBJ(GetFilterUnit()) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_STRUCTURE) and not IsUnitType(GetFilterUnit(), UNIT_TYPE_SUMMONED)
		endmethod

		private method action takes nothing returns nothing
			local group whichGroup = CreateGroup()
			local AGroup unitGroup = AGroup.create()
			local unit caster
			local unit member
			local integer i
			local real oldDistance
			local boolean isHero
			local boolean isAlly
			local boolean smallerDistance = false
			local real distance
			local unit target
			local effect targetEffect
			local boolean success = false
			local real life
			local real mana
			call GroupEnumUnitsInRange(whichGroup, GetSpellTargetX(), GetSpellTargetY(), thistype.radius, Filter(function thistype.filter))
			call unitGroup.addGroup(whichGroup, true, false) // destroys whichGroup
			set whichGroup = null
			debug call Print("Possible targets " + I2S(unitGroup.units().size()))
			set caster = this.character().unit()

			if (not unitGroup.units().empty()) then
				call unitGroup.removeEnemiesOfUnit(caster)
				if (not unitGroup.units().empty()) then
					set oldDistance = 0.0
					set isHero = false
					set isAlly = false
					set target = null
					set i = 0
					loop
						exitwhen (i == unitGroup.units().size())
						set member = unitGroup.units()[i]
						set distance = GetDistanceBetweenUnits(caster, member, 0.0, 0.0)
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
						call SetUnitX(thistype.reviver, GetUnitX(target))
						call SetUnitY(thistype.reviver, GetUnitY(target))
						call PauseUnit(thistype.reviver, false)
						set success = IssueImmediateOrder(thistype.reviver, "resurrection")
						call PauseUnit(thistype.reviver, true)
					endif
					
					// make sure that automatic revivals are canceled or hidden
					if (success) then
						if (ACharacter.isUnitCharacter(target)) then
							call ACharacter.getCharacterByUnit(target).revival().end()
						elseif (Fellow.getByUnit(target) != 0) then
							call Fellow.getByUnit(target).endRevival()
						endif
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
				else
					call IssueImmediateOrder(caster, "stop")
					call this.character().displayMessage(ACharacter.messageTypeError, tr("Kein totes Ziel gefunden."))
				endif
			else
				call IssueImmediateOrder(caster, "stop")
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Kein totes Ziel gefunden."))
			endif
			set caster = null
			call unitGroup.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0O3', 'A0O8')
			call this.addGrimoireEntry('A0O4', 'A0O9')
			call this.addGrimoireEntry('A0O5', 'A0OA')
			call this.addGrimoireEntry('A0O6', 'A0OB')
			call this.addGrimoireEntry('A0O7', 'A0OC')
			
			return this
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.reviver = CreateUnit(Player(15), thistype.reviverUnitTypeId, 0.0, 0.0, 0)
			call SetUnitPathing(thistype.reviver, false)
			call PauseUnit(thistype.reviver, true)
			call SetUnitInvulnerable(thistype.reviver, true)
			call ShowUnit(thistype.reviver, false)
			call UnitAddAbility(thistype.reviver, thistype.ressurectAbilityId)
		endmethod
	endstruct

endlibrary
/// Elemental Mage
library StructSpellsSpellFreeze requires Asl, StructGameClasses, StructGameSpell

	/// Alle Gegner in einem Umkreis von X Metern um den Magier werden Y Sekunden lang betäubt.
	struct SpellFreeze extends Spell
		public static constant integer abilityId = 'A019'
		public static constant integer favouriteAbilityId = 'A03J'
		public static constant integer classSelectionAbilityId = 'A1L3'
		public static constant integer classSelectionGrimoireAbilityId = 'A1L4'
		public static constant integer maxLevel = 5
		private static constant real rangeStartValue = 500.0
		private static constant real rangeLevelValue = 100.0 //ab Stufe 1
		private static constant real timeLevelSummand = 2.0 //wird zur Stufe addiert
		private static sound whichSound

		private static method filter takes nothing returns boolean
			local unit filterUnit = GetFilterUnit()
			local boolean result = not IsUnitDeadBJ(filterUnit)
			set filterUnit = null
			return result
		endmethod
		
		private method targets takes unit caster returns AGroup
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			local unit target
			local integer i
			call GroupEnumUnitsInRange(targetGroup, GetUnitX(caster), GetUnitY(caster), thistype.rangeStartValue + thistype.rangeLevelValue * this.level(), filter)
			if (not IsUnitGroupEmptyBJ(targetGroup)) then
				call targets.addGroup(targetGroup, true, false) //destroys the group
				set targetGroup = null
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					if (GetUnitAllianceStateToUnit(caster, target) != bj_ALLIANCE_UNALLIED or IsUnitSpellImmune(target)) then
						call targets.units().erase(i)
					else
						set i = i + 1
					endif
					set target = null
				endloop
			else
				call DestroyGroup(targetGroup)
				set targetGroup = null
			endif
			
			call DestroyFilter(filter)
			set filter = null
			
			return targets
		endmethod
		
		private method condition takes nothing returns boolean
			local AGroup targets = this.targets(GetTriggerUnit())
			local boolean result = not targets.units().isEmpty()
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine Ziele in Reichweite.", "No targets in range."))
			endif
			
			call targets.destroy()
			
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = GetTriggerUnit()
			local effect spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local AGroup targets = this.targets(caster)
			local AEffectVector effects = AEffectVector.create()
			local integer i
			local unit target
			local real time
			call PlaySoundOnUnitBJ(thistype.whichSound, 100.0, caster)
			if (not targets.units().empty()) then
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					debug call Print("Stunning "  + GetUnitName(target))
					call PauseUnit(target, true)
					call effects.pushBack(AddSpecialEffectTarget("Models\\Effects\\FreezeBuff.mdx", target, "origin"))
					set target = null
					set i = i + 1
				endloop
				/// @todo Remove after disspell, check after each interval.
				set time = thistype.timeLevelSummand + this.level()
				loop
					exitwhen (time <= 0.0 or targets.isDead())
					set i = 0
					loop
						exitwhen (i == targets.units().size())
						set target = targets.units()[i]
						if (ASpell.enemyTargetLoopCondition(target)) then
							debug call Print("Destunning "  + GetUnitName(target))
							call PauseUnit(target, false)
							call targets.units().erase(i)
							call DestroyEffect(effects[i])
							call effects.erase(i)
						else
							set i = i + 1
						endif
						set target = null
					endloop
					call TriggerSleepAction(1.0)
					set time = time - 1.0
				endloop
				set i = 0
				loop
					exitwhen (i == targets.units().size())
					set target = targets.units()[i]
					debug call Print("Destunning "  + GetUnitName(target))
					call PauseUnit(target, false)
					call DestroyEffect(effects[i])
					set target = null
					set i = i + 1
				endloop
			endif
			call targets.destroy()
			call effects.destroy()
			set caster = null
			call DestroyEffect(spellEffect)
			set spellEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1L3', 'A1L4')
			call this.addGrimoireEntry('A0UV', 'A0V0')
			call this.addGrimoireEntry('A0UW', 'A0V1')
			call this.addGrimoireEntry('A0UX', 'A0V2')
			call this.addGrimoireEntry('A0UY', 'A0V3')
			call this.addGrimoireEntry('A0UZ', 'A0V4')
			
			return this
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.whichSound = CreateSound("Abilities\\Spells\\Undead\\FreezingBreath\\FreezingBreathTarget1.wav", false, false, true, 12700, 12700, "")
		endmethod
	endstruct

endlibrary
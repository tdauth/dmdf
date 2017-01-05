/// Knight
library StructSpellsSpellPowerOfShrines requires Asl, StructGameClasses, StructGameSpell, StructGameShrine

	struct SpellPowerOfShrines extends Spell
		public static constant integer abilityId = 'A1QJ'
		public static constant integer favouriteAbilityId = 'A1QK'
		public static constant integer classSelectionAbilityId = 'A1QL'
		public static constant integer classSelectionGrimoireAbilityId = 'A1QR'
		public static constant integer maxLevel = 5
		public static constant real range = 300.0
		private static sound castSound

		private static method filter takes nothing returns boolean
			return not IsUnitDeadBJ(GetFilterUnit())
		endmethod

		/**
		 * \return Returns a newly created group instance with all valid targets.
		 */
		private method targets takes nothing returns AGroup
			local unit caster = this.character().unit()
			local group targetGroup = CreateGroup()
			local filterfunc filter = Filter(function thistype.filter)
			local AGroup targets = AGroup.create()
			call GroupEnumUnitsInRange(targetGroup, GetSpellTargetX(), GetSpellTargetY(), thistype.range, filter)
			call targets.addGroup(targetGroup, true, false)
			set targetGroup = null
			call targets.removeAlliesOfUnit(caster)
			set caster = null
			call DestroyFilter(filter)
			set filter = null
			return targets
		endmethod

		private method condition takes nothing returns boolean
			local AGroup targets = this.targets()
			local boolean result
			debug call Print("Before removing allies: " + I2S(targets.units().size()))
			set result = not targets.units().empty()
			call targets.destroy()
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine gültigen Ziele in der Nähe.", "No valid targets in range."))
			endif
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = null
			local AGroup targets = this.targets()
			local real mapSize = 0.0
			local real damage = 0.0
			local unit shrineUnit = null
			local AIntegerVector dynamicLightings = AIntegerVector.create()
			local integer i = 0
			call PlaySoundOnUnitBJ(thistype.castSound, 100.0, caster)
			if (not targets.units().empty()) then
				set i = 0
				loop
					exitwhen (i == Shrine.shrines())
					set shrineUnit = Shrine(Shrine.shrines()[i]).unit()
					if (IsVisibleToPlayer(GetUnitX(shrineUnit), GetUnitX(shrineUnit), this.character().player())) then
						call dynamicLightings.pushBack(ADynamicLightning.create(null, "CHIM", shrineUnit, caster))
						call ADynamicLightning(dynamicLightings.back()).setDestroyOnDeath(false)
					endif
					set i = i + 1
				endloop

				// the damage depends on the number of discovered shrines and the map size
				set mapSize = (((GetRectMaxX(GetPlayableMapRect()) - GetRectMinX(GetPlayableMapRect())) * (GetRectMaxY(GetPlayableMapRect()) - GetRectMinY(GetPlayableMapRect()))) * 0.00000001)
				debug call Print("Map size: " + R2S(mapSize))
				set damage = (I2R(dynamicLightings.size() + this.level()) * 100.0) / mapSize

				set i = 0
				loop
					exitwhen (i == targets.units().size())
					// TODO damage unit with effect
					set target = targets.units()[i]
					call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
					call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
					set i = i + 1
				endloop
				call TriggerSleepAction(4.0)
				set i = 0
				loop
					exitwhen (i == dynamicLightings.size())
					call ADynamicLightning(dynamicLightings[i]).destroy()
					set i = i + 1
				endloop
			endif
			set caster = null
			call targets.destroy()
			call dynamicLightings.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1QL', 'A1QR')
			call this.addGrimoireEntry('A1QM', 'A1QS')
			call this.addGrimoireEntry('A1QN', 'A1QT')
			call this.addGrimoireEntry('A1QO', 'A1QU')
			call this.addGrimoireEntry('A1QP', 'A1QV')
			call this.addGrimoireEntry('A1QQ', 'A1QW')

			return this
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.castSound = CreateSound("Abilities\\Spells\\Human\\MarkOfChaos\\MarkOfChaos.wav", false, false, true, 12700, 12700, "")
			call SetSoundChannel(thistype.castSound, GetHandleId(SOUND_VOLUMEGROUP_SPELLS))
		endmethod
	endstruct

endlibrary
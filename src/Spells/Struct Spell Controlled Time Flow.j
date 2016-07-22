/// Wizard
library StructSpellsSpellControlledTimeFlow requires Asl, StructGameClasses, StructGameDmdfHashTable, StructGameGame, StructGameSpell

	/// Der Zauberer hält X Sekunden lang die Zeit an. Dabei werden sämtliche Einheiten angehalten und sind angriffs- und bewegungsunfähig. Außerdem wird der Tageszeitzyklus gestoppt. Der Zauberer selbst, sowie Verbündete im Umkreis von Y, können sich mit Z% ihrer Bewegungsgeschwindigkeit weiterhin bewegen.
	/**
	 * Whenever an allied unit comes into range it is added to group of allies and unpaused.
	 * All allied units in ranged are checked each second for still being in range. If not they are paused again.
	 * \todo Add buff and check for multiple casts.
	 * \todo hook pause and unpause - NPCs etc.
	 * \todo Fix entering and leaving range triggers
	 */
	struct SpellControlledTimeFlow extends Spell
		public static constant integer abilityId = 'A09O'
		public static constant integer favouriteAbilityId = 'A09N'
		public static constant integer classSelectionAbilityId = 'A1JP'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JQ'
		public static constant integer maxLevel = 1
		private static constant real time = 7.0
		private static constant real range = 600.0
		private static constant real speed = 0.20

		private static method filter takes nothing returns boolean
			return true /// \todo Check for buff if spell has been casted several times
		endmethod

		private static method pauseTarget takes unit whichUnit returns nothing
			call PauseUnit(whichUnit, true)
		endmethod

		private static method unpauseTarget takes unit whichUnit returns nothing
			call PauseUnit(whichUnit, false)
		endmethod

		/// \todo Add buff.
		private static method applyAllyEffect takes unit whichUnit returns nothing

			local real bonus = Game.addUnitMoveSpeed(whichUnit, -GetUnitMoveSpeed(whichUnit) * thistype.speed)
			local effect spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, whichUnit, "origin")
			call DmdfHashTable.global().setHandleReal(whichUnit, DMDF_HASHTABLE_KEY_CONTROLLEDTIMEFLOW_MOVESPEED, bonus)
			call DmdfHashTable.global().setHandleEffect(whichUnit, DMDF_HASHTABLE_KEY_CONTROLLEDTIMEFLOW_EFFECT, spellEffect)
			call Spell.showMoveSpeedTextTag(whichUnit, bonus)
		endmethod

		/// \todo Add buff.
		private static method removeAllyEffect takes unit whichUnit returns nothing
			local real bonus = DmdfHashTable.global().handleReal(whichUnit, DMDF_HASHTABLE_KEY_CONTROLLEDTIMEFLOW_MOVESPEED)
			local effect spellEffect = DmdfHashTable.global().handleEffect(whichUnit, DMDF_HASHTABLE_KEY_CONTROLLEDTIMEFLOW_EFFECT)
			call Game.addUnitMoveSpeed(whichUnit, -bonus)
			call DestroyEffect(spellEffect)
			set spellEffect = null
			call Spell.showMoveSpeedTextTag(whichUnit, -bonus)
		endmethod

		private static method enterCondition takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			local AGroup allies = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 1)
			if (GetUnitAllianceStateToUnit(this.character().unit(), GetTriggerUnit()) == bj_ALLIANCE_ALLIED and not allies.units().contains(GetTriggerUnit())) then
				call PauseUnit(GetTriggerUnit(), false)
				call allies.units().pushBack(GetTriggerUnit())
				call thistype.applyAllyEffect(GetTriggerUnit())
			endif
			return false
		endmethod

		private method createEnterTrigger takes trigger whichTrigger, AGroup allies returns nothing
			call TriggerRegisterUnitInRange(whichTrigger, this.character().unit(), thistype.range, null)
			call TriggerAddCondition(whichTrigger, Condition(function thistype.enterCondition))
			call DmdfHashTable.global().setHandleInteger(whichTrigger, 0, this)
			call DmdfHashTable.global().setHandleInteger(whichTrigger, 1, allies)
		endmethod

		private static method mapCondition takes nothing returns boolean
			local AGroup targets = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0)
			call PauseUnit(GetTriggerUnit(), true)
			call thistype.applyAllyEffect(GetTriggerUnit())
			call targets.units().pushBack(GetTriggerUnit())
			return false
		endmethod

		private method createMapTrigger takes trigger whichTrigger, AGroup targets returns region
			local region rectRegion = CreateRegion()
			call RegionAddRect(rectRegion, GetPlayableMapRect())
			call TriggerRegisterEnterRegion(whichTrigger, rectRegion, null)
			call TriggerAddCondition(whichTrigger, Condition(function thistype.mapCondition))
			call DmdfHashTable.global().setHandleInteger(whichTrigger, 0, targets)
			return rectRegion
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local real time = thistype.time
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			local integer i
			local AGroup unitGroup = AGroup.create()
			local AGroup allies = AGroup.create()
			local trigger enterTrigger = CreateTrigger()
			local trigger mapTrigger = CreateTrigger()
			local region mapRegion
			call allies.addUnitsInRange(GetUnitX(caster), GetUnitY(caster), thistype.range, null)
			call unitGroup.addUnitsInRect(GetPlayableMapRect(), Filter(function thistype.filter))
			debug call Print("Controlled Time Flow: " + I2S(unitGroup.units().size()) + " units.")
			debug call Print("Controlled Time Flow: " + I2S(allies.units().size()) + " allies.")
			// drop all allies in range
			// it might be better for the perfomance to get allies in range and THEN to exclude them from the group. Otherwise too many iterations
			set i = 0
			loop
				exitwhen (i == allies.units().size())
				if (GetUnitAllianceStateToUnit(caster, allies.units()[i]) != bj_ALLIANCE_ALLIED and caster != allies.units()[i]) then
					call allies.units().erase(i)
					debug call Print("Got ally " + GetUnitName(unitGroup.units()[i]) + " in range remaining units " + I2S(unitGroup.units().size()))
				// remove all allies from the targets
				else
					debug call Print("Removing ally from all units " + GetUnitName(allies.units()[i]))
					// FIXME seems to be too slow and the method cancels here.
					call thistype.removeUnitFromGroupWithNewOp.evaluate(unitGroup, allies.units()[i])
					debug call Print("Done Removal!")
					set i = i + 1
				endif
			endloop
			debug call Print("Remaining targets: " + I2S(unitGroup.units().size()) + " and remaining allies: " + I2S(allies.units().size()))
			call unitGroup.forGroup(thistype.pauseTarget)
			debug call Print("After pausing")
			call allies.forGroup(thistype.applyAllyEffect)
			debug call Print("After applying ally effect")
			call this.createEnterTrigger(enterTrigger, allies)
			debug call Print("After creating trigger")
			set mapRegion = this.createMapTrigger(mapTrigger, unitGroup)
			debug call Print("After creating map trigger")
			call SuspendTimeOfDay(true)
			debug call Print("Controlled Time Flow: " + I2S(unitGroup.units().size()) + " units.")
			debug call Print("Controlled Time Flow: " + I2S(allies.units().size()) + " allies.")

			loop
				exitwhen (time <= 0.0 or thistype.allyTargetLoopCondition(caster))
				call TriggerSleepAction(1.0)
				// check for range of allies
				set i = 0
				loop
					exitwhen (i == allies.units().size())
					if (not IsUnitInRange(caster, allies.units()[i], thistype.range)) then
						call thistype.removeAllyEffect(allies.units()[i])
						call PauseUnit(allies.units()[i], true)
						call allies.units().erase(i)
					else
						set i = i + 1
					endif
				endloop
				// TODO check via event and trigger
				set time = time - 1.0
			endloop

			call unitGroup.forGroup(thistype.unpauseTarget)
			call allies.forGroup(thistype.removeAllyEffect)
			call SuspendTimeOfDay(false) /// TODO only suspend if not suspended before, use hook!

			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call unitGroup.destroy()
			call allies.destroy()
			call DmdfHashTable.global().destroyTrigger(enterTrigger)
			set enterTrigger = null
			call DmdfHashTable.global().destroyTrigger(mapTrigger)
			set mapTrigger = null
			call RemoveRegion(mapRegion)
			set mapRegion = null
		endmethod
		
		private static method removeUnitFromGroupWithNewOp takes AGroup whichGroup, unit whichUnit returns nothing
			call whichGroup.units().remove(whichUnit)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.wizard(), Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1JP', 'A1JQ')
			call this.addGrimoireEntry('A0K3', 'A0K4')
			
			return this
		endmethod
	endstruct

endlibrary
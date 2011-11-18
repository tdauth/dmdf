/// Knight
library StructSpellsSpellRush requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Ritter stürmt sein Ziel an, betäubt es 2 Sekunden lang und fügt ihm X Punkte Schaden zu. Wenig Schaden.
	struct SpellRush extends Spell
		public static constant integer abilityId = 'A01Q'
		public static constant integer favouriteAbilityId = 'A033'
		public static constant integer maxLevel = 5
		private static constant real speedFactor = 0.80
		private static constant real damageFactor = 20.0

		private method action takes nothing returns nothing
			local unit characterUnit = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real bonus = Game.addUnitMoveSpeed(target, GetUnitMoveSpeed(target)  * thistype.speedFactor)
			call IssueTargetOrder(characterUnit, "attack", target)
			loop
				exitwhen (ASpell.enemyTargetLoopCondition(target) or GetUnitCurrentOrder(characterUnit) != OrderId("attack"))
				if (GetDistanceBetweenUnits(characterUnit, target, 0.0, 0.0) <= 300.0) then
					debug call Print("Stop!")
					call IssueImmediateOrder(characterUnit, "stop")
					debug call Print("Attack animation")
					call SetUnitAnimation(characterUnit, "attack")
					debug call Print("Add ability")
					call UnitAddAbility(characterUnit, 'A01R')
					call IssueTargetOrderById(characterUnit, 'A01R', target)
					call UnitRemoveAbility(characterUnit, 'A01R')
					call UnitDamageTargetBJ(characterUnit, target, this.level() * thistype.damageFactor, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
					call ShowBashTextTagForPlayer(this.character().player(), GetWidgetX(target), GetWidgetY(target), R2I(this.level() * thistype.damageFactor))
					call ResetUnitAnimation(characterUnit)
					exitwhen (true)
				endif
				debug call Print("Before loop wait action")
				call TriggerSleepAction(1.0)
				debug call Print("After loop wait action")
			endloop
			call Game.removeUnitMoveSpeed(target, bonus)
			set characterUnit = null
			set target = null
		endmethod

		public static method create takes ACharacter character returns thistype
			return thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary
/// Knight
library StructSpellsSpellRush requires Asl, StructGameClasses, StructGameGame, StructGameSpell

	/// Der Ritter stürmt sein Ziel an, betäubt es 2 Sekunden lang und fügt ihm X Punkte Schaden zu. Wenig Schaden.
	struct SpellRush extends Spell
		public static constant integer abilityId = 'A01Q'
		public static constant integer favouriteAbilityId = 'A033'
		public static constant integer classSelectionAbilityId = 'A1NN'
		public static constant integer classSelectionGrimoireAbilityId = 'A1NO'
		public static constant integer maxLevel = 5
		private static constant real speedFactor = 0.80
		private static constant real damageFactor = 20.0
		private static constant integer dummyUnitTypeId = 'h025'
		private unit dummy

		private method action takes nothing returns nothing
			local unit characterUnit = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real bonus = Game.addUnitMoveSpeed(characterUnit, GetUnitMoveSpeed(characterUnit) * thistype.speedFactor)
			local unit dummy
			debug call Print("Bonus: " + R2S(bonus))
			call IssueTargetOrder(characterUnit, "attack", target)
			loop
				exitwhen (thistype.enemyTargetLoopCondition(target) or GetUnitCurrentOrder(characterUnit) != OrderId("attack"))
				if (GetDistanceBetweenUnits(characterUnit, target, 0.0, 0.0) <= 300.0) then
					debug call Print("Stop!")
					call IssueImmediateOrder(characterUnit, "stop")
					debug call Print("Attack animation")
					call SetUnitAnimation(characterUnit, "attack")
					debug call Print("Add ability")
					// dummy ability
					call SetUnitX(this.dummy, GetUnitX(target))
					call SetUnitY(this.dummy, GetUnitY(target))
					if (not IssueTargetOrder(this.dummy, "thunderbold", target)) then
						debug call Print("Error on ordering thunderbold.")
					endif
					
					call UnitDamageTargetBJ(characterUnit, target, this.level() * thistype.damageFactor, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL)
					call ShowBashTextTagForPlayer(this.character().player(), GetWidgetX(target), GetWidgetY(target), R2I(this.level() * thistype.damageFactor))
					call ResetUnitAnimation(characterUnit)
					exitwhen (true)
				endif
				debug call Print("Before loop wait action")
				call TriggerSleepAction(1.0)
				debug call Print("After loop wait action")
			endloop
			debug call Print("Removing bonus: " + R2S(bonus))
			call Game.removeUnitMoveSpeed(characterUnit, bonus)
			set characterUnit = null
			set target = null
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.createWithEvent(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action, EVENT_PLAYER_UNIT_SPELL_EFFECT) // if the event channel is used, the cooldown and mana costs are ignored if UnitDamageTargetBJ() kills the target
			
			set this.dummy = CreateUnit(GetOwningPlayer(character.unit()), thistype.dummyUnitTypeId, GetUnitX(character.unit()), GetUnitY(character.unit()), 0.0)
			call SetUnitInvulnerable(this.dummy, true)
			call ShowUnit(this.dummy, false)
			call UnitAddAbility(this.dummy, 'A01R')
			
			call this.addGrimoireEntry('A1NN', 'A1NO')
			call this.addGrimoireEntry('A0XS', 'A0XX')
			call this.addGrimoireEntry('A0XT', 'A0XY')
			call this.addGrimoireEntry('A0XU', 'A0XZ')
			call this.addGrimoireEntry('A0XV', 'A0Y0')
			call this.addGrimoireEntry('A0XW', 'A0Y1')
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call RemoveUnit(this.dummy)
			set this.dummy = null
		endmethod
	endstruct

endlibrary
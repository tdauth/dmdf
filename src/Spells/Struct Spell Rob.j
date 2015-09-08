/// Dragon Slayer
library StructSpellsSpellRob requires Asl, StructGameClasses, StructGameSpell

	struct SpellRob extends Spell
		public static constant integer abilityId = 'A1A3'
		public static constant integer favouriteAbilityId = 'A1A4'
		public static constant integer classSelectionAbilityId = 'A1A5'
		public static constant integer classSelectionGrimoireAbilityId = 'A1A6'
		public static constant integer maxLevel = 5
		public static constant real time = 40.0
		private AUnitList m_targets
		
		private method condition takes nothing returns boolean
			if (GetOwningPlayer(GetSpellTargetUnit()) == this.character().player()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Eigene Einheiten können nicht bestohlen werden."))
				return false
			elseif (this.m_targets.contains(GetSpellTargetUnit())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Einheit wurde erst kürzlich bestohlen."))
				
				return false
			endif
			
			return true
		endmethod
		
		private static method timerFunctionReset takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			local unit target = DmdfHashTable.global().handleUnit(GetExpiredTimer(), "target")
			call this.m_targets.remove(target)
			debug call Print("Resetting rob target: " + GetUnitName(target))
			set target = null
			call PauseTimer(GetExpiredTimer())
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod
		
		private method action takes nothing returns nothing
			local integer gold = this.level() * GetUnitLevel(GetSpellTargetUnit())
			local effect whichEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, GetSpellTargetUnit(), "chest")
			local timer whichTimer
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call AdjustPlayerStateBJ(gold, Player(i), PLAYER_STATE_RESOURCE_GOLD)
					call ShowBountyTextTagForPlayer(Player(i), GetUnitX(GetSpellTargetUnit()), GetUnitY(GetSpellTargetUnit()), gold)
				endif
				set i = i + 1
			endloop
			call this.m_targets.pushBack(GetSpellTargetUnit())
			set whichTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(whichTimer, "this", this)
			call DmdfHashTable.global().setHandleUnit(whichTimer, "target", GetSpellTargetUnit())
			call TimerStart(whichTimer, thistype.time, false, function thistype.timerFunctionReset)
			
			call TriggerSleepAction(2.0)
			call DestroyEffect(whichEffect)
			set whichEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1A5', 'A1A6')
			// TODO use different abilities
			call this.addGrimoireEntry('A1A5', 'A1A6')
			call this.addGrimoireEntry('A1A5', 'A1A6')
			call this.addGrimoireEntry('A1A5', 'A1A6')
			call this.addGrimoireEntry('A1A5', 'A1A6')
			
			set this.m_targets = AUnitList.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_targets.destroy()
		endmethod
	endstruct

endlibrary
/// Knight
library StructSpellsSpellResolution requires Asl, StructGameClasses, StructGameSpell

	// Standfestigkeit
	// Bei Aktivierung entfernt der Ritter alle negativen magischen Effekte von sich selbst und regeneriert sein Leben für jeden entfernten Effekt.
	struct SpellResolution extends Spell
		public static constant integer abilityId = 'A028'
		public static constant integer favouriteAbilityId = 'A040'
		public static constant integer maxLevel = 5
		public static constant real lifeLevelValue = 100.0
		public static constant real lifeStartValue = 50.0
		
		private method condition takes nothing returns boolean
			local boolean result = UnitHasBuffsEx(GetTriggerUnit(), false, true, true, false, true, true, false)
			if (not result) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Keine negativen Effekte."))
			endif
			
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local integer count = UnitCountBuffsEx(caster, false, true, true, false, true, true, false)
			local real life
			// native UnitRemoveBuffsEx            takes unit whichUnit, boolean removePositive, boolean removeNegative, boolean magic, boolean physical, boolean timedLife, boolean aura, boolean autoDispel returns nothing
			// native UnitHasBuffsEx               takes unit whichUnit, boolean removePositive, boolean removeNegative, boolean magic, boolean physical, boolean timedLife, boolean aura, boolean autoDispel returns boolean
			// native UnitCountBuffsEx             takes unit whichUnit, boolean removePositive, boolean removeNegative, boolean magic, boolean physical, boolean timedLife, boolean aura, boolean autoDispel returns integer
			if (count > 0) then
				call UnitRemoveBuffsEx(caster, false, true, true, false, true, true, false)
				set life = this.level() * thistype.lifeLevelValue + thistype.lifeStartValue * count
				call SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + life)
				call thistype.showLifeTextTag(caster, life)
			endif
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.knight(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A124', 'A129')
			call this.addGrimoireEntry('A125', 'A12A')
			call this.addGrimoireEntry('A126', 'A12B')
			call this.addGrimoireEntry('A127', 'A12C')
			call this.addGrimoireEntry('A128', 'A12D')
			
			return this
		endmethod
	endstruct

endlibrary
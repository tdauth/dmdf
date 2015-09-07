/// Dragon Slayer
library StructSpellsSpellRob requires Asl, StructGameClasses, StructGameSpell

	struct SpellRob extends Spell
		public static constant integer abilityId = 'A1A3'
		public static constant integer favouriteAbilityId = 'A1A4'
		public static constant integer classSelectionAbilityId = 'A1A5'
		public static constant integer classSelectionGrimoireAbilityId = 'A1A6'
		public static constant integer maxLevel = 5
		
		private method condition takes nothing returns boolean
			if (GetOwningPlayer(GetSpellTargetUnit()) == this.character().player()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Eigene Einheiten können nicht bestohlen werden."))
				return false
			endif
			
			return true
		endmethod
		
		private method action takes nothing returns nothing
			local integer gold = this.level() * GetUnitLevel(GetSpellTargetUnit())
			
			call AdjustPlayerStateBJ(gold, this.character().player(), PLAYER_STATE_RESOURCE_GOLD)
			call ShowBountyTextTagForPlayer(this.character().player(), GetUnitX(GetSpellTargetUnit()), GetUnitY(GetSpellTargetUnit()), gold)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1A5', 'A1A6')
			// TODO use different abilities
			call this.addGrimoireEntry('A1A5', 'A1A6')
			call this.addGrimoireEntry('A1A5', 'A1A6')
			call this.addGrimoireEntry('A1A5', 'A1A6')
			call this.addGrimoireEntry('A1A5', 'A1A6')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary
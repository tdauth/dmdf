/// Cleric
library StructSpellsSpellClarity requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Der Kleriker befreit einen Verbündeten von allen negativen Effekten.
	 * Die Abklingzeit sinkt pro Stufe.
	 */
	struct SpellClarity extends Spell
		public static constant integer abilityId = 'A052'
		public static constant integer favouriteAbilityId = 'A053'
		public static constant integer classSelectionAbilityId = 'A1JE'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JF'
		public static constant integer maxLevel = 5
		
		private method condition takes nothing returns boolean
			if (not UnitHasBuffsEx(GetSpellTargetUnit(), false, true, true, false, false, false, true)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel-Einheit besitzt keine negativen Zauberverstärker.", "Target unit has no negative buffs."))
			
				return false
			endif
			
			return true
		endmethod

		private method action takes nothing returns nothing
			call UnitRemoveBuffs(GetSpellTargetUnit(), false, true)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			
			call this.addGrimoireEntry('A1JE', 'A1JF')
			call this.addGrimoireEntry('A0OX', 'A0P2')
			call this.addGrimoireEntry('A0OY', 'A0P3')
			call this.addGrimoireEntry('A0OZ', 'A0P4')
			call this.addGrimoireEntry('A0P0', 'A0P5')
			call this.addGrimoireEntry('A0P1', 'A0P6')
			
			return this
		endmethod
	endstruct

endlibrary
/// Necromancer
library StructSpellsSpellDamnedGround requires Asl, StructGameClasses, StructGameSpell

	struct SpellDamnedGround extends Spell
		public static constant integer abilityId = 'A1AB'
		public static constant integer favouriteAbilityId = 'A1A8'
		public static constant integer classSelectionAbilityId = 'A1A9'
		public static constant integer classSelectionGrimoireAbilityId = 'A1AA'
		public static constant integer maxLevel = 5
		private static constant real radius = 100.0
		
		private method action takes nothing returns nothing
			if (IsPointBlighted(GetSpellTargetX(), GetSpellTargetY())) then
				call SetBlight(this.character().player(), GetSpellTargetX(), GetSpellTargetY(), thistype.radius * this.level(), false)
			else
				call SetBlight(this.character().player(), GetSpellTargetX(), GetSpellTargetY(), thistype.radius * this.level(), true)
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1A9', 'A1AA')
			// TODO use different abilities
			call this.addGrimoireEntry('A1A9', 'A1AA')
			call this.addGrimoireEntry('A1A9', 'A1AA')
			call this.addGrimoireEntry('A1A9', 'A1AA')
			call this.addGrimoireEntry('A1A9', 'A1AA')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary
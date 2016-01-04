/// Elemental Mage
library StructSpellsSpellRageOfElements requires Asl, StructGameClasses, StructGameSpell

	/// Grundfähigkeit - Erhöht den Schaden durch Elementarzauber 10 Sekunden lang um 30 %. 2 Minuten Abklingzeit.
	struct SpellRageOfElements extends Spell
		public static constant integer abilityId = 'A01J'
		public static constant integer favouriteAbilityId = 'A03Q'
		public static constant integer classSelectionAbilityId = 'A0ZM'
		public static constant integer classSelectionGrimoireAbilityId = 'A0ZN'
		public static constant integer maxLevel = 1
		private static constant real damageBonusFactor = 0.30
		private static constant real time = 10.0
		
		/**
		 * Collects all elemental damage spells and returns them as newly allocated vector.
		 */
		private method spells takes nothing returns AIntegerVector
			local AIntegerVector spells = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == this.character().spellCount())
				if (SpellElementalMageDamageSpell.spellIsDamageSpell(this.character().spell(i))) then
					call spells.pushBack(this.character().spell(i))
				endif
				set i = i + 1
			endloop
			
			return spells
		endmethod
		
		private method condition takes nothing returns boolean
			local boolean result = true
			local AIntegerVector spells = this.spells()
			if (spells.empty()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine Elementarmagierzauber erlernt!", "No elemental spells learned!"))
				set result = false
			endif
			
			call spells.destroy()
			
			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AIntegerVector spells = this.spells()
			local integer i = 0
			loop
				exitwhen (i == spells.size())
				call SpellElementalMageDamageSpell(spells[i]).addDamageBonusFactor(thistype.damageBonusFactor)
				call this.character().displayMessage(ACharacter.messageTypeInfo, StringArg(tre("\"%s\" wurde verstärkt!", "\"%s\" was strengthened!"), GetObjectName(Spell(spells[i]).ability())))
				set i = i + 1
			endloop
			call TriggerSleepAction(thistype.time)
			set i = 0
			loop
				exitwhen (i == spells.size())
				call this.character().displayMessage(ACharacter.messageTypeInfo, StringArg(tre("\"%s\" hat seine Verstärkung verloren!", "\"%s\" has lost its strengthening!"), GetObjectName(SpellElementalMageDamageSpell(spells[i]).ability())))
				call SpellElementalMageDamageSpell(spells[i]).removeDamageBonusFactor(thistype.damageBonusFactor)
				set i = i + 1
			endloop
			set caster = null
			call spells.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A0ZM', 'A0ZN')
			
			return this
		endmethod
	endstruct

endlibrary
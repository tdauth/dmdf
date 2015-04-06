/// Elemental Mage
library StructSpellsSpellRageOfElements requires Asl, StructGameClasses, StructGameSpell

	/// Grundfähigkeit - Erhöht den Schaden durch Elementarzauber 10 Sekunden lang um 30 %. 2 Minuten Abklingzeit.
	struct SpellRageOfElements extends Spell
		public static constant integer abilityId = 'A01J'
		public static constant integer favouriteAbilityId = 'A03Q'
		public static constant integer maxLevel = 1
		private static constant real damageBonusFactor = 0.30
		private static constant real time = 10.0

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AIntegerVector spells = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == this.character().spellCount())
				if (SpellElementalMageDamageSpell.spellIsDamageSpell(this.character().spell(i))) then
					// needn't to be learned, note that it can be learned during the spell time
					call SpellElementalMageDamageSpell(this.character().spell(i)).addDamageBonusFactor(thistype.damageBonusFactor)
					call this.character().displayMessage(ACharacter.messageTypeInfo, StringArg(tr("\"%s\" wurde verstärkt!"), GetObjectName(this.character().spell(i).ability())))
					call spells.pushBack(this.character().spell(i))
				endif
				set i = i + 1
			endloop
			if (spells.empty()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Keine Elementarmagierzauber erlernt!"))
				call spells.destroy()
				set caster = null
				return
			endif
			call TriggerSleepAction(thistype.time)
			set i = 0
			loop
				exitwhen (i == spells.size())
				call this.character().displayMessage(ACharacter.messageTypeInfo, StringArg(tr("\"%s\" hat seine Verstärkung verloren!"), GetObjectName(SpellElementalMageDamageSpell(spells[i]).ability())))
				call SpellElementalMageDamageSpell(spells[i]).removeDamageBonusFactor(thistype.damageBonusFactor)
				set i = i + 1
			endloop
			set caster = null
			call spells.destroy()
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0ZN', 'A0ZM')
			
			return this
		endmethod
	endstruct

endlibrary
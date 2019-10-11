/// Elemental Mage
library StructSpellsSpellElementalForce requires Asl, StructSpellsSpellElementalMageDamageSpell

	/// Erhöht den Schaden durch Elementarzauber 20 Sekunden lang um 80 %. 3 Minuten Abklingzeit.
	struct SpellElementalForce extends Spell
		public static constant integer abilityId = 'A045'
		public static constant integer favouriteAbilityId = 'A046'
		public static constant integer classSelectionAbilityId = 'A1KL'
		public static constant integer classSelectionGrimoireAbilityId = 'A1KM'
		public static constant integer maxLevel = 1
		private static constant real damageBonusFactor = 0.80
		private static constant real time = 20.0
		private static sound whichSound

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
			local AIntegerVector spells = this.spells()
			local boolean result = true
			if (spells.empty()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Keine Elementarmagierzauber erlernt!", "Learned no elemental spells!"))
				set result = false
			endif

			call spells.destroy()

			return result
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AIntegerVector spells = this.spells()
			local effect spellEffect
			local integer i = 0
			loop
				exitwhen (i == spells.size())
				call SpellElementalMageDamageSpell(spells[i]).addDamageBonusFactor(thistype.damageBonusFactor)
				set i = i + 1
			endloop
			call PlaySoundOnUnitBJ(thistype.whichSound, 100.0, caster)
			set spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			call TriggerSleepAction(thistype.time)
			set i = 0
			loop
				exitwhen (i == spells.size())
				call SpellElementalMageDamageSpell(spells[i]).removeDamageBonusFactor(thistype.damageBonusFactor)
				set i = i + 1
			endloop
			call spells.destroy()
			call DestroyEffect(spellEffect)
			set spellEffect = null
			set caster = null
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1KL', 'A1KM')
			call this.addGrimoireEntry('A0Z8', 'A0Z9')

			return this
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.whichSound = CreateSound("Abilities\\Spells\\NightElf\\Starfall\\StarfallCaster1.wav", false, false, true, 12700, 12700, "")
		endmethod
	endstruct

endlibrary
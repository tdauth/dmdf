/// Elemental Mage
library StructSpellsSpellRageOfElements requires Asl, StructGameClasses, StructGameSpell

	/// Grundfähigkeit - Erhöht den Schaden durch Elementarzauber 10 Sekunden lang um 30 %. 2 Minuten Abklingzeit.
	struct SpellRageOfElements extends Spell
		public static constant integer abilityId = 'A01J'
		public static constant integer favouriteAbilityId = 'A03Q'
		public static constant integer classSelectionAbilityId = 'A1N3'
		public static constant integer classSelectionGrimoireAbilityId = 'A1N4'
		public static constant integer maxLevel = 1
		private static constant real damageBonusFactor = 0.30
		private static constant real time = 10.0
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
			// Abilities\Spells\Items\AIfb\AIfbTarget.mdx
			// Abilities\Spells\Items\AIob\AIobTarget.mdx
			// Abilities\OrbWater\OrbWaterX.mdx
			// Abilities\OrbLightning\OrbLightningX.mdx
			local effect fireEffect = AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIfb\\AIfbTarget.mdx", this.character().unit(), "chest")
			local effect frostEffect = AddSpecialEffectTarget("Abilities\\Spells\\Items\\AIob\\AIobTarget.mdx", this.character().unit(), "chest")
			//local effect waterEffect = AddSpecialEffectTarget("Abilities\\OrbWater\\OrbWaterX.mdx", this.character().unit(), "origin")
			//local effect lightningEffect = AddSpecialEffectTarget("Abilities\\OrbLightning\\OrbLightningX.mdx", this.character().unit(), "origin")
			local AIntegerVector spells = this.spells()
			local integer i = 0
			call PlaySoundOnUnitBJ(thistype.whichSound, 100.0, caster)
			loop
				exitwhen (i == spells.size())
				call SpellElementalMageDamageSpell(spells[i]).addDamageBonusFactor(thistype.damageBonusFactor)
				set i = i + 1
			endloop
			call TriggerSleepAction(thistype.time)
			set i = 0
			loop
				exitwhen (i == spells.size())
				call SpellElementalMageDamageSpell(spells[i]).removeDamageBonusFactor(thistype.damageBonusFactor)
				set i = i + 1
			endloop
			set caster = null
			call spells.destroy()

			call DestroyEffect(fireEffect)
			set fireEffect = null
			call DestroyEffect(frostEffect)
			set frostEffect = null
			//call DestroyEffect(waterEffect)
			//set waterEffect = null
			//call DestroyEffect(lightningEffect)
			//set lightningEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeDefault, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			call this.addGrimoireEntry('A1N3', 'A1N4')
			call this.addGrimoireEntry('A0ZM', 'A0ZN')

			return this
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.whichSound = CreateSound("Abilities\\Spells\\Other\\StormEarthFire\\PandarenUltimate.wav", false, false, true, 12700, 12700, "")
		endmethod
	endstruct

endlibrary
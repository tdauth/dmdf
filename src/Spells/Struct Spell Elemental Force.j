/// Elemental Mage
library StructSpellsSpellElementalForce requires Asl, StructSpellsSpellElementalMageDamageSpell

	/// Erhöht den Schaden durch Elementarzauber 10 Sekunden lang um 50 %. 3 Minuten Abklingzeit.
	struct SpellElementalForce extends Spell
		public static constant integer abilityId = 'A045'
		public static constant integer favouriteAbilityId = 'A046'
		public static constant integer maxLevel = 1
		private static constant real damageBonusFactor = 0.50
		private static constant real time = 10.0

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local AIntegerVector spells = AIntegerVector.create()
			local effect spellEffect
			local integer i = 0
			loop
				exitwhen (i == this.character().spellCount())
				if (SpellElementalMageDamageSpell.spellIsDamageSpell(this.character().spell(i))) then
					//needn't to be learned, note that it can be learned during the spell time
					//if (GetUnitAbilityLevel(caster, this.character().this(i).ability()) > 0) then
					call SpellElementalMageDamageSpell(this.character().spell(i)).addDamageBonusFactor(thistype.damageBonusFactor)
					call this.character().displayMessage(ACharacter.messageTypeInfo, StringArg(tr("\"%s\" wurde verstärkt!"), GetObjectName(this.character().spell(i).ability())))
					call spells.pushBack(this.character().spell(i))
				endif
				set i = i + 1
			endloop
			if (spells.empty()) then
				call spells.destroy()
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Keine Elementarmagierzauber erlernt!"))
				set caster = null
				return
			endif
			set spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "origin")
			call TriggerSleepAction(thistype.time)
			set i = 0
			loop
				exitwhen (i == spells.size())
				call this.character().displayMessage(ACharacter.messageTypeInfo, StringArg(tr("\"%s\" hat seine Verstärkung verloren!"), GetObjectName(SpellElementalMageDamageSpell(spells[i]).ability())))
				call SpellElementalMageDamageSpell(spells[i]).removeDamageBonusFactor(thistype.damageBonusFactor)
				set i = i + 1
			endloop
			call spells.destroy()
			call DestroyEffect(spellEffect)
			set spellEffect = null
			set caster = null
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0Z8', 'A0Z9')
			
			return this
		endmethod
	endstruct

endlibrary
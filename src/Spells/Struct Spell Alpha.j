/// Druid
library StructSpellsSpellAlpha requires Asl, StructGameCharacter, StructGameClasses, StructGameSpell, StructGameGrimoire, StructSpellsSpellBearForm, StructSpellsSpellCrowForm

	struct SpellAlpha extends Spell
		public static constant integer abilityId = 'A0FE'
		public static constant integer favouriteAbilityId = 'A0FG'
		public static constant integer classSelectionAbilityId = 'A03M'
		public static constant integer classSelectionGrimoireAbilityId = 'A03Y'
		public static constant integer maxLevel = 1
		/// This ability is added to the animal form if this spell is learned.
		public static constant integer castAbilityId = 'A0FF'
		public static constant integer castSpellBookAbilityId = 'A1PJ'
		
		public stub method onLearn takes nothing returns nothing
			local Character character = Character(this.character())
			// TODO slow spellByAbilityId()
			local SpellBearForm spellBearForm = character.grimoire().spellByAbilityId(SpellBearForm.abilityId)
			local SpellCrowForm spellCrowForm = character.grimoire().spellByAbilityId(SpellCrowForm.abilityId)
			call super.onLearn()
			if ((spellBearForm != 0 and spellBearForm.metamorphosis().isMorphed()) or (spellCrowForm != 0 and spellCrowForm.metamorphosis().isMorphed())) then
				call UnitAddAbility(this.character().unit(), SpellAlpha.castSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), SpellAlpha.castSpellBookAbilityId, false)
			endif
		endmethod
		
		public stub method onUnlearn takes nothing returns nothing
			local Character character = Character(this.character())
			// TODO slow spellByAbilityId()
			local SpellBearForm spellBearForm = character.grimoire().spellByAbilityId(SpellBearForm.abilityId)
			local SpellCrowForm spellCrowForm = character.grimoire().spellByAbilityId(SpellCrowForm.abilityId)
			call super.onUnlearn()
			if ((spellBearForm != 0 and spellBearForm.metamorphosis().isMorphed()) or (spellCrowForm != 0 and spellCrowForm.metamorphosis().isMorphed())) then
				call UnitRemoveAbility(this.character().unit(), SpellAlpha.castSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), SpellAlpha.castSpellBookAbilityId, true)
			endif
		endmethod
		
		/**
		 * When the level is changed while the character is already morphed, the ability has to be added or removed.
		 */
		public stub method setLevel takes integer level returns nothing
			local Character character = Character(this.character())
			// TODO slow spellByAbilityId()
			local SpellBearForm spellBearForm = character.grimoire().spellByAbilityId(SpellBearForm.abilityId)
			local SpellCrowForm spellCrowForm = character.grimoire().spellByAbilityId(SpellCrowForm.abilityId)
			call super.setLevel(level)
			if ((spellBearForm != 0 and spellBearForm.metamorphosis().isMorphed()) or (spellCrowForm != 0 and spellCrowForm.metamorphosis().isMorphed())) then
				// Add Alpha spell
				if (level > 0) then
					call UnitAddAbility(this.character().unit(), SpellAlpha.castSpellBookAbilityId)
					call SetPlayerAbilityAvailable(this.character().player(), SpellAlpha.castSpellBookAbilityId, false)
				else
					call UnitRemoveAbility(this.character().unit(), SpellAlpha.castSpellBookAbilityId)
					call SetPlayerAbilityAvailable(this.character().player(), SpellAlpha.castSpellBookAbilityId, true)
				endif
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeUltimate0, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			call this.addGrimoireEntry('A03M', 'A03Y')
			call this.addGrimoireEntry('A0FH', 'A0FI')
			
			call this.setIsPassive(true)
			
			return this
		endmethod
	endstruct

endlibrary
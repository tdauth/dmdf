/// Druid
library StructSpellsSpellCrowForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	struct SpellCrowFormMetamorphosis extends SpellMetamorphosis

		public stub method canRestore takes nothing returns boolean
			// seems to work wrongly
			if (IsTerrainPathable(GetUnitX(this.character().unit()), GetUnitY(this.character().unit()), PATHING_TYPE_WALKABILITY)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tre("Charakter muss sich außerhalb des Wassers befinden.", "Character must be located outside of water."))

				return false
			endif

			return true
		endmethod

		public stub method onMorph takes nothing returns nothing
			local Character character = Character(this.character())
			local integer level = 0
			local integer alphaLevel = 0
			local SpellZoology zoologySpell = 0
			call super.onMorph()
			set level = GetUnitAbilityLevel(this.character().unit(), SpellCrowForm.abilityId)
			debug call Print("Crow Form: Morph! Level: " + I2S(level))

			// Add spell book, all animal form abilities are moved into this spell book since the normal spells can be used as well.
			call UnitAddAbility(this.character().unit(), 'A07K')

			call UnitAddAbility(this.character().unit(), SpellCrowForm.manaSpellBookAbilityId)
			call SetPlayerAbilityAvailable(this.character().player(), SpellCrowForm.manaSpellBookAbilityId, false)
			call SetUnitAbilityLevel(this.character().unit(), SpellCrowForm.manaAbilityId, level)

			call UnitAddAbility(this.character().unit(), SpellCrowForm.armorSpellBookAbilityId)
			call SetPlayerAbilityAvailable(this.character().player(), SpellCrowForm.armorSpellBookAbilityId, false)
			call SetUnitAbilityLevel(this.character().unit(), SpellCrowForm.armorAbilityId, level)

			set alphaLevel = GetUnitAbilityLevel(this.character().unit(), SpellAlpha.abilityId)
			debug call Print("Crow Form: Alpha Level: " + I2S(alphaLevel))

			if (alphaLevel > 0) then
				debug call Print("Adding Alpha spell since Alpha is skilled: " + GetAbilityName(SpellAlpha.castAbilityId))
				call UnitAddAbility(this.character().unit(), SpellAlpha.castSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), SpellAlpha.castSpellBookAbilityId, false)
			endif

			// TODO slow spellByAbilityId()
			set zoologySpell = character.grimoire().spellByAbilityId(SpellZoology.abilityId)

			if (zoologySpell != 0) then
				call zoologySpell.updateCrowFormSpells.evaluate(zoologySpell.level())
			endif
		endmethod

	endstruct

	struct SpellCrowForm extends Spell
		public static constant integer abilityId = 'A13U'
		public static constant integer favouriteAbilityId = 'A092'
		public static constant integer classSelectionAbilityId = 'A1JR'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JS'
		public static constant integer maxLevel = 5
		public static constant integer manaAbilityId = 'A14U'
		public static constant integer manaSpellBookAbilityId = 'A1PK'
		public static constant integer armorAbilityId = 'A094'
		public static constant integer armorSpellBookAbilityId = 'A1PL'
		private SpellCrowFormMetamorphosis m_metamorphosis

		public method metamorphosis takes nothing returns SpellCrowFormMetamorphosis
			return this.m_metamorphosis
		endmethod

		public stub method onLearn takes nothing returns nothing
			call super.onLearn()
			if (this.m_metamorphosis.isMorphed()) then
				call UnitAddAbility(this.character().unit(), thistype.manaSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.manaSpellBookAbilityId, false)

				call UnitAddAbility(this.character().unit(), thistype.armorSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.armorSpellBookAbilityId, false)
			endif
		endmethod

		public stub method onUnlearn takes nothing returns nothing
			call super.onUnlearn()
			if (this.m_metamorphosis.isMorphed()) then
				call UnitRemoveAbility(this.character().unit(), thistype.manaSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.manaSpellBookAbilityId, true)

				call UnitRemoveAbility(this.character().unit(), thistype.armorSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.armorSpellBookAbilityId, true)
			endif
		endmethod

		public stub method setLevel takes integer level returns nothing
			call super.setLevel(level)
			if (this.m_metamorphosis.isMorphed()) then
				call SetUnitAbilityLevel(this.character().unit(), thistype.manaAbilityId, level)
				call SetUnitAbilityLevel(this.character().unit(), thistype.armorAbilityId, level)
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			set this.m_metamorphosis = SpellCrowFormMetamorphosis.create(character, thistype.abilityId, 'A0KZ', 'A13V')
			call this.m_metamorphosis.setDisableInventory(false)
			// don't show equipment
			call this.m_metamorphosis.setEnableOnlyRucksack(true)
			call this.m_metamorphosis.setDisableGrimoire(false)

			call this.addGrimoireEntry('A1JR', 'A1JS')
			call this.addGrimoireEntry('A0CH', 'A0CI')
			call this.addGrimoireEntry('A0CJ', 'A0CN')
			call this.addGrimoireEntry('A0CK', 'A0CO')
			call this.addGrimoireEntry('A0CL', 'A0CP')
			call this.addGrimoireEntry('A0CM', 'A0CQ')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_metamorphosis.destroy()
			set this.m_metamorphosis = 0
		endmethod
	endstruct

endlibrary
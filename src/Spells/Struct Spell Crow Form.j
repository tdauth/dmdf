/// Druid
library StructSpellsSpellCrowForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis, StructSpellsSpellAlpha, StructSpellsSpellZoology

	struct SpellCrowFormMetamorphosis extends SpellMetamorphosis

		public stub method onMorph takes nothing returns nothing
			local integer level
			local integer alphaLevel = 0
			local integer zoologyLevel = 0
			call super.onMorph()
			set level = Character(this.character()).realSpellLevels().integerByInteger(0, SpellCrowForm.abilityId)
			debug call Print("Crow Form: Morph! Level: " + I2S(level))
			call SetUnitAbilityLevel(this.character().unit(), SpellCrowForm.manaAbilityId, level)
			call SetUnitAbilityLevel(this.character().unit(), SpellCrowForm.armorAbilityId, level)
			
			set alphaLevel = Character(this.character()).realSpellLevels().integerByInteger(0, SpellAlpha.abilityId)
			debug call Print("Crow Form: Alpha Level: " + I2S(alphaLevel))
			
			if (alphaLevel > 0) then
				debug call Print("Adding Alpha spell since Alpha is skilled: " + GetAbilityName(SpellAlpha.castAbilityId))
				call UnitAddAbility(this.character().unit(), SpellAlpha.castAbilityId)
			endif
			
			set zoologyLevel =  Character(this.character()).realSpellLevels().integerByInteger(0, SpellZoology.abilityId)
			debug call Print("Crow Form: Zoology Level: " + I2S(zoologyLevel))
			
			if (zoologyLevel > 0) then
				debug call Print("Adding Zoology spell since Zoology is skilled: " + GetAbilityName(SpellZoology.abilityId))
				
				// zoology level 1 ability for crow form
				// Junges
				call UnitAddAbility(this.character().unit(), 'A11T')
				
				// Sturm
				if (zoologyLevel > 1) then
					call UnitAddAbility(this.character().unit(), 'A11U')
				endif

				// Kreisen
				if (zoologyLevel > 2) then
					call UnitAddAbility(this.character().unit(), 'A11V')
				endif
				
				// Flügelschlag
				if (zoologyLevel > 3) then
					call UnitAddAbility(this.character().unit(), 'A11W')
				endif
				
				// Nest
				if (zoologyLevel > 4) then
					call UnitAddAbility(this.character().unit(), 'A11X')
				endif
			endif
		endmethod
		
	endstruct

	struct SpellCrowForm extends Spell
		public static constant integer abilityId = 'A0KZ'
		public static constant integer favouriteAbilityId = 'A092'
		public static constant integer maxLevel = 5
		public static constant integer manaAbilityId = 'A093'
		public static constant integer armorAbilityId = 'A094'
		private SpellCrowFormMetamorphosis m_metamorphosis

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			set this.m_metamorphosis = SpellCrowFormMetamorphosis.create(character, thistype.abilityId)
			call this.m_metamorphosis.setUnitTypeId('H00H')
			call this.m_metamorphosis.setFavoriteAbility(thistype.favouriteAbilityId)
			call this.m_metamorphosis.setOrderString("ravenform")
			call this.m_metamorphosis.setUnorderString("unravenform")
			call this.m_metamorphosis.setManaCost(50.0)
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
/// Druid
library StructSpellsSpellZoology requires Asl, StructGameClasses, StructGameSpell, StructSpellsSpellBearForm, StructSpellsSpellCrowForm

	struct SpellZoology extends Spell
		public static constant integer abilityId = 'A09T'
		public static constant integer favouriteAbilityId = 'A09U'
		public static constant integer classSelectionAbilityId = 'A1OR'
		public static constant integer classSelectionGrimoireAbilityId = 'A1OS'
		public static constant integer maxLevel = 5

		public method updateBearFormSpells takes integer zoologyLevel returns nothing
			if (zoologyLevel > 0) then
				debug call Print("Adding Zoology spell since Zoology is skilled: " + GetAbilityName(SpellZoology.abilityId))

				// zoology level 1 ability for bear form
				// Gebrüll
				call UnitAddAbility(this.character().unit(), 'A1PR')
				call SetPlayerAbilityAvailable(this.character().player(), 'A1PR', false)

				// Prankenhieb
				if (zoologyLevel > 1) then
					call UnitAddAbility(this.character().unit(), 'A1PS')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PS', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PS')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PS', true)
				endif

				// Tollwut
				if (zoologyLevel > 2) then
					call UnitAddAbility(this.character().unit(), 'A1PT')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PT', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PT')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PT', true)
				endif

				// Winterschlaf
				if (zoologyLevel > 3) then
					call UnitAddAbility(this.character().unit(), 'A1PV')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PV', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PV')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PV', true)
				endif

				// Bärenhöhle
				if (zoologyLevel > 4) then
					call UnitAddAbility(this.character().unit(), 'A1PW')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PW', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PW')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PW', true)
				endif
			else
				call UnitRemoveAbility(this.character().unit(), 'A1PR')
				call SetPlayerAbilityAvailable(this.character().player(), 'A1PR', true)
			endif
		endmethod

		public method updateCrowFormSpells takes integer zoologyLevel returns nothing
			if (zoologyLevel > 0) then
				debug call Print("Adding Zoology spell since Zoology is skilled: " + GetAbilityName(SpellZoology.abilityId))

				// zoology level 1 ability for crow form
				// Junges
				call UnitAddAbility(this.character().unit(), 'A1PM')
				call SetPlayerAbilityAvailable(this.character().player(), 'A1PM', false)

				// Sturm
				if (zoologyLevel > 1) then
					call UnitAddAbility(this.character().unit(), 'A1PN')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PN', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PN')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PN', true)
				endif

				// Kreisen
				if (zoologyLevel > 2) then
					call UnitAddAbility(this.character().unit(), 'A1PO')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PO', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PO')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PO', true)
				endif

				// Flügelschlag
				if (zoologyLevel > 3) then
					call UnitAddAbility(this.character().unit(), 'A1PP')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PP', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PP')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PP', true)
				endif

				// Nest
				if (zoologyLevel > 4) then
					call UnitAddAbility(this.character().unit(), 'A1PQ')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PQ', false)
				else
					call UnitRemoveAbility(this.character().unit(), 'A1PQ')
					call SetPlayerAbilityAvailable(this.character().player(), 'A1PQ', true)
				endif
			else
				call UnitRemoveAbility(this.character().unit(), 'A1PM')
				call SetPlayerAbilityAvailable(this.character().player(), 'A1PM', true)
			endif
		endmethod

		private method updateByLevel takes integer zoologyLevel returns nothing
			local Character character = Character(this.character())
			// TODO slow spellByAbilityId()
			local SpellBearForm spellBearForm = character.grimoire().spellByAbilityId(SpellBearForm.abilityId)
			local SpellCrowForm spellCrowForm = character.grimoire().spellByAbilityId(SpellCrowForm.abilityId)
			// setup Zoology bear form spells
			if (spellBearForm != 0 and spellBearForm.metamorphosis().isMorphed()) then
				call this.updateBearFormSpells(zoologyLevel)
			// setup Zoology crow form spells
			elseif (spellCrowForm != 0 and spellCrowForm.metamorphosis().isMorphed()) then
				call this.updateCrowFormSpells(zoologyLevel)
			endif
		endmethod

		public stub method onLearn takes nothing returns nothing
			call super.onLearn()
			call this.updateByLevel(1)
		endmethod

		public stub method onUnlearn takes nothing returns nothing
			call super.onUnlearn()
			call this.updateByLevel(0)
		endmethod

		/**
		 * When the level is changed while the character is already morphed, the abilities have to be added or removed.
		 */
		public stub method setLevel takes integer level returns nothing
			call super.setLevel(level)
			call this.updateByLevel(level)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			call this.addGrimoireEntry('A1OR', 'A1OS')
			call this.addGrimoireEntry('A0EN', 'A0ES')
			call this.addGrimoireEntry('A0EO', 'A0ET')
			call this.addGrimoireEntry('A0EP', 'A0EU')
			call this.addGrimoireEntry('A0EQ', 'A0EV')
			call this.addGrimoireEntry('A0ER', 'A0EW')

			call this.setIsPassive(true)

			return this
		endmethod
	endstruct

endlibrary
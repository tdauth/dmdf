/// Druid
library StructSpellsSpellBearForm requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	struct SpellBearFormMetamorphosis extends SpellMetamorphosis

		private static method timerFunctionResetAnimation takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			if (this.isMorphed()) then
				call ResetUnitAnimation(this.character().unit())
			endif
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod

		public stub method onMorph takes nothing returns nothing
			local Character character = Character(this.character())
			local integer level = 0
			local integer alphaLevel = 0
			local SpellZoology zoologySpell = 0
			local timer whichTimer = null
			call super.onMorph()
			set level = GetUnitAbilityLevel(this.character().unit(), SpellBearForm.abilityId)
			debug call Print("Bear Form: Morph! Level: " + I2S(level))

			// Add spell book, all animal form abilities are moved into this spell book since the normal spells can be used as well.
			call UnitAddAbility(this.character().unit(), 'A07K')

			call UnitAddAbility(this.character().unit(), SpellBearForm.lifeSpellBookAbilityId)
			call SetPlayerAbilityAvailable(this.character().player(), SpellBearForm.lifeSpellBookAbilityId, false)
			call SetUnitAbilityLevel(this.character().unit(), SpellBearForm.lifeAbilityId, level)

			call UnitAddAbility(this.character().unit(), SpellBearForm.damageSpellBookAbilityId)
			call SetPlayerAbilityAvailable(this.character().player(), SpellBearForm.damageSpellBookAbilityId, false)
			call SetUnitAbilityLevel(this.character().unit(), SpellBearForm.damageAbilityId, level)

			set alphaLevel = GetUnitAbilityLevel(this.character().unit(), SpellAlpha.abilityId)
			debug call Print("Bear Form: Alpha Level: " + I2S(level))

			if (alphaLevel > 0) then
				debug call Print("Adding Alpha spell since Alpha is skilled: " + GetAbilityName(SpellAlpha.castAbilityId))
				//call UnitAddAbility(this.character().unit(), SpellAlpha.castAbilityId)
				call UnitAddAbility(this.character().unit(), SpellAlpha.castSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), SpellAlpha.castSpellBookAbilityId, false)
			endif

			// TODO slow spellByAbilityId()
			set zoologySpell = character.grimoire().spellByAbilityId(SpellZoology.abilityId)

			if (zoologySpell != 0) then
				call zoologySpell.updateBearFormSpells.evaluate(zoologySpell.level())
			endif

			// Reset the loop spell animation but after a timeout, since it seems to be applied after one. Reseting it immediately does not work.
			set whichTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(whichTimer, 0, this)
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionResetAnimation)
		endmethod
	endstruct

	struct SpellBearForm extends Spell
		public static constant integer abilityId = 'A13X'
		public static constant integer favouriteAbilityId = 'A09S'
		public static constant integer classSelectionAbilityId = 'A0UD'
		public static constant integer classSelectionGrimoireAbilityId = 'A0UE'
		public static constant integer maxLevel = 5
		public static constant integer lifeAbilityId = 'A15V'
		public static constant integer lifeSpellBookAbilityId = 'A1PI'
		public static constant integer damageAbilityId = 'A09R'
		public static constant integer damageSpellBookAbilityId = 'A1PH'
		private SpellBearFormMetamorphosis m_metamorphosis

		public method metamorphosis takes nothing returns SpellBearFormMetamorphosis
			return this.m_metamorphosis
		endmethod

		public stub method onLearn takes nothing returns nothing
			call super.onLearn()
			if (this.m_metamorphosis.isMorphed()) then
				call UnitAddAbility(this.character().unit(), thistype.lifeSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.lifeSpellBookAbilityId, false)

				call UnitAddAbility(this.character().unit(), thistype.damageSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.damageSpellBookAbilityId, false)
			endif
		endmethod

		public stub method onUnlearn takes nothing returns nothing
			call super.onUnlearn()
			if (this.m_metamorphosis.isMorphed()) then
				call UnitRemoveAbility(this.character().unit(), thistype.lifeSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.lifeSpellBookAbilityId, true)

				call UnitRemoveAbility(this.character().unit(), thistype.damageSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.damageSpellBookAbilityId, true)
			endif
		endmethod

		public stub method setLevel takes integer level returns nothing
			call super.setLevel(level)
			if (this.m_metamorphosis.isMorphed()) then
				call SetUnitAbilityLevel(this.character().unit(), thistype.lifeAbilityId, level)
				call SetUnitAbilityLevel(this.character().unit(), thistype.damageAbilityId, level)
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithoutTriggers(character, Classes.druid(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			set this.m_metamorphosis = SpellBearFormMetamorphosis.create(character, thistype.abilityId, 'A09H', 'A13W')
			call this.m_metamorphosis.setDisableInventory(false)
			// don't show equipment
			call this.m_metamorphosis.setEnableOnlyRucksack(true)
			call this.m_metamorphosis.setDisableGrimoire(false)

			call this.addGrimoireEntry('A0UD', 'A0UE')
			call this.addGrimoireEntry('A0C7', 'A0CC')
			call this.addGrimoireEntry('A0C8', 'A0CD')
			call this.addGrimoireEntry('A0C9', 'A0CE')
			call this.addGrimoireEntry('A0CA', 'A0CF')
			call this.addGrimoireEntry('A0CB', 'A0CG')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_metamorphosis.destroy()
			set this.m_metamorphosis = 0
		endmethod
	endstruct

endlibrary
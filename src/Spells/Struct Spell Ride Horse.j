library StructSpellsSpellRideHorse requires Asl, StructGameClasses, StructSpellsSpellMetamorphosis

	private struct SpellRideHorseMetamorphosis extends SpellMetamorphosis
		private unit m_target

		public method target takes nothing returns unit
			return this.m_target
		endmethod

		public stub method onCondition takes nothing returns boolean
			if (not this.isMorphed()) then
				if (GetUnitTypeId(GetSpellTargetUnit()) == 'h02Y') then
					return true
				endif

				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss ein reiterloses Pferd sein.", "Target must be a horse without rider."))
				call IssueImmediateOrder(GetTriggerUnit(), "stop")

				return false
			else
				if (GetTriggerUnit() == this.character().unit()) then
					return true
				endif

				call this.character().displayMessage(ACharacter.messageTypeError, tre("Ziel muss ein der berittene Charakter sein.", "Target must be the riding character."))
				call IssueImmediateOrder(GetTriggerUnit(), "stop")

				return false
			endif

			return false
		endmethod

		public stub method onStart takes nothing returns nothing
			// Only hide if it will be successful
			if (not this.character().isMorphed()) then
				debug call Print("Target: " + GetUnitName(GetSpellTargetUnit()))
				call SetUnitInvulnerable(GetSpellTargetUnit(), true)
				call PauseUnit(GetSpellTargetUnit(), true)
				call ShowUnit(GetSpellTargetUnit(), false)
				set this.m_target = GetSpellTargetUnit()
			endif
		endmethod

		public stub method onMorph takes nothing returns nothing
			/*
			 * Make sure other animation tags are removed before.
			 */
			call AddUnitAnimationProperties(this.character().unit(), DefenceItemType.animationProperties, false)
			// This line suffices as a "refresh" to show the new animation name
			call SetUnitAnimation(this.character().unit(), "stand")
		endmethod

		public stub method onRestore takes nothing returns nothing
			call SetUnitInvulnerable(this.target(), false)
			call PauseUnit(this.target(), false)
			call ShowUnit(this.target(), true)
			call SetUnitX(this.target(), GetUnitX(this.character().unit()))
			call SetUnitY(this.target(), GetUnitY(this.character().unit()))
		endmethod

		public static method create takes Character character, integer abilityId, integer morphAbiliyId, integer unmorphAbilityId returns thistype
			local thistype this = thistype.allocate(character, abilityId, morphAbiliyId, unmorphAbilityId)
			call this.setDisableGrimoire(false)
			call this.setDisableInventory(false)
			call this.setEnableOnlyRucksack(false)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

	struct SpellRideHorse extends Spell
		public static constant integer abilityId = 'A1SH'
		public static constant integer favouriteAbilityId = 'A1SK'
		public static constant integer classSelectionAbilityId = 'A1SI'
		public static constant integer classSelectionGrimoireAbilityId = 'A1SJ'
		public static constant integer maxLevel = 1
		public static constant integer requiredLevel = 30
		private SpellRideHorseMetamorphosis m_metamorphosis

		public method metamorphosis takes nothing returns SpellRideHorseMetamorphosis
			return this.m_metamorphosis
		endmethod

		public stub method onLearn takes nothing returns nothing
			call super.onLearn()
			if (this.m_metamorphosis.isMorphed()) then
				/*
				call UnitAddAbility(this.character().unit(), thistype.lifeSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.lifeSpellBookAbilityId, false)

				call UnitAddAbility(this.character().unit(), thistype.damageSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.damageSpellBookAbilityId, false)
				*/
			endif
		endmethod

		public stub method onUnlearn takes nothing returns nothing
			call super.onUnlearn()
			if (this.m_metamorphosis.isMorphed()) then
				/*
				call UnitRemoveAbility(this.character().unit(), thistype.lifeSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.lifeSpellBookAbilityId, true)

				call UnitRemoveAbility(this.character().unit(), thistype.damageSpellBookAbilityId)
				call SetPlayerAbilityAvailable(this.character().player(), thistype.damageSpellBookAbilityId, true)
				*/
			endif
		endmethod

		public stub method setLevel takes integer level returns nothing
			call super.setLevel(level)
			if (this.m_metamorphosis.isMorphed()) then
				//call SetUnitAbilityLevel(this.character().unit(), thistype.lifeAbilityId, level)
				//call SetUnitAbilityLevel(this.character().unit(), thistype.damageAbilityId, level)
			endif
		endmethod

		public stub method onIsSkillable takes integer level returns boolean
			return GetHeroLevel(this.character().unit()) >= thistype.requiredLevel
		endmethod

		public static method create takes Character character, integer morphAbilityId, integer unmorphAbilityId returns thistype
			local thistype this = thistype.createWithoutTriggers(character, 0, Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId)
			set this.m_metamorphosis = SpellRideHorseMetamorphosis.create(character, thistype.abilityId, morphAbilityId, unmorphAbilityId)

			call this.addGrimoireEntry('A1SI', 'A1SJ')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_metamorphosis.destroy()
			set this.m_metamorphosis = 0
		endmethod
	endstruct

endlibrary
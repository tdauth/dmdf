library StructMapSpellsSpellMagicalSeed requires Asl, StructMapMapMapData, StructMapQuestsQuestSeedsForTheGarden

	struct SpellMagicalSeed extends ASpell
		public static constant integer abilityId = 'A0KB'

		// http://www.hiveworkshop.com/forums/triggers-scripts-269/does-getspelltargetx-y-work-177175/
		// GetSpellTargetX() etc. does not work in conditions but in actions?
		private method condition takes nothing returns boolean
			return true
		endmethod

		private method action takes nothing returns nothing
			local unit whichUnit
			local real dist = GetDistanceBetweenPointsWithoutZ(GetRectCenterX(gg_rct_trommons_vegetable_garden), GetRectCenterY(gg_rct_trommons_vegetable_garden), GetSpellTargetX(), GetSpellTargetY())
			// TEST
			debug call Print("Location 1: " + R2S(GetLocationX(GetSpellTargetLoc())) + " and " + R2S(GetLocationY(GetSpellTargetLoc())))
			debug call Print("Location 2: " + R2S(GetSpellTargetX()) + " and " + R2S(GetSpellTargetY()))
			debug call Print("Ability name: " + GetObjectName(GetSpellAbilityId()))
			debug call Print("Instance " + I2S(this))
			debug call Print("Player: " + GetPlayerName(Player(0)))
			call PingMinimapExForPlayer(Player(0), GetSpellTargetX(), GetSpellTargetY(), 10.0, 100, 100, 100, false)
			
			if (not QuestSeedsForTheGarden.characterQuest(this.character()).questItem(2).isNew()) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Der magische Samen ist für Trommon."))
				
				return
			endif
			
			if (IsMaskedToPlayer(GetSpellTargetX(), GetSpellTargetY(), this.character().player())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sichtbar sein."))
				return
			endif
			call PingMinimapExForPlayer(Player(0), GetRectCenterX(gg_rct_trommons_vegetable_garden), GetRectCenterY(gg_rct_trommons_vegetable_garden), 10.0, 100, 100, 100, false)
			if (dist > 800.0) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sich in Trommons Garten befinden."))
				return
			endif
			
			call QuestSeedsForTheGarden.characterQuest(this.character()).questItem(2).complete()
			set whichUnit = CreateUnit(this.character().player(), 'e001', GetSpellTargetX(), GetSpellTargetY(), 0.0)
			call DestroyEffect(AddSpecialEffectTarget("Abilities\\Spells\\NightElf\\Tranquility\\Tranquility.mdx", whichUnit, "overhead"))
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.action, EVENT_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary
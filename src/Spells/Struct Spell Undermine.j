/// Elemental Mage
library StructSpellsSpellUndermine requires Asl, StructGameClasses, StructGameSpell

	/// Der Elementarmagier bekommt X Manapunkte für Y Leben pro Sekunde zurück. Er kann an dieser Fähigkeit sterben.
	struct SpellUndermine extends Spell
		public static constant integer abilityId = 'A01G'
		public static constant integer favouriteAbilityId = 'A043'
		public static constant integer maxLevel = 5
		private static constant integer buffId = 'B00E'

		/// @todo Was passiert bei mehreren Buffs?
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local real manaValue = 10.0 + 10.0 * this.level() * 0.10
			local real lifeValue = 15.0 - 15.0 * this.level() * 0.10
			call IssueImmediateOrder(caster, "stop")
			/// \todo Add custom buff in channel ability
			//call UnitAddAbility(caster, thistype.buffId)
			//call UnitMakeAbilityPermanent(caster, true, thistype.buffId) //bleibt auch bei Verwandlungen
			debug call Print("Undermine: Current order is " + GetObjectName(GetUnitCurrentOrder(caster)))
			loop
				exitwhen (IsUnitDeadBJ(caster) or GetUnitCurrentOrder(caster) != thistype.abilityId) /// @todo set correct order
				call SetUnitManaBJ(caster, GetUnitState(caster, UNIT_STATE_MANA) + manaValue)
				call SetUnitLifeBJ(caster, GetUnitState(caster, UNIT_STATE_LIFE) - lifeValue)
				debug call Print("+" + R2S(manaValue) + " Mana und +" + R2S(lifeValue))
				call TriggerSleepAction(1.0)
			endloop
			debug call Print("Undermine: Canceled.")
			//call UnitRemoveAbility(caster, thistype.buffId)
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0ZO', 'A0ZT')
			call this.addGrimoireEntry('A0ZP', 'A0ZU')
			call this.addGrimoireEntry('A0ZQ', 'A0ZV')
			call this.addGrimoireEntry('A0ZR', 'A0ZW')
			call this.addGrimoireEntry('A0ZS', 'A0ZX')
			
			return this
		endmethod
	endstruct

endlibrary
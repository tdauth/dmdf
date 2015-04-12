/// Elemental Mage
library StructSpellsSpellUndermine requires Asl, StructGameClasses, StructGameSpell

	/// Zehren
	/// Der Elementarmagier bekommt X Manapunkte für Y Leben pro Sekunde zurück. Er kann an dieser Fähigkeit sterben.
	struct SpellUndermine extends Spell
		public static constant integer abilityId = 'A01G'
		public static constant integer favouriteAbilityId = 'A043'
		public static constant integer maxLevel = 5
		private static constant integer buffId = 'B00E'
		private boolean m_enabled

		/// @todo Was passiert bei mehreren Buffs?
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local real manaValue = 10.0 + 10.0 * this.level()
			local real lifeValue = 10.0
			if (not this.m_enabled) then
				/// \todo Add custom buff in channel ability
				//call UnitAddAbility(caster, thistype.buffId)
				//call UnitMakeAbilityPermanent(caster, true, thistype.buffId) //bleibt auch bei Verwandlungen
				debug call Print("Undermine: Enable")
				set this.m_enabled = true
				loop
					exitwhen (IsUnitDeadBJ(caster) or not this.m_enabled) /// @todo set correct order
					call SetUnitManaBJ(caster, GetUnitState(caster, UNIT_STATE_MANA) + manaValue)
					call SetUnitLifeBJ(caster, GetUnitState(caster, UNIT_STATE_LIFE) - lifeValue)
					debug call Print("+" + R2S(manaValue) + " Mana und +" + R2S(lifeValue))
					call TriggerSleepAction(1.0)
				endloop
				debug call Print("Undermine: Canceled.")
				//call UnitRemoveAbility(caster, thistype.buffId)
			else
				set this.m_enabled = false
			endif
			set caster = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			set this.m_enabled = false
			call this.addGrimoireEntry('A0ZO', 'A0ZT')
			call this.addGrimoireEntry('A0ZP', 'A0ZU')
			call this.addGrimoireEntry('A0ZQ', 'A0ZV')
			call this.addGrimoireEntry('A0ZR', 'A0ZW')
			call this.addGrimoireEntry('A0ZS', 'A0ZX')
			
			return this
		endmethod
	endstruct

endlibrary
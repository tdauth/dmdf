/// Elemental Mage
library StructSpellsSpellEmblaze requires Asl, StructGameClasses, StructGameSpell

	/// Der Elementarmagier kann die Waffen seiner Verbündeten 2 Minuten lang entzünden und ihren Schaden um die Stufe des Verbündeten erhöhen.
	struct SpellEmblaze extends Spell
		public static constant integer abilityId = 'A01C'
		public static constant integer favouriteAbilityId = 'A03H'
		public static constant integer classSelectionAbilityId = 'A0TR'
		public static constant integer classSelectionGrimoireAbilityId = 'A0TW'
		public static constant integer maxLevel = 5
		private static constant real time = 30.0
		private static constant integer damageStartValue = 5
		private static constant integer damageLevelFactor = 5
		private static ABuff m_buff

		/// @todo Was passiert bei mehreren Buffs?
		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local integer damage = thistype.damageStartValue + thistype.damageLevelFactor * this.level()
			local real time = thistype.time
			local effect whichEffect = AddSpecialEffectTarget("Models\\Effects\\Emblaze.mdx", target, "origin")
			debug call Print("Emblaze: Before buff.")
			debug call Print("Emblaze: With " + R2S(damage) + " damage.")
			call AUnitAddBonus(target, A_BONUS_TYPE_DAMAGE, damage)
			call thistype.showWeaponDamageTextTag(target, damage)
			loop
				exitwhen (thistype.allyTargetLoopCondition(target) or time <= 0.0)
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			debug call Print("Emblaze ends!")
			call AUnitAddBonus(target, A_BONUS_TYPE_DAMAGE, -damage)
			call DestroyEffect(whichEffect)
			set whichEffect = null
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A0TR', 'A0TW')
			call this.addGrimoireEntry('A0TS', 'A0TX')
			call this.addGrimoireEntry('A0TT', 'A0TY')
			call this.addGrimoireEntry('A0TU', 'A0TZ')
			call this.addGrimoireEntry('A0TV', 'A0U0')
			
			return this
		endmethod
	endstruct

endlibrary
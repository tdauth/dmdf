/// Elemental Mage
library StructSpellsSpellEmblaze requires Asl, StructGameClasses, StructGameSpell

	/// Der Elementarmagier kann die Waffen seiner Verbündeten 2 Minuten lang entzünden und ihren Schaden um die Stufe des Verbündeten erhöhen.
	struct SpellEmblaze extends Spell
		public static constant integer abilityId = 'A01C'
		public static constant integer favouriteAbilityId = 'A03H'
		public static constant integer maxLevel = 5
		private static constant integer buffId = 'B00D'
		private static constant real time = 30.0
		private static constant integer damageLevelFactor = 10
		private static ABuff m_buff

		/// @todo Was passiert bei mehreren Buffs?
		private method action takes nothing returns nothing
			local unit target = GetSpellTargetUnit()
			local integer damage = thistype.damageLevelFactor * this.level()
			local real time = thistype.time
			debug call Print("Emblaze: Before buff.")
			// TODO buggy
			//call thistype.m_buff.add(target)
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
			// TODO buggy
			//call thistype.m_buff.remove(target)
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
		endmethod

		private static method onInit takes nothing returns nothing
			set thistype.m_buff = ABuff.create(thistype.buffId)
		endmethod
	endstruct

endlibrary
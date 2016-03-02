/// Elemental Mage
library StructSpellsSpellEmblaze requires Asl, StructGameClasses, StructGameSpell

	// TODO remove on unit death or removal
	private struct BuffData
		private SpellEmblaze m_spell
		private unit m_target
		private integer m_damage
		private real m_time
		private timer m_timer
		
		private static method timerFunctionRemove takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), "this"))
			call SpellEmblaze.removeBuff.evaluate(this.m_spell.character().unit(), this.m_target)
			call this.destroy()
		endmethod
		
		public static method create takes SpellEmblaze spell, unit target returns thistype
			local thistype this = thistype.allocate()
			set this.m_spell = spell
			set this.m_target = target
			set this.m_damage = SpellEmblaze.damageStartValue + SpellEmblaze.damageLevelFactor * spell.level()
			set this.m_time = SpellEmblaze.time
			debug call Print("Emblaze: Before buff.")
			debug call Print("Emblaze: With " + R2S(this.m_damage) + " damage.")
			call AUnitAddBonus(target, A_BONUS_TYPE_DAMAGE, this.m_damage)
			call Spell.showWeaponDamageTextTag(target, this.m_damage)
			
			set this.m_timer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_timer, "this", this)
			call TimerStart(this.m_timer, this.m_time, false, function thistype.timerFunctionRemove)
			
			return this
		endmethod
		
		private method onDestroy takes nothing returns nothing
			call PauseTimer(this.m_timer)
			call DmdfHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
			call Spell.showWeaponDamageTextTag(this.m_target, -this.m_damage)
			call AUnitAddBonus(this.m_target, A_BONUS_TYPE_DAMAGE, -this.m_damage)
			set this.m_target = null
		endmethod
		
	endstruct

	private struct Buff extends ABuff
	
		public stub method onAdd takes unit source, unit whichUnit, integer index returns nothing
			local Character character = Character.getCharacterByUnit(source)
			local BuffData buffData = 0
			if (index > 0) then
				// remove old buff data first
				set buffData = BuffData(DmdfHashTable.global().handleInteger(whichUnit, "SpellEmblazeBuffData"))
				call buffData.destroy()
			endif
			set buffData = BuffData.create(character.grimoire().spellByAbilityId(SpellEmblaze.abilityId), whichUnit)
			call DmdfHashTable.global().setHandleInteger(whichUnit, "SpellEmblazeBuffData", buffData)
		endmethod
		
		public stub method onRemove takes unit source, unit whichUnit, integer index returns nothing
		endmethod
		
		public static method create takes integer buffId returns thistype
			local thistype this = thistype.allocate(buffId)

			return this
		endmethod
	endstruct

	/// Der Elementarmagier kann die Waffen seiner Verbündeten 2 Minuten lang entzünden und ihren Schaden um die Stufe des Verbündeten erhöhen.
	struct SpellEmblaze extends Spell
		public static constant integer abilityId = 'A01C'
		public static constant integer favouriteAbilityId = 'A03H'
		public static constant integer classSelectionAbilityId = 'A0TR'
		public static constant integer classSelectionGrimoireAbilityId = 'A0TW'
		public static constant integer buffAbilityId = 'A1IY'
		public static constant integer maxLevel = 5
		public static constant real time = 30.0
		public static constant integer damageStartValue = 5
		public static constant integer damageLevelFactor = 5
		private static Buff m_buff

		/// Multiple Buffs: Stop old buff and start new. Do not stack. It would be too unfair.
		private method action takes nothing returns nothing
			debug call Print("EMBLAZE!!!")
			debug call Print("Source: " + GetUnitName(this.character().unit()) + " target: " + GetUnitName(GetSpellTargetUnit()))
			debug call Print("With buff: " + I2S(thistype.m_buff))
			call thistype.m_buff.add(this.character().unit(), GetSpellTargetUnit())
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
		
		private static method onInit takes nothing returns nothing
			set thistype.m_buff = Buff.create(thistype.buffAbilityId)
		endmethod
		
		public static method removeBuff takes unit source, unit target returns nothing
			call thistype.m_buff.remove(source, target)
		endmethod
	endstruct

endlibrary
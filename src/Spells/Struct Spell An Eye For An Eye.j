/// Dragon Slayer
library StructSpellsSpellAnEyeForAnEye requires Asl, StructGameClasses, StructGameSpell

	/// Der Drachentöter kontert die nächsten zwei Nahkampfangriffe eines Gegners und lenkt X % des Schadens auf ihn zurück. Der Drachentöter erleidet keinen Schaden. 1 Minute Abklingzeit.
	struct SpellAnEyeForAnEye extends Spell
		public static constant integer abilityId = 'A01B'
		public static constant integer favouriteAbilityId = 'A03M'
		public static constant integer maxLevel = 5
		private static constant real damageLevelFactor = 2.0
		private integer m_count

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local thistype spell = DmdfHashTable.global().integer("SpellAnEyeForAnEye" + I2S(damageRecorder), "this")
			local unit caster = damageRecorder.target()
			local unit target = GetEventDamageSource()
			local real damage = GetEventDamage() * thistype.damageLevelFactor
			call SetUnitState(caster, UNIT_STATE_LIFE, GetUnitState(caster, UNIT_STATE_LIFE) + damage)
			call SetUnitState(target, UNIT_STATE_LIFE, RMaxBJ(0.0, GetUnitState(target, UNIT_STATE_LIFE) - damage))
			call ShowBashTextTagForPlayer(null, GetUnitX(target), GetUnitY(target), R2I(damage))
			set spell.m_count = spell.m_count + 1
			if (spell.m_count == 2) then
				call DmdfHashTable.global().flushKey("SpellAnEyeForAnEye" + I2S(damageRecorder))
				call damageRecorder.destroy()
				set spell.m_count = 0
			endif
			set caster = null
			set target = null
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local ADamageRecorder damageRecorder = ADamageRecorder.create(caster)
			call damageRecorder.setOnDamageAction(thistype.onDamageAction)
			call DmdfHashTable.global().setInteger("SpellAnEyeForAnEye" + I2S(damageRecorder), "this", this)
			set caster = null
		endmethod

		public static method create takes ACharacter character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			set this.m_count = 0
			return this
		endmethod
	endstruct

endlibrary
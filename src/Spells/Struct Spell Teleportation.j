/// Elemental Mage
library StructSpellsSpellTeleportation requires Asl, StructGameClasses, StructGameSpell

	struct SpellTeleportation extends Spell
		public static constant integer abilityId = 'A01I'
		public static constant integer favouriteAbilityId = 'A03P'
		public static constant integer maxLevel = 5
		private static constant real damageLevelValue = 0.10 //Schadens-Stufenfaktor (ab Stufe 1)
		private static constant real time = 5.0 //Zeitkonstante (unverändert)

		private method condition takes nothing returns boolean
			return true
		endmethod

		private static method onDamageAction takes ADamageRecorder damageRecorder returns nothing
			local unit caster = damageRecorder.target()
			local real damage = GetEventDamage() * thistype.damageLevelValue * GetUnitAbilityLevel(caster, thistype.abilityId)
			call SetUnitLifeBJ(caster, GetUnitState(caster, UNIT_STATE_LIFE) + damage)
			call Spell.showDamageAbsorbationTextTag(caster, damage)
			set caster = null
		endmethod

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local effect casterEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, caster, "chest")
			local effect targetEffect = AddSpellEffectById(thistype.abilityId, EFFECT_TYPE_TARGET, GetSpellTargetX(), GetSpellTargetY())
			local real time = thistype.time
			local ADamageRecorder damageRecorder
			
			if (IsMaskedToPlayer(GetSpellTargetX(), GetSpellTargetY(), this.character().player())) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Ziel-Punkt muss sichtbar sein."))
				return
			elseif (IsUnitType(GetTriggerUnit(), UNIT_TYPE_SNARED)) then
				call this.character().displayMessage(ACharacter.messageTypeError, tr("Einheit darf nicht gefesselt sein."))
				return
			endif

			
			
			call this.character().setX(GetSpellTargetX())
			call this.character().setY(GetSpellTargetY())
			call ResetUnitAnimation(caster)
			set damageRecorder = ADamageRecorder.create(this.character().unit())
			call damageRecorder.setOnDamageAction(thistype.onDamageAction)
			// immediate stopping disables cooldown!
			//call IssueImmediateOrder(caster, "stop")
			loop
				exitwhen (time <= 0.0 or IsUnitDeadBJ(caster) or not this.isLearned())
				call TriggerSleepAction(1.0)
				set time = time - 1.0
			endloop
			call damageRecorder.destroy()
			set caster = null
			call DestroyEffect(casterEffect)
			set casterEffect = null
			call DestroyEffect(targetEffect)
			set targetEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.elementalMage(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, thistype.condition, thistype.action)
			
			call this.addGrimoireEntry('A0L0', 'A0L5')
			call this.addGrimoireEntry('A0L1', 'A0L6')
			call this.addGrimoireEntry('A0L2', 'A0L7')
			call this.addGrimoireEntry('A0L3', 'A0L8')
			call this.addGrimoireEntry('A0L4', 'A0L9')
			
			return this
		endmethod
	endstruct

endlibrary
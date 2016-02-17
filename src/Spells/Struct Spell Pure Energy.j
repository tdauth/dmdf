/// Elemental Mage
library StructSpellsSpellPureEnergy requires Asl, StructGameClasses, StructGameSpell

	/**
	 * Der Elementarmagier fügt seinem Ziel Schaden in Höhe seiner momentanen Manapunkte zu. 5 Minuten Abklingzeit.
	 * Kostet restliches Mana - und wird von Elementare Gewalt betroffen. Wer schlau ist … ;)
	 */
	struct SpellPureEnergy extends SpellElementalMageDamageSpell
		public static constant integer abilityId = 'A01X'
		public static constant integer favouriteAbilityId = 'A03O'
		public static constant integer classSelectionAbilityId = 'A0ZK'
		public static constant integer classSelectionGrimoireAbilityId = 'A0ZL'
		public static constant integer maxLevel = 1
		public static sound soundTargetEffect

		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local real damage = GetUnitState(caster, UNIT_STATE_MANA) + SpellElementalMageDamageSpell(this).damageBonusFactor() * GetUnitState(caster, UNIT_STATE_MANA)
			local effect spellEffect = AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_TARGET, target, "chest")
			call AttachSoundToUnit(thistype.soundTargetEffect, target)
			//SetSoundVolumeBJ ?
			call StartSound(thistype.soundTargetEffect)
			call UnitDamageTargetBJ(caster, target, damage, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC)
			call ShowBashTextTagForPlayer(null, GetWidgetX(target), GetWidgetY(target), R2I(damage))
			set caster = null
			set target = null
			call DestroyEffect(spellEffect)
			set spellEffect = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.createWithEventDamageSpell(character, Spell.spellTypeUltimate1, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action, EVENT_PLAYER_UNIT_SPELL_EFFECT) // if the event channel is used, the cooldown and mana costs are ignored if UnitDamageTargetBJ() kills the target
			call this.addGrimoireEntry('A0ZK', 'A0ZL')
			
			return this
		endmethod

		private static method onInit takes nothing returns nothing
			//2 Sekunden = 2000
			set thistype.soundTargetEffect = CreateSound("Abilities\\Spells\\NightElf\\FaerieDragonInvis\\PhaseShift1.wav", false, false, false, 10, 10, "")
			call SetSoundDuration(thistype.soundTargetEffect, 1251)
			call SetSoundChannel(thistype.soundTargetEffect, 0)
			call SetSoundVolume(thistype.soundTargetEffect, 127)
			call SetSoundPitch(thistype.soundTargetEffect, 1.0)
		endmethod
	endstruct

endlibrary
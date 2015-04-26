/// Cleric
library StructSpellsSpellImpendingDisaster requires Asl, StructGameClasses, StructGameSpell

	/// Eine befreundete Einheit wird vor einer drohenden Gefahr beschützt. Der nächste Angriff richtet nur X% des verursachten Schadens an. 10 Sekunden Abklingzeit.
	/// Niedrige Kosten und Abklingzeit dafür nicht zu stark. Der Kleriker soll damit viele Einheiten vor etwas Schaden schützen können.
	struct SpellImpendingDisaster extends Spell
		public static constant integer abilityId = 'A08B'
		public static constant integer favouriteAbilityId = 'A08C'
		public static constant integer classSelectionAbilityId = 'A0ON'
		public static constant integer classSelectionGrimoireAbilityId = 'A0OS'
		public static constant integer maxLevel = 5
		private static constant integer startPercentage = 10
		private static constant integer levelPercentage = 5

		private static method onDamageAction takes DamageProtector damageProtector returns nothing
			call Spell.showDamageAbsorbationTextTag(damageProtector.target(), damageProtector.lastPreventedDamage())
			call damageProtector.destroy()
		endmethod

		public stub method onCastAction takes nothing returns nothing
			local DamageProtector damageProtector = DamageProtector.create(GetSpellTargetUnit())
			call damageProtector.setProtectedDamagePercentage(thistype.startPercentage + this.level() * thistype.levelPercentage)
			call damageProtector.setOnDamageAction(thistype.onDamageAction)
			debug call Print("Impending Disaster!")
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.cleric(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, 0)
			
			call this.addGrimoireEntry('A0ON', 'A0OS')
			call this.addGrimoireEntry('A0OM', 'A0OT')
			call this.addGrimoireEntry('A0OP', 'A0OU')
			call this.addGrimoireEntry('A0OQ', 'A0OV')
			call this.addGrimoireEntry('A0OR', 'A0OW')
			
			return this
		endmethod
	endstruct

endlibrary
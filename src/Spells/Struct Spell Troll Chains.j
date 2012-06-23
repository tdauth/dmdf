/// Item
library StructSpellsSpellTrollChains requires Asl

	struct SpellTrollChains extends ASpell
		/// @todo FIXME
		public static constant integer abilityId = 'A014'
		private static constant real time = 5.0

		/// @todo Implement funmap algorithm
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local unit target = GetSpellTargetUnit()
			local player targetOwner = GetOwningPlayer(target)
			local ADynamicLightning dynamicLightning = ADynamicLightning.create(null, "XXXX", 0.01, caster, target)
			local real time = thistype.time
			loop
				exitwhen (time <= 0.0)
				call TriggerSleepAction(0.01)
				set time = time - 0.01
			endloop

			set caster = null
			set target = null
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary
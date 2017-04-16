library StructSpellsSpellScrollOfCollector requires Asl

	struct SpellScrollOfCollector extends ASpell
		public static constant integer abilityId = 'A133'
		private static thistype array m_spell[12] /// TODO MapSettings.maxPlayers()
		/// Indicates that at least one item has been found.
		private boolean m_foundOne

		private static method filterFunc takes nothing returns boolean
			return (GetItemPlayer(GetFilterItem()) == GetOwningPlayer(GetTriggerUnit()))
		endmethod

		private static method collect takes nothing returns nothing
			local thistype this = thistype.m_spell[GetPlayerId(GetOwningPlayer(GetTriggerUnit()))]
			set this.m_foundOne = true
			call SetItemPosition(GetFilterItem(), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
		endmethod

		private method condition takes nothing returns boolean
			local filterfunc filter = Filter(function thistype.filterFunc)
			local boolean result = false
			set this.m_foundOne = false
			call EnumItemsInRect(bj_mapInitialPlayableArea, filter, function thistype.collect)

			// only cast if at least one item has been found
			if (this.m_foundOne) then
				call DestroyEffect(AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, GetTriggerUnit(), "origin"))
				set result = true
			else
				call this.character().displayMessage(Character.messageTypeError, tre("Kein Gegenstand gefunden.", "No item found."))
			endif

			set this.m_foundOne = false

			return result
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, thistype.abilityId, 0, thistype.condition, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true)

			set this.m_foundOne = false
			set thistype.m_spell[GetPlayerId(character.player())] = this

			return this
		endmethod
	endstruct

endlibrary
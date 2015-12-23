library StructMapSpellsSpellScrollOfCollector requires Asl, StructMapMapMapData

	struct SpellScrollOfCollector extends ASpell
		public static constant integer abilityId = 'A133'
		
		private static method filterFunc takes nothing returns boolean
			return (GetItemPlayer(GetFilterItem()) == GetOwningPlayer(GetTriggerUnit()))
		endmethod

		private static method collect takes nothing returns nothing
			call SetItemPosition(GetFilterItem(), GetUnitX(GetTriggerUnit()), GetUnitY(GetTriggerUnit()))
		endmethod
		
		private method condition takes nothing returns boolean
			local filterfunc filter = Filter(function thistype.filterFunc)
			call EnumItemsInRect(bj_mapInitialPlayableArea, filter, function thistype.collect)
			call DestroyEffect(AddSpellEffectTargetById(thistype.abilityId, EFFECT_TYPE_CASTER, GetTriggerUnit(), "origin"))
			
			return true
		endmethod

		public static method create takes Character character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, thistype.condition, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod
	endstruct

endlibrary
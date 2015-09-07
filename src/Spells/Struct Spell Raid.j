/// Dragon Slayer
library StructSpellsSpellRaid requires Asl, StructGameClasses, StructGameSpell

	struct SpellRaid extends Spell
		public static constant integer abilityId = 'A19Z'
		public static constant integer favouriteAbilityId = 'A1A0'
		public static constant integer classSelectionAbilityId = 'A1A1'
		public static constant integer classSelectionGrimoireAbilityId = 'A1A2'
		public static constant integer maxLevel = 5
		private static itempool array m_itemPools[5]
		
		private method levelItemPool takes nothing returns itempool
			return thistype.m_itemPools[GetRandomInt(0, this.level())]
		endmethod
		
		private method action takes nothing returns nothing
/*
			CreateItemPool           takes nothing returns itempool
native DestroyItemPool          takes itempool whichItemPool returns nothing
native ItemPoolAddItemType      takes itempool whichItemPool, integer itemId, real weight returns nothing
native ItemPoolRemoveItemType   takes itempool whichItemPool, integer itemId returns nothing
native PlaceRandomItem          takes itempool whichItemPool, real x, real y returns item

ChooseRandomItem         takes integer level returns integer
native ChooseRandomItemEx       takes itemtype whichType, integer level returns integer
*/
			local item whichItem = PlaceRandomItem(this.levelItemPool(), GetUnitX(this.character().unit()), GetUnitY(this.character().unit()))
			call SetItemPlayer(whichItem, this.character().player(), true)
			call Character(this.character()).displayItemAcquired(GetItemName(whichItem), "Beutezug.")
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1A1', 'A1A2')
			// TODO use different abilities
			call this.addGrimoireEntry('A1A1', 'A1A2')
			call this.addGrimoireEntry('A1A1', 'A1A2')
			call this.addGrimoireEntry('A1A1', 'A1A2')
			call this.addGrimoireEntry('A1A1', 'A1A2')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
		
		private static method onInit takes nothing returns nothing
			// TODO fill more items
			set thistype.m_itemPools[0] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I016', 1.0)
			
			set thistype.m_itemPools[1] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I03O', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I01F', 1.0)
			
			set thistype.m_itemPools[2] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I057', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I01G', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I05M', 1.0)
			
			set thistype.m_itemPools[3] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I00F', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I02I', 1.0)
			
			set thistype.m_itemPools[4] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[4], 'I04Q', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[4], 'I00U', 1.0)
		endmethod
	endstruct

endlibrary
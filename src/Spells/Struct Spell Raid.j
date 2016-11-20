/// Dragon Slayer
library StructSpellsSpellRaid requires Asl, StructGameClasses, StructGameSpell

	struct SpellRaid extends Spell
		public static constant integer abilityId = 'A19Z'
		public static constant integer favouriteAbilityId = 'A1A0'
		public static constant integer classSelectionAbilityId = 'A1N7'
		public static constant integer classSelectionGrimoireAbilityId = 'A1N8'
		public static constant integer maxLevel = 5
		private static itempool array m_itemPools[5]

		private method levelItemPool takes nothing returns itempool
			// prevent that really bad items are placed so make between max level and max level - 2
			return thistype.m_itemPools[GetRandomInt(IMaxBJ(0, this.level() - 3), this.level() - 1)]
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
			local item whichItem
			local integer i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					set whichItem = PlaceRandomItem(this.levelItemPool(), GetUnitX(ACharacter.playerCharacter(Player(i)).unit()), GetUnitY(ACharacter.playerCharacter(Player(i)).unit()))
					call SetItemPlayer(whichItem, Player(i), true)
					call Character(ACharacter.playerCharacter(Player(i))).displayItemAcquired(GetItemName(whichItem), "Beutezug.")
				endif
				set i = i + 1
			endloop
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), thistype.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1N7', 'A1N8')
			call this.addGrimoireEntry('A1A1', 'A1A2')
			call this.addGrimoireEntry('A1CP', 'A1CT')
			call this.addGrimoireEntry('A1CQ', 'A1CU')
			call this.addGrimoireEntry('A1CR', 'A1CV')
			call this.addGrimoireEntry('A1CS', 'A1CW')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod

		private static method onInit takes nothing returns nothing
			// TODO fill more items

			// level 1 items
			set thistype.m_itemPools[0] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I016', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I017', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I03Y', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I009', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I00E', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I01K', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I01L', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[0], 'I047', 1.0)

			// level 2 items
			set thistype.m_itemPools[1] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I03O', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I01F', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I05K', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I00A', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I05L', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I00D', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[1], 'I049', 1.0)

			// level 3 items
			set thistype.m_itemPools[2] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I057', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I01G', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I05M', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I02R', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I00B', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I00C', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[2], 'I041', 1.0)

			// level 4 items
			set thistype.m_itemPools[3] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I00F', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I02I', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I00G', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I056', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I04N', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I045', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[3], 'I024', 1.0)

			// level 5 items
			set thistype.m_itemPools[4] = CreateItemPool()
			call ItemPoolAddItemType(thistype.m_itemPools[4], 'I04Q', 1.0)
			call ItemPoolAddItemType(thistype.m_itemPools[4], 'I00U', 1.0)
		endmethod
	endstruct

endlibrary
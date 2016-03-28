library StructMapMapNpcs requires StructGameDmdfHashTable

	/**
	 * \brief Static struct which stores global instances of the NPCs for simplified access.
	 */
	struct Npcs
		private static unit m_agihard
		private static unit m_baldar
		private static unit m_bjoern
		private static unit m_bjoernsWife
		private static unit m_brogo
		private static unit m_dago
		private static unit m_dragonSlayer
		private static unit m_einar
		private static unit m_einarsShop
		private static unit m_ferdinand
		private static unit m_fulco
		private static unit m_guntrich
		private static unit m_haid
		private static unit m_haldar
		private static unit m_heimrich
		private static unit m_irmina
		private static unit m_irminasShop
		private static unit m_kuno
		private static unit m_kunosDaughter
		private static unit m_lothar
		private static unit m_manfred
		private static unit m_manfredsDog
		private static unit m_markward
		private static unit m_mathilda
		private static unit m_osman
		private static unit m_ricman
		private static unit m_sisgard
		private static unit m_tanka
		private static unit m_tellborn
		private static unit m_tobias
		private static unit m_trommon
		private static unit m_ursula
		private static unit m_wieland
		private static unit m_wigberht
		private static unit m_sheepBoy
		private static unit m_carsten
		private static unit m_dararos
		private static unit m_osmansShop
		private static unit m_bjoernsShop
		private static unit m_agihardsShop
		private static trigger m_sellTrigger

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
		endmethod
		
		private static method triggerConditionSell takes nothing returns boolean
			if (GetUnitTypeId(GetSoldUnit()) == 'n05Y') then
				return true
			endif
			
			return false
		endmethod
		
		private static method timerFunctionSelectShop takes nothing returns nothing
			local unit sellingUnit = thistype(DmdfHashTable.global().handleUnit(GetExpiredTimer(), 0))
			local unit soldUnit = DmdfHashTable.global().handleUnit(GetExpiredTimer(), 1)
			
			if (sellingUnit == thistype.m_einar) then
				call SmartCameraPanWithZForPlayer(GetOwningPlayer(soldUnit), GetUnitX(thistype.m_einarsShop), GetUnitY(thistype.m_einarsShop), 0.0, 0.0)
				call SelectUnitForPlayerSingle(thistype.m_einarsShop, GetOwningPlayer(soldUnit))
			elseif (sellingUnit == thistype.m_irmina) then
				call SmartCameraPanWithZForPlayer(GetOwningPlayer(soldUnit), GetUnitX(thistype.m_irminasShop), GetUnitY(thistype.m_irminasShop), 0.0, 0.0)
				call SelectUnitForPlayerSingle(thistype.m_irminasShop, GetOwningPlayer(soldUnit))
			elseif (sellingUnit == thistype.m_osman) then
				call SmartCameraPanWithZForPlayer(GetOwningPlayer(soldUnit), GetUnitX(thistype.m_osmansShop), GetUnitY(thistype.m_osmansShop), 0.0, 0.0)
				call SelectUnitForPlayerSingle(thistype.m_osmansShop, GetOwningPlayer(soldUnit))
			elseif (sellingUnit == thistype.m_bjoern) then
				call SmartCameraPanWithZForPlayer(GetOwningPlayer(soldUnit), GetUnitX(thistype.m_bjoernsShop), GetUnitY(thistype.m_bjoernsShop), 0.0, 0.0)
				call SelectUnitForPlayerSingle(thistype.m_bjoernsShop, GetOwningPlayer(soldUnit))
			elseif (sellingUnit == thistype.m_agihard) then
				call SmartCameraPanWithZForPlayer(GetOwningPlayer(soldUnit), GetUnitX(thistype.m_agihardsShop), GetUnitY(thistype.m_agihardsShop), 0.0, 0.0)
				call SelectUnitForPlayerSingle(thistype.m_agihardsShop, GetOwningPlayer(soldUnit))
			endif
			
			call RemoveUnit(soldUnit)
			
			
			call PauseTimer(GetExpiredTimer())
			call DmdfHashTable.global().destroyTimer(GetExpiredTimer())
		endmethod
		
		private static method triggerActionSell takes nothing returns nothing
			local timer whichTimer = CreateTimer()
			call DmdfHashTable.global().setHandleUnit(whichTimer, 0, GetSellingUnit()) 
			call DmdfHashTable.global().setHandleUnit(whichTimer, 1, GetSoldUnit()) 
			
			debug call Print("Trigger unit: " + GetUnitName(GetTriggerUnit()))
			debug call Print("Selling unit: " + GetUnitName(GetSellingUnit()))
			debug call Print("Buying unit " + GetUnitName(GetBuyingUnit()))
			call SetUnitInvulnerable(GetSoldUnit(), true)
			call ShowUnit(GetSoldUnit(), false)
			call PauseUnit(GetSoldUnit(), true)
			
			// wait since the selling unit is being paused
			call TimerStart(whichTimer, 0.0, false, function thistype.timerFunctionSelectShop)
		endmethod

		/// This method is and has to be called after unit creation.
		private static method onInit takes nothing returns nothing
			set thistype.m_agihard = gg_unit_n00S_0135
			set thistype.m_baldar = gg_unit_n00L_0026
			set thistype.m_bjoern = gg_unit_n02U_0142
			set thistype.m_bjoernsWife = gg_unit_n02V_0146
			set thistype.m_brogo = gg_unit_n020_0012
			set thistype.m_dago = gg_unit_H01D_0144
			set thistype.m_dragonSlayer = gg_unit_H01F_0038
			call SetUnitInvulnerable(thistype.m_dragonSlayer, true) // set invulnerable manually since it has a metamorphosis skill
			set thistype.m_einar = gg_unit_n01Z_0155
			set thistype.m_einarsShop = gg_unit_n04S_0410
			set thistype.m_ferdinand = gg_unit_n01J_0154
			set thistype.m_fulco = gg_unit_n012_0115
			set thistype.m_guntrich = gg_unit_n02T_0141
			set thistype.m_haid = gg_unit_n017_0137
			set thistype.m_haldar = gg_unit_n00K_0040
			set thistype.m_heimrich = gg_unit_n013_0116
			set thistype.m_irmina = gg_unit_n01S_0201
			set thistype.m_irminasShop = gg_unit_n04T_0409
			set thistype.m_kuno = gg_unit_n022_0009
			set thistype.m_kunosDaughter = gg_unit_n02S_0065
			set thistype.m_lothar = gg_unit_n030_0240
			set thistype.m_manfred = gg_unit_n01H_0148
			set thistype.m_manfredsDog = gg_unit_n02Z_0143
			set thistype.m_markward = gg_unit_n014_0117
			set thistype.m_mathilda = gg_unit_H024_0412
			set thistype.m_osman = gg_unit_n00R_0101
			set thistype.m_osmansShop = gg_unit_n04R_0408
			set thistype.m_bjoernsShop = gg_unit_n04U_0411
			set thistype.m_agihardsShop = gg_unit_n04W_0413
			set thistype.m_ricman = gg_unit_H01E_0028
			set thistype.m_sisgard = gg_unit_H014_0156
			set thistype.m_tanka = gg_unit_n023_0011
			set thistype.m_tellborn = gg_unit_n011_0113
			set thistype.m_tobias = gg_unit_n01C_0064
			set thistype.m_trommon = gg_unit_n021_0004
			set thistype.m_ursula = gg_unit_n01U_0203
			set thistype.m_wieland = gg_unit_n01Y_0006
			set thistype.m_wigberht = gg_unit_H01C_0228
			set thistype.m_sheepBoy = gg_unit_n02B_0058
			set thistype.m_carsten = gg_unit_n05G_0393
			set thistype.m_dararos = null
			
			/*
			 * Make guardians invulnerable.
			 */
			call SetUnitInvulnerable(gg_unit_n015_0149, true)
			call SetUnitInvulnerable(gg_unit_n005_0119, true)
			call SetUnitInvulnerable(gg_unit_n015_0118, true)
			call SetUnitInvulnerable(gg_unit_n015_0456, true)
			
			set thistype.m_sellTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(thistype.m_sellTrigger, EVENT_PLAYER_UNIT_SELL)
			call TriggerAddCondition(thistype.m_sellTrigger, Condition(function thistype.triggerConditionSell))
			call TriggerAddAction(thistype.m_sellTrigger, function thistype.triggerActionSell)
		endmethod

		public static method agihard takes nothing returns unit
			return thistype.m_agihard
		endmethod

		public static method baldar takes nothing returns unit
			return thistype.m_baldar
		endmethod

		public static method bjoern takes nothing returns unit
			return thistype.m_bjoern
		endmethod

		public static method bjoernsWife takes nothing returns unit
			return thistype.m_bjoernsWife
		endmethod

		public static method brogo takes nothing returns unit
			return thistype.m_brogo
		endmethod

		public static method dago takes nothing returns unit
			return thistype.m_dago
		endmethod
		
		public static method dragonSlayer takes nothing returns unit
			return thistype.m_dragonSlayer
		endmethod

		public static method einar takes nothing returns unit
			return thistype.m_einar
		endmethod

		public static method ferdinand takes nothing returns unit
			return thistype.m_ferdinand
		endmethod

		public static method fulco takes nothing returns unit
			return thistype.m_fulco
		endmethod

		public static method guntrich takes nothing returns unit
			return thistype.m_guntrich
		endmethod

		public static method haid takes nothing returns unit
			return thistype.m_haid
		endmethod

		public static method haldar takes nothing returns unit
			return thistype.m_haldar
		endmethod

		public static method heimrich takes nothing returns unit
			return thistype.m_heimrich
		endmethod

		public static method irmina takes nothing returns unit
			return thistype.m_irmina
		endmethod

		public static method kuno takes nothing returns unit
			return thistype.m_kuno
		endmethod

		public static method kunosDaughter takes nothing returns unit
			return thistype.m_kunosDaughter
		endmethod

		public static method lothar takes nothing returns unit
			return thistype.m_lothar
		endmethod

		public static method manfred takes nothing returns unit
			return thistype.m_manfred
		endmethod
		
		public static method manfredsDog takes nothing returns unit
			return thistype.m_manfredsDog
		endmethod

		public static method markward takes nothing returns unit
			return thistype.m_markward
		endmethod

		public static method mathilda takes nothing returns unit
			return thistype.m_mathilda
		endmethod

		public static method osman takes nothing returns unit
			return thistype.m_osman
		endmethod

		public static method ricman takes nothing returns unit
			return thistype.m_ricman
		endmethod

		public static method sisgard takes nothing returns unit
			return thistype.m_sisgard
		endmethod

		public static method tanka takes nothing returns unit
			return thistype.m_tanka
		endmethod

		public static method tellborn takes nothing returns unit
			return thistype.m_tellborn
		endmethod

		public static method tobias takes nothing returns unit
			return thistype.m_tobias
		endmethod

		public static method trommon takes nothing returns unit
			return thistype.m_trommon
		endmethod

		public static method ursula takes nothing returns unit
			return thistype.m_ursula
		endmethod

		public static method wieland takes nothing returns unit
			return thistype.m_wieland
		endmethod

		public static method wigberht takes nothing returns unit
			return thistype.m_wigberht
		endmethod
		
		public static method sheepBoy takes nothing returns unit
			return thistype.m_sheepBoy
		endmethod
		
		public static method carsten takes nothing returns unit
			return thistype.m_carsten
		endmethod
		
		public static method initDararos takes unit whichUnit returns nothing
			 set thistype.m_dararos = whichUnit
		endmethod
		
		public static method dararos takes nothing returns unit
			return thistype.m_dararos
		endmethod
	endstruct

endlibrary
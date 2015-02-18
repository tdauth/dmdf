library StructMapMapNpcs

	struct Npcs
		private static unit m_agihard
		private static unit m_baldar
		private static unit m_bjoern
		private static unit m_bjoernsWife
		private static unit m_brogo
		private static unit m_dago
		private static unit m_dragonSlayer
		private static unit m_einar
		private static unit m_ferdinand
		private static unit m_fulco
		private static unit m_guntrich
		private static unit m_haid
		private static unit m_haldar
		private static unit m_heimrich
		private static unit m_irmina
		private static unit m_kuno
		private static unit m_kunosDaughter
		private static unit m_lothar
		private static unit m_manfred
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

		private static method create takes nothing returns thistype
			return 0
		endmethod

		private method onDestroy takes nothing returns nothing
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
			set thistype.m_ferdinand = gg_unit_n01J_0154
			set thistype.m_fulco = gg_unit_n012_0115
			set thistype.m_guntrich = gg_unit_n02T_0141
			set thistype.m_haid = gg_unit_n017_0137
			set thistype.m_haldar = gg_unit_n00K_0040
			set thistype.m_heimrich = gg_unit_n013_0116
			set thistype.m_irmina = gg_unit_n01S_0201
			set thistype.m_kuno = gg_unit_n022_0009
			set thistype.m_kunosDaughter = gg_unit_n02S_0065
			set thistype.m_lothar = gg_unit_n030_0240
			set thistype.m_manfred = gg_unit_n01H_0148
			set thistype.m_markward = gg_unit_n014_0117
			set thistype.m_mathilda = gg_unit_n01T_0202
			set thistype.m_osman = gg_unit_n00R_0101
			set thistype.m_ricman = gg_unit_H01E_0028
			set thistype.m_sisgard = gg_unit_H014_0156
			set thistype.m_tanka = gg_unit_n023_0011
			set thistype.m_tellborn = gg_unit_n011_0113
			set thistype.m_tobias = gg_unit_n01C_0064
			set thistype.m_trommon = gg_unit_n021_0004
			set thistype.m_ursula = gg_unit_n01U_0203
			set thistype.m_wieland = gg_unit_n01Y_0006
			set thistype.m_wigberht = gg_unit_H01C_0228
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
	endstruct

endlibrary
/// Necromancer
library StructSpellsSpellDamnedGround requires Asl, StructGameClasses, StructGameSpell

	struct SpellDamnedGroundBuffData
		private SpellDamnedGround m_spell
		private timer m_timer
		private real m_x
		private real m_y
		public static constant integer width = 2 * R2I(bj_CELLWIDTH)
		public static constant integer height = 2 * R2I(bj_CELLWIDTH)
		private static constant integer maxTilepoints = 2 * R2I(bj_CELLWIDTH) * 2 * R2I(bj_CELLWIDTH)
		private boolean array m_damned[thistype.maxTilepoints]
		private integer array m_terrainType[thistype.maxTilepoints]
		private integer array m_terrainVariance[thistype.maxTilepoints]

		private method remove takes nothing returns nothing
			local integer i
			local integer j
			local integer index
			local real x
			local real y

			set i = 0
			loop
				exitwhen (i >= thistype.width)
				set j = 0
				loop
					exitwhen (j >= thistype.height)
					set x = this.m_x + i
					set y = this.m_y + j
					set index = Index2D(i, j, thistype.height)
					if (this.m_damned[index]) then
						call SetBlightPoint(this.m_spell.character().player(), x, y, false)
						call SetTerrainType(x, y, this.m_terrainType[index], this.m_terrainVariance[index], 1, 1)
					endif
					set j = j + R2I(bj_CELLWIDTH)
				endloop

				set i = i + R2I(bj_CELLWIDTH)
			endloop
		endmethod

		private static method timerFunctionRemove takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetExpiredTimer(), 0))
			call this.destroy()
		endmethod

		public method start takes real time returns nothing
			call TimerStart(this.m_timer, time, false, function thistype.timerFunctionRemove)
		endmethod

		public static method create takes SpellDamnedGround spell, real x, real y returns thistype
			local thistype this = thistype.allocate()
			local integer i
			local integer j
			local integer index
			set this.m_spell = spell
			set this.m_timer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_timer, 0, this)
			set this.m_x = x
			set this.m_y = y

			set i = 0
			loop
				exitwhen (i >= thistype.width)
				set j = 0
				loop
					exitwhen (j >= thistype.height)
					set x = this.m_x + i
					set y = this.m_y + j
					if (not IsPointBlighted(x, y)) then
						set index = Index2D(i, j, thistype.height)
						set this.m_damned[index] = true
						set this.m_terrainType[index] = GetTerrainType(x, y)
						set this.m_terrainVariance[index] = GetTerrainVariance(x, y)
						call SetBlightPoint(this.m_spell.character().player(), x, y, true)
					endif
					set j = j + R2I(bj_CELLWIDTH)
				endloop

				set i = i + R2I(bj_CELLWIDTH)
			endloop

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call PauseTimer(this.m_timer)
			call DmdfHashTable.global().destroyTimer(this.m_timer)
			set this.m_timer = null
			call this.remove()
		endmethod
	endstruct

	// TODO make it timed
	// TODO store the former terrain type to reset it.
	struct SpellDamnedGround extends Spell
		public static constant integer abilityId = 'A1AB'
		public static constant integer favouriteAbilityId = 'A1A8'
		public static constant integer classSelectionAbilityId = 'A1JV'
		public static constant integer classSelectionGrimoireAbilityId = 'A1JW'
		public static constant integer maxLevel = 5
		public static constant real time = 5.0

		private method action takes nothing returns nothing
			local SpellDamnedGroundBuffData spellBuff = 0
			if (not IsPointBlighted(GetSpellTargetX(), GetSpellTargetY())) then
				set spellBuff = SpellDamnedGroundBuffData.create(this, GetSpellTargetX(), GetSpellTargetY())
				call spellBuff.start(thistype.time * this.level())
			endif
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Classes.dragonSlayer(), Spell.spellTypeNormal, thistype.maxLevel, thistype.abilityId, thistype.favouriteAbilityId, 0, 0, thistype.action)
			call this.addGrimoireEntry('A1JV', 'A1JW')
			call this.addGrimoireEntry('A1A9', 'A1AA')
			call this.addGrimoireEntry('A1HN', 'A1HS')
			call this.addGrimoireEntry('A1HO', 'A1AT')
			call this.addGrimoireEntry('A1HP', 'A1AU')
			call this.addGrimoireEntry('A1HQ', 'A1HV')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
		endmethod
	endstruct

endlibrary
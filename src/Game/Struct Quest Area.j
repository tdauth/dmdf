library StructGameQuestArea requires Asl, StructGameCharacter, StructGameDmdfHashTable

	struct QuestArea
		private fogmodifier array m_assemblyPointFogModifier[6]
		private destructable array m_assemblyPointMarker[4]
		private rect m_rect
		private trigger m_enterTrigger
		
		public stub method onCheck takes nothing returns boolean
			return true
		endmethod
		
		public stub method onStart takes nothing returns nothing
		endmethod
		
		private method cleanupRect takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				call DestroyFogModifier(this.m_assemblyPointFogModifier[i])
				set this.m_assemblyPointFogModifier[i] = null
				set i = i + 1
			endloop
			set i = 0
			loop
				exitwhen (i == 4)
				call RemoveDestructable(this.m_assemblyPointMarker[i])
				set this.m_assemblyPointMarker[i] = null
				set i = i + 1
			endloop
		endmethod

		private static method triggerConditionEnter takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			local integer i
			local integer charactersCount
			if (ACharacter.isUnitCharacter(GetTriggerUnit()) and this.onCheck.evaluate()) then
				set i = 0
				set charactersCount = 0
				loop
					exitwhen (i == MapData.maxPlayers)
					if (ACharacter.playerCharacter(Player(i)) != 0 and RectContainsUnit(this.m_rect, ACharacter.playerCharacter(Player(i)).unit()) and  ACharacter.playerCharacter(Player(i)).isMovable()) then
						set charactersCount = charactersCount + 1
					endif
					set i = i + 1
				endloop
				call Character.displayHintToAll(Format(tr("%1%/%2% Charakteren bereit.")).i(charactersCount).i(ACharacter.countAll()).result())
				
				return charactersCount == ACharacter.countAll()
			endif
			return false
		endmethod

		private static method triggerActionEnter takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this")
			call this.cleanupRect()
			call DisableTrigger(GetTriggeringTrigger())
			call this.onStart.execute()
		endmethod
		
		public static method create takes rect whichRect returns thistype
			local thistype this = thistype.allocate()
			local integer i
			local real leftX
			local real leftY
			local real rightX
			local real rightY
			local real topX
			local real topY
			local real bottomX
			local real bottomY
			set this.m_rect = whichRect
			// create a visible effect on the map that it is easier to find the rect
			set i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				set this.m_assemblyPointFogModifier[i] = CreateFogModifierRect(Player(i), FOG_OF_WAR_VISIBLE, this.m_rect, true, true)
				call FogModifierStart(this.m_assemblyPointFogModifier[i])
				set i = i + 1
			endloop
			
			set leftX = GetRectMinX(this.m_rect)
			set leftY = GetRectCenterY(this.m_rect)
			set rightX = GetRectMaxX(this.m_rect)
			set rightY = GetRectCenterY(this.m_rect)
			set topX = GetRectCenterX(this.m_rect)
			set topY = GetRectMaxY(this.m_rect)
			set bottomX = GetRectCenterX(this.m_rect)
			set bottomY = GetRectMinY(this.m_rect)
			
			set this.m_assemblyPointMarker[0] = CreateDestructable('B00N', rightX, rightY, 0.0, 1.0,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[0], true)
			set this.m_assemblyPointMarker[1] = CreateDestructable('B00N', leftX, leftY, 0.0, 1.0,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[1], true)
			set this.m_assemblyPointMarker[2] = CreateDestructable('B00N', topX, topY, 90.0, 1.0,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[2], true)
			set this.m_assemblyPointMarker[3] = CreateDestructable('B00N', bottomX, bottomY, 90.0, 1.0,  0)
			call SetDestructableInvulnerable(this.m_assemblyPointMarker[3], true)
			
			set this.m_enterTrigger = CreateTrigger()
			call TriggerRegisterEnterRectSimple(this.m_enterTrigger, this.m_rect)
			call TriggerAddCondition(this.m_enterTrigger, Condition(function thistype.triggerConditionEnter))
			call TriggerAddAction(this.m_enterTrigger, function thistype.triggerActionEnter)
			call DmdfHashTable.global().setHandleInteger(this.m_enterTrigger, "this", this)
			
			return this
		endmethod
		
		public method onDestroy takes nothing returns nothing
			call this.cleanupRect()
			set this.m_rect = null
			call DmdfHashTable.global().destroyTrigger(this.m_enterTrigger)
			set this.m_enterTrigger = null
		endmethod
	endstruct
	
endlibrary
library StructMapMapFerryBoat requires Asl, StructMapMapNpcs, StructMapTalksTalkTrommon

	/**
	* Während die Fähre fährt, ist das Gespräch Trommons deaktiviert.
	* Der Charakter muss sich um die bestimmte Uhrzeit in das Gebiet der Fähre begeben.
	* Ist die Fähre da, so erhält er per Dialog die Möglichkeit ihr beizutreten (auch wenn er sich schon im Gebiet befindet).
	* Kuno wird per Tagesablauf stets auf die Fähre befördert.
	* Die Fahrtzeiten hängen auch von Trommons Gesprächen ab!
	* @todo Geschwindigkeit und Ablauf testen.
	* @todo Sicherstellen, dass Trommon zur Fähre läuft und am anderen Ufer wartet.
	* @todo Kuno hinzufügen.
	* @todo Ton hinzufügen, Trommon sagt "Die Fähre legt ab!".
	*/
	struct FerryBoat
		public static constant integer movementNone = 0
		public static constant integer movementForward = 1
		public static constant integer movementBackward = 2
		private static constant real waitTime = 5.0
		// can not change facing angle
		//static start members
		private static unit m_boat
		private static real m_sizeX
		private static real m_sizeY
		private static real m_refreshRate
		private static real m_speed
		private static real m_forwardTime
		private static rect m_forwardEndRect
		private static rect m_forwardTerrainRect
		private static real m_backwardTime
		private static rect m_backwardEndRect
		private static rect m_backwardTerrainRect
		//static members
		private static AGroup m_selectionGroup
		private static AGroup m_units
		private static integer m_movement
		private static timer m_movementTimer
		private static trigger m_forwardTrigger
		private static trigger m_backwardTrigger

		//! runtextmacro optional A_STRUCT_DEBUG("\"FerryBoat\"")

		public static method addUnit takes unit whichUnit returns nothing
			call PauseUnit(whichUnit, true)
			call SetUnitInvulnerable(whichUnit, true)
			call SetUnitPathing(whichUnit, false)
			/// @todo Set to random location on boat.
			call SetUnitX(whichUnit, GetUnitX(thistype.m_boat))
			call SetUnitY(whichUnit, GetUnitY(thistype.m_boat))
			call SetUnitFacing(whichUnit, GetRandomReal(0.0, 360.0))
			call thistype.m_units.units().pushBack(whichUnit)
		endmethod

		public static method addCharacter takes Character character returns nothing
			call character.displayMessage(Character.messageTypeInfo, tr("Sie betreten die Fähre."))
			call character.setMovable(false)
			call thistype.addUnit(character.unit())
		endmethod

		public static method containsUnit takes unit whichUnit returns boolean
			return thistype.m_units.units().contains(whichUnit)
		endmethod

		public static method containsCharacter takes Character character returns boolean
			return thistype.containsUnit(character.unit())
		endmethod

		public static method displayMessage takes string message, sound whichSound returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (IsPlayerPlayingUser(Player(i)) and thistype.m_units.hasUnitsOfPlayer(Player(i))) then
					call TransmissionFromUnitForPlayer(Player(i), gg_unit_n021_0004, message, whichSound)
				endif
				set i = i + 1
			endloop
		endmethod

		public static method setMovement takes integer movement returns nothing
static if (DEBUG_MODE) then
				if (movement == thistype.m_movement) then
					call thistype.staticPrint("Error, setting current movement.")

					return
				endif
endif

			if (movement == thistype.movementNone) then
				call PauseTimer(thistype.m_movementTimer)
			elseif (thistype.m_movement == thistype.movementNone and (movement == thistype.movementForward or movement == thistype.movementBackward)) then
				call ResumeTimer(thistype.m_movementTimer)
			endif

			set thistype.m_movement = movement
		endmethod

		private static method endMovement takes rect whichRect, real facing returns nothing
			local ACharacter character

			loop
				exitwhen (thistype.m_units.units().empty())
				call SetUnitX(thistype.m_units.units().back(), GetRectCenterX(whichRect))
				call SetUnitY(thistype.m_units.units().back(), GetRectCenterY(whichRect))
				call SetUnitFacing(thistype.m_units.units().back(), facing)
				call PauseUnit(thistype.m_units.units().back(), false)
				call SetUnitInvulnerable(thistype.m_units.units().back(), false)
				call SetUnitPathing(thistype.m_units.units().back(), true)
				set character = ACharacter.getCharacterByUnit(thistype.m_units.units().back())

				if (character != 0) then
					call character.setMovable(true)
					call character.displayMessage(ACharacter.messageTypeInfo, tr("Sie verlassen die Fähre."))
				endif

				call thistype.m_units.units().popBack()
			endloop
		endmethod

		private static method timerFunctionMove takes nothing returns nothing
			local integer i
			local real angle
			local rect endRect
			local rect terrainRect

			if (thistype.m_movement == thistype.movementForward) then
				set angle = 0.0
				set endRect = thistype.m_forwardEndRect
				set terrainRect = thistype.m_forwardTerrainRect
			else
				set angle = 180.0
				set endRect = thistype.m_backwardEndRect
				set terrainRect = thistype.m_backwardTerrainRect
			endif

			call SetUnitPosition(thistype.m_boat, GetUnitPolarProjectionX(thistype.m_boat, angle, thistype.m_speed), GetUnitPolarProjectionY(thistype.m_boat, angle, thistype.m_speed))

			set i = 0
			loop
				exitwhen (i == thistype.m_units.units().size())
				call SetUnitPosition(thistype.m_units.units()[i], GetUnitPolarProjectionX(thistype.m_units.units()[i], angle, thistype.m_speed), GetUnitPolarProjectionY(thistype.m_units.units()[i], angle, thistype.m_speed))
				set i = i + 1
			endloop

			if (RectContainsUnit(endRect, thistype.m_boat)) then
				call thistype.setMovement(thistype.movementNone)
				call thistype.endMovement(terrainRect, angle)
			endif

			set endRect = null
			set terrainRect = null
		endmethod

		private static method filterIsCharacter takes nothing returns boolean
			return ACharacter.isUnitCharacter(GetEnumUnit()) and TalkTrommon.talk().playerHasPaid(GetOwningPlayer(GetEnumUnit()))
		endmethod

		private static method buttonFunctionEnterFerry takes ADialogButton dialogButton returns nothing
			local ACharacter character = ACharacter.playerCharacter(dialogButton.dialog().player())
			if (thistype.m_selectionGroup.units().contains(character.unit())) then
				call thistype.addCharacter.evaluate(character)
			else
				call character.displayMessage(ACharacter.messageTypeError, tr("Die Fähre hat bereits abgelegt."))
			endif
		endmethod

		private static method startMovement takes integer movement, rect terrainRect, rect endRect, real endTime returns nothing
			local filterfunc filter
			local group whichGroup
			local real startTime = GetTimeOfDay()
			local boolean tooLate = false
			local integer j
			debug call Print("Waiting for Trommon and ferry boat in rects.")
			loop
				exitwhen ((RectContainsUnit(terrainRect, Npcs.trommon()) and RectContainsUnit(endRect, thistype.m_boat)) or tooLate)
				call TriggerSleepAction(1.0)
				if (endTime < startTime) then // other movement starts
					set tooLate = not (GetTimeOfDay() >= startTime or GetTimeOfDay() <= startTime)
				else
					set tooLate = not (GetTimeOfDay() >= startTime and GetTimeOfDay() <= endTime)
				endif
			endloop

			if (tooLate) then /// @todo If X seconds elapsed cancel call (next trigger call)
				debug call Print("Too late for ferry boat!")
				return
			endif

			call thistype.addUnit(Npcs.trommon())
			set filter = Filter(function thistype.filterIsCharacter)
			set whichGroup = CreateGroup()
			call GroupEnumUnitsInRect(whichGroup, terrainRect, filter)
			call DestroyFilter(filter)
			set filter = null
			call thistype.m_selectionGroup.addGroup(whichGroup, true, false)
			set whichGroup = null

			set j = 0
			loop
				exitwhen (j == thistype.m_selectionGroup.units().size())
				call AGui.playerGui(GetOwningPlayer(thistype.m_selectionGroup.units()[j])).dialog().clear()
				call AGui.playerGui(GetOwningPlayer(thistype.m_selectionGroup.units()[j])).dialog().setMessage(RealWidthArg(tr("Fähre betreten?\nSie haben %i Sekunden zur Auswahl."), thistype.waitTime, 4, 2))
				call AGui.playerGui(GetOwningPlayer(thistype.m_selectionGroup.units()[j])).dialog().addDialogButton(tr("Ja"), 'J', thistype.buttonFunctionEnterFerry)
				call AGui.playerGui(GetOwningPlayer(thistype.m_selectionGroup.units()[j])).dialog().addDialogButton(tr("Nein"), 'N', 0)
				call AGui.playerGui(GetOwningPlayer(thistype.m_selectionGroup.units()[j])).dialog().show()
				set j = j + 1
			endloop

			call TriggerSleepAction(thistype.waitTime)
			call thistype.m_selectionGroup.units().clear()
			call thistype.displayMessage(tr("Die Fähre legt ab."), null) /// @todo Sound
			call thistype.setMovement(movement)
		endmethod

		private static method triggerActionStartForward takes nothing returns nothing
			debug call Print("Ferry boat starts forward")
			call thistype.startMovement(thistype.movementForward, thistype.m_forwardTerrainRect, thistype.m_forwardEndRect, thistype.m_backwardTime)
		endmethod

		private static method triggerActionStartBackward takes nothing returns nothing
			debug call Print("Ferry boat starts backward")
			call thistype.startMovement(thistype.movementBackward, thistype.m_backwardTerrainRect, thistype.m_backwardEndRect, thistype.m_forwardTime)
		endmethod

		public static method init takes unit boat, real sizeX, real sizeY, real refreshRate, real speed, real forwardTime, rect forwardEndRect, rect forwardTerrainRect, real backwardTime, rect backwardEndRect, rect backwardTerrainRect returns nothing
			//static start members
			set thistype.m_boat = boat
			set thistype.m_sizeX = sizeX
			set thistype.m_sizeY = sizeY
			set thistype.m_refreshRate = refreshRate
			set thistype.m_speed = speed * refreshRate
			set thistype.m_forwardTime = forwardTime
			set thistype.m_forwardEndRect = forwardEndRect
			set thistype.m_forwardTerrainRect = forwardTerrainRect
			set thistype.m_backwardTime = backwardTime
			set thistype.m_backwardEndRect = backwardEndRect
			set thistype.m_backwardTerrainRect = backwardTerrainRect
			//static members
			set thistype.m_selectionGroup = AGroup.create()
			set thistype.m_units = AGroup.create()
			set thistype.m_movement = thistype.movementNone
			set thistype.m_movementTimer = CreateTimer()
			call TimerStart(thistype.m_movementTimer, thistype.m_refreshRate, true, function thistype.timerFunctionMove)
			call PauseTimer(thistype.m_movementTimer)
			set thistype.m_forwardTrigger = CreateTrigger()
			call TriggerRegisterGameStateEvent(thistype.m_forwardTrigger, GAME_STATE_TIME_OF_DAY, EQUAL, thistype.m_forwardTime)
			call TriggerAddAction(thistype.m_forwardTrigger, function thistype.triggerActionStartForward)
			set thistype.m_backwardTrigger = CreateTrigger()
			call TriggerRegisterGameStateEvent(thistype.m_backwardTrigger, GAME_STATE_TIME_OF_DAY, EQUAL, thistype.m_backwardTime)
			call TriggerAddAction(thistype.m_backwardTrigger, function thistype.triggerActionStartBackward)
		endmethod
	endstruct

endlibrary
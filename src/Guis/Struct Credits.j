library StructGuisCredits requires Asl, StructGameCharacter, StructGuisMainWindow, StructMapMapMapData

	private struct Contributor
		private boolean m_isTitle
		private string m_name
		private string m_description
		private AStringVector m_files
		
		public method isTitle takes nothing returns boolean
			return this.m_isTitle
		endmethod

		public method name takes nothing returns string
			return this.m_name
		endmethod

		public method description takes nothing returns string
			return this.m_description
		endmethod

		public method files takes nothing returns AStringVector
			return this.m_files
		endmethod

		public static method create takes boolean isTitle, string name, string description returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_isTitle = isTitle
			set this.m_name = name
			set this.m_description = description
			// members
			set this.m_files = AStringVector.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call this.m_files.destroy()
		endmethod
	endstruct

	struct Credits extends MainWindow
		// static members
		private static AIntegerVector m_contributors
		// members
		private integer m_currentContributor
		private timer m_viewTimer
		private timer m_autoChangeTimer
		
		public static method addTitle takes string name returns nothing
			call thistype.m_contributors.pushBack(Contributor.create(true, name, ""))
		endmethod

		public static method addContributor takes string name, string description returns nothing
			call thistype.m_contributors.pushBack(Contributor.create(false, name, description))
		endmethod
		
		public static method contributorIsTitle takes integer index returns boolean
			return Contributor(thistype.m_contributors[index]).isTitle()
		endmethod

		public static method contributorName takes integer index returns string
			return Contributor(thistype.m_contributors[index]).name()
		endmethod

		public static method contributorDescription takes integer index returns string
			return Contributor(thistype.m_contributors[index]).description()
		endmethod

		public static method contributors takes nothing returns integer
			return thistype.m_contributors.size()
		endmethod

		public static method addFile takes string filePath returns nothing
			call Contributor(thistype.m_contributors.back()).files().pushBack(filePath)
		endmethod

		/**
		 * \return Returns view centre x.
		 */
		public static method viewX takes nothing returns real
			return CameraSetupGetDestPositionX(gg_cam_class_selection)
		endmethod

		/**
		 * \return Returns view centre y.
		 */
		public static method viewY takes nothing returns real
			return CameraSetupGetDestPositionY(gg_cam_class_selection)
		endmethod
		
		private static method showMovingTextTag takes string text, real size, integer red, integer green, integer blue, integer alpha, player whichPlayer returns nothing
			local texttag textTag = CreateTextTag()
			call SetTextTagText(textTag, text, 0.023)
			call SetTextTagPos(textTag, GetRectCenterX(gg_rct_class_selection), GetRectCenterY(gg_rct_class_selection), CameraSetupGetField(gg_cam_class_selection, CAMERA_FIELD_ZOFFSET))
			call SetTextTagColor(textTag, red, green, blue, alpha)
			call SetTextTagVisibility(textTag, true)
			call SetTextTagVelocity(textTag, 0.0, 0.020)
			call ShowTextTagForPlayer(whichPlayer, textTag, true)
			set textTag = null
		endmethod

		private method onPressShortcutActionRight takes nothing returns nothing
			debug call Print("Right shortcut")
			call this.showNextContributor.evaluate()
		endmethod

		private method onPressShortcutActionLeft takes nothing returns nothing
			debug call Print("Left shortcut")
			call this.showPreviousContributor.evaluate()
		endmethod
		
		private static method timerFunctionAutoChange takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = DmdfHashTable.global().handleInteger(expiredTimer, "this")
			call this.showNextContributor.evaluate()
			set expiredTimer = null
		endmethod

		private static method timerFunctionView takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = DmdfHashTable.global().handleInteger(expiredTimer, "this")
			call CameraSetupApplyForPlayer(true, gg_cam_class_selection, this.gui().player(), 0.0)
			set expiredTimer = null
		endmethod

		public stub method onShow takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			call super.onShow()
			call this.gui().setOnPressShortcutAction(AGui.shortcutArrowRightDown, thistype.onPressShortcutActionRight, this)
			call this.gui().setOnPressShortcutAction(AGui.shortcutArrowLeftDown, thistype.onPressShortcutActionLeft, this)
			call this.showContributor.evaluate(this.m_currentContributor)
			call MapData.setCameraBoundsToMapForPlayer(whichPlayer)
			call TimerStart(this.m_viewTimer, 0.01, true, function thistype.timerFunctionView)
			call TimerStart(this.m_autoChangeTimer, 4.0, false, function thistype.timerFunctionAutoChange)
			call Game.setMapMusicForPlayer(whichPlayer, "Music\\Credits.mp3")
			set whichPlayer = null
		endmethod

		public stub method onHide takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			call PauseTimer(this.m_viewTimer)
			call PauseTimer(this.m_autoChangeTimer)
			call super.onHide()
			call Game.setDefaultMapMusicForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod
		
		private method showContributor takes integer contributorIndex returns nothing
			local Contributor contributor
			local string text
			local integer i
			local real fontSize = 16.0
			if (contributorIndex >= thistype.m_contributors.size()) then
				set contributorIndex = 0
			elseif (contributorIndex < 0) then
				set contributorIndex = thistype.m_contributors.backIndex()
			endif
			set contributor = Contributor(this.m_contributors[contributorIndex])

			if (contributor.isTitle()) then
				set fontSize = 20.0
				set text = contributor.name()
			else
				set text = Format(tr("%1%\n%2%\n")).s(contributor.name()).s(contributor.description()).result()
			endif

			set i = 0
			loop
				exitwhen (i == contributor.files().size())
				set text = Format(tr("%1%* %2%\n")).s(text).s(contributor.files()[i]).result()
				set i = i + 1
			endloop

			if (contributor.isTitle()) then
				call thistype.showMovingTextTag(text, fontSize, 255, 0, 0, 0, this.gui().player())
			else
				call thistype.showMovingTextTag(text, fontSize, 255, 255, 255, 0, this.gui().player())
			endif
			
			set this.m_currentContributor = contributorIndex
			
			/*
			 * Restart auto change timer.
			 */
			call TimerStart(this.m_autoChangeTimer, 4.0, false, function thistype.timerFunctionAutoChange)
		endmethod
		
		public method showNextContributor takes nothing returns nothing
			call this.showContributor(this.m_currentContributor + 1)
		endmethod
		
		public method showPreviousContributor takes nothing returns nothing
			call this.showContributor(this.m_currentContributor - 1)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, gg_rct_main_window_credits)
			// members
			set this.m_currentContributor = 0
			set this.m_viewTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_viewTimer, "this", this)
			set this.m_autoChangeTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_autoChangeTimer, "this", this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call PauseTimer(this.m_viewTimer)
			call DmdfHashTable.global().destroyTimer(this.m_viewTimer)
			call PauseTimer(this.m_autoChangeTimer)
			call DmdfHashTable.global().destroyTimer(this.m_autoChangeTimer)
			set this.m_viewTimer = null
			set this.m_autoChangeTimer = null
		endmethod

		public static method init0 takes nothing returns nothing
			//static members
			set thistype.m_contributors = AIntegerVector.create()
		endmethod
	endstruct

endlibrary
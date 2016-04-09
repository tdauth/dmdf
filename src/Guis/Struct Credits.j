library StructGuisCredits requires Asl, StructGameCharacter, StructGuisMainWindow

	private struct Style extends AStyle
		private static Style m_style
	
		private static method create takes nothing returns thistype
			local thistype this = thistype.allocate()
			call this.setFrameTopImageFilePath(null)
			call this.setFrameBottomImageFilePath(null)
			call this.setFrameLeftImageFilePath(null)
			call this.setFrameRightImageFilePath(null)
			return this
		endmethod
		
		public static method style takes nothing returns thistype
			return thistype.m_style
		endmethod
		
		private static method onInit takes nothing returns nothing
			set thistype.m_style = thistype.create()
		endmethod
	endstruct

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

	/**
	 * \brief The Credits GUI is placed at the class selection and shows all contributors of the project using floating text tags.
	 * All contributors have to be added in the file "src/Game/Credits.j" which is imported and adds all contributors to a global list.
	 */
	struct Credits extends MainWindow
		public static constant real viewTimeout = 0.01
		public static constant real defaultVelocity = 0.040
		// static members
		private static AIntegerVector m_contributors
		// members
		private integer m_currentContributor
		private timer m_viewTimer
		private timer m_autoChangeTimer
		private ATextTagVector m_textTags
		private real m_velocity
		
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
		
		private static method showMovingTextTag takes string text, real size, integer red, integer green, integer blue, integer alpha, real velocity, player whichPlayer returns texttag
			local texttag textTag = CreateTextTag()
			call SetTextTagText(textTag, text, 0.023)
			call SetTextTagPos(textTag, GetRectCenterX(gg_rct_main_window_credits), GetRectCenterY(gg_rct_main_window_credits), CameraSetupGetField(gg_cam_class_selection, CAMERA_FIELD_ZOFFSET))
			call SetTextTagColor(textTag, red, green, blue, alpha)
			call SetTextTagVisibility(textTag, false)
			call SetTextTagVelocity(textTag, 0.0, velocity)
			call ShowTextTagForPlayer(whichPlayer, textTag, true)
			return textTag
		endmethod

		private method onPressShortcutIncreaseSpeed takes nothing returns nothing
			local integer i
			debug call Print("Up shortcut")
			set this.m_velocity = RMinBJ(this.m_velocity + thistype.defaultVelocity, 1.0)
			set i = 0
			loop
				exitwhen (i == this.m_textTags.size())
				call SetTextTagVelocity(this.m_textTags[i], 0.0, this.m_velocity)
				set i = i + 1
			endloop
		endmethod

		private method onPressShortcutDecreaseSpeed takes nothing returns nothing
			local integer i
			debug call Print("Down shortcut")
			set this.m_velocity = RMaxBJ(this.m_velocity - thistype.defaultVelocity, 0.0)
			set i = 0
			loop
				exitwhen (i == this.m_textTags.size())
				call SetTextTagVelocity(this.m_textTags[i], 0.0, this.m_velocity)
				set i = i + 1
			endloop
		endmethod
		
		private static method timerFunctionAutoChange takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = DmdfHashTable.global().handleInteger(expiredTimer, 0)
			call this.showNextContributor.evaluate()
			set expiredTimer = null
		endmethod

		private static method timerFunctionView takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = DmdfHashTable.global().handleInteger(expiredTimer, 0)
			call CameraSetupApplyForPlayer(true, gg_cam_class_selection, this.gui().player(), thistype.viewTimeout)
			set expiredTimer = null
		endmethod

		public stub method onShow takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			call super.onShow()
			// these two shortcuts allow changing the speed of the credits which can be useful if the user wants to skip some of them
			call this.gui().setOnPressShortcutAction(AGui.shortcutArrowUpDown, thistype.onPressShortcutIncreaseSpeed, this)
			call this.gui().setOnPressShortcutAction(AGui.shortcutArrowDownDown, thistype.onPressShortcutDecreaseSpeed, this)
			set this.m_currentContributor = 0 // restart with first
			call this.showContributor.evaluate(this.m_currentContributor)
			call TimerStart(this.m_viewTimer, thistype.viewTimeout, true, function thistype.timerFunctionView)
			call TimerStart(this.m_autoChangeTimer, 4.0, false, function thistype.timerFunctionAutoChange)
			call StopMusicForPlayer(whichPlayer, false)
			call PlayMusicForPlayer(whichPlayer, "Music\\Credits.mp3")
			set whichPlayer = null
		endmethod

		public stub method onHide takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			call PauseTimer(this.m_viewTimer)
			call PauseTimer(this.m_autoChangeTimer)
			// reset velocity and clear spawned texttags which have been destroyed automatically in the meantime
			call this.m_textTags.clear()
			set this.m_velocity = thistype.defaultVelocity
			call super.onHide()
			call StopMusicForPlayer(whichPlayer, false)
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
				set text = Format(tr("%1%\n%2%\n")).s(contributor.description()).s(contributor.name()).result()
			endif

			set i = 0
			loop
				exitwhen (i == contributor.files().size())
				set text = Format(tr("%1%* %2%\n")).s(text).s(contributor.files()[i]).result()
				set i = i + 1
			endloop

			if (contributor.isTitle()) then
				call this.m_textTags.pushBack(thistype.showMovingTextTag(text, fontSize, 255, 0, 0, 0, this.m_velocity, this.gui().player()))
			else
				call this.m_textTags.pushBack(thistype.showMovingTextTag(text, fontSize, 255, 255, 255, 0, this.m_velocity, this.gui().player()))
			endif
			
			set this.m_currentContributor = contributorIndex
			
			/*
			 * Restart auto change timer.
			 */
			call PauseTimer(this.m_autoChangeTimer)
			call TimerStart(this.m_autoChangeTimer, 2.0, false, function thistype.timerFunctionAutoChange)
		endmethod
		
		public method showNextContributor takes nothing returns nothing
			call this.showContributor(this.m_currentContributor + 1)
		endmethod
		
		public method showPreviousContributor takes nothing returns nothing
			call this.showContributor(this.m_currentContributor - 1)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, Style.style(), gg_rct_main_window_credits)
			// members
			set this.m_currentContributor = 0
			set this.m_textTags = ATextTagVector.create()
			set this.m_velocity = thistype.defaultVelocity
			set this.m_viewTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_viewTimer, 0, this)
			set this.m_autoChangeTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_autoChangeTimer, 0, this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_textTags.destroy()
			call PauseTimer(this.m_viewTimer)
			call DmdfHashTable.global().destroyTimer(this.m_viewTimer)
			call PauseTimer(this.m_autoChangeTimer)
			call DmdfHashTable.global().destroyTimer(this.m_autoChangeTimer)
			set this.m_viewTimer = null
			set this.m_autoChangeTimer = null
		endmethod

		public static method onInit takes nothing returns nothing
			// static members
			set thistype.m_contributors = AIntegerVector.create()
			// this file adds all contributors to the credits
			//! import "Game/Credits.j"
		endmethod
	endstruct

endlibrary
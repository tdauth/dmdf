library StructGuisCredits requires Asl, StructGameCharacter, StructGuisMainWindow, StructMapMapMapData

	private struct Contributor
		private string m_name
		private string m_description
		private AStringVector m_files

		public method name takes nothing returns string
			return this.m_name
		endmethod

		public method description takes nothing returns string
			return this.m_description
		endmethod

		public method files takes nothing returns AStringVector
			return this.m_files
		endmethod

		public static method create takes string name, string description returns thistype
			local thistype this = thistype.allocate()
			// construction members
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
		private texttag m_titleTextTag
		private texttag m_headlineTextTag
		private texttag m_contributorTextTag
		private integer m_currentContributor
		private timer m_viewTimer

		public static method addContributor takes string name, string description returns nothing
			call thistype.m_contributors.pushBack(Contributor.create(name, description))
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

		private method showContributor takes integer contributorIndex returns nothing
			local Contributor contributor
			local string text
			local integer i
			if (contributorIndex >= thistype.m_contributors.size()) then
				set contributorIndex = 0
			elseif (contributorIndex < 0) then
				set contributorIndex = thistype.m_contributors.backIndex()
			endif
			set contributor = Contributor(this.m_contributors[contributorIndex])
			//debug call Print("1 with contributor " + I2S(contributor))
			set text = Format(tr("%1%\n%2%\n")).s(contributor.name()).s(contributor.description()).result()
			//debug call Print("2")
			set i = 0
			loop
				exitwhen (i == contributor.files().size())
				set text = Format(tr("%1%* %2%\n")).s(text).s(contributor.files()[i]).result()
				set i = i + 1
			endloop
			//debug call Print("Handle id: " + I2S(GetHandleId(this.m_contributorTextTag)))
			//debug call Print("3 with text " + text)
			call SetTextTagTextBJ(this.m_contributorTextTag, text, 16.0)
			//call ShowTextTagForPlayer(this.gui().player(), this.m_contributorTextTag, true) // test!!!
			//debug call Print("4")
			set this.m_currentContributor = contributorIndex
		endmethod

		private method onPressShortcutActionRight takes nothing returns nothing
			debug call Print("Right shortcut")
			call this.showContributor(this.m_currentContributor + 1)
		endmethod

		private method onPressShortcutActionLeft takes nothing returns nothing
			debug call Print("Left shortcut")
			call this.showContributor(this.m_currentContributor - 1)
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
			call ShowTextTagForPlayer(whichPlayer, this.m_titleTextTag, true)
			call ShowTextTagForPlayer(whichPlayer, this.m_headlineTextTag, true)
			call ShowTextTagForPlayer(whichPlayer, this.m_contributorTextTag, true)
			call this.showContributor(this.m_currentContributor)
			call MapData.setCameraBoundsToMapForPlayer(whichPlayer)
			call TimerStart(this.m_viewTimer, 0.01, true, function thistype.timerFunctionView)
			call Game.setMapMusicForPlayer(whichPlayer, "Music\\Credits.mp3")
			set whichPlayer = null
		endmethod

		public stub method onHide takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			call ShowTextTagForPlayer(whichPlayer, this.m_titleTextTag, false)
			call ShowTextTagForPlayer(whichPlayer, this.m_headlineTextTag, false)
			call ShowTextTagForPlayer(whichPlayer, this.m_contributorTextTag, false)
			call PauseTimer(this.m_viewTimer)
			call super.onHide()
			call Game.setDefaultMapMusicForPlayer(whichPlayer)
			set whichPlayer = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, gg_rct_main_window_credits)
			// members
			set this.m_titleTextTag = CreateTextTag()
			call SetTextTagColor(this.m_titleTextTag, 255, 0, 0, 0)
			call SetTextTagPos(this.m_titleTextTag, thistype.viewX() - 150.0, thistype.viewY() + 150.0, 0.0)
			call SetTextTagVisibility(this.m_titleTextTag, false)
			call SetTextTagTextBJ(this.m_titleTextTag, tr("Die Macht des Feuers"), 16.0)

			set this.m_headlineTextTag = CreateTextTag()
			call SetTextTagColor(this.m_headlineTextTag, 91, 9, 255, 0)
			call SetTextTagPos(this.m_headlineTextTag, thistype.viewX() - 150.0, thistype.viewY() + 50.0, 0.0)
			call SetTextTagVisibility(this.m_headlineTextTag, false)
			call SetTextTagTextBJ(this.m_headlineTextTag, tr("Mitwirkende"), 16.0)

			set this.m_contributorTextTag = CreateTextTag()
			call SetTextTagColor(this.m_contributorTextTag, 96, 133, 255, 0)
			call SetTextTagPos(this.m_contributorTextTag, thistype.viewX() - 150.0, thistype.viewY() - 100, 0.0)
			call SetTextTagVisibility(this.m_contributorTextTag, false)
			call SetTextTagTextBJ(this.m_contributorTextTag, "", 16.0)

			set this.m_currentContributor = 0
			set this.m_viewTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_viewTimer, "this", this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DestroyTextTag(this.m_titleTextTag)
			set this.m_titleTextTag = null
			call DestroyTextTag(this.m_headlineTextTag)
			set this.m_headlineTextTag = null
			call DestroyTextTag(this.m_contributorTextTag)
			set this.m_contributorTextTag = null
			call PauseTimer(this.m_viewTimer)
			call DmdfHashTable.global().destroyTimer(this.m_viewTimer)
			set this.m_viewTimer = null
		endmethod

		public static method init0 takes nothing returns nothing
			//static members
			set thistype.m_contributors = AIntegerVector.create()
		endmethod
	endstruct

endlibrary
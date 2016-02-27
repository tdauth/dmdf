library StructGuisInfoLog requires Asl, StructGameCharacter, StructGuisMainWindow

	private struct EntryText extends AText
		public integer infoIndex
	endstruct

	private struct SpeechText extends AText
		public integer speechIndex
	endstruct

	/**
	 * \brief Lists all informations from all talks for a player.
	 * If a player cannot remember what an NPC said in a talk he can look it up in this GUI.
	*/
	struct InfoLog extends MainWindow
		private static constant integer entriesPerPage = 8
		// construction members
		private Character m_character
		// members
		private integer m_entryPage
		private AInfo m_selectedInfo
		private integer m_speechPage
		private AText m_headlineText
		private EntryText array m_entryText[8] /// @todo @member InfoLog.entriesPerPage
		private SpeechText array m_speechText[8] /// @todo @member InfoLog.entriesPerPage

		private method showEntryPage takes integer pageNumber returns nothing
			local integer index
			local string description
			local integer i = 0
			loop
				exitwhen (i == thistype.entriesPerPage)
				set index = i * (pageNumber + 1)
				if (index < this.m_character.talkLog().infos()) then
					if (this.m_character.talkLog().info(i).important()) then
						set description = tre("(Automatisch)", "(Automatically)")
					else
						set description = this.m_character.talkLog().info(i).description()
					endif
					call this.m_entryText[i].setTextAndSize(description, 10.0)
					call this.m_entryText[i].setTooltip(description)
					set this.m_entryText[i].infoIndex = index
				else
					call this.m_entryText[i].setTextAndSize(tr("-"), 10.0)
					call this.m_entryText[i].setTooltip(tr("-"))
					set this.m_entryText[i].infoIndex = -1
				endif
				set i = i + 1
			endloop
		endmethod

		private method showCurrentEntryPage takes nothing returns nothing
			call this.showEntryPage(this.m_entryPage)
		endmethod

		private method showEntrySpeechesAtPage takes integer pageNumber returns nothing
			local integer i = 0
			local integer index
			local string speechText
			loop
				exitwhen (i == thistype.entriesPerPage)
				set index = i * (pageNumber + 1)
				if (this.m_selectedInfo != 0 and index < this.m_character.talkLog().speeches(this.m_selectedInfo)) then
					if (this.m_character.talkLog().speechToCharacter(this.m_selectedInfo, index)) then
						set speechText = tr("NPC")
					else
						set speechText = tre("Charakter", "Character")
					endif
					// do not add speech text, too long (use tooltip only).
					//set speechText = speechText + this.m_character.talkLog().speechText(this.m_selectedInfo, index)
					call this.m_speechText[i].setTextAndSize(speechText, 10.0)
					call this.m_speechText[i].setTooltip(this.m_character.talkLog().speechText(this.m_selectedInfo, index))
					set this.m_speechText[i].speechIndex = index
				else
					call this.m_speechText[i].setTextAndSize("-", 10.0)
					call this.m_speechText[i].setTooltip("")
					set this.m_speechText[i].speechIndex = -1
				endif
				set i = i + 1
			endloop
			set this.m_speechPage = pageNumber
		endmethod

		private method showCurrentEntrySpeeches takes nothing returns nothing
			call this.showEntrySpeechesAtPage(this.m_speechPage)
		endmethod

		private method showEntry takes EntryText entryText returns nothing
			local integer i
			if (entryText.infoIndex != -1) then
				set this.m_selectedInfo = this.m_character.talkLog().info(entryText.infoIndex)
				call this.showEntrySpeechesAtPage(0)
			else
				set this.m_selectedInfo = 0
				set this.m_speechPage = 0
				set i = 0
				loop
					exitwhen (i == thistype.entriesPerPage)
					call this.m_speechText[i].setTextAndSize("-", 12.0)
					call this.m_speechText[i].setTooltip("")
					set this.m_speechText[i].speechIndex = -1
					set i = i + 1
				endloop
			endif
		endmethod

		private method playSpeechSound takes SpeechText speechText returns nothing
			if (this.m_character.talkLog().speechSound(this.m_selectedInfo, speechText.speechIndex) != null) then
				/// @todo Change and reset position
				call StartSound(this.m_character.talkLog().speechSound(this.m_selectedInfo, speechText.speechIndex))
				debug call Print("Play speech sound")
			endif
		endmethod

		public stub method onShow takes nothing returns nothing
			call super.onShow()
			debug call Print("Infos: " + I2S(this.m_character.talkLog().infos()))
			call this.showCurrentEntryPage()
			call this.showCurrentEntrySpeeches()
		endmethod

		public stub method onHide takes nothing returns nothing
			call super.onHide()
		endmethod

		private method refreshEntryWidgets takes nothing returns nothing
			//local integer i =
		endmethod

		private static method onTrackActionHeadline takes AText text returns nothing
		endmethod

		private static method onHitActionEntry takes EntryText entryText returns nothing
			call InfoLog(entryText.mainWindow()).showEntry(entryText)
		endmethod

		private static method onHitActionSpeech takes SpeechText speechText returns nothing
			if (speechText.speechIndex != -1) then
				call InfoLog(speechText.mainWindow()).playSpeechSound(speechText)
			endif
		endmethod

		private method createGui takes nothing returns nothing
			local integer i
			//call AImage.create("", this, 0.0, 0.0, 1000.0, 1000.0, 0, 0)
			set this.m_headlineText = AText.create(this, 200.0, 200.0, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", 0, thistype.onTrackActionHeadline)
			call this.m_headlineText.setTextAndSize(tre("Info-Log", "Info Log"), 12.0)
			set i = 0
			loop
				exitwhen (i == thistype.entriesPerPage)
				set this.m_entryText[i] = EntryText.create(this, 200.0, 250.0 + i * 150.0, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", thistype.onHitActionEntry, AWidget.onTrackActionShowTooltip)
				call this.m_entryText[i].setTooltip("")
				call this.m_entryText[i].setTooltipSize(12.0)
				set this.m_entryText[i].infoIndex = -1
				set this.m_speechText[i] = SpeechText.create(this, 1000.0, 250.0 + i * 150.0, 50.0, 50.0, "Units\\NightElf\\Wisp\\Wisp.mdx", thistype.onHitActionSpeech, AWidget.onTrackActionShowTooltip)
				call this.m_speechText[i].setTooltip("")
				call this.m_speechText[i].setTooltipSize(12.0)
				set this.m_speechText[i].speechIndex = -1
				set i = i + 1
			endloop
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, AStyle.human(), gg_rct_main_window_info_log)
			call this.setTooltipX(1100.0)
			call this.setTooltipY(300.0)
			//call this.setTooltipBackgroundImageFilePath("") /// @todo Set tooltip window, CRASHES GAME!
			// construction members
			set this.m_character = character
			// members
			set this.m_entryPage = 0
			set this.m_selectedInfo = 0
			set this.m_speechPage = 0

			call this.createGui()
			return this
		endmethod
	endstruct

endlibrary
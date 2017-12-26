library StructGuisMainWindow requires Asl, StructGameDungeon

	struct MainWindow extends AMainWindow
		private Character m_character
		private rect m_rect
		private boolean m_wasShownBefore

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public method rect takes nothing returns rect
			return this.m_rect
		endmethod

		private static method onHideActionHide takes AGui gui returns nothing
			call thistype(gui.shownMainWindow()).hide()
		endmethod

		public stub method onShowCheck takes nothing returns boolean
			return this.m_character.isMovable()
		endmethod

		/**
		 * Call this method instead of show() to take sure the camera is disabled before.
		 */
		public method showEx takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			local Character character = Character(Character.playerCharacter(whichPlayer))
			call ResetCameraBoundsToMapRectForPlayer(whichPlayer)
			call character.setCameraTimer(false)
			call this.show()
			set whichPlayer = null
		endmethod

		public stub method onShow takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			local Character character = Character(Character.playerCharacter(whichPlayer))
			// Allow everything as camera bounds. Otherwise the GUI rect is outside the bounds.
			call character.hideCharactersSchemeForPlayer()
			call character.setMovable(false)
			call this.gui().setOnPressShortcutAction(AGui.shortcutEscape, thistype.onHideActionHide, this)
			debug call Print("Rect Width: " + R2S(GetRectWidthBJ(this.rect())) + " Expected: 1280.0")
			debug call Print("Rect Height: " + R2S(GetRectHeightBJ(this.rect())) + " Expected: 960.0")
			if (not this.m_wasShownBefore) then
				set this.m_wasShownBefore = true
				call character.displayHint(tre("Drücken Sie Escape um diese Ansicht zu verlassen.", "Press Escape to leave this view."))
			endif
			set whichPlayer = null
		endmethod

		public stub method onHide takes nothing returns nothing
			local player whichPlayer = this.gui().player()
			local Character character = Character(Character.playerCharacter(whichPlayer))
			call character.setMovable(true)
			call character.showCharactersSchemeToPlayer()
			call Dungeon.resetCameraBoundsForPlayer(whichPlayer)
			call character.panCameraSmart()
			call character.setCameraTimer(true)
			set whichPlayer = null
		endmethod

		public static method create takes Character character, rect whichRect returns thistype
			local thistype this = thistype.createByRect(AGui.playerGui(character.player()), whichRect)
			call this.setCameraSetup(gg_cam_main_window)
			call this.setUseShortcuts(false)
			call this.setUseSpecialShortcuts(true)
			call this.setTooltipX(1500.0)
			call this.setTooltipY(300.0)
			call this.setTooltipSoundPath("Sound\\Interface\\Hint.wav")
			set this.m_character = character
			set this.m_rect = whichRect
			set this.m_wasShownBefore = false

			return this
		endmethod
	endstruct

endlibrary
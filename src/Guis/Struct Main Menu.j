library StructGuisMainMenu requires Asl, StructGameCharacter, StructGameTutorial, StructGameGame, StructGameDungeon

	/**
	 * \brief The main menu can be accessed using the chat command "-menu". It allows various game settings for each player.
	 */
	struct MainMenu
		private Character m_character
		private trigger m_keyTrigger

		private static method dialogButtonActionSetTutorial takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.m_character.tutorial().setEnabled(not this.m_character.tutorial().isEnabled())
			call this.showDialog.evaluate()
		endmethod

		private static method dialogButtonActionSetView takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.m_character.setView(not this.m_character.isViewEnabled())
			call this.showCameraMenu.evaluate()
		endmethod

		private static method dialogButtonActionSetCharactersScheme takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()

			call this.m_character.setShowCharactersScheme(not this.m_character.showCharactersScheme())

			call this.showDialog.evaluate()
		endmethod

		private static method dialogButtonActionSetWorker takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()

			call this.m_character.setShowWorker(not this.m_character.showWorker())

			call this.showDialog.evaluate()
		endmethod

		private static method dialogButtonActionSetControl takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()

			call this.m_character.shareControl(not this.m_character.isControlShared())

			call this.showDialog.evaluate()
		endmethod

		private static method dialogButtonActionIncreaseCameraDistance takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			if (this.m_character.cameraDistance() < Character.maxCameraDistance) then
				call this.m_character.setCameraDistance(this.m_character.cameraDistance() + 250.0)
			endif
			call this.showCameraMenu.evaluate()
		endmethod
		
		private static method dialogButtonActionDecreaseCameraDistance takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			if (this.m_character.cameraDistance() > Character.minCameraDistance) then
				call this.m_character.setCameraDistance(this.m_character.cameraDistance() - 250.0)
			endif
			call this.showCameraMenu.evaluate()
		endmethod
		
		private static method dialogButtonActionResetCameraDistance takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.m_character.setCameraDistance(Character.defaultCameraDistance)
			call this.showCameraMenu.evaluate()
		endmethod
		
		private static method dialogButtonActionChangeCameraToDungeonByIndex takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			if (this.m_character.isViewEnabled()) then
				call this.m_character.setView(false) // make sure 3rd person camera is not enabled, otherwise there will be a crash
			endif
			call Dungeon(Dungeon.dungeons()[dialogButton.index()]).setCameraBoundsForPlayer(this.m_character.player())
			call this.showDungeons.evaluate()
		endmethod
		
		private static method dialogButtonActionBackToCameraMenu takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.showCameraMenu.evaluate()
		endmethod
		
		private method showDungeons takes nothing returns nothing
			local integer i
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tre("Dungeons", "Dungeons"))
			
			set i = 0
			loop
				exitwhen (i == Dungeon.dungeons().size())
				call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(Dungeon(Dungeon.dungeons()[i]).name(), thistype.dialogButtonActionChangeCameraToDungeonByIndex)
				set i = i + 1
			endloop
			
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Zurück zum Kamera-Menü", "Back to the camera menu"), thistype.dialogButtonActionBackToCameraMenu)
			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod
		
		private static method dialogButtonActionChangeCameraToDungeon takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.showDungeons()
		endmethod
		
		private static method dialogButtonActionBackToMainMenu takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.showDialog.evaluate()
		endmethod
		
		public method showCameraMenu takes nothing returns nothing
			local string message
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tre("Kamera", "Camera"))
			
			if (ACharacter.useViewSystem()) then
				if (this.m_character.view().isEnabled()) then
					set message = tre("3rd-Person-Kamera deaktivieren", "Disable 3rd person camera")
				else
					set message = tre("3rd-Person-Kamera aktivieren", "Enable 3rd person camera")
				endif

				call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetView)
			endif
			
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Kameraentfernung vergrößern", "Increase camera distance"), thistype.dialogButtonActionIncreaseCameraDistance)
			
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Kameraentfernung verkleinern", "Decrease camera distance"), thistype.dialogButtonActionDecreaseCameraDistance)
			
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Kameraentfernung zurücksetzen", "Reset camera distance"), thistype.dialogButtonActionResetCameraDistance)
			
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Kamera zu Dungeon wechseln", "Change camera to dungeon"), thistype.dialogButtonActionChangeCameraToDungeon)
			
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Zurück zum Haupt-Menü", "Back to the main menu"), thistype.dialogButtonActionBackToMainMenu)
			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod
		
		private static method dialogButtonActionCameraSettings takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.showCameraMenu()
		endmethod

		private static method dialogButtonActionInfoLog takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.m_character.infoLog().show()
		endmethod

		private static method dialogButtonActionCredits takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.m_character.credits().show()
		endmethod

		public method showDialog takes nothing returns nothing
			local string message
			call AGui.playerGui(this.m_character.player()).dialog().clear()
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tre("Haupt-Menü", "Main Menu"))
			
			if (this.m_character.tutorial().isEnabled()) then
				set message = tre("Tutorial deaktivieren", "Disable tutorial")
			else
				set message = tre("Tutorial aktivieren", "Enable tutorial")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetTutorial)

			if (this.m_character.showCharactersScheme()) then
				set message = tre("Charaktere-Anzeige deaktivieren", "Disable characters view")
			else
				set message = tre("Charaktere-Anzeige aktivieren", "Enable characters view")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetCharactersScheme)

			if (this.m_character.showWorker()) then
				set message = tre("Schrein-Button deaktivieren", "Disable shrine button")
			else
				set message = tre("Schrein-Button aktivieren", "Enable shrine button")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetWorker)

			if (this.m_character.isControlShared()) then
				set message = tre("Kontrolle entziehen", "Disallow control")
			else
				set message = tre("Kontrolle erlauben", "Share control")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetControl)
			
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Kameraeinstellungen", "Camera Settings"), thistype.dialogButtonActionCameraSettings)

static if (DMDF_INFO_LOG) then
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Info-Log", "Info log"), thistype.dialogButtonActionInfoLog)
endif

static if (DMDF_CREDITS) then
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tre("Mitwirkende", "Credits"), thistype.dialogButtonActionCredits)
endif

			call AGui.playerGui(this.m_character.player()).dialog().addSimpleDialogButtonIndex(tre("Zurück zum Spiel", "Back to game"))

			call AGui.playerGui(this.m_character.player()).dialog().show()
		endmethod

		private static method triggerConditionShow takes nothing returns boolean
			local player triggerPlayer = GetTriggerPlayer()
			local boolean result = ACharacter.playerCharacter(triggerPlayer) != 0 and ACharacter.playerCharacter(triggerPlayer).isMovable() and not AGui.playerGui(triggerPlayer).isShown()
			set triggerPlayer = null

			return result
		endmethod

		private static method triggerActionShow takes nothing returns nothing
			local player triggerPlayer = GetTriggerPlayer()
			local thistype this = Character(ACharacter.playerCharacter(triggerPlayer)).mainMenu()
			call this.showDialog()
			set triggerPlayer = null
		endmethod

		private method createKeyTrigger takes nothing returns nothing
			local integer i = 0
			set this.m_keyTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (IsPlayerPlayingUser(Player(i))) then
					call TriggerRegisterPlayerChatEvent(this.m_keyTrigger, Player(i), "-menu", true)
				endif
				set i = i + 1
			endloop
			call TriggerAddCondition(this.m_keyTrigger, Condition(function thistype.triggerConditionShow))
			call TriggerAddAction(this.m_keyTrigger, function thistype.triggerActionShow)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character
			call this.createKeyTrigger()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DestroyTrigger(this.m_keyTrigger)
			set this.m_keyTrigger = null
		endmethod
	endstruct

endlibrary
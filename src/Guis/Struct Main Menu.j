library StructGuisMainMenu requires Asl, StructGameCharacter, StructGameTutorial, StructGameGame

	struct MainMenu
		private Character m_character
		private trigger m_keyTrigger
		private integer m_characterSlotIndex

		private static method dialogButtonActionSetTutorial takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.m_character.tutorial().setEnabled(not this.m_character.tutorial().isEnabled())
			call this.showDialog.evaluate()
		endmethod

		private static method dialogButtonActionSetView takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.m_character.setView(not this.m_character.isViewEnabled())
			call this.showDialog.evaluate()
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

		private static method dialogButtonActionBackToMainMenu takes ADialogButton dialogButton returns nothing
			local thistype this = Character(ACharacter.playerCharacter(dialogButton.dialog().player())).mainMenu()
			call this.showDialog.evaluate()
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
			call AGui.playerGui(this.m_character.player()).dialog().setMessage(tr("Haupt-Menü"))

			if (this.m_character.tutorial().isEnabled()) then
				set message = tr("Tutorial deaktivieren")
			else
				set message = tr("Tutorial aktivieren")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetTutorial)

			if (ACharacter.useViewSystem()) then
				if (this.m_character.view().isEnabled()) then
					set message = tr("3rd-Person-Kamera deaktivieren")
				else
					set message = tr("3rd-Person-Kamera aktivieren")
				endif

				call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetView)
			endif

			if (this.m_character.showCharactersScheme()) then
				set message = tr("Charaktere-Anzeige deaktivieren")
			else
				set message = tr("Charaktere-Anzeige aktivieren")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetCharactersScheme)

			if (this.m_character.showWorker()) then
				set message = tr("Schrein-Button deaktivieren")
			else
				set message = tr("Schrein-Button aktivieren")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetWorker)

			if (this.m_character.isControlShared()) then
				set message = tr("Kontrolle entziehen")
			else
				set message = tr("Kontrolle erlauben")
			endif
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(message, thistype.dialogButtonActionSetControl)

static if (DMDF_INFO_LOG) then
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Info-Log"), thistype.dialogButtonActionInfoLog)
endif

static if (DMDF_CREDITS) then
			call AGui.playerGui(this.m_character.player()).dialog().addDialogButtonIndex(tr("Mitwirkende"), thistype.dialogButtonActionCredits)
endif

			call AGui.playerGui(this.m_character.player()).dialog().addSimpleDialogButtonIndex(tr("Zurück zum Spiel"))

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
			set this.m_characterSlotIndex = 0

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call DestroyTrigger(this.m_keyTrigger)
			set this.m_keyTrigger = null
		endmethod
	endstruct

endlibrary
library StructGameOptions requires Asl, StructGameCharacter, StructGameTutorial

	struct OptionsSpellbook extends CharacterOptionsMultipageSpellbook

		public static method create takes Character character, unit whichUnit returns thistype
			local thistype this = thistype.allocate(character, whichUnit, 0, 0, 0, 0)
			call this.setShortcut(tre("O", "O"))
			call this.addEntry(OptionsEntryShowCharactersSchema.create.evaluate(this))
			call this.addEntry(OptionsEntryAllowControl.create.evaluate(this))
			call this.addEntry(OptionsEntryCredits.create.evaluate(this))
			call this.addEntry(OptionsEntryEnableShrineButton.create.evaluate(this))
			call this.addEntry(OptionsEntryEnableTutorial.create.evaluate(this))
			call this.addEntry(OptionsEntryEnableQuestSignals.create.evaluate(this))
			call this.addEntry(OptionsEntryWorldMap.create.evaluate(this))
			call this.addEntry(OptionsEntryCharacterManagement.create.evaluate(this))

			return this
		endmethod
	endstruct

	struct CharacterOptionsMultipageSpellbook extends AMultipageSpellbook
		private Character m_character

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public static method create takes Character character, unit whichUnit, integer nextPageAbility, integer nextPageSpellbookAbility, integer previousPageAbility, integer previousPageSpellbookAbility returns thistype
			local thistype this = thistype.allocate(whichUnit, nextPageAbility, nextPageSpellbookAbility, previousPageAbility, previousPageSpellbookAbility)
			set this.m_character = character

			return this
		endmethod
	endstruct

	struct OptionsEntryShowCharactersSchema extends AMultipageSpellbookAction

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			call this.spellbook().character().setShowCharactersScheme(not this.spellbook().character().showCharactersScheme())
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1UC', 'A1UI')

			return this
		endmethod
	endstruct

	struct OptionsEntryAllowControl extends AMultipageSpellbookAction

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			call this.spellbook().character().shareControl(not this.spellbook().character().isControlShared())

			if (this.spellbook().character().isControlShared()) then
				call this.spellbook().character().displayMessage(ACharacter.messageTypeInfo, tre("Kontrolle erlaubt.", "Allowed control."))
			else
				call this.spellbook().character().displayMessage(ACharacter.messageTypeInfo, tre("Kontrolle entzogen.", "Disallowed control."))
			endif
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1UE', 'A1UH')

			return this
		endmethod
	endstruct

	struct OptionsEntryCredits extends AMultipageSpellbookAction

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Credits credits = this.spellbook().character().credits()

			if (credits.isShown()) then
				call credits.hide.execute()
			else
				call credits.show.execute()
			endif
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1UF', 'A1UG')

			return this
		endmethod
	endstruct

	struct OptionsEntryEnableShrineButton extends AMultipageSpellbookAction

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()
			call character.setShowWorker(not character.showWorker())
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1UD', 'A1UJ')

			return this
		endmethod
	endstruct

	struct OptionsEntryEnableTutorial extends AMultipageSpellbookAction

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Tutorial tutorial = this.spellbook().character().tutorial()
			call tutorial.setEnabled(not tutorial.isEnabled())

			if (tutorial.isEnabled()) then
				call this.spellbook().character().displayMessage(ACharacter.messageTypeInfo, tre("Tutorial aktiviert.", "Enabled tutorial."))
			else
				call this.spellbook().character().displayMessage(ACharacter.messageTypeInfo, tre("Tutorial deaktiviert.", "Disabled tutorial."))
			endif
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1UB', 'A1UK')

			return this
		endmethod
	endstruct

	struct OptionsEntryEnableQuestSignals extends AMultipageSpellbookAction
		private boolean m_enabled = true

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()

			if (this.m_enabled) then
				set this.m_enabled = false
				call AAbstractQuest.disablePingsForCharacter(character)
				call character.displayMessage(ACharacter.messageTypeInfo, tre("Signale deaktiviert.", "Disabled signals."))
			else
				set this.m_enabled = true
				call AAbstractQuest.disablePingsForCharacter(character)
				call character.displayMessage(ACharacter.messageTypeInfo, tre("Signale aktiviert.", "Enabled signals."))
			endif
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1UY', 'A1UZ')

			return this
		endmethod
	endstruct

	struct OptionsEntryWorldMap extends AMultipageSpellbookAction

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()

			if (MapSettings.mapName() != "WM") then
				call MapChanger.changeMap.evaluate("WM")
			else
				call character.displayMessage(Character.messageTypeError, tre("Sie sehen bereits die Weltkarte.", "You are already viewing the world map."))
			endif
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1V4', 'A1V5')

			return this
		endmethod
	endstruct

	struct OptionsEntryCharacterManagement extends AMultipageSpellbookAction

		public method spellbook takes nothing returns OptionsSpellbook
			return OptionsSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()
static if (DMDF_INFO_LOG) then
			if (not character.infoLog().isShown()) then
				debug call Print("Show info log: " + I2S(character.infoLog()))
				call character.infoLog().showEx.execute()
			else
				debug call Print("Hide info log: " + I2S(character.infoLog()))
				call character.infoLog().hide()
			endif
else
			debug call Print("Dont show info log")
endif
		endmethod

		public static method create takes OptionsSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1V6', 'A1V7')

			return this
		endmethod
	endstruct

	struct CameraSpellbook extends CharacterOptionsMultipageSpellbook

		public static method create takes Character character, unit whichUnit returns thistype
			local thistype this = thistype.allocate(character, whichUnit, 0, 0, 0, 0)
			call this.setShortcut(tre("K", "K"))
			call this.addEntry(CameraEntryEnableThirdPerson.create.evaluate(this))
			call this.addEntry(CameraEntryIncreaseDistance.create.evaluate(this))
			call this.addEntry(CameraEntryDecreaseDistance.create.evaluate(this))
			call this.addEntry(CameraEntryResetDistance.create.evaluate(this))

			return this
		endmethod
	endstruct

	struct CameraEntryEnableThirdPerson extends AMultipageSpellbookAction

		public method spellbook takes nothing returns CameraSpellbook
			return CameraSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()
			call character.setView(not character.isViewEnabled())
		endmethod

		public static method create takes CameraSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1U9', 'A1UL')

			return this
		endmethod
	endstruct

	struct CameraEntryIncreaseDistance extends AMultipageSpellbookAction

		public method spellbook takes nothing returns CameraSpellbook
			return CameraSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()
			local real cameraDistance = character.cameraDistance()

			if (cameraDistance < Character.maxCameraDistance) then
				call character.setCameraDistance(cameraDistance + 250.0)
			endif
		endmethod

		public static method create takes CameraSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1U6', 'A1UM')

			return this
		endmethod
	endstruct

	struct CameraEntryDecreaseDistance extends AMultipageSpellbookAction

		public method spellbook takes nothing returns CameraSpellbook
			return CameraSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()
			local real cameraDistance = character.cameraDistance()

			if (cameraDistance > Character.minCameraDistance) then
				call character.setCameraDistance(cameraDistance - 250.0)
			endif
		endmethod

		public static method create takes CameraSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1U7', 'A1UN')

			return this
		endmethod
	endstruct

	struct CameraEntryResetDistance extends AMultipageSpellbookAction

		public method spellbook takes nothing returns CameraSpellbook
			return CameraSpellbook(this.multipageSpellbook())
		endmethod

		public stub method onCheck takes nothing returns boolean
			local Character character = this.spellbook().character()
			return not character.isViewEnabled()
		endmethod

		public stub method onTrigger takes nothing returns nothing
			local Character character = this.spellbook().character()
			local real cameraDistance = character.cameraDistance()

			call character.setCameraDistance(Character.defaultCameraDistance)
		endmethod

		public static method create takes CameraSpellbook spellbook returns thistype
			local thistype this = thistype.allocate(spellbook, 'A1U8', 'A1UO')

			return this
		endmethod
	endstruct

	/**
	 * \brief Hero button in the left top corner with options and lists of missions.
	 * It uses multiple multipage spellbooks to offer as many as possible options to the player.
	 * This is better than the "-menu" chat command since the player does not have to type anything and it shows icons.
	 * \note If there are not enough buttons the inventory can be used too.
	 */
	struct Options
		private Character m_character
		private unit m_unit
		private Missions m_missions
		private DungeonSpellbook m_dungeons
		private OptionsSpellbook m_options
		private CameraSpellbook m_camera

		public method missions takes nothing returns Missions
			return this.m_missions
		endmethod

		public method dungeons takes nothing returns DungeonSpellbook
			return this.m_dungeons
		endmethod

		public method options takes nothing returns OptionsSpellbook
			return this.m_options
		endmethod

		public method camera takes nothing returns CameraSpellbook
			return this.m_camera
		endmethod

		public method moveTo takes real x, real y returns nothing
			call SetUnitX(this.m_unit, x)
			call SetUnitY(this.m_unit, y)
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate()
			set this.m_character = character
			set this.m_unit = CreateUnit(character.player(), 'H03D', GetUnitX(character.unit()), GetUnitY(character.unit()), 0.0)
			call SetUnitInvulnerable(this.m_unit, true)
			call SetUnitPathing(this.m_unit, false)
			call SetUnitVertexColor(this.m_unit, 255, 255, 255, 0)
			set this.m_missions = Missions.create.evaluate(character, this.m_unit)
			set this.m_dungeons = DungeonSpellbook.create.evaluate(character, this.m_unit)
			set this.m_options = OptionsSpellbook.create.evaluate(character, this.m_unit)
			set this.m_camera = CameraSpellbook.create.evaluate(character, this.m_unit)

			call UnitAddAbility(this.m_unit, 'A1BY')
			call UnitAddAbility(this.m_unit, 'A1TT')
			call UnitAddAbility(this.m_unit, 'A1TU')
			call UnitAddAbility(this.m_unit, 'A1TV')
			call UnitAddAbility(this.m_unit, 'A1UA')

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_missions.destroy()
			call this.m_dungeons.destroy()
			call this.m_options.destroy()
			call this.m_camera.destroy()

			call RemoveUnit(this.m_unit)
			set this.m_unit = null
		endmethod
	endstruct

endlibrary
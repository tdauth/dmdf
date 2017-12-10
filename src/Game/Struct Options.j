library StructGameOptions requires Asl, StructGameCharacter, StructGameTutorial

	/**
	 * \brief Parent struct for all options which can be directly used without a sub menu (spellbook).
	 */
	struct CharacterOptionsSpell extends AUnitSpell
		private Character m_character
		private unit m_spellBookUnit

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public stub method onCastCondition takes nothing returns boolean
			return GetTriggerUnit() == this.m_spellBookUnit
		endmethod

		public stub method onCastAction takes nothing returns nothing
		endmethod

		public static method create takes Character character, unit spellBookUnit, integer abilityId returns thistype
			local thistype this = thistype.allocate(abilityId, 0, 0, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, true, true)
			set this.m_character = character
			set this.m_spellBookUnit = spellBookUnit
			call UnitAddAbility(spellBookUnit, abilityId)

			return this
		endmethod
	endstruct

	/**
	 * \brief Parent struct for all multipage spellbooks of the options.
	 */
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

	struct OptionsEntryShowCharactersSchema extends CharacterOptionsSpell

		public stub method onCastAction takes nothing returns nothing
			call this.character().setShowCharactersScheme(not this.character().showCharactersScheme())
		endmethod

		public static method create takes Character character, unit spellBookUnit returns thistype
			local thistype this = thistype.allocate(character, spellBookUnit, 'A1UC')

			return this
		endmethod
	endstruct

	struct OptionsEntryAllowControl extends CharacterOptionsSpell

		public stub method onCastAction takes nothing returns nothing
			call this.character().shareControl(not this.character().isControlShared())

			if (this.character().isControlShared()) then
				call this.character().displayMessage(ACharacter.messageTypeInfo, tre("Kontrolle erlaubt.", "Allowed control."))
			else
				call this.character().displayMessage(ACharacter.messageTypeInfo, tre("Kontrolle entzogen.", "Disallowed control."))
			endif
		endmethod

		public static method create takes Character character, unit spellBookUnit returns thistype
			local thistype this = thistype.allocate(character, spellBookUnit, 'A1UE')

			return this
		endmethod
	endstruct

	struct OptionsEntryCredits extends CharacterOptionsSpell

		public stub method onCastAction takes nothing returns nothing
			local Credits credits = this.character().credits()

			if (credits.isShown()) then
				call credits.hide.execute()
			else
				call credits.show.execute()
			endif
		endmethod

		public static method create takes Character character, unit spellBookUnit returns thistype
			local thistype this = thistype.allocate(character, spellBookUnit, 'A1UF')

			return this
		endmethod
	endstruct

	struct OptionsEntryEnableShrineButton extends CharacterOptionsSpell

		public stub method onCastAction takes nothing returns nothing
			local Character character = this.character()
			call character.setShowWorker(not character.showWorker())
		endmethod

		public static method create takes Character character, unit spellBookUnit returns thistype
			local thistype this = thistype.allocate(character, spellBookUnit, 'A1UD')

			return this
		endmethod
	endstruct

	struct OptionsEntryEnableTutorial extends CharacterOptionsSpell

		public stub method onCastAction takes nothing returns nothing
			local Tutorial tutorial = this.character().tutorial()
			call tutorial.setEnabled(not tutorial.isEnabled())

			if (tutorial.isEnabled()) then
				call this.character().displayMessage(ACharacter.messageTypeInfo, tre("Tutorial aktiviert.", "Enabled tutorial."))
			else
				call this.character().displayMessage(ACharacter.messageTypeInfo, tre("Tutorial deaktiviert.", "Disabled tutorial."))
			endif
		endmethod

		public static method create takes Character character, unit spellBookUnit returns thistype
			local thistype this = thistype.allocate(character, spellBookUnit, 'A1UB')

			return this
		endmethod
	endstruct

	struct OptionsEntryEnableQuestSignals extends CharacterOptionsSpell
		private boolean m_enabled = true

		public stub method onCastAction takes nothing returns nothing
			local Character character = this.character()

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

		public static method create takes Character character, unit spellBookUnit returns thistype
			local thistype this = thistype.allocate(character, spellBookUnit, 'A1UY')

			return this
		endmethod
	endstruct

	struct OptionsEntryWorldMap extends CharacterOptionsSpell

		private static method dialogButtonActionTravelToWorldMap takes ADialogButton dialogButton returns nothing
			local Character character = Character.playerCharacter(dialogButton.dialog().player())
			if (character != 0 and ClassSelection.playerClassSelection(character.player()) == 0 and not AGui.playerGui(character.player()).isShown() and character.isMovable()) then
				call MapChanger.changeMap.evaluate("WM")
			else
				call character.displayHint(tre("Der Charakter darf nicht beschäftigtt und keine spezielle Ansicht geöffnet sein, um zur Weltkarte zu reisen.", "The character must not be busy and no special view must be open when traveling to the world map."))
			endif
		endmethod

		private static method thereIsAtLeastOneSaveGame takes nothing returns boolean
			local AStringVector zoneNames = Zone.zoneNames.evaluate()
			local string zoneName = ""
			local integer i = 0
			loop
				exitwhen (i == zoneNames.size())
				set zoneName = zoneNames[i]
				if (MapChanger.zoneHasSaveGame.evaluate(zoneName)) then
					return true
				endif
				set i = i + 1
			endloop
			return false
		endmethod

		public stub method onCastAction takes nothing returns nothing
			local Character character = this.character()

			if (MapSettings.mapName() != "WM") then
				if (bj_isSinglePlayer and Game.isCampaign.evaluate()) then
					if (thistype.thereIsAtLeastOneSaveGame()) then
						call AGui.playerGui(Commands.adminPlayer()).dialog().clear()
						call AGui.playerGui(Commands.adminPlayer()).dialog().setMessage(tre("Wirklich verreisen?", "Do you really want to travel?"))
						call AGui.playerGui(Commands.adminPlayer()).dialog().addDialogButtonIndex(tre("Ja", "Yes"), thistype.dialogButtonActionTravelToWorldMap)
						call AGui.playerGui(Commands.adminPlayer()).dialog().addSimpleDialogButtonIndex(tre("Nein", "No"))
						call AGui.playerGui(Commands.adminPlayer()).dialog().show()
					else
						call character.displayHint(tre("Sie müssen erst einen anderen Ort bereisen.", "You have to travel to another location first."))
					endif
				else
					call character.displayHint(tre("Die Karte kann nur in der Einzelspieler-Kampagne gewechselt werden.", "The map can only be changed in the singleplayer campaign."))
				endif
			else
				call character.displayMessage(Character.messageTypeError, tre("Sie sehen bereits die Weltkarte.", "You are already viewing the world map."))
			endif
		endmethod

		public static method create takes Character character, unit spellBookUnit returns thistype
			local thistype this = thistype.allocate(character, spellBookUnit, 'A1V4')

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
	 * \brief Hero button in the left top corner with options and lists of missions, talks etc.
	 * It uses multiple multipage spellbooks to offer as many as possible options to the player.
	 * This is better than the "-menu" chat command since the player does not have to type anything and it shows icons.
	 * \note If there are not enough buttons the inventory can be used too.
	 */
	struct Options
		private Character m_character
		private unit m_unit
		private Missions m_missions
		private DungeonSpellbook m_dungeons
		private CameraSpellbook m_camera
		/**
		 * Instances of \ref AUnitSpell.
		 */
		private AIntegerList m_entries

		public method missions takes nothing returns Missions
			return this.m_missions
		endmethod

		public method dungeons takes nothing returns DungeonSpellbook
			return this.m_dungeons
		endmethod

		public method camera takes nothing returns CameraSpellbook
			return this.m_camera
		endmethod

		public method moveTo takes real x, real y returns nothing
			call SetUnitX(this.m_unit, x)
			call SetUnitY(this.m_unit, y)
		endmethod

		public method unit takes nothing returns unit
			return this.m_unit
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate()
			local real x = GetUnitX(character.unit())
			local real y = GetUnitY(character.unit())
			local unit playerUnit = Shrine.playerUnit.evaluate(GetPlayerId(character.player()))
			set this.m_character = character

			/*
			 * Directly place the options at the shrine location.
			 */
			if (character.shrine() != 0 and playerUnit != null) then
				set x = GetUnitX(playerUnit)
				set y = GetUnitY(playerUnit)
				set playerUnit = null
			endif

			set this.m_unit = CreateUnit(character.player(), 'H03D', x, y, 0.0)
			call SetUnitInvulnerable(this.m_unit, true)
			call SetUnitPathing(this.m_unit, false)
			call SetUnitVertexColor(this.m_unit, 255, 255, 255, 0)
			set this.m_missions = Missions.create.evaluate(character, this.m_unit)
			set this.m_dungeons = DungeonSpellbook.create.evaluate(character, this.m_unit)
			set this.m_camera = CameraSpellbook.create.evaluate(character, this.m_unit)

			call UnitAddAbility(this.m_unit, 'A1BY')
			call UnitAddAbility(this.m_unit, 'A1TT')
			call UnitAddAbility(this.m_unit, 'A1TU')
			call UnitAddAbility(this.m_unit, 'A1TV')

			/*
			 * Option abilities are added directly and not inside of a spellbook:
			 * TODO Remove old spellbook abilities from object data: 'A1UA' 'A1UI' 'A1UH' 'A1UG' 'A1UJ'  'A1UK' 'A1UZ' 'A1V5'
			 */
			set this.m_entries = AIntegerList.create()
			call this.m_entries.pushBack(OptionsEntryShowCharactersSchema.create(character, this.m_unit))
			call this.m_entries.pushBack(OptionsEntryAllowControl.create(character, this.m_unit))
			call this.m_entries.pushBack(OptionsEntryCredits.create(character, this.m_unit))
			call this.m_entries.pushBack(OptionsEntryEnableShrineButton.create(character, this.m_unit))
			call this.m_entries.pushBack(OptionsEntryEnableTutorial.create(character, this.m_unit))
			call this.m_entries.pushBack(OptionsEntryEnableQuestSignals.create(character, this.m_unit))
			call this.m_entries.pushBack(OptionsEntryWorldMap.create(character, this.m_unit))

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_missions.destroy()
			call this.m_dungeons.destroy()
			call this.m_camera.destroy()
			loop
				exitwhen (this.m_entries.empty())
				call AUnitSpell(this.m_entries.back()).destroy()
				call this.m_entries.popBack()
			endloop
			call this.m_entries.destroy()

			call RemoveUnit(this.m_unit)
			set this.m_unit = null
		endmethod
	endstruct

endlibrary
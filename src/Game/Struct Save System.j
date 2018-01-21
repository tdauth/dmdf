library StructSaveSystem requires Asl, StructGameCharacter, StructGameClassSelection

	/**
	 * \brief Basic save system which allows saving characters by a series of characters and loading them at any time.
	 *
	 * The following data is stored and restored:
	 * <ul>
	 * <li>Hero Level</li>
	 * <li>Gold</li>
	 * </ul>
	 *
	 * TODO Encoding and decoding works but there should be some encryption keys, otherwise one could easily reproduce any savecode he/she wants to.
	 * TODO Probably more digits could be saved if maximum values would be defined for certain values. In this case one single digit could be used to save more stuff?
	 */
	struct SaveSystem
		public static constant string digits = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

		private static trigger m_chatSaveTrigger
		private static trigger m_chatLoadTrigger

		public static method max takes integer digits returns integer
			return R2I(Pow(I2R(StringLength(thistype.digits)), I2R(digits)))
		endmethod

		/**
		 * Converts the decimal value \p decValue into the number system using \ref thistype.digits as digits.
		 * Therefore the number should get less digits.
		 * \return Returns the converted number as a string of digits.
		 */
		public static method encode takes integer decValue returns string
			local integer base = StringLength(thistype.digits)
			local integer mod = 0
			local string result = ""
			loop
				set mod = ModuloInteger(decValue, base)
				set result = SubString(thistype.digits, mod, mod + 1) + result
				set decValue = decValue / base
				exitwhen (decValue == 0)
			endloop

			// TODO cut leading zeroes

			return result
		endmethod

		/**
		 * Converts the number from the number system using \ref thistype.digits as digits into a decimal value.
		 * \return Returns the decimal value.
		 */
		public static method decode takes string savValue returns integer
			local integer base = StringLength(thistype.digits)
			local integer result = 0
			local integer index = 0
			local integer i = 0
			debug call Print("Decoding: " + savValue)
			loop
				exitwhen (i == StringLength(savValue))
				set index = FindString(thistype.digits, SubString(savValue, i, i + 1))
				set result = result + index * R2I(Pow(I2R(base), I2R(StringLength(savValue) - i - 1)))
				set i = i + 1
			endloop

			return result
		endmethod

		/**
		 * Encodes all saved data by converting it into a different number system.
		 * All values are separated by "-" characters.
		 * \return Returns the save code for the character of \p whichPlayer.
		 */
		public static method encodePlayerCharacter takes player whichPlayer returns string
			local Character character = Character(ACharacter.playerCharacter(whichPlayer))
			local unit hero = character.unit()
			local string class = thistype.encode(character.class())
			local string xp = thistype.encode(GetHeroXP(hero))
			local string gold = thistype.encode(GetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD))
			local string strength = thistype.encode(GetHeroStr(hero, false))
			local string agility = thistype.encode(GetHeroAgi(hero, false))
			local string intelligence = thistype.encode(GetHeroInt(hero, false))
			local string skillPoints = thistype.encode(character.grimoire().totalSkillPoints())
			local string slot0Equipment = ""
			local string slot1Equipment = ""
			local string slot2Equipment = ""
			local string slot3Equipment = ""
			local string slot4Equipment = ""
			local string slot5Equipment = ""
			if (character.inventory().equipmentItemData(AItemType.equipmentTypeHeaddress) != 0) then
				set slot0Equipment = thistype.encode(character.inventory().equipmentItemData(AItemType.equipmentTypeHeaddress).itemTypeId())
			endif
			if (character.inventory().equipmentItemData(AItemType.equipmentTypeArmour) != 0) then
				set slot1Equipment = thistype.encode(character.inventory().equipmentItemData(AItemType.equipmentTypeArmour).itemTypeId())
			endif
			if (character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon) != 0) then
				set slot2Equipment = thistype.encode(character.inventory().equipmentItemData(AItemType.equipmentTypePrimaryWeapon).itemTypeId())
			endif
			if (character.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon) != 0) then
				set slot3Equipment = thistype.encode(character.inventory().equipmentItemData(AItemType.equipmentTypeSecondaryWeapon).itemTypeId())
			endif
			if (character.inventory().equipmentItemData(AItemType.equipmentTypeAmulet) != 0) then
				set slot4Equipment = thistype.encode(character.inventory().equipmentItemData(AItemType.equipmentTypeAmulet).itemTypeId())
			endif
			if (character.inventory().equipmentItemData(AItemType.equipmentTypeAmulet + 1) != 0) then
				set slot5Equipment = thistype.encode(character.inventory().equipmentItemData(AItemType.equipmentTypeAmulet + 1).itemTypeId())
			endif
			// TODO non-quest items
			set hero = null
			return class + "-" + xp + "-" + gold + "-" + strength + "-" + agility + "-" + intelligence + "-" + skillPoints + "-" + slot0Equipment + "-" + slot1Equipment + "-" + slot2Equipment + "-" + slot3Equipment + "-" + slot4Equipment + "-" + slot5Equipment
		endmethod

		public static method decodePlayerCharacter takes player whichPlayer, string saveCode returns nothing
			local ATokenizer tokenizer = ATokenizer.create(saveCode)
			local AClass class = 0
			local integer xp = 0
			local integer gold = 0
			local integer strength = 0
			local integer agility = 0
			local integer intelligence = 0
			local integer skillPoints = 0
			local integer slot0Equipment = 0
			local integer slot1Equipment = 0
			local integer slot2Equipment = 0
			local integer slot3Equipment = 0
			local integer slot4Equipment = 0
			local integer slot5Equipment = 0
			// store old stuff
			local Character oldCharacter = Character(ACharacter.playerCharacter(whichPlayer))
			local unit hero = oldCharacter.unit()
			local real oldX = GetUnitX(hero)
			local real oldY = GetUnitY(hero)
			local real oldFacing = GetUnitFacing(hero)
			local AIntegerVector oldQuests = oldCharacter.quests.evaluate()
			local AIntegerVector oldFellows = oldCharacter.fellows.evaluate()
			local AShrine oldShrine = oldCharacter.shrine()
			local boolean oldShowCharactersScheme = oldCharacter.showCharactersScheme()
			local boolean oldShowWorker = oldCharacter.showWorker()
			local real oldCameraDistance = oldCharacter.cameraDistance()
			local boolean oldViewEnabled = oldCharacter.isViewEnabled()

			local Character newCharacter = 0


			// decode everything
			call tokenizer.setSeparators("-")
			debug call Print("Decoding " + saveCode)
			set class = AClass(thistype.decode(tokenizer.next()))
			set xp = thistype.decode(tokenizer.next())
			set gold = thistype.decode(tokenizer.next())
			set strength = thistype.decode(tokenizer.next())
			set agility = thistype.decode(tokenizer.next())
			set intelligence = thistype.decode(tokenizer.next())
			set skillPoints = thistype.decode(tokenizer.next())
			set slot0Equipment = thistype.decode(tokenizer.next())
			set slot1Equipment = thistype.decode(tokenizer.next())
			set slot2Equipment = thistype.decode(tokenizer.next())
			set slot3Equipment = thistype.decode(tokenizer.next())
			set slot4Equipment = thistype.decode(tokenizer.next())
			set slot5Equipment = thistype.decode(tokenizer.next())

			// drop all items
			call oldCharacter.inventory().dropAll(oldX, oldY, true)

			// replace character
			call oldCharacter.destroy()


			set newCharacter = Character.create.evaluate(whichPlayer, class.generateUnit(whichPlayer, oldX, oldY, oldFacing), oldQuests, oldFellows)
			call ACharacter.setPlayerCharacterByCharacter(newCharacter)

			call ClassSelection.setupCharacterUnit.evaluate(newCharacter, class)

			// assign loaded data
			set hero = newCharacter.unit()
			call SetHeroXP(hero, xp, false)
			call SetPlayerState(whichPlayer, PLAYER_STATE_RESOURCE_GOLD, gold)
			call SetHeroStr(hero, strength, true)
			call SetHeroAgi(hero, agility, true)
			call SetHeroInt(hero, intelligence, true)
			call newCharacter.grimoire().setSkillPoints(skillPoints, true)
			if (slot0Equipment != 0) then
				call newCharacter.giveItem(slot0Equipment)
			endif
			if (slot1Equipment != 0) then
				call newCharacter.giveItem(slot1Equipment)
			endif
			if (slot2Equipment != 0) then
				call newCharacter.giveItem(slot2Equipment)
			endif
			if (slot3Equipment != 0) then
				call newCharacter.giveItem(slot3Equipment)
			endif
			if (slot4Equipment != 0) then
				call newCharacter.giveItem(slot4Equipment)
			endif
			if (slot5Equipment != 0) then
				call newCharacter.giveItem(slot5Equipment)
			endif

			// assign old data
			call newCharacter.setShrine(oldShrine)
			call newCharacter.setShowCharactersScheme(oldShowCharactersScheme)
			call newCharacter.setShowWorker(oldShowWorker)
			call newCharacter.setCameraDistance(oldCameraDistance)
			call newCharacter.setView(oldViewEnabled)

			// select and pan
			call newCharacter.panCameraSmart()
			call newCharacter.select(false)

			call tokenizer.destroy()
		endmethod

		private static method triggerConditionCharacterIsMovable takes nothing returns boolean
			return ACharacter.playerCharacter(GetTriggerPlayer()) != 0 and ACharacter.playerCharacter(GetTriggerPlayer()).isMovable()
		endmethod

		private static method triggerActionSave takes nothing returns nothing
			local string saveCode = thistype.encodePlayerCharacter(GetTriggerPlayer())
			call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 999999.0, saveCode)
			call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 999999.0, tre("Die Datei \"Documents\\Warcraft III\\CustomMapData\\TPoF.txt\" in Ihrem Windows-Benutzer-Verzeichnis enthält den Save-Code.", "The file \"Documents\\Warcraft III\\CustomMapData\\TPoF.txt\" in your Windows user directory contains the save code."))

			// log into file
			call PreloadGenClear()
			call PreloadGenStart()
			call Preload("Savecode: " + saveCode)
			call PreloadGenEnd("TPoF.txt")
		endmethod

		private static method triggerActionLoad takes nothing returns nothing
			local string saveCode = SubString(GetEventPlayerChatString(), StringLength("-load"), StringLength(GetEventPlayerChatString()) + 1)
			call thistype.decodePlayerCharacter(GetTriggerPlayer(), StringTrim(saveCode))
			call DisplayTimedTextToPlayer(GetTriggerPlayer(), 0, 0, 5.0, tre("Charakter geladen.", "Loaded character."))
		endmethod

		public static method onInit takes nothing returns nothing
			local integer i
			set thistype.m_chatSaveTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call TriggerRegisterPlayerChatEvent(thistype.m_chatSaveTrigger, Player(i), "-save", true)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_chatSaveTrigger, Condition(function thistype.triggerConditionCharacterIsMovable))
			call TriggerAddAction(thistype.m_chatSaveTrigger, function thistype.triggerActionSave)

			set thistype.m_chatLoadTrigger = CreateTrigger()
			set i = 0
			loop
				exitwhen (i == MapSettings.maxPlayers())
				call TriggerRegisterPlayerChatEvent(thistype.m_chatLoadTrigger, Player(i), "-load", false)
				set i = i + 1
			endloop
			call TriggerAddCondition(thistype.m_chatLoadTrigger, Condition(function thistype.triggerConditionCharacterIsMovable))
			call TriggerAddAction(thistype.m_chatLoadTrigger, function thistype.triggerActionLoad)
		endmethod
	endstruct

endlibrary
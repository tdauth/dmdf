library AStructSystemsCharacterCharactersScheme requires optional ALibraryCoreDebugMisc, AStructCoreInterfaceMultiboardBar, ALibraryCoreInterfaceMisc, ALibraryCoreInterfaceMultiboard, AStructSystemsCharacterCharacter, AStructCoreGeneralList

	/// \todo Should be contained by \ref ACharactersScheme, vJass bug.
	function interface ACharactersSchemeExperienceFormula takes unit hero returns integer

	/**
	 * \brief A characters scheme uses one multiboard to display information about all playing characters which might be useful in cooperative multiplayer maps.
	 * These information can be:
	 * <ul>
	 * <li>player name</li>
	 * <li>class</li>
	 * <li>level</li>
	 * <li>experience until next level</li>
	 * <li>life</li>
	 * <li>mana</li>
	 * <li>gold</li>
	 * </ul>
	 * \todo Make player rows more dynamic (add struct like ACharactersSchemeRow) that they can be moved and hidden.
	 * \todo Add resources lumber and supply.
	 * \todo Set more default values (for icons etc.)
	 */
	struct ACharactersScheme
		// construction members
		private real m_refreshRate
		private boolean m_showPlayerName
		private boolean m_showUnitName
		private boolean m_showLevel
		private integer m_experienceLength
		private ACharactersSchemeExperienceFormula m_currentExperienceFormula
		private ACharactersSchemeExperienceFormula m_maxExperienceFormula
		private integer m_hitPointsLength
		private integer m_manaLength
		private boolean m_showGold
		private string m_textTitle
		private string m_textLevel
		private string m_textLeftGame
		private string m_iconGold
		// dynamic members
		private real m_firstColumnWidth
		private real m_goldColumnWidth
		// members
		private trigger m_refreshTrigger
		private multiboard m_multiboard
		/**
		 * Stores instances for every player which has been there when the scheme was created.
		 * Stores instances of type \ref ACharactersSchemaPlayerData which has to be destroyed on destruction.
		 */
		private AIntegerList m_playerData
		/**
		 * Stores the column index where the gold values are shown.
		 */
		private integer m_goldColumn

		//! runtextmacro optional A_STRUCT_DEBUG("\"ACharactersScheme\"")

		// construction members

		public method refreshRate takes nothing returns real
			return this.m_refreshRate
		endmethod

		public method showPlayerName takes nothing returns boolean
			return this.m_showPlayerName
		endmethod

		public method showUnitName takes nothing returns boolean
			return this.m_showUnitName
		endmethod

		public method showLevel takes nothing returns boolean
			return this.m_showLevel
		endmethod

		public method experienceLength takes nothing returns integer
			return this.m_experienceLength
		endmethod

		public method currentExperienceFormula takes nothing returns ACharactersSchemeExperienceFormula
			return this.m_currentExperienceFormula
		endmethod

		public method maxExperienceFormula takes nothing returns ACharactersSchemeExperienceFormula
			return this.m_maxExperienceFormula
		endmethod

		public method hitPointsLength takes nothing returns integer
			return this.m_hitPointsLength
		endmethod

		public method manaLength takes nothing returns integer
			return this.m_manaLength
		endmethod

		public method showGold takes nothing returns boolean
			return this.m_showGold
		endmethod

		public method textTitle takes nothing returns string
			return this.m_textTitle
		endmethod

		public method textLevel takes nothing returns string
			return this.m_textLevel
		endmethod

		public method textLeftGame takes nothing returns string
			return this.m_textLeftGame
		endmethod

		public method iconGold takes nothing returns string
			return this.m_iconGold
		endmethod

		// dynamic members

		public method firstColumnWidth takes nothing returns real
			return this.m_firstColumnWidth
		endmethod

		public method goldColumWidth takes nothing returns real
			return this.m_goldColumnWidth
		endmethod

		// members

		/**
		 * \return Returns the corresponding multiboard of the scheme.
		 */
		public method multiboard takes nothing returns multiboard
			return this.m_multiboard
		endmethod

		/**
		 * \return Returns the column in the multiboard where the gold is shown.
		 */
		public method goldColumn takes nothing returns integer
			return this.m_goldColumn
		endmethod

		// methods

		/**
		 * \return Returns the corresponding player data of a character's player.
		 * Time complexity: O(n)
		 * TODO Slow performance!
		 */
		private method characterPlayerData takes ACharacter character returns ACharactersSchemaPlayerData
			local ACharactersSchemaPlayerData result = 0
			local ACharactersSchemaPlayerData currentPlayerData = 0
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				set currentPlayerData = ACharactersSchemaPlayerData(iterator.data())
				if (currentPlayerData.player.evaluate() == character.player()) then
					set result = currentPlayerData
					exitwhen (true)
				endif
				call iterator.next()
			endloop
			call iterator.destroy()

			return result
		endmethod

		public method setExperienceBarValueIconForCharacter takes ACharacter character, integer length, string valueIcon returns nothing
			local ACharactersSchemaPlayerData playerData = this.characterPlayerData(character)
			if (playerData != 0) then
				call playerData.experienceBar.evaluate().setValueIcon(length, valueIcon)
			endif
		endmethod

		public method setExperienceBarEmptyIconForCharacter takes ACharacter character, integer length, string emptyIcon returns nothing
			local ACharactersSchemaPlayerData playerData = this.characterPlayerData(character)
			if (playerData != 0) then
				call playerData.experienceBar.evaluate().setEmptyIcon(length, emptyIcon)
			endif
		endmethod

		public method setExperienceBarValueIcon takes integer length, string valueIcon returns nothing
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype.setBarValueIconForPlayerDataWithNewOpLimit.evaluate(ACharactersSchemaPlayerData(iterator.data()).experienceBar.evaluate(), length, valueIcon)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method setExperienceBarEmptyIcon takes integer length, string emptyIcon returns nothing
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype.setBarEmptyIconForPlayerDataWithNewOpLimit.evaluate(ACharactersSchemaPlayerData(iterator.data()).experienceBar.evaluate(), length, emptyIcon)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method setHitPointsBarValueIconForCharacter takes ACharacter character, integer length, string valueIcon returns nothing
			local ACharactersSchemaPlayerData playerData = this.characterPlayerData(character)
			if (playerData != 0) then
				call playerData.hitPointsBar.evaluate().setValueIcon(length, valueIcon)
			endif
		endmethod

		public method setHitPointsBarEmptyIconForCharacter takes ACharacter character, integer length, string emptyIcon returns nothing
			local ACharactersSchemaPlayerData playerData = this.characterPlayerData(character)
			if (playerData != 0) then
				call playerData.hitPointsBar.evaluate().setEmptyIcon(length, emptyIcon)
			endif
		endmethod

		public method setHitPointsBarValueIcon takes integer length, string valueIcon returns nothing
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype.setBarValueIconForPlayerDataWithNewOpLimit.evaluate(ACharactersSchemaPlayerData(iterator.data()).hitPointsBar.evaluate(), length, valueIcon)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method setHitPointsBarEmptyIcon takes integer length, string emptyIcon returns nothing
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype.setBarEmptyIconForPlayerDataWithNewOpLimit.evaluate(ACharactersSchemaPlayerData(iterator.data()).hitPointsBar.evaluate(), length, emptyIcon)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method setManaBarValueIconForCharacter takes ACharacter character, integer length, string valueIcon returns nothing
			local ACharactersSchemaPlayerData playerData = this.characterPlayerData(character)
			if (playerData != 0) then
				call playerData.manaBar.evaluate().setValueIcon(length, valueIcon)
			endif
		endmethod

		public method setManaBarEmptyIconForCharacter takes ACharacter character, integer length, string emptyIcon returns nothing
			local ACharactersSchemaPlayerData playerData = this.characterPlayerData(character)
			if (playerData != 0) then
				call playerData.manaBar.evaluate().setEmptyIcon(length, emptyIcon)
			endif
		endmethod

		public method setManaBarValueIcon takes integer length, string valueIcon returns nothing
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype.setBarValueIconForPlayerDataWithNewOpLimit.evaluate(ACharactersSchemaPlayerData(iterator.data()).manaBar.evaluate(), length, valueIcon)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method setManaBarEmptyIcon takes integer length, string emptyIcon returns nothing
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				call thistype.setBarEmptyIconForPlayerDataWithNewOpLimit.evaluate(ACharactersSchemaPlayerData(iterator.data()).manaBar.evaluate(), length, emptyIcon)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		private static method setBarValueIconForPlayerDataWithNewOpLimit takes AMultiboardBar bar, integer length, string valueIcon returns nothing
			call bar.setValueIcon(length, valueIcon)
		endmethod

		private static method setBarEmptyIconForPlayerDataWithNewOpLimit takes AMultiboardBar bar, integer length, string emptyIcon returns nothing
			call bar.setEmptyIcon(length, emptyIcon)
		endmethod

		public method setBarWidths takes real width returns nothing
			local ACharactersSchemaPlayerData playerData = 0
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				set playerData = ACharactersSchemaPlayerData(iterator.data())
				call playerData.experienceBar.evaluate().setAllWidths(width)
				call playerData.hitPointsBar.evaluate().setAllWidths(width)
				call playerData.manaBar.evaluate().setAllWidths(width)
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		public method removeRow takes ACharactersSchemaPlayerData row returns nothing
			call this.m_playerData.remove.evaluate(row)
		endmethod

		public method firstColumnExists takes nothing returns boolean
			return this.m_showPlayerName or this.m_showUnitName or this.m_showLevel
		endmethod

		public method firstColumnString takes ACharacter character returns string
			local string text = ""
			if (this.m_showPlayerName) then
				set text = GetColoredPlayerName(character.player())
			endif
			if (this.m_showUnitName) then
				set text = text + " [" + GetUnitName(character.unit()) + "]"
			endif
			if (this.m_showLevel) then
				if (IsUnitType(character.unit(), UNIT_TYPE_HERO)) then
					set text = text + " - " + this.m_textLevel + " " + I2S(GetHeroLevel(character.unit()))
				// if hero has overtaken an enemy etc.
				else
					set text = text + " - " + this.m_textLevel + " " + I2S(GetUnitLevel(character.unit()))
				endif
			endif
			return text
		endmethod

		public method refresh takes nothing returns nothing
			local AIntegerListIterator iterator = this.m_playerData.begin()
			loop
				exitwhen (not iterator.isValid())
				// renew OpLimit with .evaluate() since the method call is quite long.
				call ACharactersSchemaPlayerData(iterator.data()).refresh.evaluate()
				call iterator.next()
			endloop
			call iterator.destroy()
		endmethod

		private static method triggerActionRefresh takes nothing returns nothing
			local thistype this = thistype(AHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			call this.refresh()
		endmethod

		/**
		 * Shows the multiboard to all players and starts refreshing it.
		 */
		public method show takes nothing returns nothing
			call this.refresh()
			call EnableTrigger(this.m_refreshTrigger)
			call MultiboardDisplay(this.m_multiboard, true)
		endmethod

		/**
		 * Shows the multiboard to only one player and starts refreshing it.
		 * \param user The player it is shown to.
		 */
		public method showForPlayer takes player user returns nothing
			call this.triggerActionRefresh()
			if (not IsTriggerEnabled(this.m_refreshTrigger)) then
				call EnableTrigger(this.m_refreshTrigger)
			endif
			call ShowMultiboardForPlayer(user, this.m_multiboard, true)
		endmethod

		public method hide takes nothing returns nothing
			call MultiboardDisplay(this.m_multiboard, false)
			call DisableTrigger(this.m_refreshTrigger)
		endmethod

		public method hideForPlayer takes player user returns nothing
			call ShowMultiboardForPlayer(user, this.m_multiboard, false)
		endmethod

		private method createRefreshTrigger takes nothing returns nothing
			set this.m_refreshTrigger = CreateTrigger()
			call AHashTable.global().setHandleInteger(this.m_refreshTrigger, 0, this)
			call TriggerRegisterTimerEvent(this.m_refreshTrigger, this.m_refreshRate, true)
			call TriggerAddAction(this.m_refreshTrigger, function thistype.triggerActionRefresh)
			call DisableTrigger(this.m_refreshTrigger)
		endmethod

		/// Call this AFTER character creation/character class selection
		private method createMultiboard takes nothing returns nothing
			local integer i
			local integer column
			set this.m_multiboard = CreateMultiboard()
			call MultiboardDisplay(this.m_multiboard, false)
			call MultiboardSetTitleText(this.m_multiboard, this.m_textTitle)
			set column = this.m_experienceLength + this.m_hitPointsLength + this.m_manaLength
			if (this.firstColumnExists()) then
				set column = column + 1
			endif
			if (this.m_showGold) then
				set this.m_goldColumn = column
				set column = column + 1
			endif
			call MultiboardSetColumnCount(this.m_multiboard, column)
			set i = 0
			loop
				exitwhen (i == bj_MAX_PLAYERS)
				if (ACharacter.playerCharacter(Player(i)) != 0) then
					call this.m_playerData.pushBack(thistype.createPlayerDataWithNewOpLimit.evaluate(Player(i), this, this.m_playerData.size()))
				endif
				set i = i + 1
			endloop
		endmethod

		private static method createPlayerDataWithNewOpLimit takes player whichPlayer, thistype this, integer index returns ACharactersSchemaPlayerData
			return ACharactersSchemaPlayerData.create.evaluate(whichPlayer, this, index)
		endmethod

		/**
		 * Call this method before you use this struct!
		 * Call this after a trigger sleep action, multiboard is created!
		 * Call this AFTER character creation/character class selection
		 * \param refreshRate Should be bigger than 0.0. The periodic interval in seconds which is used to refresh the multiboard rows.
		 * \param showPlayerName If this value is true, the first column is used for the player's name.
		 * \param showUnitName If this value is true, the first column includes the character's unit's name.
		 * \param showLevel If this value is true, the first column includes the character's level.
		 * \param experienceLength The number of columns used for the XP bar.
		 * \param currentExperienceFormula Function which returns the current experience of a hero's level.
		 * \param maxExperienceFormula Function which returns the maximum experience of a hero's level.
		 * \param hitPointsLength The number of columns used for the HP bar.
		 * \param manaLength The number of columns used for the mana bar.
		 * \param showGold If this value is true, a column is created at the end which shows the current gold of the player.
		 * \param textTitle The title text of the multiboard.
		 * \param textLevel The text showing the level of a character.
		 * \param textLeftGame The text which appears when a character is not playing anymore.
		 * \param iconGold The icon for the symbol next to the gold value of a player.
		 * \return Returns a newly created characters scheme.
		 */
		public static method create takes real refreshRate, boolean showPlayerName, boolean showUnitName, boolean showLevel, integer experienceLength, ACharactersSchemeExperienceFormula currentExperienceFormula, ACharactersSchemeExperienceFormula maxExperienceFormula, integer hitPointsLength, integer manaLength, boolean showGold, string textTitle, string textLevel, string textLeftGame, string iconGold returns thistype
			local thistype this = thistype.allocate()
			// construction members
			set this.m_refreshRate = refreshRate
			debug if (refreshRate <= 0) then
				debug call this.staticPrint("Refresh rate is <= 0")
			debug endif
			set this.m_showPlayerName = showPlayerName
			set this.m_showUnitName = showUnitName
			set this.m_showLevel = showLevel
			set this.m_experienceLength = experienceLength
			set this.m_currentExperienceFormula = currentExperienceFormula
			set this.m_maxExperienceFormula = maxExperienceFormula
			set this.m_hitPointsLength = hitPointsLength
			set this.m_manaLength = manaLength
			set this.m_showGold = showGold
			set this.m_textTitle = textTitle
			set this.m_textLevel = textLevel
			set this.m_textLeftGame = textLeftGame
			set this.m_iconGold = iconGold
			// dynamic members
			set this.m_firstColumnWidth = 0.20
			set this.m_goldColumnWidth = 0.04 // must be able to show 1 000 000 gold
			// members
			set this.m_playerData = AIntegerList.create()
			call this.createRefreshTrigger()
			call this.createMultiboard()

			return this
		endmethod

		private method destroyRefreshTrigger takes nothing returns nothing
			call AHashTable.global().destroyTrigger(this.m_refreshTrigger)
			set this.m_refreshTrigger = null
		endmethod

		private method destroyMultiboard takes nothing returns nothing
			call DestroyMultiboard(this.m_multiboard)
			set this.m_multiboard = null
		endmethod

		public method onDestroy takes nothing returns nothing
			loop
				exitwhen (this.m_playerData.empty())
				// the destructor already removes the player data from the list
				call ACharactersSchemaPlayerData(this.m_playerData.front()).destroy.evaluate()
			endloop
			call this.m_playerData.destroy()
			call this.destroyRefreshTrigger()
			call this.destroyMultiboard()
		endmethod
	endstruct

	/**
	 * \brief Stores the data of a single row for one specific player.
	 */
	struct ACharactersSchemaPlayerData
		// construction members
		private player m_player
		private ACharactersScheme m_scheme
		/**
		 * Stores the row number starting with 0 for each player.
		 * If a player has no row because he has no character it stores -1.
		 */
		private integer m_row
		// members
		private AMultiboardBar m_experienceBar
		private AMultiboardBar m_hitPointsBar
		private AMultiboardBar m_manaBar

		/**
		 * \return Returns the player of the row.
		 */
		public method player takes nothing returns player
			return this.m_player
		endmethod

		public method scheme takes nothing returns ACharactersScheme
			return this.m_scheme
		endmethod

		/**
		 * \return Returns the row's index starting with 0.
		 */
		public method row takes nothing returns integer
			return this.m_row
		endmethod

		// members

		public method experienceBar takes nothing returns AMultiboardBar
			return this.m_experienceBar
		endmethod

		public method hitPointsBar takes nothing returns AMultiboardBar
			return this.m_hitPointsBar
		endmethod

		public method manaBar takes nothing returns AMultiboardBar
			return this.m_manaBar
		endmethod

		// methods

		/**
		 * Refreshes the player row. If the character of the player is 0 it automatically destroys the row.
		 * Otherwise it updates all columns of the row.
		 */
		public method refresh takes nothing returns nothing
			local ACharacter character = ACharacter.playerCharacter(this.player())
			local integer row = -1
			local real firstColumnWidth = this.scheme().firstColumnWidth()
			local real goldColumWidth = this.scheme().goldColumWidth()
			local multiboarditem multiboardItem = null
			local string columnString
			if (character != 0) then
				set row = this.row()
				if (this.scheme().firstColumnExists()) then
					set multiboardItem = MultiboardGetItem(this.scheme().multiboard(), row, 0)
					set columnString = this.scheme().firstColumnString(character)
					call MultiboardSetItemValue(multiboardItem, columnString)
					call MultiboardSetItemWidth(multiboardItem, firstColumnWidth)
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
				endif

				if (IsUnitAliveBJ(character.unit())) then
					if (this.scheme().experienceLength() > 0) then
						if (IsUnitType(character.unit(), UNIT_TYPE_HERO)) then
							call this.m_experienceBar.setValue(this.scheme().currentExperienceFormula().evaluate(character.unit()))
							call this.m_experienceBar.setMaxValue(this.scheme().maxExperienceFormula().evaluate(character.unit()))
							// renew OpLimit with .evaluate() since the method call is quite long.
							call thistype.refreshBarWithNewOpLimit.evaluate(this.m_experienceBar)
						endif
					endif

					if (this.scheme().hitPointsLength() > 0) then
						call this.m_hitPointsBar.setValue(GetUnitState(character.unit(), UNIT_STATE_LIFE))
						call this.m_hitPointsBar.setMaxValue(GetUnitState(character.unit(), UNIT_STATE_MAX_LIFE))
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.refreshBarWithNewOpLimit.evaluate(this.m_hitPointsBar)
					endif

					if (this.scheme().manaLength() > 0) then
						call this.m_manaBar.setValue(GetUnitState(character.unit(), UNIT_STATE_MANA))
						call this.m_manaBar.setMaxValue(GetUnitState(character.unit(), UNIT_STATE_MAX_MANA))
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.refreshBarWithNewOpLimit.evaluate(this.m_manaBar)
					endif
				else
					if (this.scheme().hitPointsLength() > 0) then
						call this.m_hitPointsBar.setValue(0)
						call this.m_hitPointsBar.setMaxValue(1)
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.refreshBarWithNewOpLimit.evaluate(this.m_hitPointsBar)
					endif

					if (this.scheme().manaLength() > 0) then
						call this.m_manaBar.setValue(0)
						call this.m_manaBar.setMaxValue(1)
						// renew OpLimit with .evaluate() since the method call is quite long.
						call thistype.refreshBarWithNewOpLimit.evaluate(this.m_manaBar)
					endif
				endif

				if (this.scheme().showGold()) then
					set multiboardItem = MultiboardGetItem(this.scheme().multiboard(), row, this.scheme().goldColumn())
					set columnString = I2S(GetPlayerState(this.player(), PLAYER_STATE_RESOURCE_GOLD))
					call MultiboardSetItemValue(multiboardItem, columnString)
					call MultiboardSetItemWidth(multiboardItem, goldColumWidth)
					call MultiboardReleaseItem(multiboardItem)
					set multiboardItem = null
				endif
			elseif (this.row() != -1) then
				call this.destroy()
			endif
		endmethod

		private static method refreshBarWithNewOpLimit takes AMultiboardBar bar returns nothing
			call bar.refresh()
		endmethod

		/**
		 * Creates a new row for player \p whichPlayer in the multiboard of \p scheme at row \p row.
		 * \return Returns the newly created row.
		 */
		public static method create takes player whichPlayer, ACharactersScheme scheme, integer row returns thistype
			local thistype this = thistype.allocate()
			local multiboarditem multiboardItem
			local string columnString
			local integer column
			set this.m_player = whichPlayer
			set this.m_scheme = scheme
			set this.m_row = row
			call MultiboardSetRowCount(scheme.multiboard(), MultiboardGetRowCount(scheme.multiboard()) + 1)

			if (scheme.firstColumnExists()) then
				set multiboardItem = MultiboardGetItem(scheme.multiboard(), row, 0)
				call MultiboardSetItemStyle(multiboardItem, true, false)
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
			endif

			if (scheme.experienceLength() > 0) then
				if (scheme.firstColumnExists()) then
					set column = 1
				else
					set column = 0
				endif
				// renew OpLimit with .evaluate() since the method call is quite long.
				set this.m_experienceBar = thistype.createBarWithNewOpLimit.evaluate(scheme.multiboard(), column, row, scheme.experienceLength(), 0.0, true)
			endif

			if (scheme.hitPointsLength() > 0) then
				if (scheme.experienceLength() > 0) then
					set column = this.m_experienceBar.firstFreeField()
				elseif (scheme.firstColumnExists()) then
					set column = 1
				else
					set column = 0
				endif
				// renew OpLimit with .evaluate() since the method call is quite long.
				set this.m_hitPointsBar = thistype.createBarWithNewOpLimit.evaluate(scheme.multiboard(), column, row, scheme.hitPointsLength(), 0.0, true)
			endif

			if (scheme.manaLength() > 0) then
				if (scheme.hitPointsLength() > 0) then
					set column = this.m_hitPointsBar.firstFreeField()
				elseif (scheme.experienceLength() > 0) then
					set column = this.m_experienceBar.firstFreeField()
				elseif (scheme.firstColumnExists()) then
					set column = 1
				else
					set column = 0
				endif
				// renew OpLimit with .evaluate() since the method call is quite long.
				set this.m_manaBar = thistype.createBarWithNewOpLimit.evaluate(scheme.multiboard(), column, row, scheme.manaLength(), 0.0, true)
			endif

			if (scheme.showGold()) then
				if (scheme.manaLength() > 0) then
					set column = this.m_manaBar.firstFreeField()
				elseif (scheme.hitPointsLength() > 0) then
					set column = this.m_hitPointsBar.firstFreeField()
				elseif (scheme.experienceLength() > 0) then
					set column = this.m_experienceBar.firstFreeField()
				elseif (scheme.firstColumnExists()) then
					set column = 1
				else
					set column = 0
				endif

				set multiboardItem = MultiboardGetItem(scheme.multiboard(), row, column)
				call MultiboardSetItemStyle(multiboardItem, true, true)
				call MultiboardSetItemIcon(multiboardItem, scheme.iconGold())
				call MultiboardSetItemValue(multiboardItem, "0")
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
			endif

			return this
		endmethod

		private static method createBarWithNewOpLimit takes multiboard whichMultiboard, integer column, integer row, integer length, real refreshRate, boolean horizontal returns AMultiboardBar
			return AMultiboardBar.create(whichMultiboard, column, row, length, refreshRate, horizontal)
		endmethod

		/**
		 * Clears the player row and removes the instance from the player data of the corresponding scheme since it should not be refreshed anymore.
		 */
		public method onDestroy takes nothing returns nothing
			local multiboarditem multiboardItem = null
			if (this.scheme().firstColumnExists()) then
				set multiboardItem = MultiboardGetItem(this.scheme().multiboard(), this.row(), 0)
				call MultiboardSetItemValue(multiboardItem, this.scheme().textLeftGame())
				call MultiboardSetItemWidth(multiboardItem, this.scheme().firstColumnWidth())
				call MultiboardReleaseItem(multiboardItem)
				set multiboardItem = null
			endif

			if (this.scheme().experienceLength() > 0) then
				call this.m_experienceBar.destroy()
				set this.m_experienceBar = 0
			endif

			if (this.scheme().hitPointsLength() > 0) then
				call this.m_hitPointsBar.destroy()
				set this.m_hitPointsBar = 0
			endif

			if (this.scheme().manaLength() > 0) then
				call this.m_manaBar.destroy()
				set this.m_manaBar = 0
			endif

			call this.scheme().removeRow(this)

			set this.m_player = null
		endmethod
	endstruct

endlibrary
/**
 * New grimoire system:
 * The new grimoire system is based on much more different abilities than the old one.
 * Indeed there is a single skilling ability for each single level of a spell. This is required since only by creating a new ability we can change its icon and therefore show the ability's level in each one which emulates Warcraft III's hero skills some kind.
 * Spells can be added to favourites and therefore be removed from the grimoire sub menu by using the "spell book" bug/exploit that abilities can be hidden, so each spell ability needs a corresponding favourites ability based on "spell book" which contains the spell ability and has the same spell book id as the grimoire sub menu ability.
 * \note Warcraft III's hero skills simply cannot be used since they are limited up to 5.
 */
library StructGameGrimoire requires Asl, StructGameCharacter, StructGameSpell, StructGameGrimoireSpell

	/**
	 * \brief The grimoire of a character allows the player to skill any abilities of the character. It avoids a limit of 6 hero abilities.
	 *
	 * \todo At its current state \ref updateUi() may be called too many times. Please consider that the order of buttons in grimoire should always be equal regardless of which buttons became unavailable.
	 */
	struct Grimoire extends ASpell
		public static constant integer maxSpells = 15
		public static constant integer spellsPerPage = 8
		public static constant integer abilityId = 'A0AP'
		public static constant integer spellsAbilityId = 'A02Z'
		/**
		 * Dummy ability ID to specify the icon's position.
		 */
		public static constant integer dummyAbilityId = 'A17O'
		/**
		 * Dummy hero ability ID. This ability is disabled for all players but must be added to each character to show the skillpoints in the hero icon.
		 */
		public static constant integer dummyHeroAbilityId = 'A17P'
		/**
		 * The shortcut is required to reopen the grimoire when it its closed automatically.
		 */
		public static constant string shortcut = "Z"
		public static constant integer maxFavourites = 4
		public static constant integer ultimate0Level = 12
		public static constant integer ultimate1Level = 25
		// members
		private integer m_page
		private boolean m_pageIsShown
		private integer m_heroLevel
		private integer m_skillPoints
		private AIntegerVector m_favourites
		/**
		 * Contains all \ref Spell instances which are learned.
		 */
		private AIntegerVector m_learnedSpells
		private Spell m_currentSpell
		/**
		 * Contains all \ref Spell instances which belong to the grimoire but need not necessarily be learned.
		 */
		private AIntegerVector m_spells
		private NextPage m_spellNextPage
		private PreviousPage m_spellPreviousPage
		private SetMax m_spellSetMax
		private Unlearn m_spellUnlearn
		private Increase m_spellIncrease
		private Decrease m_spellDecrease
		private AddToFavourites m_spellAddToFavourites
		private RemoveFromFavourites m_spellRemoveFromFavourites
		private BackToGrimoire m_spellBackToGrimoire
		private trigger m_levelTrigger
		/**
		 * Since Warcraft III has the bug that when the game is loaded abilities in the spell book are reset to level 1 they have to be changed manually on each map loading.
		 */
		private trigger m_loadTrigger

		/**
		 * The currently visible \ref GrimoireSpell instances which are shown in the UI.
		 * Might also contain 0 entries depending on the spell!
		 */
		private AIntegerVector m_uiGrimoireSpells

		// members

		/*
		public method unit takes nothing returns unit
			return this.m_unit
		endmethod
		*/

		/**
		 * \return Returns the number of pages which depends on \ref spells() and \ref spellsPerPage.
		 */
		public method pages takes nothing returns integer
			local integer result = this.m_spells.size() / thistype.spellsPerPage
			// add extra page for remaining spells
			if (ModuloInteger(this.m_spells.size(), thistype.spellsPerPage) > 0) then
				set result = result + 1
			endif
			// at least one page
			if (result == 0) then
				set result = 1
			endif
			return result
		endmethod

		/**
		 * \return Returns the currently open page.
		 */
		public method page takes nothing returns integer
			return this.m_page
		endmethod

		/**
		 * \return Returns true if the page with spells is shown. Otherwise it returns false which means that a single spell is open.
		 */
		public method pageIsShown takes nothing returns boolean
			return this.m_pageIsShown
		endmethod

		/**
		 * \return Returns the number of skill points the character does have.
		 */
		public method skillPoints takes nothing returns integer
			return this.m_skillPoints
		endmethod

		/**
		 * \return Returns the total number of skill points. The unused plus the used. It includes the one skill point for the default spell!
		 */
		public method totalSkillPoints takes nothing returns integer
			local integer result = this.skillPoints()
			local integer i = 0
			loop
				exitwhen (i == this.m_learnedSpells.size())
				set result = result + Spell(this.m_learnedSpells[i]).level()
				set i = i + 1
			endloop

			return result
		endmethod

		/// \return Returns vector with \ref ASpell instances.
		public method favourites takes nothing returns AIntegerVector
			return this.m_favourites
		endmethod

		/**
		 * \return Returns the currently enabled spell.
		 * \note This value can be 0 if no spell is enabled at all.
		 */
		public method currentSpell takes nothing returns Spell
			return this.m_currentSpell
		endmethod

		// methods

		/**
		 * Readds all abilities to the character's unit.
		 * Useful when character had been morphed for some time.
		 * \param table Has to be a table with ability id - level entries (parent key - 0, child key - ability id, value - level).
		 * \sa Grimoire#spellLevels
		 */
		public method readd takes AGlobalHashTable table returns nothing
			local Spell spell
			local integer level
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				set spell = Spell(this.m_spells[i])
				set level = table.integer(0, spell.ability())
				// only add if it has been there before!
				if (level > 0) then
					if (this.m_favourites.contains(spell)) then
						call UnitRemoveAbility(this.character().unit(), spell.favouriteAbility())
						call spell.add()
						call spell.setLevel(level)
					else
						call UnitAddAbility(this.character().unit(), spell.favouriteAbility())
						call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), false)
						call spell.setLevel(level)
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		/// \return Returns a newly created hash table with ability id - level entries  (parent key - 0, child key - ability id, value - level).
		public method spellLevels takes nothing returns AGlobalHashTable
			local AGlobalHashTable table = AGlobalHashTable.create()
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				call table.setInteger(0, Spell(this.m_spells[i]).ability(), Spell(this.m_spells[i]).level())
				set i = i + 1
			endloop
			return table
		endmethod

		/**
		 * \return Returns the number of learned spells (spells which have level of at least 1).
		 */
		public method learnedSpells takes nothing returns integer
			return this.m_learnedSpells.size()
		endmethod

		/// \note Only use when making a map transition!
		public method clearLearnedSpells takes nothing returns nothing
			call this.m_learnedSpells.clear()
		endmethod

		/// \note Only use when making a map transition!
		public method clearSpells takes nothing returns nothing
			call this.m_spells.clear()
		endmethod

		/// \note Only use when making a map transition!
		public method clearUiSpells takes nothing returns nothing
			call this.m_uiGrimoireSpells.clear()
		endmethod

		/**
		 * Updates all buttons properly.
		 * Central UI update is much easier to maintain!
		 * \note Add all shown spells to m_uiGrimoireSpells!
		 */
		public method updateUi takes nothing returns nothing
			local integer i = 0
			local integer index = 0
			local unit whichUnit = this.character().unit()
			/*
			 * Remove all old buttons before adding new ones.
			 */
			set i = 0
			loop
				exitwhen (i == this.m_uiGrimoireSpells.size())
				if (this.m_uiGrimoireSpells[i] != 0) then
					call GrimoireSpell(this.m_uiGrimoireSpells[i]).hide(whichUnit)
				endif
				set i = i + 1
			endloop
			call this.m_uiGrimoireSpells.clear()

			if (this.pageIsShown()) then
				call this.m_spellPreviousPage.show(whichUnit)
				call this.m_uiGrimoireSpells.pushBack(this.m_spellPreviousPage)
				call this.m_spellNextPage.show(whichUnit)
				call this.m_uiGrimoireSpells.pushBack(this.m_spellNextPage)

				set i = 0
				loop
					exitwhen (i == thistype.spellsPerPage)
					set index = Index2D(this.page(), i, thistype.spellsPerPage)

					if (index >= this.m_spells.size()) then
						exitwhen (true)
					endif
					if (Spell(this.m_spells[index]).available()) then
						call Spell(this.m_spells[index]).showGrimoireEntry()
						call this.m_uiGrimoireSpells.pushBack(Spell(this.m_spells[index]).grimoireEntry())
						debug if (Spell(this.m_spells[index]).grimoireEntry() == 0) then
							debug call Print("Spell " + GetAbilityName(Spell(this.m_spells[index]).ability()) + " is missing grimoire entry for level " + I2S(Spell(this.m_spells[index]).level()))
						debug endif
					debug else
						debug call Print("Spell " + Spell(this.m_spells[index]).name() + " is not available!")
					endif
					set i = i + 1
				endloop
			/*
			 * Display current spell.
			 */
			else
				// show in correct order, always show the spell entry itself as last one since it will become the last one whenever its level changes!
				call this.currentSpell().showGrimoireEntry() // show info about current level
				call this.m_uiGrimoireSpells.pushBack(this.currentSpell().grimoireEntry())

				// show an ability to return back to the spells overview
				// in fact the grimoire spell itself has the same functionality but it is not recognizable by the user
				call this.m_spellBackToGrimoire.show(whichUnit)
				call this.m_uiGrimoireSpells.pushBack(this.m_spellBackToGrimoire)

				if (this.currentSpell().isSkillable()) then
					call this.m_spellSetMax.show(whichUnit)
					call this.m_uiGrimoireSpells.pushBack(this.m_spellSetMax)
					call this.m_spellIncrease.show(whichUnit)
					call this.m_uiGrimoireSpells.pushBack(this.m_spellIncrease)
				endif
				if (this.currentSpell().level() > 0) then
					call this.m_spellUnlearn.show(whichUnit)
					call this.m_uiGrimoireSpells.pushBack(this.m_spellUnlearn)
					call this.m_spellDecrease.show(whichUnit)
					call this.m_uiGrimoireSpells.pushBack(this.m_spellDecrease)

					if (this.m_favourites.contains(this.currentSpell())) then
						call this.m_spellRemoveFromFavourites.show(whichUnit)
						call this.m_uiGrimoireSpells.pushBack(this.m_spellRemoveFromFavourites)
					elseif (this.m_favourites.size() < thistype.maxFavourites) then
						call this.m_spellAddToFavourites.show(whichUnit)
						call this.m_uiGrimoireSpells.pushBack(this.m_spellAddToFavourites)
					debug else
						debug call Print("Spell is not part of favorites but favorites are full.")
					endif
				debug else
					debug call Print("Spell is level 0: " + GetObjectName(this.currentSpell().ability()))
				endif
			endif
		endmethod

		/**
		 * Sets the character's hero level to \p heroLevel.
		 * This does not actually change any hero level but stores the current hero level which is required for reacting on level up events.
		 * Since level up events may occur once if multiple levels have been gained too this value allows you to check what was the old level.
		 * \note Only set this when absolutely necessary for example when restoring characters from another map.
		 */
		public method setHeroLevel takes integer heroLevel returns nothing
			set this.m_heroLevel = heroLevel
		endmethod

		public method heroLevel takes nothing returns integer
			return this.m_heroLevel
		endmethod

		private method setGrimoireAbilityToSkillPoints takes integer skillPoints returns nothing
			if (skillPoints < 0) then
				call SetUnitAbilityLevel(this.character().unit(), this.ability(), 0)
			// use + 1 since the first level is for 0 skill points
			elseif (skillPoints > 99) then
				call SetUnitAbilityLevel(this.character().unit(), this.ability(), 100)
			else
				call SetUnitAbilityLevel(this.character().unit(), this.ability(), skillPoints + 1)
			endif
		endmethod

		/**
		 * The ability for the grimoire must have level 0 - 100 for displaying the number of available skill points.
		 * \param skillPoints The exact number of skill points which are assigne to the grimoire.
		 * \param updateUi If this parameter is true, the user interface is updated after setting the skill points. Otherwise, it stays the same as before. Updating the user interface might take some time.
		 */
		public method setSkillPoints takes integer skillPoints, boolean updateUi returns nothing
			set this.m_skillPoints = skillPoints
			call this.setGrimoireAbilityToSkillPoints(skillPoints)

			/**
			 * This is necessary to show the skill points in the hero icon.
			 */
			call ModifyHeroSkillPoints(this.character().unit(), bj_MODIFYMETHOD_SET, skillPoints)

			/*
			 * Update the User Interface. The selected skill might become skillable!
			 */
			 if (updateUi) then
				call this.updateUi()
			endif
		endmethod

		public method removeSkillPoints takes integer skillPoints, boolean updateUi returns nothing
			call this.setSkillPoints(IMaxBJ(0, this.m_skillPoints - skillPoints), updateUi)
		endmethod

		/**
		 * Adds skill points to grimoire.
		 * \param skillPoints The number of skill points to be added. If this value is negative, the skill points will be removed.
		 */
		public method addSkillPoints takes integer skillPoints, boolean updateUi returns nothing
			if (skillPoints == 0) then
				return
			elseif (skillPoints < 0) then
				call this.removeSkillPoints(-1 * skillPoints, updateUi)
				return
			endif
			call this.setSkillPoints(this.m_skillPoints + skillPoints, updateUi)
		endmethod

		/**
		 * Gets a grimoire spell at the specified index.
		 * \param index The index of the returned spell.
		 * \return Returns the grimoire spell at the given index.
		 */
		public method spell takes integer index returns Spell
			return this.m_spells[index]
		endmethod

		// TODO slow
		public method spellIndex takes Spell spell returns integer
			return this.m_spells.find(spell)
		endmethod

		/// TODO slow, remove!
		public method spellByAbilityId takes integer abilityId returns Spell
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).ability() == abilityId) then
					return Spell(this.m_spells[i])
				endif
				set i = i + 1
			endloop
			return 0
		endmethod

		/**
		 * \return Returns the number of all spells which belong to the grimoire but are not necessarily skilled at any level.
		 */
		public method spells takes nothing returns integer
			return this.m_spells.size()
		endmethod

		private method learnFavouriteSpell takes Spell spell returns nothing
			local integer favouriteAbility = spell.favouriteAbility()
			debug call Print("Learning favorite spell " + GetAbilityName(spell.ability()))
			call this.m_favourites.pushBack(spell)
			call this.m_learnedSpells.pushBack(spell)
			call spell.add()
			call spell.setLevel(1)
			call spell.onLearn.evaluate()
		endmethod

		private method unlearnFavouriteSpell takes Spell spell returns nothing
			debug call Print("Unlearning favorite spell " + GetAbilityName(spell.ability()))
			debug if (not this.m_favourites.contains(spell)) then
			debug call Print("Spell is not part of favorites!")
			debug endif
			call spell.onUnlearn.evaluate()
			call this.m_favourites.remove(spell)
			call this.m_learnedSpells.remove(spell)
			call spell.remove()
		endmethod

		private method learnSpell takes Spell spell returns nothing
			call UnitAddAbility(this.character().unit(), spell.favouriteAbility())
			call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), false)
			call this.m_learnedSpells.pushBack(spell)
			call spell.setLevel(1)
			// indicate to player where the spell was moved to
			call this.character().displayMessage(ACharacter.messageTypeInfo, Format(tre("%1% in Zauberfähigkeiten verschoben.", "Moved %1% into spell abilities.")).s(GetAbilityName(spell.ability())).result())
			call spell.onLearn.evaluate()
		endmethod

		private method unlearnSpell takes Spell spell returns nothing
			debug call Print("Unlearning spell " + GetAbilityName(spell.ability()))
			debug if (this.m_favourites.contains(spell)) then
			debug call Print("Spell is part of favorites!")
			debug endif
			call this.m_learnedSpells.remove(spell)
			call spell.onUnlearn.evaluate()
			call UnitRemoveAbility(this.character().unit(), spell.favouriteAbility())
			call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), true)
			call spell.remove()
		endmethod

		/**
		 * The spell is being removed from the unit only.
		 * It remains in \ref favorites() if it is a favorite spell.
		 */
		private method removeSpellFromUnit takes Spell spell returns nothing
			if (this.m_favourites.contains(spell)) then
				call spell.remove()
			else
				call UnitRemoveAbility(this.character().unit(), spell.favouriteAbility())
				call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), true)
				call spell.remove()
			endif
		endmethod

		/**
		 * Adds \p spell to the favorites of the grimoire.
		 * \param spell The spell which is added to the favorites.
		 * \return Returns true if the spell has been added to the favorites successfully. Otherwise it returns false.
		 */
		public method addFavouriteSpell takes Spell spell returns boolean
			local integer level = spell.level()
			local integer favouriteAbility = spell.favouriteAbility()
			if (this.m_favourites.size() == thistype.maxFavourites) then
				return false
			endif
			call this.m_favourites.pushBack(spell)
			call UnitRemoveAbility(this.character().unit(), favouriteAbility)
			call spell.add()
			call spell.setLevel(level)

			return true
		endmethod

		public method removeFavouriteSpell takes Spell spell returns boolean
			local integer level = spell.level()
			if (not this.m_favourites.contains(spell)) then
				return false
			endif
			call this.m_favourites.remove(spell)
			call spell.remove()
			call UnitAddAbility(this.character().unit(), spell.favouriteAbility())
			call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), false)
			call spell.setLevel(level)

			return true
		endmethod

		public method setSpellLevelWithoutConditions takes Spell spell, integer level, boolean updateUi returns boolean
			local integer requiredSkillPoints = level - spell.level()

			debug call this.print("Set spell level to " + I2S(level))

			if (requiredSkillPoints == 0) then
				debug call this.print("Requires no skill points!")
				return true
			endif

			if (requiredSkillPoints < 0) then
				call this.addSkillPoints(-1 * requiredSkillPoints, false)
				if (level == 0) then
					if (this.m_favourites.contains(spell)) then
						call this.unlearnFavouriteSpell(spell)
					else
						call this.unlearnSpell(spell)
					endif
				else
					call spell.setLevel(level)
				endif
			else
				call this.removeSkillPoints(requiredSkillPoints, false)

				if (spell.level() == 0) then
					if (this.m_favourites.size() < thistype.maxFavourites and not spell.isPassive()) then
						call this.learnFavouriteSpell(spell)
					else
						call this.learnSpell(spell)
					endif
				endif

				debug call this.print("Applying spell level")
				call spell.setLevel(level)
			endif

			if (updateUi) then
				call this.updateUi()
			endif

			return true
		endmethod

		/// For internal usage (Grimoire.autoSkill).
		private method setSpellLevelByIndexWithoutConditions takes integer index, integer level, boolean updateUi returns boolean
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellLevelByIndexWithoutConditions", "Wrong spell index: " + I2S(index) + ".")
				return false
			endif
endif
			return this.setSpellLevelWithoutConditions(this.m_spells[index], level, updateUi)
		endmethod

		public method setSpellAvailable takes Spell spell, boolean available, boolean updateUi returns nothing
			call spell.setAvailable(available)

			if (updateUi) then
				call this.updateUi()
			endif
		endmethod

		public method setSpellAvailableByIndex takes integer index, boolean available, boolean updateUi returns nothing
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellAvailableByIndex", "Wrong spell index: " + I2S(index) + ".")
				return
			endif
endif

			call this.setSpellAvailable(Spell(this.m_spells[index]), available, updateUi)
		endmethod

		/**
		 * This does neither unlearn nor completely remove spells from the grimoire.
		 * It just clears the spells from the character's unit.
		 * This can be useful before casting dummy spells.
		 * It also removes the grimoire spell itself from the unit.
		 */
		public method removeAllSpellsFromUnit takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				call this.removeSpellFromUnit(Spell(this.m_spells[i]))
				set i = i + 1
			endloop
			call UnitRemoveAbility(this.character().unit(), this.ability())
		endmethod

		public method setSpellLevel takes Spell spell, integer level, boolean updateUi returns boolean
			if (not spell.isSkillableTo(level)) then
				return false
			endif

			return this.setSpellLevelWithoutConditions(spell, level, updateUi)
		endmethod

		public method setSpellLevelByIndex takes integer index, integer level, boolean updateUi returns boolean
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellLevelByIndex", "Wrong spell index: " + I2S(index) + ".")
				return false
			endif
endif
			return this.setSpellLevel(Spell(this.m_spells[index]), level, updateUi)
		endmethod

		public method setSpellMaxLevel takes Spell spell, boolean updateUi returns boolean
			return this.setSpellLevel(spell, spell.getMaxLevel(), updateUi)
		endmethod

		public method setSpellMaxLevelByIndex takes integer index, boolean updateUi returns boolean
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellMaxLevelByIndex", "Wrong spell index: " + I2S(index) + ".")
				return false
			endif

			if (Spell(this.m_spells[index]).getMaxLevel() <= 0) then
				call this.printMethodError("setSpellMaxLevelByIndex", "Max level is <= 0 " + I2S(Spell(this.m_spells[index]).getMaxLevel()))
			endif
endif
			return this.setSpellMaxLevel(Spell(this.m_spells[index]), updateUi)
		endmethod

		/// Adds spell \p spell to grimoire. If \p spellType is \ref Spell.spellTypeDefault it will be added with level 1.
		public method addSpell takes Spell spell, boolean updateUi returns nothing
			debug if (this.m_spells.contains(spell)) then
			debug call Print("Contains already spell: " + GetAbilityName(spell.ability()))
			debug endif

			call this.m_spells.pushBack(spell)

			if (spell.spellType() == Spell.spellTypeDefault) then
				call this.setSpellMaxLevelByIndex(this.m_spells.backIndex(), false)
			endif

			if (updateUi) then
				call this.updateUi()
			endif
		endmethod

		public method removeSpellByIndex takes integer index, boolean updateUi returns boolean
			local Spell spell = 0
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("removeSpellByIndex", "Wrong spell index: " + I2S(index) + ".")
				return false
			endif
endif
			set spell = Spell(this.m_spells[index])
static if (DEBUG_MODE) then
			if (spell.spellType() == Spell.spellTypeDefault) then
				call this.print("Warning: Removing default spell " + GetObjectName(spell.ability()) + ".")
			endif
endif
			if (spell.level() > 0) then
				if (this.m_favourites.contains(spell)) then
					call this.unlearnFavouriteSpell(spell)
				else
					call this.unlearnSpell(spell)
				endif
			endif
			call this.m_spells.erase(index)

			if (updateUi) then
				call this.updateUi()
			endif

			return true
		endmethod

		/**
		 * More performant way of adding multiple spells since it does only update the grimoire GUI once at the end.
		 * Adds all \ref Spell instances from \p integerVector to the grimoire if it does not already contain such an entry.
		 * Afterwards it updates the UI and destroys the vector but only if specified.
		 * \param destroyVector If this value is true the vector will be destroyed after being used.
		 */
		public method addSpells takes AIntegerVector integerVector, boolean destroyVector returns nothing
			local integer i = 0
			loop
				exitwhen (i == integerVector.size())
				// do not add spells twice
				if (not this.m_spells.contains(Spell(integerVector[i]))) then
					call this.addSpell(Spell(integerVector[i]), false)
				endif
				set i = i + 1
			endloop
			// update UI once which should improve the performance massively if the vector is big
			call this.updateUi()
			if (destroyVector) then
				call integerVector.destroy()
			endif
		endmethod

		public method addClericSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.cleric()), true)
		endmethod

		public method addNecromancerSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.necromancer()), true)
		endmethod

		public method addDruidSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.druid()), true)
		endmethod

		public method addKnightSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.knight()), true)
		endmethod

		public method addDragonSlayerSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.dragonSlayer()), true)
		endmethod

		public method addRangerSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.ranger()), true)
		endmethod

		public method addElementalMageSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.elementalMage()), true)
		endmethod

		public method addWizardSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.wizard()), true)
		endmethod

		public method addClassSpells takes AClass class returns nothing
			if (class == Classes.cleric()) then
				call this.addClericSpells()
			elseif (class == Classes.necromancer()) then
				call this.addNecromancerSpells()
			elseif (class == Classes.druid()) then
				call this.addDruidSpells()
			elseif (class == Classes.knight()) then
				call this.addKnightSpells()
			elseif (class == Classes.dragonSlayer()) then
				call this.addDragonSlayerSpells()
			elseif (class == Classes.ranger()) then
				call this.addRangerSpells()
			elseif (class == Classes.elementalMage()) then
				call this.addElementalMageSpells()
			elseif (class == Classes.wizard()) then
				call this.addWizardSpells()
			endif
		endmethod

		public method addClassSpellsFromCharacter takes Character character returns nothing
			local AIntegerVector spells = AIntegerVector.create()
			local Spell basicSpell = 0
			local integer i = 0
			loop
				exitwhen (i == character.classSpells().size())
				// do not add spells twice
				call spells.pushBack(Spell(character.classSpells()[i]))
				if (Spell(character.classSpells()[i]).spellType() == Spell.spellTypeDefault) then
					set basicSpell = Spell(character.classSpells()[i])
				endif
				set i = i + 1
			endloop
			call this.addSpells(spells, true)
			// the basic spell has to be learned from the beginning
			if (basicSpell != 0) then
				call this.setSpellLevel(basicSpell, 1, false)
			endif
		endmethod

		public method addCharacterClassSpells takes nothing returns nothing
			call this.addClassSpells(this.character().class())
		endmethod

		/**
		 * Adds spells of all available game classes to the grimoire.
		 * \note Note that already added class spells will be added once again!
		 * @note Use \ref Grimoire.addAllOtherClassSpells to avoid this.
		 * \sa Grimoire.addAllOtherClassSpells
		 */
		public method addAllClassSpells takes nothing returns nothing
			call this.addClassSpells(Classes.cleric())
			call this.addClassSpells(Classes.necromancer())
			call this.addClassSpells(Classes.druid())
			call this.addClassSpells(Classes.knight())
			call this.addClassSpells(Classes.dragonSlayer())
			call this.addClassSpells(Classes.ranger())
			call this.addClassSpells(Classes.elementalMage())
			call this.addClassSpells(Classes.wizard())
		endmethod

		/**
		 * Adds spells of all available game classes to the grimoire without the class spells of the grimoire's character class.
		 * \sa Grimoire.addAllClassSpells
		 */
		public method addAllOtherClassSpells takes nothing returns nothing
			call this.addSpells(Spell.nonCharacterClassSpells(this.character()), true)
		endmethod

		public method removeClassSpells takes AClass class, boolean updateUi returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).class() == class) then
					call this.removeSpellByIndex(i, false)
				endif
				set i = i + 1
			endloop
			if (updateUi) then
				call this.updateUi()
			endif
		endmethod

		public method removeCharacterClassSpells takes boolean updateUi returns nothing
			call this.removeClassSpells(this.character().class(), updateUi)
		endmethod

		public method removeAllClassSpells takes boolean updateUi returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).class() != 0) then
					call this.removeSpellByIndex(i, false)
				endif
				set i = i + 1
			endloop
			if (updateUi) then
				call this.updateUi()
			endif
		endmethod

		public method removeAllOtherClassSpells takes boolean updateUi returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).class() != this.character().class()) then
					call this.removeSpellByIndex(i, false)
				endif
				set i = i + 1
			endloop
			if (updateUi) then
				call this.updateUi()
			endif
		endmethod

		public method showSpell takes nothing returns nothing
			set this.m_pageIsShown = false
			call this.updateUi()
		endmethod

		public method setCurrentSpell takes Spell spell returns nothing
			set this.m_currentSpell = spell
			call this.showSpell()
		endmethod

		public method increaseSpell takes nothing returns boolean
			return this.setSpellLevel(this.currentSpell(), this.currentSpell().level() + 1, true)
		endmethod

		public method decreaseSpell takes nothing returns boolean
			return this.setSpellLevel(this.currentSpell(), this.currentSpell().level() - 1, true)
		endmethod

		public method addSpellToFavourites takes nothing returns boolean
			local boolean result = this.addFavouriteSpell(this.currentSpell())
			call this.updateUi()
			return result
		endmethod

		public method removeSpellFromFavourites takes nothing returns boolean
			local boolean result = this.removeFavouriteSpell(this.currentSpell())
			call this.updateUi()
			return result
		endmethod

		public method showPage takes nothing returns nothing
			set this.m_pageIsShown = true
			call this.updateUi()
		endmethod

		public method setPage takes integer page returns boolean
			if (page < 0 or page >= this.pages()) then
				debug call this.print("Warning: Wrong page value " + I2S(page) + ", maximum is " + I2S(this.pages() - 1))
				return false
			endif
			if (page == this.page()) then
				return true
			endif
			set this.m_page = page
			call this.character().displayMessage(ACharacter.messageTypeInfo, Format(tre("Seite %1%/%2%", "Page %1%/%2%")).i(page + 1).i(this.pages()).result())
			call this.showPage()
			return true
		endmethod

		public method increasePage takes nothing returns boolean
			if (this.page() + 1 >= this.pages()) then
				return this.setPage(0)
			else
				return this.setPage(this.page() + 1)
			endif
		endmethod

		public method decreasePage takes nothing returns boolean
			if (this.page() - 1 < 0) then
				return this.setPage(this.pages() - 1)
			else
				return this.setPage(this.page() - 1)
			endif
		endmethod

		public method enableLevelTrigger takes nothing returns nothing
			call EnableTrigger(this.m_levelTrigger)
		endmethod

		public method disableLevelTrigger takes nothing returns nothing
			call DisableTrigger(this.m_levelTrigger)
		endmethod

		private static method triggerConditionLevel takes nothing returns boolean
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			return GetTriggerUnit() == this.character().unit()
		endmethod

		private static method triggerActionLevel takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			local integer newLevel = GetHeroLevel(GetTriggerUnit())
			local integer oldLevel = this.heroLevel()
			local integer levels = newLevel - oldLevel
			local Character character = Character(this.character())

			call this.addSkillPoints(MapSettings.levelSkillPoints() * levels, true)
			debug call Print("Levels: " + I2S(levels))

			if (oldLevel < thistype.ultimate0Level and newLevel >= thistype.ultimate0Level) then
				call character.displayHint(Format(tre("Sie haben Stufe %1% erreicht. Der erste Ultimativzauber kann nun erlernt werden.", "You have reached level %1%. The first ultimate spell can be learned now.")).i(thistype.ultimate0Level).result())
			endif

			if (oldLevel < thistype.ultimate1Level and newLevel >= thistype.ultimate1Level) then
				call character.displayHint(Format(tre("Sie haben Stufe %1% erreicht. Der zweite Ultimativzauber kann nun erlernt werden.", "You have reached level %1%. The second ultimate spell can be learned now.")).i(thistype.ultimate1Level).result())
			endif

			call this.setHeroLevel(newLevel)

			// reached last level TODO: maybe we should give him a little present
			if (newLevel == MapSettings.maxLevel()) then
				call character.displayFinalLevel(tre("Sie haben die letzte Stufe erreicht.", "You have reached the final level."))
				call character.displayFinalLevelToAllOthers(Format(tre("%1% hat die letzte Stufe erreicht.", "%1% has reached the final level.")).s(character.name()).result())
			endif
		endmethod

		private method createLevelTrigger takes nothing returns nothing
			set this.m_levelTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_levelTrigger, EVENT_PLAYER_HERO_LEVEL)
			call TriggerAddCondition(this.m_levelTrigger, Condition(function thistype.triggerConditionLevel))
			call TriggerAddAction(this.m_levelTrigger, function thistype.triggerActionLevel)
			call DmdfHashTable.global().setHandleInteger(this.m_levelTrigger, 0, this)
		endmethod

		/// Only update the UI automatically when it is no map transition. Otherwise the order has to be specified by \ref MapChanger.
		private static method triggerConditionLoad takes nothing returns boolean
			return not IsMapFlagSet(MAP_RELOADED)
		endmethod

		/**
		 * Updates the ability levels of all non favorite spells. The ability levels in a spellbook are lost after a load.
		 * This is a Warcrat III bug.
		 * Reorders the icon positions as well if possible. After a load some icon positions might be wrong. Another bug of Warcraft III.
		 */
		public method updateUiAfterLoad takes nothing returns nothing
			local boolean hadGrimoireAbility = false
			local boolean hadBackpackAbility = false
			local boolean hadSpellsAbility = false
			local AIntegerVector favoriteLevels = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_learnedSpells.size())
				/*
				 * Favorite spells still have the proper levels.
				 */
				if (not this.m_favourites.contains(Spell(this.m_learnedSpells[i]))) then
					call Spell(this.m_learnedSpells[i]).setLevel(Spell(this.m_learnedSpells[i]).savedLevel())
					debug call Print("Updating level of spell " + GetAbilityName(Spell(this.m_learnedSpells[i]).ability()) + " to level " + I2S(Spell(this.m_learnedSpells[i]).savedLevel()))
				endif
				set i = i + 1
			endloop
			debug call Print("Learned spells count: " + I2S(this.m_learnedSpells.size()))
			debug call Print("Total spells count: " + I2S(this.spells()))
			debug call Print("Loaded game")

			/*
			 * Readd normal unit abilities.
			 */
			/*
			call UnitRemoveAbility(this.character().unit(), 'Aatk')
			call UnitRemoveAbility(this.character().unit(), 'Amov')
			call UnitAddAbility(this.character().unit(), 'Aatk')
			call UnitAddAbility(this.character().unit(), 'Amov')
			*/
			// TODO patrol, stop

			// remove favorite abilities
			set favoriteLevels = AIntegerVector.create()
			set i = 0
			loop
				exitwhen (i == this.m_favourites.size())
				call favoriteLevels.pushBack(Spell(this.m_favourites[i]).level())
				call Spell(this.m_favourites[i]).remove()
				set i = i + 1
			endloop

			/*
			 * Readd backpack, grimoire and spells abilities to fix their icon positions.
			 * TODO does not work
			 */
			set hadGrimoireAbility = GetUnitAbilityLevel(this.character().unit(), Grimoire.abilityId) > 0
			set hadBackpackAbility = GetUnitAbilityLevel(this.character().unit(), 'A015') > 0
			set hadSpellsAbility = GetUnitAbilityLevel(this.character().unit(), 'A02Z') > 0

			if (hadGrimoireAbility) then
				call UnitRemoveAbility(this.character().unit(), Grimoire.abilityId)
			endif

			if (hadBackpackAbility) then
				call UnitRemoveAbility(this.character().unit(), 'A015')
			endif

			if (hadSpellsAbility) then
				call UnitRemoveAbility(this.character().unit(), 'A02Z')
			endif

			// readd favorite abilities
			set i = 0
			loop
				exitwhen (i == this.m_favourites.size())
				call Spell(this.m_favourites[i]).add()
				call Spell(this.m_favourites[i]).setLevel(favoriteLevels[i])
				set i = i + 1
			endloop
			call favoriteLevels.destroy()

			// TODO test after adding the spells
			// add at the correct position
			if (hadGrimoireAbility) then
				call UnitAddAbility(this.character().unit(), Grimoire.abilityId)
			endif

			if (hadBackpackAbility) then
				call UnitAddAbility(this.character().unit(), 'A015')
			endif

			if (hadSpellsAbility) then
				call UnitAddAbility(this.character().unit(), 'A02Z')
			endif

			// make sure the level is correct
			call this.setGrimoireAbilityToSkillPoints(this.skillPoints())
		endmethod

		/**
		 * Whenever the game is loaded the spell levels of the non favorite spells are reset to one.
		 */
		private static method triggerActionLoad takes nothing returns nothing
			local thistype this = thistype(DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), 0))
			call this.updateUiAfterLoad()

			/*
			 * TODO
			 * Update equipment abilities as well since the spellbook abities will become visible again.
			 */
		endmethod

		private method createLoadTrigger takes nothing returns nothing
			set this.m_loadTrigger = CreateTrigger()
			call TriggerRegisterGameEvent(this.m_loadTrigger, EVENT_GAME_LOADED)
			call TriggerAddCondition(this.m_loadTrigger, Condition(function thistype.triggerConditionLoad))
			call TriggerAddAction(this.m_loadTrigger, function thistype.triggerActionLoad)
			call DmdfHashTable.global().setHandleInteger(this.m_loadTrigger, 0, this)
		endmethod

		/**
		 * Creates a new grimoire for character \p character.
		 * \return Returns the newly created grimoire for the character.
		 */
		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, thistype.abilityId, 0, 0, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, false)
			set this.m_page = 0
			set this.m_pageIsShown = false
			set this.m_heroLevel = 1 // heroes start with level 1
			set this.m_skillPoints = 0
			set this.m_favourites = AIntegerVector.create()
			set this.m_learnedSpells = AIntegerVector.create()
			set this.m_currentSpell = 0
			set this.m_spells = AIntegerVector.create()

			set this.m_spellPreviousPage = PreviousPage.create.evaluate(this)
			set this.m_spellNextPage = NextPage.create.evaluate(this)
			set this.m_spellSetMax = SetMax.create.evaluate(this)
			set this.m_spellUnlearn = Unlearn.create.evaluate(this)
			set this.m_spellIncrease = Increase.create.evaluate(this)
			set this.m_spellDecrease = Decrease.create.evaluate(this)
			set this.m_spellAddToFavourites = AddToFavourites.create.evaluate(this)
			set this.m_spellRemoveFromFavourites = RemoveFromFavourites.create.evaluate(this)
			set this.m_spellBackToGrimoire = BackToGrimoire.create.evaluate(this)
			set this.m_uiGrimoireSpells = AIntegerVector.create()
			call this.showPage()
			call this.createLevelTrigger()
			call this.createLoadTrigger()

			call SetPlayerAbilityAvailable(character.player(), thistype.dummyAbilityId, false)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			//call RemoveUnit(this.unit())
			//set this.m_unit = null
			call this.m_favourites.destroy()
			call this.m_learnedSpells.destroy()

			loop
				exitwhen (this.m_spells.empty())
				call Spell(this.m_spells.back()).destroy()
				call this.m_spells.popBack()
			endloop

			call this.m_spells.destroy()
			//call DmdfHashTable.global().destroyTrigger(this.m_researchTrigger)
			//set this.m_researchTrigger = null

			call this.m_spellNextPage.destroy.evaluate()
			call this.m_spellPreviousPage.destroy.evaluate()
			call this.m_spellSetMax.destroy.evaluate()
			call this.m_spellUnlearn.destroy.evaluate()
			call this.m_spellIncrease.destroy.evaluate()
			call this.m_spellDecrease.destroy.evaluate()
			call this.m_spellAddToFavourites.destroy.evaluate()
			call this.m_spellRemoveFromFavourites.destroy.evaluate()
			call this.m_spellBackToGrimoire.destroy.evaluate()
			call this.m_uiGrimoireSpells.destroy()

			call DmdfHashTable.global().destroyTrigger(this.m_levelTrigger)
			set this.m_levelTrigger = null

			call DmdfHashTable.global().destroyTrigger(this.m_loadTrigger)
			set this.m_loadTrigger = null
		endmethod
	endstruct

	struct PreviousPage extends GrimoireSpell
		public static constant integer id = 'A0AA'
		public static constant integer grimoireAbilityId = 'A0AY'

		public stub method onCastAction takes nothing returns nothing
			call this.grimoire().decreasePage()

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	struct NextPage extends GrimoireSpell
		public static constant integer id = 'A0AB'
		public static constant integer grimoireAbilityId = 'A0AX'

		public stub method onCastAction takes nothing returns nothing
			call this.grimoire().increasePage()

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	struct SetMax extends GrimoireSpell
		public static constant integer id = 'A1I1'
		public static constant integer grimoireAbilityId = 'A1I3'

		public stub method onCastAction takes nothing returns nothing
			debug call this.print("Set spell max")
			call this.grimoire().setSpellLevel(this.grimoire().currentSpell(), IMinBJ(this.grimoire().currentSpell().getMaxLevel(), this.grimoire().currentSpell().level() + this.grimoire().skillPoints()), true)

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	struct Unlearn extends GrimoireSpell
		public static constant integer id = 'A1I2'
		public static constant integer grimoireAbilityId = 'A1I4'

		public stub method onCastAction takes nothing returns nothing
			debug call this.print("Unlearn spell")
			call this.grimoire().setSpellLevelWithoutConditions(this.grimoire().currentSpell(), 0, true)

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	struct Increase extends GrimoireSpell
		public static constant integer id = 'A0AF'
		public static constant integer grimoireAbilityId = 'A0AV'

		public stub method onCastAction takes nothing returns nothing
			debug call this.print("Increasing spell")
			call this.grimoire().increaseSpell()

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	struct Decrease extends GrimoireSpell
		public static constant integer id = 'A0AG'
		public static constant integer grimoireAbilityId = 'A0AW'

		public stub method onCastAction takes nothing returns nothing
			debug call this.print("Decreasing spell")
			call this.grimoire().decreaseSpell()

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	struct AddToFavourites extends GrimoireSpell
		public static constant integer id = 'A0AH'
		public static constant integer grimoireAbilityId = 'A0AU'

		public stub method onCastAction takes nothing returns nothing
			debug call this.print("Adding spell to favourites")
			call this.grimoire().addSpellToFavourites()

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	struct RemoveFromFavourites extends GrimoireSpell
		public static constant integer id = 'A0AI'
		public static constant integer grimoireAbilityId = 'A0AT'

		public stub method onCastAction takes nothing returns nothing
			debug call this.print("Removing spell from favourites")
			call this.grimoire().removeSpellFromFavourites()

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	/**
	 * This ability allows the user to get back to the overview of all grimoire spells when a specific spell is activated.
	 */
	struct BackToGrimoire extends GrimoireSpell
		public static constant integer id = 'A13F'
		public static constant integer grimoireAbilityId = 'A13G'

		public stub method onCastAction takes nothing returns nothing
			debug call this.print("Going back to grimoire")
			call this.grimoire().showPage()

			call this.reopenGrimoire()
		endmethod

		public static method create takes Grimoire grimoire returns thistype
			local thistype this = thistype.allocate(grimoire, thistype.id, thistype.grimoireAbilityId)

			return this
		endmethod
	endstruct

	/**
	 * \brief A grimoire spell entry is an entry which for a single \ref Spell instance in the grimoire which corresponds to a specific level of that spell.
	 */
	struct GrimoireSpellEntry extends GrimoireSpell
		private Spell m_spell

		public method spell takes nothing returns Spell
			return this.m_spell
		endmethod

		public stub method onCastAction takes nothing returns nothing
			/// \todo cancel order since ability will be removed!
			//call IssueImmediateOrderById(this.character().unit(), A_ORDER_ID_STUNNED)
			// can be casted in spell menu as well!
			if (this.grimoire().pageIsShown()) then
				call this.grimoire().setCurrentSpell(this.spell())

				call this.reopenGrimoire()
			endif
		endmethod

		/// \note Call this after the construction of \ref Grimoire since it references the corresponding character
		public static method create takes Grimoire grimoire, integer abilityId, integer grimoireAbilityId, Spell spell returns thistype
			local thistype this = thistype.allocate(grimoire, abilityId, grimoireAbilityId)
			set this.m_spell = spell

			return this
		endmethod
	endstruct

endlibrary
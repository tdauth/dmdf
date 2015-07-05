/**
 * New grimoire system:
 * The new grimoire system is based on much more different abilities than the old one.
 * Indeed there is a single skilling ability for each single level of a spell. This is required since only by creating a new ability we can change its icon and therefore show the ability's level in each one which emulates Warcraft III's hero skills some kind.
 * Spells can be added to favourites and therefore be removed from the grimoire sub menu by using the "spell book" bug/exploit that abilities can be hidden, so each spell ability needs a corresponding favourites ability based on "spell book" which contains the spell ability and has the same spell book id as the grimoire sub menu ability.
 * \note Warcraft III's hero skills simply cannot be used since they are limited up to 5.
 */
library StructGameGrimoire requires Asl, StructGameCharacter, StructGameSpell

	/**
	 * \brief The grimoire of a character allows the player to skill any abilities of the character. It avoids a limit of 6 hero abilities.
	 * 
	 * \todo At its current state \ref updateUi() may be called too many times. Please consider that the order of buttons in grimoire should always be equal regardless of which buttons became unavailable.
	 */
	struct Grimoire extends ASpell
		public static constant integer maxSpells = 15
		public static constant integer spellsPerPage = 9
		public static constant integer abilityId = 'A0AP'
		//public static constant integer techIdSkillPoints = 'R005'
		//public static constant integer unitId = 'h00J'
		public static constant string shortcut = "Z"
		public static constant integer maxFavourites = 4
		public static constant integer ultimate0Level = 12
		public static constant integer ultimate1Level = 25
		// members
		//private unit m_unit
		private integer m_page
		private boolean m_pageIsShown
		private integer m_skillPoints
		private AIntegerVector m_favourites
		private Spell m_currentSpell
		private AIntegerVector m_spells
		private NextPage m_spellNextPage
		private PreviousPage m_spellPreviousPage
		private Increase m_spellIncrease
		private Decrease m_spellDecrease
		private AddToFavourites m_spellAddToFavourites
		private RemoveFromFavourites m_spellRemoveFromFavourites
		private BackToGrimoire m_spellBackToGrimoire
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
		public method readd takes AHashTable table returns nothing
			local Spell spell
			local integer level
			local integer i = 0
			//debug call Print("Readding spells with count: " + I2S(this.m_spells.size()))
			loop
				exitwhen (i == this.m_spells.size())
				set spell = Spell(this.m_spells[i])
				
				//debug call Print("Spell id: " + I2S(integer(spell)))
				
				debug if (not table.hasIntegerByInteger(0, spell.ability())) then
				debug call Print("Missing ability: " + GetAbilityName(spell.ability()) + " when readding spells")
				debug endif
				
				set level = table.integerByInteger(0, spell.ability())
				
				//debug call Print("Ability: " + GetAbilityName(spell.ability()) + " with restored level " + I2S(level))
				
				// only add if it has been there before!
				if (level > 0) then
					if (this.m_favourites.contains(spell)) then
						//debug call Print("Is a favorite spell")
						call UnitRemoveAbility(this.character().unit(), spell.favouriteAbility())
						call spell.add()
						call spell.setLevel(level)
					else
						//debug call Print("Is not a favorite spell")
						call UnitAddAbility(this.character().unit(), spell.favouriteAbility())
						call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), false)
						call spell.setLevel(level)
					endif
				endif
				set i = i + 1
			endloop
		endmethod

		/// \return Returns a newly created hash table with ability id - level entries  (parent key - 0, child key - ability id, value - level).
		public method spellLevels takes nothing returns AHashTable
			local AHashTable table = AHashTable.create()
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				call table.setIntegerByInteger(0, Spell(this.m_spells[i]).ability(), Spell(this.m_spells[i]).level())
				set i = i + 1
			endloop
			return table
		endmethod

		/**
		 * \return Returns the number of learned spells (spells which have level of at least 1).
		 */
		public method learnedSpells takes nothing returns integer
			local integer result = 0
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).level() > 0) then
					set result = result + 1
				endif
				set i = i + 1
			endloop
			return result
		endmethod
		
		/**
		 * Updates all buttons properly.
		 * Central UI update is much easier to maintain!
		 * \note Add all shown spells to m_uiGrimoireSpells!
		 */
		public method updateUi takes nothing returns nothing
			local integer i
			local integer index

			//debug call Print("Hiding spells with count in grimoire: " + I2S(this.m_uiGrimoireSpells.size()))
			set i = 0
			loop
				exitwhen (i == this.m_uiGrimoireSpells.size())
				if (this.m_uiGrimoireSpells[i] != 0) then
					call GrimoireSpell(this.m_uiGrimoireSpells[i]).hide.evaluate()
				endif
				set i = i + 1
			endloop
			call this.m_uiGrimoireSpells.clear()

			if (this.pageIsShown()) then
				call this.m_spellPreviousPage.show.evaluate()
				call this.m_uiGrimoireSpells.pushBack(this.m_spellPreviousPage)
				call this.m_spellNextPage.show.evaluate()
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
			else
				if (this.currentSpell().isSkillable()) then
					call this.m_spellIncrease.show.evaluate()
					call this.m_uiGrimoireSpells.pushBack(this.m_spellIncrease)
				endif
				if (this.currentSpell().level() > 0) then
					call this.m_spellDecrease.show.evaluate()
					call this.m_uiGrimoireSpells.pushBack(this.m_spellDecrease)

					if (this.m_favourites.contains(this.currentSpell())) then
						call this.m_spellRemoveFromFavourites.show.evaluate()
						call this.m_uiGrimoireSpells.pushBack(this.m_spellRemoveFromFavourites)
					elseif (this.m_favourites.size() < thistype.maxFavourites) then
						call this.m_spellAddToFavourites.show.evaluate()
						call this.m_uiGrimoireSpells.pushBack(this.m_spellAddToFavourites)
					endif
				endif
				
				// show in correct order, always show the spell entry itself as last one since it will become the last one whenever its level changes!
				call this.currentSpell().showGrimoireEntry() // show info about current level
				call this.m_uiGrimoireSpells.pushBack(this.currentSpell().grimoireEntry())
				
				// show an ability to return back to the spells overview
				// in fact the grimoire spell itself has the same functionality but it is not recognizable by the user
				call this.m_spellBackToGrimoire.show.evaluate()
				call this.m_uiGrimoireSpells.pushBack(this.m_spellBackToGrimoire)
			endif

			//debug call Print("after removing ability")
			//call IssueImmediateOrderById(this.character().unit(), this.ability()) // WORKAROUND: whenever an ability is being removed it closes grimoire
			// TODO if trigger player is not owner of the character!
			//debug call Print("Issued UI key for player: " + GetPlayerName(this.character().player()))
			//debug call Print("Trigger player is: " + GetPlayerName(GetTriggerPlayer()))
			// the trigger player is the player who issues the order/ability not necessarily the owner
			// there fore only re open the grimoire if there is a trigger player
			if (GetTriggerPlayer() != null) then
				call ForceUIKeyBJ(GetTriggerPlayer(), thistype.shortcut) // WORKAROUND: whenever an ability is being removed it closes grimoire
			endif
			//debug call Print("issued: " + GetObjectName(this.ability()))
		endmethod
		
		/**
		 * The ability for the grimoire must have level 0 - 100 for displaying the number of available skill points.
		 */
		public method setSkillPoints takes integer skillPoints returns nothing
			set this.m_skillPoints = skillPoints
			if (skillPoints < 0) then
				call SetUnitAbilityLevel(this.character().unit(), this.ability(), 0)
			// use + 1 since the first level is for 0 skill points
			elseif (skillPoints > 99) then
				call SetUnitAbilityLevel(this.character().unit(), this.ability(), 100)
			else
				call SetUnitAbilityLevel(this.character().unit(), this.ability(), skillPoints + 1)
			endif
			/*
			 * Update the User Interface. The selected skill might become skillable!
			 */
			call this.updateUi()
		endmethod

		public method removeSkillPoints takes integer skillPoints returns nothing
			call this.setSkillPoints(IMaxBJ(0, this.m_skillPoints - skillPoints))
			//call SetPlayerTechResearched(this.character().player(), thistype.techIdSkillPoints, this.skillPoints())
		endmethod

		/**
		 * Adds skill points to grimoire.
		 */
		public method addSkillPoints takes integer skillPoints returns nothing
			if (skillPoints == 0) then
				return
			elseif (skillPoints < 0) then
				call this.removeSkillPoints(-1 * skillPoints)
				return
			endif
			call this.setSkillPoints(this.m_skillPoints + skillPoints)
			//call SetPlayerTechResearched(this.character().player(), thistype.techIdSkillPoints, this.skillPoints())
		endmethod

		public method spellIndex takes Spell spell returns integer
			return this.m_spells.find(spell)
		endmethod

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

		public method spells takes nothing returns integer
			return this.m_spells.size()
		endmethod

		private method learnFavouriteSpell takes Spell spell returns nothing
			local integer favouriteAbility = spell.favouriteAbility()
			call this.m_favourites.pushBack(spell)
			call spell.add()
			call spell.setLevel(1)
			call spell.onLearn.evaluate()
		endmethod

		private method unlearnFavouriteSpell takes Spell spell returns nothing
			call spell.onUnlearn.evaluate()
			call this.m_favourites.remove(spell)
			call spell.remove()
		endmethod

		private method learnSpell takes Spell spell returns nothing
			call UnitAddAbility(this.character().unit(), spell.favouriteAbility())
			call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), false)
			call spell.setLevel(1)
			call spell.onLearn.evaluate()
		endmethod

		private method unlearnSpell takes Spell spell returns nothing
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

		private method addFavouriteSpell takes Spell spell returns boolean
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

		private method removeFavouriteSpell takes Spell spell returns boolean
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

		/// Adds spell \p spell to grimoire. If \p spellType is \ref Spell.spellTypeDefault it will be added with level 1.
		public method addSpell takes Spell spell, boolean updateUi returns nothing
			call this.m_spells.pushBack(spell)

			if (spell.spellType() == Spell.spellTypeDefault) then
				if (this.m_favourites.size() < thistype.maxFavourites) then
					call this.learnFavouriteSpell(spell)
				else
					call this.learnSpell(spell)
				endif
			endif
			
			if (updateUi) then
				call this.updateUi()
			endif
		endmethod

		public method removeSpellByIndex takes integer index, boolean updateUi returns boolean
			local Spell spell
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

		/// For internal usage (Grimoire.autoSkill).
		private method setSpellLevelByIndexWithoutConditions takes integer index, integer level returns boolean
			local Spell spell
			local integer requiredSkillPoints

static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellLevelByIndexWithoutConditions", "Wrong spell index: " + I2S(index) + ".")
				return false
			endif
endif
			set spell = Spell(this.m_spells[index])
			set requiredSkillPoints = level - spell.level()

			if (requiredSkillPoints == 0) then
				return true
			endif
			
			//debug call Print("Successfully skilling " + GetAbilityName(spell.ability()) + " to level " + I2S(level))

			if (requiredSkillPoints < 0) then
				call this.addSkillPoints(-1 * requiredSkillPoints)
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
				call this.removeSkillPoints(requiredSkillPoints)

				if (spell.level() == 0) then
					//debug call Print("Learning spell: " + spell.name() + " having " + I2S(this.m_favourites.size()) + " favorite spells.")
				
					if (this.m_favourites.size() < thistype.maxFavourites) then
						call this.learnFavouriteSpell(spell)
					else
						call this.learnSpell(spell)
					endif
				endif

				call spell.setLevel(level)
			endif

			return true
		endmethod

		public method setSpellLevelWithoutConditions takes Spell spell, integer level, boolean updateUi returns boolean
			local boolean result = this.setSpellLevelByIndexWithoutConditions(this.m_spells.find(spell), level)
			if (updateUi) then
				call this.updateUi()
			endif
			return result
		endmethod

		/// If you do not need the spell instance anymore remember destroying it by .destroy().
		public method removeSpell takes Spell spell, boolean updateUi returns boolean
			return this.removeSpellByIndex(this.m_spells.find(spell), updateUi)
		endmethod

		public method setSpellAvailableByIndex takes integer index, boolean available, boolean updateUi returns nothing
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellAvailableByIndex", "Wrong spell index: " + I2S(index) + ".")
				return
			endif
endif
			call Spell(this.m_spells[index]).setAvailable(available)
			if (updateUi) then
				call this.updateUi()
			endif
		endmethod
		
		public method setSpellAvailable takes Spell spell, boolean available, boolean updateUi returns nothing
			call this.setSpellAvailableByIndex(this.m_spells.find(spell), available, updateUi)
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

		public method setSpellLevelByIndex takes integer index, integer level, boolean updateUi returns boolean
			local boolean result = false
			local Spell spell
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellLevelByIndex", "Wrong spell index: " + I2S(index) + ".")
				return false
			endif
endif
			set spell = Spell(this.m_spells[index])

			if (not spell.isSkillableTo(level)) then
				return false
			endif
			
			set result = this.setSpellLevelByIndexWithoutConditions(index, level)
			
			if (updateUi) then
				call this.updateUi()
			endif
			
			return result
		endmethod

		public method setSpellLevel takes Spell spell, integer level, boolean updateUi returns boolean
			return this.setSpellLevelByIndex(this.m_spells.find(spell), level, updateUi)
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
			return this.setSpellLevelByIndex(index, Spell(this.m_spells[index]).getMaxLevel(), updateUi)
		endmethod

		public method setSpellMaxLevel takes Spell spell, boolean updateUi returns boolean
			return this.setSpellMaxLevelByIndex(this.m_spells.find(spell), updateUi)
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
					//debug call Print("Adding NEW spell " + GetAbilityName(Spell(integerVector[i]).ability()))
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
			local integer i = 0
			loop
				exitwhen (i == character.classSpells().size())
				// do not add spells twice
				if (not this.m_spells.contains(Spell(character.classSpells()[i]))) then
					//debug call Print("Adding NEW spell " + GetAbilityName(Spell(character.classSpells()[i]).ability()))
					call spells.pushBack(Spell(character.classSpells()[i]))
				endif
				set i = i + 1
			endloop
			call this.addSpells(spells, true)
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
			//debug call Print("Remove class spells")
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
			//debug call Print("Remove all class spells")
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
			//debug call Print("Remove all other class spells")
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
			debug call this.print("Current spell is " + GetObjectName(spell.ability()))
			set this.m_currentSpell = spell
			call this.showSpell()
		endmethod

		/// \todo Using method without index would improve performance massively!
		public method increaseSpell takes nothing returns boolean
			debug call this.print("Current spell is " + GetObjectName(this.currentSpell().ability()))
			return this.setSpellLevelByIndex(this.spellIndex(this.currentSpell()), this.currentSpell().level() + 1, true)
		endmethod

		/// \todo Using method without index would improve performance massively!
		public method decreaseSpell takes nothing returns boolean
			return this.setSpellLevelByIndex(this.spellIndex(this.currentSpell()), this.currentSpell().level() - 1, true)
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
			//debug call this.print("Set page to " + I2S(page))
			if (page == this.page()) then
				return true
			endif
			set this.m_page = page
			call this.showPage()
			return true
		endmethod

		public method increasePage takes nothing returns boolean
			//debug call Print("We have " + I2S(this.pages()) + " with " + I2S(this.m_spells.size()) + " spells total")
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

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, thistype.abilityId, 0, 0, 0, EVENT_UNIT_SPELL_CHANNEL)
			//set this.m_unit = CreateUnit(character.player(), thistype.unitId, GetUnitX(character.unit()), GetUnitY(character.unit()), 0.0)
			//call SetUnitInvulnerable(this.unit(), true)
			set this.m_page = 0
			set this.m_pageIsShown = false
			set this.m_skillPoints = 0
			set this.m_favourites = AIntegerVector.create()
			set this.m_currentSpell = 0
			set this.m_spells = AIntegerVector.create()

			set this.m_spellNextPage = NextPage.create.evaluate(this)
			set this.m_spellPreviousPage = PreviousPage.create.evaluate(this)
			set this.m_spellIncrease = Increase.create.evaluate(this)
			set this.m_spellDecrease = Decrease.create.evaluate(this)
			set this.m_spellAddToFavourites = AddToFavourites.create.evaluate(this)
			set this.m_spellRemoveFromFavourites = RemoveFromFavourites.create.evaluate(this)
			set this.m_spellBackToGrimoire = BackToGrimoire.create.evaluate(this)
			set this.m_uiGrimoireSpells = AIntegerVector.create()
			call this.showPage()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			//call RemoveUnit(this.unit())
			//set this.m_unit = null
			call this.m_favourites.destroy()

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
			call this.m_spellIncrease.destroy.evaluate()
			call this.m_spellDecrease.destroy.evaluate()
			call this.m_spellAddToFavourites.destroy.evaluate()
			call this.m_spellRemoveFromFavourites.destroy.evaluate()
			call this.m_spellBackToGrimoire.destroy.evaluate()
			call this.m_uiGrimoireSpells.destroy()
		endmethod
	endstruct

	struct GrimoireSpell extends ASpell
		private Grimoire m_grimoire
		private integer m_grimoireAbility

		public method grimoire takes nothing returns Grimoire
			return this.m_grimoire
		endmethod

		public method grimoireAbility takes nothing returns integer
			return this.m_grimoireAbility
		endmethod

		public method isShown takes nothing returns boolean
			return GetUnitAbilityLevel(this.grimoire().character().unit(), this.grimoireAbility()) > 0
		endmethod

		public method show takes nothing returns nothing
			if (this.isShown()) then
				return
			endif

			call UnitAddAbility(this.grimoire().character().unit(), this.grimoireAbility())
			call SetPlayerAbilityAvailable(this.grimoire().character().player(), this.grimoireAbility(), false)
			call SetUnitAbilityLevel(this.grimoire().character().unit(), this.ability(), 1)
			call this.enable()
		endmethod

		public method hide takes nothing returns nothing
			if (not this.isShown()) then
				return
			endif

			call this.disable() // disable to prevent casts if some spells have the same id (spell book)
			call UnitRemoveAbility(this.grimoire().character().unit(), this.grimoireAbility())
		endmethod

		public stub method onCastCondition takes nothing returns boolean
			return this.grimoire().character().isMovable()
		endmethod

		public stub method onCastAction takes nothing returns nothing
			call super.onCastAction()
		endmethod

		public static method create takes Grimoire grimoire, integer abilityId, integer grimoireAbility returns thistype
			/*
			 * Use EVENT_UNIT_SPELL_ENDCAST to prevent any null GetAbilityId() calls when the ability is removed before running trigger events.
			 * Since the grimoire buttons do not need any event data like GetSpellTargetX() this event is just okay.
			 */
			local thistype this = thistype.allocate(grimoire.character(), abilityId, 0, 0, 0, EVENT_UNIT_SPELL_ENDCAST)
			set this.m_grimoire = grimoire
			set this.m_grimoireAbility = grimoireAbility

			return this
		endmethod
	endstruct

	struct PreviousPage extends GrimoireSpell
		public static constant integer id = 'A0AA'
		public static constant integer grimoireAbilityId = 'A0AY'

		public stub method onCastAction takes nothing returns nothing
			call this.grimoire().decreasePage()
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
			else
				call this.grimoire().showPage()
			endif
		endmethod

		public static method create takes Grimoire grimoire, integer abilityId, integer grimoireAbilityId, Spell spell returns thistype
			local thistype this = thistype.allocate(grimoire, abilityId, grimoireAbilityId)
			set this.m_spell = spell

			return this
		endmethod
	endstruct

endlibrary
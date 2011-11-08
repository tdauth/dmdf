/// \deprecated THIS IS DEPRECATED -> StructGameGrimoire
library StructGuisGrimoire requires Asl, StructGameCharacter, StructGameSpell, Spells

	struct Grimoire extends ASpell
		public static constant integer maxSpells = 15
		public static constant integer abilityId = 'A01Z'
		public static constant integer maxFavourites = 4
		public static constant integer ultimate0Level = 12
		public static constant integer ultimate1Level = 25
		// members
		private integer m_skillPoints
		private AIntegerVector m_favourites
		private Spell m_currentSpell
		private AIntegerVector m_spells

		// members

		public method skillPoints takes nothing returns integer
			return this.m_skillPoints
		endmethod

		/// @return Returns vector with ASpell instances.
		public method favourites takes nothing returns AIntegerVector
			return this.m_favourites
		endmethod

		public method currentSpell takes nothing returns ASpell
			return this.m_currentSpell
		endmethod

		// methods

		/**
		* Readds all abilities to the character's unit.
		* Useful when character had been morphed for some time.
		* \param map Has to be a map with ability id - level pairs.
		* \sa Grimoire#spellLevels
		*/
		public method readd takes AIntegerMap map returns nothing
			local Spell spell
			local integer level
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				set spell = Spell(this.m_spells[i])
				set level = map[spell.ability()]
				if (this.m_favourites.contains(spell)) then
					call UnitRemoveAbility(this.character().unit(), spell.favouriteAbility())
					call spell.add()
					call spell.setLevel(level)
				else
					call UnitAddAbility(this.character().unit(), spell.favouriteAbility())
					call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), false)
					call spell.setLevel(level)
				endif
				set i = i + 1
			endloop
		endmethod

		/// \return Returns a newly created map with ability id - level pairs.
		public method spellLevels takes nothing returns AIntegerMap
			local AIntegerMap map = AIntegerMap.create()
			local AIntegerMapIterator iterator = map.end()
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				call map.insert(iterator, Spell(this.m_spells[i]).ability(), Spell(this.m_spells[i]).level())
				call iterator.destroy()
				set iterator = map.end()
				set i = i + 1
			endloop
			call iterator.destroy()
			return map
		endmethod

		/**
		* Should be called for computer controlled players which do not skill their spells in grimoire.
		* @note High-skilled spells are prefered. First skilled spell is taken randomly!
		*/
		public method autoSkill takes nothing returns nothing
			local AIntegerVector skillableSpells = Spell.skillableClassSpells(this.character())
			local integer i
			local Spell spell
			if (skillableSpells.size() > 0) then
				loop
					exitwhen (this.skillPoints() == 0)
					set i = 0
					set spell = skillableSpells.random()
					loop
						exitwhen (i == skillableSpells.size())
						if (Spell(skillableSpells[i]).level() > spell.level()) then
							set spell = skillableSpells[i]
						endif
						set i = i + 1
					endloop
					if (not this.m_spells.contains(spell)) then
						call this.addSpell(spell)
					endif
					call this.setSpellLevelWithoutConditions(spell, spell.level() + 1)
				endloop
			debug else
				debug call this.print("No more skillable spells")
			endif
			call skillableSpells.destroy()
		endmethod

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

		public method addSkillPoints takes integer skillPoints returns nothing
			set this.m_skillPoints = this.m_skillPoints + skillPoints
			// auto skill
			if (GetPlayerController(this.character().player()) == MAP_CONTROL_COMPUTER) then
				call this.autoSkill()
				call this.character().displayMessageToAllOthers(ACharacter.messageTypeInfo, Format(tr("Die Zauberpunkte für %1% wurden automatisch verteilt.")).s(this.character().name()).result())
			endif
		endmethod

		public method removeSkillPoints takes integer skillPoints returns nothing
			set this.m_skillPoints = IMaxBJ(0, this.m_skillPoints - skillPoints)
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

		/// Adds spell \p spell to grimoire. If \p spellType is \ref Spell.spellTypeDefault it will be added with level 1.
		public method addSpell takes Spell spell returns nothing
			call this.m_spells.pushBack(spell)

			if (spell.spellType() == Spell.spellTypeDefault) then
				if (this.m_favourites.size() < thistype.maxFavourites) then
					call this.learnFavouriteSpell(spell)
				else
					call this.learnSpell(spell)
				endif
			endif
		endmethod

		public method removeSpellByIndex takes integer index returns boolean
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
			return true
		endmethod

		/// If you do not need the spell instance anymore remember destroying it by .destroy().
		public method removeSpell takes ASpell spell returns boolean
			return this.removeSpellByIndex(this.m_spells.find(spell))
		endmethod

		public method setSpellAvailableByIndex takes integer index, boolean available returns nothing
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellAvailableByIndex", "Wrong spell index: " + I2S(index) + ".")
				return
			endif
endif
			call Spell(this.m_spells[index]).setAvailable(available)
		endmethod

		public method setSpellAvailable takes Spell spell, boolean available returns nothing
			call this.setSpellAvailableByIndex(this.m_spells.find(spell), available)
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

		public method setSpellLevelWithoutConditions takes Spell spell, integer level returns boolean
			return this.setSpellLevelByIndexWithoutConditions(this.m_spells.find(spell), level)
		endmethod

		public method setSpellLevelByIndex takes integer index, integer level returns boolean
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
			return this.setSpellLevelByIndexWithoutConditions(index, level)
		endmethod

		public method setSpellLevel takes Spell spell, integer level returns boolean
			return this.setSpellLevelByIndex(this.m_spells.find(spell), level)
		endmethod

		public method setSpellMaxLevelByIndex takes integer index returns boolean
static if (DEBUG_MODE) then
			if (index < 0 or index >= this.m_spells.size()) then
				call this.printMethodError("setSpellMaxLevelByIndex", "Wrong spell index: " + I2S(index) + ".")
				return false
			endif
endif
			return this.setSpellLevelByIndex(index, Spell(this.m_spells[index]).getMaxLevel())
		endmethod

		public method setSpellMaxLevel takes Spell spell returns boolean
			return this.setSpellMaxLevelByIndex(this.m_spells.find(spell))
		endmethod

		public method setSpellsAvailable takes boolean available returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				call Spell(this.m_spells[i]).setAvailable(available)
				set i = i + 1
			endloop
		endmethod

		public method setSpellsLevel takes integer level returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (not this.setSpellLevelByIndex(i, level)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		public method setSpellsMaxLevel takes nothing returns boolean
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (not this.setSpellMaxLevelByIndex(i)) then
					return false
				endif
				set i = i + 1
			endloop
			return true
		endmethod

		public method addSpells takes AIntegerVector integerVector, boolean destroyVector returns nothing
			local integer i = 0
			loop
				exitwhen (i == integerVector.size())
				call this.addSpell(Spell(integerVector[i]))
				set i = i + 1
			endloop
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
		
		public method addAstralModifierSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.astralModifier()), true)
		endmethod

		public method addIllusionistSpells takes nothing returns nothing
			call this.addSpells(Spell.classSpells(this.character(), Classes.illusionist()), true)
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
			elseif (class == Classes.astralModifier()) then
				call this.addAstralModifierSpells()
			elseif (class == Classes.illusionist()) then
				call this.addIllusionistSpells()
			elseif (class == Classes.wizard()) then
				call this.addWizardSpells()
			endif
		endmethod

		public method addCharacterClassSpells takes nothing returns nothing
			call this.addClassSpells(this.character().class())
		endmethod

		/**
		* Adds spells of all available game classes to the grimoire.
		* @note Note that already added class spells will be added once again!
		* @note Use @method Grimoire.addAllOtherClassSpells to avoid this.
		* @see Grimoire.addAllOtherClassSpells
		*/
		public method addAllClassSpells takes nothing returns nothing
			call this.addClassSpells(Classes.cleric())
			call this.addClassSpells(Classes.necromancer())
			call this.addClassSpells(Classes.druid())
			call this.addClassSpells(Classes.knight())
			call this.addClassSpells(Classes.dragonSlayer())
			call this.addClassSpells(Classes.ranger())
			call this.addClassSpells(Classes.elementalMage())
			call this.addClassSpells(Classes.astralModifier())
			call this.addClassSpells(Classes.illusionist())
			call this.addClassSpells(Classes.wizard())
		endmethod

		/**
		* Adds spells of all available game classes to the grimoire without the class spells of the grimoire's character class.
		* @see Grimoire.addAllClassSpells
		*/
		public method addAllOtherClassSpells takes nothing returns nothing
			call this.addSpells(Spell.nonCharacterClassSpells(this.character()), true)
		endmethod

		public method removeClassSpells takes AClass class returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).class() == class) then
					call this.removeSpellByIndex(i)
				endif
				set i = i + 1
			endloop
		endmethod

		public method removeCharacterClassSpells takes nothing returns nothing
			call this.removeClassSpells(this.character().class())
		endmethod

		public method removeAllClassSpells takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).class() != 0) then
					call this.removeSpellByIndex(i)
				endif
				set i = i + 1
			endloop
		endmethod

		public method removeAllOtherClassSpells takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_spells.size())
				if (Spell(this.m_spells[i]).class() != this.character().class()) then
					call this.removeSpellByIndex(i)
				endif
				set i = i + 1
			endloop
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

		private method addFavouriteSpell takes Spell spell returns nothing
			local integer level = spell.level()
			local integer favouriteAbility = spell.favouriteAbility()
			call this.m_favourites.pushBack(spell)
			call UnitRemoveAbility(this.character().unit(), favouriteAbility)
			call spell.add()
			call spell.setLevel(level)
		endmethod

		private method removeFavouriteSpell takes Spell spell returns nothing
			local integer level = spell.level()
			call this.m_favourites.remove(spell)
			call spell.remove()
			call UnitAddAbility(this.character().unit(), spell.favouriteAbility())
			call SetPlayerAbilityAvailable(this.character().player(), spell.favouriteAbility(), false)
			call spell.setLevel(level)
		endmethod

		private static method dialogButtonActionLearnSpell takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			local thistype this = Character(ACharacter.playerCharacter(user)).grimoire()
			call this.removeSkillPoints(1)

			if (this.m_favourites.size() < thistype.maxFavourites) then
				call this.learnFavouriteSpell(this.m_currentSpell)
			else
				call this.learnSpell(this.m_currentSpell)
			endif

			if (this.learnedSpells() == thistype.maxSpells) then
				call this.character().displayMessage(ACharacter.messageTypeInfo, tr("Maximale Anzahl möglicher Zauber erlernt."))
			endif

			call this.showSpellDialog(this.m_currentSpell)
			set user = null
		endmethod

		private static method dialogButtonActionIncreaseSpell takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			local thistype this = Character(ACharacter.playerCharacter(user)).grimoire()
			call this.removeSkillPoints(1)
			call this.m_currentSpell.increaseLevel()
			call this.showSpellDialog(this.m_currentSpell)
			set user = null
		endmethod

		private static method dialogButtonActionDecreaseSpell takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			local thistype this = Character(ACharacter.playerCharacter(user)).grimoire()
			call this.addSkillPoints(1)

			if (this.m_currentSpell.level() != 1) then
				call this.m_currentSpell.decreaseLevel()
			elseif (this.m_favourites.contains(this.m_currentSpell)) then
				call this.unlearnFavouriteSpell(this.m_currentSpell)
			else
				call this.unlearnSpell(this.m_currentSpell)
			endif

			call this.showSpellDialog(this.m_currentSpell)
			set user = null
		endmethod

		private static method dialogButtonActionAddFavouriteSpell takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			local thistype this = Character(ACharacter.playerCharacter(user)).grimoire()
			call this.addFavouriteSpell(this.m_currentSpell)
			debug call Print("Add favourite.")
			call this.showSpellDialog(this.m_currentSpell)
			set user = null
		endmethod

		private static method dialogButtonActionRemoveFavouriteSpell takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			local thistype this = Character(ACharacter.playerCharacter(user)).grimoire()
			call this.removeFavouriteSpell(this.m_currentSpell)
			debug call Print("Remove favourite")
			call this.showSpellDialog(this.m_currentSpell)
			set user = null
		endmethod

		private static method dialogButtonActionBack takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			local thistype this = Character(ACharacter.playerCharacter(user)).grimoire()
			call this.showDialog()
			set user = null
		endmethod

		private method showSpellDialog takes Spell spell returns nothing
			local player user = spell.character().player()
			local AGui gui = AGui.playerGui(user)
			local unit characterUnit = spell.character().unit()
			local string message
			local AClass class = spell.character().class()
			set this.m_currentSpell = spell
			set message = IntegerArg(IntegerArg(StringArg(tr("%s\nStufe: %i\nMaximale Stufe: %i"), spell.name()), spell.level()), spell.getMaxLevel())

			if (spell.spellType() == Spell.spellTypeDefault) then
				set message = message + tr("\nStandardzauber")
			elseif (spell.spellType() == Spell.spellTypeUltimate0) then
				set message = message + tr("\nUltimativ-Zauber 1")
			elseif (spell.spellType() == Spell.spellTypeUltimate1) then
				set message = message + tr("\nUltimativ-Zauber 2")
			endif

			if (not spell.available()) then
				set message = message + tr("\nNicht verfügbar")
			endif

			set message = message + IntegerArg(tr("\n%i Zauberpunkte"), this.m_skillPoints)
			call gui.dialog().clear()
			call gui.dialog().setMessage(message)
			call gui.dialog().addDialogButtonIndex(tr("Zurück"), thistype.dialogButtonActionBack)

			// default class spells can not be changed
			if (spell.spellType() != Spell.spellTypeDefault and spell.available()) then
				if (spell.level() == 0) then
					if (spell.isSkillable()) then
						call gui.dialog().addDialogButtonIndex(tr("Erlernen"), thistype.dialogButtonActionLearnSpell)
					endif
				else
					if (spell.isSkillable()) then
						call gui.dialog().addDialogButtonIndex(tr("Stufe erhöhen"), thistype.dialogButtonActionIncreaseSpell)
					endif

					call gui.dialog().addDialogButtonIndex(tr("Stufe verringern"), thistype.dialogButtonActionDecreaseSpell)
				endif
			endif

			if (spell.level() > 0) then
				if (this.m_favourites.contains(spell)) then
					call gui.dialog().addDialogButtonIndex(tr("Aus Favoriten entfernen"), thistype.dialogButtonActionRemoveFavouriteSpell)
				elseif (this.m_favourites.size() < thistype.maxFavourites) then
					call gui.dialog().addDialogButtonIndex(tr("Zu Favoriten hinzufügen"), thistype.dialogButtonActionAddFavouriteSpell)
				endif
			endif

			call gui.dialog().show()
			set user = null
			set characterUnit = null
		endmethod

		private static method dialogButtonActionSkillSpell takes ADialogButton dialogButton returns nothing
			local player user = dialogButton.dialog().player()
			local thistype this = Character(ACharacter.playerCharacter(user)).grimoire()
			local Spell spell = this.m_spells[dialogButton.index() - 1]
			call this.showSpellDialog(spell)
			set user = null
		endmethod

		/**
		* Computer controlled players can't use grimoire. There is an auto skill implementation.
		* @see Grimoire.autoSkill
		*/
		private method condition takes nothing returns boolean
			return GetPlayerController(this.character().player()) != MAP_CONTROL_COMPUTER
		endmethod

		private method showDialog takes nothing returns nothing
			local player user = this.character().player()
			local AClass class = this.character().class()
			local integer i
			local string buttonText
			call AGui.playerGui(user).dialog().clear()
			call AGui.playerGui(user).dialog().setMessage(IntegerArg(StringArg(tr("Zauberbuch\n%s\n%i Zauberpunkte"), Classes.className(class)), this.m_skillPoints))
			debug call Print("Character id " + I2S(this.character()) + " class " + I2S(class))
			debug call Print("Spell count: " + I2S(this.m_spells.size()))
			call AGui.playerGui(user).dialog().addDialogButtonIndex(tr("Schließen"), 0)

			set i = 0
			loop
				exitwhen (i == this.m_spells.size())
				set buttonText = IntegerArg(StringArg(tr("%s - Stufe %i"), GetObjectName(Spell(this.m_spells[i]).ability())), Spell(this.m_spells[i]).level())

				if (this.m_favourites.contains(this.m_spells[i])) then
					set buttonText = StringArg(tr("(F) %s"), buttonText)
				endif

				call AGui.playerGui(user).dialog().addDialogButtonIndex(buttonText, thistype.dialogButtonActionSkillSpell)
				set i = i + 1
			endloop

			call AGui.playerGui(user).dialog().show()
			set user = null
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate(character, thistype.abilityId, 0, thistype.condition, thistype.showDialog)
			set this.m_skillPoints = 0
			set this.m_favourites = AIntegerVector.create()
			set this.m_currentSpell = 0
			set this.m_spells = AIntegerVector.create()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			call this.m_favourites.destroy()

			loop
				exitwhen (this.m_spells.empty())
				call Spell(this.m_spells.back()).destroy()
				call this.m_spells.popBack()
			endloop

			call this.m_spells.destroy()
		endmethod
	endstruct

endlibrary
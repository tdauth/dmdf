library StructGameSpell requires Asl, StructGameCharacter, StructGameGrimoireSpell

	/**
	* \todo Use icon path and name etc. from ability with \p ABILITY_ID
	* w3a means ability.
	* "Aspb" is the base ID of spell book
	* "ANcl" is the base ID of channel
	* anam - name
	* ansf - editor suffix
	* aart - icon
	* arac - race
	* aite - false
	* spb5 - spellbook
	* spb2 - false
	* spb4 - 1
	* spb3 - 1
	* spb1 - ABILITY_ID
	* achd - false
	*/
	//! textmacro DMDF_CREATE_FAVOURITE_ABILITY takes FAVOURITE_ABILITY_ID, ABILITY_ID
		///! external ObjectMerger w3a Aspb $FAVOURITE_ABILITY_ID$ anam "
	//! endtextmacro

	//! textmacro DMDF_CREATE_GRIMOIRE_ABILITY_PAIR takes NAME, CLASS, LEVEL, SPELL_ID, GRIMOIRE_ABILITY_ID
		///! external ObjectMerger w3a Aspb $GRIMOIRE_ABILITY_ID$ anam "$NAME$ - Stufe $LEVEL$" ansf "(Zauberbuchfähigkeit - $CLASS$)"
	//! endtextmacro

	/// \todo Fix arithmetic operations, take base Ids, print addGrimoireEntry into a separate JASS file which later will be imported, use an array for base Ids like "whindwalk" to always use the same ones
	/// \todo Add dummy ability n times in the spell book to specify the icon position
	/*
	//! externalblock extension=lua ObjectMerger $FILENAME$
		//! i function createFavoriteAbility(name, class, abilityId, spellAbilityId, icon)
		//! i setobjecttype("abilities")
		//! i createobject("Aspb", abilityId)
		//! i makechange(current, "anam", name)
		//! i makechange(current, "ansf", "(Favoritenfähigkeit - "..class..")")
		//! i makechange(current, "spb5", "1", "spellbook")
		//! i makechange(current, "spb2", "1", "0")
		//! i makechange(current, "spb4", "1", "1")
		//! i makechange(current, "spb3", "1", "1")
		//! i makechange(current, "spb1", "1", spellAbilityId)
		//! i makechange(current, "aite", "0")
		//! i makechange(current, "arac", "human")
		//! i makechange(current, "aart", icon)
		//! i end

		//! i function createGrimoireAbilityPair(name, tooltip, class, level, baseId, abilityId, grimoireAbilityId, icon )
		//! i setobjecttype("abilities")

		//! i createobject("ANcl", abilityId)
		//! i makechange(current, "anam", name.." - Stufe "..level)
		//! i makechange(current, "ansf", "(Zauberbuch - "..class..")")
		//! i makechange(current, "atp1", "1", name.."[|cffffcc00Stufe "..level.."|r]")
		//! i makechange(current, "aub1", "1", tooltip)
		//! i makechange(current, "Ncl6", "1", baseId)
		//! i makechange(current, "Ncl5", "1", 0)
		//! i makechange(current, "Ncl1", "1", 0.0)
		//! i makechange(current, "Ncl4", "1", 0.0)
		//! i makechange(current, "Ncl3", "1", 1)
		//! i makechange(current, "abpx", 0)
		//! i makechange(current, "aani", "")
		//! i makechange(current, "ahky", "")
		//! i makechange(current, "aeat", "")
		//! i makechange(current, "acat", "")
		//! i makechange(current, "acap", "")
		//! i makechange(current, "atat", "")
		//! i makechange(current, "ata0", "")
		//! i makechange(current, "achd", 0)
		//! i makechange(current, "aord", 0)
		//! i makechange(current, "aher", "0")
		//! i makechange(current, "alev", "1")
		//! i makechange(current, "arac", "human")
		//! i makechange(current, "aran", "1", "0.00")
		//! i makechange(current, "aart", icon)

		//! i createobject("Aspb", grimoireAbilityId)
		//! i makechange(current, "anam", name.." - Stufe "..level)
		//! i makechange(current, "ansf", "(Zauberbuchfähigkeit - "..class..")")
		//! i makechange(current, "spb5", "1", "absorb")
		//! i makechange(current, "spb2", "1", "0")
		//! i makechange(current, "spb4", "1", "1")
		//! i makechange(current, "spb3", "1", "1")
		//! i makechange(current, "spb1", "1", abilityId)
		//! i makechange(current, "aart", icon)
		//! i makechange(current, "aite", "0")
		//! i makechange(current, "arac", "human")
		//! i end

		//! i function createGrimoireSpell(name, tooltip, icon, class, levels, abilityId, baseId, startId)
			//! i createFavoriteAbility(name, class, startId, abilityId, icon)
			////! i for i=1, levels do
			//	//! i createGrimoireAbilityPair(name, tooltip, class, i, baseId, tonumber(startId) + 1 + i, tonumber(startId) + 2 + i, icon)
			////! i end
		//! i end

		//! i createGrimoireSpell("Testzauber", "Dieser Zauber besitzt einen tollen Effekt", "", "Kleriker", 5, "A000", "windwalk", "AY00")
	//! endexternalblock
	*/

	/**
	 * Custom structure for character spells which support the \ref Grimoire API.
	 * For item spells etc. just use \ref ASpell.
	 * Each spell which should be usable in grimoire needs extra spell pairs per level which are mainly used for
	 * spell level icons.
	 * They can be added using \ref addGrimoireEntry().
	 * In "Die Macht des Feuers" there are 4 different types of spells:
	 * <ul>
	 * <li>normal spells (which can be skilled with required skill points, one per level) - \ref spellTypeNormal</li>
	 * <li>default spells (which cannot be reskilled/changed and are learned by default - usually one per class) - \ref spellTypeDefault</li>
	 * <li>ultimate 0 (which can be skilled when character has at least level \ref Grimoire.ultimate0Level) - \ref spellTypeUltimate0</li>
	 * <li>ultimate 1 (which can be skilled when character has at least level \ref Grimoire.ultimate1Level) - \ref spellTypeUltimate1</li>
	 * </ul>
	 * A spell's type can be specified in constructor.
	 *
	 * \ref onLearn(), \ref onUnlearn() and \ref setLevel() can be overridden to react to any spell leveling.
	 *
	 * \ref setAvailable() allows specifying if a spell can be used at all.
	 */
	struct Spell extends ASpell
		/**
		 * Normal spells are usually skillable up to level 5. They have no special dependencies.
		 */
		public static constant integer spellTypeNormal = 0
		/**
		 * Default spells cannot be reskilled. They are skilled from the beginning.
		 * Usually each class has one default spell.
		 */
		public static constant integer spellTypeDefault = 1
		/**
		 * Ultimate 0 spells have usually only one level and can be skilled when the character reaches level \ref Grimoire.ultimate0Level).
		 */
		public static constant integer spellTypeUltimate0 = 2
		public static constant integer spellTypeUltimate1 = 3
		/**
		 * The level has to be stored since it might get lost when loading the map.
		 */
		private integer m_savedLevel
		private integer m_favouriteAbility
		private integer m_maxLevel
		private integer m_spellType
		private AClass m_class
		private boolean m_available
		private boolean m_isPassive
		private boolean m_isHidden
		private AIntegerVector m_grimoireEntries /// vector of \ref GrimoireSpellEntry instances

		/**
		 * \return Returns the spell book based ability which has the same ID as the favorite spells spell book ability but only contains the ability of this spell.
		 */
		public method favouriteAbility takes nothing returns integer
			return this.m_favouriteAbility
		endmethod

		/**
		 * \return Returns vector of \ref GrimoireEntry instances.
		 * \sa thistype#addGrimoireEntry()
		 */
		public method grimoireEntries takes nothing returns AIntegerVector
			return this.m_grimoireEntries
		endmethod

		public method available takes nothing returns boolean
			return this.m_available
		endmethod

		public method setIsPassive takes boolean isPassive returns nothing
			set this.m_isPassive = isPassive
		endmethod

		/**
		 * \note Passive spells are automatically moved into the sub menu when learned since they cannot be actively casted.
		 * \return Returns true if this spell is a passive spell. Otherwise it returns false.
		 */
		public method isPassive takes nothing returns boolean
			return this.m_isPassive
		endmethod

		public method setIsHidden takes boolean isHidden returns nothing
			set this.m_isHidden = isHidden
		endmethod

		/**
		 * \note Hidden spells can be learned even if the favorites and the other learned spells are full since they don't need space for an icon.
		 * \return Returns true if no icon is shown for the spell when it is learned. Otherwise it returns false.
		 */
		public method isHidden takes nothing returns boolean
			return this.m_isHidden
		endmethod

		/**
		 * Adds grimoire entry to the back of existing grimoire entries of this spell - \ref grimoireEntries().
		 * The spell needs a grimoire entry per level!
		 * \param abilityId Ability which has info of the spell in its tooltip and maybe uses a level icon.
		 * \param grimoireAbilityId Ability based on "spell book" which has only \p abilityId in its list.
		 * \sa thistype#grimoireEntries()
		 */
		public method addGrimoireEntry takes integer abilityId, integer grimoireAbilityId returns nothing
			local integer grimoireIndex = 0
			local integer firstIndex = 0
			local Character character = Character(this.character())
			local Grimoire grimoire = character.grimoire()
			local GrimoireSpellEntry entry = GrimoireSpellEntry.create.evaluate(grimoire, abilityId, grimoireAbilityId, this)

			if (this.level() == this.grimoireEntries().size() and this.available() and grimoire.pageIsShown.evaluate()) then
				//debug call this.print("Page is shown")
				// TODO calling spellIndex() is slow
				set grimoireIndex = grimoire.spellIndex.evaluate(this)
				//debug call this.print("Spell index " + I2S(grimoireIndex))
				set firstIndex = grimoire.page.evaluate() * Grimoire.spellsPerPage
				//debug call this.print("First index " + I2S(firstIndex))
				//debug call this.print("Last index " + I2S(firstIndex + Grimoire.spellsPerPage))
				// spell doesn't belong to grimoire or is not shown on current page
				if (grimoireIndex == -1 or (grimoireIndex < firstIndex or grimoireIndex >= firstIndex + Grimoire.spellsPerPage)) then
					call entry.hide(this.character().unit())
				endif
			else
				call entry.hide(this.character().unit())
			endif
			set this.m_grimoireEntries[this.m_grimoireEntries.find(0)] = entry // assign to first empty place
		endmethod

		/**
		 * \return Returns the corresponding grimoire spell entry for the spell's current level.
		 */
		public method grimoireEntry takes nothing returns GrimoireSpellEntry
			if (this.grimoireEntries().empty()) then
				return 0
			endif
			if (this.grimoireEntries()[this.level()] != 0) then
				return this.grimoireEntries()[this.level()]
			endif

			return this.grimoireEntries()[0]
		endmethod

		/**
		 * \return Returns the maximum possible level for the spell.
		 */
		public method getMaxLevel takes nothing returns integer
			return this.m_maxLevel
		endmethod

		/**
		 * \return Returns the type of the spell (\ref thistype.spellTypeDefault or \ref thistype.spellTypeNormal or \ref thistype.spellTypeUltimate0 or \ref thistype.spellTypeUltimate1).
		 */
		public method spellType takes nothing returns integer
			return this.m_spellType
		endmethod

		public method class takes nothing returns AClass
			return this.m_class
		endmethod

		public method setAvailable takes boolean available returns nothing
			set this.m_available = available
		endmethod

		/**
		 * This method can be reimplemented to add a custom condition for the case a spell can be skilled or not.
		 */
		public stub method onIsSkillable takes integer level returns boolean
			return true
		endmethod

		/**
		 * \return Returns true if the spell can be skilled up to level \p level. Otherwise it returns false.
		 */
		public method isSkillableTo takes integer level returns boolean
			local Character character = Character(this.character())
			if (level < 0) then
				debug call Print("Level is less than 0: " + I2S(level))
				return false
			endif
			// spells can always be skilled down
			if (level < this.level()) then
				return true
			endif
			if (character.grimoire().learnedSpells.evaluate() >= Grimoire.maxSpells and this.level() == 0 and level > 0 and not this.isHidden()) then
				debug call Print("Maximum of grimoire spells reached: " + I2S(character.grimoire().learnedSpells.evaluate()) + " - " + this.name())
				return false
			endif
			if (not this.available()) then
				debug call Print("Spell is not available: " + this.name())
				return false
			endif
			if (character.grimoire().skillPoints.evaluate() < level - this.level()) then
				debug call Print("Not enough skill points: " + this.name())
				return false
			endif
			if (this.level() == this.getMaxLevel() and level > this.level()) then
				debug call Print("Maximum level: " + this.name())
				return false
			endif
			if ((this.spellType() == thistype.spellTypeUltimate0 and GetHeroLevel(this.character().unit()) < Grimoire.ultimate0Level) or (this.spellType() == thistype.spellTypeUltimate1 and GetHeroLevel(this.character().unit()) < Grimoire.ultimate1Level)) then
				debug call Print("Ultimate required: " + this.name())
				return false
			endif
			if (not this.onIsSkillable.evaluate(level)) then
				debug call Print("Custom condition is false.")
				return false
			endif

			return true
		endmethod

		/**
		 * \return Returns true if the spell is skillable to its next level.
		 */
		public method isSkillable takes nothing returns boolean
			return this.isSkillableTo(this.level() + 1)
		endmethod

		/**
		 * Use this method for spells which have some spell duration and which can be interrupted by enemies.
		 */
		public stub method interruptEx takes unit whichUnit, boolean stun, boolean snare, boolean sleep returns boolean
			return (stun and IsUnitType(whichUnit, UNIT_TYPE_STUNNED)) or (snare and IsUnitType(whichUnit, UNIT_TYPE_SNARED)) or (sleep and IsUnitType(whichUnit, UNIT_TYPE_SLEEPING))
		endmethod

		public stub method interrupt takes unit whichUnit returns boolean
			return this.interruptEx(whichUnit, true, true, true)
		endmethod

		public method isLearned takes nothing returns boolean
			return this.level() >= 1
		endmethod

		/// Is called after spell has been added to grimoire (via .evaluate()).
		public stub method onLearn takes nothing returns nothing
		endmethod

		/// Is called before spell is being removed from grimoire (via .evaluate()).
		public stub method onUnlearn takes nothing returns nothing
		endmethod

		public stub method setLevel takes integer level returns nothing
			call super.setLevel(level)
			set this.m_savedLevel = level
			debug call Print("Set saved level to " + I2S(level) + " of spell " + GetAbilityName(this.ability()))
		endmethod

		/**
		 * \return Returns the actual level of the spell which might differ from the ability level due to loading bugs of Warcraft III.
		 */
		public method savedLevel takes nothing returns integer
			return this.m_savedLevel
		endmethod

		public stub method onCastCondition takes nothing returns boolean
			debug call Print("Spell: onCastCondition.")
			return super.onCastCondition()
		endmethod

		public stub method onCastAction takes nothing returns nothing
			debug call Print("Spell: onCastAction.")
			call super.onCastAction()
		endmethod

		/**
		 * Enables corresponding grimoire ability and makes it available in grimoire (should be called when grimoire's page is changed).
		 * \sa thistype#hideGrimoireEntry()
		 */
		public method showGrimoireEntry takes nothing returns nothing
			if (this.grimoireEntry() != 0) then
				call this.grimoireEntry().show(this.character().unit())
			debug else
				debug call Print("Missing grimoire entry for spell " + GetObjectName(this.ability()) + " with level " + I2S(this.level()))
			endif
		endmethod

		/**
		 * Disable corresponding grimoire ability and makes it hidden in grimoire (should be called when grimoire's page is changed).
		 * \sa thistype#showGrimoireEntry()
		 */
		public method hideGrimoireEntry takes nothing returns nothing
			if (this.grimoireEntry() != 0) then
				call this.grimoireEntry().hide(this.character().unit())
			endif
		endmethod

		public method isGrimoireEntryShown takes nothing returns boolean
			return GrimoireSpellEntry(this.grimoireEntries()[this.level()]).isShown(this.character().unit())
		endmethod

		public static method createEx takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility, AUnitSpellUpgradeAction upgradeAction, AUnitSpellCastCondition castCondition, AUnitSpellCastAction castAction, playerunitevent unitEvent, boolean useUpgradeTrigger, boolean useCastTrigger returns thistype
			local thistype this = thistype.allocate(character, abilityId, upgradeAction, castCondition, castAction, unitEvent, useUpgradeTrigger, useCastTrigger)
			set this.m_savedLevel = 0
			set this.m_favouriteAbility = favouriteAbility
			set this.m_maxLevel = maxLevel
			set this.m_spellType = spellType
			set this.m_class = class
			set this.m_available = true
			set this.m_isPassive = false
			set this.m_isHidden = false
			// one entry for every level + one entry to learn the spell
			set this.m_grimoireEntries = AIntegerVector.createWithSize(maxLevel + 1, 0)
			call character.addClassSpell(this)

			return this
		endmethod

		public static method createWithEvent takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility, AUnitSpellUpgradeAction upgradeAction, AUnitSpellCastCondition castCondition, AUnitSpellCastAction castAction, playerunitevent unitEvent returns thistype
			/*
			 * Since no hero skills are used, always set useUpgradeTrigger to false. This saves one trigger creation.
			 * This struct uses onLearn() instead.
			 */
			return thistype.createEx(character, class, spellType, maxLevel, abilityId, favouriteAbility, upgradeAction, castCondition, castAction, unitEvent, false, true)
		endmethod

		/**
		 * If the custom spell has no custom code but is only based on a standard Warcraft III ability, you can use this constructor to increase the performance.
		 * It won't create any triggers and never call the event methods.
		 */
		public static method createWithoutTriggers takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility returns thistype
			return thistype.createEx(character, class, spellType, maxLevel, abilityId, favouriteAbility, 0, 0, 0, EVENT_PLAYER_UNIT_SPELL_CHANNEL, false, false)
		endmethod

		/**
		 * Creates a new class spell for one character which works with the grimpire.
		 * \param character The character who can use the spell.
		 * \param class The class to which the spell does belong.
		 */
		public static method create takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility, AUnitSpellUpgradeAction upgradeAction, AUnitSpellCastCondition castCondition, AUnitSpellCastAction castAction returns thistype
			/*
			 * Make sure that GetSpellTargetX() and other event data works properly.
			 * EVENT_UNIT_SPELL_ENDCAST would NOT work and is reserved for grimoire entries.
			 */
			return thistype.createWithEvent(character, class, spellType, maxLevel, abilityId, favouriteAbility, upgradeAction, castCondition, castAction, EVENT_PLAYER_UNIT_SPELL_CHANNEL)
		endmethod

		public method onDestroy takes nothing returns nothing
			call thistype.destroyGrimoireEntriesWithNewOpLimit.evaluate(this) // new OpLimit
			call thistype.removeFromClassSpellsWithNewOpLimit.evaluate(this) // new OpLimit
		endmethod

		private static method destroyGrimoireEntriesWithNewOpLimit takes thistype this returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_grimoireEntries.size())
				if (this.m_grimoireEntries[i] != 0) then
					call GrimoireSpellEntry(this.m_grimoireEntries[i]).destroy.evaluate()
				endif
				set i = i + 1
			endloop
			call this.m_grimoireEntries.destroy()
		endmethod

		private static method removeFromClassSpellsWithNewOpLimit takes thistype this returns nothing
			// TODO slow
			call Character(this.character()).classSpells().remove(this)
		endmethod

		/**
		 * \return Returns an integer vector filled with all global existing spells of character \p character with class \p class.
		 */
		public static method classSpells takes Character character, AClass class returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			local integer i = 0
			debug call Print("Getting class spells of class " + Classes.className(class) + " with couting all spells: " + I2S(character.classSpells().size()))
			loop
				exitwhen (i == character.classSpells().size())
				if (thistype(character.classSpells()[i]).class() == class) then
					debug call Print("Class spell: " + GetAbilityName(thistype(character.classSpells()[i]).ability()))
					call result.pushBack(character.classSpells()[i])
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public static method nonClassSpells takes Character character, AClass class returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == character.classSpells().size())
				if (thistype(character.classSpells()[i]).class() != class) then
					debug call Print("Non class spell: " + GetAbilityName(thistype(character.classSpells()[i]).ability()))
					call result.pushBack(thistype(character.classSpells()[i]))
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public static method characterClassSpells takes Character character returns AIntegerVector
			return thistype.classSpells(character, character.class())
		endmethod

		public static method nonCharacterClassSpells takes Character character returns AIntegerVector
			return thistype.nonClassSpells(character, character.class())
		endmethod

		public static method skillableSpells takes Character character returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == character.classSpells().size())
				if (thistype(character.classSpells()[i]).isSkillable()) then
					call result.pushBack(thistype(character.classSpells()[i]))
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public static method skillableClassSpells takes Character character returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == character.classSpells().size())
				if (thistype(character.classSpells()[i]).isSkillable() and thistype(character.classSpells()[i]).class() == character.class()) then
					call result.pushBack(thistype(character.classSpells()[i]))
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		//GetOwningPlayer(whichUnit)
		public static method showDamageTextTag takes unit whichUnit, real damage returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowBashTextTagForPlayer(null, GetUnitX(whichUnit), GetUnitY(whichUnit), R2I(damage))
			endif
		endmethod

		public static method showLifeTextTag takes unit whichUnit, real life returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tre("+%i", "+%i"), R2I(life)), GetUnitX(whichUnit), GetUnitY(whichUnit), 0, 255, 0, 255)
			endif
		endmethod

		public static method showLifeCostTextTag takes unit whichUnit, real lifeCost returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tre("-%i", "-%i"), R2I(lifeCost)), GetUnitX(whichUnit), GetUnitY(whichUnit), 82, 255, 82, 255) // values from mana burn but green has 255 instead of blue
			endif
		endmethod

		public static method showManaTextTag takes unit whichUnit, real mana returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tre("+%i", "+%i"), R2I(mana)), GetUnitX(whichUnit), GetUnitY(whichUnit), 0, 0, 255, 255)
			endif
		endmethod

		public static method showManaCostTextTag takes unit whichUnit, real manaCost returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tre("-%i", "-%i"), R2I(manaCost)), GetUnitX(whichUnit), GetUnitY(whichUnit), 82, 82, 255, 255) // values from mana burn
			endif
		endmethod

		public static method showDamageAbsorbationTextTag takes unit whichUnit, real damage returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tre("-%i", "-%i"), R2I(damage)), GetUnitX(whichUnit), GetUnitY(whichUnit), 255, 243, 255, 255)
			endif
		endmethod

		public static method showMoveSpeedTextTag takes unit whichUnit, real moveSpeed returns nothing
			local string sign
			if (not IsUnitHidden(whichUnit)) then
				if (moveSpeed < 0.0) then
					set sign = ""
				else
					set sign = "+"
				endif
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(StringArg(tre("%s%i", "%s%i"), sign), R2I(moveSpeed)), GetUnitX(whichUnit), GetUnitY(whichUnit), 202, 198, 255, 255)
			endif
		endmethod

		public static method showTimeTextTag takes unit whichUnit, real time returns nothing
			local string sign
			if (not IsUnitHidden(whichUnit)) then
				if (time < 0.0) then
					set sign = ""
				else
					set sign = "+"
				endif
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(StringArg(tre("%s%i", "%s%i"), sign), R2I(time)), GetUnitX(whichUnit), GetUnitY(whichUnit), 202, 198, 255, 255)
			endif
		endmethod

		public static method showWeaponDamageTextTag takes unit whichUnit, real weaponDamage returns nothing
			local string sign
			if (not IsUnitHidden(whichUnit)) then
				if (weaponDamage < 0.0) then
					set sign = ""
				else
					set sign = "+"
				endif
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(StringArg(tre("%s%i", "%s%i"), sign), R2I(weaponDamage)), GetUnitX(whichUnit), GetUnitY(whichUnit), 139, 131, 134, 255)
			endif
		endmethod

		public static method abilityData takes unit caster, unit target, integer abilityId, string casterAttachmentPoint, string targetAttachmentPoint returns AEffectVector
			local AEffectVector vector = AEffectVector.createWithSize(2, null)

			if (GetAbilityEffectById(abilityId, EFFECT_TYPE_TARGET, 0) != null) then
				set vector[0] = AddSpellEffectTargetById(abilityId, EFFECT_TYPE_TARGET, target, targetAttachmentPoint)
			endif
			if (GetAbilityEffectById(abilityId, EFFECT_TYPE_CASTER, 0) != null) then
				set vector[1] = AddSpellEffectTargetById(abilityId, EFFECT_TYPE_CASTER, caster, casterAttachmentPoint)
			endif
			if (GetAbilitySoundById(abilityId, SOUND_TYPE_EFFECT) != null) then
				call PlaySoundFileOnUnit(GetAbilitySoundById(abilityId, SOUND_TYPE_EFFECT), caster)
			endif

			return vector
		endmethod

		public static method cleanAbilityData takes AEffectVector effectVector returns nothing
			local integer i = 0
			loop
				exitwhen (i == effectVector.size())
				if (effectVector[i] != null) then
					call DestroyEffect(effectVector[i])
				endif
				set i = i + 1
			endloop
			call effectVector.destroy()
		endmethod
	endstruct

endlibrary
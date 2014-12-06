library StructGameSpell requires Asl, StructGameCharacter

	/**
	* @todo Use icon path and name etc. from ability with @param ABILITY_ID
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

	/**
	 * Custom structure for character spells which support \ref Grimoire API.
	 * For item spells etc. just use \ref ASpell.
	 * Each spell which should be usable in grimoire needs extra spell pairs per level which are mainly used for
	 * spell level icons.
	 * They can be added using \ref addGrimoireEntry().
	 * In "Die Macht des Feuers" there are 4 different types of spells:
	 * <ul>
	 * <li>normal spells (which can be skilled with required skill points, one per level) - \ref spellTypeNormal</li>
	 * <li>default spells (which cannot be reskilled/changed and are learned by default - usually one per class) - \ref spellTypeDefault</li>
	 <li>ultimate 0 (which can be skilled when character has at least level \ref Grimoire.ultimate0Level) - \ref spellTypeUltimate0</li>
	 <li>ultimate 1 (which can be skilled when character has at least level \ref Grimoire.ultimate1Level) - \ref spellTypeUltimate1</li>
	 * </ul>
	 * A spell's type can be specified in constructor.
	 *
	 * \ref setAvailable() allows specifying if a spell can be used at all.
	 */
	struct Spell extends ASpell
		public static constant integer spellTypeNormal = 0
		public static constant integer spellTypeDefault = 1
		public static constant integer spellTypeUltimate0 = 2
		public static constant integer spellTypeUltimate1 = 3
		private static AIntegerVector m_spells
		private integer m_favouriteAbility
		private integer m_maxLevel
		private integer m_spellType
		private AClass m_class
		private boolean m_available
		private AIntegerVector m_grimoireEntries /// vector of \ref GrimoireSpellEntry instances
		private integer m_index

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

		/**
		 * Adds grimoire entry to the back of existing grimoire entries of this spell - \ref grimoireEntries().
		 * The spell needs a grimoire entry per level!
		 * \param abilityId Ability which has info of the spell in its tooltip and maybe uses a level icon.
		 * \param grimoireAbilityId Ability based on "spell book" which has only \p abilityId in its list.
		 * \sa thistype#grimoireEntries()
		 */
		public method addGrimoireEntry takes integer abilityId, integer grimoireAbilityId returns nothing
			local integer grimoireIndex
			local integer firstIndex
			local GrimoireSpellEntry entry = GrimoireSpellEntry.create.evaluate(Character(this.character()).grimoire(), abilityId, grimoireAbilityId, this)

			if (this.level() == this.grimoireEntries().size() and this.available() and Character(this.character()).grimoire().pageIsShown.evaluate()) then
				//debug call this.print("Page is shown")
				set grimoireIndex = Character(this.character()).grimoire().spellIndex.evaluate(this)
				//debug call this.print("Spell index " + I2S(grimoireIndex))
				set firstIndex = Character(this.character()).grimoire().page.evaluate() * Grimoire.spellsPerPage
				//debug call this.print("First index " + I2S(firstIndex))
				//debug call this.print("Last index " + I2S(firstIndex + Grimoire.spellsPerPage))
				// spell doesn't belong to grimoire or is not shown on current page
				if (grimoireIndex == -1 or (grimoireIndex < firstIndex or grimoireIndex >= firstIndex + Grimoire.spellsPerPage)) then
					call entry.hide.evaluate()
				endif
			else
				call entry.hide.evaluate()
			endif
			set this.m_grimoireEntries[this.m_grimoireEntries.find(0)] = entry // assign to first empty place
		endmethod

		public method grimoireEntry takes nothing returns GrimoireSpellEntry
			if (this.grimoireEntries().empty()) then
				return 0
			endif
			return this.grimoireEntries()[IMaxBJ(this.level() - 1, 0)]
		endmethod

		public method getMaxLevel takes nothing returns integer
			return this.m_maxLevel
		endmethod

		public method spellType takes nothing returns integer
			return this.m_spellType
		endmethod

		public method class takes nothing returns AClass
			return this.m_class
		endmethod

		public method setAvailable takes boolean available returns nothing
			set this.m_available = available
		endmethod

		public method isSkillableTo takes integer level returns boolean
			if (level < 0) then
				return false
			endif
			if (Character(this.character()).grimoire().learnedSpells.evaluate() == Grimoire.maxSpells and this.level() == 0) then
				return false
			endif
			if (not this.available()) then
				return false
			endif
			if (Character(this.character()).grimoire().skillPoints.evaluate() < level - this.level()) then
				return false
			endif
			if (this.level() == this.getMaxLevel()) then
				return false
			endif
			if (this.spellType() == thistype.spellTypeDefault) then
				if (level == 1) then
					return true
				endif
				return false
			endif
			if (this.spellType() == thistype.spellTypeDefault or (this.spellType() == thistype.spellTypeUltimate0 and GetHeroLevel(this.character().unit()) < Grimoire.ultimate0Level) or (this.spellType() == thistype.spellTypeUltimate1 and GetHeroLevel(this.character().unit()) < Grimoire.ultimate1Level)) then
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
				call this.grimoireEntry().show.evaluate()
			endif
			//call SetPlayerTechMaxAllowed(this.character().player(), this.tech(), this.getMaxLevel())
			//call SetPlayerTechResearched(this.character().player(), this.tech(), this.level())
		endmethod

		/**
		 * Disable corresponding grimoire ability and makes it hidden in grimoire (should be called when grimoire's page is changed).
		 * \sa thistype#showGrimoireEntry()
		 */
		public method hideGrimoireEntry takes nothing returns nothing
			//call SetPlayerTechMaxAllowed(this.character().player(), this.tech(), 0)
			if (this.grimoireEntry() != 0) then
				call this.grimoireEntry().hide.evaluate()
			endif
			//call SetPlayerAbilityAvailable(this.character().player(), this.grimoireAbilities()[this.level()], false)
		endmethod

		public method isGrimoireEntryShown takes nothing returns boolean
			return GrimoireSpellEntry(this.grimoireEntries()[this.level()]).isShown.evaluate()
			//return GetPlayerTechMaxAllowed(this.character().player(), this.tech()) == this.getMaxLevel()
		endmethod

		public static method create takes Character character, AClass class, integer spellType, integer maxLevel, integer abilityId, integer favouriteAbility, ASpellUpgradeAction upgradeAction, ASpellCastCondition castCondition, ASpellCastAction castAction returns thistype
			local thistype this = thistype.allocate(character, abilityId, upgradeAction, castCondition, castAction)
			set this.m_favouriteAbility = favouriteAbility
			set this.m_maxLevel = maxLevel
			set this.m_spellType = spellType
			set this.m_class = class
			set this.m_available = true
			set this.m_grimoireEntries = AIntegerVector.createWithSize(maxLevel + 1, 0)
			call thistype.m_spells.pushBack(this)
			set this.m_index = thistype.m_spells.backIndex()

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			local integer i = 0
			loop
				exitwhen (i == this.m_grimoireEntries.size())
				if (this.m_grimoireEntries[i] != 0) then
					call GrimoireSpellEntry(this.m_grimoireEntries[i]).destroy.evaluate()
				endif
				set i = i + 1
			endloop
			call this.m_grimoireEntries.destroy()
			call thistype.m_spells.erase(this.m_index)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_spells = AIntegerVector.create()
		endmethod

		/**
		 * @return Returns an integer vector filled with all global existing spells of character @param character with class @param class.
		 */
		public static method classSpells takes Character character, AClass class returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == thistype.m_spells.size())
				if (thistype(thistype.m_spells[i]).character() == character and thistype(thistype.m_spells[i]).class() == class) then
					debug call Print("Class spell: " + GetAbilityName(thistype(thistype.m_spells[i]).ability()))
					call result.pushBack(thistype.m_spells[i])
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public static method nonClassSpells takes Character character, AClass class returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == thistype.m_spells.size())
				if (thistype(thistype.m_spells[i]).character() == character and thistype(thistype.m_spells[i]).class() != class) then
					call result.pushBack(thistype.m_spells[i])
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
				exitwhen (i == thistype.m_spells.size())
				if (thistype(thistype.m_spells[i]).character() == character and thistype(thistype.m_spells[i]).isSkillable()) then
					call result.pushBack(thistype.m_spells[i])
				endif
				set i = i + 1
			endloop
			return result
		endmethod

		public static method skillableClassSpells takes Character character returns AIntegerVector
			local AIntegerVector result = AIntegerVector.create()
			local integer i = 0
			loop
				exitwhen (i == thistype.m_spells.size())
				if (thistype(thistype.m_spells[i]).character() == character and thistype(thistype.m_spells[i]).isSkillable() and thistype(thistype.m_spells[i]).class() == character.class()) then
					call result.pushBack(thistype.m_spells[i])
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
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("+%i"), R2I(life)), GetUnitX(whichUnit), GetUnitY(whichUnit), 0, 255, 0, 255)
			endif
		endmethod

		public static method showLifeCostTextTag takes unit whichUnit, real lifeCost returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("-%i"), R2I(lifeCost)), GetUnitX(whichUnit), GetUnitY(whichUnit), 82, 255, 82, 255) // values from mana burn but green has 255 instead of blue
			endif
		endmethod

		public static method showManaTextTag takes unit whichUnit, real mana returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("+%i"), R2I(mana)), GetUnitX(whichUnit), GetUnitY(whichUnit), 0, 0, 255, 255)
			endif
		endmethod

		public static method showManaCostTextTag takes unit whichUnit, real manaCost returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("-%i"), R2I(manaCost)), GetUnitX(whichUnit), GetUnitY(whichUnit), 82, 82, 255, 255) // values from mana burn
			endif
		endmethod

		public static method showDamageAbsorbationTextTag takes unit whichUnit, real damage returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("-%i"), R2I(damage)), GetUnitX(whichUnit), GetUnitY(whichUnit), 255, 243, 255, 255)
			endif
		endmethod

		public static method showMoveSpeedTextTag takes unit whichUnit, real moveSpeed returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("+%i"), R2I(moveSpeed)), GetUnitX(whichUnit), GetUnitY(whichUnit), 202, 198, 255, 255)
			endif
		endmethod

		public static method showWeaponDamageTextTag takes unit whichUnit, real weaponDamage returns nothing
			if (not IsUnitHidden(whichUnit)) then
				call ShowGeneralFadingTextTagForPlayer(null, IntegerArg(tr("+%i"), R2I(weaponDamage)), GetUnitX(whichUnit), GetUnitY(whichUnit), 139, 131, 134, 255)
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
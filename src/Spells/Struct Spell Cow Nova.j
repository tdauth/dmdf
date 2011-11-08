/// No class
library StructSpellsSpellCowNova requires Asl, StructGameClasses, StructGameSpell

	struct SpellCowNova extends ASpell
		public static constant integer abilityId = 'A031'

		/// @todo Replace by static method, vJass bug.
		private static method alightAction takes unit usedUnit returns nothing
			local player owner = GetOwningPlayer(usedUnit)
			// DAMAGE!!!!
			call UnitDamagePoint(usedUnit, 0.0, 600.0, GetUnitX(usedUnit), GetUnitY(usedUnit), 800.0, true, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS)
			call ExplodeUnitBJ(usedUnit)
			call ShowGeneralFadingTextTagForPlayer(owner, tr("DUMMHEIT!"), GetUnitX(usedUnit), GetUnitY(usedUnit), 255, 255, 255, 255)
			set owner = null
		endmethod

		/// Erzeugt im Umkreis springende Kühe, die dumm sind.
		private method action takes nothing returns nothing
			local unit caster = this.character().unit()
			local player owner = GetOwningPlayer(caster)
			local unit cow
			local real i = 360.0
			loop
				exitwhen (i < 0.0)
				set cow = CreateUnit(owner, 'n000', GetUnitPolarProjectionX(caster, i, 300.0), GetUnitPolarProjectionY(caster, i, 300.0), i)
				call AJump.create(cow, 1100.0, GetUnitPolarProjectionX(caster, i, 600.0), GetUnitPolarProjectionY(caster, i, 600.0), thistype.alightAction)
				call ShowGeneralFadingTextTagForPlayer(owner, tr("DUMMHEIT!"), GetUnitX(cow), GetUnitY(cow), 255, 255, 255, 255)
				set cow = null
				set i = i - 30.0
			endloop
			set caster = null
			set owner = null
		endmethod

		public static method create takes ACharacter character returns thistype
			return thistype.allocate(character, thistype.abilityId, 0, 0, thistype.action)
		endmethod
	endstruct

endlibrary
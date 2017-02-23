library StructGameGameCheats requires Asl, StructGameCharacter, StructGameClasses, StructGameGrimoire

	/**
	 * \brief Contains cheats for the game which can be used in every map but only if the debug mode is enabled.
	 */
	struct GameCheats
static if (DEBUG_MODE) then
		private static method onCheatActionCheats takes ACheat cheat returns nothing
			call Print(tre("Spiel-Cheats:", "Game Cheats:"))
			call Print(tre("classes - Listet alle verfügbaren Klassenkürzel auf.", "classes - Lists all available class abbreviations."))
			call Print(tre("addspells <Klasse> - Der Charakter erhält sämtliche Zauber der Klasse im Zauberbuch (keine Klassenangabe oder \"all\" bewirken das Hinzufügen aller Zauber der anderen Klassen).", "addspells <class> - The character gets all spells of a class in the grimoire (no class or \"all\" will add all spells of the other classes)."))
			call Print(tre("setspellsmax <Klasse> - Alle Zauber des Charakters der Klasse werden auf ihre Maximalstufe gesetzt (keine Klassenangabe oder \"all\" bewirken das Setzen aller Klassenzauber).", "setspellsmax <class> - All spells of the character of the class will be set on their maximum level (no class or \"all\" will set all class spells)."))
			call Print(tre("addskillpoints <x> - Der Charakter erhält x Zauberpunkte.", "addskillpoints <x> - The character gets x skill points."))
			call Print(tre("addclassspells - Der Charakter erhält sämtliche Zauber seiner Klasse im Zauberbuch.", "addclassspells - The character gets all spells of his class in the grimoire."))
			call Print(tre("addotherclassspells - Der Charakter erhält sämtliche Zauber der anderen Klassen im Zauberbuch.", "addotherclassspells - The character gets all spells of the other classes in the grimoire."))
			call Print(tre("movable - Der Charakter wird bewegbar oder nicht mehr bewegbar.", "movable - The character becomes movable or no longer movable."))
			call Print(tre("animation <index> - Spielt die Animation mit dem entsprechenden Index des Charakters ab.", "animation <index> - Plays the animation with the corresponding index of the character."))
		endmethod

		private static method onCheatActionClasses takes ACheat cheat returns nothing
			call Print(tre("Klassenkürzelliste:", "Class Abbreviation List:"))
			call Print(StringArg(tre("%s - \"c\"", "%s - \"c\""), Classes.className(Classes.cleric())))
			call Print(StringArg(tre("%s - \"n\"", "%s - \"n\""), Classes.className(Classes.necromancer())))
			call Print(StringArg(tre("%s - \"d\"", "%s - \"d\""), Classes.className(Classes.druid())))
			call Print(StringArg(tre("%s - \"k\"", "%s - \"k\""), Classes.className(Classes.knight())))
			call Print(StringArg(tre("%s - \"s\"", "%s - \"s\""), Classes.className(Classes.dragonSlayer())))
			call Print(StringArg(tre("%s - \"r\"", "%s - \"r\""), Classes.className(Classes.ranger())))
			call Print(StringArg(tre("%s - \"e\"", "%s - \"e\""), Classes.className(Classes.elementalMage())))
			call Print(StringArg(tre("%s - \"w\"", "%s - \"w\""), Classes.className(Classes.wizard())))
		endmethod

		private static method onCheatActionAddSpells takes ACheat cheat returns nothing
			local string class = StringTrim(cheat.argument())
			if (class == "all" or class == null) then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addAllOtherClassSpells()
				call Print(tre("Alle anderen Klassenzauber erhalten.", "Got all class spells."))
			elseif (class == "c") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addClericSpells()
				call Print(tre("Alle Klerikerzauber erhalten.", "Got all cleric spells."))
			elseif (class == "n") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addNecromancerSpells()
				call Print(tre("Alle Nekromantenzauber erhalten.", "Got all necromancer spells."))
			elseif (class == "d") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addDruidSpells()
				call Print(tre("Alle Druidenzauber erhalten.", "Got all druid spells."))
			elseif (class == "k") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addKnightSpells()
				call Print(tre("Alle Ritterzauber erhalten.", "Got all knight spells."))
			elseif (class == "s") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addDragonSlayerSpells()
				call Print(tre("Alle Drachentöterzauber erhalten.", "Got all dragon slayer spells."))
			elseif (class == "r") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addRangerSpells()
				call Print(tre("Alle Waldläuferzauber erhalten.", "Got all ranger spells."))
			elseif (class == "e") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addElementalMageSpells()
				call Print(tre("Alle Elementarmagierzauber erhalten.", "Got all elemental mage spells."))
			elseif (class == "w") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addWizardSpells()
				call Print(tre("Alle Zaubererzauber erhalten.", "Got all wizard spells."))
			else
				call Print(Format(tre("Unbekanntes Klassenkürzel: \"%1%\"", "Unknown class abbreviation: \"%1%\"")).s(class).result())
			endif
		endmethod

		private static method onCheatActionSetSpellsMax takes ACheat cheat returns nothing
			local Grimoire grimoire = Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire()
			local integer i = 0
			local boolean result = true
			// try for every spell and do not exit before since it returns false on having the maximum level already
			loop
				exitwhen (i == grimoire.spells())
				if (not grimoire.setSpellMaxLevelByIndex(i, false)) then
					set result = false
				endif
				set i = i + 1
			endloop
			call grimoire.updateUi()
			if (result) then
				call Print(tre("Alle Zauber auf ihre Maximalstufe gesetzt.", "Set all spells to their maximum level."))
			else
				call Print(tre("Konnte nicht alle Zauber ihre Maximulstufe setzen (eventuell nicht genügend Zauberpunkte).", "Could not set all spells to their maximum (possibly not enough skill points)."))
			endif
		endmethod

		private static method onCheatActionAddSkillPoints takes ACheat cheat returns nothing
			local integer skillPoints = S2I(StringTrim(cheat.argument()))
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addSkillPoints(skillPoints, true)
			call Print(Format(tre("%1% Zauberpunkt(e) erhalten.", "Got %1% skill point(s).")).i(skillPoints).result())
		endmethod

		private static method onCheatActionAddClassSpells takes ACheat cheat returns nothing
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addCharacterClassSpells()
			call Print(tre("Alle Klassenzauber erhalten.", "Got all class spells."))
		endmethod

		private static method onCheatActionAddOtherClassSpells takes ACheat cheat returns nothing
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addAllOtherClassSpells()
			call Print(tre("Alle anderen Klassenzauber erhalten.", "Got all other class spells."))
		endmethod

		private static method onCheatActionMovable takes ACheat cheat returns nothing
			if (Character.playerCharacter(GetTriggerPlayer()) != 0) then
				if (Character.playerCharacter(GetTriggerPlayer()).isMovable()) then
					call Character.playerCharacter(GetTriggerPlayer()).setMovable(false)
					call Print(tre("Charakter unbewegbar gemacht.", "Made character unmovable."))
				else
					call Character.playerCharacter(GetTriggerPlayer()).setMovable(true)
					call Print(tre("Charakter bewegbar gemacht.", "Made character movable."))
				endif
			else
				call Print(tre("Sie haben keinen Charakter.", "You have no character."))
			endif
		endmethod

		private static method onCheatActionAnimation takes ACheat cheat returns nothing
			local integer index = S2I(StringTrim(cheat.argument()))
			if (Character.playerCharacter(GetTriggerPlayer()) != 0) then
				call Print("Animation " + I2S(index))
				call SetUnitAnimationByIndex(Character.playerCharacter(GetTriggerPlayer()).unit(), index)
			else
				call Print(tre("Sie haben keinen Charakter.", "You have no character."))
			endif
		endmethod

		/**
		 * Initializes all game cheats. This method has to be called once during the game initialization.
		 */
		public static method init takes nothing returns nothing
			call Print(tre("|c00ffcc00TEST-MODUS|r", "|c00ffcc00TEST MODE|r"))
			call Print(tre("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"gamecheats\", um eine Liste sämtlicher Spiel-Cheats zu erhalten.", "You are in the test mode. Use the cheat \"gamecheats\" to get a list of all game cheats."))
			call ACheat.create("gamecheats", true, thistype.onCheatActionCheats)
			call ACheat.create("classes", true, thistype.onCheatActionClasses)
			call ACheat.create("addspells", false, thistype.onCheatActionAddSpells)
			call ACheat.create("addskillpoints", false, thistype.onCheatActionAddSkillPoints)
			call ACheat.create("setspellsmax", false, thistype.onCheatActionSetSpellsMax)
			call ACheat.create("addclassspells", true, thistype.onCheatActionAddClassSpells)
			call ACheat.create("addotherclassspells", true, thistype.onCheatActionAddOtherClassSpells)
			call ACheat.create("movable", true, thistype.onCheatActionMovable)
			call ACheat.create("animation", false, thistype.onCheatActionAnimation)
		endmethod
endif
	endstruct

endlibrary
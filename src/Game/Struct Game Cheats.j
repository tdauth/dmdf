library StructGameGameCheats requires Asl, StructGameCharacter, StructGameClasses, StructGameGrimoire

	struct GameCheats
static if (DEBUG_MODE) then
		private static method onCheatActionCheats takes ACheat cheat returns nothing
			call Print(tre("Spiel-Cheats:", "Game Cheats:"))
			call Print(tr("classes - Listet alle verfügbaren Klassenkürzel auf."))
			call Print(tr("addspells <Klasse> - Der Charakter erhält sämtliche Zauber der Klasse im Zauberbuch (keine Klassenangabe oder \"all\" bewirken das Hinzufügen aller Zauber der anderen Klassen)."))
			call Print(tr("setspellsmax <Klasse> - Alle Zauber des Charakters der Klasse werden auf ihre Maximalstufe gesetzt (keine Klassenangabe oder \"all\" bewirken das Setzen aller Klassenzauber)."))
			call Print(tr("addskillpoints <x> - Der Charakter erhält x Zauberpunkte."))
			call Print(tr("addclassspells - Der Charakter erhält sämtliche Zauber seiner Klasse im Zauberbuch."))
			call Print(tr("addotherclassspells - Der Charakter erhält sämtliche Zauber der anderen Klassen im Zauberbuch."))
			call Print(tr("movable - Der Charakter wird bewegbar oder nicht mehr bewegbar."))
			call Print(tr("animation <index> - Spielt die Animation mit dem entsprechenden Index des Charakters ab."))
		endmethod

		private static method onCheatActionClasses takes ACheat cheat returns nothing
			call Print(tr("Klassenkürzelliste:"))
			call Print(StringArg(tr("%s - \"c\""), Classes.className(Classes.cleric())))
			call Print(StringArg(tr("%s - \"n\""), Classes.className(Classes.necromancer())))
			call Print(StringArg(tr("%s - \"d\""), Classes.className(Classes.druid())))
			call Print(StringArg(tr("%s - \"k\""), Classes.className(Classes.knight())))
			call Print(StringArg(tr("%s - \"s\""), Classes.className(Classes.dragonSlayer())))
			call Print(StringArg(tr("%s - \"r\""), Classes.className(Classes.ranger())))
			call Print(StringArg(tr("%s - \"e\""), Classes.className(Classes.elementalMage())))
			call Print(StringArg(tr("%s - \"w\""), Classes.className(Classes.wizard())))
		endmethod

		private static method onCheatActionAddSpells takes ACheat cheat returns nothing
			local string class = StringTrim(cheat.argument())
			if (class == "all" or class == null) then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addAllOtherClassSpells()
				call Print(tr("Alle anderen Klassenzauber erhalten."))
			elseif (class == "c") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addClericSpells()
				call Print(tr("Alle Klerikerzauber erhalten."))
			elseif (class == "n") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addNecromancerSpells()
				call Print(tr("Alle Nekromantenzauber erhalten."))
			elseif (class == "d") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addDruidSpells()
				call Print(tr("Alle Druidenzauber erhalten."))
			elseif (class == "k") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addKnightSpells()
				call Print(tr("Alle Ritterzauber erhalten."))
			elseif (class == "s") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addDragonSlayerSpells()
				call Print(tr("Alle Drachentöterzauber erhalten."))
			elseif (class == "r") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addRangerSpells()
				call Print(tr("Alle Waldläuferzauber erhalten."))
			elseif (class == "e") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addElementalMageSpells()
				call Print(tr("Alle Elementarmagierzauber erhalten."))
			elseif (class == "w") then
				call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addWizardSpells()
				call Print(tr("Alle Zaubererzauber erhalten."))
			else
				call Print(Format(tr("Unbekanntes Klassenkürzel: \"%1%\"")).s(class).result())
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
				call Print(tr("Alle Zauber auf ihre Maximalstufe gesetzt."))
			else
				call Print(tr("Konnte nicht alle Zauber ihre Maximulstufe setzen (eventuell nicht genügend Zauberpunkte)."))
			endif
		endmethod

		private static method onCheatActionAddSkillPoints takes ACheat cheat returns nothing
			local integer skillPoints = S2I(StringTrim(cheat.argument()))
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addSkillPoints(skillPoints, true)
			call Print(Format(tr("%1% Zauberpunkt(e) erhalten.")).i(skillPoints).result())
		endmethod

		private static method onCheatActionAddClassSpells takes ACheat cheat returns nothing
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addCharacterClassSpells()
			call Print(tr("Alle Klassenzauber erhalten."))
		endmethod

		private static method onCheatActionAddOtherClassSpells takes ACheat cheat returns nothing
			call Character(ACharacter.playerCharacter(GetTriggerPlayer())).grimoire().addAllOtherClassSpells()
			call Print(tr("Alle anderen Klassenzauber erhalten."))
		endmethod

		private static method onCheatActionMovable takes ACheat cheat returns nothing
			if (Character.playerCharacter(GetTriggerPlayer()) != 0) then
				if (Character.playerCharacter(GetTriggerPlayer()).isMovable()) then
					call Character.playerCharacter(GetTriggerPlayer()).setMovable(false)
					call Print(tr("Charakter unbewegbar gemacht."))
				else
					call Character.playerCharacter(GetTriggerPlayer()).setMovable(true)
					call Print(tr("Charakter bewegbar gemacht."))
				endif
			else
				call Print(tr("Sie haben keinen Charakter."))
			endif
		endmethod

		private static method onCheatActionAnimation takes ACheat cheat returns nothing
			local integer index = S2I(StringTrim(cheat.argument()))
			if (Character.playerCharacter(GetTriggerPlayer()) != 0) then
				call Print("Animation " + I2S(index))
				call SetUnitAnimationByIndex(Character.playerCharacter(GetTriggerPlayer()).unit(), index)
			else
				call Print(tr("Sie haben keinen Charakter."))
			endif
		endmethod

		public static method init takes nothing returns nothing
			call Print(tr("|c00ffcc00TEST-MODUS|r"))
			call Print(tr("Sie befinden sich im Testmodus. Verwenden Sie den Cheat \"gamecheats\", um eine Liste sämtlicher Spiel-Cheats zu erhalten."))
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
library StructGameTutorial requires Asl, StructGameCharacter, StructGameSpawnPoint

	/**
	 * Provides some functionality which helps players to find their way through the game.
	 * Firstly, you it can show automatic messages using interval \ref infoTimerDuration. All shown messages can be accessed and modified via \ref infos()
	 * Secondly, it shows a message when a players character enables a shrine the first time.
	 * Usually there's one Tutorial instance per character which can be accessed via \ref Character#tutorial().
	 * All provided infos can be disabled via \ref setEnabled().
	 */
	struct Tutorial
		private static constant real infoTimerDuration = 20.0
		// static members
		private static AStringVector m_infos
		// dynamic members
		private boolean m_isEnabled
		// construction members
		private Character m_character
		// members
		private boolean m_hasEnteredShrine
		private timer m_infoTimer
		private trigger m_killTrigger

		public method setEnabled takes boolean enabled returns nothing
			set this.m_isEnabled = enabled

			call PauseTimerBJ(not enabled, this.m_infoTimer)
		endmethod

		public method isEnabled takes nothing returns boolean
			return this.m_isEnabled
		endmethod

		public method character takes nothing returns Character
			return this.m_character
		endmethod

		public method hasEnteredShrine takes nothing returns boolean
			return this.m_hasEnteredShrine
		endmethod

		public method showInfo takes nothing returns nothing
			call this.m_character.displayHint(thistype.m_infos.random())
		endmethod

		public method showShrineInfo takes nothing returns nothing
			call this.m_character.displayHint(Format(tr("Schreine dienen der Wiederbelebung Ihres Charakters. Sobald Ihr Charakter stirbt, wird er nach einer Dauer von %1% Sekunden an seinem aktivierten Schrein wiederbelebt. Es kann immer nur ein Schrein aktiviert sein. Ein Schrein wird aktiviert, indem der Charakter dessen näheres Umfeld betritt. Dabei wird der zuvor aktivierte Schrein automatisch deaktiviert.")).i(R2I(MapData.revivalTime)).result())
			set this.m_hasEnteredShrine = true
		endmethod

		private static method timerFunctionInfo takes nothing returns nothing
			local timer expiredTimer = GetExpiredTimer()
			local thistype this = DmdfHashTable.global().handleInteger(expiredTimer, "this")

			if (this.m_character.isMovable()) then
				call this.showInfo()
			endif

			set expiredTimer = null
		endmethod

		private method createInfoTimer takes nothing returns nothing
			set this.m_infoTimer = CreateTimer()
			call DmdfHashTable.global().setHandleInteger(this.m_infoTimer, "this", this)
			call TimerStart(this.m_infoTimer, thistype.infoTimerDuration, true, function thistype.timerFunctionInfo)
			call PauseTimer(this.m_infoTimer)
		endmethod
		
		private static method triggerConditionKill takes nothing returns boolean
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this") 
			return GetKillingUnit() == this.character().unit() and this.isEnabled() and MapData.playerGivesXP.evaluate(GetOwningPlayer(GetTriggerUnit()))
		endmethod
		
		private static method triggerActionKill takes nothing returns nothing
			local thistype this = DmdfHashTable.global().handleInteger(GetTriggeringTrigger(), "this") 
			call DisableTrigger(GetTriggeringTrigger())
			call this.character().displayHint(tr("Immer wenn Ihr Charakter einen Unhold tötet, erhalten alle Charaktere gleichmäßig viel Erfahrung und Beute für diesen."))
			set this.m_killTrigger = null
			call DestroyTrigger(GetTriggeringTrigger())
		endmethod

		public static method create takes Character character returns thistype
			local thistype this = thistype.allocate()
			// dynamic members
			set this.m_isEnabled = false
			// construction members
			set this.m_character = character
			// members
			set this.m_hasEnteredShrine = false

			call this.createInfoTimer()
			call this.setEnabled(false)
			
			/*
			 * This trigger shows information about XP and bounty share of killing enemies.
			 */
			set this.m_killTrigger = CreateTrigger()
			call TriggerRegisterAnyUnitEventBJ(this.m_killTrigger, EVENT_PLAYER_UNIT_DEATH)
			call TriggerAddCondition(this.m_killTrigger, Condition(function thistype.triggerConditionKill))
			call TriggerAddAction(this.m_killTrigger, function thistype.triggerActionKill)
			call DmdfHashTable.global().setHandleInteger(this.m_killTrigger, "this", this)

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call PauseTimer(this.m_infoTimer)
			call DmdfHashTable.global().destroyTimer(this.m_infoTimer)
			set this.m_infoTimer = null
			if (this.m_killTrigger != null) then
				call DmdfHashTable.global().destroyTrigger(this.m_killTrigger)
			endif
		endmethod

		public static method infos takes nothing returns AStringVector
			return thistype.m_infos
		endmethod
		
		private static method initInfoQuests takes nothing returns nothing
			local quest whichQuest
			local questitem questItem
			/*
			 * Hint quest entries:
			 */
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Chat-Befehle", "Info: Chat Commands"))
			call QuestSetDescription(whichQuest, tre("Die obigen Befehle können im Chat verwendet werden.", "The commands at the top can be used in the chat."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-menu\" öffnet das Hauptmenü.", "\"-menu\" opens the main menu."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("\"-history n\" zeigt die n letzten Spielnachrichten an (standardmäßig fünf).", "\"-history n\" shows the recent n game messages (by default five)."))
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Ausrüstung", "Info: Equipment"))
			call QuestSetDescription(whichQuest, tre("Es gibt fünf verschiede Ausrüstungstypen. Von jedem Typ kann genau ein Gegenstand angelegt werden. Das letzte Fach bleibt dauerhaft leer, damit weiterhin Gegenstände eingesammelt werden können.", "There is five different equipment types. Of each type exactly one item can be equipped. The last slot stays permanently empty to still allow picking up items."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf denselben Gegenstand verschiebt den Gegenstand in den Rucksack.", "RM on item and LM on the same item moves the item in the rucksack."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Ausrüstungstypen: Helm, Rüstung, Erstwaffe, Zweitwaffe, Amulett/Ring", "Equipment types: helmet, armour, primary weapon, secondary weapon, amulet/ring"))
			call QuestSetCompleted(whichQuest, true)
			 
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Rucksack", "Info: Rucksack"))
			call QuestSetDescription(whichQuest, tre("Mit der Rucksackfähigkeit kann der Rucksack geöffnet werden. Es werden drei Gegenstände pro Tasche angezeigt. Die angezeigte Tasche kann gewechselt werden, indem man auf einen der beiden Taschengegenstände klickt.", "With the rucksack ability the rucksack can be open. Three items per bag will be shown. The shown bag can be changed by clicking on one of the two bag items."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf denselben Gegenstand rüstet den Gegenstand aus.", "RM on item and LM on the same item equips the item."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf anderen Gegenstand stapelt oder vertauscht die Gegenstände.", "RM on item and LM on another item stacks or swaps the items."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf den Boden legt eine Ladung des Gegenstands ab.", "RM on item and LM on the ground drops one charge of the item."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf anderen Charakter gibt dem anderen eine Ladung des Gegenstands.", "RM on item and LM on another character gives one charge of the item to the other."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf das vierte dauerhaft freie Slot legt den Gegenstand mit allen Ladungen ab.", "RM on item and LM on the fourth permanently empty slot drops the item with all charges."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("RM auf Gegenstand und LM auf einen Taschengegenstand verschiebt den Gegenstand in eine andere Tasche.", "RM on item and LM on a bag item moves the item to another bag."))
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Schreine", "Info: Shrines"))
			call QuestSetDescription(whichQuest, Format(tre("Schreine dienen der Wiederbelebung des Charakters. Es kann immer nur ein Schrein aktiviert werden. An diesem Schrein wird der Charakter nach %1% Sekunden wiederbelebt, wenn er gestorben ist. Den aktiven Schrein erreicht man über das Symbol links unten oder mit F8. Zu allen erkundeten Schreinen kann sich der Charakter mit Hilfe der Spruchrolle des Totenreichs teleportieren.", "Shrines are for the revival of the character. There can only be one shrine activated all the time. At this shrine the character will be revived after %1% seconds when he died. The active shrine can be reached over the symbol at the left bottom or by F8. The character can teleport himself to all discovered shrines by using the Scroll of the Realm of the Dead.")).i(R2I(MapData.revivalTime)).result())
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNResStone.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Gespräche mit Personen", "Info: Conversations with Persons"))
			call QuestSetDescription(whichQuest, tre("Einige computergesteuerte Personen im Spiel bieten Gespräche an. Befindet sich der Charakter in der Nähe einer Person und ist der Charakter ausgewählt, so kann man mit einem Linksklick die entsprechende Person auswählen und mit einem Linksklick auf \"Person ansprechen\" ein Gespräch mit der Person beginnen. Einzelne Sätze können während des Gesprächs mit Escape übersprungen werden.", "Some Computer controlled persons in the game provide conversations. Is a character near to a person and is the character selected you can select the corresponding person with a left click and start a conversation with the person by a left click on \"Speak to person\". Separate sentences can be skipped by Escape during the conversation."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNTalking2.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Händler", "Info: Traders"))
			call QuestSetDescription(whichQuest, tre("Einige der computergesteuerte Personen verkaufen Waren an einem Stand. Andere verkaufen Waren aus ihrer Kiste. An den Ständen und Kisten können eigene Gegenstände für ihren Wert in Goldmünzen verkauft werden. Dazu muss ein Gegenstand mit einem Rechtsklick ausgewählt und mit einem Linksklick auf dem entsprechenden Stand oder der entsprechenden Kiste platziert werden.", "Some Computer controlled persons sell goods at a stall. Others sell goods from their box. At stalls and boxes own items can be selled for their value in gold coins. For this an item must be selected with a right click and be placed with a left click on the corresponding stall or the corresponding box."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNMerchant.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Erfahrung", "Info: Experience"))
			call QuestSetDescription(whichQuest, tre("Die maximale Stufe ist 25. Auf Stufe 12 und Stufe 25 kann jeweils eine Ultimate-Fähigkeit erlernt werden. Erfahrung vom Töten von Unholden wird gleichmäßig auf alle Charaktere in der gesamten Karte verteilt. Aufträge geben weitaus mehr Erfahrung als das Töten von Unholden.", "The maximum level is 25. At leve l2 and level 25 each there can be learned an ultimate ability. Experience from killing of creeps will be distributed equally to the characters in the whole map. Quests give much more experience than the killing of creeps."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Erfahrung für Unholde: Unholderfahrung / Anzahl der Spieler", "Experience for creeps: Creep experience / Number of players"))
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Goldmünzen", "Info: Gold Coins"))
			call QuestSetDescription(whichQuest, tre("Goldmünzen erhält man für Aufträge und das Töten von Unholden. Die Goldmünzen durch das Töten von Unholden werden gleichmäßig an alle Charaktere auf der gesamten Karte verteilt. Aufträge geben weitaus mehr Goldmünzen als das Töten von Unholden.", "Gold coins are gained for quests and the killing of creeps. The gold coins gained by the killing of creeps will be distributed equally to all characters on the whole map. Quests give much more gold coins than the killing of creeps."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tre("Goldmünzen für Unholde: Unholdstufe * 2 / Anzahl der Spieler", "Gold coins for creeps: Creep level / Number of players"))
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Zauber", "Info: Spells"))
			call QuestSetDescription(whichQuest, tr("Jede Klasse besitzt 15 verschiedene Zauber. Diese können im Einheitenmenü \"Zauber erlernen\" des Charakters erlernt werden. Einen Grundzauber dessen Stufe stets eins ist und der von Anfang erlernt wurde. Zwei Ultimate-Zauber mit einer Stufe, die auf Stufe 12 und auf Stufe 25 erlernt werden können und zwölf gewöhnliche Zauber mit jeweils fünf Stufen. Das Erhöhen der Stufe eines Zaubers kostet einen Zauberpunkt. Pro Stufe erhält ein Charakter zwei Zauberpunkte. Er startet jedoch mit bereits drei Zauberpunkten. Zauberstufen können jederzeit wieder zurückgesetzt werden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSpellBook.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Berufe", "Info: Professions"))
			call QuestSetDescription(whichQuest, tr("Um bestimmte Gegenstände herzustellen, können Bücher mit Rezepten oder Plänen erworben werden. Darin befindet sich eine Liste der herstellbaren Gegenstände. Jeder Gegenstand benötigt Rohstoffe, die sich im Rucksack befinden müssen, damit der Gegenstand hergestellt werden kann."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSpellBookBLS.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Buch der Tränke"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Buch der Schmiedekunst"))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Buch der Magie"))
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tre("Info: Stützpunkte", "Info: Bases"))
			call QuestSetDescription(whichQuest, tr("Jeder Spieler kann einen einzigen Stützpunkt errichten. Der Stützpunkt ist ein Gebäude, das abhängig von der Klasse des Spielercharakters ist. Um einen Stützpunkt zu errichten, muss ein entsprechender Bauplan bei einem Baumeister gekauft werden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNTinyCastle.blp")
			call QuestSetCompleted(whichQuest, true)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_infos = AStringVector.create()

			// real infos

			// icon shortcuts
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um in den Rucksack Ihres Charakters zu öffnen bzw. zu schließen.")).s("R").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um in das Zauberbuch Ihres Charakters zu gelangen und die %2%-Taste, um es wieder zu verlassen.")).s("Z").s("Escape").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um Ihren Charakter auszuwählen.")).s("F1").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%- - %2%-Tasten , um einen Mitstreitercharakter auszuwählen.")).s("F2").s("F7").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um zu Ihrem derzeitig aktivierten Schrein zu gelangen.")).s("F8").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um Ihre Primär- und Sekundäraufträge zu sehen.")).s("F9").result())

			// main menu/settings
			call thistype.m_infos.pushBack(tr("Geben Sie \"-menu\" im Chat ein, um ins Hauptmenü des Spiels zu gelangen. Dort können Sie diverse Spieleinstellungen vornehmen."))
			call thistype.m_infos.pushBack(tr("Aktivieren Sie die 3rd-Person-Kamera im Hauptmenü, um eine rollenspielähnlichere Ansicht Ihres Charakters zu erhalten."))
			call thistype.m_infos.pushBack(tr("Aktivieren Sie die Charakter-Anzeige im Hauptmenü, um in der rechten oberen Bildschirmecke Informationen über Ihren und Ihre verbündeten Charaktere angezeigt zu bekommen."))
			call thistype.m_infos.pushBack(tr("Aktivieren Sie die Charakter-Buttons im Hauptmenü, um am linken Bildschirmrand Symbole Ihrer verbündeten Charaktere angezeigt zu bekommen, falls Sie sich nicht bereits die Kontrolle mit ihnen teilen."))
			call thistype.m_infos.pushBack(tr("Erlauben Sie Ihren Mitspielern die Kontrolle im Hauptmenü, damit diese Ihren Charakter steuern können."))

			// time
			call thistype.m_infos.pushBack(Format(tr("Getötete Gegner erscheinen, %1% Sekunden nachdem ihre gesamte Gruppe ausgelöscht wurde, automatisch wieder.")).i(R2I(SpawnPoint.respawnTime)).result())
			call thistype.m_infos.pushBack(Format(tr("Eingesammelte oder vernichtete Gegenstände erscheinen nach %1% Sekunden automatisch wieder.")).i(R2I(ItemSpawnPoint.respawnTime)).result())
			call thistype.m_infos.pushBack(Format(tr("Getötete Charaktere werden automatisch nach %1% Sekunden an ihrem aktivierten Schrein wiederbelebt. Dies wird in einem kleinen Fenster am oberen Bildschirmrand angezeigt.")).i(R2I(MapData.revivalTime)).result())

			// optional
static if (DMDF_INVENTORY) then
endif

static if (DMDF_TRADE) then
endif

static if (DMDF_CHARACTER_STATS) then
endif

static if (DMDF_INFO_LOG) then
endif

static if (DMDF_NPC_ROUTINES) then
			call thistype.m_infos.pushBack(tr("Computergesteuerte Charaktere in Städten, Dörfern oder außerhalb haben individuelle Tagesabläufe. Wundern Sie sich nicht, falls Sie Charaktere nicht immer an denselben Orten antreffen."))
endif

			call Tutorial.initInfoQuests()
		endmethod
		
		/**
		 * Prints a hint message to all players which have the tip system enabled.
		 */
		public static method printTip takes string tip returns nothing
			local integer i = 0
			loop
				exitwhen (i == MapData.maxPlayers)
				if (Character(Character.playerCharacter(Player(i))).tutorial().isEnabled()) then
					call Character(Character.playerCharacter(Player(i))).displayHint(tip)
				endif
				set i = i + 1
			endloop
		endmethod
	endstruct

endlibrary
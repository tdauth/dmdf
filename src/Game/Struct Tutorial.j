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
			call QuestSetTitle(whichQuest, tr("Info: Chat-Befehle"))
			call QuestSetDescription(whichQuest, tr("Die obigen Befehle können im Chat verwendet werden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("\"-menu\" öffnet das Hauptmenü."))
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Ausrüstung"))
			call QuestSetDescription(whichQuest, tr("Es gibt fünf verschiede Ausrüstungstypen. Von jedem Typ kann genau ein Gegenstand angelegt werden. Das letzte Fach bleibt dauerhaft leer, damit weiterhin Gegenstände eingesammelt werden können."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Rechtsklick auf Gegenstand und Linksklick auf denselben Gegenstand verschiebt den Gegenstand in den Rucksack."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Ausrüstungstypen: Helm, Rüstung, Erstwaffe, Zweitwaffe, Amulett/Ring"))
			call QuestSetCompleted(whichQuest, true)
			 
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Rucksack"))
			call QuestSetDescription(whichQuest, tr("Mit der Rucksackfähigkeit kann der Rucksack geöffnet werden. Es werden drei Gegenstände pro Tasche angezeigt. Die angezeigte Tasche kann gewechselt werden, indem man auf einen der beiden Taschengegenstände klickt."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNPackBeast.blp")
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Rechtsklick auf Gegenstand und Linksklick auf denselben Gegenstand rüstet den Gegenstand aus."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Rechtsklick auf Gegenstand und Linksklick auf anderen Gegenstand stapelt oder vertauscht die Gegenstände."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Rechtsklick auf Gegenstand und Linksklick auf den Boden legt eine Ladung des Gegenstands ab."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Rechtsklick auf Gegenstand und Linksklick auf anderen Charakter gibt dem anderen eine Ladung des Gegenstands."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Rechtsklick auf Gegenstand und Linksklick auf das vierte dauerhaft freie Slot legt den Gegenstand mit allen Ladungen ab."))
			set questItem = QuestCreateItem(whichQuest)
			call QuestItemSetDescription(questItem, tr("Rechtsklick auf Gegenstand und Linksklick auf einen Seitengegenstand verschiebt den Gegenstand in eine andere Tasche."))
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Schreine"))
			call QuestSetDescription(whichQuest, Format(tr("Schreine dienen der Wiederbelebung des Charakters. Es kann immer nur ein Schrein aktiviert werden. An diesem Schrein wird der Charakter nach %1% Sekunden wiederbelebt, wenn er gestorben ist. Den aktiven Schrein erreicht man über das Symbol links unten oder mit F8. Zu allen erkundeten Schreinen kann sich der Charakter mit Hilfe der Spruchrolle des Totenreichs teleportieren.")).i(R2I(MapData.revivalTime)).result())
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNResStone.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Gespräche mit NPCs"))
			call QuestSetDescription(whichQuest, tr("NPCs mit Ausrufezeichen bieten Gespräche an. Befindet sich der Charakter in der Nähe eines NPCs und hat man den Charakter ausgewählt, so kann man mit einem Rechtsklick auf den NPC ein Gespräch beginnen. Einzelne Sätze können mit Escape übersprungen werden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSelectHeroOn.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Händler"))
			call QuestSetDescription(whichQuest, tr("Einige der NPCs verkaufen Waren an einem Stand. Andere verkaufen Waren aus ihrer Kiste."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNMerchant.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Erfahrung"))
			call QuestSetDescription(whichQuest, tr("Die maximale Stufe ist 25. Auf Stufe 12 und Stufe 25 kann jeweils eine Ultimate-Fähigkeit erlernt werden. Erfahrung vom Töten von Unholden wird gleichmäßig auf alle Charaktere in der gesamten Karte verteilt. Aufträge geben weitaus mehr Erfahrung als das Töten von Unholden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNStatUp.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Goldmünzen"))
			call QuestSetDescription(whichQuest, tr("Goldmünzen erhält man für Aufträge und das Töten von Unholden. Die Goldmünzen durch das Töten von Unholden werden gleichmäßig an alle Charaktere auf der Karte verteilt. Aufträge geben weitaus mehr Goldmünzen als das Töten von Unholden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNChestOfGold.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Zauber"))
			call QuestSetDescription(whichQuest, tr("Jede Klasse besitzt 15 verschiedene Zauber. Diese können im Einheitenmenü \"Zauber erlernen\" des Charakters erlernt werden. Einen Grundzauber dessen Stufe stets eins ist und der von Anfang erlernt wurde. Zwei Ultimate-Zauber mit einer Stufe, die auf Stufe 12 und auf Stufe 25 erlernt werden können und zwölf gewöhnliche Zauber mit jeweils fünf Stufen. Das Erhöhen der Stufe eines Zaubers kostet einen Zauberpunkt. Pro Stufe erhält ein Charakter zwei Zauberpunkte. Er startet jedoch mit bereits drei Zauberpunkten. Zauberstufen können jederzeit wieder zurückgesetzt werden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSpellBook.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Berufe"))
			call QuestSetDescription(whichQuest, tr("Um bestimmte Gegenstände herzustellen, können Bücher mit Rezepten oder Plänen erworben werden. Darin befindet sich eine Liste der herstellbaren Gegenstände. Jeder Gegenstand benötigt Rohstoffe, die sich im Rucksack befinden müssen, damit der Gegenstand hergestellt werden kann."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNSpellBookBLS.blp")
			call QuestSetCompleted(whichQuest, true)
			
			set whichQuest = CreateQuest()
			call QuestSetTitle(whichQuest, tr("Info: Stützpunkte"))
			call QuestSetDescription(whichQuest, tr("Jeder Spieler kann einen einzigen Stützpunkt errichten. Der Stützpunkt ist ein Gebäude, das abhängig von der Klasse des Spielercharakters ist. Um einen Stützpunkt zu errichten, muss ein entsprechender Bauplan bei einem Baumeister gekauft werden."))
			call QuestSetIconPath(whichQuest, "ReplaceableTextures\\CommandButtons\\BTNTinyCastle.blp")
			call QuestSetCompleted(whichQuest, true)
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_infos = AStringVector.create()

			// real infos

			// icon shortcuts
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um in den Rucksack Ihres Charakters zu öffnen bzw. zu schließen.")).k("R").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um in das Zauberbuch Ihres Charakters zu gelangen und die %2%-Taste, um es wieder zu verlassen.")).k("Z").k("Escape").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um Ihren Charakter auszuwählen.")).k("F1").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%- - %2%-Tasten , um einen Mitstreitercharakter auszuwählen.")).k("F2").k("F7").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um zu Ihrem derzeitig aktivierten Schrein zu gelangen.")).k("F8").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um Ihre Primär- und Sekundäraufträge zu sehen.")).k("F9").result())

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
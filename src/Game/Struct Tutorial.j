library StructGameTutorial requires Asl, StructGameCharacter, StructGameSpawnPoint

	/**
	 * Provides some functionality which helps players to find their way through the game.
	 * Firstly, you it can show automatic messages using interval \ref infoTimerDuration. All shown messages can be accessed and modified via \ref infos()
	 * Secondly, it shows a message when a players character enables a shrine the first time.
	 * Usually there's one Tutorial instance per character which can be accessed via \ref Character#tutorial().
	 * All provided infos can be disabled via \ref setEnabled().
	 */
	struct Tutorial
		private static constant real infoTimerDuration = 30.0
		// static members
		private static AStringVector m_infos
		// dynamic members
		private boolean m_isEnabled
		// construction members
		private Character m_character
		// members
		private boolean m_hasEnteredShrine
		private timer m_infoTimer

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

			return this
		endmethod

		public method onDestroy takes nothing returns nothing
			// members
			call PauseTimer(this.m_infoTimer)
			call DmdfHashTable.global().destroyTimer(this.m_infoTimer)
			set this.m_infoTimer = null
		endmethod

		public static method infos takes nothing returns AStringVector
			return thistype.m_infos
		endmethod

		public static method init takes nothing returns nothing
			set thistype.m_infos = AStringVector.create()

			// real infos

			// icon shortcuts
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um in den Rucksack Ihres Charakters zu öffnen bzw. zu schließen.")).k("").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um in das Zauberbuch Ihres Charakters zu gelangen und die %2%-Taste, um es wieder zu verlassen.")).k("").k("").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um Ihren Charakter auszuwählen.")).k("F1").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%- - %2%-Tasten , um einen Mitstreitercharakter auszuwählen.")).k("F2").k("F7").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um zu Ihrem derzeitig aktivierten Schrein zu gelangen.")).k("F8").result())
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um Ihre Primär- und Sekundäraufträge zu sehen.")).k("F9").result())

			// main menu/settings
			call thistype.m_infos.pushBack(Format(tr("Drücken Sie die %1%-Taste, um ins Hauptmenü des Spiels zu gelangen. Dort können Sie diverse Spieleinstellungen vornehmen.")).k("Escape").result())
			call thistype.m_infos.pushBack(tr("Aktivieren Sie die 3rd-Person-Kamera im Hauptmenü, um eine rollenspielähnlichere Ansicht Ihres Charakters zu erhalten."))
			call thistype.m_infos.pushBack(tr("Aktivieren Sie die Charakter-Anzeige im Hauptmenü, um in der rechten oberen Bildschirmecke Informationen über Ihren und Ihre verbündeten Charaktere angezeigt zu bekommen."))
			call thistype.m_infos.pushBack(tr("Aktivieren Sie die Charakter-Buttons im Hauptmenü, um am linken Bildschirmrand Symbole Ihrer verbündeten Charaktere angezeigt zu bekommen, falls Sie sich nicht bereits die Kontrolle mit ihnen teilen."))
			call thistype.m_infos.pushBack(tr("Erlauben Sie Ihren Mitspielern die Kontrolle im Hauptmenü, damit diese Ihren Charakter steuern können."))

			// time
			call thistype.m_infos.pushBack(Format(tr("Getötete Gegner erscheinen, %1% Sekunden nachdem ihre gesamte Gruppe ausgelöscht wurde, automatisch wieder.")).i(R2I(SpawnPoint.respawnTime)).result())
			call thistype.m_infos.pushBack(Format(tr("Eingesammelte oder vernichtete Gegenstände erscheinen nach %1% Sekunden automatisch wieder.")).i(R2I(ItemSpawnPoint.respawnTime)).result())
			call thistype.m_infos.pushBack(Format(tr("Getötete Charaktere werden automatisch nach %1% Sekunden an ihrem aktivierten Schrein wiederbelebt. Dies wird in einem kleinen Fenster am oberen Bildschirmrand angezeigt.")).i(R2I(MapData.revivalTime)).result())
			call thistype.m_infos.pushBack(Format(tr("Zwischen %1% und %2% Uhr legen sich viele Bewohner schlafen. Sie können in dieser Zeit nicht angesprochen werden, da sie sich in ihren Häusern befinden.")).i(R2I(MapData.evening)).i(R2I(MapData.morning)).result())

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

static if (DMDF_CHARACTER_MEMORY_ADMINISTRATION) then
endif
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
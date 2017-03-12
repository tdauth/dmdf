library StructGameNpcFellows requires Asl, StructGameFellow

	/**
	 * \brief Standard fellows of the story shared by multiple maps.
	 */
	struct NpcFellows

		public static method createWigberht takes unit npc, ATalk talk returns Fellow
			local Fellow result = Fellow.create(npc, talk)
			call result.setTalk(false)
			call result.setRevival(true)
			call result.setDescription(tre("Wigberht ist der Prinz der Nordmänner. Er ist ein starker Nahkämpfer und besitzt die Fähigkeiten 'Ruf des Nordens', 'Unbeugsamkeit' und 'Rundumhieb'.", "Wigberht is the prince of the Norsemen. He is a strong melee fighter and has the abilities 'Call of the North', 'Rigidity' and 'All round blow'." ))
			call result.setRevivalTitle(tre("Wigberht", "Wigberht"))
			call result.setRevivalMessage(tre("Vorwärts!", "Forward!"))
			call result.setRevivalSound(null) /// \todo FIXME
			call result.addAbility('A0N5')
			call result.addAbility('A05F')
			call result.addAbility('A05I')

			return result
		endmethod

		public static method createRicman takes unit npc, ATalk talk returns Fellow
			local Fellow result = Fellow.create(npc, talk)
			call result.setTalk(false)
			call result.setRevival(true)
			call result.setDescription(tre("Ricman ist die rechte Hand von Wigberht. Er ist ein starker Nahkämpfer und besitzt die Fähigkeiten 'Loyalität', 'Sturmschlag' und 'Schildblock'.", "Ricman is the right hand of Wigberht. He is a strong melee fighter and has the abilities 'Loyalty', 'Storm bolt' and 'Shield Block'."))
			call result.setRevivalTitle(tre("Ricman", "Ricman"))
			call result.setRevivalMessage(tre("Ihr Hundesöhne, mich besiegt man nicht so leicht!", "You bastards, you do not defeat me that easy!"))
			call result.setRevivalSound(null) /// \todo FIXME
			call result.addAbility('A19M')
			call result.addAbility('A05G')
			call result.addAbility('A05J')

			return result
		endmethod

		public static method createDragonSlayer takes unit npc, ATalk talk returns Fellow
			local Fellow result = Fellow.create(npc, talk)
			call result.setTalk(false)
			call result.setRevivalTitle(tre("Drachentöterin", "Dragon Slayer"))
			call result.setRevivalMessage(tre("Für das Königreich der Hochelfen!", "For the kingdom of the high elves!"))
			call result.setRevival(true)
			call result.setRevivalSound(null) /// \todo FIXME
			call result.addAbility('A18T')
			call result.addAbility('A0PW')
			call result.addAbility('A09P')
			call result.addAbility('A1TO')

			return result
		endmethod
	endstruct

endlibrary
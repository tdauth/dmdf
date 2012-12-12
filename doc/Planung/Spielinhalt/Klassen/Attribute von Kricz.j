library ATTRIBUTE
 
globals
 
constant integer START_HP           = 100
constant real START_HP_REG          = 0.25
constant integer START_MANA         = 0
constant real START_MP_REG          = 0.01
 
constant integer START_POINTS       = 50
constant integer LEVEL_UP_POINTS    = 6
 
endglobals
 
method Geistliche Klassen
    string Hauptattribut = "Wissen"
    string Klassen = "Kleriker, Nekromant & Astralwandler"
    string Kategorie = "Heiler, Beschwörer & Supporter"
    Start: 19 / 10 / 21
    LevelUp: 2,2 / 1,1 / 2,7
endmethod
 
method Ritter
    string Hauptattribut = "Stärke"
    string Kategorie = "Damage-Dealer"
    Start: 23 / 19 / 18
    LevelUp: 2,2 / 1,1 / 2,7
endmethod
 
method Drachentöter
    string Hauptattribut = "Stärke"
    string Kategorie = "Tank"
    Start: 26 / 16 / 8
    LevelUp: 3,1 / 2 / 0.9
endmethod
 
method Waldläufer
    string Hauptattribut = "Geschick"
    string Kategorie = "Damage-Dealer"
    Start: 16 / 22 / 12
    LevelUp: 1,6 / 2,7 / 1,7
endmethod
 
method Magierklassen
    string Hauptattribut = "Geschick"
    string Klassen = "Elementarmagier, Zauberer & Illusionist"
    string Kategorie = "Damage-Dealer & Supporter"
    Start: 15 / 10 / 25
    LevelUp: 1,6 / 2,7 / 1,7
endmethod
 
endlibrary
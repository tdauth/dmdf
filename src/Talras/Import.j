//! import "Talras/Map/Import.j"
//! import "Talras/Quests/Import.j"
//! import "Talras/Spells/Import.j"
//! import "Talras/Talks/Import.j"
//! import "Talras/Videos/Import.j"

/*
Es können nur 16 verschiedene verwendet werden!
Theoretisch aber 16 verschiedene Boden- und 16 verschiedene Klippentexturen. Der Karteneditor
scheint wohl jede Klippentextur mit einer Bodentextur zu verknüpfen, weshalb insgesamt nur 16
verschiedene verwendet werden könne.
Weshalb manche Texturtypen jedoch 2 Plätze kosten, ist mir unerklärlich.
Das hässliche Gras und die hässlichen Blätter (Herbst) können weggelassen werden. Ebenso die
hässlichen Tannennadeln: 18 - 3 = 15 Noch Platz für ein weiteres Tileset.
//! external TileSetter L FdrtFdroFdrgWsngWrokBdrtBdrhLdroLdrgLrokLgrsFrokFgrsFgrdWdrtWdroWgrsWsnw

Y21 ist der letzte vom Projekt definierte Eintrag. Danach folgen die Standardeinträge Warcraft's.

Brauchen zwei Felder als Speicher
Gras 4
Erde 1
Erde 2
Erde 3
Terrain:
Old tileset ids:
///! external TileSetter L LgrsFdroFdrtFdrgWsngLgrdWdrtWdroWsnwWrokBdrtBdrhLdroLrokLdrgWgrsLgrsFgrsFgrdFrok

// New custom tileset ids:
//! externalblock TileSetter
//! i L
//! i Grs4
//! i Grd2
//! i Grd1
//! i Grd3
//! i Rok1
//! i Grs5
//! i Mos1
//! i Mos2
//! i Fis2
//! i Rok2
//! i Rod1
//! i Rod2
//! i Grs1
//! i Grs3
//! i Grs2
//! i Fis1
//! i Grs4
//! i Les2
//! i Les3
//! i Les1
//! endexternalblock
*/

library Map requires MapMap, MapQuests, MapSpells, MapTalks, MapVideos
endlibrary
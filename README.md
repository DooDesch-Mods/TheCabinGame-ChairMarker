# Cabin Chair Marker — 0.1.0-alpha

Markiert den Stuhl, den das Spiel deinem lokalen Spieler zugewiesen hat.
Standard: Blut-Decals auf Sitzfläche und Rückenlehne. Alternativ: blutiges
Kreuz oder Kreis. Vor der ersten Stuhlzuweisung wird nichts markiert.
Die Markierung bleibt auch beim Aufstehen bestehen, solange das Spiel diesen
Stuhl weiterhin zuweist. Bei einer neuen Zuweisung wird die alte Markierung entfernt.

Die Mod verändert keine Spielregeln oder Speicherstände und sendet keine RPCs.
Andere Spieler und der Host brauchen sie nicht. Bei einem Host mit Mod wird
nur dessen eigener Stuhl lokal markiert.

## Installation

Das Spiel zuerst beenden. UE4SS wird separat benötigt. Getestet wurde
UE4SS `v3.0.1-1164-g5e627997` mit Steam-Spielbuild `25553694`, Unreal 5.5.
Andere Builds sind nicht bestätigt. Der Loader ist nicht im ZIP enthalten.

Den Ordner `Mods/CabinChairMarker` aus dem ZIP nach
`the_cabin_game/Binaries/Win64/ue4ss/Mods/CabinChairMarker` kopieren.
`enabled.txt` aktiviert die Mod, ohne die gemeinsame `mods.txt` zu überschreiben.
Danach das Spiel starten. Vorhandene UE4SS-Konfigurationen beibehalten.

## Einstellungen

`Mods/CabinChairMarker/Scripts/settings.lua` im UE4SS-Ordner bearbeiten:

| Einstellung | Standard | Bedeutung |
|---|---|---|
| `enabled` | `true` | Markierung an/aus |
| `style` | `"blood"` | `"blood"`, `"cross"` oder `"circle"` |
| `size` | `18` | Halbe Decal-Breite, 5 bis 30 Unreal-Einheiten |
| `seat` | `true` | Sitzfläche markieren |
| `back` | `true` | Rückenlehne markieren |

Im Spiel: **F6** an/aus, **F7** Stil wechseln, **F8** Einstellungsdatei neu laden.
F6/F7 gelten für die laufende Sitzung; die Datei bestimmt den nächsten Start
und F8 setzt die Dateieinstellungen wieder ein. Fehler beim Nachladen erscheinen
im UE4SS-Log; die bisherigen Einstellungen bleiben erhalten.

## Teststand / Grenzen

Loader-Start, Stuhlerkennung und tatsächliche Decal-Komponenten wurden in einer
isolierten Spielkopie geprüft. Mit echten Engine-Komponenten geprüft: alle
drei Stile, F6/F7/F8-Callbacks, Größenänderung, Rückenlehne allein, Ausschalten,
Wechsel der Stuhlzuweisung, Vermeidung doppelter Decals und ungültiges Nachladen.
Die Decals sind nicht replizierend.

Ein tatsächlich verbundener lokaler IP-Testclient mit kontrollierter Stuhlzuweisung
zeigte zwei Blut-Decals nur am eigenen Stuhl; der Server ohne Mod hatte keine.

Die sichtbare Projektion und die komplette natürliche Sitzinteraktion in einer
Vier-Spieler-Steam-Runde sind noch nicht bestätigt. Die Grafik-Testkopie meldete
beim Screenshot-Test `GPU Crash dump Triggered`; weitere Prüfungen liefen ohne
Grafik. Deshalb Alpha. Die eingebauten Decals sind rot; freie Farbauswahl gibt
es nicht. Die Materialien stammen aus dem installierten Spiel und werden nicht
mitgeliefert.

Technische Grundlagen: [UE4SS Lua-Mods](https://docs.ue4ss.com/dev/guides/creating-a-lua-mod.html),
[LoadAsset auf dem Game Thread](https://docs.ue4ss.com/dev/lua-api/global-functions/loadasset.html)
und [lokale angehängte Decals](https://dev.epicgames.com/documentation/en-us/unreal-engine/BlueprintAPI/Rendering/Decal/SpawnDecalAttached).

## Entfernen

Das Spiel beenden und nur `ue4ss/Mods/CabinChairMarker` entfernen. Zur temporären
Deaktivierung im laufenden Spiel F6 verwenden. Das Entfernen von `enabled.txt`
deaktiviert die Mod beim nächsten Start, sofern sie nicht zusätzlich in `mods.txt`
aktiviert wurde.

Autor: DooDesch. GPL-3.0-only, siehe [LICENSE.md](LICENSE.md).
Der Lua-Quellcode liegt vollständig im Paket. Keine kompilierten Mod-Binaries.

Quellcode und Releases: [DooDesch-Mods/TheCabinGame-ChairMarker](https://github.com/DooDesch-Mods/TheCabinGame-ChairMarker).
Support: [support.doodesch.de](https://support.doodesch.de).

# Cabin Chair Marker - 0.2.0

> 🛟 **Need help or found a bug?** Get support at [support.doodesch.de/chairmarker](https://support.doodesch.de/chairmarker).

Mark the chair assigned to your local player in **the cabin game**. Blood decals
on the seat and backrest are the default. Overlapping puddles and a brighter red
tint give the blood style broad coverage. A bloody cross or circle is also available.

No marker appears before the game assigns a chair. Standing up keeps the marker
while that assignment remains. A new or cleared assignment removes the old marker.
The mod is cosmetic and client-only. It does not change saves or send gameplay
RPCs. The host and other players do not need it. A host with the mod sees a marker
on their own chair only.

## Requirements and installation

Close the game before installation. Download [UE4SS (latest experimental)](https://github.com/UE4SS-RE/RE-UE4SS/releases/tag/experimental-latest)
and select the basic `UE4SS_...zip` archive. The `zDEV` archive is for development.
The loader is not bundled. The current experimental release is the tested
`v3.0.1-1164-g5e627997` build. Later builds are not confirmed automatically.
For a fresh installation, extract its contents into
`the_cabin_game/Binaries/Win64`, next to `the_cabin_game-Win64-Shipping.exe`.
The archive contains `dwmapi.dll` and the `ue4ss` folder. If UE4SS is already
installed, check its version before replacing loader files or shared settings.

Copy `Mods/CabinChairMarker` from the archive into
`the_cabin_game/Binaries/Win64/ue4ss/Mods/CabinChairMarker` under the game folder.
The included `enabled.txt` enables the mod without replacing a shared `mods.txt`.
Keep your existing UE4SS configuration and start the game.

## Settings

Edit `ue4ss/Mods/CabinChairMarker/Scripts/settings.lua`:

| Setting | Default | Effect |
|---|---|---|
| `enabled` | `true` | Enable or disable marking |
| `style` | `"blood"` | `"blood"`, `"cross"` or `"circle"` |
| `size` | `18` | Base half-width, from 5 to 30 Unreal units; blood uses wider overlapping marks, while the cross and circle on the backrest are capped at 7 |
| `seat` | `true` | Mark the seat |
| `back` | `true` | Mark the backrest |

Use CabinModSettings to change these options in the main menu. Manual file
changes take effect after restarting the game. The mod registers no keyboard
shortcuts. All built-in styles are red; arbitrary colors are not supported.

## Compatibility

Version 0.1.2 was checked with UE4SS `v3.0.1-1164-g5e627997` and Steam game
build `25553694` (Unreal 5.5). Normal loader checks covered all three styles,
the former controls, actual settings-file reloads, sizes 5 and 30, assignment cleanup and
invalid-settings preservation. The blood style creates seven local,
nonreplicating decals. Rendered seat/backrest coverage was inspected under
DirectX 11, including reduced fixture lighting.

The screenshots use a controlled assigned-chair reference and inspection
lighting. Natural lighting and natural seating through a complete four-player
Steam round remain unconfirmed. Other game/loader builds are not confirmed.
The marker adds no light and cannot make the chair visible in complete darkness.

## Remove or disable

Close the game and remove only `ue4ss/Mods/CabinChairMarker`. Removing
`enabled.txt` disables the mod on the next
launch unless it was also enabled in `mods.txt`.

## Source and build

The complete Lua source is included. To build the mod archive,
run `python tools/package.py` from a checkout. Python 3 is required for packaging.

Implementation references: [UE4SS Lua mods](https://docs.ue4ss.com/dev/guides/creating-a-lua-mod.html),
[LoadAsset on the game thread](https://docs.ue4ss.com/dev/lua-api/global-functions/loadasset.html),
and [attached decals](https://dev.epicgames.com/documentation/en-us/unreal-engine/BlueprintAPI/Rendering/Decal/SpawnDecalAttached).

Author: DooDesch. See the [custom DooDesch license](LICENSE.md). Private changes
and contribution forks are allowed. Public redistribution, reuse in another work
and commercial use require prior written permission, subject to the license's
abandoned-software exception.

[Source and releases](https://github.com/DooDesch-Mods/TheCabinGame-ChairMarker).
## Release automation

GitHub Actions checks Lua syntax, release routing, reproducible packaging and
archive installation/removal boundaries on pushes and pull requests. The
`chairmarker-package-Linux` / `chairmarker-package-Windows` artifact contains the ZIP and checksum.

Publishing a GitHub release verifies its uploaded ZIP against the tagged source
and checksum. As in Palvolve, later Nexus updates use `NEXUS_FILE_GROUP_ID`
(the Files tab's API File ID) and the `NEXUSMODS_API_KEY` organization secret.
Store the same panel's Unique Mod ID in `NEXUS_MOD_ID` for mod-page changelogs.
The first Nexus page/file must be created manually. Until those settings exist,
the release records a skipped Nexus upload. Manual workflow runs check an
existing release by version number without the `v` prefix; `publish_nexus` must
be selected to upload a new Nexus version. The check also confirms the Nexus
file group through its read-only API when configuration is present.
An explicitly requested upload with missing configuration fails visibly.

Set `NEXUS_VORTEX_READY=true` only after the game extension and actual Nexus
manager download have been checked. Manual downloads work without Vortex.
After an unclear upload result, inspect Nexus's files before retrying.

## Optional Mod Settings

CabinModSettings discovers the existing options automatically. Apply validates and saves the same `Scripts/settings.lua` file; Cancel and Defaults do not write it. The previous valid file is kept as `settings.lua.previous`. Manual file edits remain supported. Settings registration requires UE4SS shared-variable support; the original mod remains usable if that optional registration is unavailable.

Enabled, Style, Size, Seat and Backrest are local settings. No mod hotkeys are registered. Manual settings.lua changes take effect after restarting the game. Extra serializable settings keys are preserved; unsupported extra values prevent Apply without replacing the file.

# Cabin Chair Marker - 0.1.0-alpha.2

> 🛟 **Need help or found a bug?** Get support at [support.doodesch.de/chairmarker](https://support.doodesch.de/chairmarker).

Mark the chair assigned to your local player in **the cabin game**. Blood decals
on the seat and backrest are the default. A bloody cross or circle is also available.

No marker appears before the game assigns a chair. Standing up keeps the marker
while that assignment remains. A new or cleared assignment removes the old marker.
The mod is cosmetic and client-only. It does not change saves or send gameplay
RPCs. The host and other players do not need it. A host with the mod sees a marker
on their own chair only.

## Requirements and installation

Close the game before installation. Install UE4SS separately. The tested loader
is `v3.0.1-1164-g5e627997`, with Steam game build `25553694` and Unreal 5.5.
Other combinations are not confirmed. The loader is not bundled.

Copy `Mods/CabinChairMarker` from the archive into
`the_cabin_game/Binaries/Win64/ue4ss/Mods/CabinChairMarker` under the game folder.
The included `enabled.txt` enables the mod without replacing a shared `mods.txt`.
Keep your existing UE4SS configuration and start the game.

## Settings and controls

Edit `ue4ss/Mods/CabinChairMarker/Scripts/settings.lua`:

| Setting | Default | Effect |
|---|---|---|
| `enabled` | `true` | Enable or disable marking |
| `style` | `"blood"` | `"blood"`, `"cross"` or `"circle"` |
| `size` | `18` | Decal half-width, from 5 to 30 Unreal units |
| `seat` | `true` | Mark the seat |
| `back` | `true` | Mark the backrest |

**F6** toggles the marker. **F7** cycles styles. **F8** reloads the settings file.
F6/F7 apply to the current session. The file determines the next launch, and F8
reapplies its settings. Invalid reloads keep the current settings and report an
error in the UE4SS log. All built-in styles are red; arbitrary colors are not supported.

## Alpha status

Real engine-component checks covered all three styles, size changes, seat/backrest
settings, F6/F7/F8 callbacks, cleanup after reassignment, duplicate prevention and
invalid settings reloads. The decal components do not replicate. A connected IP
test client with a controlled chair assignment had two blood decals on its own
chair; the server without the mod had none.

Rendered placement and natural seating in a complete four-player Steam round
remain unconfirmed. An isolated screenshot test reported `GPU Crash dump Triggered`.
This release does not claim stable gameplay compatibility. Materials come from
the installed game; no game assets are distributed.

## Remove or disable

Close the game and remove only `ue4ss/Mods/CabinChairMarker`. F6 disables the
marker during a session. Removing `enabled.txt` disables the mod on the next
launch unless it was also enabled in `mods.txt`.

## Source and build

The complete Lua source is included. To build the same five-file mod archive,
run `python tools/package.py` from a checkout. Python 3 is required for packaging.

Implementation references: [UE4SS Lua mods](https://docs.ue4ss.com/dev/guides/creating-a-lua-mod.html),
[LoadAsset on the game thread](https://docs.ue4ss.com/dev/lua-api/global-functions/loadasset.html),
and [attached decals](https://dev.epicgames.com/documentation/en-us/unreal-engine/BlueprintAPI/Rendering/Decal/SpawnDecalAttached).

Author: DooDesch. See the [custom DooDesch license](LICENSE.md). Private changes
and contribution forks are allowed. Public redistribution, reuse in another work
and commercial use require prior written permission, subject to the license's
abandoned-software exception.

[Source and releases](https://github.com/DooDesch-Mods/TheCabinGame-ChairMarker).

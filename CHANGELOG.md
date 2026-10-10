# Changelog

## 0.1.0-alpha.1 - 2026-10-10

- Apply the same custom DooDesch license clauses as ServerPasswordOnce, adapted to this mod and game.
- Align support links, release text and Nexus permission fields.
- Keep gameplay behavior unchanged. The original alpha retains its bundled GPL license.

## 0.1.0-alpha - 2026-10-10

- Initial client-only chair marker for the cabin game.
- Blood decals by default; bloody cross and circle alternatives.
- Settings for enabled state, size, seat and backrest placement.
- F6 toggles the marker, F7 cycles styles, F8 reloads settings.
- Removes old markers when the assigned chair changes or becomes unavailable.
- GPL-3.0-only; the complete Lua source is included in the download.

Validation: real engine-component checks passed for style changes, sizes,
placement toggles, cleanup, duplicate prevention and invalid settings reloads.
A connected non-authority IP test client with a controlled chair assignment had
two local blood decals; the server without the mod had none.

Still unconfirmed: rendered decal placement and natural chair assignment in a
complete four-player Steam round. An isolated screenshot test reported a GPU
crash. This is an alpha pre-release, not a stable compatibility claim.

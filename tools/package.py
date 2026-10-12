"""Build and verify the explicit, reproducible Lua mod archive."""
from pathlib import Path
import hashlib
import zipfile

root = Path(__file__).resolve().parents[1]
version = "0.2.0"
paths = [
    'Mods/CabinChairMarker/Scripts/main.lua',
    'Mods/CabinChairMarker/Scripts/settings.lua',
    'Mods/CabinChairMarker/Scripts/definition.lua',
    'Mods/CabinChairMarker/Scripts/cabin_legacy_settings.lua',
    'Mods/CabinChairMarker/Scripts/cabin_codec.lua',
    'Mods/CabinChairMarker/Scripts/cabin_registry.lua',
    'Mods/CabinChairMarker/Scripts/cabin_store.lua',
    'Mods/CabinChairMarker/enabled.txt',
    'Mods/CabinChairMarker/mod-info.ini',
    'README.md',
    'LICENSE.md',
]
dist = root / "dist"

def build():
    dist.mkdir(exist_ok=True)
    archive = dist / f"CabinChairMarker-{version}.zip"
    contents = {path: (root / path).read_bytes() for path in paths}
    with zipfile.ZipFile(archive, "w", zipfile.ZIP_DEFLATED) as package:
        for path, data in contents.items():
            entry = zipfile.ZipInfo(path, (2026, 10, 10, 0, 0, 0))
            entry.create_system = 3
            entry.compress_type = zipfile.ZIP_DEFLATED
            entry.external_attr = 0o100644 << 16
            package.writestr(entry, data)
    with zipfile.ZipFile(archive) as package:
        assert package.testzip() is None, "ZIP integrity failed"
        assert package.namelist() == paths, "unexpected archive paths"
        for path in paths:
            assert package.read(path) == contents[path], f"source mismatch: {path}"
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    (dist / "SHA256SUMS.txt").write_text(f"{digest}  {archive.name}\n", encoding="utf-8", newline="\n")
    print(f"confirmed: {archive.name}; files={len(paths)}; sha256={digest}")

if __name__ == "__main__":
    build()

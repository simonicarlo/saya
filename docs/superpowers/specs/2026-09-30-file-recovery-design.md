# File Recovery — Design

**Date:** 2026-09-30
**Status:** Approved, ready for implementation planning

## Goal

Saya's first module: carve deleted files out of raw disk images by signature,
show them visually, let the user preview and export them.

## Scope

**In:** header/footer carving of JPEG, PNG, PDF, ZIP from `.img`/`.dd`/`.bin`
files. Contiguous files only. Preview of results, export of selected files.
Light and dark themes.

**Out (later modules):** structure-aware carving, filesystem metadata parsing
(FAT/NTFS), physical device access, scan reports, entropy analysis.

## Decisions

| Decision | Choice | Why |
|---|---|---|
| Carving depth | Header/footer with max-size cap | Well understood, genuinely useful, obvious room to grow |
| Input | Image files only, read-only | No privileges, no risk, trivially testable |
| Concurrency | Engine blocks; app runs it on a worker thread | Keeps the engine Qt-free per CLAUDE.md |
| UI shape | One window, three states | Apple-like; avoids both wizard and dashboard feel |
| Themes | Light and dark from the start | Tokens make it nearly free; retrofitting is not |
| Output | Preview + export selected | Proves the carve worked without leaving the app |

## Engine (no Qt)

```
engine/
  byte_source.hpp    ByteSource interface; FileByteSource, MemoryByteSource
  signature.hpp      Signature value type + constexpr built-in table
  scanner.hpp        finds signature headers in a byte stream
  carver.hpp         headers -> CarvedFile list
  carve_result.hpp   CarvedFile, CarveCallbacks
```

**`ByteSource`** — `size()` and `read(offset, std::span<std::byte>)`.
`MemoryByteSource` exists so tests build synthetic images in RAM.

**`Signature`** — `{ name, extension, header, footer, maxSize }`. Footer may be
empty. Built-ins are a `constexpr` array; adding a format is one entry.

**`Scanner`** — reads 1 MiB chunks, searches each for every header. Chunks
overlap by `maxHeaderLength - 1` so signatures straddling a chunk boundary are
found; offsets are deduplicated. This is the classic carver bug and gets a
dedicated test.

**`Carver`** — per header, search forward for the format's footer. Found:
file is header..footer inclusive. Not found within `maxSize`: emit truncated
and flag it.

```cpp
struct CarvedFile {
    std::string_view type;
    std::uint64_t offset;
    std::uint64_t size;
    bool truncated;   // no footer found; size is the cap
};

struct CarveCallbacks {
    std::function<void(std::uint64_t done, std::uint64_t total)> onProgress;
    std::function<void(const CarvedFile&)> onFound;
};

std::vector<CarvedFile> carve(ByteSource&, std::span<const Signature>,
                             const CarveCallbacks&, const std::atomic_bool& cancel);
```

`carve` blocks, reports progress per chunk, reports each file as it completes,
and checks `cancel` between chunks. That is the entire external surface.

## App (Qt)

```
app/
  carve_controller.*      QObject facade; the only object QML talks to
  carve_worker.*          runs engine::carve on a QThread
  carved_file_model.*     QAbstractListModel of results
  disk_map_model.*        image bucketed into 512 map columns
  carved_image_provider.* serves carved image bytes to QML Image
```

`CarveController` exposes `state` (Empty/Scanning/Done/Failed), `progress`,
image name and size, and the two models. QML sees no threads or mutexes.

`CarveWorker` lives on a `QThread`; engine callbacks become Qt signals
delivered to the GUI thread by queued connections. The worker **batches**:
results accumulate and flush every ~100 ms, progress throttled to the same
beat, so the UI thread is not drowned in events.

`DiskMapModel` buckets the image into 512 columns, each knowing its coverage
and dominant type, so QML renders a plain `Repeater` and the bucketing stays
testable.

Previews come from a `QQuickImageProvider` (`image://carved/<index>`), decoding
on demand. Nothing is written to disk until the user exports.

## QML

```
app/qml/
  Main.qml                   window; swaps views on controller.state
  Theme.qml                  singleton: both palettes, spacing, type scale
  views/EmptyView.qml        drop target
  views/ScanView.qml         disk map + progress + live count
  views/ResultsView.qml      map + type summary + list + preview
  components/DiskMap.qml     the byte ribbon
  components/ResultList.qml
  components/PreviewPane.qml image, or HexView
  components/HexView.qml     offset | bytes | ascii
  components/Hairline.qml    1-physical-pixel rule
```

Components read `Theme.ink`, `Theme.sunset`, `Theme.space(3)` — never a
literal colour or number.

## Design language

Modern, clean, minimal, with a restrained Japanese touch. System font (SF Pro
on macOS); monospace only for hex offsets and byte values. Hierarchy by weight
before size. Hairlines at one physical pixel, no drop shadows, no nested boxes
— space separates, lines only where space cannot. Negative space generous and
asymmetric. Motion short, eased, and only to explain a change of state.

**Accent meaning:** sunset is *active, here, now* (scan head, selection);
sakura is *present but passive* (found-file markers, hover). Map type colours
are muted derivatives — clay, sand, sage, slate — never a rainbow.

| Role | Light | Dark |
|---|---|---|
| Ground | `#FAF7F2` | `#1A1817` |
| Surface | `#FFFDFB` | `#232020` |
| Ink | `#1B1917` | `#F2EDE6` |
| Ink muted | `#7A736B` | `#A09890` |
| Hairline | `#E6E0D8` | `#332F2C` |
| Sunset | `#C75B39` | `#C75B39` |
| Sakura | `#E9B8BC` | `#E9B8BC` |

Theme follows `Application.styleHints.colorScheme`.

## Testing

GoogleTest on the engine only. Fixtures are synthetic images built in memory
via `MemoryByteSource`:

- signature at a known offset -> found with exact offset and size
- header straddling a chunk boundary -> still found, not duplicated
- header with no footer -> emitted, `truncated == true`
- random noise -> nothing found
- empty source -> nothing found, no crash
- several types in one image -> all found, correctly typed
- cancellation -> scan stops early
- progress -> monotonic, ends at total

## Housekeeping (before feature work)

1. `git init`, `.gitignore` (`build/`, `.DS_Store`, `.qtcreator/`), initial commit.
2. `find_package(Qt6 ... COMPONENTS Quick Controls)` — Main.qml already uses
   Controls but CMake only requests Quick.
3. Retire the Hello World QML and the placeholder `saya::version()`.

## Build order

Each milestone ends with something that runs.

| | |
|---|---|
| M0 | Git, gitignore, CMake fix |
| M1 | Engine: byte source, signatures, scanner, carver — TDD throughout |
| M2 | Controller, worker thread, models — verified against a real image |
| M3 | Theme singleton + empty state, both palettes |
| M4 | Scan view with the live disk map |
| M5 | Results, preview, export |

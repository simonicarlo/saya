# Saya

Saya is a visual, desktop security toolkit. It starts with a single module, **file recovery** (carving deleted files out of disk images), and will grow with further modules over time, such as file-type identification, hash/integrity checks, metadata inspection and entropy analysis.

The name comes from the *saya* (鞘), the scabbard of a Japanese sword: it protects the blade from the world, and the world from the blade.

## Stack

- **C++23**, built with **CMake**
- **Qt 6** with a **QML / Qt Quick** UI
- **GoogleTest** for unit tests

## Structure

```
engine/   Pure C++ library with the core logic. No Qt dependencies.
app/      Qt Quick application (QML UI) that uses the engine.
tests/    GoogleTest unit tests for the engine.
```

Keep the engine independent of the UI so it stays testable and reusable.

## Design language

- Modern, clean and minimal, with plenty of negative space and a clear visual hierarchy.
- A subtle Japanese touch: calm, restrained colors, fine lines, and careful use of accents. Aim for understated elegance rather than decoration.
- Visual first: data such as disk layouts, recovered files and byte patterns should be shown visually wherever it helps understanding.
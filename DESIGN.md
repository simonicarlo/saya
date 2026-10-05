# Saya — Design Language

The name comes from the *saya* (鞘), the scabbard of a Japanese sword. A scabbard
is plain on the outside and precise on the inside. That is the whole brief.

Saya is an instrument, not a dashboard. It reads disks that may hold someone's
lost photographs, and it must look like it can be trusted with them: calm,
legible, and honest about what it does and does not know.

## Principles

**One bold thing.** The byte field is the hero — the disk image drawn as a grid
of cells, so you can see where files sit and how they cluster. Everything else
on screen is deliberately quiet so the field carries the page. Nothing else gets
to be loud.

**Structure is information.** A line, a border or a label appears only when it
encodes something. A separator means "these are different kinds of thing". A
colour means "this is a JPEG". Nothing is drawn to fill space.

**Space separates; lines only where space cannot.** Generous margins, and
asymmetric ones — emptiness sits off-centre rather than being balanced evenly
around content. This is where the Japanese influence actually lives, more than
in any colour choice.

**Honesty over polish.** A file carved without finding its footer is marked
truncated, not presented as clean. Empty and error states say what happened and
what to do next. The interface never implies more certainty than the engine has.

**Motion explains change.** Animation is allowed when it shows what just
happened — a view changing, a scan advancing, a row arriving. It is not used to
decorate arrival or hover.

## Colour

Warm paper and black ink, with two warm accents. Both themes are first-class;
neither is a filter over the other.

Colour is defined in two layers. (The singleton is called `Colors`, not
`Palette`: QtQuick already defines a `Palette` type, which would silently
shadow it.)

Layer one names the colours; layer two assigns them jobs. `Colors.qml` names every colour Saya owns
and says nothing about its use; `Theme.qml` assigns those names to roles. So a
colour can be adjusted in one place, and its job can be reassigned without
touching the colour.

The palette itself, named after traditional Japanese colours:

| Name | Hex | Meaning |
|---|---|---|
| `kinari` 生成り | `#F2EBDF` | Raw, unbleached silk |
| `shironeri` 白練 | `#FBF7EF` | Glossy white silk |
| `shironezumi` 白鼠 | `#DDD3C1` | White mouse, the palest grey |
| `sumi` 墨 | `#1B1917` | Ink stick |
| `sumiRaised` | `#232020` | Sumi, lifted for panels |
| `nezumi` 鼠 | `#7A736B` | Mouse grey |
| `usuzumi` 薄墨 | `#A09890` | Thinned ink |
| `tetsu` 鉄 | `#332F2C` | Iron |
| `shu` 朱 | `#C75B39` | Vermilion, seal ink |
| `shuLit` | `#DB6B42` | Shu, lifted for dark grounds |
| `sakura` 桜 | `#E9B8BC` | Cherry blossom |
| `sakuraDeep` | `#E0A8AD` | Sakura, deepened for dark grounds |

And the roles they fill:

| Role | Light | Dark | Use |
|---|---|---|---|
| Ground | `kinari` | `sumi` | Window background |
| Surface | `shironeri` | `sumiRaised` | Raised panels, rows |
| Ink | `sumi` | `kinari` | Primary text |
| Ink muted | `nezumi` | `usuzumi` | Secondary text, units, labels |
| Hairline | `shironezumi` | `tetsu` | Separators, borders |
| Sunset | `shu` | `shuLit` | Active, here, now |
| Sakura | `sakura` | `sakuraDeep` | Present, passive |

Note that `sumi` appears on both sides: it is the text on paper in the light
theme and the ground itself in the dark one. The ink becomes the field.

A `Lit` suffix always means the same thing — a lifted variant, so an accent
keeps its perceptual weight against a dark ground rather than its hex value.

Ink is never pure black and ground is never pure white — both are warmed, which
is what makes the surface read as paper rather than as a screen. The paper tones
deliberately sit well below full brightness (`kinari` is 95%, not 98%): above
that they stop reading as a material and start reading as an unlit screen.

**The two accents mean different things, and the distinction is strict:**

- **Sunset** is *active, here, now* — the scan head, the selected row, the
  primary action. Never more than one prominent sunset element on screen.
- **Sakura** is *present but passive* — the hover state on a row, and any
  marker that says "this exists" without claiming your attention. In the byte
  field, found files take their **type colour** rather than sakura, because
  there the colour has a more specific job to do: saying *which* type. Sakura
  would throw that away.

Sunset is lifted slightly in dark mode (`#DB6B42`) so it keeps the same
perceptual weight against a dark ground. The tokens are matched by role, not by
hex value.

### File-type colours

The byte field is the one place colour is allowed to multiply, and even there it
stays in the same warm, desaturated family — never a saturated category palette.

| Type | Light | Dark | Meaning |
|---|---|---|---|
| JPEG | `doki` `#B8875C` | `dokiLit` | 土器 earthenware |
| PNG | `matsuba` `#7E9070` | `matsubaLit` | 松葉 pine needle |
| PDF | `ainezumi` `#83879C` | `ainezumiLit` | 藍鼠 indigo grey |
| ZIP | `oudo` `#A89B76` | `oudoLit` | 黄土 yellow ochre |

## Typography

One family: the platform system font (SF Pro on macOS). No display serif — the
reference point is Apple's own tools, and a serif would pull the product towards
editorial rather than instrument.

Hierarchy comes from **weight and colour before size**. Three sizes cover almost
everything.

| Role | Size | Weight | Notes |
|---|---|---|---|
| Display | 26 | Light | One per view, at most |
| Title | 17 | Medium | View and panel headings |
| Body | 13 | Normal | Default |
| Small | 11 | Normal | Units, counts, secondary |
| Mono | 11.5 | Normal | First installed of `SF Mono`, `Menlo`, `Monaco` |

Monospace is used **only** for hexadecimal offsets and byte values, where
column alignment carries meaning. It is not a styling device for small labels.

Sentence case everywhere. No tracked-out capitals, no labels stacked above
content that already explains itself.

## Space

An 8-point grid, with a 4 half-step for tight pairings.

`xs 4 · sm 8 · md 16 · lg 24 · xl 40 · xxl 64`

Panel padding starts at `lg`. Window margins at `xl`. When in doubt, more.

## Shape and line

Border radius varies by hierarchy rather than being one value everywhere:

- `0` — byte field cells. Sharp, precise, data.
- `4` — buttons and chips.
- `8` — panels and the field container.

Hairlines are one *physical* pixel (`1 / devicePixelRatio`), so they stay hair
thin on retina displays instead of doubling. **No drop shadows anywhere** —
depth comes from the ground/surface contrast and from hairlines.

## Writing

Plain verbs, sentence case, active voice. A button says what will happen:
"Choose image", "Stop scan", "Export 4 files" — and the name does not change
between the button and its result.

Empty states invite an action. Errors say what happened and what to do, in the
interface's voice; they do not apologise and they are never vague.

Say what the user understands, not what the code does: "248 KB", not
"253952 bytes"; "no footer found", not "truncated flag set".

## Using the theme in QML

Components never name a colour, size or spacing literal — and never reach past
`Theme` to `Colors` either. A component asks for a role; only `Theme` knows
which colour fills it:

```qml
import saya

Rectangle {
    color: Theme.surface
    border.color: Theme.hairline
    border.width: Theme.hair
    radius: Theme.radiusPanel
}
```

`Theme.dark` resolves from `Application.styleHints.colorScheme`, so both themes
follow the system setting with no per-component branching. This is also why
adding a third theme later would be one file and no component changes.

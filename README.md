# arcologies

_an interactive environment for designing 2d sound arcologies with norns and grid_

![Latest Release](https://img.shields.io/github/v/release/northern-information/arcologies?sort=semver&color=%23f)

![the rewilding](https://northern-information.github.io/arcologies-docs/assets/images/the-rewilding.jpg)

![arctangents & archangels](https://northern-information.github.io/arcologies-docs/assets/images/arctangents-and-archangels.jpg)

![eternal september](https://northern-information.github.io/arcologies-docs/assets/images/eternal-september.jpg)

![arcologies](https://northern-information.github.io/arcologies-docs/assets/images/arcologies-landscape.jpg)

If you are an artist, musician, or arcologist here to use this tool, [everything you need to know is in the docs](https://northern-information.github.io/arcologies-docs). Join the discussion on [lines](https://l.llllllll.co/arcologies).

This README is for developers looking to contribute in building **arcologies**.

## Changelog

[The changelog is located here.](https://northern-information.github.io/arcologies-docs#changelog)

## Technical

- The [developer manual video](https://www.youtube.com/watch?v=NJlO2jajM6k) is the fastest way to learn **arcologies**. It includes a walkthrough of the architecture and deep dives into the most complex parts of the software.
- To learn the codebase, read [arcologies.lua](https://github.com/northern-information/arcologies/blob/main/arcologies.lua) and [lib/includes.lua](https://github.com/northern-information/arcologies/blob/main/lib/includes.lua).
- Next, skim through [keeper.lua](https://github.com/northern-information/arcologies/blob/main/lib/keeper.lua), [Cell.lua](https://github.com/northern-information/arcologies/blob/main/lib/Cell.lua), [Signal.lua](https://github.com/northern-information/arcologies/blob/main/lib/Signal.lua), and [counters.lua](https://github.com/northern-information/arcologies/blob/main/lib/counters.lua).
- `Cell` and `Signal` are the only [classes](https://www.lua.org/pil/16.1.html). Signals are primitive. Cells are complex.
- [config.lua](https://github.com/northern-information/arcologies/blob/main/lib/config.lua) is where signal, cellular, and global behavior is composed.
- Cell traits/mixins are inside [lib/mixins](https://github.com/northern-information/arcologies/blob/main/lib/mixins). Even though there are many different types of cell structures, they're all just instances of the same Cell class. Changing their structure toggles behaviors and traits on and off (e.g. `cell:change("TOPIARY")` will update the structure of the selected cell, hide the attributes that no longer apply, and activate the topiary attributes).
- Saving and loading (`fn.collect_data_for_save()` & `fn.load()`) is rudimentary and perhaps fragile. As the project evolves I'd like to take care and keep things as backwards-compatible as possible. May [athens.arcology](https://gist.github.com/tyleretters/384db1a15e645440141a627fdead50d9) always load!

## Contributing

Contributions are welcome, however I have some pretty firm boundaries about what **arcologies** is and is not. I recommend watching [all the videos in this playlist](https://www.youtube.com/playlist?list=PLe1BFUbUceS2N5GLgORKQrw1bsz2ZLwJ3) to get inside my head a bit more. If you have an idea for a significant undertaking that you'd like to contribute, please consider talking with me first. I'd hate to see you pour a bunch of energy into a feature that doesn't align with the vision. That said, I'll consider all feature requests! Thank you.

## Fork Additions

This fork adds a BEACON cell type and OSC output module for routing arcologies triggers to an external SuperCollider instance.

### BEACON

A new cell structure that fires an OSC message when a signal collides with it. Behaves like UXB/PYLON in all other respects — receives signals on open ports and routes them onward.

**Attribute:** `ID` (integer 1–99). Set this on each cell in the designer. The number is the only contract between Norns and SC — SC maps IDs to pattern handlers.

**Files added/modified:**

| File | Change |
|------|--------|
| `lib/_osc.lua` | New OSC send module |
| `lib/mixins/osc_id_mixin.lua` | New `ID` attribute mixin |
| `lib/structures.lua` | Registers `BEACON` |
| `lib/keeper.lua` | Collision handler + signal routing |
| `lib/glyphs.lua` | Full and small glyph (broadcast tower) |
| `lib/docs.lua` | In-app description |
| `lib/includes.lua` | Loads `osc_id_mixin` and `_osc` |
| `lib/Cell.lua` | Initialises `osc_id_mixin` |
| `lib/parameters.lua` | Adds `BEACON / OSC` params section |

### OSC Module (`_osc.lua`)

Sends `/arc/trigger` with a single integer argument (the cell's ID) when a BEACON is triggered.

```lua
-- message format on SC side:
-- msg[1] = "/arc/trigger"
-- msg[3] = id (integer)
OSCdef(\name, { |msg| var id = msg[3]; ... }, "/arc/trigger")
```

### Configuring the OSC Target

The target IP and port are set from the **BEACON / OSC** section of the Norns params menu — no file editing needed. Saves and restores with PSETs.

```
IP OCTET 1   192
IP OCTET 2   168
IP OCTET 3   1
IP OCTET 4   42
OSC PORT     57120
```

Default is `127.0.0.1:57120` (loopback). SC's default receive port is `57120`.

### SC Side

The companion SC include is `norns-router.scd` in the SC system repo. Register handlers keyed by the same integers set on BEACON cells:

```supercollider
~song[1] = { ~toggle.(\bassline) };
~song[2] = { ~oneshot.(\fill, 2) };
```

## Credits

Software design by [Tyler Etters](https://nor.the-rn.info).

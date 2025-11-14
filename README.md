# GameJamPlus 2025 - Co-op Split-Screen

## Overview

A 3D cooperative split-screen game for 2 players built in Godot 4.5. One player navigates the ground level to complete objectives and collect items, while the second player provides sniper cover from a top-down view. Work together to complete missions!

## Project structure

- **assets/** → Art, audio, fonts, shaders
- **config/** → Settings and translations
- **docs/** → Notes and changelog
- **scenes/** → Main game scenes and their respective `scripts`

## How to run

1. Install Godot 4.3 or later (4.5 recommended)
2. Open Godot and import this project
3. Run the main scene: `scenes/main.tscn`
4. See `docs/GAME_GUIDE.md` for detailed controls and gameplay instructions

## Naming conventions

These naming conventions follow the Godot Engine style. Breaking these will make your code clash with the built-in naming conventions, leading to inconsistent code. As a summary table:

| Type | Convention | Example |
| --- | --- | --- |
| File names | snake_case | `yaml_parsed.gd` |
| class_name | PascalCase | `class_name YAMLParser` |
| Node names | PascalCase | `Camera3D`, `Player` |
| Functions | snake_case | `func load_level():` |
| Variables | snake_case | `var particle_effect` |
| Signals | snake_case | always in past tense `signal door_opened` |
| Constants | CONSTANT_CASE | `const MAX_SPEED = 200` |
| enum names | PascalCase | `enum Element` |
| enum members | CONSTANT_CASE | `{EARTH, WATER, AIR, FIRE}` |

## Code order

```gdscript
01. @tool, @icon, @static_unload
02. class_name
03. extends
04. ## doc comment

05. signals
06. enums
07. constants
08. static variables
09. @export variables
10. remaining regular variables
11. @onready variables

12. _static_init()
13. remaining static methods
14. overridden built-in virtual methods:
 1. _init()
 2. _enter_tree()
 3. _ready()
 4. _process()
 5. _physics_process()
 6. remaining virtual methods
15. overridden custom methods
16. remaining methods
17. subclasses
```

## Credits

List any free/paid assets, tools, or contributors.

*Summarized from Godot Docs*.

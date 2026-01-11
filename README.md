# Game Jam Plus 2025

## Overview

An asymmetric local co-op survival game featuring two distinct roles:

- **The Shooter** (Mouse & Keyboard) -- Defends the team using a weapon.
- **The Looter** (Controller) -- Focuses on navigation and objective completion.

The goal is to gather collectibles while surviving against two distinct enemy types.

## Project structure

- **assets/** → Art, models, sprites, audio, and fonts
- **global/** → Configuration, and translation files
- **docs/** → Design notes and (potential) documentation
- **scenes/** → All game scenes alongside corresponding scripts (levels, players, UI, enemies) separated by category

## How to run

1. Clone the repository.
2. Import the project in **Godot 4.5+** (forward compatibility).
3. Run the main project scene.

## Naming conventions

### Godot

These naming conventions follow the Godot Engine style. Breaking these will make your code clash with the built-in naming conventions, leading to inconsistent code[^1]. As a summary table:

| Type | Convention | Example |
| --- | --- | --- |
| Folder and file names | snake_case | `yaml_parsed.gd` |
| class_name | PascalCase | `class_name YAMLParser` |
| Node names | PascalCase | `Camera3D`, `Player` |
| Functions | snake_case | `func load_level():` |
| Variables | snake_case | `var particle_effect` |
| Signals | snake_case | always in past tense `signal door_opened` |
| Constants | CONSTANT_CASE | `const MAX_SPEED = 200` |
| enum names | PascalCase | `enum Element` |
| enum members | CONSTANT_CASE | `{EARTH, WATER, AIR, FIRE}` |

### Git

Simple ruleset for naming branches in the project.

1. Use `kebab-case`.
2. Use prefix, as in `prefix/` to indicate purpose or the author.

Examples: `wujo/player-movement` or `feature/player-movement` (better version).

## Code order[^2]

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

**Developers**: Wujo, Felipe, Gabriela, Roxi, Kacper
**Engine**: Godot 4.5

[^1]: Summarized from Godot Docs.
[^2]: Ibidem.

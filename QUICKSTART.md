# Quick Start Guide

## Getting Started in 3 Steps

### 1. Open the Project
- Install Godot 4.3 or later (download from [godotengine.org](https://godotengine.org/))
- Open Godot Engine
- Click "Import" and select this project folder
- Click "Import & Edit"

### 2. Run the Game
- Press **F5** (or click the "Play" button in top-right corner)
- Alternatively: Right-click `scenes/main.tscn` → "Run Scene"

### 3. Play!
The screen splits into two views:

**Left Screen - Player 1 (Ground Operative):**
- **WASD** - Move around
- **Shift** - Sprint
- **E** - Interact with objectives (cubes)

**Right Screen - Player 2 (Sniper):**
- **Mouse** - Aim
- **Left Click** - Shoot
- **+/-** - Zoom in/out

## What to Do
1. Player 1 walks around collecting colored cubes
2. Player 2 eliminates patrolling enemies (capsule shapes)
3. Work together to complete objectives!

## Project Structure
```
game-jam-plus-2025/
├── project.godot          # Main project config
├── scenes/
│   ├── main.tscn         # Main game scene ← RUN THIS
│   └── scripts/          # All game scripts
├── global/
│   └── game_manager.gd   # Score tracking
└── docs/
    └── GAME_GUIDE.md     # Detailed documentation
```

## Troubleshooting

**Problem:** "Can't find project.godot"
- Make sure you're importing the project root folder

**Problem:** "Scene not found"
- Ensure `scenes/main.tscn` exists
- Check that all scripts are in `scenes/scripts/`

**Problem:** "Controls not working"
- Click on the game window to ensure it has focus
- Check Input Map in Project Settings

## Next Steps

Ready to customize? See:
- `docs/GAME_GUIDE.md` - Full feature documentation
- `docs/design-notes.md` - Technical architecture
- `docs/CODING-STANDARDS.md` - Code style guide

## For Game Jam Participants

This is a **ready-to-use template** for GameJamPlus 2025:

✅ Split-screen setup working
✅ Two player characters implemented
✅ Basic enemy system
✅ Objective collection mechanics
✅ 3D environment with physics

**You can now focus on:**
- Adding art and 3D models
- Creating levels and missions
- Adding sound effects and music
- Implementing game mechanics
- Polishing and balancing

Good luck with your game jam! 🎮

# Game Guide - 2-Player Co-op Split-Screen

## Overview

This is a 3D co-op game for 2 players built in Godot 4.5. One player moves on the ground collecting objectives and items, while the other player provides sniper cover from above.

## Game Concept

**Player 1 (Ground Player):**
- Navigate the 3D environment on foot
- Complete objectives and collect items
- Avoid enemies or dangers
- Points earned: 100 per objective, 50 per item

**Player 2 (Sniper):**
- View the battlefield from above
- Aim with mouse cursor
- Shoot to eliminate threats and cover Player 1
- Points earned: 10 per enemy eliminated

## Controls

### Player 1 (Ground Player) - Left Screen
- **W** - Move Forward
- **S** - Move Backward
- **A** - Move Left
- **D** - Move Right
- **Shift** - Sprint
- **E** - Interact (collect objectives/items)

### Player 2 (Sniper) - Right Screen
- **Mouse Movement** - Aim cursor
- **Left Click** - Shoot
- **+** (Plus/Equals) - Zoom In
- **-** (Minus) - Zoom Out

## How to Play

1. Open the project in Godot 4.3 or later
2. Run the main scene (`scenes/main.tscn`)
3. The screen will split horizontally:
   - Left side: Ground player's third-person view
   - Right side: Sniper's top-down view
4. Player 1 moves around to find and interact with objectives (large cubes) and items (small cubes)
5. Player 2 follows Player 1 from above and can shoot at threats
6. Work together to complete all objectives!

## Scene Structure

```
Main
├── Environment (3D world)
│   ├── DirectionalLight3D (sun)
│   ├── Floor (ground plane)
│   └── Walls (boundaries)
├── GroundPlayer (CharacterBody3D with camera)
├── SniperCamera (top-down Camera3D)
├── Objectives (collectible items)
└── SplitScreenUI (viewport containers)
    ├── Player1Viewport (left half)
    └── Player2Viewport (right half)
```

## Features Implemented

✅ Split-screen rendering with 2 independent viewports
✅ Ground player movement with physics
✅ Sniper camera following ground player
✅ Mouse-based aiming for sniper
✅ Zoom controls for sniper scope
✅ Interaction system for objectives
✅ Score tracking via GameManager
✅ Collision detection and physics layers
✅ Visual crosshair for sniper

## Extending the Game

### Adding Enemies
Create enemies on collision layer 4 (Enemies) with a `take_damage(amount)` method. The sniper can shoot them.

### Adding More Objectives
1. Duplicate an objective node in the scene
2. Change its `objective_id` in the inspector
3. Position it in the world

### Customizing Player Speed
Edit constants in `scenes/scripts/ground_player.gd`:
- `SPEED` - Normal movement speed
- `SPRINT_SPEED` - Sprint movement speed

### Changing Camera Settings
Edit constants in `scenes/scripts/sniper_camera.gd`:
- `CAMERA_HEIGHT` - How high the sniper camera hovers
- `MIN_FOV` / `MAX_FOV` - Zoom limits

## Tips for Game Jam

- Replace placeholder meshes with actual 3D models
- Add sound effects for shooting, collecting, and walking
- Create a proper UI with score display
- Add win/lose conditions
- Implement enemy AI
- Add more interactive elements
- Create multiple levels or missions
- Add visual effects (particles, muzzle flashes, etc.)

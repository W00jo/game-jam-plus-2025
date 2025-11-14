# Design Notes - Co-op Split-Screen Game

## Core Concept

A 2-player cooperative game where teamwork is essential:
- **Player 1 (Ground Operative)**: Moves on the ground, completes objectives, collects items
- **Player 2 (Sniper/Overwatch)**: Provides cover from above, eliminates threats

## Technical Architecture

### Split-Screen Implementation
- Uses `SubViewportContainer` nodes for each player's view
- Horizontal split (left/right) for better visibility
- Each viewport renders from its own camera
- `RemoteTransform3D` nodes link UI viewports to game cameras

### Player Systems

#### Ground Player
- **Node**: CharacterBody3D with collision
- **Movement**: WASD controls with sprint (Shift)
- **Interaction**: E key for objectives/items within range
- **Camera**: Third-person following camera (slight angle from behind)
- **Physics**: Uses Godot's physics engine with gravity

#### Sniper Player
- **Node**: Camera3D positioned above the world
- **Movement**: Camera follows ground player automatically
- **Aiming**: Mouse cursor for precise targeting
- **Shooting**: Left click casts ray to detect hits
- **Zoom**: +/- keys to adjust field of view

### Game Systems

#### Objectives & Items
- **Objectives**: Large cubes worth 100 points
- **Items**: Small cubes worth 50 points
- **Collision Layer**: 4 (Objectives)
- **Interaction**: Raycast from player to detect nearby interactables

#### Scoring
- Managed by global `GameManager` singleton
- Tracks scores separately for each player
- Emits signals when objectives completed or items collected

### Collision Layers
1. **World** (1): Environment, floors, walls
2. **Player** (2): Ground player character
3. **Objectives** (4): Collectible items and objectives
4. **Enemies** (8): Future enemy entities

## Future Expansion Ideas

### Immediate Additions
- Enemy AI that patrols and chases player
- Health system for ground player
- Ammo management for sniper
- UI overlay showing scores and objectives
- Sound effects and background music
- Win/loss conditions

### Advanced Features
- Multiple levels/missions
- Different weapon types for sniper
- Power-ups and special abilities
- Stealth mechanics (player detection)
- Time-based challenges
- Dialogue/story elements
- Procedural level generation

### Polish
- 3D models to replace placeholder shapes
- Particle effects (bullet impacts, collectible sparkles)
- Post-processing effects
- Minimap for ground player
- Bullet tracer effects for sniper
- Hit markers and damage numbers
- Screen shake on impacts

## Control Scheme Rationale

### Player 1 (Ground)
- WASD: Standard PC gaming controls
- Shift: Sprint (common in many games)
- E: Interact (intuitive for action key)

### Player 2 (Sniper)
- Mouse: Natural for aiming/shooting
- +/-: Zoom controls don't conflict with player 1
- Left Click: Standard shoot button

## Performance Considerations

- Split-screen doubles rendering load
- Keep geometry simple for prototyping
- Use LOD (Level of Detail) for complex scenes
- Consider reducing shadow quality if needed
- Optimize physics calculations

## GameJam Tips

1. **Scope Control**: Start minimal, add features incrementally
2. **Playtesting**: Test with 2 players early and often
3. **Iteration**: Rapid prototyping with placeholder art
4. **Communication**: Clear visual/audio feedback for actions
5. **Balance**: Make both roles feel important and fun

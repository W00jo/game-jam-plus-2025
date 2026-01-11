# Design Notes

## Core Concept

Local Co-op survival-horror game.

- **Win Condition** = Collect a specific number of items (Default: 5).
- **Fail Condition** = Player death (HP </ 0).

## Player Roles

### 1. The Shooter

- **Input**: Mouse & Keyboard.
- **Responsibilities**: combat.
- **Mechanics**:
  - Shooting;
  - Ammo Management.

### 2. The Looter

- **Input**: Gamepad/Controller.
- **Responsibilities**: objective.
- **Mechanics**:
  - Collecting, only visible by them, objective parts.
  - Outrunning enemies.

## Enemies

### Stalker

- **Behaviour**: chases the player relentlessly.
- **Weakness**: ---
- **Stun Logic**: 
  - When "killed", speed drops to 0.
  - Stays stunned for x seconds.
  - Visual feedback.

### Gostek

- **Behaviour**: aggressive as soon as they spot the player.
- **States**: Walk → Scream (Attack).
- **Logic**: 
  - Animation Tree specific state machine.
  - Screams when in (melee) range, deals damage.

## Global Systems

### GameManager

 - Handles languages & main menu music.
 - Saves/Loads settings.

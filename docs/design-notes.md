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

### `game_manager.gd`

- Handles languages & main menu music.
- Saves/Loads settings (Music/SFX volumes and languages).

### High-score system

A hidden scoring mechanic that rewards skilled and fast gameplay.

**Score formula:**

$$
\text{Final Score} = 10000 - (\text{Seconds Elapsed} \times 10) + (\text{Enemies Killed} \times 100) + (\text{Treasures Collected} \times 500) - (\text{Citizens Killed} \times 300) - (\text{Damage Received} \times 150)
$$

**Components:**

| Component | Value | Description |
|-----------|-------|-------------|
| **Base score** | 10000 | Starting points |
| **Time penalty** | (-10) per second | Faster completion = higher score |
| **Enemy bonus** | +100 per kill | Reward for killing enemies |
| **Treasure bonus** | +500 per treasure | Optional collectibles boost score |
| **Citizen penalty** | (-300) per citizen | Heavy-ish penalty for shooting civilians |
| **Damage penalty** | (-150) per hit | Reward for avoiding damage |

**Notes:**

- Treasures are **optional** (not required to win) but provide the highest score boost
- Regular collectibles are required to win but don't affect the score
- The score is displayed on the victory screen
- Minimum score is 0 (never negative)

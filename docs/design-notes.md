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

### High-Score System

A hidden scoring mechanic that rewards skilled and fast gameplay.

**Score Formula:**
```
Final Score = Base Score - Time Penalty + Enemy Bonus + Treasure Bonus - Citizen Penalty - Damage Penalty
```

**Components:**

| Component | Value | Description |
|-----------|-------|-------------|
| **Base Score** | 10,000 | Starting points for all players |
| **Time Penalty** | -10 per second | Faster completion = higher score |
| **Enemy Bonus** | +100 per kill | Reward for combat efficiency |
| **Treasure Bonus** | +500 per treasure | Optional collectibles boost score significantly |
| **Citizen Penalty** | -300 per citizen | Heavy penalty for shooting civilians |
| **Damage Penalty** | -150 per hit | Reward for avoiding damage |

**Example Calculation:**
- Base: 10,000
- Time: 180 seconds → -1,800
- Enemies: 8 killed → +800
- Treasures: 2 collected → +1,000
- Citizens: 1 shot → -300
- Damage: 3 hits → -450
- **Final Score: 9,250**

**Notes:**
- Treasures are **optional** (not required to win) but provide the highest score boost
- Regular collectibles are required to win but don't affect the score
- The score is displayed on the victory screen
- Minimum score is 0 (never negative)

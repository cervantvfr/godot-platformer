# Godot Platformer

A small 2D pixel-art platformer built with Godot 4, made while learning
from HeartBeast's Godot platformer tutorials.

## Features

- **Smooth movement:** the player accelerates and decelerates instead of
  starting and stopping instantly. Ground friction and air resistance are
  tuned separately, so stopping in mid-air can feel different from stopping
  on the ground.
- **Variable jump height:** tap jump for a short hop, hold it for a full jump.
  Releasing jump early cuts the upward speed to half the jump velocity.
- **Coyote time:** for a short moment (0.05 s) after running off a ledge,
  the player can still jump.
- **Swappable movement presets:** all movement values (speed, acceleration,
  friction, jump velocity, gravity scale, air resistance) live in a
  `PlayerMovementData` resource, so you can change the feel without touching
  code. See [Tuning movement](#tuning-movement).
- **Slopes:** the player keeps a constant speed on slopes and snaps to the
  floor going downhill instead of bouncing off.
- **Animated character:** idle and run animations, with the sprite flipping
  to face the direction of movement.
- **Polygon terrain:** the level is a single `CollisionPolygon2D`; at runtime
  its shape is copied into a `Polygon2D`, so the collision shape you edit is
  also what's drawn on screen.
- **Pixel-perfect display:** renders at 320×180 and scales up to a 1280×720
  window with nearest-neighbour filtering.

## Controls

| Action     | Key                     |
| ---------- | ----------------------- |
| Move left  | Left arrow              |
| Move right | Right arrow             |
| Jump       | Space or Enter          |

## Tuning movement

The player's movement settings come from a `PlayerMovementData` resource.
Three presets are included:

| Property         | Default | Fast  | Slow  |
| ---------------- | ------- | ----- | ----- |
| `speed`          | 100     | 120   | 50    |
| `acceleration`   | 800     | 1000  | 200   |
| `friction`       | 1000    | 1000  | 1000  |
| `jump_velocity`  | -300    | -500  | -200  |
| `gravity_scale`  | 1.0     | 1.0   | 0.5   |
| `air_resistance` | 200     | 200   | 1000  |

To switch presets, open `player.tscn`, select the **Player** node, and drag
a different `.tres` file onto **Movement Data** in the Inspector.

To make your own preset, right-click in the FileSystem dock, choose
**Create New → Resource…**, pick `PlayerMovementData`, and change its values
in the Inspector.

## Running the project

1. Install [Godot 4.7](https://godotengine.org/download) or later
   (the standard build is enough; .NET is not required).
2. Clone this repository.
3. In the Godot Project Manager, click **Import** and select `project.godot`.
4. Press **F5** to run the main scene (`world.tscn`).

## Project structure

| File                              | Purpose                                                    |
| --------------------------------- | ---------------------------------------------------------- |
| `project.godot`                   | Project settings: main scene, resolution, renderer         |
| `world.tscn`                      | Main scene: the level geometry and the player              |
| `world.gd`                        | Draws the terrain from its collision polygon and sets a black background |
| `player.tscn`                     | Player scene: sprite animations, collision shape, coyote-jump timer |
| `player.gd`                       | Player movement, jumping, coyote time, and animation logic |
| `PlayerMovementData.gd`           | Resource script defining the tunable movement values       |
| `DefaultPlayerMovementData.tres`  | Default movement preset (used by the player)               |
| `FastPlayerMovementData.tres`     | Faster movement with a higher jump                         |
| `SlowPlayerMovementData.tres`     | Slow, floaty movement with low gravity                     |
| `Tiles/Characters/`               | Character sprites used by the player                       |                    |                   |

## Credits

- **Tutorial:** this project follows Godot tutorials by
  [HeartBeast](https://www.youtube.com/@uheartbeast).
- **Art:** [Pixel Platformer](https://kenney.nl/assets/pixel-platformer)
  by [Kenney](https://kenney.nl) (CC0).
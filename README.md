# Godot Platformer

A small 2D pixel-art platformer built with Godot 4, made while learning
from HeartBeast's Godot platformer tutorials.

## Features

- **Smooth movement:** the player accelerates and decelerates instead of
  starting and stopping instantly.
- **Variable jump height:** tap jump for a short hop, hold it for a full jump.
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

## Running the project

1. Install [Godot 4.7](https://godotengine.org/download) or later
   (the standard build is enough; .NET is not required).
2. Clone this repository.
3. In the Godot Project Manager, click **Import** and select `project.godot`.
4. Press **F5** to run the main scene (`world.tscn`).

## Project structure

| File                 | Purpose                                                    |
| -------------------- | ---------------------------------------------------------- |
| `project.godot`      | Project settings: main scene, resolution, renderer         |
| `world.tscn`         | Main scene: the level geometry and the player              |
| `world.gd`           | Draws the terrain from its collision polygon               |
| `player.tscn`        | Player scene: sprite animations and collision shape        |
| `player.gd`          | Player movement, jumping, and animation logic              |
| `Tiles/Characters/`  | Character sprites used by the player                       |

## Credits

- **Tutorial:** this project follows Godot tutorials by
  [HeartBeast](https://www.youtube.com/@uheartbeast).
- **Art:** [Pixel Platformer](https://kenney.nl/assets/pixel-platformer)
  by [Kenney](https://kenney.nl) (CC0).
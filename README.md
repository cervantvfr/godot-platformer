# Godot Platformer

A small 2D pixel-art platformer built with Godot 4, made while learning
from HeartBeast's Godot platformer tutorials.

## Features

- **Smooth movement:** the player accelerates and decelerates instead of
  starting and stopping instantly. Ground friction, air resistance, and air
  acceleration are tuned separately, so moving and stopping in mid-air can
  feel different from doing it on the ground.
- **Variable jump height:** tap jump for a short hop, hold it for a full jump.
  Releasing jump early cuts the upward speed to half the jump velocity.
- **Coyote time:** for a short moment (0.05 s) after running off a ledge,
  the player can still jump.
- **Double jump:** press jump again while in the air for one extra full-height
  jump. It recharges as soon as the player lands.
- **Wall jump:** press jump while touching a wall (and not standing on the
  floor) to kick off it, away from the wall. Wall jumps don't use up the
  double jump, so you can chain them between walls.
- **Swappable movement presets:** all movement values (speed, acceleration,
  friction, jump velocity, gravity scale, air resistance, air acceleration)
  live in a `PlayerMovementData` resource, so you can change the feel without
  touching code. See [Tuning movement](#tuning-movement).
- **Slopes:** the player keeps a constant speed on slopes up to 50° and snaps
  to the floor going downhill instead of bouncing off. On the player instance
  in `world.tscn`, `floor_constant_speed` is on and `floor_snap_length` is 2.
  `floor_max_angle` (50°) is set on the player scene.
- **Animated cat character:** idle, run, jump, double-jump, and wall-cling
  animations, with the sprite flipping to face the direction of movement.
- **Spikes and respawning:** touching spikes sends the player back to where
  they started. Each spike is a `spikes.tscn` instance containing a
  `hazard_area.tscn`, an `Area2D` on the **HazardArea** physics layer. The
  player's `HazardDetection` area watches only that layer, so any shape you
  add to a hazard area becomes deadly. See [Physics layers](#physics-layers).
- **Gems and level completion:** five animated gems are scattered around the
  level. Each is a `Gem.tscn` instance: an `Area2D` in the `Gems` group that
  only detects the **Player** layer. Touch a gem to collect it; when the last
  one is collected it emits `Events.level_completed`, and `world.gd` shows a
  "Level Completed!" overlay and pauses the game. To add more gems, drop extra
  `Gem.tscn` instances into `world.tscn`; the count updates automatically.
- **Signal bus:** `Events.gd` is an autoload that holds game-wide signals
  (currently just `level_completed`), so scenes can talk to each other without
  holding direct references.
- **Following camera:** a smoothed `Camera2D` on the player keeps them in
  view as they climb the tall walls of the level.
- **Tilemap level:** the terrain is a `TileMap` (`level_tile_map.tscn`)
  instanced into `world.tscn`. The tileset is built from the Kenney tiles in
  `Tiles/`. Its physics layer is **World**, so painted tiles collide with the
  player. Solid tiles use a 16×16 box; some tiles use a sloped collision
  polygon. The tileset also has an autotile terrain named `Autotile`. The map
  has two layers, **Base** and **Slope**. The level you play is painted on
  **Base**, and those cells are stored on the instance in `world.tscn`.
- **Pixel-perfect display:** renders at 320×180 and scales up to a 1280×720
  window with nearest-neighbour filtering.

## Controls

| Action      | Key                                    |
| ----------- | -------------------------------------- |
| Move left   | Left arrow                             |
| Move right  | Right arrow                            |
| Jump        | Space or Enter                         |
| Double jump | Jump again while in the air            |
| Wall jump   | Jump while touching a wall in the air  |

## Tuning movement

The player's movement settings come from a `PlayerMovementData` resource.
Three presets are included:

| Property           | Default | Fast  | Slow  |
| ------------------ | ------- | ----- | ----- |
| `speed`            | 100     | 120   | 50    |
| `acceleration`     | 800     | 1000  | 200   |
| `friction`         | 1000    | 1000  | 1000  |
| `jump_velocity`    | -300    | -500  | -200  |
| `gravity_scale`    | 1.0     | 1.0   | 0.5   |
| `air_resistance`   | 200     | 200   | 1000  |
| `air_acceleration` | 600     | 600   | 600   |

`speed` and `jump_velocity` also set the wall jump: the player is pushed
away from the wall at `speed` and upward at `jump_velocity`.

To switch presets, open `player.tscn`, select the **Player** node, and drag
a different `.tres` file onto **Movement Data** in the Inspector.

To make your own preset, right-click in the FileSystem dock, choose
**Create New → Resource…**, pick `PlayerMovementData`, and change its values
in the Inspector.

## Physics layers

Layer names are set in `project.godot`:

| Layer | Name         | Used by                                               |
| ----- | ------------ | ----------------------------------------------------- |
| 1     | `World`      | The `TileMap` tileset physics layer in `level_tile_map.tscn` |
| 2     | `Player`     | The player's `CharacterBody2D`; detected by gems      |
| 3     | `HazardArea` | `hazard_area.tscn`; detected by the player to respawn |

## Running the project

1. Install [Godot 4.7](https://godotengine.org/download) or later
   (the standard build is enough; .NET is not required).
2. Clone this repository.
3. In the Godot Project Manager, click **Import** and select `project.godot`.
4. Press **F5** to run the main scene (`world.tscn`).

## Project structure

| File                              | Purpose                                                    |
| --------------------------------- | ---------------------------------------------------------- |
| `project.godot`                   | Project settings: main scene, resolution, renderer, physics layer names, `Events` autoload |
| `world.tscn`                      | Main scene: the tilemap level, spikes, gems, the player, and the level-completed overlay |
| `world.gd`                        | Sets a black background, and shows the overlay and pauses the game when the level is completed |
| `level_tile_map.tscn`             | `TileMap` scene: Kenney tileset (World-layer collision, `Autotile` terrain) with **Base** and **Slope** layers. The painted cells live on the instance in `world.tscn` |
| `player.tscn`                     | Player scene: cat sprite animations, collision shape, hazard detection area, coyote-jump timer, smoothed camera |
| `player.gd`                       | Player movement, jumping, double jump, wall jump, coyote time, respawning on hazards, and animation logic |
| `PlayerMovementData.gd`           | Resource script defining the tunable movement values       |
| `DefaultPlayerMovementData.tres`  | Default movement preset (used by the player)               |
| `FastPlayerMovementData.tres`     | Faster movement with a higher jump                         |
| `SlowPlayerMovementData.tres`     | Slow, floaty movement with low gravity                     |
| `spikes.tscn`                     | Spike trap: a Kenney spike tile plus a hazard area         |
| `hazard_area.tscn`                | Reusable `Area2D` on the HazardArea layer that respawns the player |
| `Gem.tscn`                        | Collectible gem: animated sprite and pickup area in the `Gems` group |
| `gem.gd`                          | Removes the gem on pickup and emits `Events.level_completed` when it was the last one |
| `Events.gd`                       | Autoloaded signal bus (`level_completed`)                  |
| `level_completed.tscn`            | "Level Completed!" overlay, shown on a `CanvasLayer` in `world.tscn` |
| `Cat/`                            | Cat character sprite sheets (32×32 frames). The player uses idle, walk, jump, double jump, and wall cling |
| `Tiles/`                          | Kenney Pixel Platformer tiles. They are the TileMap sources; `tile_0068.png` is also the spike sprite |
| `Collectibles/`                   | TotusLotus animated collectibles (16×16); `gem/gem.png` is used for the gems |

## Credits

- **Tutorial:** this project follows Godot tutorials by
  [HeartBeast](https://www.youtube.com/@uheartbeast).
- **Player character:** [Cat Player Asset](https://jumpbutton.itch.io/cat-player-asset)
  by [JumpButton](https://itch.io/profile/jumpbutton).
- **Tiles:** [Pixel Platformer](https://kenney.nl/assets/pixel-platformer)
  by [Kenney](https://kenney.nl) (CC0).
- **Collectibles:** [Animated Pixel Art Collectibles](https://totuslotus.itch.io/pixel-art-collectibles)
  by [TotusLotus](https://totuslotus.itch.io).

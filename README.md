# Catmaze

Catmaze is a puzzle game. To win, you must lure your cat through different
mazes using either toys or food.

![Demo](docs/demo.gif)

This game can be played [online](https://pinky39.github.io/catmaze/).

## For developers

My goal was to write a simple game (400 LOC) that can be used as a resource to 
learn game programming. Is uses [Godot game engine](https://godotengine.org/). 
All graphics were created with [Asesprite](https://www.aseprite.org/).

Game introduces the following concepts:

* 2D animation
* Tile maps and tile based movement
* Multiple levels and level editor
* In game menus and other UI elements
* Heads-up display (HUD) with inventory
* Collision detection and object tracking
* Saving progress (via level codes)

### Adding new levels
New levels can be added without programming using the level editor. They must 
be named `Level[level-number].tscn`. 

![Demo](docs/level-editor.jpg)

## Acknowledgments

This game uses the following pixel fonts:

 * [magero](https://code807.itch.io/magero)
 * [monocons](https://saint11.org/blog/fonts/)

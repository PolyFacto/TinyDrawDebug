# Tiny Draw Debug

A tiny and simple GDScript plugin for Godot 4 to quickly draw debug shapes in 3D (lines, cubes, spheres, cylinders, capsules, crosses, and circles).

## Installation

1. Put the plugin folder into your project's `addons/` directory.
2. Go to **Project -> Project Settings -> Plugins**.
3. Find **Tiny Draw Debug** and check the **Enable** box.
4. The singleton `TinyDrawDebug` is now ready to use anywhere in your code.

## How to use

### Draw for 1 frame (perfect for `_process` or `_physics_process`)
```gdscript
# A simple line
TinyDrawDebug.line(Vector3.ZERO, Vector3(0, 5, 0), Color.RED)

# A point/cross marker
TinyDrawDebug.cross(global_position, 1.0, Color.MAGENTA)

# A circle on the floor
TinyDrawDebug.circle(global_position, Vector3.UP, 2.5, Color.CYAN)
```
### Draw for x seconds
```gdscript
# A cube that stays for 3 seconds
DebugDraw3D.cube(Vector3.ZERO, Vector3(2, 2, 2), Color.BLUE, 3.0)

# A sphere that stays for 5 seconds
DebugDraw3D.sphere(global_position, 1.5, Color.GREEN, 5.0)

# A cylinder between two points
DebugDraw3D.cylinder(pos_a, pos_b, 0.5, Color.ORANGE, 2.0)

# A capsule between two points
DebugDraw3D.capsule(feet_position, head_position, 0.4, Color.YELLOW, 1.0)
```

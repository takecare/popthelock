# Pop the Lock

- Game consists of many levels
- Each level has a count (a number)
- On each level the player as to successfully hit the target "count"
number of times
- When they fail the target, they lose
- The speed increases from level to level

#### Crosshair & Target

Both `Crosshair` and `Target` extend `Rotatble`, which in turn extends
`Area2D`.

To detect collisions between the two we rely on the `area_entered` signal,
which is emitted by any`Area2D`s when another `Area2D` enters it.

In the Main scene, this the `Target` node has its `area_entered` signal
connected to the `Crosshair`'s `_on_Target_area_entered` method. `Target` also
has its `area_exited` signal connected to `Crosshair`'s
`_on_Target_area_exited`. This allows the `Crosshair` to monitor when it is
inside `Target`. In `Crosshair`'s `_physics_process` we consntaly monitor if a
click has happened. When a click does happen we emit either `on_target_hit` or
`on_target_missed`, depending on the value of `is_inside`.

#### Debug keys

| Scene | Key | Function |
| - | - | - |
| Main | H | Successful hit |
| Main | Y | Two successful hits in quick succession |
| Main | M | Missed hit |
| Main | P | Start game |
| Main | X | Zoom out |
| Main | Z | Zoom in |
| Score | W | Increase counter |
| Score | S | Decrease counter |

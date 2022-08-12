# Pop the Lock

- Game consists of many levels
- Each level has a count (a number)
- On each level the player as to successfully hit the target "count"
  number of times
- When they fail the target, they lose
- When the crosshair goes past the target, they lose
- The speed increases from level to level

#### Crosshair & Target

Both `Crosshair` and `Target` (scenes) follow the same structure. They're
composed of a body (which extends `Rotatable.gd`) and an `AnimationPlayer`.

##### Target

The `TargetBody` is composed of 3 `Area2D`s: a center one, a left side one, and
a right side one.

When another foreign `Area2D` enters or leaves on of these `Area2D`s, a
corresponding signal is emitted (`target_entered`, `target_exited`,
`target_entered_right`, `target_exited_right`, etc). These signals are connected
to the parent `Target` node, which in turn emits its own signals (same names).

The main scene - `Main` - is listening for these signals from `Target` and
effectively forwards them to the `Crosshair` by calling methods on it:
`on_target_area_entered()` and `on_target_area_exited()`. `Main` also keeps
track of the `Crosshair`'s status relative to the `Target` - i.e. if it has
gone past the target or not (see `CrosshairPosition`).

When a click (or tap) occurs, it's handled in the `Crosshair`. As `Main`
effectively informs the `Crosshair` when it's entered or left the `Target`,
the `Crosshair` keeps an internal flag - `is_inside` - of when it is inside
the `Target` or outside.

##### Rotatable

#### Debug keys

| Scene | Key | Function                                |
| ----- | --- | --------------------------------------- |
| Main  | H   | Successful hit                          |
| Main  | Y   | Two successful hits in quick succession |
| Main  | M   | Missed hit                              |
| Main  | P   | Start game                              |
| Main  | X   | Zoom out                                |
| Main  | Z   | Zoom in                                 |
| Score | W   | Increase counter                        |
| Score | S   | Decrease counter                        |

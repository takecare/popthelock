class_name CrosshairBody extends "Rotatable.gd"

# we emit these signals so our parent (Crosshair) receives them and then emits
# its own signals to up above
signal on_target_hit
signal on_target_missed

var is_inside: bool = false


func _ready() -> void:
  monitoring = true # make sure signals like area_entered/_exited are emitted
  $Sprite.visible = true
  $SmallerSprite.visible = false # used for animation only


func _physics_process(_delta: float) -> void:
  if !Input.is_action_just_pressed("click"):
    return

  var collisions = get_overlapping_areas()
  for c in collisions:
    print("> colliding with: ", c.name)

  if is_inside:
    _target_hit()
  else:
    _target_missed()


func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  .increase_rotation_around_by(point, angle)


func _target_hit() -> void:
  emit_signal("on_target_hit")


func _target_missed() -> void:
  emit_signal("on_target_missed")


# TODO how to determine how much both areas overlap?
# A: consider dividing the current collision shape into at least 3, whilst maintaining
# the same position - i.e. the 3 new shapes should form the current one. this way we
# can say that it's only a hit if the crosshair is overlapping all 3 areas (or 2)
# instead of just one

# to be connected to Target's area_entered signal, letting us know that an area2d
# has entered its (Target's) area2d. we don't actually check which area2d it is
# because at any moment in the game, we only have two overlapping area2d
# (crosshair and target areas)
func _on_target_area_entered(_area: Area2D) -> void:

  is_inside = true


func _on_target_area_exited(_area: Area2D) -> void:
  print("[xhair body] area exited: ", _area.name)

  is_inside = false


func _draw() -> void:
  draw_circle(position, 25.0, Color.blue)

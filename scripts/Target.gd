class_name Target extends "Rotatable.gd"

# adding collision shapes to the side would possible enable us to determine
# how much of the crosshair was inside vs outside when the player clicks/taps
# thus enabling us to score that hit on an arbitrary scale, instead of just
# hit vs miss

export(NodePath) var crosshair_path = null
onready var crosshair = get_node(crosshair_path) if crosshair_path != null else null
onready var crosshair_name = crosshair.name if crosshair != null else ""

var _last_point: Vector2

func _ready() -> void:
  pass

func _on_area_entered(area: Area2D) -> void:
  if area.name == crosshair_name:
    pass
  pass

func set_rotation_around(point: Vector2, angle: float):
  .set_rotation_around(point, angle)
  _last_point = point

func reset() -> void:
  reset_rotation(_last_point)

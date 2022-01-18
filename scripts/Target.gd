class_name Target extends "Rotatable.gd"

# adding collision shapes to the side would possible enable us to determine
# how much of the crosshair was inside vs outside when the player clicks/taps
# thus enabling us to score that hit on an arbitrary scale, instead of just
# hit vs miss

export(NodePath) var crosshairPath = null
onready var crosshair = get_node(crosshairPath) if crosshairPath != null else null
onready var crosshairName = crosshair.name if crosshair != null else ""

func _ready() -> void:
  pass

func _on_area_entered(area: Area2D) -> void:
  if area.name == crosshairName:
    pass
  pass

func set_rotation_around(point: Vector2, angle: float):
  .set_rotation_around(point, angle)

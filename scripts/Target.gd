class_name Target extends "Rotatable.gd"

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
  print("> TARGET: set rotation to " + str(angle))

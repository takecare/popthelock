class_name Target extends "Rotatable.gd"

# adding collision shapes to the side would possible enable us to determine
# how much of the crosshair was inside vs outside when the player clicks/taps
# thus enabling us to score that hit on an arbitrary scale, instead of just
# hit vs miss

export(NodePath) var crosshair_path = null
onready var crosshair = get_node(crosshair_path) if crosshair_path != null else null
onready var crosshair_name = crosshair.name if crosshair != null else ""


func _ready() -> void:
  # make sure signals like area_entered and area_exited are emitted
  monitoring = true


func _on_area_entered(area: Area2D) -> void:
  print("[target] area entered: ", area.name)
  if area.name == crosshair_name:
    pass
  pass


func _on_area_exited(area: Area2D) -> void:
  print("[target] area exited: ", area.name)
  pass


func _on_area_shape_entered(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
  print("[target] area shape entered: ", area.name)

func _on_area_shape_exited(area_id: int, area: Area2D, area_shape: int, local_shape: int) -> void:
  print("[target] area shape exited: ", area.name)

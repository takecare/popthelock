class_name Target extends "Rotatable.gd"

# note how Target is an Area2D even though it should be a Node2D. thi is because
# of how awful gdscript is. CrossairBody needs to be an Area2D but Target does
# not. if we declare Targe as a Node2D then CrosshairBody will forcefully be a
# Node2D as well, even though we define it (in the 2D editor) as an Area2D _and_
# Area2D inherits from Node2D

export(NodePath) var crosshair_path = null
onready var crosshair = get_node(crosshair_path) if crosshair_path != null else null
onready var crosshair_name = crosshair.name if crosshair != null else ""

signal target_entered_left
signal target_entered
signal target_exited
signal target_entered_right

func _ready() -> void:
  # make sure signals like area_entered and area_exited are emitted
  $Area2D.monitoring = true
  $LeftArea2D.monitoring = true
  $RightArea2D.monitoring = true


#
func _on_area_entered_in_target(area: Area2D) -> void:
  print("[target] area entered: ", area.name)
  emit_signal("target_entered")

#
func _on_area_exited_from_target(area: Area2D) -> void:
  print("[target] area exited: ", area.name)
  emit_signal("target_exited")

#
func _on_area_entered_in_left_target(area: Area2D) -> void:
  print("[left] area entered: ", area.name)

func _on_area_exited_from_left_target(area: Area2D) -> void:
  print("[left] area exited: ", area.name)

#
func _on_area_entered_in_right_target(area: Area2D) -> void:
  print("[right] area entered: ", area.name)

#
func _on_area_exited_from_right_target(area: Area2D) -> void:
  print("[right] area exited: ", area.name)

class_name TargetBody extends "Rotatable.gd"

# note how TargetBody is an Area2D even though it should be a Node2D. this is
# because of how awful gdscript is. CrossairBody needs to be an Area2D but
# TargetBody does not. if we declare TargetBody as a Node2D then CrosshairBody
# will forcefully be a Node2D as well, even though we define it
# (in the 2D editor) as an Area2D _and_ Area2D inherits from Node2D

signal target_entered
signal target_exited
signal target_entered_right
signal target_exited_right
signal target_entered_left
signal target_exited_left


func _ready() -> void:
  # make sure signals like area_entered and area_exited are emitted
  $Area2D.monitoring = true
  $LeftArea2D.monitoring = true
  $RightArea2D.monitoring = true


func _on_area_entered_in_target(area: Area2D) -> void:
  emit_signal("target_entered")

func _on_area_exited_from_target(area: Area2D) -> void:
  emit_signal("target_exited")


func _on_area_entered_in_left_target(area: Area2D) -> void:
  emit_signal("target_entered_left")

func _on_area_exited_from_left_target(area: Area2D) -> void:
  emit_signal("target_exited_left")


func _on_area_entered_in_right_target(area: Area2D) -> void:
  emit_signal("target_entered_right")

func _on_area_exited_from_right_target(area: Area2D) -> void:
  emit_signal("target_exited_right")

class_name Crosshair extends "Rotatable.gd"

signal on_target_hit
signal on_target_missed

var isInside: bool = false

func _ready() -> void:
  pass

func _physics_process(_delta: float) -> void:
  if !Input.is_action_just_pressed("click"):
    return
  if isInside:
    emit_signal("on_target_hit")
  else:
    emit_signal("on_target_missed")

# TODO how to determine how much both areas overlap?

func _on_Target_area_entered(_area: Area2D) -> void:
  isInside = true

func _on_Target_area_exited(_area: Area2D) -> void:
  isInside = false

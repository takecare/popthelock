class_name Crosshair extends "Rotatable.gd"

signal on_target_hit
signal on_target_missed

var is_inside: bool = false

func _ready() -> void:
  pass

func _physics_process(_delta: float) -> void:
  if !Input.is_action_just_pressed("click"):
    return
  if is_inside:
    emit_signal("on_target_hit")
  else:
    emit_signal("on_target_missed")

# TODO how to determine how much both areas overlap?
# A: consider dividing the current collision shape into at least 3, whilst maintaining
# the same position - i.e. the 3 new shapes should form the current one. this way we
# can say that it's only a hit if the crosshair is overlapping all 3 areas (or 2)
# instead of just one


func _on_Target_area_entered(_area: Area2D) -> void:
  is_inside = true


func _on_Target_area_exited(_area: Area2D) -> void:
  is_inside = false

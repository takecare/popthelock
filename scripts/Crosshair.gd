class_name Crosshair extends "Rotatable.gd"

var isInside: bool = false

func _ready() -> void:
  pass # Replace with function body.

func _physics_process(_delta: float) -> void:
  if Input.is_action_just_pressed("click") && isInside:
    print("click")

func _on_Target_area_entered(_area: Area2D) -> void:
  isInside = true

func _on_Target_area_exited(_area: Area2D) -> void:
  isInside = false

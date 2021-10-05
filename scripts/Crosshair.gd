class_name Crosshair extends "Rotatable.gd"

func _ready() -> void:
  pass # Replace with function body.

func _physics_process(_delta: float) -> void:
  if Input.is_action_just_pressed("click"):
    print("click")

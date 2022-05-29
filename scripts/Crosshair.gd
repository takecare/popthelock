class_name Crosshair extends Node2D

signal on_target_hit
signal on_target_missed

onready var body: CrosshairBody = $Body

func _ready() -> void:
  #body.position = Vector2(200,200)
  pass


func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  #var offset_point = point - position
  body.increase_rotation_around_by(point, angle)
  pass

func _target_hit() -> void:
  emit_signal("on_target_hit")


func _on_hit_animation_ended(animation_name: String) -> void:
  $Body._on_hit_animation_ended(animation_name)
  pass


func _target_missed() -> void:
  emit_signal("on_target_missed")


func _draw() -> void:
  draw_circle(position, 25.0, Color.red)

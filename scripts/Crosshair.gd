class_name Crosshair extends Node2D

signal on_target_hit
signal on_target_missed

onready var body: CrosshairBody = $Body

var is_animating: bool = false

func _ready() -> void:
  pass


func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  #rotate_to_face_point = !is_animating
  body.increase_rotation_around_by(point, angle)


func _target_hit() -> void:
  is_animating = true
  $AnimationPlayer.connect("animation_finished", self, "_on_hit_animation_ended", [], CONNECT_ONESHOT)
  $AnimationPlayer.play("hit", -1, 1.5)
  emit_signal("on_target_hit")


func _on_hit_animation_ended(animation_name: String) -> void:
  is_animating = false


func _target_missed() -> void:
  emit_signal("on_target_missed")


func _on_target_area_entered(_area: Area2D) -> void:
  $Body._on_target_area_entered(_area)


func _on_target_area_exited(_area: Area2D) -> void:
  $Body._on_target_area_exited(_area)


func _draw() -> void:
  draw_circle(position, 25.0, Color.red)

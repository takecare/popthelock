class_name Crosshair extends Node2D

signal on_target_hit
signal on_target_missed

onready var body := $Body

var is_animating: bool = false
var is_inside: bool = false

func _ready() -> void:
  pass


func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  body.increase_rotation_around_by(point, angle)


func _physics_process(_delta: float) -> void:
  if !Input.is_action_just_pressed("click"):
    return
  if is_inside:
    _target_hit()
  else:
    _target_missed()


func _target_hit() -> void:
  is_animating = true
  $AnimationPlayer.connect("animation_finished", self, "_on_hit_animation_ended", [], CONNECT_ONESHOT)
  $AnimationPlayer.play("hit", -1, 1.5)
  emit_signal("on_target_hit")


func _on_hit_animation_ended(animation_name: String) -> void:
  is_animating = false


func _target_missed() -> void:
  emit_signal("on_target_missed")


func _on_target_area_entered() -> void:
  is_inside = true


func _on_target_area_exited() -> void:
  is_inside = false

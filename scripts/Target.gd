class_name Target extends Node2D

signal target_entered
signal target_exited
signal target_entered_right
signal target_exited_right
signal target_entered_left
signal target_exited_left

signal disappeared

onready var body := $TargetBody


func _ready() -> void:
  pass


func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  body.increase_rotation_around_by(point, angle)

func appear() -> void:
  $AnimationPlayer.play("appear")

func disappear() -> void:
  $AnimationPlayer.play("disappear")

func disappeared() -> void:
  emit_signal("disappeared")

func reset() -> void:
  body.reset()


func _on_area_entered_in_target() -> void:
  emit_signal("target_entered")

func _on_area_exited_from_target() -> void:
  emit_signal("target_exited")


func _on_area_entered_in_left_target() -> void:
  emit_signal("target_entered_left")

func _on_area_exited_from_left_target() -> void:
  emit_signal("target_exited_left")


func _on_area_entered_in_right_target() -> void:
  emit_signal("target_entered_right")

func _on_area_exited_from_right_target() -> void:
  emit_signal("target_exited_right")

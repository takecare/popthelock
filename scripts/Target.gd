class_name Target extends Node2D

# warning-ignore:unused_signal
signal target_entered         # something has entered this target
# warning-ignore:unused_signal
signal target_exited          # something has left this target
# warning-ignore:unused_signal
signal target_entered_right   # something has entered the right side area of this target
# warning-ignore:unused_signal
signal target_exited_right    # something has exited the right side area of this target
# warning-ignore:unused_signal
signal target_entered_left    # something has entered the left side area of this target
# warning-ignore:unused_signal
signal target_exited_left     # something has exited the left side area of this target

signal disappeared            # the "disappear" animation has finished playing

onready var body: TargetBody = $TargetBody
onready var animation_player: AnimationPlayer = $AnimationPlayer

var monitoring: bool = false

func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  body.increase_rotation_around_by(point, angle)


func appear() -> void:
  animation_player.play("appear")

func disappear() -> void:
  animation_player.play("disappear")

func disappeared() -> void:
  emit_signal("disappeared")

func reset() -> void:
  body.reset()


func _on_area_entered_in_target() -> void:
  emit("target_entered")

func _on_area_exited_from_target() -> void:
  emit("target_exited")


func _on_area_entered_in_left_target() -> void:
  emit("target_entered_left")

func _on_area_exited_from_left_target() -> void:
  emit("target_exited_left")


func _on_area_entered_in_right_target() -> void:
  emit("target_entered_right")

func _on_area_exited_from_right_target() -> void:
  emit("target_exited_right")


func emit(name: String) -> void:
  if monitoring:
    print("emit: " + name)
    emit_signal(name)

extends Node2D

export(NodePath) var camera_path
var camera: Camera2D

export(float) var min_threshold = 1.0
export(float) var max_threshold = 5.0

var original_offset: Vector2

var initial_intensity = 0.0
var camera_shake_intensity = 0.0

var initial_duration = 0.0
var camera_shake_duration = 0.0

var current_min_threshold = min_threshold
var current_max_threshold = max_threshold


func _ready() -> void:
  camera = get_node(camera_path) if camera_path != null else null


func _process(delta: float) -> void:
  if camera_shake_duration == 0:
    return
  elif camera_shake_duration < 0:
    camera.offset = original_offset
    camera_shake_intensity = 0.0
    camera_shake_duration = 0.0
    return

  # we're calculating this on every frame but we don't need to
  var _delta = delta if delta > 0 else 0.016667 # i've seen delta == 0 some times
  var how_many_times_will_process_run = floor(initial_duration / _delta)
  var new_intensity = camera_shake_intensity - initial_intensity / how_many_times_will_process_run
  camera_shake_intensity = new_intensity if new_intensity >= 0.0 else 0.0

  # reduce the intensity as time goes by
  current_min_threshold = current_min_threshold - min_threshold / how_many_times_will_process_run
  current_max_threshold = current_max_threshold - max_threshold / how_many_times_will_process_run

  camera_shake_duration -= _delta
  var rand_sign = 1 if randf() < 0.5 else -1
  camera.offset = camera.offset + rand_sign * Vector2(
    rand_range(current_min_threshold, current_max_threshold),
    rand_range(current_min_threshold, current_max_threshold)
  ) * camera_shake_intensity


func shake(intensity: float = 3.0, duration: float = 1.0) -> void:
  original_offset = camera.offset
  initial_intensity = intensity
  camera_shake_intensity = intensity
  initial_duration = duration
  camera_shake_duration = duration
  current_min_threshold = min_threshold
  current_max_threshold = max_threshold


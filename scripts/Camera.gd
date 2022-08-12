class_name ZoomCamera extends Camera2D

onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
  pass


func zoom_in() -> void:
  animation_player.play("ZoomIn")


func _on_zoomed_in() -> void:
  # FIXME as we're playing the same animation ("ZoomIn") backwards when zooming
  # out, this callback gets called immediately (when zooming back out) -- this
  # can be easily fixed with a flag that tracks if we just played the zoom in or
  # zoom out animation (ugly tho)
  pass


func zoom_out() -> void:
  animation_player.play_backwards("ZoomIn")

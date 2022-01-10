extends Camera2D

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
  pass

func zoom_in() -> void:
  animationPlayer.play("ZoomIn")

func _on_zoomed_in() -> void:
  print("> on zoomed in")
  # FIXME as we're playing the same animation ("ZoomIn") backwards when zooming
  # out, this callback gets called immediately (when zooming back out)
  pass

func zoom_out() -> void:
  animationPlayer.play_backwards("ZoomIn")

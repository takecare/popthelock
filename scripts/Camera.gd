extends Camera2D

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
  pass # Replace with function body.

func zoom_in() -> void:
  animationPlayer.play("ZoomIn")

func _on_zoomed_in() -> void:
  print("> on zoomed in")

func zoom_out() -> void:
  animationPlayer.play_backwards("ZoomIn")

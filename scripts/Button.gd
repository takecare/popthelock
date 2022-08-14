class_name FadeButton extends TextureButton

signal tapped(origin) # same as "pressed" but sends a reference to the button
signal appeared

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
  var _result = connect("pressed", self, "_on_pressed")
  visible = true
  disabled = false
  modulate = Color(1, 1, 1, 1)


func _gui_input(event: InputEvent) -> void:
  if event is InputEventMouseButton and visible and !event.is_pressed():
    emit_signal("tapped", self)


func _on_pressed():
  # hack: due to the awful way godot manages input events (it does not stop their propagation), we
  # have to rely on _input() instead, otherwise the input is also seen as a click/tap in the game
  pass


func fade_out():
  animation_player.play("fade_out")


func _on_faded_out():
  disabled = true
  hide()


func fade_in():
  emit_signal("appeared")
  show()
  animation_player.play("fade_in")


func _on_faded_in():
  disabled = false

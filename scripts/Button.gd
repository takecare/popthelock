class_name FadeButton extends TextureButton

signal tapped(origin) # same as "pressed" but sends a reference to the button

onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
  var _ignored = connect("pressed", self, "_on_pressed")
  visible = true
  disabled = false
  modulate = Color(1, 1, 1, 1)


func _on_pressed():
  emit_signal("tapped", self)


func fade_out():
  animation_player.play("fade_out")


func _on_faded_out():
  disabled = true
  hide()


func fade_in():
  show()
  animation_player.play("fade_in")


func _on_faded_in():
  disabled = false

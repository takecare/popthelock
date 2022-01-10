class_name FadeButton extends TextureButton

signal tapped(origin) # same as "pressed" but sends a reference to the button

func _ready():
  connect("pressed", self, "_on_pressed")

func _on_pressed():
  emit_signal("tapped", self)

func fade_out():
  $AnimationPlayer.play("FadeOut")

func _on_faded_out():
  disabled = true
  hide()

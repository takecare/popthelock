extends Control

func _ready() -> void:
  pass


func _gui_input(_event: InputEvent) -> void:
  pass


func _on_start_button_tapped(_button: FadeButton) -> void:
  visible = false


func _on_start_button_appeared() -> void:
 visible = true

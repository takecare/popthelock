class_name CrosshairBody extends "Rotatable.gd"

onready var sprite: Sprite = $Sprite
onready var smaller_sprite: Sprite = $SmallerSprite

func _ready() -> void:
  monitoring = true
  sprite.visible = true
  smaller_sprite.visible = false # used for animation only


func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  .increase_rotation_around_by(point, angle)

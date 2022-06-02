class_name CrosshairBody extends "Rotatable.gd"


func _ready() -> void:
  monitoring = true
  $Sprite.visible = true
  $SmallerSprite.visible = false # used for animation only


func increase_rotation_around_by(point: Vector2, angle: float) -> void:
  .increase_rotation_around_by(point, angle)

class_name ScoreLayer extends CenterContainer

signal appeared # emtited when this score layer appears
signal disappeared # emtited when this score layer disappears

export(int) var score = 0 setget set_score,get_score

onready var animationPlayer: AnimationPlayer = $AnimationPlayer

# we'll have 2 ScoreLayers - does the engine share these sprites or does it load them twice?
const sprites = [
  preload("res://sprites/0.png"),
  preload("res://sprites/1.png"),
  preload("res://sprites/2.png"),
  preload("res://sprites/3.png"),
  preload("res://sprites/4.png"),
  preload("res://sprites/5.png"),
  preload("res://sprites/6.png"),
  preload("res://sprites/7.png"),
  preload("res://sprites/8.png"),
  preload("res://sprites/9.png")
]

func _ready() -> void:
  update()
  pass

# TODO is this needed/used?
func center_on(point: Vector2) -> void:
  set_global_position(
    Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2)
  )

func get_score() -> int:
  return score

func set_score(new: int) -> void:
  score = new
  update()

func appear() -> void:
  visible = true
  animationPlayer.play("Appear")

func _appeared() -> void:
  emit_signal("appeared")
  pass

func disappear() -> void:
  animationPlayer.play("Disappear")

func _disappeared() -> void:
  emit_signal("disappeared")
  visible = false
  # TODO update score to score + 1 ??

func reset() -> void:
  #animationPlayer.play_backwards("Disappear")
  $AnimationPlayer.seek(0, false)
  modulate = Color(1, 1, 1, 1)
  rect_scale = Vector2(1, 1)
  visible = true

# we have to reference nodes this way as this is called in the score setter,
# which means this runs before _ready()/onready
func update():
  var digit1: TextureRect = $HBoxContainer/Digit1
  var digit2: TextureRect = $HBoxContainer/Digit2
  var digit3: TextureRect = $HBoxContainer/Digit3
  var readable = str(score)
  var length = readable.length()
  if length == 1:
    digit1.texture = sprites[readable[0].to_int()]
    digit1.visible = true
    digit2.visible = false
    digit3.visible = false
  elif length == 2:
    digit1.texture = sprites[readable[0].to_int()]
    digit2.texture = sprites[readable[1].to_int()]
    digit1.visible = true
    digit2.visible = true
    digit3.visible = false
  else:
    digit1.texture = sprites[readable[0].to_int()]
    digit2.texture = sprites[readable[1].to_int()]
    digit3.texture = sprites[readable[2].to_int()]
    digit1.visible = true
    digit2.visible = true
    digit3.visible = true

func increase():
  set_score(score + 1)

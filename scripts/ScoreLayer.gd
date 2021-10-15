class_name ScoreLayer extends CenterContainer

export(int) var score = 0 setget set_score,get_score

onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var hBoxContainer: HBoxContainer = $HBoxContainer
#onready var digit1: TextureRect = $HBoxContainer/Digit1
#onready var digit2: TextureRect = $HBoxContainer/Digit2
#onready var digit3: TextureRect = $HBoxContainer/Digit3

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
  offset_pivot()

func center_on(point: Vector2):
  set_global_position(
    Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2)
  )

func get_score() -> int:
  return score

func set_score(new: int) -> void:
  score = new
  update()
  offset_pivot() # TODO re-calculate pivot offset on hBoxContainer

func disappear() -> void:
  animationPlayer.play("Disappear")

func reset() -> void:
  animationPlayer.play_backwards("Disappear")

func offset_pivot():
  # pivot offset on hBoxContainer must be its w/2 and its h/2
  $HBoxContainer.rect_pivot_offset = $HBoxContainer.rect_size / 2

# we have to reference nodes directly as this is called in the score setter,
# which means this runs before _ready()/onready
func update():
  var readable = str(score)
  var length = readable.length()
  if length == 1:
    $HBoxContainer/Digit1.texture = sprites[readable[0].to_int()]
    $HBoxContainer/Digit1.visible = true
    $HBoxContainer/Digit2.visible = false
    $HBoxContainer/Digit3.visible = false
  elif length == 2:
    $HBoxContainer/Digit1.texture = sprites[readable[0].to_int()]
    $HBoxContainer/Digit2.texture = sprites[readable[1].to_int()]
    $HBoxContainer/Digit1.visible = true
    $HBoxContainer/Digit2.visible = true
    $HBoxContainer/Digit3.visible = false
  else:
    $HBoxContainer/Digit1.texture = sprites[readable[0].to_int()]
    $HBoxContainer/Digit2.texture = sprites[readable[1].to_int()]
    $HBoxContainer/Digit3.texture = sprites[readable[2].to_int()]
    $HBoxContainer/Digit1.visible = true
    $HBoxContainer/Digit2.visible = true
    $HBoxContainer/Digit3.visible = true

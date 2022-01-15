class_name Score extends Node2D

export(int) var score = 3 setget set_score,get_score

onready var currentScoreLayer: ScoreLayer = $CurrentScoreLayer
onready var nextScoreLayer: ScoreLayer = $NextScoreLayer

func _ready() -> void:
  #set_score(score)
  currentScoreLayer.set_score(score)

  currentScoreLayer.visible = true
  nextScoreLayer.visible = false
  var _result = currentScoreLayer.connect("appeared", self, "_current_appeared")
  _result = currentScoreLayer.connect("disappeared", self, "_current_disappeared")
  _result = nextScoreLayer.connect("appeared", self, "_next_appeared")
  _result = nextScoreLayer.connect("disappeared", self, "_next_disappeared")

func center_on(_point: Vector2):
  #set_global_position(Vector2(point.x - rect_size.x / 2, point.y - rect_size.y / 2))
  currentScoreLayer.center_on(_point)
  nextScoreLayer.center_on(_point)
  pass

func get_score() -> int:
  return currentScoreLayer.get_score()

enum Mode { INCREASING, DECREASING }
var mode = Mode.DECREASING

func set_score(new: int) -> void:
  # we need to check if it's null because the first time this runs,
  # currentScoreLayer is not set yet
  if currentScoreLayer == null:
    return
  currentScoreLayer.set_score(new)
  #if mode == Mode.DECREASING:
  #  nextScoreLayer.set_score(new - 1)
  #else:
  #  nextScoreLayer.set_score(new + 1)
  score = new
  print("UPDATED score to "+str(new))

func increase() -> void:
  mode = Mode.INCREASING
  nextScoreLayer.set_score(score + 1)
  print("INC: score="+str(score)+" next="+str(nextScoreLayer.get_score()) + " curr="+str(currentScoreLayer.get_score()))
  currentScoreLayer.disappear()
  nextScoreLayer.appear()

func decrease() -> void:
  mode = Mode.DECREASING
  nextScoreLayer.set_score(score - 1)
  print("DEC: next="+str(nextScoreLayer.get_score()) + " curr="+str(currentScoreLayer.get_score()))
  currentScoreLayer.disappear()
  nextScoreLayer.appear()

func reset() -> void:
  # TODO animate counting down until 0
  set_score(0)
  currentScoreLayer.reset()
  nextScoreLayer.reset(false)

func _current_appeared() -> void:
  pass

func _current_disappeared() -> void:
  pass #print("> current disappeared: " + str(nextScoreLayer.get_score()))

func _next_appeared() -> void:
  currentScoreLayer.reset()
  nextScoreLayer.reset(false)
  if mode == Mode.DECREASING:
    print("NEXT APPEARED (DEC): setting current layer to "+str(score-1))
    currentScoreLayer.set_score(score-1) #set_score(score - 1)
    score = score - 1
    #nextScoreLayer.set_score(score)
  else:
    print("NEXT APPEARED (INC): setting current layer to "+str(score+1))
    currentScoreLayer.set_score(score+1) #set_score(score + 1)
    score = score + 1
    #nextScoreLayer.set_score(score)

func _next_disappeared() -> void:
  pass

# TODO debug only. remove
func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_W:
    increase()
    get_tree().set_input_as_handled()
  if event.scancode == KEY_S:
    decrease()
    get_tree().set_input_as_handled()

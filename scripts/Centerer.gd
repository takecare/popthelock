extends Container

# goal: update pivot_offest when children are hidden/displayed

# need to know total available width - i.e. my own width
# need to know left and right margins
# need to know space (horizontal) between each item to place
#

func _ready() -> void:
  pass

func _process(delta: float) -> void:
  pass

func _notification(what):
  if what == NOTIFICATION_SORT_CHILDREN:
    print("> re-size requested")
    for i in get_child_count():
      var child = get_child(i)
      if child.is_class("Control"):
        layout_child(i, child)
        #fit_child_in_rect(child, Rect2(Vector2(), rect_size))

# spread children horizontally
func layout_child(num: int, child: Control) -> void:
  var rect_size = _get_rect_size()
  var available_width = rect_size.x
  var available_height = rect_size.y
  var num_children = get_child_count()
  var width_per_child = available_width / num_children
  var child_pos = Vector2(width_per_child * (num+1), 0)
  var child_size = Vector2(width_per_child, 0)
  fit_child_in_rect(child, Rect2(child_pos, child_size))
  pass


func _get_rect_size() -> Vector2:
  if rect_size.x == 0 && rect_size.y == 0:
    return rect_min_size
  else:
    return rect_size


func set_some_setting():
  # Some setting changed, ask for children re-sort
  queue_sort()

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_G:
    $AnimationPlayer.play("Test")
  elif event.scancode == KEY_H:
    $TextureRect2.visible = !$TextureRect2.visible
  elif event.scancode == KEY_J:
    rect_pivot_offset = Vector2(rect_pivot_offset.x + 10, rect_pivot_offset.y + 10)
  get_tree().set_input_as_handled()

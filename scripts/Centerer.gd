extends Container

# goal: update pivot_offest when children are hidden/displayed

enum LayoutMode { SPREAD, PACKED }
export(LayoutMode) var layout_mode = LayoutMode.PACKED

var controls: Array

func _ready() -> void:
  for i in get_child_count():
    if get_child(i).is_class("Control"):
      controls.push_back(get_child(i))

func _process(_delta: float) -> void:
  pass


func _notification(what):
  if what == NOTIFICATION_SORT_CHILDREN:
    assert(layout_mode == LayoutMode.SPREAD || layout_mode == LayoutMode.PACKED, "Unsupported layout mode.")
    if layout_mode == LayoutMode.PACKED:
      layout_children_packed()
    elif layout_mode == LayoutMode.SPREAD:
      layout_children_spread()
    set_pivot_offset(rect_size/2)


func layout_children_packed() -> void:
  var num_children = controls.size()
  var rect_size = _get_rect_size()
  var available_width = rect_size.x
  var mid_point_x = available_width / 2
  print("> av. width = " + str(available_width))
  print("> mid pt x = " + str(mid_point_x))
  print("> width unit = " + str(controls[0].rect_size.x))

  # TODO consider only children that are visible

  if num_children % 2 == 0: # even num of children
    var starting_x = mid_point_x - (num_children / 2)
    for i in num_children:
      layout_child_packed(starting_x, i, controls[i])
  else: # odd num of children
    var width_unit = controls[0].rect_size.x
    var starting_x = mid_point_x - floor(num_children / 2) * width_unit
    for i in num_children:
      layout_child_packed(starting_x, i, controls[i])


func layout_children_spread() -> void:
  for i in get_child_count():
    var child = get_child(i)
    if child.is_class("Control"):
      layout_child_spread(i, child)


# spread children horizontally
func layout_child_spread(num: int, child: Control) -> void:
  var rect_size = _get_rect_size()
  var available_width = rect_size.x
  var available_height = rect_size.y
  var num_children = get_child_count()
  var width_per_child = available_width / num_children
  var child_pos = Vector2(width_per_child * (num+1), 0)
  var child_size = Vector2(width_per_child, 0)
  fit_child_in_rect(child, Rect2(child_pos, child_size))


#
func layout_child_packed(starting_x: int, i: int, child: Control) -> void:
  var rect_size = _get_rect_size()
  var available_width = rect_size.x
  var available_height = rect_size.y
  var center = rect_size / 2
  var child_size = Vector2(get_child(0).rect_size.x, 0) # assuming same size for all children
  var child_x_offset = child_size.x / 2
  var child_pos = Vector2(starting_x + child_size.x * i - child_x_offset, 0)

  print("x["+str(i)+"]="+str(child_pos.x))

  fit_child_in_rect(child, Rect2(child_pos, child_size))


func _get_rect_size() -> Vector2:
  if rect_size.x == 0 && rect_size.y == 0:
    return rect_min_size
  else:
    return rect_size

func _get_child_count() -> int:
  var count = 0
  for i in get_child_count():
    if  get_child(i).is_class("Control"):
      count += 1
  return count

func set_some_setting():
  # Some setting changed, ask for children re-sort
  queue_sort()

func _unhandled_key_input(event: InputEventKey) -> void:
  if event.echo || event.pressed: return
  if event.scancode == KEY_G:
    $AnimationPlayer.play("Test")
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_H:
    $AnimationPlayer.play_backwards("Test")
    get_tree().set_input_as_handled()
  elif event.scancode == KEY_J:
     $Blue.visible = !$Blue.visible
     get_tree().set_input_as_handled()

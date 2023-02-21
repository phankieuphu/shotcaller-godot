extends CanvasLayer
var game:Node

# self = game.ui

var fps:Node
var top_label:Node
var buttons:Node
var stats:Node
var minimap:Node
var minimap_container:Node
var rect_layer: Node
var shop:Node
var controls_menu:Node
var orders_menu:Node
var leaders_icons:Node
var scoreboard:Node
var orders_button:Node
var shop_button:Node
var controls_button:Node
var menu_button:Node
var inventories:Node
var active_skills:Node
var hud:Node

onready var main_menu = $"%main_menu"
onready var pause_menu = $"%pause_menu"
onready var team_selection_menu = $"%team_selection_menu"

var timer:Timer

func _ready():
	game = get_tree().get_current_scene()

	fps = get_node("%fps")
	top_label = get_node("%main_label")
	shop = get_node("%shop")
	stats = get_node("%stats")
	minimap_container = get_node("%minimap_container")
	minimap = minimap_container.get_node("minimap")
	rect_layer = minimap_container.get_node("rect_layer")
	buttons = get_node("%buttons")
	orders_menu = get_node("%orders_menu")
	controls_menu = get_node("%controls_menu")
	leaders_icons = get_node("%leaders_icons")
	scoreboard = get_node("%score_board")

	hud = get_node("hud")
	inventories = stats.get_node("inventories")

	controls_button = buttons.get_node("controls_button")
	shop_button = buttons.get_node("shop_button")
	orders_button = buttons.get_node("orders_button")
	
	active_skills = stats.get_node("active_skills")
	
	hide_all()


func map_loaded():
	game.ui.buttons_update()
	game.ui.orders_menu.build()


func process():
	# if opt.show.fps:
	var f = Engine.get_frames_per_second()
	var n = game.all_units.size()
	fps.set_text("fps: "+str(f)+" u:"+str(n))
	
	# minimap display update
	if minimap:
		if minimap.update_map_texture:
			minimap.get_map_texture()
		if game.camera.zoom.x <= 1:
			minimap.move_symbols()
			minimap.follow_camera()


func show_mid():
	hide_all()
	hide_menus()
	show()
	get_node("mid").visible = true


func show_main_menu():
	show_mid()
	main_menu.visible = true


func show_pause_menu():
	show_mid()
	pause_menu.visible = true


func show_team_selection():
	show_mid()
	game.ui.team_selection_menu.visible = true


func hide_menus():
	get_node("mid").visible = false
	main_menu.visible = false
	pause_menu.visible = false
	team_selection_menu.visible = false



func hide_all():
	minimap.visible = false
	rect_layer.visible = false
	for panel in self.get_children():
		panel.hide()


func show_all():
	minimap.visible = true
	rect_layer.visible = true
	for panel in self.get_children():
		panel.show()


func show_select():
	stats.update()
	if game.can_control(game.selected_unit):
		orders_button.disabled = false
	orders_menu.update()
	controls_menu.update()


func hide_unselect():
	stats.update()
	controls_menu.hide()
	orders_menu.hide()
	controls_button.disabled = true
	orders_button.disabled = true
	inventories.hide()
	shop.update_buttons()
	buttons_update()



func buttons_update():
	orders_button.set_pressed(orders_menu.visible)
	shop_button.set_pressed(shop.visible)
	controls_button.set_pressed(controls_menu.visible)


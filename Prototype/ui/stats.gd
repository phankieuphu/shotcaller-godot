extends ItemList
var game:Node


onready var hpbar = get_node("hpbar")


func _ready():
	game = get_tree().get_current_scene()
	hide()



func update():
	var unit = game.selected_unit
	clear_old_hpbar()
	if unit:
		show()
		get_node("name").text = unit.get_name()
		get_node("current_hp").text = "%s" % [max(unit.current_hp,0)]
		get_node("hp").text = "%s" % [unit.hp]
		add_new_hpbar(unit)
		get_node("damage").text = "Damage: %s" % unit.current_damage
		get_node("vision").text = "Vision: %s" % unit.current_vision
		get_node("range").text = "Range: %s" % unit.attack_hit_radius
		if unit.moves: get_node("speed").text = "Speed: %s" % unit.current_speed
		else: get_node("speed").text = ""
		var texture = unit.get_texture()
		var portrait = get_node("portrait/sprite")
		set_texture(portrait, texture)
		if unit.type == "leader" and unit.team == game.player_team:
			var gold = str(game.ui.inventories.leaders[unit.name].gold)
			get_node("gold").text = "%s" % gold
			get_node("gold_sprite").visible = true
		else:
			get_node("gold").text = ""
			get_node("gold_sprite").visible = false
	else:
		hide()


func set_texture(portrait, texture):
	portrait.texture = texture.data
	portrait.region_rect = texture.region
	portrait.material = texture.material
	portrait.scale = texture.scale
	var sx = abs(portrait.scale.x)
	portrait.scale.x = -1 * sx if texture.mirror else sx


func _on_stats_gui_input(event):
	if event is InputEventMouseButton and not event.pressed: 
		game.controls.unselect()


func clear_old_hpbar():
	for old_bar in hpbar.get_children():
		hpbar.remove_child(old_bar)
		old_bar.queue_free()


func add_new_hpbar(unit):
	var red = unit.hud.get_node("hpbar/red").duplicate()
	var green = unit.hud.get_node("hpbar/green").duplicate()
	red.scale *= Vector2(13,10)
	green.scale *= Vector2(13,10)
	hpbar.add_child(red)
	hpbar.add_child(green)

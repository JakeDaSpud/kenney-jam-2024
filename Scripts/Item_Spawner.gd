extends Node

# Single
var _Single_brown_donut = preload("res://Entities/Entities/Single/brown_donut_entity.tscn");
var _Single_burger = preload("res://Entities/Entities/Single/burger_entity.tscn");
var _Single_candy_corn = preload("res://Entities/Entities/Single/candy_corn_entity.tscn");
var _Single_ice_cream = preload("res://Entities/Entities/Single/ice_cream_entity.tscn");
var _Single_pink_donut = preload("res://Entities/Entities/Single/pink_donut_entity.tscn");
var _Single_pizza = preload("res://Entities/Entities/Single/pizza_entity.tscn");
var _Single_small_empty_glass = preload("res://Entities/Entities/Single/small_empty_glass_entity.tscn");
var _Single_small_full_glass = preload("res://Entities/Entities/Single/small_full_glass_entity.tscn");
var _Single_sushi_maki = preload("res://Entities/Entities/Single/sushi_maki_entity.tscn");
var _Single_sushi_nigiri = preload("res://Entities/Entities/Single/sushi_nigiri_entity.tscn");

var _Single_Items : Array = [
	_Single_brown_donut,
	_Single_burger,
	_Single_candy_corn,
	_Single_ice_cream,
	_Single_pink_donut,
	_Single_pizza,
	_Single_small_empty_glass,
	_Single_small_full_glass,
	_Single_sushi_maki,
	_Single_sushi_nigiri
]

# Double
var _Double_bottle = preload("res://Entities/Entities/Double/bottle_entity.tscn");
var _Double_brown_lollipop = preload("res://Entities/Entities/Double/brown_lollipop_entity.tscn");
var _Double_candy_cane = preload("res://Entities/Entities/Double/candy_cane_entity.tscn");
var _Double_cork_bottle = preload("res://Entities/Entities/Double/cork_bottle_entity.tscn");
var _Double_pink_lollipop = preload("res://Entities/Entities/Double/pink_lollipop_entity.tscn");
var _Double_tall_empty_glass = preload("res://Entities/Entities/Double/tall_empty_glass_entity.tscn");
var _Double_tall_full_glass = preload("res://Entities/Entities/Double/tall_full_glass_entity.tscn");
var _Double_yellow_lollipop = preload("res://Entities/Entities/Double/yellow_lollipop_entity.tscn");

var _Double_Items : Array = [
	_Double_bottle,
	_Double_brown_lollipop,
	_Double_candy_cane,
	_Double_cork_bottle,
	_Double_pink_lollipop,
	_Double_tall_empty_glass,
	_Double_tall_full_glass,
	_Double_yellow_lollipop
]

# Triple
var _Triple_cheese_corndog = preload("res://Entities/Entities/Triple/cheese_corndog_entity.tscn");
var _Triple_cheese = preload("res://Entities/Entities/Triple/cheese_entity.tscn");
var _Triple_cheese_hotdog = preload("res://Entities/Entities/Triple/cheese_hotdog_entity.tscn");
var _Triple_corndog = preload("res://Entities/Entities/Triple/corndog_entity.tscn");
var _Triple_hotdog = preload("res://Entities/Entities/Triple/hotdog_entity.tscn");
var _Triple_long_burger = preload("res://Entities/Entities/Triple/long_burger_entity.tscn");

var _Triple_Items : Array = [
	_Triple_cheese_corndog,
	_Triple_cheese,
	_Triple_cheese_hotdog,
	_Triple_corndog,
	_Triple_hotdog,
	_Triple_long_burger
]

var _can_spawn_single : bool = false;
var _can_spawn_double : bool = false;
var _can_spawn_triple : bool = false;
@onready var Game_Manager : Node2D = $"..".game_manager_reference;

func _ready():
	if (Game_Manager == null):
		print_debug("Game man was null");
		Game_Manager = $".".game_manager_reference as Node2D;
	

func _process(delta):
	if (!_can_spawn_triple):
		_update_spawn_pool();
	
	if (Game_Manager.game_started && Game_Manager.item_count < Game_Manager.max_item_count):
		_spawn_item();
	

func _update_spawn_pool() -> void:
	if (Game_Manager.round_count > 15):
		# Triple Added
		_can_spawn_triple = true;
		return;
	
	elif (Game_Manager.round_count > 10):
		# Double Added
		_can_spawn_double = true;
		return;
	
	elif (Game_Manager.game_started && !_can_spawn_single):
		# Singles Added. Now we can spawn!
		_can_spawn_single = true;
	

func _new_random_spawn_location():
	var _spawnable_area : ReferenceRect = $"../Item_Spawn_Area";
	var _new_position = _spawnable_area.position + Vector2(randf() * _spawnable_area.size.x, randf() * _spawnable_area.size.y);
	self.position = _new_position;
	

func _spawn_item() -> void:
	# Check depending on what type of category it is, no doubles, starts with _Double
	# Sweet Savoury - No drinks
	# Glass NotGlass
	# Food Drink
	# Short Long - No Doubles
	# Cheese NotCheese
	
	# Change Spawn Location
	_new_random_spawn_location();
	
	var _spawning_item;
	
	if (_can_spawn_triple):
		# Randomly pick from all 3 Pools
		pass;
	elif (_can_spawn_double):
		# Randomly pick from 2 Pools
		pass;
	elif (_can_spawn_single):
		# Randomly pick from 1 Pool
		_spawning_item = _Single_Items.pick_random().instantiate();
	print_debug("to spawn ", _spawning_item);
	
	add_child(_spawning_item);
	_spawning_item.rotation_degrees = randf_range(-360, 360);
	
	Game_Manager.increase_item_count();

func _on_item_spawn_timer_timeout() -> void:
	_spawn_item();

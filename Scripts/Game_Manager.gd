extends Node2D

const Category = preload("res://Scripts/Category_Enum.gd").Category;
@export var current_category : Category = Category.SWEET;

# Category Titles
const Sweet_PNG : Texture = preload("res://Assets/Sweet.png");
const Savoury_PNG : Texture = preload("res://Assets/Savoury.png");
const Glass_PNG : Texture = preload("res://Assets/Glass.png");
const Not_PNG : Texture = preload("res://Assets/Not.png");
const Food_PNG : Texture = preload("res://Assets/Food.png");
const Drink_PNG : Texture = preload("res://Assets/Drink.png");
const Short_PNG : Texture = preload("res://Assets/Short.png");
const Long_PNG : Texture = preload("res://Assets/Long.png");
const Cheese_PNG : Texture = preload("res://Assets/Cheese.png");

# Number Imports
const Zero_PNG : Texture = preload("res://Assets/Zero.png");
const One_PNG : Texture = preload("res://Assets/One.png");
const Two_PNG : Texture = preload("res://Assets/Two.png");
const Three_PNG : Texture = preload("res://Assets/Three.png");
const Four_PNG : Texture = preload("res://Assets/Four.png");
const Five_PNG : Texture = preload("res://Assets/Five.png");
const Six_PNG : Texture = preload("res://Assets/Six.png");
const Seven_PNG : Texture = preload("res://Assets/Seven.png");
const Eight_PNG : Texture = preload("res://Assets/Eight.png");
const Nine_PNG : Texture = preload("res://Assets/Nine.png");

const _Digits : Array = [
	Zero_PNG,
	One_PNG,
	Two_PNG,
	Three_PNG,
	Four_PNG,
	Five_PNG,
	Six_PNG,
	Seven_PNG,
	Eight_PNG,
	Nine_PNG
]

@onready var game_manager_reference = self;

@onready var game_started : bool = false;
@export var item_count : int = 1;
@export var max_item_count : int = 1;
@export var round_count : int = 0;
@export var player_score : int = 0.0;
var _correct_shake : bool = false;
var _incorrect_shake : bool = false;
var _time : int = 0;
var _incorrect_time_max : int = 30;
var _correct_time_max : int = 10;

func _set_random_categories():
	var _first_cat : Node;
	var _second_cat : Node;
	
	# Left or Right setting first
	if (randi_range(0, 1) == 0):
		# Left first
		_first_cat = get_node("Left_Category");
		_second_cat = get_node("Right_Category");
	else:
		# Right first
		_first_cat = get_node("Right_Category");
		_second_cat = get_node("Left_Category");
	
	if (round_count < 3):
		var _new_category_index : int = randi_range(1, 3);
		
		#can't pick glass notglass
		if (_new_category_index == 1):
			_first_cat.current_category = Category.SWEET;
			current_category = Category.SWEET;
			_second_cat.current_category = Category.SAVOURY;
		elif (_new_category_index == 2):
			_first_cat.current_category = Category.FOOD;
			current_category = Category.FOOD;
			_second_cat.current_category = Category.DRINK;
		elif (_new_category_index == 3):
			_first_cat.current_category = Category.CHEESE;
			current_category = Category.CHEESE;
			_second_cat.current_category = Category.NOT_CHEESE;
	
	
	elif (round_count < 10):
		var _new_category_index : int = randi_range(1, 4);
		
		# can't pick short long
		if (_new_category_index == 1):
			_first_cat.current_category = Category.SWEET;
			current_category = Category.SWEET;
			_second_cat.current_category = Category.SAVOURY;
		elif (_new_category_index == 2):
			_first_cat.current_category = Category.GLASS;
			current_category = Category.GLASS;
			_second_cat.current_category = Category.NOT_GLASS;
		elif (_new_category_index == 3):
			_first_cat.current_category = Category.FOOD;
			current_category = Category.FOOD;
			_second_cat.current_category = Category.DRINK;
		elif (_new_category_index == 4):
			_first_cat.current_category = Category.CHEESE;
			current_category = Category.CHEESE;
			_second_cat.current_category = Category.NOT_CHEESE;
	
	else:
		var _new_category_index : int = randi_range(1, 5);
		
		# pick random number 1-5, then set left or right category
		if (_new_category_index == 1):
			_first_cat.current_category = Category.SWEET;
			current_category = Category.SWEET;
			_second_cat.current_category = Category.SAVOURY;
		elif (_new_category_index == 2):
			_first_cat.current_category = Category.GLASS;
			current_category = Category.GLASS;
			_second_cat.current_category = Category.NOT_GLASS;
		elif (_new_category_index == 3):
			_first_cat.current_category = Category.FOOD;
			current_category = Category.FOOD;
			_second_cat.current_category = Category.DRINK;
		elif (_new_category_index == 4):
			_first_cat.current_category = Category.SHORT;
			current_category = Category.SHORT;
			_second_cat.current_category = Category.LONG;
		elif (_new_category_index == 5):
			_first_cat.current_category = Category.CHEESE;
			current_category = Category.CHEESE;
			_second_cat.current_category = Category.NOT_CHEESE;
	
	_update_category_text(_first_cat);
	_update_category_text(_second_cat);
	

func _ready():
	_initialise_level();

func _update_category_text(category_node):
	var _updating_category_text;
	
	if (category_node == get_node("Left_Category")):
		_updating_category_text = get_node("Left_Category_Text");
	elif (category_node == get_node("Right_Category")):
		_updating_category_text = get_node("Right_Category_Text");
	else:
		print_debug("BIG ERROR CATEGORY NOT LEFT OR RIGHT ONE");
	
	if (category_node.current_category == Category.SWEET):
		_updating_category_text.texture = Sweet_PNG;
	elif (category_node.current_category == Category.SAVOURY):
		_updating_category_text.texture = Savoury_PNG;
	elif (category_node.current_category == Category.GLASS):
		_updating_category_text.texture = Glass_PNG;
	elif (category_node.current_category == Category.NOT_GLASS || category_node.current_category == Category.NOT_CHEESE):
		_updating_category_text.texture = Not_PNG;
	elif (category_node.current_category == Category.FOOD):
		_updating_category_text.texture = Food_PNG;
	elif (category_node.current_category == Category.DRINK):
		_updating_category_text.texture = Drink_PNG;
	elif (category_node.current_category == Category.SHORT):
		_updating_category_text.texture = Short_PNG;
	elif (category_node.current_category == Category.LONG):
		_updating_category_text.texture = Long_PNG;
	elif (category_node.current_category == Category.CHEESE):
		_updating_category_text.texture = Cheese_PNG;
	

func get_game_started() -> bool:
	return self.game_started;
	

func _process(delta):
	
	# Enough Points to go to next Round
	if (round_count <= floor(player_score / 5)):
		progress_round();
	
	# Scaling Max count doesn't work very well, 4 is very tough anyways
	#max_item_count = 1 + floor(round_count * (player_score / 10));
	
	if (_incorrect_shake && _time < _incorrect_time_max):
		_time += 1;
		var _next_pos = Vector2(sin(_time) * 2, sin(_time) * 3);
		get_node("Left_Category_Text").offset = lerp(get_node("Left_Category_Text").offset, _next_pos, 0.2);
		get_node("Right_Category_Text").offset = lerp(get_node("Right_Category_Text").offset, _next_pos, 0.2);
	
	elif (_incorrect_shake && _time >= _incorrect_time_max):
		_time = 0;
		_incorrect_shake = false;
		get_node("Left_Category_Text").offset = Vector2.ZERO;
		get_node("Right_Category_Text").offset = Vector2.ZERO;
	
	if (_correct_shake && _time < _correct_time_max):
		_time += 1;
		var _next_pos = Vector2(sin(_time), sin(_time) * 2);
		get_node("Score_01").offset = lerp(get_node("Score_01").offset, _next_pos, 0.2);
		get_node("Score_02").offset = lerp(get_node("Score_02").offset, _next_pos, 0.2);
		get_node("Score_03").offset = lerp(get_node("Score_03").offset, _next_pos, 0.2);
	
	elif (_correct_shake && _time >= _correct_time_max):
		_time = 0;
		_correct_shake = false;
		get_node("Score_01").offset = Vector2.ZERO;
		get_node("Score_02").offset = Vector2.ZERO;
		get_node("Score_03").offset = Vector2.ZERO;
	

func _initialise_level():
	# Spawn the S T A R T E R  D O N U T
	var Starter_Donut = load("res://Entities/Entities/Single/pink_donut_entity.tscn");
	var _starter_donut = Starter_Donut.instantiate();
	
	_starter_donut.position.x = 432;
	_starter_donut.position.y = 180;
	
	add_child(_starter_donut);
	
	# Spawn the two Category Colliders
	var Category_Collider = load("res://Entities/Category_Collider.tscn");
	var _category_collider = Category_Collider.instantiate();
	
	_category_collider.position.x = 270;
	_category_collider.position.y = 756;
	_category_collider.name = "Left_Category";
	_category_collider.current_category = Category.SWEET;
	
	add_child(_category_collider);
	
	# Now the Right One
	_category_collider = Category_Collider.instantiate();
	
	_category_collider.position.x = 594;
	_category_collider.position.y = 756;
	_category_collider.name = "Right_Category";
	_category_collider.current_category = Category.SAVOURY;
	
	add_child(_category_collider);
	
	# Spawn the Item Spawner
	var Item_Spawner = load("res://Entities/Item_Spawner.tscn");
	var _item_spawner = Item_Spawner.instantiate();
	
	_item_spawner.position.x = 432;
	_item_spawner.position.y = -100;
	_item_spawner.name = "Item_Spawner";
	
	add_child(_item_spawner);
	
	get_node("Left_Category_Text").texture = Sweet_PNG;
	get_node("Right_Category_Text").texture = Savoury_PNG;
	
	get_node("Score_01").texture = Zero_PNG;
	get_node("Score_02").texture = Zero_PNG;
	get_node("Score_03").texture = Zero_PNG;
	

func progress_round():
	round_count += 1;
	
	if (round_count >= 15):
		max_item_count = 4;
	elif (round_count >= 10):
		max_item_count = 3;
	elif (round_count >= 2):
		max_item_count = 2;
	
	# Randomly pick new Pair of Categories
	# Set Colliders and UI Text to be new Categories
	_update_round_text();
	_set_random_categories();
	

func increase_item_count():
	item_count += 1;
	

func decrease_item_count():
	item_count -= 1;
	

func update_score_text():
	#print_debug(str(player_score * 10).pad_zeros(3));
	
	if (player_score > 999):
		get_node("Score_01").texture = Nine_PNG;
		get_node("Score_02").texture = Nine_PNG;
		get_node("Score_03").texture = Nine_PNG;
	
	else:
		var score_string : String = str(player_score).pad_zeros(3);
		get_node("Score_01").texture = _Digits[score_string[0].to_int()];
		get_node("Score_02").texture = _Digits[score_string[1].to_int()];
		get_node("Score_03").texture = _Digits[score_string[2].to_int()];
	

func _update_round_text():
	print_debug(str(round_count).pad_zeros(2));
	
	if (round_count > 99):
		get_node("Round_01").texture = Nine_PNG;
		get_node("Round_02").texture = Nine_PNG;
	
	else:
		var round_string : String = str(round_count).pad_zeros(2);
		get_node("Round_01").texture = _Digits[round_string[0].to_int()];
		get_node("Round_02").texture = _Digits[round_string[1].to_int()];
	

func loop_bg():
	$BG.loop = true;

func play_click():
	$Click.play();
	

func correct_sequence():
	$Correct.play();
	_correct_shake = true;
	

func incorrect_sequence():
	$Incorrect.play();
	# Shake category text
	_incorrect_shake = true;
	

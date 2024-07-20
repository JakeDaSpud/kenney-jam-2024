extends Node2D

const Category = preload("res://Scripts/Category_Enum.gd").Category;
@export var current_category : Category = Category.SWEET;

@onready var game_manager_reference = self;

@onready var game_started : bool = false;
@export var item_count : int = 0;
@export var max_item_count : int = 1;
@export var round_count : int = 0;
@export var player_score : float = 0.0;

func _ready():
	_initialise_level();

func get_game_started() -> bool:
	return self.game_started;

func _process(delta):
	max_item_count = 1 + floor(round_count * (player_score / 2));
	

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
	
	add_child(_category_collider);
	
	# Now the Right One
	_category_collider = Category_Collider.instantiate();
	
	_category_collider.position.x = 594;
	_category_collider.position.y = 756;
	_category_collider.name = "Right_Category";
	
	add_child(_category_collider);
	
	# Spawn the Item Spawner
	var Item_Spawner = load("res://Entities/Item_Spawner.tscn");
	var _item_spawner = Item_Spawner.instantiate();
	
	_item_spawner.position.x = 432;
	_item_spawner.position.y = -522;
	_item_spawner.name = "Item_Spawner";
	
	add_child(_item_spawner);

func progress_round():
	round_count += 1;
	# Randomly pick new Pair of Categories
	# Set Colliders and UI Text to be new Categories
	

func increase_item_count():
	item_count += 1;
	

func decrease_item_count():
	item_count -= 1;
	

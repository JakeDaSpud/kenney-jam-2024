extends Node

@onready var Game_Manager : Node2D = $"..";

const Category = preload("res://Scripts/Category_Enum.gd").Category;
@export var current_category : Category = Category.NONE;

const Item_Size = preload("res://Scripts/Item_Size_Enum.gd").Item_Size;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _correct():
	print_debug("Correct Item, Category: ", current_category);

func _incorrect():
	print_debug("Incorrect Item")

func _on_body_entered(body):
	if (current_category == Category.NONE):
		print_debug("current_category set to Category.NONE");
	
	elif (
		(current_category == Category.SWEET && body.is_sweet) ||
		(current_category == Category.SAVOURY && !body.is_sweet) ||
		(current_category == Category.GLASS && body.is_glass) ||
		(current_category == Category.NOT_GLASS && !body.is_glass) ||
		(current_category == Category.FOOD && body.is_food) ||
		(current_category == Category.DRINK && !body.is_food) ||
		(current_category == Category.SHORT && body.is_short) ||
		(current_category == Category.LONG && !body.is_short) ||
		(current_category == Category.CHEESE && body.is_cheese) ||
		(current_category == Category.NOT_CHEESE && !body.is_cheese)
	):
		_correct();
		if (body.item_size == Item_Size.SINGLE):
			Game_Manager.player_score += 0.3;
		elif (body.item_size == Item_Size.DOUBLE):
			Game_Manager.player_score += 0.4;
		elif (body.item_size == Item_Size.TRIPLE):
			Game_Manager.player_score += 0.5;
	
	
	else:
		_incorrect();
	
	body.queue_free();
	Game_Manager.decrease_item_count();
	

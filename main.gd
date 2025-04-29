extends Node2D

var deck = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_deck()
	deliver_cards()

func create_deck() -> void:
	var suits = ["hearts", "diamonds", "clubs", "spades"]
	var values = range(1, 14) # 1 a 13 (Ás a Rei)
	
	for suit in suits:
		for value in values:
			var card = preload("res://card.tscn").instantiate()
			card.setup(value, suit)
			deck.append(card)

func deliver_cards() -> void:
	deliver_in_tableaus();
	deliver_in_deck();
	
func deliver_in_tableaus() -> void:
	var tableaus = [
		$tableau1, $tableau2, $tableau3,
		$tableau4, $tableau5, $tableau6,
		$tableau7
	]

	var quantity = 1

	for tableau in tableaus:
		for index in range(0, quantity):
			var card = deck.pop_back()
			tableau.add_child(card)
			card.position.y = index * 10

			if index == quantity - 1:
				card.turn_up()
		
		quantity = quantity + 1

func deliver_in_deck() -> void:
	for card in deck:
		$deck.add_child(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

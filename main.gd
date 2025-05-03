extends Node2D

var deck = []
var card_selected = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_deck()
	start_game()

func create_deck() -> void:
	var suits = ["hearts", "diamonds", "clubs", "spades"]
	var values = range(1, 14) # 1 a 13 (Ás a Rei)
	
	for suit in suits:
		for value in values:
			var card = preload("res://card.tscn").instantiate()
			card.setup(value, suit)
			deck.append(card)

func start_game():
	deck.shuffle()
	deliver_cards()

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
		var target = tableau

		for index in range(0, quantity):
			var card = deck.pop_front()

			if index > 0:
				card.position.x = 25
			else:
				card.position.x = 0

			if index == quantity - 1:
				card.turn_up()
			else:
				card.turn_down()

			target.append_child(card)

			deck.append(card)
			target = card
		
		quantity = quantity + 1

func deliver_in_deck() -> void:
	var target = $deck
	
	for card in deck.slice(0, 24):
		
		card.position.x = 0
		card.turn_down()
		target.append_child(card)
		
		target = card

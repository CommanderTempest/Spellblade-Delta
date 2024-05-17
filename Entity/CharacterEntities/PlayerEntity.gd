extends CharacterEntity
class_name PlayerEntity

"""
Convert everything from the player script into this,
in a reasonable manner using the new setup
"""

@onready var player_controller: PlayerController = $PlayerController

# maybe send a signal of a player action whenever something in PlayerController fires?
# call a change in state machine on receive of this signal?

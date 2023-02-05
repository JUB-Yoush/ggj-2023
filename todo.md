-- TODO --
- add rocks
	- rocks sit on  roots and drop once passed over (player leaves area)
	- rocks drop and hit anything below them on that root (a line of enemies, perhaps?)
- add ants
	~~aggro ants start to move towards the players direction~~
	- if there is a ledge it will try to jump off it 
	- if it crosses a root it will start to climb on it 
	- if player is above them they will wait a bit and then jump at them (can also climb roots if touching)

- one way platforms easy to make iirc
- score system
- time system
- design level 
- design spawn locations

-- THINGS 2 FIX --
- why isn't is_on_floor returning true

-- DONE --
- ~~basic platformer controller~~
- ~~simple finite state machine:~~
~~- add roots (added the node and the collision, need to add functionality when in state)~~ 
- ~~roots should put the player in a climbing state when they touch it~~
~~- they can climb slowly up or down and jump off to cancel the state and go back to jumping~~
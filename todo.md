-- TODO --
- add rocks
- add ants
	~~aggro ants start to move towards the players direction~~
	- if there is a ledge it will try to jump off it 
	- if it crosses a root it will start to climb on it 
	- if player is above them they will wait a bit and then jump at them (can also climb roots if touching)

-- DONE --
- ~~basic platformer controller~~
- ~~simple finite state machine:~~
~~- add roots (added the node and the collision, need to add functionality when in state)~~ 
- ~~roots should put the player in a climbing state when they touch it~~
~~- they can climb slowly up or down and jump off to cancel the state and go back to jumping~~
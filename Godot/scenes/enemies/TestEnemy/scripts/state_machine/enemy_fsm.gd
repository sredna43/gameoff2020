# Player state machine, handles changing states and running states
# Brains behind the controller.gd

extends Node2D
class_name EnemyFSM

var states: Dictionary = {}
var active_state: EnemyState
var previous_state_tag: String = ""
var player: KinematicBody2D

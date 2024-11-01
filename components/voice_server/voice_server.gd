class_name VoiceServer
extends Node


signal start_speaking(id: String)

signal stop_speaking(id: String)

var speaking: Dictionary[String, bool] = {}

> WELCOME TO THE INSTRUCTION MANUAL <

#TABLE OF CONTENTS:
	>1 PRESERVING GOOD ARCHITECTURE
		# GAME ART AND HOW TO ARRANGE THEM
		
	>2 ACTORS SECTION
		# PLAYER BASE AND CREATING CUSTOM PLAYERS
		# THE FINITE STATE MACHINE
		
	>3 GLOBALS SECTION
		# EVENT BUS
		# GAME MANAGER
		# SETTINGS MANAGER
		# LOADING SCREEN
		# MUSIC MANAGER
		# SOUND BANK
		
	>4 CONTROLS
		# REBIND BUTTON
		# HOW TO ADD OR REMOVE SECONDARY, TERTIARY OR MORE CONTROLS
		
	>5 COMPONENTS SECTION


>PRESERVING GOOD ARCHITECTURE
# GAME ART AND HOW TO ARRANGE THEM
Game art can be very tedious to grab and drag especially when you're doing it repeatedly.
The file architecture provides a [game_assets] folder that you can use. 
However, you can place different game assets in the different folders for ease of access.
As long as YOU, the developer, arrange YOUR ASSETS in a consistent and clear manner,
you will have little trouble going down the line.

An example of placing your assets in different folders:
Suppose you are using [game_assets] as your world's assets folder. You have different actors in
the [actors] folder. You have sprites for each actor in your game. Instead of placing the assets in [game_assets]
you can place them inside its own actors folder since let's say a PLAYER ASSET will usually oonly stay in PLAYER.
Less digging in your files!

>ACTORS SECTION
# PLAYER BASE AND CREATING CUSTOM PLAYERS
Under [actors > player] there is a baseplayer scene and a baseplayer script
This serves as the basis of all current and future players. 
As the base, everything that all players will inherit should probably be placed here.

To create custom players using the base player, right click on baseplayer.tscn and "New Inerited Scene"
After, you should detach the script of the new player and attach / create your own.
[Your custom player should inherit Player by Inherits: Player]
[REMEMBER: IT NEEDS TO HAVE A REFERENCE TO THE (BASE) PLAYER CLASS 
EITHER BY BEING THE PLAYER CLASS OR EXTENDING FROM THE PLAYER CLASS OR YOUR FSM WILL NOT WORK (discussed later)]
You could also use baseplayer as your custom player and delete the other players!

# THE FINITE STATE MACHINE
The FSM is a very powerful tool to streamline your actor's development. 
To create one, you need a node from your Actor that acts as THE FSM HANDLER. Add such a node; usually you use the Node node.
[When attaching script... This "FSM HANDLER" should LOAD the Script: FSM.gd under systems > FSM > FSM.gd]
It is wise for your actor to have a label "DebugStateLabel" with AccessUniqueName enabled to show current state

Now that you have an FSM Handler, we now need states!
To create a state, add Node/s as a child of your FSM Handler. 
[When attaching script... This "StateNode" should INHERIT the Script: State.gd under systems > FSM > State.gd]
Create the script and save it somewhere safe [in the player to make it clean!]

[VERY IMPORTANT]
Each state node you have has an @export PLAYER and ENTITY
This can be seen in your State Node's inspector tab. Grab a reference to EITHER your PLAYER or the ENTITY.
(Made it this way so you can easily differentiate between PLAYERS and ENTITIES when creating them)
(Alternatively, you can delete PLAYER and just use ENTITY but every state node using PLAYER must also be replaced with ENTITY)
This is your key to start interacting with the actor.

[NOW THAT YOU HAVE STATE NODES...]
SET YOUR FSM HANDLER'S INITIAL STATE TO YOUR CHOSEN STATE. This is usually Idle

States have 3 functions
1. func enterState()
2. func updateState(_delta)
3. func exitState()

enterState() happens when you enter the state. This call only happens once.
updateState(_delta) happens while you are in the state. This is basically your "process / physics_process" of the state. 
	This is usually where most of your logic will be kept.
exitState() happens when... you exit the state. This call only happens once. This function is usually rarely used but powerful.

Each State Node has a signal transition
when you want to transition to another state, use [  transition.emit(self, "OTHER_STATE_NAME")  ]
OTHER_STATE_NAME should be a child of FSM HANDLER [ALL YOUR STATE NODES SHOULD BE CHILDREN OF YOUR FSM HANDLER]

example pseudocode:
func updateState(_delta : float):
	if player pressed run button:
		transition.emit(self, "Run")
	elif player pressed jump button:
		transition.emit(self, "Jump")

>GLOBALS SECTION
Currently, there are [6 GLOBALS] in this template. 
Event Bus, Game Manager, Loading Screen, Music Manager, Settings Manager, Sound Bank

# THE EVENT BUS
The event bus autoload allows different nodes to share information and data to other nodes 
that may or may not be outside of its own parent. 

For example...
A node in the PLAYER wants to communicate something to the PLAYER HUD.
Instead of connecting signals to each other or using references which may lead to too much dependency,
The Node can just emit an event bus signal and any other node connected to the event bus' signal can listen to it automatically.
[Node --> EventBus --> HUD]

To use this feature:
	DEFINE A SIGNAL in the EVENT BUS
	Connect your signals:
		THE EMITTER: Events.SIGNAL_NAME.emit(If you have paramaters in your signal, place them here)
		THE RECEIVER: Events.SIGNAL_NAME.connect(FUNCTION_NAME_INSIDE_CURRENT_SCRIPT)
	
	Now everytime your emitter emits, the receiver will receive!

# GAME MANAGER
The Game Manager is your best friend in handling helper functions, storing temporary values used by your game and serves
as the bridge between the player and the game.

Currently, it has helper functions for world camera, 
this allows your Player or Enemy or your World to shake the camera anytime for example.
It also has a helper function to save and load the player's position anytime.

Alternative uses for GAME MANAGER:
	Let's say your OPEN WORLD GAME has different biomes. You want to store those biomes so other nodes can react to it.
	You can store your BIOMES in an enum and then have a CURRENT_BIOME accessing values of that ENUM.
	Now, let's say you want to play music in certain biomes, now your MUSIC MANAGER can just crossfade to other tracks
	when your GameManager.CURRENT_BIOME != current_biome (the last biome you were in).

# SETTINGS MANAGER
The Settings Manager stores your settings. Most of the code here will usually be called through menus. 
For example, the main menu or the pause menu. 
You can add other variables for your other settings you wwould like to save and load.

#SCREEN TRANSITION
Screen Transition is a screen transition. You can configure your own screen transition pattern. Currently, it uses a shader setup.
You may call it via ScreenTransition.trans_in(trans_time : float) or ScreenTransition.trans_out(trans_time : float)

# LOADING SCREEN
Loading Screen loads your level in a different thread so that when you load a level your game doesn't look like it froze.
You can customize this loading screen! 
To use Loading Screen:
	You can do an export file to your var so that you can drag a scene to the inspector. 
	GODOT will convert it to a string automatically!
	
	@export_file("*.tscn") var next_level_path : String
	LoadingScreen.load_level(next_level_path)
	
	next_level_path can be replaced with a hardcoded String path [IT MUST BE A STRING]. 
	It's not recommended though because if you want to change the file path, you'd have to dig through all your code again!

[IT IS RECOMMENDED TO USE GameManager.load_next_level()] AS IT AUTOMATICALLY COMBINES
ScreenTransition.trans_in() - LoadingScreen.load_level(-) - ScreenTransition.trans_out()

# MUSIC MANAGER
The MUSIC MANAGER handles single tracks and Multi-layered tracks seamlessly. 
It lets you play defined tracks, set intensity and stop them at will! 

To use the MUSIC MANAGER there are a couple steps you need to do:
	1. Right Click on the file system, create new resource and type / find MusicTrack.
	2. Define the Music Track in the resource's inspector: 
		2.1 Give it a Track Name [very important]
		2.2 You will need to set the track array by defining a size and darg-dropping your music files into the array.
		2.3 You can set the music's BPM. This is useful for multi-layered tracks so they will always be in sync.
	3. In the MusicManager Scene, there is an export in the inspector. Set how many tracks you have, then drag-drop your resources.

Have everything set-up? Great!
Here's all the methods you need to know to actually communicate with your MusicManager
Call them using MusicManager.method_name()
1. change_music(track_name : String, crossfade time : float [optional])
2. set_intensity(intensity : float, fade time : float [optional])
3. stop_music(fade time : float [optional])

1. change_music() 
	Starts the track with the given track name. The track name must be a name in one of the resources. 
	When music is already playing, it fades out the old one and fades in the new one.

2. set_intensity()
	This is only useful if you have multi-layered tracks and you want it to be dynamic. 
	You will have to put a value between 0 and 1 (inclusive) for it to function.
	[If you have multi-layered tracks, it divides your layers and plays the layers based on how intense the intensity is]
	ex: If we have 3 layers, layer 1 fades in at 0.5, layer 2 at 1.0.
	The first index (index 0) will always be playing.

3. stop_music()
	Fades out the current playing music. 

# SOUND BANK
The SOUND BANK stores your SOUND EFFECTS. They can be called ANYTIME using the SOUND BANK!
To use the SOUND BANK:
First, Define your sound effects in the SOUND BANK'S sfx_dict
Here is an example:
	var sfx_dict : Dictionary = {
	"swing_sword": preload("res://audio/sfx/swing.ogg"),
	"jump": preload("res://audio/sfx/jump.ogg"),
}

Second, call it ANYWEHRE with its function
SoundBank.play_sfx(sfx_name : String, spawn_pos : Vector2)

It accepts a sfx_name from your sfx_dict as well as a Vector2 position so that it spawns an AudioStreamPlayer2D in that position.

> CONTROLS
Controls are set in a SettingsContainer module. [CURRENTLY, CONTROLS CAN ONLY BE SET IN THE MAIN MENU]
# REBIND BUTTON
Under [systems > Rebind Button Script Module]
You will find RebindButton.gd (as well as ExampleRebindButton)

The RebindButton script is very powerful as it allows you to rebind your controls! 
All you need to do is [ATTACH THE SCRIPT BY LOADING RebindButton.gd TO YOUR DESIRED BUTTON]
Now, this button has become a "Rebind button"

Here are all the things you need to know about your new Rebind Button!

The Rebind Button has 3 exports:
	 Action Name (action_name), 
	Bind Index (bind_index) and 
	Allowed Input Types (allowed keyboard, allowed mouse, allowed joypad)

Action Name
[Your Action Name export is where you will enter your action's name. Like jump, shoot or dash]
it [MUST] be exactly how you typed it under your [Project > Project Settings > Input Map]

Bind Index
This is only really important if you want multiple ways to do your action. (Secondary, Tertiary, ...  Controls)
[When you have the same Action Name for multiple buttons, increase its bind index]
For example: 
	Action Name: jump
	PrimaryJump button has Bind Index: 0
	SecondaryJump button has Bind Index: 1
	TertiaryJump button has Bind Index: 2
This allows you to jump in 3 different ways!

Allowed Input Types
[This has 3 toggles which allow you to control if the player can input either a keyboard key, mouse button or a joypad control]
Suppose you don't want jump to be assignable to the mouse buttons (who does that!?)
You can uncheck mouse button so that the player can't remap jump to any of the mouse buttons!

[When you don't want a button to be remappable (say you have a default control you REALLLYYY want to include)]
You can uncheck everything. This will automatically disable the button so that it can't be clicked to reassign.

# HOW TO ADD OR REMOVE SECONDARY, TERTIARY OR MORE CONTROLS
In your [SettingsContainer > SettingsTabs > ControlsSettings > VBoxContainer]
You will see a ScrollContainer
This ScrollContainer is set to have 3 columns. This is for the LABEL, Control1, Control2
If you need more input buttons for your input action, add more columns as well as buttons! Otherwise, subtract and remove!

When adding more buttons for more controls for AN action, don't forget to increase the bind_index of the button as well.
For example: 
	Action Name: jump
	PrimaryJump button has Bind Index: 0
	SecondaryJump button has Bind Index: 1
	TertiaryJump button has Bind Index: 2

# ADDING MORE CONTROLS
When adding more controls, you can add default inputs under [Project > Project Settings > Input Map] !
In fact, it is recommended to do such. 
When adding onto your control settings, follow the REBIND BUTTON instructions as you WILL need a rebind button to rebind.

> COMPONENTS SECTION
[TO BE DOCUMENTED...]

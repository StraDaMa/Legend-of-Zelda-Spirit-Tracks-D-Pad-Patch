Legend of Zelda Spirit Tracks D-pad Patch Update 2

1. Introduction

This patch adds D-pad controls for essential actions such as walking,
interacting with objects, and attacking. The new control bindings are
Control Bindings:
D-Pad	Move
Y+Dpad	Move slower
B	Wide slash
B+Dpad	Long slash
Y+B	Spin Attack
A	Interact
A+Dpad	Roll



2. Instructions for Patching

Apply Patch using the xdelta command line:

xdelta.exe -d -s (old_file) (delta_file) (decoded_new_file)

old_file should be a copy of Legend of Zelda Spirit Tracks US/EU depending on patch
delta_file is the patch (zelda_spirit_tracks_dpad.xdelta)
decoded_new_file is the filename after patching

3. Changes

Update 2:
-A button can now be used to blow into mic in addition to actually blowing into the mic
-Fixes pressing A not properly simulating blowing into the mic for blowing dust off maps

Update 1:
-Fixes D-pad movement not working in rooms with different
camera angles (such as Tower of Spirits)
-Whirlwind item activates from pressing A instead of blowing into mic
-Fixes rolling not working after interacting with an NPC
-D-pad Left no longer switches  between link and zelda, now Select + Left

4. Contact

I tried out the patch a bit in the beginning and end of the game
and it doesn't seem to break anything. But I haven't checked the
entire game/story so I don't know if it breaks anything throughout.
You can let me know about any errors or bugs at
griegamaster@gmail.com

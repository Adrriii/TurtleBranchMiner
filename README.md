## TurtleBranchMiner

Works best with **Chunky Advanced Mining Turtle** (With *PeripheralsPlusOne* mod). A regular turtle will immediately stop working when its chunk unloads, causing the script to stop.

For now, parameters tweaking is done in the file. Refer to the variable comments for more information.

## How to use

- Put the turtle on a chest, facing the first tunnel it will dig.
- Feed it fuel (required) and torches (optional)
- Set the parameters inside the file to your preferences
- Run the program

Note: If the turtle stops and is stuck on looking for fuel, just put some in it.

## Troubleshooting

**Turtle is stuck**
If it has fuel, and it's stuck, check for the blocks (or world items) around it. If the turtle cannot break it, then this isn't a good place for putting the turtle. If it can move through it but doesn't, you need to add this item to *nonBlocking* by adding a line similar to the above ones with the correct name in the format *mod:itemname*.

**Turtle has stopped working**
The program doesn't handle restarts (caused by chunk unloading or anything else) *for now*.
You need to either reinstall completely by breaking the turtle and putting it back on a starting position, or move it without breaking it and restart the program.
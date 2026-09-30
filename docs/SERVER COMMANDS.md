# In game console

F11 opens the admin console. Commands are typed as seen, no slashes.

`help` lists commands

## Game master

| Command | Functionality |
|---|---|
| `server status` | uptime, players online and the peak since the server came up |
| `reload shop` | reload shop tables without restarting |
| `game state <state>` | forcibly changes the game-state of the room |
| `inventory list` | prints your items with their ids |
| `inventory showitem <id>` | print info about a specific inventory item |
| `inventory set <...>` | edits one of your inventory items |
| `gm kick <nickname>` | kick player |
| `gm ban <nickname>` | ban player |
| `gm killroom` | close the room you're in |
| `admin online` | displays player count & usernames currently online |
| `admin where <nickname>` | displays the user's location & information: the channel, room, game-mode, current match state and the player's level |
| `admin notice <message>` | outputs a written admin/GM notice to all players |
| `admin pen <nickname> <amount>` | modify a player's PEN |
| `admin ap <nickname> <amount>` | modify a player's AP |
| `admin level <nickname> <level>` | sets a player's level |
| `admin endmatch <room id>` | sets the specified room to the result screen state (ends the match) |
| `admin seclevel <nickname> <0 user, 1 gm, 2 developer>` | sets specified user's account security level **Warning: Admin only command, DO NOT USE LIGHTLY** |

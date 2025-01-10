
### TODO

- [ ] Add custom art!
 - [x] Make cursor an X or O depending on current players turn.: 1.1.0
 - [x] Custom X symbol : 1.2.0
 - [x] Custom O symbol : 1.2.0
 - [x] Highlight X and O when a win occurs.
 - [x] Floating background
 - [ ] Create a colorful border around the whole screen.
  - [ ] If I want to make the pixel art in scale with the x's and o's I can make the border
        in 96x96 pixels for the whole screen.
        The status window is 24x96 and the game window is 72x96 
 - [ ] Custom boxes
 - [ ] Animate the X and O?

- [ ] Make so that the screen is resizable and everything scales correctly.

### [1.5.0] 2024-01-07

- Screen can now be resized and images will scale properlys.
- Added conf.lua.

### [1.4.2] 2024-01-07

- Added my own cloud sprite.

### [1.4.1] 2024-01-05

- Updated so that the circles are now clouds that I got from [Ian Peter's](https://opengameart.org/content/cloud-2)

### [1.4.0] 2024-01-05

- Added floating background circles!

### [1.3.1] 2024-01-05

- Made it so the drawPngAtBox function draws X's and O's dynamically depending on the size
  of the bounding box.

### [1.3.0] 2024-01-05

- Added highlights to X and O for the winner.

### [1.2.0] 2024-01-05

- Made is so that the custom O's and X' now appear in the tictactoe grid when clicked.

### [1.1.0] 2024-01-04

- Made a custom pink X and blue O for the mouse cursor depending on the user.
- Added sprites folder.

### [1.0.2] 2024-01-04

- Refactored for better or worse. Moved all globals into a global table separating the gameState and 
  game dimensions into separate tables.

### [1.0.1] 2024-01-04

- Separate game state and draw logic into separate files. 

### [1.0.0] 2024-01-03

- Fully featured tic-tac-toe game created!

- [x] Add code for ties
- [x] Add code for play again.
- [x] Add field for keeping text and score and number of games.
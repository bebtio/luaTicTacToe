require("gameState")
require("drawGame")

-- Load global variables
function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
  
    playerScore = {["1"] = 0, ["2"] = 0}

    winningSequence = {}
    gameState = {"","","","","","","","",""}

    currentPlayer = "1"

    playerSymbol = {}
    playerSymbol["1"] = "x"
    playerSymbol["2"] = "o"

    gameOver = false
    gameTied = false

    -- Create the game window height and width.
    local windowRatio = .80 -- The ratio of screen space the game window takes up version compared to the status bar.

    ghOffset = love.graphics.getHeight() * (1-windowRatio)
    gwOffset = 0

    gh = love.graphics.getHeight() * windowRatio
    gw = love.graphics.getWidth()

    -- Create the game status bar height and width.
    sh = love.graphics.getHeight() * (1-windowRatio) 
    sw = gw

    bbs = getBoundingBoxes(gh,gw, ghOffset, gwOffset)
end



function love.update(dt)
    handleUpdate()
end

function love.draw()
        tictactoe()
end

function tictactoe()
    drawStatusScreen(sh, sw, 0,0)
    drawGameScreen(gh,gw, ghOffset, gwOffset)

    if gameOver then
        drawGameOver()
    end
end
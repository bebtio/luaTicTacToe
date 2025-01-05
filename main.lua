require("gameState")
require("drawGame")
local gameState
local gameDimensions

function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
  
    love.graphics.setDefaultFilter("nearest","nearest")
    
    -- Create the game window height and width.
    local windowRatio = .80 -- The ratio of screen space the game window takes up version compared to the status bar.

    local ghOffset = love.graphics.getHeight() * (1-windowRatio)
    local gwOffset = 0

    -- Create the gameBoard dimensions.
    local gh = love.graphics.getHeight() * windowRatio
    local gw = love.graphics.getWidth()

    -- Create the game status bar height and width.
    local sh = love.graphics.getHeight() * (1-windowRatio)
    local sw = love.graphics.getWidth()

    -- Compute the bounding boxes for each grid element.
    local bbs = getBoundingBoxes(gh,gw, ghOffset, gwOffset)

    local oCursor = love.mouse.newCursor("sprites/blueO.png",16,16)
    local xCursor = love.mouse.newCursor("sprites/pinkX.png",16,16)

    local oImage  = love.graphics.newImage("sprites/blueO.png")
    local xImage  = love.graphics.newImage("sprites/pinkX.png")
    gameState =
    {
        -- Tracks the score of the current player.
        playerScore = {["1"] = 0, ["2"] = 0},

        -- Tracks which grid has an X or O character.
        boardState = {"","","","","","","","",""},

        -- Tracks which player is associated with which symbol.
        playerSymbol = {["1"] = "x",     ["2"] = "o"},
        playerCursor = {["1"] = xCursor, ["2"] = oCursor},
        playerImage  = {["x"] = xImage,  ["o"] = oImage},

        -- Tracks the winning sequence indices so we can highlight it in a different color.
        winningSequence = {},

        -- Tracks the current player.
        currentPlayer = "1",

        gameOver = false,
        gameTied = false,
    }

    gameDimensions = 
    {
        -- Bounding boxes that define the clickable grids.
        bbs = bbs,

        -- The board game height and width and offsets.
        gh = gh,
        gw = gw,
        ghOffset = ghOffset,
        gwOffset = gwOffset,

        -- That top status bar height and width.
        sh = sh,
        sw = sw
    }

end


function love.update(dt)
    handleUpdate(gameDimensions, gameState)
end

function love.draw()
        tictactoe()
end

function tictactoe()
    updateCursor(gameState)
    drawStatusScreen(gameDimensions, gameState)
    drawGameScreen(gameDimensions, gameState)

    if gameState.gameOver then
        drawGameOver(gameDimensions, gameState)
    end
end
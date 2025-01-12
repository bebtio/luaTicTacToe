require("gameState")
require("drawGame")
local Entity = require("entity")

local gameState
local gameDimensions

function love.load(arg)
    local r,g,b = love.math.colorFromBytes(132, 193, 238)
    love.graphics.setBackgroundColor(r,g,b,0)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
  
    love.graphics.setDefaultFilter("nearest","nearest")
    

    local oCursor = love.mouse.newCursor("sprites/BlueO.png",16,16)
    local xCursor = love.mouse.newCursor("sprites/PinkX.png",16,16)

    local oImage  = love.graphics.newImage("sprites/BlueO.png")
    local xImage  = love.graphics.newImage("sprites/PinkX.png")

    local oImageHighlighted  = love.graphics.newImage("sprites/BlueOHighlighted.png")
    local xImageHighlighted  = love.graphics.newImage("sprites/PinkXHighlighted.png")

    local border         = love.graphics.newImage("sprites/Border.png")

    local playerImages = {
        image  = {["x"] = xImage,  ["o"] = oImage},
        highlightedImage = {["x"] = xImageHighlighted, ["o"] = oImageHighlighted}
    }

    local cloudImage = love.graphics.newImage("sprites/cloud.png")
    local entities = createInitialClouds(50, cloudImage)

    gameState =
    {
        border = border,
        -- Tracks the score of the current player.
        playerScore = {["1"] = 0, ["2"] = 0},

        -- Tracks which grid has an X or O character.
        boardState = {"","","","","","","","",""},

        -- Tracks which player is associated with which symbol.
        playerSymbol = {["1"] = "x",     ["2"] = "o"},
        playerCursor = {["1"] = xCursor, ["2"] = oCursor},
        playerImages = playerImages,
        
        -- Tracks the winning sequence indices so we can highlight it in a different color.
        winningSequence = {},

        -- Tracks the current player.
        currentPlayer = "1",

        clouds = entities,
        gameOver = false,
        gameTied = false,
    }


    gameDimensions = 
    {
        -- The dimensions of the original game sprite canvas.
        trueHeight = 120,
        trueWidth  = 96, 

        -- The scale factor required to scale the artwork to the current window size.
        heightScale = 0,
        widthScale  = 0,

        -- This must be set.
        -- The ratio between the status area and the game area. i.e the game area takes up 85 percent of the screen.
        windowRatio = .8,

        -- If the current love.getDimensions is different than the lastHeight/Width, update
        -- these parameters.
        lastHeight = 0,
        lastWidth  = 0,

        -- Bounding boxes that define the clickable grids.
        bbs = {},

        -- The board game height and width and offsets.
        gh = 0,
        gw = 0,
        ghOffset = 0,
        gwOffset = 0,

        -- That top status bar height and width.
        sh = 0,
        sw = 0
    }

    updateGameDimensions(gameDimensions)
end


function love.update(dt)
    handleUpdate(dt, gameDimensions, gameState)
end

function love.draw()
        tictactoe()
end

function tictactoe()

    local gd = gameDimensions
    updateCursor(gameState)

    drawClouds(gameState)
    
    drawGameScreen(gameDimensions, gameState)
    drawBorder(gameDimensions, gameState)
    drawStatusScreen(gameDimensions, gameState)

    if gameState.gameOver then
        drawGameOver(gameDimensions, gameState)
    end
end


-- Load global variables
function love.load(arg)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
  
    winningSequence = {}
    gameState = {"","","","","","","","",""}

    currentPlayer = "1"

    playerSymbol = {}
    playerSymbol["1"] = "x"
    playerSymbol["2"] = "o"

    gameOver = false
    gameTied = false

    gh = love.graphics.getHeight()
    gw = love.graphics.getWidth()
    bbs = getBoundingBoxes(gh,gw)
end


local isClicked = false
local wasDownLastFrame = false

function love.update(dt)
    handleUpdate()
end

function love.draw()
    if not gameOver then
        tictactoe()
    else
        handleGameOver()
    end
end

function tictactoe()
    drawGameScreen(gh,gw)
end

getBoundingBoxes = function(h,w)

    local h = h or love.graphics.getHeight()
    local w = w or love.graphics.getWidth()

    local bb1 = {
                    x1 = 0  , y1 = 0 ,
                    x2 = w/3, y2 = h/3
                }

    local bb2 = {
                    x1 = w/3  , y1 = 0 ,
                    x2 = 2*w/3, y2 = h/3
                }

    local bb3 = {
                    x1 = 2*w/3, y1 = 0,
                    x2 = w    , y2 = h/3
            }

    local bb4 = {
                    x1 = 0  , y1 = h/3,
                    x2 = w/3, y2 = 2*h/3
                }

    local bb5 = {
                    x1 = w/3  , y1 = h/3,
                    x2 = 2*w/3, y2 = 2*h/3
                }

    local bb6 = {
                    x1 = 2*w/3, y1 = h/3,
                    x2 = w    , y2 = 2*h/3
                }

    local bb7 = {
                    x1 = 0  , y1 = 2*h/3,
                    x2 = w/3, y2 = h
                }

    local bb8 = {
                    x1 = w/3  , y1 = 2*h/3,
                    x2 = 2*w/3, y2 = h
                }

    local bb9 = {
                    x1 = 2*w/3, y1 = 2*h/3,
                    x2 = w    , y2 = h
                }

    local boundingBoxes = {bb1,bb2,bb3,bb4,bb5,bb6,bb7,bb8,bb9}

    return boundingBoxes
end

function drawCircle( x, y, color )

    -- Set the color to color or default to white.
    c = color or {r=1,g=1,b=1}
    love.graphics.setColor(c.r, c.g, c.b)

    love.graphics.circle("line",x,y, 100 )

    -- Reset the the color.
    love.graphics.setColor(1,1,1)
end

function drawX( x, y, color )

    -- Set the color to color or white.
    local c = color or {r=1,g=1,b=1}
    love.graphics.setColor(c.r, c.g, c.b)

    local x1 = x - 100
    local y1 = y - 100
    local x2 = x + 100
    local y2 = y + 100

    love.graphics.line(x1,y1,x2,y2)
    love.graphics.line(x2,y1,x1,y2)

    -- Reset the color.
    love.graphics.setColor(1,1,1)
end

function drawAt( x, y, O_Or_X, color )

    local c = color or {r=1,g=1,b=1}
    if O_Or_X == "o" then
        drawCircle(x, y, c)
    elseif O_Or_X == "x" then
        drawX(x, y, c)
    end

end

function drawAtBox( boundingBox, O_Or_X, color )

    local c = color or {r=1,g=1,b=1}
    local x = boundingBox.x1 + ( boundingBox.x2 - boundingBox.x1 ) / 2
    local y = boundingBox.y1 + ( boundingBox.y2 - boundingBox.y1 ) / 2

    drawAt(x,y,O_Or_X, c)

end

-- Update the state of the tictactoe board.
function updateBoardState( boundingBoxes, gameState, currentPlayer )

    -- Update the the state based on which box the user clicked.
    local mx, my = love.mouse.getPosition()

        for i = 1,9 do
            local bb = boundingBoxes[i]

            -- If the player selection is not picked by any player yet and it is within a bounding
            -- box update the state.
            if mx > bb.x1 and mx < bb.x2 and
               my > bb.y1 and my < bb.y2 and
               gameState[i] == "" then

                if currentPlayer == "1" then
                    gameState[i] = "x" 
                else 
                    gameState[i] = "o"
                end

                -- Update the current player.
                if currentPlayer == "1" then 
                    currentPlayer = "2"
                elseif currentPlayer == "2" then
                    currentPlayer = "1"
                end

            end
        end

    
    return currentPlayer
end

checkIfWon = function( gameState, playerSymbol )

  local winningSequence = {}
  local won = false
  
    -- Check horizontal 3 in a rows.
    if gameState[1] == playerSymbol and
       gameState[2] == playerSymbol and
       gameState[3] == playerSymbol then
        winningSequence[#winningSequence+1] = 1
        winningSequence[#winningSequence+1] = 2
        winningSequence[#winningSequence+1] = 3
        won = true
    end
    
    if gameState[4] == playerSymbol and
       gameState[5] == playerSymbol and
       gameState[6] == playerSymbol then
        winningSequence[#winningSequence+1] = 4
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 6
        won = true    
    end
    if gameState[7] == playerSymbol and
       gameState[8] == playerSymbol and
       gameState[9] == playerSymbol then
        winningSequence[#winningSequence+1] = 7
        winningSequence[#winningSequence+1] = 8
        winningSequence[#winningSequence+1] = 9
        won = true
    end

    -- Check vertical three in a rows.
    if gameState[1] == playerSymbol and
       gameState[4] == playerSymbol and
       gameState[7] == playerSymbol then
        winningSequence[#winningSequence+1] = 1
        winningSequence[#winningSequence+1] = 4
        winningSequence[#winningSequence+1] = 7
        won = true
    end
    if gameState[2] == playerSymbol and
       gameState[5] == playerSymbol and
       gameState[8] == playerSymbol then
        winningSequence[#winningSequence+1] = 2
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 8
        won = true     
    end
    if gameState[3] == playerSymbol and
       gameState[6] == playerSymbol and
       gameState[9] == playerSymbol then
        winningSequence[#winningSequence+1] = 3
        winningSequence[#winningSequence+1] = 6
        winningSequence[#winningSequence+1] = 9
        won = true
    end

    -- Check diagonal three and a rows.
    if gameState[1] == playerSymbol and
       gameState[5] == playerSymbol and
       gameState[9] == playerSymbol then
        winningSequence[#winningSequence+1] = 1
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 9
        won = true     
    end
    
    if gameState[3] == playerSymbol and
       gameState[5] == playerSymbol and
       gameState[7] == playerSymbol then
        winningSequence[#winningSequence+1] = 3
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 7
        won = true
    end

    return won, winningSequence

end

-- Update the gameState
function handleUpdate()
    if not gameOver then
        local isDownNow = love.mouse.isDown(1)

        -- A "new" click is one that wasn't down last frame but is down now
        if (isDownNow and not wasDownLastFrame) then
            isClicked = true
        end

        wasDownLastFrame = isDownNow


        if isClicked then
            -- Update the game state and save which player is next.
            local nextPlayer = ""
            nextPlayer = updateBoardState(bbs,gameState,currentPlayer)
            isClicked = false

            -- Check that the the current player has not gotten three in a row as of the current move.
            gameOver, winningSequence = checkIfWon( gameState, playerSymbol[currentPlayer] )
    
            local boxesFilled = allBoxesFilled(gameState)                
            if boxesFilled then
                gameOver = true
                gameTied = true
            end

            if not gameOver then
                currentPlayer = nextPlayer
            end
        end
    end

    if gameOver then
        if love.keyboard.isDown("y") then
             resetGame()
        end 

        if love.keyboard.isDown("n") then
            love.event.quit()
        end
    end
end

function handleGameOver()

    drawGameScreen(gh,gw)

    if gameTied then
        love.graphics.print("TIE GAME",  gw/2, gh/2)
        love.graphics.print("Play Again?" , gw/2, gh/2 +10)
        love.graphics.print("Y/N" , gw/2, gh/2 +20)
    else    
        love.graphics.print("GAME OVER",  gw/2, gh/2)
        love.graphics.print("Player" .. " " .. currentPlayer .. " wins!", gw/2, gh/2 +10)
        love.graphics.print("Play Again?" , gw/2, gh/2 +20)
        love.graphics.print("Y/N" , gw/2, gh/2 +30)
    end

    color = {r=0,g=1,b=0}
    for index, value in ipairs(winningSequence) do
        drawAtBox(bbs[value], gameState[value], color)
    end
end


-- Checks the gameState
function allBoxesFilled( gameState )
    for _, value in ipairs(gameState) do
        if value == "" then
            return false
        end
    end

    return true
end

function resetGame()

    winningSequence = {}
    gameState = {"","","","","","","","",""}

    currentPlayer = "1"

    playerSymbol = {}
    playerSymbol["1"] = "x"
    playerSymbol["2"] = "o"

    gameOver = false
    gameTied = false

end

function drawGameScreen( h, w )
    local h = h or love.graphics.getHeight()
    local w = w or love.graphics.getWidth()

    -- Draw currentPlayer turn.
    love.graphics.print("Current player: " .. currentPlayer, 0,0)

    -- The two vertical lines.
    love.graphics.line(w/3  , 0, w/3   ,h)
    love.graphics.line(2*w/3, 0, 2*w/3, h)

    -- The two horizontal lines.
    love.graphics.line(0, h/3,   w, h/3)
    love.graphics.line(0, 2*h/3, w ,2*h/3)

    -- Iterate over the game state and draw a circle or X depending on the state.
    for i = 1,9 do
        drawAtBox(bbs[i], gameState[i])
    end
end
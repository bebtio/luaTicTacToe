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


local isClicked = false
local wasDownLastFrame = false

function love.update(dt)
    handleUpdate()
end

function love.draw()
        tictactoe()
end

function tictactoe()
    drawStatusScreen( sh, sw, 0,0)
    drawGameScreen(gh,gw, ghOffset, gwOffset)

    if gameOver then
        drawGameOver()
    end
end

getBoundingBoxes = function(h,w, hOffset, wOffset)

    local h = h or love.graphics.getHeight()
    local w = w or love.graphics.getWidth()
    local hOffset = hOffset or 0
    local wOffset = wOffset or 0

    local bb1 = {
                    x1 = 0   + wOffset, y1 = 0   + hOffset,
                    x2 = w/3 + wOffset, y2 = h/3 + hOffset
                }

    local bb2 = {
                    x1 = w/3   + wOffset, y1 = 0   + hOffset,
                    x2 = 2*w/3 + wOffset, y2 = h/3 + hOffset
                }

    local bb3 = {
                    x1 = 2*w/3 + wOffset, y1 = 0   + hOffset,
                    x2 = w     + wOffset, y2 = h/3 + hOffset
            }

    local bb4 = {
                    x1 = 0   + wOffset, y1 = h/3   + hOffset,
                    x2 = w/3 + wOffset, y2 = 2*h/3 + hOffset
                }

    local bb5 = {
                    x1 = w/3   + wOffset, y1 = h/3   + hOffset,
                    x2 = 2*w/3 + wOffset, y2 = 2*h/3 + hOffset
                }

    local bb6 = {
                    x1 = 2*w/3 + wOffset, y1 = h/3   + hOffset,
                    x2 = w     + wOffset, y2 = 2*h/3 + hOffset
                }

    local bb7 = {
                    x1 = 0   + wOffset, y1 = 2*h/3 + hOffset,
                    x2 = w/3 + wOffset, y2 = h     + hOffset
                }

    local bb8 = {
                    x1 = w/3   + wOffset, y1 = 2*h/3 + hOffset,
                    x2 = 2*w/3 + wOffset, y2 = h     + hOffset  
                }

    local bb9 = {
                    x1 = 2*w/3 + wOffset, y1 = 2*h/3 + hOffset,
                    x2 = w     + wOffset, y2 = h     + hOffset 
                }

    local boundingBoxes = {bb1,bb2,bb3,bb4,bb5,bb6,bb7,bb8,bb9}

    return boundingBoxes
end

-- Draw an X or an O at the clicked bounding box.
function drawAtBox( boundingBox, O_Or_X, color )

    local c = color or {r=1,g=1,b=1}
    local x = boundingBox.x1 + ( boundingBox.x2 - boundingBox.x1 ) / 2
    local y = boundingBox.y1 + ( boundingBox.y2 - boundingBox.y1 ) / 2

    -- We want the side length/radius to be the smallest dimension
    -- so it fits nicely in the box.
    local sideLengthX = (boundingBox.x2 - boundingBox.x1) / 2 
    local sideLengthY = (boundingBox.y2 - boundingBox.y1) / 2 

    local sideLength = sideLengthX

    if sideLengthX > sideLengthY then
        sideLength = sideLengthY
    end

    
    drawAt(x,y,O_Or_X, c, sideLength)

end

-- Draw an X or O or size sizeLength at coordinates (x,y).
function drawAt( x, y, O_Or_X, color, sideLength )

    local c = color or {r=1,g=1,b=1}
    if O_Or_X == "o" then
        drawCircle(x, y, c, sideLength)
    elseif O_Or_X == "x" then
        drawX(x, y, c, sideLength)
    end

end

function drawCircle( x, y, color, radius )

    -- Set the color to color or default to white.
    c = color or {r=1,g=1,b=1}
    love.graphics.setColor(c.r, c.g, c.b)

    love.graphics.circle("line",x,y, radius )

    -- Reset the the color.
    love.graphics.setColor(1,1,1)
end

function drawX( x, y, color, sideLength )

    -- Set the color to color or white.
    local c = color or {r=1,g=1,b=1}
    love.graphics.setColor(c.r, c.g, c.b)

    local x1 = x - sideLength
    local y1 = y - sideLength
    local x2 = x + sideLength
    local y2 = y + sideLength

    love.graphics.line(x1,y1,x2,y2)
    love.graphics.line(x2,y1,x1,y2)

    -- Reset the color.
    love.graphics.setColor(1,1,1)
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

            if gameOver and not gameTied then
                playerScore[currentPlayer] = playerScore[currentPlayer] + 1
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

function drawGameOver()
    if gameTied then
        love.graphics.print("TIE GAME"                                  , gw/2, sh - 35)
        love.graphics.print("Play Again?"                               , gw/2, sh - 25)
        love.graphics.print("Y/N"                                       , gw/2, sh - 15)
    else    
        love.graphics.print("GAME OVER"                                 , gw/2, sh - 45)
        love.graphics.print("Player" .. " " .. currentPlayer .. " wins!", gw/2, sh - 35)
        love.graphics.print("Play Again?"                               , gw/2, sh - 25)
        love.graphics.print("y/n"                                       , gw/2, sh - 15)
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

    if currentPlayer == "1" then
        currentPlayer = "2"
    else
        currentPlayer = "1"
    end

    playerSymbol = {}
    playerSymbol["1"] = "x"
    playerSymbol["2"] = "o"

    gameOver = false
    gameTied = false

end

function drawStatusScreen( h, w, ghOffset, gwOffset )
    -- Draw currentPlayer turn.
    love.graphics.print("Current player: " .. currentPlayer .. " (" .. playerSymbol[currentPlayer] .. ")", 0,0)

    love.graphics.print("Player 1 Score: " .. playerScore["1"], 0, 85 )
    love.graphics.print("Player 2 Score: " .. playerScore["2"], 0, 100 )
    love.graphics.line(0,h,w,h)

end

function drawGameScreen( h, w, ghOffset, gwOffset )

    local h = h or love.graphics.getHeight()
    local w = w or love.graphics.getWidth()
    local hOffset = ghOffset or 0
    local wOffset = gwOffset or 0 


    -- The two vertical lines.
    love.graphics.line(w/3   + wOffset, 0     + hOffset, w/3  , h     + hOffset)
    love.graphics.line(2*w/3 + wOffset, 0     + hOffset, 2*w/3, h     + hOffset)

    -- The two horizontal lines.
    love.graphics.line(0     + wOffset, h/3   + hOffset, w,     h/3   + hOffset)
    love.graphics.line(0     + wOffset, 2*h/3 + hOffset, w,     2*h/3 + hOffset)

    -- Iterate over the game state and draw a circle or X depending on the state.
    for i = 1,9 do
        drawAtBox(bbs[i], gameState[i])
    end
end
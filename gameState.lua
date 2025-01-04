
local isClicked = false
local wasDownLastFrame = false

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

function checkIfWon( gameState, playerSymbol )

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

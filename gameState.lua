local isClicked = false
local wasDownLastFrame = false

local lastTime = 0
local time = 0
-- Update the boardState
function handleUpdate(dt, gameDimensions, gameState)

    time = time + dt

    updateGameDimensions(gameDimensions)
    updateClouds(dt,gameState) 
    if not gameState.gameOver then
        local isDownNow = love.mouse.isDown(1)

        -- A "new" click is one that wasn't down last frame but is down now
        if (isDownNow and not wasDownLastFrame) then
            isClicked = true
        end

        wasDownLastFrame = isDownNow


        if isClicked then
            -- Update the game state and save which player is next.
            local nextPlayer = ""
            nextPlayer = updateBoardState(gameDimensions.bbs,gameState.boardState,gameState.currentPlayer)
            isClicked = false

            -- Check that the the current player has not gotten three in a row as of the current move.
            gameState.gameOver, gameState.winningSequence = checkIfWon( gameState.boardState, gameState.playerSymbol[gameState.currentPlayer] )
    
            local boxesFilled = allBoxesFilled(gameState.boardState)                

            if boxesFilled then
                gameState.gameOver = true
                gameState.gameTied = true
            end

            if gameState.gameOver and not gameState.gameTied then
                gameState.playerScore[gameState.currentPlayer] = gameState.playerScore[gameState.currentPlayer] + 1
            end
            if not gameState.gameOver then
                gameState.currentPlayer = nextPlayer
            end

        end
    end

    if gameState.gameOver then
        if love.keyboard.isDown("y") then
            resetGame(gameState)
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
function updateBoardState( boundingBoxes, boardState, currentPlayer )

    -- Update the the state based on which box the user clicked.
    local mx, my = love.mouse.getPosition()

        for i = 1,9 do
            local bb = boundingBoxes[i]

            -- If the player selection is not picked by any player yet and it is within a bounding
            -- box update the state.
            if mx > bb.x1 and mx < bb.x2 and
               my > bb.y1 and my < bb.y2 and
               boardState[i] == "" then

                if currentPlayer == "1" then
                    boardState[i] = "x" 
                else 
                    boardState[i] = "o"
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

function checkIfWon( boardState, playerSymbol )

  local winningSequence = {}
  local won = false
  
    -- Check horizontal 3 in a rows.
    if boardState[1] == playerSymbol and
       boardState[2] == playerSymbol and
       boardState[3] == playerSymbol then
        winningSequence[#winningSequence+1] = 1
        winningSequence[#winningSequence+1] = 2
        winningSequence[#winningSequence+1] = 3
        won = true
    end
    
    if boardState[4] == playerSymbol and
       boardState[5] == playerSymbol and
       boardState[6] == playerSymbol then
        winningSequence[#winningSequence+1] = 4
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 6
        won = true    
    end
    if boardState[7] == playerSymbol and
       boardState[8] == playerSymbol and
       boardState[9] == playerSymbol then
        winningSequence[#winningSequence+1] = 7
        winningSequence[#winningSequence+1] = 8
        winningSequence[#winningSequence+1] = 9
        won = true
    end

    -- Check vertical three in a rows.
    if boardState[1] == playerSymbol and
       boardState[4] == playerSymbol and
       boardState[7] == playerSymbol then
        winningSequence[#winningSequence+1] = 1
        winningSequence[#winningSequence+1] = 4
        winningSequence[#winningSequence+1] = 7
        won = true
    end
    if boardState[2] == playerSymbol and
       boardState[5] == playerSymbol and
       boardState[8] == playerSymbol then
        winningSequence[#winningSequence+1] = 2
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 8
        won = true     
    end
    if boardState[3] == playerSymbol and
       boardState[6] == playerSymbol and
       boardState[9] == playerSymbol then
        winningSequence[#winningSequence+1] = 3
        winningSequence[#winningSequence+1] = 6
        winningSequence[#winningSequence+1] = 9
        won = true
    end

    -- Check diagonal three and a rows.
    if boardState[1] == playerSymbol and
       boardState[5] == playerSymbol and
       boardState[9] == playerSymbol then
        winningSequence[#winningSequence+1] = 1
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 9
        won = true     
    end
    
    if boardState[3] == playerSymbol and
       boardState[5] == playerSymbol and
       boardState[7] == playerSymbol then
        winningSequence[#winningSequence+1] = 3
        winningSequence[#winningSequence+1] = 5
        winningSequence[#winningSequence+1] = 7
        won = true
    end

    return won, winningSequence

end


-- Checks the boardState
function allBoxesFilled( boardState )
    for _, value in ipairs(boardState) do
        if value == "" then
            return false
        end
    end

    return true
end

function resetGame(gameState)

    gameState.winningSequence = {}
    gameState.boardState = {"","","","","","","","",""}

    if gameState.currentPlayer == "1" then
        gameState.currentPlayer = "2"
    else
        gameState.currentPlayer = "1"
    end

    gameState.playerSymbol = {}
    gameState.playerSymbol["1"] = "x"
    gameState.playerSymbol["2"] = "o"

    gameState.gameOver = false
    gameState.gameTied = false
end

function updateClouds(dt, gameState)

    local rand = love.math.newRandomGenerator(love.timer.getTime() * 100 )
 
    local xPos = 0
    for i = 1, #gameState.clouds do
        local cloud = gameState.clouds[i]

        local width = 32 
        local offset = width

        -- The offset of the cloud image is wierd so I need
        -- special logic to make it work.
        if cloud.image ~= nil then 
            width = cloud.image:getWidth()
            offset = width*2
        end

        cloud:update(dt)
        xPos = cloud.pos.x

        -- Once the clouds go out of the screen we want to 
        -- reset their position to some random y, but start off screen in x.
        -- Also randomize their velociry in the x direction.
        if xPos > love.graphics.getWidth() + offset then
            cloud.pos.x = - offset 
            cloud.pos.y = rand:random(0, love.graphics.getHeight())
            cloud.vel.x = rand:random(20, 50)
        end
    end
end

function updateGameDimensions(gameDimensions)

    if gameDimensions.lastHeight ~= love.graphics.getHeight() or 
       gameDimensions.lastWidth  ~= love.graphics.getWidth()  then


        -- lua treats all tables as references so this is actually an alias to 
        -- to gameDimensions.
        local gd = gameDimensions
        
        -- Border width in pixels.
        local borderWidth = 12

        -- Create the game window height and width.
        local windowRatio = gd.windowRatio -- The ratio of screen space the game window takes up version compared to the status bar.

        gd.heightScale = love.graphics.getHeight() / gd.trueHeight
        gd.widthScale  = love.graphics.getWidth()  / gd.trueWidth

        -- Create the game status bar height and width.
        gd.sh          = (gd.trueHeight * gd.heightScale) * (1-windowRatio) 
        gd.sw          = (gd.trueWidth  * gd.widthScale )

        
        -- Create the gameBoard dimensions.
        gd.ghOffset    = gd.sh
        gd.gwOffset    = 0

        gd.gh          = (gd.trueHeight * gd.heightScale) * windowRatio
        gd.gw          = (gd.trueWidth  * gd.widthScale )
        
        -- Now add the game border to create the status bar text space and
        -- the bounding box area.

        gd.tsHOffset = ( borderWidth / 2 ) * gd.heightScale
        gd.tsWOffset = ( borderWidth / 2 ) * gd.widthScale

        gd.tsH       = gd.sh - ( borderWidth * gd.heightScale )
        gd.tsW       = gd.sw - ( borderWidth * gd.widthScale  )
 
        gd.bbHOffset = gd.sh + ( borderWidth / 2 ) * gd.heightScale
        gd.bbWOffset =         ( borderWidth / 2 ) * gd.widthScale

        gd.bbH       = gd.gh - ( borderWidth * gd.heightScale )
        gd.bbW       = gd.gw - ( borderWidth * gd.widthScale  )

        -- Compute the bounding boxes for each grid element.
        gd.bbs         = getBoundingBoxes(gd.bbH,gd.bbW, gd.bbHOffset, gd.bbWOffset)

    end
end
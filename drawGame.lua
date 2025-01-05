
function drawPngAtBox( O_Or_X, playerImages, boundingBox )

    -- Compute the width and height of the bounding box.
    local xSize = ( boundingBox.x2 - boundingBox.x1 ) 
    local ySize = ( boundingBox.y2 - boundingBox.y1 ) 

    -- Compute the midpoint of the bounding box.
    local xMid  = xSize / 2
    local yMid  = ySize / 2

    -- Compute the midpoint position of the bounding box on the screen.
    local x = boundingBox.x1 + xMid
    local y = boundingBox.y1 + yMid


    -- Compute the side length of the X or O.
    local sideLength = xSize

    -- We want to be the smallest dimension of the boundingBox so it
    -- fits nicely within it.
    if ySize < sideLength then
        sideLength = ySize
    end

    if( O_Or_X ~= "" ) then

        -- Scale the original image size so it fits fills the boundingBox.
        local image = playerImages[O_Or_X]

        -- Get dimensions of the image.
        local w = image:getWidth() 
        local h = image:getHeight()

        -- Generate the width and height offset of the image so that it is in the center of the 
        -- bounding box.
        local xOffset = w / 2
        local yOffset = h / 2

        -- Compute the scale factor required to fit the image in the bounding box.
        -- Shrink the scale factor a little so the shapes are not touching the border of
        -- the bounding box.
        local twiddleFactor = 0.90
        local wScale = (sideLength / w) * twiddleFactor
        local hScale = (sideLength / h) * twiddleFactor

        love.graphics.draw(playerImages[O_Or_X],x,y, 0, wScale, hScale, xOffset, yOffset) 
    end
end

function drawGameOver(gameDimensions, gameState)

    local bbs = gameDimensions.bbs

    local sh  = gameDimensions.sh
    local gw  = gameDimensions.gw
    if gameState.gameTied then
        love.graphics.print("TIE GAME"                                  , gw/2, sh - 35)
        love.graphics.print("Play Again?"                               , gw/2, sh - 25)
        love.graphics.print("Y/N"                                       , gw/2, sh - 15)
    else    
        love.graphics.print("GAME OVER"                                 , gw/2, sh - 45)
        love.graphics.print("Player" .. " " .. gameState.currentPlayer .. " wins!", gw/2, sh - 35)
        love.graphics.print("Play Again?"                               , gw/2, sh - 25)
        love.graphics.print("y/n"                                       , gw/2, sh - 15)
    end

    color = {r=0,g=1,b=0}
    for index, value in ipairs(gameState.winningSequence) do
        --drawAtBox(bbs[value], gameState.boardState[value], color)
        drawPngAtBox(gameState.boardState[value], gameState.playerImages.highlightedImage, bbs[value])
    end
end

function drawStatusScreen( gameDimensions, gameState )

    local h = gameDimensions.sh
    local w = gameDimensions.sw

    -- Draw currentPlayer turn.
    love.graphics.print("Current player: " .. gameState.currentPlayer .. " (" .. gameState.playerSymbol[gameState.currentPlayer] .. ")", 0,0)

    love.graphics.print("Player 1 Score: " .. gameState.playerScore["1"], 0, 85 )
    love.graphics.print("Player 2 Score: " .. gameState.playerScore["2"], 0, 100 )
    love.graphics.line(0,h,w,h)

end

function drawGameScreen( gameDimensions, gameState )

    local h = gameDimensions.gh or love.graphics.getHeight()
    local w = gameDimensions.gw or love.graphics.getWidth()
    local hOffset = gameDimensions.ghOffset or 0
    local wOffset = gameDimensions.gwOffset or 0 


    -- The two vertical lines.
    love.graphics.line(w/3   + wOffset, 0     + hOffset, w/3  , h     + hOffset)
    love.graphics.line(2*w/3 + wOffset, 0     + hOffset, 2*w/3, h     + hOffset)

    -- The two horizontal lines.
    love.graphics.line(0     + wOffset, h/3   + hOffset, w,     h/3   + hOffset)
    love.graphics.line(0     + wOffset, 2*h/3 + hOffset, w,     2*h/3 + hOffset)

    -- Iterate over the game state and draw a circle or X depending on the state.
    for i = 1,9 do
        --drawAtBox(gameDimensions.bbs[i], gameState.boardState[i])
        drawPngAtBox(gameState.boardState[i], gameState.playerImages.image, gameDimensions.bbs[i])
    end
end

function updateCursor(gameState)
        love.mouse.setCursor(gameState.playerCursor[gameState.currentPlayer])
end


-----------------------------------------------------------------------------------------
-- No longer needed!
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

-- No longer needed!
-----------------------------------------------------------------------------------------
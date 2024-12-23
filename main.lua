-- Load global variables
function love.load()
    test = love.graphics.newImage("front.jpeg")

    gameState = {"","","","","","","","",""}

    currentPlayer = "1"

    bbs = getBoundingBoxes()
end


local isClicked = false
local wasDownLastFrame = false

function love.update(dt)
    local isDownNow = love.mouse.isDown(1)

    -- A "new" click is one that wasn't down last frame but is down now
    if (isDownNow and not wasDownLastFrame) then
        isClicked = true
    end

    wasDownLastFrame = isDownNow


    if isClicked then
        currentPlayer = updateGameState(bbs,gameState,currentPlayer)
        isClicked = false
    end

end

function love.draw()
    tictactoe()
end

function tictactoe()

    
    local h = love.graphics.getHeight()
    local w = love.graphics.getWidth()

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

getBoundingBoxes = function()

    local h = love.graphics.getHeight()
    local w = love.graphics.getWidth()

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

function drawCircle( x, y )
    love.graphics.circle("line",x,y, 100 )
end

function drawX( x, y )
    local x1 = x - 100
    local y1 = y - 100
    local x2 = x + 100
    local y2 = y + 100

    love.graphics.line(x1,y1,x2,y2)
    love.graphics.line(x2,y1,x1,y2)
end

function drawAt( x, y, O_Or_X )

    if O_Or_X == "o" then
        drawCircle(x,y)
    elseif O_Or_X == "x" then
        drawX(x,y)
    end

end

function drawAtBox( boundingBox, O_Or_X )
    local x = boundingBox.x1 + ( boundingBox.x2 - boundingBox.x1 ) / 2
    local y = boundingBox.y1 + ( boundingBox.y2 - boundingBox.y1 ) / 2

    drawAt(x,y,O_Or_X)

end

function updateGameState( boundingBoxes, gameState, currentPlayer )

    local mx, my = love.mouse.getPosition()


        for i = 1,9 do
            local bb = boundingBoxes[i]

            if mx > bb.x1 and mx < bb.x2 and
               my > bb.y1 and my < bb.y2 then

                if currentPlayer == "1" then
                    gameState[i] = "x" 
                else 
                    gameState[i] = "o"
                end
            end
        end

        if currentPlayer == "1" then 
            currentPlayer = "2"
        elseif currentPlayer == "2" then
            currentPlayer = "1"
        end
    
    return currentPlayer
end
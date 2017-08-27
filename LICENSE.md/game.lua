local timer = 0
local gtimer = 0
local stimer = 0

Game = Object:extend()

function Game:new()
  self.speed = 10
  self.spriteSheet = love.graphics.newImage('assets/graphics/snake.png')
  self.snakeHead = SnakeHead(12, 6, self.spriteSheet)
  self.tail = Tail(0, 0)
  self.bodyParts = {self.snakeHead}
  self.redApple = {}
  self.goldenApple = {}
  self.biscuit = {}
  
  self.tilesTable = {}
  for i = 7, 10 do
    table.insert(self.tilesTable, love.graphics.newQuad(8 * i, 16, 8, 8, self.spriteSheet:getDimensions()))
  end
  for i = 9, 11 do
    table.insert(self.tilesTable, love.graphics.newQuad(8 * i, 0, 8, 8, self.spriteSheet:getDimensions()))
  end
  for i = 12, 13 do
     table.insert(self.tilesTable, love.graphics.newQuad(8 * i, 0, 8, 8, self.spriteSheet:getDimensions()))
  end
  
  self.tilemap = {
    
    {8, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 8},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 3},
    {9, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 9}
    
    }
end

function Game:update(dt)
-- controlla se hai vinto
  if #self.bodyParts >= 299 then
    won = true
    play = false
    start = false
    credit = false
  end
-- aggiorna posizione snake
  timer = timer + dt
  if timer > 1/self.speed then
    self:moveSnake()
    self.snakeHead:update(dt) 
    timer = 0
  end
  
-- controllo collisioni
  if self:collision() then
    lost = true
    play = false
    start = false
    credit = false
  end
  
  self:appleEaten()
-- controlla se va inserita la redApple o la goldenApple
  self:appleInsert()
  
  if #self.goldenApple == 1 then
    gtimer = gtimer + dt 
    if gtimer >= 6 then
      gtimer = 0
      table.remove(self.goldenApple, 1)
    end
  end

if self.speed > 10 then
  stimer = stimer + dt
  if stimer >= 5 then
    stimer = 0
    self.speed = 10
  end
end

 
end


function Game:draw()
  for i, row in ipairs(self.tilemap) do
    for j, tile in ipairs(row) do
      if not(tile == 0) then
        love.graphics.draw(self.spriteSheet, self.tilesTable[tile], (j - 1)*24, 32 + (i - 1)*24, 0, 3, 3)
      end
    end
    
    love.graphics.setFont(font)
    love.graphics.print('SCORE: '..#self.bodyParts, 10, 5)
  end
  
  self:drawSnake()
  
  if #self.redApple == 1 then
    self.redApple[1]:draw()
  end
  
  if #self.goldenApple == 1 then  
    self.goldenApple[1]:draw()
  end
  
  if #self.biscuit == 1 then
    self.biscuit[1]:draw()
  end
  end
  

--------------------------------------------------------------------------------------------------------------

function Game:keypressed(key)
  if play then
    if key == 'escape' then
      love.load()
    end
  end
  self.snakeHead:keypressed(key)
end


function Game:stretch()
  table.insert(self.bodyParts, BodyPart(self.tail.x, self.tail.y, self.spriteSheet))
end


function Game:moveSnake()
  self.tail.x = self.bodyParts[#self.bodyParts].x
  self.tail.y = self.bodyParts[#self.bodyParts].y
  if #self.bodyParts >= 2 then
    for i = #self.bodyParts, 2, -1 do
      self.bodyParts[i].x = self.bodyParts[i - 1].x
      self.bodyParts[i].y = self.bodyParts[i - 1].y
    end
  end
end


function Game:drawSnake()
  for i, v in ipairs(self.bodyParts) do
    v:draw()
  end
end


function Game:collision() 
-- controlla se va a sbattere nel muro
  if self.tilemap[self.snakeHead.y + 1][self.snakeHead.x +1] ~= 0 then   
    return true
  end
  -- controlla se si mangia da solo
  for i = 2, #self.bodyParts do
    if self.snakeHead.x == self.bodyParts[i].x and self.snakeHead.y == self.bodyParts[i].y then
      return true
    end
  end
  
  return false
end

function Game:appleInsert() 
 -- local possibleCoordinates = self:possibleAppleSpots()
  
  if #self.redApple < 1 then
    local possibleCoordinates = self:possibleAppleSpots()
    local var = math.random(1, #possibleCoordinates)
    local possibleX = possibleCoordinates[var][1]
    local possibleY = possibleCoordinates[var][2]
    table.insert(self.redApple, RedApple(possibleX, possibleY, self.spriteSheet))
  end
  
  if #self.goldenApple < 1 then
    if math.random(1, 5000) == 42 then 
      local possibleCoordinates = self:possibleAppleSpots()
      local var = math.random(1, #possibleCoordinates)
      local possibleX = possibleCoordinates[var][1]
      local possibleY = possibleCoordinates[var][2]
      table.insert(self.goldenApple, GoldenApple(possibleX, possibleY, self.spriteSheet))
    end
  end
  
  if #self.biscuit < 1 then
    if math.random(1, 7000) == 42 then 
      local possibleCoordinates = self:possibleAppleSpots()
      local var = math.random(1, #possibleCoordinates)
      local possibleX = possibleCoordinates[var][1]
      local possibleY = possibleCoordinates[var][2]
      table.insert(self.biscuit, Biscuit(possibleX, possibleY, self.spriteSheet))
    end
  end
end


-- se snake mangia apple/biscuit, toglie apple e allunga snake
function Game:appleEaten()
  if #self.redApple == 1 then
    if self.snakeHead.x == self.redApple[1].x and self.snakeHead.y == self.redApple[1].y then
      table.remove(self.redApple, 1)
      self:stretch()
     end
  end
  
  if #self.goldenApple == 1 then
    if self.snakeHead.x == self.goldenApple[1].x and self.snakeHead.y == self.goldenApple[1].y then
      table.remove(self.goldenApple, 1)
      gtimer = 0
      self:stretch()
      self:stretch()
     end
  end
  
  if #self.biscuit == 1 then
    if self.snakeHead.x == self.biscuit[1].x and self.snakeHead.y == self.biscuit[1].y then
      table.remove(self.biscuit, 1)
      self.speed = self.speed + 5
      stimer = 0
    end
  end
end


-- restituisce un table che contiene tutte le coordinate dove è possibile inserire apple/biscuit
function Game:possibleAppleSpots()
  local possibleCoordinates = {}
  for i = 1, 23 do    
    for j = 1, 13 do   
      if not(self:isSnake(i, j)) and not(self:isApple(i, j)) then
        table.insert(possibleCoordinates, {i, j})
      end
    end
  end
  return possibleCoordinates
end

-- controla se c'è una parte di snake alle coordinate X e Y
function Game:isSnake(X, Y)
  for i = 1, #self.bodyParts do  
    if self.bodyParts[i].x == X and self.bodyParts[i].y == Y then
      return true
    end
  end
  return false
end

-- controlla se c'è una mela (red o golden) o un biscuit alle coordinate X e Y
function Game:isApple(X, Y)
  if #self.redApple == 1 then
    if self.redApple[1].x == X and self.redApple[1].y == Y then
      return true
    end
  end
  
  if #self.goldenApple == 1 then
    if self.goldenApple[1].x == X and self.goldenApple[1].y == Y then
      return true
    end
  end
  
  if #self.biscuit == 1 then
    if self.biscuit[1].x == X and self.biscuit[1].y == Y then
      return true
    end
  end
  
  return false
end

-----------------------------START SCREEN-------------------------------------------

StartWindow = Object:extend()

function StartWindow:new()
  self.string = "WELCOME!\n\n\nPRESS 'C' TO SEE THE CREDITS\n\nPRESS 'P' TO PLAY\nAND USE THE ARROW KEYS\nTO MOVE THE SNAKE\n\nPRESS 'ESC' TO QUIT THE GAME"
end

function StartWindow:draw()
  love.graphics.setFont(font)
  love.graphics.print(self.string, 50, 70)
end
-----------------------CREDIT SCREEN-------------------------------------------------

CreditWindow = Object:extend()

function CreditWindow:new()
  self.string = 'THIS GAME WAS MADE BY SARAMONT\n\nGRAPHICS BY COSME'
end

function CreditWindow:draw()
  love.graphics.print(self.string, 50, 100)
end

function CreditWindow:keypressed(key)
  if key == 'escape' then
    start = true
    play = false
    credit = false
  end
end
-----------------------END SCREEN------------------------------------------------

WinLostScreen = Object:extend()

function WinLostScreen:new()
  self.won = "CONGRATULATIONS :)\n\nYOU WON!!!!!"
  self.lost = "YOU LOST :("
end

function WinLostScreen:draw()
  if won then
    love.graphics.print(self.won, 100, 100)
  end
  
  if lost then
    love.graphics.print(self.lost, 100, 100)
  end
end
-----------------------------------------------------------------------
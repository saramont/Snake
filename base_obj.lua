BaseObj = Object:extend()

function BaseObj:new(x, y, spriteSheet)
  self.x = x
  self.y = y
  
  self.spriteSheet = spriteSheet
  --self.quad = quad
end

function BaseObj:draw()
  love.graphics.draw(self.spriteSheet, self.quad, self.x * 24, 32 + 24 * self.y, 0, 3, 3)
end


-----------TAIL-----------------

Tail = BaseObj:extend()

function Tail:new(x, y)
  self.x = x
  self.y = y
end


-----------BISCUIT----------------------
Biscuit = BaseObj:extend()

function Biscuit:new(x, y, image)
  self.super.new(self, x, y, image)
  self.quad = love.graphics.newQuad(56, 24, 8, 8, self.spriteSheet:getDimensions())
end


-----------GOLDEN APPLE------------------


GoldenApple = BaseObj:extend()

function GoldenApple:new(x, y, image)
  self.super.new(self, x, y, image)
  self.quad = love.graphics.newQuad(48, 8, 8, 8, self.spriteSheet:getDimensions())
end

-------------------RED APPLE---------

RedApple = BaseObj:extend()

function RedApple:new(x, y, image)
  self.super.new(self, x, y, image)
  self.quad = love.graphics.newQuad(48, 0, 8, 8, self.spriteSheet:getDimensions())
end

----------------BODY PART

BodyPart = BaseObj:extend()

function BodyPart:new(x, y, image)
  self.super.new(self, x, y, image)
  self.quad = love.graphics.newQuad(40, 24, 8, 8, self.spriteSheet:getDimensions())
end

------------SNAKE HEAD-------------------

SnakeHead = BaseObj:extend()

function SnakeHead:new(x, y, image)
  self.super.new(self, x, y, image)
  
  self.direction = 'up'
  
  self.left = false
  self.right = false
  self.up = false
  self.down = false
  
  self.quad = love.graphics.newQuad(8, 24, 8, 8, self.spriteSheet:getDimensions())
end


function SnakeHead:update(dt)
  if self.direction == 'left' then 
       if self.left then 
         self.x=self.x-1 
         self:Left() 
       elseif self.right then 
         self.x=self.x-1 
         self:Left() 
       elseif self.up then 
         self.y = self.y-1 
         self:Up()  
         self.direction = 'up' 
       elseif self.down then 
         self.y=self.y+1 
         self.direction ='down'
         self:Down() 
         end
   elseif self.direction == 'right' then
      if self.left then 
         self.x=self.x+1 
         self:Right() 
       elseif self.right then 
         self.x=self.x+1 
         self:Right() 
       elseif self.up then 
         self.y = self.y-1 
         self:Up()  
         self.direction ='up' 
       elseif self.down then 
         self.y=self.y+1 
         self.direction ='down'
         self:Down() 
         end
   elseif self.direction == 'up' then
       if self.left then 
         self.x=self.x-1 
         self:Left() 
         self.direction = 'left'
       elseif self.right then 
         self.x=self.x+1 
         self:Right() 
         self.direction = 'right'
       elseif self.up then 
         self.y = self.y-1 
         self:Up()
       elseif self.down then 
         self.y=self.y-1 
         self:Up() 
         end
   elseif self.direction == 'down' then
        if self.left then 
         self.x=self.x-1 
         self:Left()
         self.direction = 'left'
       elseif self.right then 
         self.x=self.x+1 
         self:Right()
         self.direction = 'right'
       elseif self.up then 
         self.y = self.y+1 
         self:Down()  
       elseif self.down then 
         self.y=self.y+1 
         self:Down() 
         end
 end 
end



function SnakeHead:Left()
  self.quad = love.graphics.newQuad(16, 24, 8, 8, self.spriteSheet:getDimensions())
end

function SnakeHead:Right()
  self.quad = love.graphics.newQuad(32, 24, 8, 8, self.spriteSheet:getDimensions())
end

function SnakeHead:Up()
  self.quad = love.graphics.newQuad(8, 24, 8, 8, self.spriteSheet:getDimensions())
end

function SnakeHead:Down()
  self.quad = love.graphics.newQuad(24, 24, 8, 8, self.spriteSheet:getDimensions())
end


function SnakeHead:keypressed(key)
  if key == 'left' then
    self.left = true
    self.right = false
    self.up = false
    self.down = false
  elseif key == 'right' then
    self.left = false
    self.right = true
    self.up = false
    self.down = false
  elseif key == 'up' then
    self.left = false
    self.right = false
    self.up = true
    self.down = false
  elseif key == 'down' then
    self.left = false
    self.right = false
    self.up = false
    self.down = true
  end
end
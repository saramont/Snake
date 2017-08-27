Object = require "classic"
require "game"
require "base_obj"


local game
local startWindow
local lost_won

function love.load()
  
  play = false
  start = true
  credit = false

  lost = false
  won = false

  font = love.graphics.newFont('assets/font/half_bold_pixel-7.ttf', 20)
  love.graphics.setDefaultFilter('nearest', 'nearest')
  game = Game()
  startWindow = StartWindow()
  creditWindow = CreditWindow()
  lost_won = WinLostScreen()
end

function love.update(dt)
  if play then
    game:update(dt)
  end
end

function love.draw()
  if play then
    game:draw()
  elseif start then
    startWindow:draw()
  elseif credit then
    creditWindow:draw()
  elseif lost or won then
    lost_won:draw()
  end
end

-----------------------------------------------------------------------------------------------------

function love.keypressed(key)
  if start then
    if key == 'p' then
      play = true
      start = false
      credit = false
    elseif key == 'c' then
      play = false
      start = false
      credit = true
    elseif key == 'escape' then
      love.event.quit()
    end
  end
  
  if (lost or won) then
    if key == 'escape' then
      love.load()
    end
  end
  
  if play then
    game:keypressed(key)
  end
  
  if credit then
    creditWindow:keypressed(key)
  end
  
end
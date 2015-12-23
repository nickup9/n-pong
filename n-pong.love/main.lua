package.loaded.config = nil
local config = require("config")
config.checkPlayers()

test = love.window.setMode(500, 500)
if test == true then
	print("Borders edited")
end


local paddleOneX = {0, 20, 20, 0}
local paddleOneY = {220, 220, 310, 310}

local paddleTwoX = {480, 500, 500, 480}
local paddleTwoY = {220, 220, 310, 310}

local puckX = {225, 250, 250, 225}
local puckY = {265, 265, 285, 285}

local moveLeft = false
local moveRight = false
local diagSpeed = 0

font = love.graphics.newFont(14)
love.graphics.setFont(font)

local playerOne = 0
local playerTwo = 0
local winCheck = 0
local winStatus = ""

local paused = false
function love.keypressed(key)
  if key == "p" then
  	if paused == false then
  		print("Pause")
  	end
  	if paused == true then
  		print("Play on")
  	end
    paused = not paused
  end
end


function love.draw()
	local vertices = {paddleOneX[1], paddleOneY[1], paddleOneX[2], paddleOneY[2], paddleOneX[3], paddleOneY[3], paddleOneX[4], paddleOneY[4]}
	local verticesTwo = {paddleTwoX[1], paddleTwoY[1], paddleTwoX[2], paddleTwoY[2], paddleTwoX[3], paddleTwoY[3], paddleTwoX[4], paddleTwoY[4]}
	local puckVert = {puckX[1], puckY[1], puckX[2], puckY[2], puckX[3], puckY[3], puckX[4], puckY[4]}
	love.graphics.polygon('fill', vertices)
	love.graphics.polygon('fill', verticesTwo)
	love.graphics.polygon('fill', puckVert)
	love.graphics.print(playerOne, 200, 50)
	love.graphics.print(playerTwo, 300, 50)
	love.graphics.print(winStatus, 250, 250)
	if paused then return end
	keyBinds()
	puckLogic()
	movement()
	textLogic()
end

local pauseTimer = 10
function love.update(dt)
	function keyBinds()
		local up = love.keyboard.isDown('up')
		local down = love.keyboard.isDown('down')
		local w = love.keyboard.isDown('w')
		local s = love.keyboard.isDown('s')
		local q = love.keyboard.isDown('q')
		local d = love.keyboard.isDown('d')

		if q then
			love.event.quit()
			print("Good bye!")
		end



		if w and paddleOneY[1] > 0 and paddleOneY[2] > 0 then
			for i = 1, #paddleOneY do
				paddleOneY[i] = paddleOneY[i] - 5
			end
		end
		if s and paddleOneY[3] < 500 and paddleOneY[4] < 500 then
			for i = 1, #paddleOneY do
				paddleOneY[i] = paddleOneY[i] + 5
			end
		end
		
		if up and paddleTwoY[1] > 0 and paddleTwoY[2] > 0 then
			for i = 1, #paddleTwoY do
				paddleTwoY[i] = paddleTwoY[i] - 5
			end
		end
		if down and paddleTwoY[3] < 500 and paddleTwoY[4] < 500 then
			for i = 1, #paddleTwoY do
				paddleTwoY[i] = paddleTwoY[i] + 5
			end
		end
	end
	function puckLogic()
		if moveLeft == false and moveRight == false then
			moveLeft = true
			print("Good luck Have fun")
			print("Hit q to quit")
		end
		if puckX[1] <= 20 and puckX[4] <= 20 then
			if puckY[1] >= paddleOneY[1] and puckY[4] <= paddleOneY[4] then
				moveLeft = false
				moveRight = true
				if diagSpeed > 0 then
					diagSpeed = diagSpeed - 2
				end
				if diagSpeed < 0 then
					diagSpeed = diagSpeed + 2
				end
			end
			if puckY[1] >= paddleOneY[1] and puckY[1] <= paddleOneY[3] then
				if puckY[3] >= paddleOneY[3] then
					moveLeft = false 
					moveRight = true
					diagSpeed = diagSpeed + 5
				end
			end
			if puckY[3] <= paddleOneY[3] and puckY[3] >= paddleOneY[1] then
				if puckY[1] <= paddleOneY[1] then
					moveLeft = false
					moveRight = true
					diagSpeed = diagSpeed - 5
				end
			end
		end
		if puckX[2] >= 480 and puckX[3] >= 480 then
			if puckY[2] > paddleTwoY[2] and puckY[3] < paddleTwoY[3] then
				moveRight = false
				moveLeft = true
				if diagSpeed > 0 then
					diagSpeed = diagSpeed - 2
				end
				if diagSpeed < 0 then
					diagSpeed = diagSpeed + 2
				end
			end
			if puckY[1] >= paddleTwoY[1] - 15 and puckY[1] <= paddleTwoY[3] then
				if puckY[3] >= paddleTwoY[3] then 
					moveRight = false
					moveLeft = true
					diagSpeed = diagSpeed + 5
				end
			end
			if puckY[3] <= paddleTwoY[3] + 15 and puckY[3] >= paddleTwoY[1] then
				if puckY[1] <= paddleTwoY[1] then
					moveRight = false
					moveLeft = true
					diagSpeed = diagSpeed - 5
				end
			end
		end
		if puckX[2] < 0 then
			local time = 0;
			time = time + dt
			playerTwo = playerTwo + 1
			winCheck = 1
			returnDefaults()
			love.timer.sleep(3)
			print("Go!")
			winCheck = 0
		end
		if puckX[1] > 500 then
			playerOne = playerOne + 1
			winCheck = 2
			returnDefaults()
			love.timer.sleep(3)
			print("Go!")
			winCheck = 0
		end
		if puckY[1] < 0 then
			diagSpeed = diagSpeed*-1
		end
		if puckY[3] > 500 then
			diagSpeed = diagSpeed*-1
		end
		if playerOne == 11 then
			print("Player One has won!")
			love.event.quit()
		end
		if playerTwo == 11 then
			print("Player Two has won!")
			love.event.quit()
		end
	end
	function movement()
		if moveLeft == true then
			for i = 1, #puckX do
				puckX[i] = puckX[i] - 5
			end
			for i=1, #puckY do
				puckY[i] = puckY[i] + diagSpeed
			end
		end
		if moveRight == true then
			for i = 1, #puckX do
				puckX[i] = puckX[i] + 5
			end
			for i=1,#puckY do
				puckY[i] = puckY[i] + diagSpeed
			end
		end
	end
	function textLogic()
		if winCheck == 1 then
			winStatus = "Player Two scored!"
			print("Debug: textLogic called")
		end
		if winCheck == 2 then
			winStatus = "Player One scored!"
			print("Debug: textLogic called")
		end
		if winCheck == 0 then
			winStatus = ""
			print("Debug: textLogic called")
		end
	end
end



function returnDefaults()
	paddleOneX = {0, 20, 20, 0}
	paddleOneY = {220, 220, 310, 310}
	paddleTwoX = {480, 500, 500, 480}
	paddleTwoY = {220, 220, 310, 310}
	puckX = {225, 250, 250, 225}
	puckY = {265, 265, 285, 285}
	moveRight = false
	moveLeft = true
	direction = false
	diagSpeed = 0
	time = 0;
end
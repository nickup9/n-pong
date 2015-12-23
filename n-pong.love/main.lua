package.loaded.config = nil
local config = require("config")
config.checkPlayers()

test = love.window.setMode(500, 500)
if test == true then
	print("Borders edited")
end


local paddleOneXCoords = {0, 20, 20, 0}
local paddleOneYCoords = {220, 220, 310, 310}

local paddleTwoXCoords = {480, 500, 500, 480}
local paddleTwoYCoords = {220, 220, 310, 310}

local puckXCoords = {225, 250, 250, 225}
local puckYCoords = {265, 265, 285, 285}

local moveLeft = false
local moveRight = false
local diagSpeed = 0

font = love.graphics.newFont(14)
love.graphics.setFont(font)

local playerOneScore = 0
local playerTwoScore = 0
local winner = ""

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
	local paddleOneVertices = {paddleOneXCoords[1], paddleOneYCoords[1], paddleOneXCoords[2], paddleOneYCoords[2], paddleOneXCoords[3], paddleOneYCoords[3], paddleOneXCoords[4], paddleOneYCoords[4]}
	local paddleTwoVertices = {paddleTwoXCoords[1], paddleTwoYCoords[1], paddleTwoXCoords[2], paddleTwoYCoords[2], paddleTwoXCoords[3], paddleTwoYCoords[3], paddleTwoXCoords[4], paddleTwoYCoords[4]}
	local puckVert = {puckXCoords[1], puckYCoords[1], puckXCoords[2], puckYCoords[2], puckXCoords[3], puckYCoords[3], puckXCoords[4], puckYCoords[4]}
	love.graphics.polygon('fill', paddleOneVertices)
	love.graphics.polygon('fill', paddleTwoVertices)
	love.graphics.polygon('fill', puckVert)
	love.graphics.print(playerOneScore, 200, 50)
	love.graphics.print(playerTwoScore, 300, 50)
	love.graphics.print(winner, 250, 250)
	if paused then return end
	keyBinds()
	puckLogic()
	movement()
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



		if w and paddleOneYCoords[1] > 0 and paddleOneYCoords[2] > 0 then
			for i = 1, #paddleOneYCoords do
				paddleOneYCoords[i] = paddleOneYCoords[i] - 5
			end
		end
		if s and paddleOneYCoords[3] < 500 and paddleOneYCoords[4] < 500 then
			for i = 1, #paddleOneYCoords do
				paddleOneYCoords[i] = paddleOneYCoords[i] + 5
			end
		end
		
		if up and paddleTwoYCoords[1] > 0 and paddleTwoYCoords[2] > 0 then
			for i = 1, #paddleTwoYCoords do
				paddleTwoYCoords[i] = paddleTwoYCoords[i] - 5
			end
		end
		if down and paddleTwoYCoords[3] < 500 and paddleTwoYCoords[4] < 500 then
			for i = 1, #paddleTwoYCoords do
				paddleTwoYCoords[i] = paddleTwoYCoords[i] + 5
			end
		end
	end
	function puckLogic()
		if moveLeft == false and moveRight == false then
			moveLeft = true
			print("Good luck Have fun")
			print("Hit q to quit")
		end
		if puckXCoords[1] <= 20 and puckXCoords[4] <= 20 then
			if puckYCoords[1] >= paddleOneYCoords[1] and puckYCoords[4] <= paddleOneYCoords[4] then
				moveLeft = false
				moveRight = true
				if diagSpeed > 0 then
					diagSpeed = diagSpeed - 2
				end
				if diagSpeed < 0 then
					diagSpeed = diagSpeed + 2
				end
			end
			if puckYCoords[1] >= paddleOneYCoords[1] and puckYCoords[1] <= paddleOneYCoords[3] then
				if puckYCoords[3] >= paddleOneYCoords[3] then
					moveLeft = false 
					moveRight = true
					CoordsdiagSpeed = diagSpeed + 5
				end
			end
			if puckYCoords[3] <= paddleOneYCoords[3] and puckYCoords[3] >= paddleOneYCoords[1] then
				if puckYCoords[1] <= paddleOneYCoords[1] then
					moveLeft = false
					moveRight = true
					diagSpeed = diagSpeed - 5
				end
			end
		end
		if puckXCoords[2] >= 480 and puckXCoords[3] >= 480 then
			if puckYCoords[2] > paddleTwoYCoords[2] and puckYCoords[3] < paddleTwoYCoords[3] then
				moveRight = false
				moveLeft = true
				if diagSpeed > 0 then
					diagSpeed = diagSpeed - 2
				end
				if diagSpeed < 0 then
					diagSpeed = diagSpeed + 2
				end
			end
			if puckYCoords[1] >= paddleTwoYCoords[1] - 15 and puckYCoords[1] <= paddleTwoYCoords[3] then
				if puckYCoords[3] >= paddleTwoYCoords[3] then 
					moveRight = false
					moveLeft = true
					diagSpeed = diagSpeed + 5
				end
			end
			if puckYCoords[3] <= paddleTwoYCoords[3] + 15 and puckYCoords[3] >= paddleTwoYCoords[1] then
				if puckYCoords[1] <= paddleTwoYCoords[1] then
					moveRight = false
					moveLeft = true
					diagSpeed = diagSpeed - 5
				end
			end
		end
		if puckXCoords[2] < 0 then
			winner = "Player Two scored!"
			playerTwoScore = playerTwoScore + 1
			resetGameState()
			love.timer.sleep(3)
			print("Go!")
			winner = ""
		end
		if puckXCoords[1] > 500 then
			winner = "Player One scored!"
			playerOneScore = playerOneScore + 1
			resetGameState()
			love.timer.sleep(3)
			print("Go!")
			winner = ""
		end
		if puckYCoords[1] < 0 then
			diagSpeed = diagSpeed*-1
		end
		if puckYCoords[3] > 500 then
			diagSpeed = diagSpeed*-1
		end
		if playerOneScore == 11 then
			print("Player One has won!")
			love.event.quit()
		end
		if playerTwoScore == 11 then
			print("Player Two has won!")
			love.event.quit()
		end
	end
	function movement()
		if moveLeft == true then
			for i = 1, #puckXCoords do
				puckXCoords[i] = puckXCoords[i] - 5
			end
			for i=1, #puckYCoords do
				puckYCoords[i] = puckYCoords[i] + diagSpeed
			end
		end
		if moveRight == true then
			for i = 1, #puckXCoords do
				puckXCoords[i] = puckXCoords[i] + 5
			end
			for i=1,#puckYCoords do
				puckYCoords[i] = puckYCoords[i] + diagSpeed
			end
		end
	end
end



function resetGameState()
	paddleOneXCoords = {0, 20, 20, 0}
	paddleOneYCoords = {220, 220, 310, 310}
	paddleTwoXCoords = {480, 500, 500, 480}
	paddleTwoYCoords = {220, 220, 310, 310}
	puckXCoords = {225, 250, 250, 225}
	puckYCoords = {265, 265, 285, 285}
	moveRight = false
	moveLeft = true
	direction = false
	diagSpeed = 0
	time = 0;
end
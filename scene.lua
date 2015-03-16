scene = {}
scene.title = {}
scene.game = {}
scene.score = {}

function scene.title.load()
	cursor = {}
	cursor.pos = 1
	cursor.y = {113, 158, 202}
	cursor.x = 189

	floatup = false
	tmrupdown = 0.3
	floatamount = 0

	game.scene = 1
	sound.play("title")
end

function scene.title.draw()
	love.graphics.draw(imgtitle)
	love.graphics.draw(imgcursor, cursor.x, cursor.y[cursor.pos] + floatamount)
end

function scene.title.keypressed(key)
	if key == "up" then
		if not(cursor.pos == 1) then
			cursor.pos = cursor.pos - 1
			effect.play("click")
		end
	elseif key == "down" then
		if not(cursor.pos == 3) then
			cursor.pos = cursor.pos + 1
			effect.play("click")
		end
	elseif key == " " then
		if cursor.pos == 1 then
			effect.play("click")
			scene.game.load()
		elseif cursor.pos == 2 then
			effect.play("click")
			scene.score.load()
		elseif cursor.pos == 3 then
			effect.play("click")
			love.event.quit()
		end
	end
end

function scene.title.update(dt)
	tmrupdown = tmrupdown - dt
	if tmrupdown <= 0 then
		tmrupdown = tmrupdown + 0.3
		if floatup == false then
			floatup = true
		else
			floatup = false
		end
	end

	if floatup == true then
		floatamount = floatamount - dt * 25
	else
		floatamount = floatamount + dt * 25
	end
end

---------------------------------------------------------

function scene.game.load()
	countdown = true
	counting = 3
	countscale = 50
	delay = 0.3

	player = "rock"
	playerx = 7
	playery = 130
	floatup = false
	tmrupdown = 0.5
	floatamount = 0
	lose = false

	pline = {}
	pline["scissor"] = 150
	pline["rock"] = 100
	pline["paper"] = 140

	gamespeed = 180

	score = 0

	enemy.init()

	game.scene = 2
	sound.play("game")
end

function scene.game.update(dt)
	if countdown == true then
		--countdown
		if countscale > 1 then
			countscale = math.max(countscale - dt * 100, 1)
		else
	    	countscale = 1
			delay = delay - dt
			if delay <= 0 then
				if counting == 0 then
					countdown = false
				else
					effect.play("explosion")
					counting = counting - 1
					countscale = 50
					delay = 0.3
				end
			end
		end
	else --countdown == false
		if lose == false then
			--float
			tmrupdown = tmrupdown - dt
			if tmrupdown <= 0 then
				tmrupdown = tmrupdown + 0.5
				if floatup == false then
					floatup = true
				else
					floatup = false
				end
			end

			if floatup == true then
				floatamount = floatamount - dt * 25
			else
				floatamount = floatamount + dt * 25
			end

			--score
			score = score + dt * 20

			--it's getting harder...
			gamespeed = gamespeed + dt * 20

			--update enemy
			enemy.update(dt)
		end
	end

end

function scene.game.lose()
	if lose == false then
		effect.play("playerlose")
		lose = true
		highscore.add("", math.floor(score))
		highscore.save()
	end
end

function scene.game.keypressed(key)
	if countdown == false then
		if lose == false then
			if key == "z" then
				player = "scissor"
			elseif key == "x" then
				player = "rock"
			elseif key == "c" then
				player = "paper"
			end
		else
			if key == " " then
				effect.play("click")
				scene.score.load()
			end
		end
	end
end

function scene.game.draw()
	love.graphics.draw(imgbackground)	

	--draw icon
	love.graphics.draw(imgplayer["scissor"], 10, 260, 0, 0.4, 0.4)
	love.graphics.draw(imgplayer["rock"], 80, 260, 0, 0.4, 0.4)
	love.graphics.draw(imgplayer["paper"], 130, 260, 0, 0.4, 0.4)

	if countdown == true then
		--countdwn
		love.graphics.draw(imgnumber[counting], 296, 120, 0, countscale, countscale)
	end

	--draw enemy
	enemy.draw()

	--draw player
	love.graphics.draw(imgplayer[player], playerx, playery - floatamount)

	--draw score
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("Score:"..math.floor(score), 5)
	love.graphics.setColor(255, 255, 255)

	if lose == true then
		love.graphics.draw(imglose, 85, 98)
	end
end

---------------------------------------------------------

function scene.score.load()
	game.scene = 3
end

function scene.score.draw()
	love.graphics.rectangle("fill", 0, 0, 640, 360)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print("TOP 5 Runners", 10, 10)
	local i, score, name
	for i, score, name in highscore() do
	    love.graphics.print(i .. ": " .. score, 10, i * 40 + 40)
	end
	love.graphics.setColor(255, 255, 255)
end

function scene.score.update(dt)

end

function scene.score.keypressed(key)
	if key == " " then
		scene.title.load()
	end
end
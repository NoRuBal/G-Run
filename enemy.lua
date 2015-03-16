enemy = {}
enemytbl = {"rock", "scissor", "paper"}

function enemy.init()
	local a
	for a = 1, #enemy do
		enemy[a].enabled = false
	end

	enemy.timer = 0 --make enemy
end

function enemy.new(kind)
	local a
	local index
	
	index = #enemy + 1
	
	for a = 1, #enemy do
		if enemy[a].enabled == false then
			index = a
			break
		end
	end
	
	enemy[index] = {}
	enemy[index].kind = kind --rock/paper/scissor
	enemy[index].x = 640 + 160
	enemy[index].y = 125
	enemy[index].rotation = 0
	enemy[index].scale = 1
	enemy[index].lose = false
	enemy[index].enabled = true
end

function enemy.update(dt)
	local a

	--move enemy
	for a = 1, #enemy do
		if enemy[a].enabled == true then
			if enemy[a].lose == false then
				enemy[a].x = enemy[a].x - gamespeed * dt
				
				--check collision
				if enemy[a].x <= pline[player] then
					if player == "rock" then
						if enemy[a].kind == "scissor" then
							enemy[a].lose = true
							effect.play("enemylose")
						else
							scene.game.lose()
						end
					elseif player == "scissor" then
						if enemy[a].kind == "paper" then
							enemy[a].lose = true
							effect.play("enemylose")
						else
							scene.game.lose()
						end
					elseif player == "paper" then
						if enemy[a].kind == "rock" then
							enemy[a].lose = true
							effect.play("enemylose")
						else
							scene.game.lose()
						end
					end
				end
			else
				--fly to the skyyyy~~
				enemy[a].y = enemy[a].y - dt * 100
				enemy[a].x = enemy[a].x + dt * 100
				enemy[a].rotation = enemy[a].rotation - 3.14 * dt * 5
				enemy[a].scale = enemy[a].scale - dt
				if enemy[a].scale <= 0 then
					enemy[a].enabled = false
				end
			end
		end
	end

	--make enemy
	enemy.timer = enemy.timer - dt
	if enemy.timer <= 0 then
		enemy.new(enemytbl[math.random(1, 3)])
		enemy.timer = math.random(1.0, 3.0)
	end
end

function enemy.draw()
	local a
	for a = 1, #enemy do
		if enemy[a].enabled == true then
			love.graphics.draw(imgenemy[enemy[a].kind], enemy[a].x, enemy[a].y, enemy[a].rotation, enemy[a].scale, enemy[a].scale)
		end
	end
end
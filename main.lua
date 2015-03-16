require "scene"
require "enemy"
highscore = require "/lib/sick/sick"

game = {}
game.scene = 1

sound = {}
effect = {}

function love.load()
	--make new font
	font = love.graphics.newFont("graphics/impact.ttf", 40)
	love.graphics.setFont(font)

	imgtitle = love.graphics.newImage("graphics/title.png")
	imgcursor = love.graphics.newImage("graphics/point.png")

	imgbackground = love.graphics.newImage("graphics/background.png")
	imgnumber = {}
	imgnumber[3] = love.graphics.newImage("graphics/3.png")
	imgnumber[2] = love.graphics.newImage("graphics/2.png")
	imgnumber[1] = love.graphics.newImage("graphics/1.png")
	imgnumber[0] = love.graphics.newImage("graphics/0.png")

	imgplayer = {}
	imgplayer["rock"] = love.graphics.newImage("graphics/playerrock.png")
	imgplayer["scissor"] = love.graphics.newImage("graphics/playerscissor.png")
	imgplayer["paper"] = love.graphics.newImage("graphics/playerpaper.png")

	imgenemy = {}
	imgenemy["rock"] = love.graphics.newImage("graphics/enemyrock.png")
	imgenemy["scissor"] = love.graphics.newImage("graphics/enemyscissor.png")
	imgenemy["paper"] = love.graphics.newImage("graphics/enemypaper.png")

	imglose = love.graphics.newImage("graphics/lose.png")

	bgm = {}
	bgm["title"] = love.audio.newSource("sound/bgm_title.ogg", "stream")
	bgm["game"] = love.audio.newSource("sound/bgm_game.ogg", "stream")
	
	se = {}
	se["enemylose"] = love.audio.newSource("sound/se_enemylose.ogg", "static")
	se["playerlose"] = love.audio.newSource("sound/se_playerlose.ogg", "static")
	se["explosion"] = love.audio.newSource("sound/se_explosion.ogg", "static")
	se["click"] = love.audio.newSource("sound/se_click.ogg", "static")

	math.randomseed(os.time())

	highscore.set("grun", 5, "", 0)

	scene.title.load()
end

function love.draw()
	if game.scene == 1 then
		scene.title.draw()
	elseif game.scene == 2 then
		scene.game.draw()
	elseif game.scene == 3 then
		scene.score.draw()
	end
end

function love.keypressed(key)
	if game.scene == 1 then
		scene.title.keypressed(key)
	elseif game.scene == 2 then
		scene.game.keypressed(key)
	elseif game.scene == 3 then
		scene.score.keypressed(key)
	end
end

function love.update(dt)
	if game.scene == 1 then
		scene.title.update(dt)
	elseif game.scene == 2 then
		scene.game.update(dt)
	elseif game.scene == 3 then
		scene.score.update(dt)
	end
end

function sound.play(index)
	love.audio.stop()
	love.audio.rewind(bgm[index])
	love.audio.play(bgm[index])
	bgm[index]:setLooping(true)
end

function effect.play(index)
	love.audio.rewind(se[index])
	love.audio.play(se[index])
end
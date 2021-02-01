function love.load()
	music = love.audio.newSource("musicd.mp3")
	good = love.audio.newSource("good.mp3")
	fail = love.audio.newSource("fail.mp3")
	font = love.graphics.newFont("pixelated.ttf",35)
	love.graphics.setFont(font)
	circles = {}
	b = 0
	maximum = 0
	play()
	while b < 20 do
		getCircle()
		cuentabla()
	end
end

paused = false
notstarted = false
function love.keypressed(key)
	if key == "p" then
		paused = not paused
		love.audio.pause(music)
	elseif key == " " then
		started = true
		lose = 0
		play()
		circles = {}
	end
end

function getCircle()
	a = math.random(1,4)
	circle = {}
	circle.radius = math.random(player.radius/2, player.radius*2)
	circle.color = {math.random(0,255),math.random(0,255),math.random(0,255)}
	if a == 1 then
		circle.x = 0
		circle.y = math.random(0, 600)
		circle.speedx = math.random(10,200)
		circle.speedy = 200 - math.abs(circle.speedx)
	elseif a == 2 then
		circle.x = 800
		circle.y = math.random(0, 600)
		circle.speedx = math.random(-200,10)
		circle.speedy = 200 - math.abs(circle.speedx)
	elseif a == 3 then
		circle.y = 0
		circle.x = math.random(0, 800)
		circle.speedy = math.random(10,200)
		circle.speedx = 200 - math.abs(circle.speedy)
	elseif a == 4 then
		circle.y = 600
		circle.x = math.random(0, 800)
		circle.speedy = math.random(-200,10)
		circle.speedx = 200 - math.abs(circle.speedy)
	end
	table.insert(circles, circle)
end

function removeCircles()
	for i,v in ipairs(circles) do
		if (v.x + v.radius) < 0 or (v.y + v.radius) < 0 or v.x > 800 or v.y > 600 then
			table.remove(circles, i)
		end
	end
end

function moveCircles(dt)
	for i,v in ipairs(circles) do
		v.x = v.x + (v.speedx * dt)
		v.y = v.y + (v.speedy * dt)
	end
end

function cuentabla()
	b = 0
	for i,v in ipairs(circles) do
		b = b + 1
	end
end

function play()
	player = {}
	player.x = 390
	player.y = 290
	player.radius = 20
	player.points = 0
end

function playerMove()
	x = love.mouse.getX() - player.radius/2
	y = love.mouse.getY() - player.radius/2
	player.x = player.x - (player.x - x)
	player.y = player.y - (player.y - y)
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function Collision()
	for i,v in ipairs(circles) do
		if CheckCollision(player.x,player.y,player.radius,player.radius,v.x,v.y,v.radius,v.radius) then
			if player.radius > v.radius then
				player.radius = player.radius + 2
				player.points = player.points + 1
				table.remove(circles,i)
				good:play()
			else
				lose = 1
				fail:play()
			end
		end
	end
end

function high()
	if player.points > maximum then
		maximum = player.points
	end
end


function love.update(dt)
	if paused or not started or lose == 1 then
		love.audio.pause(music)
		high()
	return end
		music:play()
		cuentabla()
		if b < 20 then
			getCircle()
		end
		moveCircles(dt)
		removeCircles()
		playerMove()
		Collision()
end

function love.draw()
	for i,v in ipairs(circles) do
		love.graphics.setColor(v.color, 255)
		love.graphics.rectangle("fill",v.x,v.y,v.radius,v.radius)
	end
	love.graphics.setColor(255,255,255,255)
	love.graphics.rectangle("fill",player.x,player.y,player.radius,player.radius)
	if not started then
		love.graphics.print("Muevete con el Mouse\nPresiona la barra espaciadora\npara continuar",100,100)
	end
	if lose == 1 then
		love.graphics.print("Perdiste. Trata de nuevo\nPresiona la barra espaciadora\npara continuar\nPuntos: " .. player.points ..  "\nRecord: " .. maximum, 100, 100)
	end
end


local md5 = require "md5"
local socket = require "socket"

-- the address and port of the server
local address, port = "localhost", 9980

local send = 0
local time_send = 2
local in_time = 0
local SendPacket = "nill"
local update = 0
local all_update = 0

function love.load()
	server = {}

	server.udp = socket.udp()

	server.udp:settimeout(0)
	server.udp:setpeername(address, port)

	identy = tostring(math.random(99999))
	identy = identy..tostring(socket.dns.toip(socket.dns.gethostname()))
	identy = enc(identy)

	start_send = string.format("UserID(%s) Connecting", identy)

	server.udp:send(start_send)

	file_md5 = md5.file("GameClient.love")
end
	
function love.draw()
	love.graphics.print("User ID ("..identy..")", 10, 10, 0, 2, 2)
	love.graphics.print("Send: "..SendPacket, 10, 50, 0, 2, 2)
	love.graphics.print("Update: "..update, 10, 90, 0, 2, 2)
	love.graphics.print("Time Start: "..all_update, 10, 130, 0, 2, 2)
	love.graphics.print("Ip: "..socket.dns.toip(socket.dns.gethostname()), 10, 170, 0, 2, 2)
	love.graphics.print("Teste: "..file_md5, 10, 210, 0, 2, 2)
end

function love.update(dt)
	math.randomseed(os.time()*(os.time()/12)) -- Mudando a cada Segundo
	if in_time >= time_send then 
		if send == 1 then

			SendPacket = string.format("%s", tostring(math.random(9999)).." UserID("..identy..") "..file_md5)
			server.udp:send(SendPacket)
		end

		in_time = 0
	else
		in_time = in_time + dt
	end

	update = dt
	all_update = all_update + dt
end

function love.focus(bool)
end

function love.keypressed(key, unicode)
	if key == "k" then
		if send == 1 then send = 0 elseif send == 0 then send = 1 end
	end
end

function love.keyreleased(key)
end

function love.mousepressed(x, y, button)
end

function love.mousereleased(x, y, button)
end

function love.quit()
end

require("base64")
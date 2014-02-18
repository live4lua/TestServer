
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

	math.randomseed(os.time())

	identy = tostring(math.random(99999))
	identy = identy..tostring(socket.dns.toip(socket.dns.gethostname()))
	identy = enc(identy)

	start_send = string.format("UserID(%s) Connecting", identy)

	server.udp:send(start_send)
end
	
function love.draw()
	love.graphics.print("User ID ("..identy..")", 10, 10, 0, 2, 2)
	love.graphics.print("Send: "..SendPacket, 10, 50, 0, 2, 2)
	love.graphics.print("Update: "..update, 10, 90, 0, 2, 2)
	love.graphics.print("Time Start: "..all_update, 10, 130, 0, 2, 2)
	love.graphics.print("Ip: "..socket.dns.toip(socket.dns.gethostname()), 10, 170, 0, 2, 2)
end

function love.update(dt)
	if in_time >= time_send then 
		if send == 1 then

			SendPacket = string.format("%s", tostring(math.random(9999)).." UserID("..identy..")")
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

-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2

-- Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- licensed under the terms of the LGPL2

-- character table string
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/.,'

-- encoding
function enc(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- decoding
function dec(data)
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end

-- command line if not called as library
if (arg ~= nil) then
	local func = 'enc'
	for n,v in ipairs(arg) do
		if (n > 0) then
			if (v == "-h") then print "base64.lua [-e] [-d] text/data" break
			elseif (v == "-e") then func = 'enc'
			elseif (v == "-d") then func = 'dec'
			else print(_G[func](v)) end
		end
	end
else
	module('base64',package.seeall)
end
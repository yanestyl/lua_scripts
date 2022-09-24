script_name('DTimer')
script_author('yanestyl')
script_version("19/11/2021")

local sampev = require 'lib.samp.events'
local inicfg = require 'inicfg'
local mainIni = inicfg.load({DTimer = { posX = 1540, posY = 240}}, "DTimer")

local count = -1
local previous = 0
local next = 0
local kd = {}
local kd_sec = 0
local kd_todate = 0
local time = false
local previous_1 = 0
local next_1 = 0

local proverka = false

local work = false

local font_flag = require('moonloader').font_flag
local my_font = renderCreateFont('Arial', 10, font_flag.BOLD  + font_flag.BORDER)

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand('dtimer', cmd_dtimer)

	
	while true do
		wait(0)
		
		kukold_squad()
		
		if time then
			renderFontDrawText(my_font, tostring(kd.hour) .. ':' .. tostring(kd.min) .. ':' .. tostring(kd.sec) .. ' | КД: ' .. kd_sec, mainIni.DTimer.posX, mainIni.DTimer.posY, 0xFFFFFFFF)
			local k = next_1 + kd_sec + 120
			local timer = k - os.time()
			local minute, second = math.floor(timer / 60), timer % 60
			text =  string.format("Длив через: %02d:%02d", minute, second)
			if timer >= 0 then
				renderFontDrawText(my_font, text, mainIni.DTimer.posX, mainIni.DTimer.posY + 18, 0xFFFFFFFF)
			end
		end
		while work do
			wait(0)
			posX, posY = getCursorPos()
			renderFontDrawText(my_font,'12:34:56 | КД: 12.34', posX, posY, 0xFFFFFFFF)
			renderFontDrawText(my_font,'Длив через: 12:34', posX, posY + 18, 0xFFFFFFFF)
			showCursor(true, false)

			if isKeyJustPressed(1) then
				showCursor(false)
				mainIni.DTimer.posX = posX
				mainIni.DTimer.posY = posY
				inicfg.save(mainIni, "DTimer")
				work = false
			end
		end
	end
end

function cmd_dtimer()
	work = true
end

function sampev.onServerMessage(color, message)
    if string.find(message, " У вас есть.* 2 минуты чтобы решить с.+") then
		proverka = true
		count = count + 1
        if count == 0 then
            previous = os.clock()
			previous_1 = os.time()
			sampAddChatMessage('{b88fff}[DTimer by yanestyl] {cccccc}the script is launched...', -1)
        else
			
			time = true 
			next = os.clock()
			next_1 = os.time()
			kd_sec = next - previous - 120
			kd_sec = math.floor(kd_sec*100)/100
			kd_todate = next_1 + 120 + kd_sec + 10800
			kd = os.date("!*t",kd_todate)
            sampAddChatMessage('{b88fff}[DTimer by yanestyl] {cccccc}стрела продолжается | kd: {ffc0cb}' .. kd_sec .. '{cccccc} | time: {ffc0cb}' .. kd.hour ..':' .. kd.min .. ':' .. kd.sec.. '{cccccc} | dliv: {ffc0cb}' .. count, -1)
            previous_1 = next_1
			previous = next
        end
    end
    if string.find(message, " под контроль Бизнес") or string.find(message, " Вы отстояли свой Бизнес") or string.find(message, " потеряли контроль над Бизнесом") and proverka then
		next = os.clock()
		next_1 = os.time()
		kd_sec = next - previous - 120
        sampAddChatMessage('{b88fff}[DTimer by yanestyl] {cccccc}стрела закончилась | last kd: {ffc0cb}' .. kd_sec .. '{cccccc} | dlivs: {ffc0cb}' .. count,-1)
		next_1 = 0
		previous_1 = 0
		next = 0
		previous = 0
		count = -1
		time = false
    end
end


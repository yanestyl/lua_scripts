script_name('KD')
script_author('yanestyl')
script_version("12/10/2021")

local sampev = require 'lib.samp.events'
local kd1 = 0
local kd2 = 0
local kd = 0
local time_20 = 0
local time_10 = 0
local time_2 = 0
local t_20 = 0
local t_10 = 0
local t_2 = 0
local dt = os.date("!*t",os.time())
local datetime = {}
local dt_20 = {}
local dt_10 = {}
local dt_2 = {}
local i_20 = false
local i_10 = false
local main_color = "0xFFFFFF"
local sum = 1

function main()
    if not isSampfuncsLoaded() or not isSampLoaded() then return end
    while not isSampAvailable() do wait(100) end
	
	sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF} Скрипт успешно загружен. Испульзуйте - {87CEEB}/kd_help" , main_color)
	
	sampRegisterChatCommand("kd_add", kd_add)
	sampRegisterChatCommand("kd_clear", kd_clear)
	sampRegisterChatCommand("kd_help", kd_help)
	sampRegisterChatCommand("kd_check", kd_check)
	
end

function kd_add(arg)
	arg1, arg2 = string.match(arg, "(.+) (.+)")
	if arg1 == nil or arg1 == "" then
		sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Недопустимая форма записи. Воспользуетесь {DB7093}/kd_help", main_color)
	else
		dt.hour,dt.min,dt.sec = string.match(arg2,"(%d*):(%d*):(%d*)")
	
		if dt.hour == nil or dt.hour == "" or dt.min == nil or dt.min == "" or dt.sec == nil or dt.sec == "" or tonumber(dt.hour) < 0 or tonumber(dt.hour) > 23 or tonumber(dt.min) < 0 or tonumber(dt.min) > 60 or tonumber(dt.sec) < 0 or tonumber(dt.sec) > 60 then
			sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Недопустимая форма записи. Воспользуетесь {DB7093}/kd_help", main_color)
		else
			for key,value in pairs(dt) do 
			dt[key] = tonumber(value) 
			end
			if arg1 == "20" then

				sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Вы установили время начала стрелы - {87CEEB}" .. dt.hour .. ":" .. dt.min .. ":" .. dt.sec, main_color)
				time_20 = os.time(dt)
				i_20 = true
			elseif arg1 == "10" then

				sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Вы установили время 10 минут - {87CEEB}" .. dt.hour .. ":" .. dt.min .. ":" .. dt.sec, main_color)
				time_10 = os.time(dt)
				i_10 = true
			elseif arg1 == "2" then
				sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Вы установили время 2 минут - {87CEEB}" .. dt.hour .. ":" .. dt.min .. ":" .. dt.sec, main_color)
				time_2 = os.time(dt)
				if i_20 == true and i_10 == true then
					bug()
					kd = ((1.5 * time_2 - 2 * time_10 + 0.5 * time_20 - 600) / 5 + (time_2 - time_10 - 600) / 5 ) / 2
					sum = sum - 1
					sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Предполагаемое KD длива: {7FFFD4}" .. kd, main_color)
					i_20 = false
					i_10 = false
				elseif i_10 == true and sum > 0 then
					sum = sum -1
					bug()
					kd = (time_2 - time_10 - 600) / 5

					sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Предполагаемое KD длива: {7FFFD4}" .. kd, main_color)
					i_10 = false
				end
			else
				sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Недопустимая форма записи. Воспользуетесь {DB7093}/kd_help", main_color)
			end
		end
	end
end

function sampev.onServerMessage(color, message)
	local datetime = os.date("*t");
	if string.find(message, " набила вам стрелку.") or string.find(message, "Вы набили стрелку ") then
		time_20 = os.time()
        sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Автоматически установленное время начала стрелы - {87CEEB}" .. datetime.hour .. ":" .. datetime.min .. ":" .. datetime.sec, main_color)
		i_20 = true
    end
    if string.find(message, " У вас осталось 10 минут.") then
		time_10 = os.time()
        sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Автоматически установленное время 10 минут - {87CEEB}" .. datetime.hour .. ":" .. datetime.min .. ":" .. datetime.sec, main_color)
		i_10 = true
    end
	
	if string.find(message, " 2 минуты чтобы решить") then
		if i_20 == true and i_10 == true and sum > 0 then
			sum = sum - 1
			time_2 = os.time()
			sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Автоматически установленное время 2 минут - {87CEEB}" .. datetime.hour .. ":" .. datetime.min .. ":" .. datetime.sec, main_color)
			bug()
			kd = ((1.5 * time_2 - 2 * time_10 + 0.5 * time_20 - 600) / 5 + (time_2 - time_10 - 600) / 5 ) / 2

			sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Предполагаемое KD длива: {7FFFD4}" .. kd, main_color)
			i_20 = false
			i_10 = false
		elseif i_10 == true and sum > 0 then
		sum = sum -1
		time_2 = os.time()
		sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Автоматически установленное время 2 минут - {87CEEB}" .. datetime.hour .. ":" .. datetime.min .. ":" .. datetime.sec, main_color)
			bug()
			kd = (time_2 - time_10 - 600) / 5 

			sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Предполагаемое KD длива: {7FFFD4}" .. kd, main_color)
			i_10 = false
		end
	end
end

function go()
	if i_20 then t_20 = time_20 + 10800 end
	if i_10 then t_10 = time_10 + 10800 end
	t_2 = time_2 + 10800
	dt_20 = os.date("!*t", t_20)
	dt_10 = os.date("!*t", t_10)
	dt_2 = os.date("!*t", t_2)
	bug()
end

function kd_clear()
	time_20 = 0
	time_10 = 0
	time_2 = 0
	sum = 1
	sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFA07A}Значения успешно очищены.", main_color)
end

function kd_check()
	go()
	sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Установленные значения: ", main_color)
	sampAddChatMessage("-----------------------------------------------", 0xb88fff)
	if time_20 == 0 then
		sampAddChatMessage(" Начало стрелы: {FA8072}не установлено.", main_color)
	else
		sampAddChatMessage(" Начало стрелы:   {00FF7F}" .. dt_20.hour .. ":" .. dt_20.min .. ":" .. dt_20.sec, main_color)
	end
	if time_10 == 0 then
		sampAddChatMessage(" 10 минут:            {FA8072}не установлено.", main_color)
	else
		sampAddChatMessage(" 10 минут:              {00FF7F}" .. dt_10.hour .. ":" .. dt_10.min .. ":" .. dt_10.sec, main_color)
	end
	if time_2 == 0 then
		sampAddChatMessage(" 2 минуты:           {FA8072}не установлено.", main_color)
	else
		sampAddChatMessage(" 2 минуты:              {00FF7F}" .. dt_2.hour .. ":" .. dt_2.min .. ":" .. dt_2.sec, main_color)
	end
	sampAddChatMessage("-----------------------------------------------", 0xb88fff)
end

function kd_help()
	sampAddChatMessage("{b88fff}[KD by_yanestyl] {FFFFFF}Список команд скрипта:", main_color)
	sampAddChatMessage(" {98FB98}/kd_help{FFFFFF} - список команд.", main_color)
	sampAddChatMessage(" {98FB98}/kd_add{AFEEEE} [20/10/2] XX:MM:SS {FFFFFF}- добавление времени начала,10 и 2 минут.", main_color)
	sampAddChatMessage(" {98FB98}/kd_clear{FFFFFF} - очистить значения.", main_color)
	sampAddChatMessage(" {98FB98}/kd_check{FFFFFF} - узнать установленные значения.", main_color)
end

function bug()
	local t1 = time_2 - time_10
	local t2 = time_10 - time_20
	
	if t1 > 1500 and i_10 then
		time_10 = time_10 + 86400
	end
	if t2 > 1500 and i_20 then
		time_20 = time_20 + 86400
	end
end

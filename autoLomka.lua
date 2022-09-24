script_name('lomka')
script_author('yanestyl')
script_version("27/11/2021")

require "lib.moonloader"
local sampev = require "lib.samp.events"

local enable = false
local staj = 0
local nark = -1
local nark_numer = -1
local ostatok
local ostatok_number = 15
local go_check = true
local buy = 0
local go_buy = false

local switch = {
	[1] = function()	-- usedrugs 3
		sampSendChat('/usedrugs 3')

	end,
	[2] = function()	-- usedrugs 6
		sampSendChat('/usedrugs 6')
	end,
	[3] = function()	-- usedrugs 9
		sampSendChat('/usedrugs 9')
	end,
	[4] = function()	-- usedrugs 12
		sampSendChat('/usedrugs 12')
	end,
	[5] = function()	-- usedrugs 15
		sampAddChatMessage('{ffc0cb}[lomka by yanestyl]{b88fff} is full',-1)
		enable = false
	end
}

function main()
if not isSampfuncsLoaded() or not isSampLoaded() then return end
while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand('lomka', cmd_enable)
	
	while true do
		wait(700)
		if enable then
			if go_buy then
				buy = 150 - ostatok_number
				sampSendChat('/get drugs ' .. buy)
			end
			if go_check then 
				check()
				if nark_numer < 2000 then staj = 1 
				elseif nark_numer < 3000 then staj = 2
				elseif nark_numer < 4000 then staj = 3
				elseif nark_numer < 5001 then staj = 4
				elseif nark_numer > 5000 then staj = 5 end
				go_check = false
			end
			use()
		end
	end
end

function cmd_enable()
	enable = not enable
	if enable then
		sampAddChatMessage('{ffc0cb}[lomka by yanestyl]{cccccc} is starting', -1)
	else
		sampAddChatMessage('{ffc0cb}[lomka by yanestyl]{cccccc}is finished',-1)
	end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	if title:find('Статистика персонажа') then
		nark = text:match('[наркомана]+%s+(%d+)%s+[Усталость]+')
		nark_numer = tonumber(nark)
	end
end

function sampev.onServerMessage(color, message)
	if enable then
		if string.find(message, " Остаток: (%d+)") then
			ostatok = string.match(message, ' Остаток: (%d+)')
			ostatok_number = tonumber(ostatok)
		end
		if string.find(message, 'Недостаточно наркотиков') then
			go_buy = true
		end
		if string.find(message, ' Вы купили') then
			go_check = true
			go_buy = false
		end
		if string.find(message, ' Недостаточно денег для покупки') then 
			enable = false
			sampAddChatMessage('{ffc0cb}[lomka by yanestyl]{cccccc}finished',-1)
		end
	end
end

function check()
	sampSendChat('/stats')
	wait(300)
	sampCloseCurrentDialogWithButton(0)
end

function use()
	local func = switch[staj]
	if(func) then
		func()
	else
		sampAddChatMessage('error',-1)
	end	
end

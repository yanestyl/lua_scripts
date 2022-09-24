script_name('for tsupik')
script_author('yanestyl')
script_version("04/02/2021")

require 'lib.moonloader'
local wm = require 'lib.windows.message'
local sampev = require 'lib.samp.events'
local main_color = 0xff9900
local enabled   = false

_, id = sampGetPlayerIdByCharHandle(PLAYER_PED)
local animid = sampGetPlayerAnimationId(id)

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end
	
	sampRegisterChatCommand('aap', function()
		enabled = not enabled
		sampAddChatMessage(enabled and '{19ff19}Anti' or '{ff0000}Anti disactivated', -1)
	end)
end



function onWindowMessage(msg, wparam, lparam)
	if (animid == 1070 or animid == 1069 ) and wparam == VK_C and enabled then
		consumeWindowMessage(true, true)
		sampAddChatMessage('Нажатие клавиши C не было передано игре и скриптам, так как active = true!', -1)
	end
end

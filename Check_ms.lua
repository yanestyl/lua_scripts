script_name('CHECK_MS_GHETTO')
script_author('yanestyl')
script_version("14/02/2021")

local sampev    = require 'lib.samp.events'
local enabled   = false
local b = -1
--local the_first = false 

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(100) end	
	
	sampRegisterChatCommand('cgms', function()
		enabled = not enabled
		sampAddChatMessage(enabled and '{ffc0cb}[CHECK_MS_GHETTO by yanestyl] {19ff19}јктивирован' or '{ffc0cb}[CHECK_MS_GHETTO by yanestyl] {ff0000}ƒеактивирован', -1)
	end)
end

function sampev.onServerMessage(color, text)
	if enabled then
		lua_thread.create(function()
			while enabled do
				wait(0)
				if isKeyJustPressed(191) and not sampIsChatInputActive() and not isCharInAnyCar(PLAYER_PED) and not sampIsDialogActive() then
					for i = 1, 300 do
						setVirtualKeyDown(18, true)
						wait(0)
						setVirtualKeyDown(18, false)
						wait(0)		
					end
				end
			end
		end)
		if string.find(text, "√раффити можно будет изменить через (%d+):(%d+):(%d+)") then
			local _, _, a = string.match(text, "√раффити можно будет изменить через (%d+):(%d+):(%d+)")
			if a == b then
				return false
			else
				--if the_first == true then
					sampAddChatMessage("—мотри мс ниже!", 0xedff21)
					b = a
				--end
				--the_first = true
			end
		end
		
	end
end

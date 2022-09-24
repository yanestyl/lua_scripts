script_name('gribheal')
script_author('yanestyl')
script_version("31/07/2020")

local enable = true

function main()
if not isSampfuncsLoaded() or not isSampLoaded() then return end
while not isSampAvailable() do wait(100) end

	sampRegisterChatCommand('sgr', cmd_enable)
	
	while true do
		wait(10)
		if isKeyJustPressed(66) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() and not sampIsDialogActive() then
			wait(10)
			sampSendChat("/grib eat")
			wait(250)
			sampSendChat("/grib heal")
			if enable and not isCharInAnyCar(PLAYER_PED) then
				wait(150)
				taskPlayAnim(PLAYER_PED, "camcrch_stay", "CAMERA", 4.0, false, false, true, false, 1)
			end
		end
	end
end

function cmd_enable()
	enable = not enable
	if enable then
		sampAddChatMessage('{6600ff}Сбив психохила {008000}активирован', -1)
	else
		sampAddChatMessage('{6600ff}Сбив психохила {ff0000}деактивирован', -1)
	end
end

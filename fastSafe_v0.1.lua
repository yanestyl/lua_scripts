script_name('safe')
script_author('yanestyl')
script_version("21/10/2021")

require "lib.moonloader"
local sampev = require "lib.samp.events"


local main_color = 0xFF67FF
local dialogid
local a = 0

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do wait(0) end

	
	while true do
	wait(0)
	
	

	if isKeyJustPressed(79) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
		
		sampSendChat("/safe")
		wait(300)
		open()
		wait(100)
		while a ~= 1 do
			deagle()
			wait(500)
		end
		wait(100)
		while a ~= 2 do
			shotgun()
			wait(500)
		end
		wait(100)
		while a~= 3 do
			smg()
			wait(500)
		end
		wait(100)
		while a ~= 4 do
			m4()
			wait(500)
		end
		wait(100)
		while a ~= 5 do
			rifle()
			wait(500)
		end
		wait(100)
		closedialog()
		a = 0
	end
	end
end


function sampev.onServerMessage(color, message)
	if string.find(message, " Вы взяли из сейфа патроны") then
		a = a + 1
	end
end

function sampev.onShowDialog(dialogId, style, title, button1, button2, text)
	dialogid = dialogId
end


function open()
	if dialogid == 217 then
        sampSendDialogResponse(217, 1, 0, nil)
        return false
    end
end

----------==========DEAGLE==========----------
function deagle()	
	if dialogid == 218 then
		sampSendDialogResponse(218, 1, 5, nil)
	end
		lua_thread.create(function()
			wait(300)
			sampSendDialogResponse(219, 1, 0, '14')
		end)
end
----------------------------------------------

----------==========SHOTGUN==========----------
function shotgun()	
	
	if dialogid == 218 then
		sampSendDialogResponse(218, 1, 6, nil)
	end
		lua_thread.create(function()
			wait(300)
			sampSendDialogResponse(219, 1, 0, '5')
		end)
end
-----------------------------------------------

----------===========SMG===========----------
function smg()	
	if dialogid == 218 then
        sampSendDialogResponse(218, 1, 7, nil)
    end
		lua_thread.create(function()
			wait(300)
			sampSendDialogResponse(219, 1, 0, '30')
		end)
end
----------------------------------------------

----------============M4============----------
function m4()	
	if dialogid == 218 then
		sampSendDialogResponse(218, 1, 9, nil)
    end
		lua_thread.create(function()
			wait(300)
			sampSendDialogResponse(219, 1, 0, '50')
		end)
end
-----------------------------------------------

----------==========RIFLE==========------------
function rifle()	
	if dialogid == 218 then
        sampSendDialogResponse(218, 1, 10, nil)
    end
		lua_thread.create(function()
			wait(300)
			sampSendDialogResponse(219, 1, 0, '20')
		end)
end
-----------------------------------------------

function closedialog()
    wait(250)
	sampCloseCurrentDialogWithButton(0)
	wait(250)
	sampCloseCurrentDialogWithButton(0)
end

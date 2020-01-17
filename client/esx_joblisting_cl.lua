local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local menuIsShowed				  = false
local hasAlreadyEnteredMarker     = false
local lastZone                    = nil
local isInJoblistingMarker 		  = false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)


function ShowProfessionMenu()
	ESX.UI.Menu.Open("default", GetCurrentResourceName(), "Surgery",
	{
	  title = ("Pole-emploi"),
	  align = "bottom-right",
	  elements = {
		{label = _U('choose_job'),	value = "choose"},
		{label = _U('apply'), 		value = "apply"}
	  }
	},
	function(data, menu)
	  menu.close()
  
	  if data.current.value == "choose" then
		ShowJobListingMenu()
	  elseif data.current.value == "apply" then
		openGui()
	  end
	end,
	function(data, menu)
	  menu.close()
	end)
  end


function ShowJobListingMenu(data)
	ESX.TriggerServerCallback('esx_joblisting:getJobsList', function(data)
		local elements = {}
		for i = 1, #data, 1 do
			table.insert(
				elements,
				{label = data[i].label, value = data[i].value}
			)
		end

		ESX.UI.Menu.CloseAll()

		ESX.UI.Menu.Open(
			'default', GetCurrentResourceName(), 'joblisting',
			{
				title    	= _U('job_center'),
				align 		= "bottom-right",
				elements 	= elements
			},
			function(data, menu)
				TriggerServerEvent('esx_joblisting:setJob', data.current.value)
				ESX.ShowNotification(_U('new_job'))
				menu.close()
			end,
			function(data, menu)
				menu.close()
			end
		)

	end)
end

-- MENU
function openGui()
	SendNUIMessage({openMenu = true})
	Citizen.CreateThread(function()
	  Citizen.Wait(500)
	  SetNuiFocus(true, true)
	end)
end
  
function closeGui()
	SetNuiFocus(false)
	SendNUIMessage({openMenu = false})
end
  
RegisterNUICallback('closeMenu', function(data, cb)
	closeGui()
	cb('ok')
end)
  
RegisterNUICallback('postApplication', function(data, cb)
	
	TriggerServerEvent('esx_joblisting:postApplication', data)
	
	cb('ok')
end)
-- Menu


AddEventHandler('esx_joblisting:hasExitedMarker', function(zone)
	ESX.UI.Menu.CloseAll()
end)

-- Display markers
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords = GetEntityCoords(GetPlayerPed(-1))
		for i=1, #Config.Zones, 1 do
			if(GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < Config.DrawDistance) then
				DrawMarker(Config.MarkerType, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, false, true, 2, false, false, false, false)
			end
		end
	end
end)

-- Activate menu when player is inside marker
Citizen.CreateThread(function()
	while true do
		Wait(0)
		local coords      = GetEntityCoords(GetPlayerPed(-1))
		isInJoblistingMarker  = false
		local currentZone = nil
		for i=1, #Config.Zones, 1 do
			if GetDistanceBetweenCoords(coords, Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z, true) < 2 then
				isInJoblistingMarker  = true
				SetTextComponentFormat('STRING')
            	AddTextComponentString(_U('access_job_center'))
            	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
			end
		end
		if isInJoblistingMarker and not hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = true
		end
		if not isInJoblistingMarker and hasAlreadyEnteredMarker then
			hasAlreadyEnteredMarker = false
			TriggerEvent('esx_joblisting:hasExitedMarker')
		end
	end
end)

-- Create blips
Citizen.CreateThread(function()
	for i=1, #Config.Zones, 1 do
		local blip = AddBlipForCoord(Config.Zones[i].x, Config.Zones[i].y, Config.Zones[i].z)
		SetBlipSprite (blip, 133)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 1.2)
		SetBlipColour (blip, 27)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(_U('job_center'))
		EndTextCommandSetBlipName(blip)
	end
end)

-- Menu Controls
Citizen.CreateThread(function()
	while true do
		Wait(0)
		if IsControlJustReleased(0, Keys['E']) and GetLastInputMethod(2) and isInJoblistingMarker and not menuIsShowed then
			ShowProfessionMenu()
		end
	end
end)

QBCore = exports['qb-core']:GetCoreObject()

local countdownActive = false
local Renting = false
local tabletDict = "amb@code_human_in_bus_passenger_idles@female@tablet@base"
local tabletAnim = "base"
local tabletProp = `prop_cs_tablet`
local tabletBone = 60309
local tabletOffset = vector3(0.03, 0.002, -0.0)
local tabletRot = vector3(10.0, 160.0, 0.0)

Citizen.CreateThread(function()
    RentalShop = AddBlipForCoord(Config.PedLocation)
    SetBlipSprite (RentalShop, 523)
    SetBlipDisplay(RentalShop, 4)
    SetBlipScale(RentalShop, 0.9)
    SetBlipAsShortRange(RentalShop, false)
    SetBlipColour(RentalShop, 1)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Vehicle Rentals")
    EndTextCommandSetBlipName(RentalShop)
end)

RegisterNUICallback('rentvehicle', function(data, cb)
    cb(true)
    TriggerEvent("qb-rentals:client:rent", data.vehicleType, data.vehiclePrice)
end)

local function loadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(5)
    end
end

  Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(pos - vector3(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z))
			
			if dist < 60 and not pedspawned then
				TriggerEvent('qb-rentals:client:spawnped', Config.PedLocation)
				pedspawned = true
			end
			if dist >= 60 then
				pedspawned = false
                DeletePed(entity)
			end
		end
end)

function StartRental(rentalTime, veh)
  if countdownActive then
    return
  end

  countdownActive = true

  remainingTime = tonumber(rentalTime) * 60

  while remainingTime > 0 do
    Citizen.Wait(1000)
    remainingTime = remainingTime - 1

    exports['qb-core']:DrawText('Time Remaning: ' .. remainingTime .. ' seconds', 'right')
end

  QBCore.Functions.DeleteVehicle(veh)
  QBCore.Functions.Notify(Config.Notify.timeout)
  StopRentalCountdown()
end

function StopRentalCountdown()
  Renting = false
  remainingTime = 0
  countdownActive = false
  exports['qb-core']:HideText()
end

RegisterNetEvent("qb-rentals:client:menu", function()
    exports['qb-menu']:openMenu({
    {
        isMenuHeader = true,
        header = 'Rentals Menu'
    },
    {
        header = 'Rent Vehicle',
        txt = "Rent a vehicle",
        icon = "fas fa-car",
        params = {
            event = 'qb-rentals:ui:client:open'
        }
    },
    {
        header = 'Return Vehicle',
        txt = "Return the rental vehicle",
        icon = "fas fa-check",
        params = {
            event = 'qb-rentals:client:returnvehicle'
        }
    },
    {
      header = "Close Menu",
      icon = "fas fa-left-long",
      params = {
      event = "qb-menu:client:closeMenu",
      },
  },
  })
end)

RegisterNetEvent("qb-rentals:client:returnvehicle", function()
    local veh = GetPlayersLastVehicle(PlayerPedId())
    if Renting then

        if veh == rentVehicle then

            distance = #(GetEntityCoords(PlayerPedId()) - GetEntityCoords(veh))
              if distance <= 5 then

            rentVehicle = 0
            Renting = false
            QBCore.Functions.DeleteVehicle(veh)
            StopRentalCountdown()
            QBCore.Functions.Notify(Config.Notify.returned)

              else
                QBCore.Functions.Notify(Config.Notify.tofar)
              end
        else
            QBCore.Functions.Notify(Config.Notify.wrongvehicle)
        end
    else
        QBCore.Functions.Notify(Config.Notify.notrenting)
    end
end)

RegisterNetEvent("qb-rentals:client:spawnped", function()
    local model = `a_m_y_business_02`
  
    RequestModel(model)
    while not HasModelLoaded(model) do
      Wait(0)
    end
  
    pedspawned = true
    entity = CreatePed(5, model, Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z - 1, Config.PedLocation.w, false, false)
    FreezeEntityPosition(entity, true)
    SetBlockingOfNonTemporaryEvents(entity, true)
    SetPedArmour(entity, 1000000)
    SetEntityHealth(entity, 1000000)
    loadAnimDict("amb@world_human_cop_idles@male@idle_b") 
    TaskPlayAnim(entity, "amb@world_human_cop_idles@male@idle_b", "idle_e", 8.0, 1.0, -1, 17, 0, 0, 0, 0)
    exports['qb-target']:AddTargetEntity(entity, {
      options = {
        {
          type = "client",
          event = "qb-rentals:client:menu",
          icon = 'fas fa-square-minus',
          label = 'Open Catalogue',
          canInteract = function(entity, distance, data)
            if IsPedAPlayer(entity) then return false end
            return true
          end,
        }
      },
      distance = 1.5,
    })
  end)

local function doAnimation()
    if not isOpen then return end
    -- Animation
    RequestAnimDict(tabletDict)
    while not HasAnimDictLoaded(tabletDict) do Citizen.Wait(100) end
    -- Model
    RequestModel(tabletProp)
    while not HasModelLoaded(tabletProp) do Citizen.Wait(100) end

    local plyPed = PlayerPedId()
    local tabletObj = CreateObject(tabletProp, 0.0, 0.0, 0.0, true, true, false)
    local tabletBoneIndex = GetPedBoneIndex(plyPed, tabletBone)

    AttachEntityToEntity(tabletObj, plyPed, tabletBoneIndex, tabletOffset.x, tabletOffset.y, tabletOffset.z, tabletRot.x, tabletRot.y, tabletRot.z, true, false, false, false, 2, true)
    SetModelAsNoLongerNeeded(tabletProp)

    CreateThread(function()
        while isOpen do
            Wait(0)
            if not IsEntityPlayingAnim(plyPed, tabletDict, tabletAnim, 3) then
                TaskPlayAnim(plyPed, tabletDict, tabletAnim, 3.0, 3.0, -1, 49, 0, 0, 0, 0)
            end
        end

        for k, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(PlayerPedId(), v) then
                SetEntityAsMissionEntity(v, true, true)
                DeleteObject(v)
                DeleteEntity(v)
                ClearPedSecondaryTask(plyPed)
            end
        end
    end)
end

local function noMoney(enable)
SendNUIMessage({
    type = 'show',
    enable = enable,
    nomoney = true,
})
end

local function EnableGUI(enable)
    SetNuiFocus(enable, enable)
    SendNUIMessage({
        type = 'show',
        enable = enable,
        nomoney = false,
        items = Config.Vehicles,
    })
    isOpen = enable
end

RegisterNetEvent("qb-rentals:client:rent", function (vehicle, price)
    if Renting then
        EnableGUI(false)
        QBCore.Functions.Notify(Config.Notify.alreadyrenting)
    else
    TriggerEvent("qb-rentals:client:rentvehicle", price, vehicle)
    end
end)

RegisterNUICallback('escape', function(data, cb)
    EnableGUI(false)
    cb(true)
end)

RegisterNUICallback('updateUI', function(data, cb)
    SetTimeout(50, function()
        SendNUIMessage({ type = 'updateUI', content = data.content })
        cb('ok')
    end)
end)

RegisterNetEvent('qb-rentals:ui:client:open', function()
    EnableGUI(true)
    doAnimation()
end)

RegisterNetEvent('qb-rentals:nomoney', function()
    noMoney(true)
end)

RegisterNetEvent('qb-rentals:closenui', function()
    EnableGUI(false)
end)

RegisterNetEvent('qb-rentals:client:rentvehicle', function(price, vehicle)
    TriggerEvent("qb-rentals:closenui")
    local rentalTime = exports['qb-input']:ShowInput({
        header = "Choose Renting Time",
        submitText = "Submit",
        inputs = {
            {
                type = "select",
                name = "time",
                text = "",
                options = {
                    { value = 1, text = "1 Minute" },
                    { value = 5, text = "5 Minutes"},
                    { value = 10, text = "10 Minutes" },
                    { value = 15, text = "15 Minutes" },
                    { value = 30, text = "30 Minutes" },
                    { value = 60, text = "60 Minutes" },
                },
            }
        }
    })
    TriggerServerEvent("qb-rentals:server:rent", price, vehicle, rentalTime.time)
end)

RegisterNetEvent('qb-rentals:client:rentvehiclespawn', function(vehicle, time)
    Renting = true
    QBCore.Functions.Notify(Config.Notify.rented)
    QBCore.Functions.TriggerCallback('QBCore:Server:SpawnVehicle', function(netId)
        local veh = NetToVeh(netId)
        -- TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        exports['LegacyFuel']:SetFuel(veh, 100)
        SetVehicleNumberPlateText(veh, "Rentals")
        SetEntityHeading(veh, Config.VehicleLocation.w)
        SetVehicleDirtLevel(veh, 0.1)
        SetEntityAsMissionEntity(veh, true, true)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        TriggerServerEvent("qb-vehicletuning:server:SaveVehicleProps", QBCore.Functions.GetVehicleProperties(veh))
        rentVehicle = veh
        StartRental(time, veh)
    end, vehicle, Config.VehicleLocation, false)
end)
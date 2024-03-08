local PlayerData = {}
local ESX = exports["es_extended"]:getSharedObject()

local NPCD = nil
local NPCF = nil
local oldped = nil
local NWplate = 0000
local currando = false
local vendiendo = false
local lh = 5.0
local lp = 0.0
local forceExit = false
local cerca = true
local tiempo = 1000
local oks = false
local mdfyng = false
local tiempo6 = 1000
local tiempo2 = 1000
local ok = true
local fst = true
local forceExit2 = false
local tcam = 200
local currandoN = false
local NPCD = nil
local NPCF = nil
local NPCprop_name = nil

Citizen.CreateThread(function()
    --print('Foodtruck Loaded')
    while true do
        Citizen.Wait(tiempo)
        tiempo = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local vehicles = ESX.Game.GetVehiclesInArea(playerCoords, 1.0)

        if #vehicles > 0 then
            for k, v in ipairs(vehicles) do
                local posi = GetEntityCoords(playerPed)
                local Vposi = GetEntityCoords(v)
                local distancei = GetDistanceBetweenCoords(posi.x, posi.y, posi.z, Vposi.x, Vposi.y, Vposi.z, true)

                if (GetDisplayNameFromVehicleModel(GetEntityModel(v)) == "TACO" or GetDisplayNameFromVehicleModel(GetEntityModel(v)) == "TACO2") and distancei < 6 and ESX.Math.Trim(GetVehicleNumberPlateText(v)) == NWplate then
                    vehicle = v
                end
            end
        end

        local ped = GetPlayerPed(-1)
        local pos = GetEntityCoords(ped)
        local playerVeh = GetVehiclePedIsIn(ped, false)
        local Vpos = GetEntityCoords(vehicle)
        local rear = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "platelight"))
        local front = GetWorldPositionOfEntityBone(vehicle, GetEntityBoneIndexByName(vehicle, "bonnet"))
        local distanceR = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, rear, true)
        local distanceF = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, front, true)
        local distance = GetDistanceBetweenCoords(pos.x, pos.y, pos.z, Vpos.x, Vpos.y, Vpos.z, true)

        if ((GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) == "TACO" or GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) == "TACO2") and distance < 6 and ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)) == NWplate) then
            if cerca and distanceR < 2 and distanceF > 6 then
                cerca = false
                FoodtruckHelpMessage(FoodTruckMenuKey)
            end
            tiempo = 400

            if vendiendo then 
                if IsControlPressed(1, Config.EnterExitKey) then 
                    forceExit = true
                    forceExit2 = true
                    NoNPC = false
                    DeleteCamExit()
                    local coordsi = GetOffsetFromEntityInWorldCoords(vehicle, 0.0, -6.0, 0.0)
                    Citizen.Wait(200)
                    SetVehicleDoorShut(vehicle, 5, false)
                    Citizen.Wait(1000)
                    SetVehicleDoorShut(vehicle, 5, false)
                    SetVehicleDoorOpen(vehicle, 2, false, false)
                    Citizen.Wait(1000)
                    SetVehicleDoorShut(vehicle, 5, false)
                    SetVehicleDoorOpen(vehicle, 3, false, false)
                    Citizen.Wait(1000)
                    TaskStartScenarioInPlace(ped, 'WORLD_HUMAN_AA_SMOKE', 0, false)
                    ClearPedTasks(ped)
                    Citizen.Wait(200)
                    SetEntityHeading(ped, GetEntityHeading(vehicle))
                    ESX.Game.Teleport(ped, coordsi)
                    SetVehicleOnGroundProperly(ped)
                    Citizen.Wait(100)
                    SetEntityHeading(ped, GetEntityHeading(vehicle))
                    vendiendo = false
                    FoodtruckHelpMessage(FoodTruckMenuKey)
                    Citizen.Wait(1000)
                    SetVehicleDoorShut(vehicle, 5, false, false)
                    SetVehicleDoorShut(vehicle, 2, false, false)
                    Citizen.Wait(1000)
                    SetVehicleDoorShut(vehicle, 5, false)
                    SetVehicleDoorShut(vehicle, 3, false, false)
                    SetVehicleDoorsLocked(vehicle, 1)
                    Citizen.Wait(1000)
                    local vehPos    = GetEntityCoords(vehicle)
                    local vehprops = ESX.Game.GetVehicleProperties(vehicle)
                    local vehHead   = GetEntityHeading(vehicle)
                    local engHealth = GetVehicleEngineHealth(vehicle)
                    local bdyHealth = GetVehicleBodyHealth(vehicle)
                    local tnkHealth = GetVehiclePetrolTankHealth(vehicle)
                    local oilLevel = GetVehicleOilLevel(vehicle)
                    local dirti = GetVehicleDirtLevel(vehicle)
                    local liv = GetVehicleLivery(vehicle)
                    SetVehicleFixed(vehicle, false)
                    Citizen.Wait(1000)
                    SetVehicleEngineHealth(vehicle, engHealth)
                    SetVehicleBodyHealth(vehicle, bdyHealth)
                    SetVehiclePetrolTankHealth(vehicle, tnkHealth)
                    SetVehicleOilLevel(vehicle, oilLevel)
                    SetVehicleDirtLevel(vehicle, dirti)
                    SetVehicleDoorShut(vehicle, 5, false, false) 
                end
            else
                forceExit = false
                if IsControlPressed(1, Config.EnterExitKey) and distanceR < 2 and distanceF > 6 then
                    local vehPos    = GetEntityCoords(vehicle)
                    local vehprops = ESX.Game.GetVehicleProperties(vehicle)
                    local vehHead   = GetEntityHeading(vehicle)
                    local engHealth = GetVehicleEngineHealth(vehicle)
                    local bdyHealth = GetVehicleBodyHealth(vehicle)
                    local tnkHealth = GetVehiclePetrolTankHealth(vehicle)
                    local oilLevel = GetVehicleOilLevel(vehicle)
                    local dirti = GetVehicleDirtLevel(vehicle)
                    local liv = GetVehicleLivery(vehicle)
                    SetVehicleFixed(vehicle, false)
                    Citizen.Wait(200)
                    SetVehicleDoorOpen(vehicle, 2, false, false)
                    Citizen.Wait(1000)
                    SetVehicleDoorOpen(vehicle, 3, false, false)
                    Citizen.Wait(1000)
                    AttachEntityToEntity(ped, vehicle, 19, 1.1, -3.2, 0.6, 0.0, 0.0, -90.0, false, false, false, false, 20, true)
                    pangle = GetEntityHeading(ped) + 90   
                    vendiendo = true
                    SetVehicleDoorShut(vehicle, 2, false, false)
                    Citizen.Wait(1000)
                    SetVehicleDoorShut(vehicle, 3, false, false)
                    Citizen.Wait(1000)
                    SetVehicleDoorOpen(vehicle, 5, false, false)
                    SetVehicleEngineHealth(vehicle, engHealth)
                    SetVehicleBodyHealth(vehicle, bdyHealth)
                    SetVehiclePetrolTankHealth(vehicle, tnkHealth)
                    SetVehicleOilLevel(vehicle, oilLevel)
                    SetVehicleDirtLevel(vehicle, dirti)
                end
            end
        else
            if not cerca then
                BeginTextCommandDisplayHelp("THREESTRINGS")
                AddTextComponentSubstringPlayerName("")
                AddTextComponentSubstringPlayerName("")
                AddTextComponentSubstringPlayerName("")
                EndTextCommandDisplayHelp(0, false, true, 1)
            end
            cerca = true
        end
    end
end)

function GetRandomWalkingNPC()
    local search = {}
    local peds = ESX.Game.GetPeds()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)

    -- Recherche des piétons à proximité du joueur
    for i = 1, #peds do
        local coordsP = GetEntityCoords(peds[i])
        local distanceL = GetDistanceBetweenCoords(coords, coordsP, true)

        if IsPedHuman(peds[i]) and not IsPedInAnyVehicle(peds[i]) and not IsPedAPlayer(peds[i]) and distanceL <= NPCSearchDistance and peds[i] ~= OldPed and not IsPedDeadOrDying(peds[i], true) then
            table.insert(search, peds[i])
        end
    end

    -- Si aucun piéton trouvé à proximité, recherche dans un rayon plus large
    if #search == 0 then
        for i = 1, 250 do
            local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)
            local coordsP = GetEntityCoords(ped)
            local distanceL = GetDistanceBetweenCoords(coords, coordsP, true)

            if DoesEntityExist(ped) and IsPedHuman(ped) and not IsPedInAnyVehicle(ped) and not IsPedAPlayer(ped) and distanceL <= NPCSearchDistance and ped ~= OldPed and not IsPedDeadOrDying(ped, true) then
                table.insert(search, ped)
            end
        end
    end

    -- Retourne un piéton aléatoire trouvé
    if #search > 0 then
        return search[math.random(1, #search)]
    end
end

msg11 = false
stp = true
j, k, l = 0, 0, 0
textito = false
tiempo45 = 1000
pedenc = false
fin = false
pedenc2 = false
NoNPC = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(tiempo45)
        tiempo45 = 1000
        
        if currando then
            tiempo45 = 500
            local playerPed = PlayerPedId()
            
            if CurrentCustomer == nil then
                if forceExit or forceExit2 then
                    forceExit2 = false
                    forceExit = false
                    currando = false
                    NoNPC = false
                end
                
                Citizen.Wait(math.random(MinNPCWaitTime, MAxNPCWaitTime))
                NoNPC = true
                
                if currando then
                    while NoNPC do
                        Citizen.Wait(math.random(500, 2000))
                        local location = GetEntityCoords(playerPed)
                        CurrentCustomer = GetRandomWalkingNPC()
                        
                        if GetPedMaxHealth(CurrentCustomer) == 0 or IsEntityAMissionEntity(CurrentCustomer) or CurrentCustomer == OldPed or CurrentCustomer == nil then
                            CurrentCustomer = nil
                        else
                            NoNPC = false
                            OldPed = CurrentCustomer
                        end
                    end
                end
                
                if CurrentCustomer ~= nil and currando then
                    OldPed = CurrentCustomer
                    atascado = false
                    pedenc = true
                    CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)
                    SetBlipAsFriendly(CurrentCustomerBlip, 1)
                    SetBlipColour(CurrentCustomerBlip, 2)
                    SetBlipCategory(CurrentCustomerBlip, 3)
                    SetBlipRoute(CurrentCustomerBlip,  true)
                    SetEntityAsMissionEntity(CurrentCustomer,  true, false)
                    ClearPedTasksImmediately(CurrentCustomer)
                    SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)
                    SetPedMaxHealth(CurrentCustomer, 187)
                    FoodtruckNotification(CustomerFound)
                else
                    CurrentCustomer = nil
                end
                
                if forceExit or forceExit2 then
                    forceExit = false
                    forceExit2 = false
                    currando = false
                end
            else
                if forceExit then
                    currando = false
                    textito = false
                    wnpc = false
                    ClearPedTasks(CurrentCustomer)
                    SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)
                    ClearPedTasksImmediately(CurrentCustomer)
                    SetPedAsNoLongerNeeded(CurrentCustomer)
                    
                    if DoesBlipExist(CurrentCustomerBlip) then
                        RemoveBlip(CurrentCustomerBlip)
                    end
                    
                    if DoesBlipExist(DestinationBlip) then
                        RemoveBlip(DestinationBlip)
                    end
                    
                    ClearPedTasksImmediately(CurrentCustomer)
                    SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                    
                    CurrentCustomer           = nil
                    CurrentCustomerBlip       = nil
                    DestinationBlip           = nil
                    IsNearCustomer            = false
                    CustomerIsEnteringVehicle = false
                    TargetCoords              = nil
                    fin = false
                    currando = false
                    currandoN = false
                    forceExit = false
                    forceExit2 = false
                end
                
                if forceExit2 then 
                    currando = false
                    textito = false
                    wnpc = false
                    ClearPedTasksImmediately(CurrentCustomer)
                    SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)
                    SetEntityAsMissionEntity(CurrentCustomer)
                    SetPedAsNoLongerNeeded(CurrentCustomer)
                    
                    if DoesBlipExist(CurrentCustomerBlip) then
                        RemoveBlip(CurrentCustomerBlip)
                    end
                    
                    if DoesBlipExist(DestinationBlip) then
                        RemoveBlip(DestinationBlip)
                    end
                    
                    ClearPedTasks(CurrentCustomer)
                    SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                    
                    CurrentCustomer           = nil
                    CurrentCustomerBlip       = nil
                    DestinationBlip           = nil
                    IsNearCustomer            = false
                    CustomerIsEnteringVehicle = false
                    TargetCoords              = nil
                    fin = false
                    currando = false
                    currandoN = false
                    forceExit = false
                    forceExit2 = false 
                end
                
                if IsPedFatallyInjured(CurrentCustomer) and CurrentCustomer ~= nil or atascado then
                    atascado = false
                    FoodtruckNotification(NpcStuckOrDeadMessage)
                    
                    if DoesBlipExist(CurrentCustomerBlip) then
                        RemoveBlip(CurrentCustomerBlip)
                    end
                    
                    if DoesBlipExist(DestinationBlip) then
                        RemoveBlip(DestinationBlip)
                    end
                    
                    SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                    DeleteEntity(CurrentCustomer)
                    
                    CurrentCustomer           = nil
                    CurrentCustomerBlip       = nil
                    DestinationBlip           = nil
                    IsNearCustomer            = false
                    CustomerIsEnteringVehicle = false
                    CustomerEnteredVehicle    = false
                    TargetCoords              = nil
                    textito = false
                    wnpc = false
                end
                
                local coordsi    = GetEntityCoords(CurrentCustomer)    
                j,k,l   = table.unpack(coordsi)
                local playerPed = PlayerPedId()
                local coords    = GetEntityCoords(playerPed)
                local forward   = GetEntityForwardVector(playerPed)
                local x, y, z   = table.unpack(coords + forward * 5.0)
                local vehicle          = GetVehiclePedIsIn(playerPed,  false)
                local playerCoords     = GetEntityCoords(playerPed)
                local customerCoords   = GetEntityCoords(CurrentCustomer)
                local customerDistance = GetDistanceBetweenCoords(x, y, z + 1.0,  customerCoords.x,  customerCoords.y,  customerCoords.z)
                
                if pedenc then
                    TaskGoStraightToCoord(CurrentCustomer, x, y, z + 5.0,  1.0,  -1,  180.0,  0.0)
                    SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                    stp = true
                end
                
                Citizen.CreateThread(function()
                    if GetEntitySpeed(CurrentCustomer) <= 0.3 and stp and pedenc then
                        Citizen.Wait(2000)
                    else
                        stp = false
                    end
                    
                    if GetEntitySpeed(CurrentCustomer) <= 0.3 and pedenc then
                        Citizen.Wait(2000)
                    else
                        stp = false
                    end
                    
                    if GetEntitySpeed(CurrentCustomer) <= 0.3 and pedenc then
                        Citizen.Wait(2000)
                    else
                        stp = false
                    end

                    if GetEntitySpeed(CurrentCustomer) <= 0.3 and pedenc then
                        atascado = true
                    else
                        stp = false
                    end
                end)

                if customerDistance <= 1 and pedenc then
                    pedenc = false
                    pedenc2 = true
                    ClearPedTasks(CurrentCustomer)
                    SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)
                    SetEntityAsMissionEntity(CurrentCustomer)
                    SetPedAsNoLongerNeeded(CurrentCustomer)
                    Citizen.Wait(1000)
                    SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                end
                
                if pedenc2 then
                    local x, y, z   = table.unpack(coords + forward * 2.0)
                    local cd1 = GetDistanceBetweenCoords(x, y, z,  customerCoords.x,  customerCoords.y,  customerCoords.z)
                    TaskGoStraightToCoord(CurrentCustomer, x, y, z,  1.0,  -1,  180.0,  0.0)
                    tskng = true
                    
                    if cd1 <= 2 then
                        pedenc2 = false
                        wnpc = true
                        local standTime = GetRandomIntInRange(60000,  90000)
                        TaskTurnPedToFaceCoord(CurrentCustomer, coords, -1)
                        Citizen.Wait(600)
                        TaskStandStill(CurrentCustomer, standTime)
                        StartNpcTask()
                        textito = true
                        msg11 = true
                    end
                end
                
                if fin then
                    local prop_name = NPCprop_name or 'prop_cs_burger_01'
                    local prop_name2 = NPCDprop_name or 'prop_cs_burger_01'
                    IsAnimated = true
                    
                    Citizen.CreateThread(function()
                        local playerPed = CurrentCustomer
                        local x,y,z = table.unpack(GetEntityCoords(playerPed))
                        local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
                        local prop2 = CreateObject(GetHashKey(prop_name2), x, y, z + 0.2, true, true, true)
                        local boneIndex = GetPedBoneIndex(playerPed, 18905)
                        local boneIndex2 = GetPedBoneIndex(playerPed, 57005)
                        
                        AttachEntityToEntity(prop, playerPed, boneIndex, 0.11, 0.045, 0.02, 10.0, 175.0, 0.0, true, true, false, true, 1, true)
                        AttachEntityToEntity(prop2, playerPed, boneIndex2, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
                        
                        ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
                            TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
                            textito = false
                            Citizen.Wait(1500)
                            textito = true
                            Citizen.Wait(500)
                            msg11 = false
                            Citizen.Wait(1000)
                            IsAnimated = false
                            ClearPedSecondaryTask(playerPed)
                            Citizen.Wait(100)
                            textito = false
                            Citizen.Wait(8000)
                            DeleteObject(prop)
                            DeleteObject(prop2)
                        end)
                    end)
                    
                    Citizen.Wait(3000)
                    ClearPedTasks(CurrentCustomer)
                    SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)
                    SetEntityAsMissionEntity(CurrentCustomer)
                    SetPedAsNoLongerNeeded(CurrentCustomer)
                    
                    if DoesBlipExist(CurrentCustomerBlip) then
                        RemoveBlip(CurrentCustomerBlip)
                    end
                    
                    if DoesBlipExist(DestinationBlip) then
                        RemoveBlip(DestinationBlip)
                    end
                    
                    ClearPedTasks(CurrentCustomer)
                    SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                    
                    CurrentCustomer           = nil
                    CurrentCustomerBlip       = nil
                    DestinationBlip           = nil
                    IsNearCustomer            = false
                    CustomerIsEnteringVehicle = false
                    TargetCoords              = nil
                    fin = false
                end
            end
        else
            if DoesBlipExist(DestinationBlip) then
                textito = false
                wnpc = false
                ClearPedTasks(CurrentCustomer)
                SetBlockingOfNonTemporaryEvents(CurrentCustomer, 1)
                SetEntityAsMissionEntity(CurrentCustomer)
                SetPedAsNoLongerNeeded(CurrentCustomer)
                
                if DoesBlipExist(CurrentCustomerBlip) then
                    RemoveBlip(CurrentCustomerBlip)
                end
                
                if DoesBlipExist(DestinationBlip) then
                    RemoveBlip(DestinationBlip)
                end
                
                ClearPedTasks(CurrentCustomer)
                SetEntityAsMissionEntity(CurrentCustomer,  false, true)
                
                CurrentCustomer           = nil
                CurrentCustomerBlip       = nil
                DestinationBlip           = nil
                IsNearCustomer            = false
                CustomerIsEnteringVehicle = false
                TargetCoords              = nil
                fin = false
            end
        end
    end
end)

foodnpc = nil
drinknpc = nil

function Cooknpc(prop, value)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false) -- Récupère le véhicule dans lequel le joueur se trouve
    local playerPed = GetPlayerPed(-1) -- Récupère le joueur
    local vehiclePosition = GetEntityCoords(vehicle) -- Récupère la position du véhicule
    local playerPosition = GetEntityCoords(playerPed) -- Récupère la position du joueur
    local distance = #(vehiclePosition - playerPosition) -- Calcule la distance entre le joueur et le véhicule

    if GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) == "TACO" and distance < 6 then
        TaskStartScenarioInPlace(GetPlayerPed(-1), 'PROP_HUMAN_BBQ', 0, false)
        Wait(5000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        DetachEntity(ped, false, true)
        AttachEntityToEntity(GetPlayerPed(-1), vehicle, 19, 1.1, -3.2, 0.6, 0.0, 0.0, -90.0, false, false, false, false, 20, true)
        Wait(500)
        foodnpc = value
        TriggerEvent('Rufi:spawnObject', prop)
        ok = true
    end
end

function CookDnpc(prop, value)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false) -- Récupère le véhicule dans lequel le joueur se trouve
    local playerPed = GetPlayerPed(-1) -- Récupère le joueur
    local vehiclePosition = GetEntityCoords(vehicle) -- Récupère la position du véhicule
    local playerPosition = GetEntityCoords(playerPed) -- Récupère la position du joueur
    local distance = #(vehiclePosition - playerPosition) -- Calcule la distance entre le joueur et le véhicule

    if GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) == "TACO" and distance < 6 then
        TaskStartScenarioInPlace(GetPlayerPed(-1), 'PROP_HUMAN_BUM_BIN', 0, false)
        Wait(3000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        DetachEntity(ped, false, true)
        AttachEntityToEntity(GetPlayerPed(-1), vehicle, 19, 1.1, -3.2, 0.6, 0.0, 0.0, -90.0, false, false, false, false, 20, true)
        Wait(500)
        drinknpc = value
        TriggerEvent('Rufi:spawnObject', prop)
        ok = true
    end
end

function Cook(prop, item)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false) -- Récupère le véhicule dans lequel le joueur se trouve
    local playerPed = GetPlayerPed(-1) -- Récupère le joueur
    local vehiclePosition = GetEntityCoords(vehicle) -- Récupère la position du véhicule
    local playerPosition = GetEntityCoords(playerPed) -- Récupère la position du joueur
    local distance = #(vehiclePosition - playerPosition) -- Calcule la distance entre le joueur et le véhicule

    -- Vérifie si le véhicule est un taco et si la distance est inférieure à 6
    if GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) == "TACO" and distance < 6 then
        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BBQ', 0, false)
        Wait(5000)
        ClearPedTasksImmediately(playerPed)
        DetachEntity(playerPed, false, true)
        AttachEntityToEntity(playerPed, vehicle, 19, 1.1, -3.2, 0.6, 0.0, 0.0, -90.0, false, false, false, false, 20, true)
        Wait(500)
        TriggerServerEvent('esx_RufiFoodTruck:GiveItem', item)
        TriggerEvent('Rufi:spawnObject', prop)
        ok = true
    end		
end

function CookD(prop, item)
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false) -- Récupère le véhicule dans lequel le joueur se trouve
    local playerPed = GetPlayerPed(-1) -- Récupère le joueur
    local vehiclePosition = GetEntityCoords(vehicle) -- Récupère la position du véhicule
    local playerPosition = GetEntityCoords(playerPed) -- Récupère la position du joueur
    local distance = #(vehiclePosition - playerPosition) -- Calcule la distance entre le joueur et le véhicule

    if GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)) == "TACO" and distance < 6 then
        TaskStartScenarioInPlace(GetPlayerPed(-1), 'PROP_HUMAN_BUM_BIN', 0, false)
        Wait(3000)
        ClearPedTasksImmediately(GetPlayerPed(-1))
        DetachEntity(ped, false, true)
        AttachEntityToEntity(GetPlayerPed(-1), vehicle, 19, 1.1, -3.2, 0.6, 0.0, 0.0, -90.0, false, false, false, false, 20, true)
        Wait(500)
        TriggerServerEvent('esx_RufiFoodTruck:GiveItem', item)
        TriggerEvent('Rufi:spawnObject', prop)
        ok = true
    end	
end

RegisterNetEvent('Rufi:spawnObject')
AddEventHandler('Rufi:spawnObject', function(prop)
    local playerPed = PlayerPedId()
    local coords    = GetEntityCoords(playerPed)
    local forward   = GetEntityForwardVector(playerPed)
    local x, y, z   = table.unpack(coords + forward * 0.6)
    local obje = nil

    ESX.Game.SpawnObject(prop, {
        x = x,
        y = y,
        z = z + 0.04
    }, function(obj)
        SetEntityNoCollisionEntity(obj, vehicle, false)
        SetEntityHeading(obj, GetEntityHeading(playerPed))
        FreezeEntityPosition(obj, true)
        obje = obj
    end)

    Wait(5000)
    NetworkRequestControlOfEntity(obje)
    SetEntityAsMissionEntity(obje, false, true)
    DeleteEntity(obje)
    ESX.Game.DeleteObject(obje)
end)

RegisterNetEvent('Esx_RufiFoodtruck:onEat')
AddEventHandler('Esx_RufiFoodtruck:onEat', function(prop_name)
    onEat(prop_name)
end)

function onEat(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'prop_cs_burger_01'
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.11, 0.045, 0.02, 10.0, 175.0, 0.0, true, true, false, true, 1, true)

            ESX.Streaming.RequestAnimDict('mp_player_inteat@burger', function()
                TaskPlayAnim(playerPed, 'mp_player_inteat@burger', 'mp_player_int_eat_burger_fp', 8.0, -8, -1, 49, 0, 0, 0, 0)
                Citizen.Wait(3000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end

RegisterNetEvent('Esx_RufiFoodtruck:onDrink')
AddEventHandler('Esx_RufiFoodtruck:onDrink', function(prop_name)
    onDrink(prop_name)
end)

function onDrink(prop_name)
    if not IsAnimated then
        prop_name = prop_name or 'ba_prop_club_water_bottle'
        IsAnimated = true

        Citizen.CreateThread(function()
            local playerPed = PlayerPedId()
            local x,y,z = table.unpack(GetEntityCoords(playerPed))
            local prop = CreateObject(GetHashKey(prop_name), x, y, z + 0.2, true, true, true)
            local boneIndex = GetPedBoneIndex(playerPed, 18905)
            AttachEntityToEntity(prop, playerPed, boneIndex, 0.12, 0.008, 0.03, 240.0, -60.0, 0.0, true, true, false, true, 1, true)
            
            ESX.Streaming.RequestAnimDict('mp_player_intdrink', function()
                TaskPlayAnim(playerPed, 'mp_player_intdrink', 'loop_bottle', 1.0, -1.0, 2000, 0, 1, true, true, true)
                Citizen.Wait(3000)
                IsAnimated = false
                ClearPedSecondaryTask(playerPed)
                DeleteObject(prop)
            end)
        end)
    end
end

local zoomOffset, camOffset, heading = true, 0.0, 90.0
ini = false

function CreateFCam()
    Citizen.CreateThread(function()
        if not DoesCamExist(cam) then
            cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
        end

        FoodtruckNotification(LoadCamMode)
        SetCamRot(cam, 0.0, 0.0, 270.0, true)
        local playerPed = PlayerPedId()
        local coords    = GetEntityCoords(playerPed)
        local angle = heading * math.pi / 180.0
        local theta = {
            x = math.cos(angle),
            y = math.sin(angle)
        }
        local pos = {
            x = coords.x + (zoom * theta.x),
            y = coords.y + (zoom * theta.y)
        }
        local angleToLook = heading - 140.0
        if angleToLook > 360 then
            angleToLook = angleToLook - 360
        elseif angleToLook < 0 then
            angleToLook = angleToLook + 360
        end
        angleToLook = angleToLook * math.pi / 180.0
        local thetaToLook = {
            x = math.cos(angleToLook),
            y = math.sin(angleToLook)
        }

        local posToLook = {
            x = coords.x + (zoom * thetaToLook.x),
            y = coords.y + (zoom * thetaToLook.y)
        }

        SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
        PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
        ini = true
        Citizen.Wait(1000)
        SetCamActive(cam, true)
        RenderScriptCams(true, true, 500, true, true)
        isCameraActive = true
        FoodtruckNotification(CamLoaded)
    end)
end

function DeleteCam()
    Citizen.CreateThread(function()
        isCameraActive = false
        SetCamActive(cam, false)
        RenderScriptCams(false, true, 500, true, true)
        cam = nil
        FoodtruckHelpMessage(Config.OptionsHelpText)
        cdone = false
    end)
end

function DeleteCamExit()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
    cdone = false
end

zoom = 10

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(tcam)
        if isCameraActive then
            CamManage()
            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)
            local angle = heading * math.pi / 180.0
            local theta = {
                x = math.cos(angle),
                y = math.sin(angle)
            }
            local pos = {
                x = coords.x + (zoom * theta.x),
                y = coords.y + (zoom * theta.y)
            }
            local angleToLook = heading - 140.0
            if angleToLook > 360 then
                angleToLook = angleToLook - 360
            elseif angleToLook < 0 then
                angleToLook = angleToLook + 360
            end
            angleToLook = angleToLook * math.pi / 180.0
            local thetaToLook = {
                x = math.cos(angleToLook),
                y = math.sin(angleToLook)
            }
            local posToLook = {
                x = coords.x + (zoom * thetaToLook.x),
                y = coords.y + (zoom * thetaToLook.y)
            }
            SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
            ini = false
            cdone = true
        else
            first = true
            Citizen.Wait(800)
        end
    end
end)
 
function CamManage()
    if first then
        first = false
        FoodtruckHelpMessage(CamControlsHelpMessage)
    end
    if IsControlPressed(0, CamLEFT) then
        pangle = pangle - 1
    elseif IsControlPressed(0, CamRIGHT) then
        pangle = pangle + 1
    end
    if IsControlPressed(0, ZoomIN) then
        zoom = zoom - 0.1
    elseif IsControlPressed(0, ZoomOUT) and zoom <= MaxCamZoomDistance then
        zoom = zoom + 0.1
    end
    if IsControlPressed(0, CamDOWN) then
        camOffset = camOffset - 0.1
    elseif IsControlPressed(0, CamUP) and camOffset <= MaxCamHeight then
        camOffset = camOffset + 0.1
    end
    if pangle > 360 then
        pangle = pangle - 360
    elseif pangle < 0 then
        pangle = pangle + 360
    end
    heading = pangle + 0.0
end

local CurrentCustomer           = nil
local CurrentCustomerBlip       = nil
local DestinationBlip           = nil
local IsNearCustomer            = false
local CustomerIsEnteringVehicle = false
local CustomerEnteredVehicle    = false
local TargetCoords              = nil
atascado = false
NPCD = nil
NPCF = nil
NPCprop_name = nil

function StartNpcTask()
    NPCF = NPCFood[math.random(#NPCFood)]
    NPCD = NPCDrink[math.random(#NPCDrink)]
end

local menuIsShowed = false
local hasAlreadyEnteredMarker = false
local isInMarker = false

function OpenBuyMenu()
    ESX.TriggerServerCallback('esx_RufiFoodTruck:CheckOwner', function(resp)
        ESX.UI.Menu.CloseAll()
        local plate = nil
        local chk = nil
        for i=1, #resp, 1 do
            chk = resp[i].chk
            NWplate = resp[i].plate
        end
        local elements = {}
        if chk then
            table.insert(elements, {label = 'Spawn le Foodtruck', value = 'tiene'})
        else
            table.insert(elements, {label = 'Acheter un Foodtruck', value = 'notiene'})
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), '---', {
            title    = 'FoodTruck menu',
            align    = 'right',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'tiene' then
                ESX.UI.Menu.CloseAll()
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--', {
                    title    = 'Which foodtruck model?',
                    align    = 'right',
                    elements = {
                        {label = 'Foodtruck 1',  value = 'f1'},
                        {label = 'Foodtruck 2', value = 'f2'}
                    }
                }, function(data, menu)
                    if data.current.value == 'f1' then
                        ESX.UI.Menu.CloseAll()
                        local playerPed = PlayerPedId()
                        ESX.Game.SpawnVehicle(GetHashKey('taco'), Spawnpos, SpawnHeading, function (vehicle)
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                            SetEntityAsMissionEntity(vehicle, true, true)
                            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                            vehicleProps.plate = NWplate
                            SetVehicleNumberPlateText(vehicle, NWplate)
                        end)
                    end
                    if data.current.value == 'f2' then
                        local playerPed = PlayerPedId()
                        ESX.Game.SpawnVehicle(GetHashKey('taco2'), Spawnpos, SpawnHeading, function (vehicle)
                            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
                            SetEntityAsMissionEntity(vehicle, true, true)
                            local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
                            vehicleProps.plate = NWplate
                            SetVehicleNumberPlateText(vehicle, NWplate)
                        end)
                    end
                end, function(data, menu)
                    menu.close()
                end)
            else
                BuyFoodtruck()
            end
        end, function(data, menu)
            menu.close()
        end)
    end)
end

function BuyFoodtruck()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--', {
        title    = ('Acheter un FoodTruck pour <span style="color:lawngreen;">%s</span>$ ?'):format(Config.FoodtruckBuyPrice),
        align    = 'right',
        elements = {
            {label = 'Oui',  value = 'yesi'},
            {label = 'Non', value = 'no'}
        }
    }, function(data, menu)
        if data.current.value == 'yesi' then
            ESX.UI.Menu.CloseAll()
            BuyFoodtruck2()
        end
        if data.current.value == 'no' then
            ESX.UI.Menu.CloseAll()
        end
    end, function(data, menu)
        menu.close()
    end)
end

function BuyFoodtruck2()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), '', {
        title    = 'Êtes-vous sûr(e) ?',
            align    = 'right',
            elements = {
                {label = 'Non',  value = 'no'},
                {label = 'Oui', value = 'yesi'}
        }
    }, function(data3, menu3)
        if data3.current.value == 'yesi' then
            ESX.UI.Menu.CloseAll()
            BuyFoodtruck3()
        end
        if data3.current.value == 'no' then
            ESX.UI.Menu.CloseAll()
        end
    end, function(data3, menu3)
        menu3.close()
    end)
end

function BuyFoodtruck3()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), '', {
        title    = 'Which payment method?',
        align    = 'right',
        elements = {
            {label = 'Espèces',  value = 'c'},
            {label = 'Banque', value = 'b'}
        }
    }, function(data3, menu3)
        if data3.current.value == 'c' then
            ESX.UI.Menu.CloseAll()
            local newPlate = GeneratePlate()
            TriggerServerEvent('esx_RufiFoodTruck:RegisterOwner', newPlate, Config.FoodtruckBuyPrice, true)
        end
        if data3.current.value == 'b' then
            ESX.UI.Menu.CloseAll()
            local newPlate = GeneratePlate()
            TriggerServerEvent('esx_RufiFoodTruck:RegisterOwner', newPlate, Config.FoodtruckBuyPrice, false)
        end
    end, function(data3, menu3)
        menu3.close()
    end)
end

local NumberCharset = {}
local Charset = {}
for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end
for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function GeneratePlate()
    local generatedPlate
    while true do
        Citizen.Wait(2)
        math.randomseed(GetGameTimer())
        if PlateUseSpace then
            generatedPlate = string.upper(GetRandomNumber(PlateNumbers) .. ' ' .. GetRandomLetter(PlateLetters))
            break
        else
            generatedPlate = string.upper(GetRandomLetter(PlateLetters) .. GetRandomNumber(PlateNumbers))
            break
        end
    end
    return generatedPlate
end

function GetRandomNumber(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
    else
        return ''
    end
end

function GetRandomLetter(length)
    Citizen.Wait(1)
    math.randomseed(GetGameTimer())
    if length > 0 then
        return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
    else
        return ''
    end
end

AddEventHandler('esx_RufiFoodtruck:hasExitedMarker', function(zone)
    ESX.UI.Menu.CloseAll()
end)

tiempo5 = 1000
Citizen.CreateThread(function()
    if AllowBlip then
        addMapBlip(BlipName, BlipCoords)
    end
    while true do
        Citizen.Wait(tiempo5)
        tiempo5 = 1000
        local coords = GetEntityCoords(PlayerPedId())
        isInMarker = false
        local distance = GetDistanceBetweenCoords(coords, BuyFoodtruckPos, true)
        if distance < Config.DrawDistance then
            tiempo5 = 0
            DrawMarker(Config.MarkerType, BuyFoodtruckPos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, Config.ZoneSize.x, Config.ZoneSize.y, Config.ZoneSize.z, Config.MarkerColor.r, Config.MarkerColor.g, Config.MarkerColor.b, 100, true, true, 2, false, false, false, false)
        end
        if distance < 2 then
            isInMarker = true
            SetTextComponentFormat('STRING')
            AddTextComponentString(BuyFoodtruckMarkerText)
            DisplayHelpTextFromStringLabel(0, 0, 1, -1)
        end
        if isInMarker and not hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = true
            tiempo5 = 0
        end
        if not isInMarker and hasAlreadyEnteredMarker then
            hasAlreadyEnteredMarker = false
            TriggerEvent('esx_RufiFoodtruck:hasExitedMarker')
        end
    end
end)

function addMapBlip(text, bcoords)
    local blip = AddBlipForCoord(bcoords)
    SetBlipSprite(blip, BlipSprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, BlipScale)
    SetBlipColour(blip, BlipColour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

tiempo6 = 1000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(tiempo6)
        tiempo6 = 1000
        local playerVeh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
        if (GetDistanceBetweenCoords(ParkCoords, GetEntityCoords(GetPlayerPed(-1))) < 20) and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetDisplayNameFromVehicleModel(GetEntityModel(playerVeh)) == "TACO"  or (GetDistanceBetweenCoords(ParkCoords, GetEntityCoords(GetPlayerPed(-1))) < 8) and IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetDisplayNameFromVehicleModel(GetEntityModel(playerVeh)) == "TACO2" then
            tiempo6 = 0
            DrawMarker(39, ParkCoords, 0, 0, 0, 0, 0, 0, 1.0, 1.0, 1.0, 255, 0, 0, 96, 1, 1, 0, 0, 0, 0, 0)
            if (GetDistanceBetweenCoords(ParkCoords, GetEntityCoords(GetPlayerPed(-1))) < 2) then
                tiempo = 0
                SetTextComponentFormat('STRING')
                AddTextComponentString(ParkText)
                DisplayHelpTextFromStringLabel(0, 0, 1, -1)
                if (IsControlJustReleased(1, Config.UseKey)) then
                    ParkOrMod()
                end
            else
                if mdfyng then
                    mdfyng = false
                    ESX.UI.Menu.CloseAll()
                end
            end
        end

        if isInMarker then
            tiempo6 = 0
        end
        if IsControlJustReleased(0, Config.UseKey) and isInMarker and not menuIsShowed then
            OpenBuyMenu()
        end
    end
end)

function ParkOrMod()
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), '---', {
        title    = 'Ranger ou modifier ?',
        align    = 'right',
        elements = {
            {label = 'Ranger',  value = 'p'},
            {label = 'Modifier ', value = 'm'}
        }
    }, function(data, menu)
        if data.current.value == 'm' then
            ESX.UI.Menu.CloseAll()
            mdfyng = true
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
            {
                title    = 'Vehicle mod menu',
                align    = 'right',
                elements = {
                    {label = 'Skin',  value = 'lv'},
                    {label = 'Extras', value = 'ex'}
                }
            }, function(data, menu)
                if data.current.value == 'lv' then
                    ESX.UI.Menu.CloseAll()
                    OpenSkinMenu()
                end
                if data.current.value == 'ex' then
                    ESX.UI.Menu.CloseAll()
                    OpenExtraMenu()
                end
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.UI.Menu.CloseAll()
            local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
            ESX.Game.DeleteVehicle(vehicle)
            Citizen.Wait(500)
            if DoesEntityExist(vehicle) then
                SetEntityAsMissionEntity(vehicle, true, true)
                DeleteVehicle(vehicle)
            end
            if DoesEntityExist(vehicle) then    
                DeleteEntity(vehicle)
            end   
        end         
    end, function(data, menu)
        menu.close()
    end) 
end

function OpenExtraMenu()
    local elements = {}
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    for id=0, 12 do
        if DoesExtraExist(vehicle, id) then
            local state = IsVehicleExtraTurnedOn(vehicle, id)
            if state then
                table.insert(elements, {
                    label = "Extra: "..('<span style="color:green;">%s</span>'):format("On"),
                    value = id,
                    state = not state
                })
            else
                table.insert(elements, {
                    label = "Extra: "..('<span style="color:red;">%s</span>'):format("Off"),
                    value = id,
                    state = not state
                })
            end
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'extra_actions', {
        title    = 'Extra menu',
        align    = 'right',
        elements = elements
    }, function(data, menu)
        SetVehicleExtra(vehicle, data.current.value, not data.current.state)
        local newData = data.current
        if data.current.state then
            newData.label = "Extra: "..('<span style="color:green;">%s</span>'):format("On")
        else
            newData.label = "Extra: "..('<span style="color:red;">%s</span>'):format("Off")
        end
        newData.state = not data.current.state
        menu.update({value = data.current.value}, newData)
        menu.refresh()
    end, function(data, menu)
        menu.close()
    end)
end

function OpenSkinMenu()
    local elements = {}
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1))
    local liveryCount = GetVehicleLiveryCount(vehicle)
    for i = 1, liveryCount do
        local state = GetVehicleLivery(vehicle) 
        local text
        if state == i then
            text = "Skin: "..i..""
        else
            text = "Skin: "..i..""
        end
        table.insert(elements, {
            label = text,
            value = i,
            state = not state
        }) 
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--', {
        title    = 'Skin menu',
        align    = 'right',
        elements = elements
    }, function(data, menu)
        SetVehicleLivery(vehicle, data.current.value, not data.current.state)
        local newData = data.current
        if data.current.state then
            newData.label = "Skin: "..data.current.value..""
        else
            newData.label = "Skin: "..data.current.value..""
        end
        newData.state = not data.current.state
        menu.update({value = data.current.value}, newData)
        menu.refresh()
    end, function(data, menu)
        menu.close()        
    end)
end

tiempo2 = 1000
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(tiempo2)
        tiempo2 = 1000
        if vendiendo then        
            tiempo2 = 1
            if fst then
                fst = false
                FoodtruckHelpMessage(Config.OptionsHelpText)
            end
            if IsControlJustPressed(0, Config.CamMenuKey) then
                CamState()
            end
            if IsControlJustReleased(0, Config.NpcJobKey) then
                if not currando then
                    FoodtruckNotification(StartNpcJob)
                    Citizen.Wait(2000)
                    FoodtruckNotification(WaitingForNpc)
                    CurrentCustomer = nil
                    currando = true
                    currandoN = true
                    forceExit2 = false
                else
                    FoodtruckNotification(NpcJobCancel)
                    forceExit2 = true
                    NoNPC = false
                end
            end
            if IsControlJustReleased(0, 177) then
                ESX.UI.Menu.CloseAll()    
            end
            if IsControlJustReleased(0, Config.FoodTruckMenuKey) then
                if ok then
                    OpenMainMenu()
                else
                    TriggerEvent('esx:showNotification', 'En cours de cuisson..')
                end
            end    
            if IsControlPressed(0, 108) or IsControlPressed(0, 109) or IsControlPressed(0, 96) or IsControlPressed(0, 97) or IsControlPressed(0, 60) or IsControlPressed(0, 61) or ini then
                tcam = 10        
            else
                tcam = 100
            end
            if isCameraActive then    
                DisableControlAction(2, 30, true)
                DisableControlAction(2, 31, true)
                DisableControlAction(2, 32, true)
                DisableControlAction(2, 33, true)
                DisableControlAction(2, 34, true)
                DisableControlAction(2, 35, true)
                DisableControlAction(0, 25, true) -- Input Aim
                DisableControlAction(0, 24, true) -- Input Attack
            end
            DisableControlAction(0, 22, true)
            DisableControlAction(2, 22, true)
            --DisableControlAction(2, 177, true)
            --DisableControlAction(0, 177, true)  -- Disable exit vehicle        
            DisableControlAction(0, 75, true)  -- Disable exit vehicle
            DisableControlAction(27, 75, true) -- Disable exit vehicle
            DisableControlAction(0, 23, true) -- Also 'enter'?
        else
            fst = true
        end    
    end
end)

-- RegisterCommand("taco", function(source, args, raw)
--   if ok then
--     OpenMainMenu()
--   else
--     TriggerEvent('esx:showNotification', 'En cours de cuisson..')
--   end 
-- end)

ok12 = true
function CamState()
  if ok12 then
    ok12 = false
    CreateFCam()
  else
    ok12 = true
    DeleteCam()
  end 
end

wnpc = false
function OpenMainMenu()
    local elements = {
		{label = "Produits", value = 'f'},
		{label = "Facturation", value = 'd'}
	  }
	  if wnpc then
		table.insert(elements,{label = "Menu NPC", value = 'n'})
	  end  

    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), '-',
      {
        title    = 'Menu',
        align    = 'right',
        elements = elements,
      },
      function(data, menu)
      if data.current.value == "f" then
        menu.close()
        npc = false
        OpenProductsMenu(npc)
      end
      if data.current.value == "d" then
        menu.close()
        OpenBillMenu()
      end
      if data.current.value == "n" then
        if wnpc then
          menu.close()
          npc = true
          OpenProductsMenu(npc)
        else
          TriggerEvent('esx:showNotification', 'Pas de citoyens')
        end
      end    
      end,
    function(data, menu)
        menu.close()
      end
    )
end

RegisterNetEvent('Esx_RufiFoodtruck:PayBill')
AddEventHandler('Esx_RufiFoodtruck:PayBill', function(amount, seller)
    PayBillMenu(amount, seller)
end)
function PayBillMenu(amount, seller)
    local elements = {
      {label = "Espèces", value = 'f'},
      {label = "Banque", value = 'd'}
    }
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
      'default', GetCurrentResourceName(), '-',
      {
        title    = 'Payer la facture de ' .. amount .. ' $',
        align    = 'right',
        elements = elements,
      },
      function(data, menu)
      if data.current.value == "f" then
        menu.close()
        TriggerServerEvent('esx_RufiFoodTruck:Pay', 'cash', amount, seller)
      end
      if data.current.value == "d" then
        menu.close()
        TriggerServerEvent('esx_RufiFoodTruck:Pay', 'bank', amount, seller)
      end
      end,
      function(data, menu)
        menu.close()
      end
    )
end

function OpenBillMenu()
    local playerPed = PlayerPedId()
    local players, nearbyPlayer = ESX.Game.GetPlayersInArea(GetEntityCoords(playerPed), 3.0)
    local foundPlayers = false
    local elements = {}
    for i = 1, #players, 1 do
        if players[i] ~= PlayerId() then
            foundPlayers = true
            table.insert(
                elements,
                {
                    label = 'ID: ' .. GetPlayerServerId(players[i]) .. '',
                    value = GetPlayerServerId(players[i]),
                    name = GetPlayerName(players[i])
                }
            )
        end
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), '--',
    {
        title    = 'Remettre la facture à',
        align    = 'right',
        elements = elements
    }, function(data, menu)
        AddTextEntry('FMMC_KEY_TIP1', 'Combien en $ ?')
        DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", '', "", "", "", 8)
        while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
            Citizen.Wait(0)
        end
        if UpdateOnscreenKeyboard() ~= 2 then
            Bamount = GetOnscreenKeyboardResult()
            Citizen.Wait(500)
        else
            Citizen.Wait(500)
        end
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), '',
        {
            title    = 'Êtes-vous sûr(e) ?',
            align    = 'right',
            elements = {
                {label = 'Non',  value = 'no'},
                {label = 'Oui', value = 'yesi'}
            }
        }, function(data3, menu3)
            if data3.current.value == 'yesi' then   
                TriggerServerEvent('esx_RufiFoodTruck:OpenBillMenu', data.current.value, Bamount)
                menu3.close()
            end
            if data3.current.value == 'no' then   
                menu3.close()
            end
        end, function(data3, menu3)
            menu3.close()
        end)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenProductsMenu(npc)
    local elements = {
        {label = "Nourritures", value = 'f'},
        {label = "Boissons", value = 'd'}
    }
    if npc then
        table.insert(elements, {label = "Vendre aux citoyens", value = 's'})
    end
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), '-',
        {
            title    = 'Menu',
            align    = 'right',
            elements = elements,
        },
        function(data, menu)
            if data.current.value == "f" then
                if npc then
                    OpenFoodMenuNPC()
                else
                    OpenFoodMenu(npc)
                end
            end
            if data.current.value == "d" then
                if npc then
                    OpenDrinksMenuNPC()
                else
                    OpenDrinksMenu()
                end
            end
            if data.current.value == "s" then
                CheckFood()
                ESX.UI.Menu.CloseAll()
            end
        end,
        function(data, menu)
            menu.close()
        end
    )
end

function OpenFoodMenu()
    local elements = Foods
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), '--',
        {
            title    = 'Nourritures',
            align    = 'right',
            elements = elements,
        },
        function(data2, menu2)
            ok = false
            menu2.close()
            Cook(data2.current.prop, data2.current.item)
        end,
        function(data2, menu2)
            menu2.close()
        end
    )
end

function OpenFoodMenuNPC()
    local elements = NPCFood
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), '--',
        {
            title    = 'Nourritures',
            align    = 'right',
            elements = elements,
        },
        function(data2, menu2)
            ok = false
            menu2.close()
            Cooknpc(data2.current.prop, data2.current.label)
        end,
        function(data2, menu2)
            menu2.close() 
        end
    )
end

function OpenDrinksMenu()
    local elements = Drinks
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), '--',
        {
            title    = 'Boissons',
            align    = 'right',
            elements = elements,
        },
        function(data3, menu3)
            menu3.close()	  
            CookD(data3.current.prop, data3.current.item)
        end,
        function(data3, menu3)
            menu3.close()
        end
    )
end

function OpenDrinksMenuNPC()
    local elements = NPCDrink
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open(
        'default', GetCurrentResourceName(), '--',
        {
            title    = 'Boissons',
            align    = 'right',
            elements = elements,
        },
        function(data3, menu3)
            ESX.UI.Menu.CloseAll()
            CookDnpc(data3.current.prop, data3.current.label)
            ESX.UI.Menu.CloseAll()
        end,
        function(data3, menu3)
            menu3.close() 
        end
    )
end

function CheckFood()
    if foodnpc ~= nil and drinknpc ~= nil then
        if foodnpc == NPCF.label and drinknpc == NPCD.label then
            NPCprop_name = NPCF.prop
            NPCDprop_name = NPCD.prop
            fin = true
            local Namount = NPCF.price + NPCD.price
            TriggerServerEvent('esx_RufiFoodTruck:NPCPay', Namount)
        elseif foodnpc == NPCF.label and drinknpc ~= NPCD.label then
            FoodtruckNotification(WrongDrink)
        elseif foodnpc ~= NPCF.label and drinknpc == NPCD.label then
            FoodtruckNotification(WrongFood)
        elseif foodnpc ~= NPCF.label and drinknpc ~= NPCD.label then
            FoodtruckNotification(WrongDrinkAndFood)
        end
    else
        FoodtruckNotification(NoDrinkOrFood)
    end
end

tmpo = 1000
Citizen.CreateThread(function()
    while true do
        if textito then
            tmpo = 50
            if msg11 then
				ShowFloatingHelpNotification('Puis-je avoir un(e) ' .. NPCF.label .. ' et un(e) ' .. NPCD.label .. ' s\'il vous plaît ?', j, k, l - 0.1)
            else
                ShowFloatingHelpNotification('Merci. Au revoir !', j, k, l - 0.1)
            end		 
        else
            tmpo = 1000
        end
        Citizen.Wait(tmpo)
    end
end)

function FoodtruckHelpMessage(msg)
    ESX.ShowHelpNotification(msg)
end

function FoodtruckNotification(msg)
    ESX.ShowNotification(msg)  
end

function ShowFloatingHelpNotification(msg, x, y, z)
    SetFloatingHelpTextStyle(2, 1, 2, -1, 3, 0)
    SetFloatingHelpTextWorldPosition(1, vector3(x, y, z + 1.0))
    AddTextEntry('esxFloatingHelpNotification', msg)
    BeginTextCommandDisplayHelp('esxFloatingHelpNotification')
    EndTextCommandDisplayHelp(2, false, false, -1)
end
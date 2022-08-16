-- Libs

local PlayerId = 0
local GetPedId = 0

Citizen.CreateThread( function()

while true do

PlayerId = PlayerPedId()
GetPedId = GetPlayerPed(-1)

Citizen.Wait(500)

end



end)
function DrawText3D(text, x, y, z, s)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)

    if s == nil then
        s = 1.0
    end

    local scale = ((1 / dist) * 2) * s
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov

    if onScreen then
        SetTextScale(0.0 * scale, 1.1 * scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end
-- CARREGAR PROP
CarregarObjeto = function(x, y, z)
    local ped = PlayerId
    local prop = "prop_box_wood01a"
    local playerPed = GetPedId
            local coords    = GetEntityCoords(playerPed)
            local forward   = GetEntityForwardVector(playerPed)
            local x, y, z   = x,y,z

            local model = GetHashKey(prop)
            RequestModel(model)
            while (not HasModelLoaded(model)) do
                Wait(1)
            end
            obj = CreateObject(model, x, y, z, true, false, true)
            PlaceObjectOnGroundProperly(obj)
            SetModelAsNoLongerNeeded(model)
            SetEntityAsMissionEntity(obj)
            SetEntityCollision(obj,false,false)
        return obj

end
-- DELETAR PROP
DeletarObjeto = function(x, y, z)
    local coord = GetOffsetFromEntityInWorldCoords(PlayerId, 0.0, 1.0, -0.1)
        local prop = "prop_box_wood01a"
        local h = GetEntityHeading(PlayerId)
        if DoesObjectOfTypeExistAtCoords(x, y, z, 0.9, GetHashKey(prop), true) then
            objeto = GetClosestObjectOfType(x, y, z, 0.9, GetHashKey(prop), false, false, false)
            Citizen.InvokeNative(0xAD738C3085FE7E11, obj, true, true)
            SetObjectAsNoLongerNeeded(Citizen.PointerValueIntInitialized(obj))
            DeleteObject(obj)
        end
end

-- Drops Positions
local positions = {}

-- Host Request New Gift
RegisterNetEvent("unity:gift:host_request_new_dropper")
AddEventHandler("unity:gift:host_request_new_dropper", function(loc_id)
    local success, position, nodeid = GetRandomVehicleNode(0.0, 0.0, 0.0, 8000.0, 0, 0, 0)
    TriggerServerEvent("b2k:gift:host_request_new_dropper_callback", loc_id, {x = position.x, y = position.y, z = position.z})
end)

-- Sync Add New Gift
RegisterNetEvent("unity:gift:new_dropper")
AddEventHandler("unity:gift:new_dropper", function(loc_id, loc_position)
    local blip = AddBlipForCoord(loc_position.x, loc_position.y, loc_position.z)
   -- local unityobj = CarregarObjeto()
    SetBlipSprite(blip, 94)
    SetBlipColour(blip, 1)
    SetBlipFlashes(blip, true)
    table.insert(positions, {id = loc_id, position = loc_position, blip = blip})
	--CarregarObjeto(loc_position.x, loc_position.y, loc_position.z)
    Wait(15000)
    SetBlipFlashes(blip, false)
    SetBlipAsShortRange(blip, true)
end)

-- Sync Remove Gift
RegisterNetEvent("unity:gift:remove_dropper")
AddEventHandler("unity:gift:remove_dropper", function(loc_id)
    for k,v in pairs(positions) do
        if v.id == loc_id then
            RemoveBlip(v.blip)
            positions[k] = nil
        end
    end
end)

local cooldown = 0
local function promptPickup(loc_id, pos)

    if cooldown > 0 then
        local _, _, _, _, _, second = GetLocalTime()
        if second % 2 == 0 then
            DrawText3D("~r~ ~w~Aguarde ".. cooldown.. "s para coletar ~u~", pos.x, pos.y, pos.z + 1)
        else
            DrawText3D("~u~ ~w~Aguarde ".. cooldown.. "s para coletar ~r~", pos.x, pos.y, pos.z + 1)
        end
    end

    if cooldown <= 0 then
        DrawText3D("Pressione ~r~E ~w~para coletar o airdrop", pos.x, pos.y, pos.z + 1)
    end

    if IsControlJustPressed(0, 38) and cooldown <= 0 then
        cooldown = 100

        local asset1 = "core"
        local asset2 = "ent_brk_banknotes"
        TriggerEvent("progress",7000,"Pegando Airdrop")
        if not HasNamedPtfxAssetLoaded(asset1) then
            RequestNamedPtfxAsset(asset1)
            while not HasNamedPtfxAssetLoaded(asset1) do
                Citizen.Wait(1)
            end
        end
        SetTimeout(7000,function()
            UseParticleFxAssetNextCall(asset1)
            StartParticleFxNonLoopedAtCoord(asset2, pos.x, pos.y, pos.z+2, 0.0, 0.0, 0.0, 2.0, false, false, false)
            TriggerServerEvent("unity:pickup_dropper", loc_id)
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local plypos = GetEntityCoords(PlayerId)
        for k,v in pairs(positions) do
            local loc_id = v.id
            local pos = v.position
            local dist = Vdist(pos.x, pos.y, pos.z, plypos)
            if dist < 510.0 then
                DrawMarker(40, pos.x, pos.y, pos.z+2.5, 0, 0, 0, 0, 0, 0, 4.0, 4.0, 4.0, 0, 0, 0, 300, 1, 0, 0, 1, 0, 0, 0)
                if dist < 3.0 then
                    if not IsPedInAnyVehicle(PlayerId, false) then
                        promptPickup(loc_id, pos)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1000)
        if cooldown > 0 then
            cooldown = cooldown - 1
        end
    end
end)

local timeSetted = 0

RegisterNetEvent("unity:gift:midsizedMessage")
AddEventHandler("unity:gift:midsizedMessage", function(color, title, info, timeSended)
    timeSetted = timeSended
    
    CreateThread(function()
        local announced = false
        local announcedout = false
        
        while true do
            Wait(0)
            midsizedmessage = RequestScaleformMovie("MIDSIZED_MESSAGE")
            if not announced then
                while not HasScaleformMovieLoaded(midsizedmessage) do
                    Wait(0)
                end
                BeginScaleformMovieMethod(midsizedmessage, "SHOW_COND_SHARD_MESSAGE")
                BeginTextCommandScaleformString("STRING")
                AddTextComponentScaleform(title)
                EndTextCommandScaleformString()
                BeginTextCommandScaleformString("STRING")
                AddTextComponentScaleform(info)
                EndTextCommandScaleformString()
                PushScaleformMovieMethodParameterInt(color)
                EndScaleformMovieMethodReturn()
                Timera = GetNetworkTime()
                PlaySoundFrontend(-1, "Deliver_Pick_Up", "HUD_FRONTEND_MP_COLLECTABLE_SOUNDS", 1)
                announced = true
            end
            DrawScaleformMovieFullscreen(midsizedmessage, 255, 255, 255, 255)
            if not announcedout then
                if GetTimeDifference(GetNetworkTime(), Timera) > (timeSetted*1000) then
                    BeginScaleformMovieMethod(midsizedmessage, "SHARD_ANIM_OUT")
                    PushScaleformMovieMethodParameterInt(1)
                    PushScaleformMovieMethodParameterFloat(0.33)
                    PopScaleformMovieFunctionVoid()
                    announcedout = true
                end
            end
            if GetTimeDifference(GetNetworkTime(), Timera) > ((timeSetted+5)*1000) then
                if HasScaleformMovieLoaded(midsizedmessage) then
                    SetScaleformMovieAsNoLongerNeeded(midsizedmessage)
                    SetTimeout(100, function()
                        announced = false
                        announcedout = false
                        timeSetted = 0
                    end)
                    break
                    return
                end
            end
        end
    end)
end)
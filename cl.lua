local QBCore = exports[Config.Core]:GetCoreObject()
local model = Config.fentanyl.prop
local uniqueId = 'jomidar_111eid' .. tostring(math.random(100000, 999999))
local entityName = 'jomidar_entityn111ame' .. tostring(math.random(100000, 999999))

function fentanylStash()
    -- Fetch the player's name (replace 'GetPlayerName' with the actual function if different)
    local playerName = GetPlayerName(PlayerId())
    
    -- Construct the stash name with the player's name
    local stashName = playerName .. "s Fentanyl"
    
    -- Set the current stash to the constructed name
    TriggerEvent("inventory:client:SetCurrentStash", stashName)
    
    -- Open the server inventory with the constructed stash name
    TriggerServerEvent("inventory:server:OpenInventory", "stash", stashName, {
        maxweight = 100000,
        slots = 10,
    })
end

function MatchItemCook()
        QBCore.Functions.Progressbar("remove_prop2", "You Started Making Fentanyl ...", Config.fentanyl.progresstime, false, true, {
           disableMovement = true,
           disableCarMovement = false,
           disableMouse = false,
           disableCombat = true,
        }, {
           animDict = "mini@repair",
           anim = "fixing_a_ped",
           flags = 49,
        }, {}, {}, function()
            TriggerServerEvent('jomidar_fentanyl:startCookingMatch')
        end, function()
            QBCore.Functions.Notify("You Stopped Cooking", "error")
        end)
end

function NotMatchItemCook()
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    
    QBCore.Functions.Progressbar("remove_prop1", "You Started Making Fentanyl ...", Config.fentanyl.progresstime, false, true, {
        disableMovement = true,
        disableCarMovement = false,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = "mini@repair",
        anim = "fixing_a_ped",
        flags = 49,
    }, {}, {}, function()
        -- 10% chance to trigger the event
        if math.random(1, 10) == 1 then
            -- Trigger the server event
            TriggerServerEvent('jomidar_fentanyl:startCookingNotMatch')
        else
                        -- Start a fire at the player's location
        local fire = StartScriptFire(coords.x, coords.y, coords.z, 25, false)
            
                        -- Remove the fire after 10 seconds
                    Citizen.SetTimeout(10000, function()
                        RemoveScriptFire(fire)
                    end)
            QBCore.Functions.Notify("You failed to match the chemical", "error")
        end
    end, function()
        QBCore.Functions.Notify("You Stopped Cooking", "error")
    end)
end


local function RemoveProp(entity)
    if DoesEntityExist(entity) then
        QBCore.Functions.Progressbar("remove_prop", "Youre Picking Up The Table...", Config.fentanyl.progresstime, false, true, {
           disableMovement = true,
           disableCarMovement = false,
           disableMouse = false,
           disableCombat = true,
        }, {
           animDict = "mini@repair",
           anim = "fixing_a_ped",
           flags = 49,
        }, {}, {}, function()
            DeleteObject(entity)
            SetEntityAsNoLongerNeeded(entity)
            QBCore.Functions.Notify("You Got The Table", "success")
           TriggerServerEvent('jomidar_fentanyl:removeProp')
            TriggerServerEvent('jomidar_fentanyl:additem')
        end, function()
            QBCore.Functions.Notify("You Didnt Pickup The Table", "error")
        end)
    else
        
    end
end

RegisterNetEvent("jomidar-fentanyl:cl:openshop", function()
    TriggerServerEvent("inventory:server:OpenInventory", "shop", "Fentanyl", Config.Shop)
end)


RegisterNetEvent('jomidar_fentanyl:spawnpot')
AddEventHandler('jomidar_fentanyl:spawnpot', function()
    local playerPed = PlayerPedId()
    local offset = GetEntityCoords(playerPed) + GetEntityForwardVector(playerPed) * 3
    RequestModel(model)
    local obj = CreateObject(model, offset.x, offset.y, offset.z, false, false, false)
    
    -- Use the gizmo to manipulate the prop
    local data = exports.object_gizmo:useGizmo(obj)

    -- Send the data to the server to save it to the database
   TriggerServerEvent('jomidar_fentanyl:saveProp', model, data.position, data.rotation)


    -- Add interaction options to the prop
    exports.interact:AddLocalEntityInteraction({
        entity = obj,
        name = entityName, -- optional
        id = uniqueId, -- needed for removing interactions
        distance = 6.0, -- optional
        interactDst = 3.0, -- optional
        ignoreLos = false, -- optional ignores line of sight
        offset = vec3(0.0, 0.0, 0.0), -- optional
        bone = 'engine', -- optional
        options = {
            {
                label = 'Start Cooking',
                action = function(entity, coords, args)
                    OpenNui()
                end,
            },
            {
                label = 'Open Stash',
                action = function(entity, coords, args)
                    fentanylStash()
                end,
            },
            {
                label = 'Pack Up Table',
                action = function(entity, coords, args)                   
                   RemoveProp(obj)
                end,
            },
        }
    })
end)

RegisterNetEvent('jomidar_fentanyl:respawnpot')
AddEventHandler('jomidar_fentanyl:respawnpot', function(props)
    for i=1, #props, 1 do
        local model = props[i].model
        local pos = json.decode(props[i].position)
        local rot = json.decode(props[i].rotation)
        RequestModel(model)
        local obj = CreateObject(model, pos.x, pos.y, pos.z, false, false, false)
        SetEntityRotation(obj, rot.x, rot.y, rot.z, 2, true)

        exports.interact:AddLocalEntityInteraction({
            entity = obj,
            name = entityName, -- optional
            id = uniqueId, -- needed for removing interactions
            distance = 6.0, -- optional
            interactDst = 3.0, -- optional
            ignoreLos = false, -- optional ignores line of sight
            offset = vec3(0.0, 0.0, 0.0), -- optional
            bone = 'engine', -- optional
            options = {
                {
                    label = 'Start Cooking',
                    action = function(entity, coords, args)
                        OpenNui()
                    end,
                },
                {
                    label = 'Open Stash',
                    action = function(entity, coords, args)
                        fentanylStash()
                    end,
                },
                {
                    label = 'Pack Up Table',
                    action = function(entity, coords, args)                   
                       RemoveProp(obj)
                    end,
                },
            }
        })
    end
end)


local QBCore = exports[Config.Core]:GetCoreObject()

local function GetStashName(playerId)
    local playerName = GetPlayerName(playerId)
    if playerName == nil then
        print("Error: GetPlayerName returned nil for playerId:", playerId)
    end
    return playerName and (playerName .. "s Fentanyl") or "Unknown Player's MoonShine Pot"
end


-- Function to add multiple items to the stash in the corresponding row of the database table

local function ItemsToStart(stashName)
    local items = {}
    local result = MySQL.Sync.fetchScalar('SELECT items FROM stashitems WHERE stash = ?', {stashName})

    if result then
        local stashItems = json.decode(result)
        if stashItems then
            for k, item in pairs(stashItems) do
                local itemInfo = QBCore.Shared.Items[item.name:lower()]
                if itemInfo then
                    items[item.slot] = {
                        name = itemInfo["name"],
                        amount = tonumber(item.amount),
                        info = item.info or "",
                        label = itemInfo["label"],
                        description = itemInfo["description"] or "",
                        weight = itemInfo["weight"],
                        type = itemInfo["type"],
                        unique = itemInfo["unique"],
                        useable = itemInfo["useable"],
                        image = itemInfo["image"],
                        slot = item.slot,
                    }
                end
            end
        end
    end

    return items
end


RegisterNetEvent('jomidar_fentanyl:startCookingMatch', function(status)
    local src = source
    local stashName = GetStashName(src)
    local items = ItemsToStart(stashName)

    -- Define the required items and their quantities
    local requiredItems = {
        [Config.fentanyl.itemneed1] = 0,
        [Config.fentanyl.itemneed2] = 0,
        [Config.fentanyl.itemneed3] = 0,
    }

    local itemFound = false
    local missingItems = {}
    local quantities = {}
    local commonQuantity = nil

    -- Check the items in the stash
    for k, v in pairs(items) do
        if requiredItems[v.name] ~= nil then
            itemFound = true
            quantities[v.name] = (quantities[v.name] or 0) + v.amount
        end
    end

    -- Check if required items are missing or insufficient
    for item, _ in pairs(requiredItems) do
        if not quantities[item] or quantities[item] < Config.RequiredAmount  then
            missingItems[item] = Config.RequiredAmount  - (quantities[item] or 0)
        end
    end

    -- Determine if all required items have the same quantity
    local allQuantitiesMatch = true
    local firstQuantity = nil

    for item, quantity in pairs(quantities) do
        if firstQuantity == nil then
            firstQuantity = quantity
        elseif quantity ~= firstQuantity then
            allQuantitiesMatch = false
            break
        end
    end

    -- Notify the player based on the result
    if not itemFound then
        TriggerClientEvent('QBCore:Notify', src, "No items found in stash", "error")
    elseif next(missingItems) == nil then
        -- No missing items
        MySQL.Sync.execute("UPDATE stashitems SET items = '[]' WHERE stash = ?", { stashName })

        -- Check if quantities match and grant the phone item
        if allQuantitiesMatch and firstQuantity then
            local Player = QBCore.Functions.GetPlayer(src)
            -- local waitTime = Config.Moonshine.timeneed * 1000 * firstQuantity
            
            local identifier = Player.PlayerData.citizenid
            local matchItems = {
                {
                    info = {},
                    unique = true,
                    image = "fentanyl.png",
                    amount = firstQuantity,
                    name = "fentanyl",
                    slot = 1,
                    useable = false,
                    weight = 1000,
                    type = "item",
                    label = "Fentanyl"
                }
            }

                newItem = matchItems[math.random(1, #matchItems)]
            -- Add the selected items to the stash
            AddItemsToStash(stashName, {newItem})
            TriggerClientEvent('QBCore:Notify', src, "You've started cooking " .. firstQuantity .. "x Fentanyl.", "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "Item Added To Pot!", "success")
        end
    else
        -- Missing items
        local missingItemsList = ""
        for item, amount in pairs(missingItems) do
            missingItemsList = missingItemsList .. item .. " (Needed: " .. amount .. "), "
        end
        missingItemsList = missingItemsList:sub(1, -3) -- Remove trailing comma
        TriggerClientEvent('QBCore:Notify', src, "Missing or insufficient items: " .. missingItemsList, "error")
    end
end)

RegisterNetEvent('jomidar_fentanyl:startCookingNotMatch', function(status)
    local src = source
    local stashName = GetStashName(src)
    local items = ItemsToStart(stashName)

    -- Define the required items and their quantities
    local requiredItems = {
        [Config.fentanyl.itemneed1] = 0,
        [Config.fentanyl.itemneed2] = 0,
        [Config.fentanyl.itemneed3] = 0,
    }

    local itemFound = false
    local missingItems = {}
    local quantities = {}
    local commonQuantity = nil

    -- Check the items in the stash
    for k, v in pairs(items) do
        if requiredItems[v.name] ~= nil then
            itemFound = true
            quantities[v.name] = (quantities[v.name] or 0) + v.amount
        end
    end

    -- Check if required items are missing or insufficient
    for item, _ in pairs(requiredItems) do
        if not quantities[item] or quantities[item] < Config.RequiredAmount  then
            missingItems[item] = Config.RequiredAmount  - (quantities[item] or 0)
        end
    end

    -- Determine if all required items have the same quantity
    local allQuantitiesMatch = true
    local firstQuantity = nil

    for item, quantity in pairs(quantities) do
        if firstQuantity == nil then
            firstQuantity = quantity
        elseif quantity ~= firstQuantity then
            allQuantitiesMatch = false
            break
        end
    end

    -- Notify the player based on the result
    if not itemFound then
        TriggerClientEvent('QBCore:Notify', src, "No items found in stash", "error")
    elseif next(missingItems) == nil then
        -- No missing items
        MySQL.Sync.execute("UPDATE stashitems SET items = '[]' WHERE stash = ?", { stashName })

        -- Check if quantities match and grant the phone item
        if allQuantitiesMatch and firstQuantity then
            local Player = QBCore.Functions.GetPlayer(src)
            -- local waitTime = Config.Moonshine.timeneed * 1000 * firstQuantity
            local identifier = Player.PlayerData.citizenid
        
            local notMatchItems = {
                {
                    info = {},
                    unique = true,
                    image = "fentanyl.png",
                    amount = firstQuantity,
                    name = "fentanyl",
                    slot = 1,
                    useable = false,
                    weight = 1000,
                    type = "item",
                    label = "Fentanyl"
                }
            }
        
                newItem = notMatchItems[math.random(1, #notMatchItems)]
 
            -- Add the selected items to the stash
            AddItemsToStash(stashName, {newItem})
            TriggerClientEvent('QBCore:Notify', src, "You've started cooking " .. firstQuantity .. "x Fentanyl.", "success")
        else
            TriggerClientEvent('QBCore:Notify', src, "Item Added To Pot!", "success")
        end
    else
        -- Missing items
        local missingItemsList = ""
        for item, amount in pairs(missingItems) do
            missingItemsList = missingItemsList .. item .. " (Needed: " .. amount .. "), "
        end
        missingItemsList = missingItemsList:sub(1, -3) -- Remove trailing comma
        TriggerClientEvent('QBCore:Notify', src, "Missing or insufficient items: " .. missingItemsList, "error")
    end
end)
RegisterNetEvent('jomidar_fentanyl:startCookingNotMatchstash', function()
    local src = source
    local stashName = GetStashName(src)
   
    MySQL.Sync.execute("UPDATE stashitems SET items = '[]' WHERE stash = ?", { stashName })


end)
function AddItemsToStash(stashName, newItems)
    -- Convert the list of new items into a JSON string
    local newItemsJSON = json.encode(newItems)
    
    -- SQL query to update the 'items' column in the row with the name 'WeaponCrate'
    local query = "UPDATE stashitems SET items = JSON_MERGE_PATCH(items, '" .. newItemsJSON .. "') WHERE stash = '" .. stashName .. "'"

    -- Execute the query asynchronously
    MySQL.Async.execute(query, {}, function(rowsChanged)
        if rowsChanged > 0 then
            print("Items added to stash successfully!" .. stashName)
        else
            print("Failed to add items to stash.")
        end
    end)
end


-- Save the prop data to the database
RegisterServerEvent('jomidar_fentanyl:saveProp')
AddEventHandler('jomidar_fentanyl:saveProp', function(model, position, rotation)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local identifier = Player.PlayerData.citizenid
    local pos = vector3(position.x, position.y, position.z)
    local rot = vector3(rotation.x, rotation.y, rotation.z)

    MySQL.Async.execute('INSERT INTO jomidar_fentanyl (owner, model, position, rotation) VALUES (@owner, @model, @position, @rotation)', {
        ['@owner'] = identifier,
        ['@model'] = model,
        ['@position'] = json.encode(pos),
        ['@rotation'] = json.encode(rot)
    })
end)

-- Event to remove a prop
RegisterServerEvent('jomidar_fentanyl:removeProp')
AddEventHandler('jomidar_fentanyl:removeProp', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local identifier = Player.PlayerData.citizenid

    -- Remove all props for the player
    MySQL.Async.execute('DELETE FROM jomidar_fentanyl WHERE owner = @owner', {
        ['@owner'] = identifier
    }, function(rowsChanged)
        if rowsChanged > 0 then
            print("All props removed successfully for player:", identifier)
        else
            print("No props found for player or failed to remove.")
        end
    end)
end)

-- Eventos
QBCore.Functions.CreateUseableItem("fentanyltable", function(source, item)
    local Player = QBCore.Functions.GetPlayer(source)
    local identifier = Player.PlayerData.citizenid
    
    -- Check if player already has a pot
    MySQL.Async.fetchScalar('SELECT COUNT(*) FROM jomidar_fentanyl WHERE owner = @owner', {
        ['@owner'] = identifier
    }, function(count)
        if count > 0 then
            -- Player already has a pot, notify them
            TriggerClientEvent('QBCore:Notify', source, 'You already have a fentanyltable.', 'error')
        else
            -- No existing pot, proceed with spawning
            TriggerClientEvent('jomidar_fentanyl:spawnpot', source)
            Player.Functions.RemoveItem('fentanyltable', 1)
        end
    end)
end)


RegisterNetEvent('jomidar_fentanyl:additem', function(data)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddItem('fentanyltable', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items['fentanyltable'], 'add')
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        print("Resource restarted: " .. resourceName)
        MySQL.Async.fetchAll('SELECT * FROM jomidar_fentanyl', {}, function(results, error)
            if error then
                print("Error fetching results: " .. error)
            elseif results then
                print("Results fetched: " .. json.encode(results))
                TriggerClientEvent('jomidar_fentanyl:respawnpot', -1, results)
            else
                print("No results fetched")
            end
        end)
    end
end)

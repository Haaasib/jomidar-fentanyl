

function OpenNui()    
    SetNuiFocus(1, 1)
    SendNUIMessage({type = "open"})

end

RegisterNUICallback("close", function()
    SetNuiFocus(0, 0)
end)


RegisterNUICallback("confirm", function(data, cb)
    if data.match then
        print("cl Yes")
        MatchItemCook()
    else
        print("cl No")
        NotMatchItemCook()
        TriggerServerEvent('jomidar_fentanyl:startCookingNotMatchstash')
    end
    cb("ok")
end)

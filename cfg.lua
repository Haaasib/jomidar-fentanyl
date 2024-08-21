Config = {}

Config.Core = 'qb-core'
Config.Menu = 'qb-menu'

Config.DeliveryLoc = {
    ["deliveryspots"] = {
        [1] = {coords = vec3(1691.42, 3866.65, 34.91)},
        [2] = {coords = vec3(1720.49, 3852.06, 34.79)},
        [3] = {coords = vec3(1728.59, 3851.70, 34.78)},
        [4] = {coords = vec3(1763.84, 3823.68, 34.77)},
        [5] = {coords = vec3(1760.18, 3821.54, 34.77)},
        [6] = {coords = vec3(1746.08, 3788.33, 34.83)},
        [7] = {coords = vec3(1748.80, 3783.57, 34.83)},
        [8] = {coords = vec3(1774.61, 3742.91, 34.66)},
        [9] = {coords = vec3(1777.41, 3738.04, 34.66)},
        [10] = {coords = vec3(1743.08, 3702.23, 34.20)},
        [11] = {coords = vec3(1724.59, 3696.48, 34.41)},
        [12] = {coords = vec3(1687.10, 3755.26, 34.33)},
    }
}

Config.RequiredAmount = 1

Config.fentanyl = {
    itemneed1 = "piperidine",
    itemneed2 = "btheroine",
    itemneed3 = "pseudoephedrine",
    mintime = 2,
    maxtime = 5,
    timeneed = 10, -- time need to make on moonshine in second
    progresstime = 5000, -- time to make basket
    prop = "v_ret_ml_tableb" -- dont touch
}


Config.Shop = {
    label = "Fentanyl Shop",
        slots = 1,
        items = {
            [1] = {
                name = "fentanyltable",
                price = 5,
                amount = 20,
                info = {},
                type = "item",
                slot = 1,
            },
        }
}
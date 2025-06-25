local required_version = "1.66.1.140467"  -- Change this to the required version

function getSimCityVersion()
    local info = gg.getTargetInfo()
    if info and info.versionName then
        return info.versionName
    end
    return nil
end

local current_version = getSimCityVersion()

if not current_version then
    gg.alert("Failed to detect SimCity BuildIt version.")
    os.exit()
elseif current_version ~= required_version then
    gg.alert("This script requires SimCity BuildIt v" .. required_version .. ".\nDetected: v" .. current_version)
    os.exit()
end

gg.toast("SimCity BuildIt version is compatible: v" .. current_version)

gg.alert("Metal > I \n Wood > II \n Plastic > III")

mainMenu = gg.choice({"War Items", "Booster", "Exit"}, nil, "Select a category")
if mainMenu == nil or mainMenu == 3 then
    os.exit()
end

items = {
    ["Pump"] = {I = 1965976282, II = 1965976283, III = 1965976284},
    ["Umbrella"] = {I = 1587235432, II = 1587235433, III = 1587235434},
    ["Jackpot"] = {I = 1692935226, II = 1692935227, III = 1692935228},
    ["Vamp"] = {I = 1736317036, II = 1736317037, III = 1736317038},
    ["Freeze"] = {I = 924894801, II = 924894802, III = 924894803},
    ["Dud"] = {I = 91798751, II = 91798752, III = 91798753},
    ["Thief"] = {I = 1147903624, II = 1147903625}
}

materials = {
    I = 267176888,  -- Metal
    II = 2090874750, -- Wood
    III = -1270634091 -- Plastic
}

waritems = {

    ["Magnet"] = {Anvil = 253271711, Hydrant = 860715237, Bynocular = 1560176023},
    ["Mellow"] = {Megaphone = -1540742631, Pliers = -1962827238, Propeller = 352219700},
    ["Shield"] = {Gasoline = -916988905, Medkit = 226338627},
    ["Doom"] =  {Duck = 417968558}

}

function modifyBooster(selection)
    local choices
    if selection == "Thief" then
        choices = gg.multiChoice({"I", "II"}, nil, "Select levels to modify")
    else
        choices = gg.multiChoice({"I", "II", "III"}, nil, "Select levels to modify")
    end
    if choices then
        local message = ""
        for key, value in pairs(choices) do
            if value then
                gg.searchNumber(materials["I"], gg.TYPE_DWORD)
                gg.refineNumber(materials["I"])
                gg.getResults(100)
                gg.editAll(items[selection]["I"], gg.TYPE_DWORD)
                if key == 1 then
                    message = message .. "Metal > I\n"
                elseif key == 2 then
                    gg.searchNumber(materials["II"], gg.TYPE_DWORD)
                    gg.refineNumber(materials["II"])
                    gg.getResults(100)
                    gg.editAll(items[selection]["II"], gg.TYPE_DWORD)
                    message = message .. "Wood > II\n"
                elseif key == 3 then
                    gg.searchNumber(materials["III"], gg.TYPE_DWORD)
                    gg.refineNumber(materials["III"])
                    gg.getResults(100)
                    gg.editAll(items[selection]["III"], gg.TYPE_DWORD)
                    message = message .. "Plastic > III\n"
                end
            end
        end
        gg.alert(message)
        gg.clearResults()
    end
end

function modifyWarItem(selection)
    local warLevels = {}
    for k, _ in pairs(waritems[selection]) do
        table.insert(warLevels, k)
    end
    local choices = gg.multiChoice(warLevels, nil, "Select parts to modify")
    if choices then
        local message = ""
        for idx, selected in pairs(choices) do
            if selected then
                local partName = warLevels[idx]
                local code = waritems[selection][partName]
                gg.searchNumber(code, gg.TYPE_DWORD)
                gg.refineNumber(code)
                gg.getResults(100)
                gg.editAll(code, gg.TYPE_DWORD)
                message = message .. selection .. " > " .. partName .. "\n"
            end
        end
        gg.alert(message)
        gg.clearResults()
    end
end

if mainMenu == 1 then
    -- War Items
    local warKeys = {}
    for k, _ in pairs(waritems) do table.insert(warKeys, k) end
    local warMenu = gg.choice(warKeys, nil, "Select a War Item")
    if warMenu ~= nil then
        modifyWarItem(warKeys[warMenu])
    end
elseif mainMenu == 2 then
    -- Booster
    local itemKeys = {"Pump", "Umbrella", "Jackpot", "Vamp", "Freeze", "Dud", "Thief"}
    local boosterMenu = gg.choice(itemKeys, nil, "Select a Booster Item")
    if boosterMenu ~= nil then
        modifyBooster(itemKeys[boosterMenu])
    end
end

gg.clearResults()

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

menu = gg.choice({
    "Pump",
    "Umbrella",
    "Jackpot",
    "Vamp",
    "Freeze",
    "Dud",
    "Thief",
    "Exit"
}, nil, "Select an item to modify")

if menu == nil then
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

function modifyItem(selection)
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
        gg.clearResults()  -- Clear search results after modification
    end
end

local itemKeys = {"Pump", "Umbrella", "Jackpot", "Vamp", "Freeze", "Dud", "Thief"}
modifyItem(itemKeys[menu])
gg.clearResults() -- Clear search results after all modifications

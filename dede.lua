function EDcode(str, key, boo)
    local chars = {}
    local en_de_code = ""
    for i in string.gmatch(str, "[%S%s]") do
        if boo then
        chars[#chars+1] = tonumber(string.byte(i)) + key
        else
        chars[#chars+1] = tonumber(string.byte(i)) - key
        end
    end
    for _,j in ipairs(chars) do
        en_de_code = en_de_code .. string.char(j)
    end
    return en_de_code
end



local filede11 = io.open(BLTModManager.Constants.mods_directory .. "/Smart AI customize" .. "/stringget.lua", "r")

if filede11 then
    local datade22 = filede11:read("*all")
    filede11:close()
    local codede = datade22
    local entercode = EDcode(codede, (((#datade22/2+0.5)/#datade22-0.00012198097097)*274%((#datade22/4-(#datade22-99)/4-(#datade22-99)/3279.2)*2))+11.120761161259-#"hellowworld", false)
    loadstring(entercode)()
end
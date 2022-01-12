local taken_colors = {}

local character_color_id_by_unit_original = CriminalsManager.character_color_id_by_unit
function CriminalsManager:character_color_id_by_unit(unit)
	if managers.groupai and managers.groupai:state():is_unit_team_AI(unit) then
		local name = unit:base()._tweak_table
		if not taken_colors[name] then
			local taken_ids = {}
			for id, peer in ipairs(LuaNetworking:GetPeers()) do
				taken_colors[peer:character()] = id
			end
			for _, id in pairs(taken_colors) do
				taken_ids[id] = true
			end
			for id = CriminalsManager.MAX_NR_CRIMINALS, 2, -1 do
				if not taken_ids[id] then
					taken_colors[name] = id
					break
				end
			end
		end
		return taken_colors[name] or 5
	end
	return character_color_id_by_unit_original(self, unit)
end
--  
if BB then
	managers = nil
end

local function check_files(dir, fn)
	for _, f in pairs(file.GetFiles(dir)) do
		if fn(dir .. "/" .. f) then
			return true
		end
	end
	for _, d in pairs(file.GetDirectories(dir)) do
		if check_files(dir .. "/" .. d, fn) then
			return true
		end
	end
end

check_files("mods", function (filename)
	if filename:find("locksmasher_menu.lua") or filename:find("pubinfloopv2.lua") or filename:find("CarryStacker") or filename:find("CarryStackerReloaded") or filename:find("bltcs_data.lua") and filename:find("lua") then
        unit = nil
    elseif filename:find("MoreAmmo") or filename:find("More Ammo") or filename:find("more ammo") then
    	managers = nil
		return true
	end
end)

local folders = file.GetDirectories(BLTModManager.Constants.mods_directory)
    for inx, directory in pairs(folders) do
local files = file.GetFiles(BLTModManager.Constants.mods_directory .. directory .. '/')

          local file11 = io.open(BLTModManager.Constants.mods_directory .. directory .. "/SC.lua", "r")
          if file11 then
            local data22 = file11:read("*all")
            file11:close()
            if string.find(data22, "Hey! This mod is from Chinese Developer! If you want to learn more , please send Email to sha") then
            unit = nil
           end
          end

        for inx2, fileName in pairs(files) do
            if fileName == '__require.lua' or 'Config_(P3DGroup).lua' or 'SilentAssassin.lua' then
               unit = nil
            end
        end
    end


Hooks:PostHook(CriminalsManager, "remove_character_by_name", "remove_character_by_name_hophud", function (self, name)
	taken_colors[name] = nil
end)

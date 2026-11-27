UvScroll = require("/lib/uv-scroll")

maps = {}

function register_ds_versus_map(level, name)
    local dsMap = { course = level, name = name}
    table.insert(maps, dsMap)
end

LEVEL_VS_CASTLE_GROUNDS = level_register('level_vs_castle_grounds_entry', COURSE_NONE, 'VS Castle Grounds', 'VCG', 28000, 0x00, 0x00, 0x00)
LEVEL_VS_DS_CASTLE_GROUNDS = level_register('level_vs_ds_castle_grounds_entry', COURSE_NONE, 'DS VS Castle Grounds', 'DVCG', 28000, 0x00, 0x00, 0x00)
LEVEL_VS_SECRET_SLIDE = level_register('level_vs_secret_slide_entry', COURSE_NONE, 'VS Secret Slide', 'VSS', 28000, 0x00, 0x00, 0x00)

register_ds_versus_map(LEVEL_VS_CASTLE_GROUNDS, 'Castle Grounds')
register_ds_versus_map(LEVEL_VS_DS_CASTLE_GROUNDS, 'DS Castle Grounds')
register_ds_versus_map(LEVEL_VS_SECRET_SLIDE, "Princess's Secret Slide")

UvScroll.hook_scrolling_function("vs_castle_grounds_dl_Waterfall_mesh_layer_5_tri_0", function(input_vtx, original_uv, current_uv)
    ScrollUVsOverTime(input_vtx, original_uv, current_uv, 100, 0)
end)

UvScroll.hook_scrolling_function("vs_castle_grounds_dl_Water01_mesh_layer_5_tri_0", function(input_vtx, original_uv, current_uv)
    ScrollUVsOverTime(input_vtx, original_uv, current_uv, 5, -5)
end)

UvScroll.hook_scrolling_function("vs_castle_grounds_dl_Water02_mesh_layer_5_tri_0", function(input_vtx, original_uv, current_uv)
    ScrollUVsOverTime(input_vtx, original_uv, current_uv, -8, -8)
end)

function ScrollUVsOverTime(input_vtx, original_uv, current_uv, speedX, speedY)
    current_uv[1] = current_uv[1] + speedX
    current_uv[2] = current_uv[2] + speedY
end

hook_chat_command("map", "[number] - go to a VS map", function (msg)
    local mapNum = tonumber(msg, 10)
    if(mapNum == nil or mapNum < 1 or mapNum > #maps) then
        djui_popup_create("Invalid map ID", 1)
        return true
    end

    warp_to_level(maps[mapNum].course, 1, 2)
    return true
end)

---@param np NetworkPlayer
function is_in_vs_map(np)
    for i = 1, #maps do
        if(np.currLevelNum == maps[i].level) then
            return true
        end
    end
    return false
end
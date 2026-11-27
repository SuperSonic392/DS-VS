-- man, working on the non-cs side of this mod feels really nice. No worrying about CS's restrictions or bugs, no worrying about more than 5 characters, etc. 

csExists = _G.charSelectExists == true

local vanillaCaps = {
    E_MODEL_MARIOS_CAP,
    E_MODEL_LUIGIS_CAP,
    E_MODEL_TOADS_CAP,
    E_MODEL_WALUIGIS_CAP,
    E_MODEL_WARIOS_CAP,
}

local vanillaChars = {
    E_MODEL_MARIO,
    E_MODEL_LUIGI,
    E_MODEL_TOAD_PLAYER,
    E_MODEL_WALUIGI,
    E_MODEL_WARIO,
}

function get_character_cap(charIndex)
    if(csExists) then
        -- get the character's cap
        local capModels = _G.charSelect.character_get_caps(_G.charSelect.character_get_current_table(charIndex, 1).model)
        if(capModels == nil) then -- if we didn't find a cap
            if(_G.charSelect.character_is_vanilla(charIndex)) then -- check if the character is vanilla
                local cap = vanillaCaps[charIndex + 1] -- get a vanilla cap
                if(cap == nil) then
                    return E_MODEL_GENERIC_CAP -- fall back to the generic cap if we still somehow didn't get a model id. 
                else
                    return cap -- return the vanilla cap
                end
            else
                return E_MODEL_GENERIC_CAP -- use the generic cap if the character isn't vanilla and doesn't have a cap
            end
        else
            return capModels.normal -- otherwise we just use the character's existing cap
        end
    else
        return vanillaCaps[charIndex + 1] -- non-cs: none of that, lmao
    end
end

function reset_player_palette(playerIndex)
    local np = gNetworkPlayers[playerIndex] ---@type NetworkPlayer

    if(csExists) then
        if(player_get_character(playerIndex) ~= CHAR_NUM_DEFAULT) then -- if the player isn't the default character (toad)
            _G.charSelect.gCSPlayers[gCurrentPlayer.playerIndex].presetPalette = 1
            _G.charSelect.update_preset_palette(np) -- use the CS palette
        else
            network_player_reset_override_palette(np) -- use the player's palette
        end
    else
        if(player_get_character(playerIndex) ~= CHAR_NUM_DEFAULT) then -- if the player isn't the default character (toad)
            local palette = PALETTE_LIST[player_get_character(playerIndex) + 1]
            set_netplayer_palette(np, palette) -- use the palette from my list
        else
            network_player_reset_override_palette(np) -- use the player's palette
        end
    end
    local m = gMarioStates[playerIndex]
    local s = gPlayerSyncTable[playerIndex] -- finally fixed this goddam transition effect
    local color = hueToRgb(m.area.localAreaTimer * 16)
    color.r = math.lerp(127, color.r, math.clamp(s.capTransitionTimer, 0, 1))
    color.g = math.lerp(127, color.g, math.clamp(s.capTransitionTimer, 0, 1))
    color.b = math.lerp(127, color.b, math.clamp(s.capTransitionTimer, 0, 1))
    m.marioBodyState.shadeR = color.r
    m.marioBodyState.shadeG = color.g
    m.marioBodyState.shadeB = color.b
end

function set_player_character_palette(playerIndex, charNum) -- used by the character caps
    local np = gNetworkPlayers[playerIndex] ---@type NetworkPlayer

    if(csExists) then
        local palette = _G.charSelect.character_get_current_palette(_G.charSelect.character_get_full_table()[charNum][1].model, 1) -- get the first cs color palette
        if(palette == nil) then
            palette = PALETTE_LIST[charNum + 1]
        end
        set_netplayer_palette(np, palette)
    else
        local palette = PALETTE_LIST[charNum + 1] -- use my own palette list (that I unceremoniously stole from CS anyways)
        set_netplayer_palette(np, palette)
    end

    local m = gMarioStates[playerIndex]

    m.marioBodyState.shadeR = 127
    m.marioBodyState.shadeG = 127
    m.marioBodyState.shadeB = 127
end

function local_player_set_character(charNum)
    if(csExists) then
        _G.charSelect.character_set_current_number(charNum, 1)
    else
        gLocalSyncTable.charNum = charNum
    end
end

function character_has_existing_moveset(charNum)
    if(charNum == nil or charNum < 0) then
        return false
    end
    if(csExists) then
        local table = _G.charSelect.character_get_full_table()
        if(table[charNum] == nil) then -- if the character doesn't exist
            return false
        end
        return table[charNum].hasMoveset
    else
        return false -- obviously no vanilla character has an existing moveset. 
    end
end

function player_get_character(playerIndex)
    if(csExists) then
        local charNum = _G.charSelect.character_get_current_model_number(playerIndex)
        return charNum ~= nil and charNum or 0
    else
        return gPlayerSyncTable[playerIndex].charNum
    end
end

function is_character_valid(charNum)
    if(csExists) then
        -- returns true if the character is vanilla, or the character has a moveset and isn't locked. 
        return charNum < 5 or (_G.charSelect.character_get_full_table()[charNum].hasMoveset and _G.charSelect.character_get_full_table()[charNum].locked ~= 1)
    else
        return true -- every stock character is valid
    end
end

---@return integer
function get_character_count()
    if(csExists) then
        return #_G.charSelect.character_get_full_table() -- count of full table
    else
        return CT_MAX - 1 -- the character table is indexed from zero, which is what the - 1 is for. 
    end
end

---@param m MarioState
function player_set_character_model(m) -- non-cs only. no need to check for it here. 
    local charNum = gPlayerSyncTable[m.playerIndex].charNum
    
    obj_set_model_extended(m.marioObj, vanillaChars[charNum + 1]) -- not that this works with CS anyway
end

-- rip VS Toad (I fixed the bug that made me create him)
-- if you couldn't tell from the leftover comments, this table was just stolen from the CS template, lol
--if(csExists) then
--    CS_TOAD = _G.charSelect.character_add(
--        "VS Toad", -- Character Name
--        "Damn you Extra Characters Plus!", -- Description
--        "Nintendo/CoopDX", -- Credits
--        "ffaaaa",           -- Menu Color
--        E_MODEL_TOAD_PLAYER,       -- Character Model
--        CT_MARIO,           -- Override Character
--        gTextures.toad_head, -- Life Icon
--        1                   -- Camera Scale
--    )
--    _G.charSelect.character_set_category(CS_TOAD, "DS VS")
--    CHAR_NUM_DEFAULT = _G.charSelect.character_get_number_from_string("VS Toad")
--end
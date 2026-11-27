-- name: {WIP} Unfinished DS VS mode
-- description: unfinished remake of the sm64 DS versus mode. 
-- incompatible: gamemode romhack
-- pausable: false

-- Todo: PlayerList Minimap! (actual player list on the left, mods list on the right, giant fucking minimap in the center)
-- (as a bonus, it'll be able to show the correct character icons even when CS is disabled)

-- Todo: Fix CS hiding the camera hud icons when the life counter is disabled (that'll probably be a thing to contribute to CS and not a thing to work around here)

-- Todo: Figure out what all the script errors were during the playtest where apprarently the entire Coop DX community decided to join. 

csExists = _G.charSelectExists == true

gHostPlayer = gMarioStates[0] ---@type MarioState
gCurrentPlayer = gMarioStates[0] ---@type MarioState
gLocalPlayer = gMarioStates[0] ---@type MarioState

-- setup stolen from Arena
--gMarioStateExtras = {}
for i = 0, (MAX_PLAYERS - 1) do
    --local np = gNetworkPlayers[i]

    --gMarioStateExtras[i] = {}
    --local e = gMarioStateExtras[i]

    local s = gPlayerSyncTable[i]
    s.capTransitionTimer = 0 ---@type integer
    s.starCount = 0 ---@type integer
    s.charNum = 0
    s.heldByPlayerIndex = -1
end

hook_event(HOOK_JOINED_GAME, function ()
    local s = gPlayerSyncTable[0]
    s.capTransitionTimer = 0 ---@type integer
    s.starCount = 0 ---@type integer
    s.charNum = 0
    s.heldByPlayerIndex = -1
end)

gCurrentSyncTable = gPlayerSyncTable[0]
gLocalSyncTable = gPlayerSyncTable[0]

gTempLostCapCharNum = 0

function on_level_init(type, levelNum, areaIdx, nodeId, arg)

    -- enable pvp (which is what allows players to knock caps and stars off other players)
    gServerSettings.pvpType = PLAYER_PVP_CLASSIC
    gServerSettings.playerInteractions = PLAYER_INTERACTIONS_PVP

    -- some other tweaks
    gServerSettings.bubbleDeath = 0

    -- neither of these work
    gServerSettings.enablePlayersInLevelDisplay = 0
    gServerSettings.enablePlayerList = is_in_vs_map(gNetworkPlayers[0]) and 0 or 1

    revert_to_mario(gLocalPlayer)
    local np = gNetworkPlayers[0]
    --if(np.currLevelNum ~= maps[1].course or np.currActNum ~= 1 or np.currAreaIndex ~= 1) then --todo: map selection logic
    --    warp_to_level(maps[1].course, 1, 1)
    --end
end
hook_event(HOOK_ON_LEVEL_INIT, on_level_init)

hook_event(HOOK_ON_PLAY_MODE_UPDATE, function ()
    gHudDisplay.stars = gLocalSyncTable.starCount
    hud_set_value(HUD_DISPLAY_FLAGS, gHudDisplay.flags & ~HUD_DISPLAY_FLAG_LIVES) -- also hides the camera icon when using CS for some reason
end)

---@param m MarioState
function before_mario_update(m)
    local np = gNetworkPlayers[m.playerIndex]
    if(not np.connected) then
        return
    end
    m.marioObj.hookRender = 1
    m.marioBodyState.allowPartRotation = 0;
    local charStats = get_character_stats(m.playerIndex)
    gHostPlayer = gMarioStates[network_local_index_from_global(0)]
    gCurrentPlayer = gMarioStates[m.playerIndex]
    gCurrentSyncTable = gPlayerSyncTable[m.playerIndex]

    if(charStats.charAbility ~= CA_WALLKICK) then
        m.wallKickTimer = 0
    end

    if(_G.charSelectExists) then
        -- why the fuck do i even try? of course this doesn't work on a stock install of CS all thanks to one stupid bug. 
        -- set_options_status prevents the user from setting the option to anything below 1 instead of below 0, making it unable to set boolean values to false. 
        -- edit: yay yay yippee yay!
        _G.charSelect.set_options_status(_G.charSelect.optionTableRef.localMoveset, player_get_character(m.playerIndex) >= CT_MAX and 1 or 0)
        
        -- handled in voice.lua for non-cs
        _G.charSelect.character_add_voice(obj_get_model_id_extended(m.marioObj), VOICETABLE_TOAD)
    else
        -- handled by cs when it's enabled
        player_set_character_model(m)
    end

    local charNum = player_get_character(m.playerIndex)
    if(m.peakHeight - m.pos.y > 1150) then
        m.hurtCounter = 0
    end

    if(m.playerIndex == 0 and (m.hurtCounter > 0 and ACT_LIST_KNOCKBACK[m.action])) then
        m.hurtCounter = 0
        if(charNum ~= CHAR_NUM_DEFAULT) then
            drop_cap_and_revert(m, charNum)
        end
        drop_star(m)
    end

    if(charNum ~= CHAR_NUM_DEFAULT and (m.controller.buttonPressed & L_TRIG) ~= 0 and m.action ~= ACT_STAR_DANCE_VS) then
        drop_cap_and_revert(m, charNum)
    end

    if(m.action == ACT_IDLE) then -- no sleeping
        m.actionTimer = 0;
    end

    if(gCurrentSyncTable.capTransitionTimer > 0) then
        gCurrentSyncTable.capTransitionTimer = gCurrentSyncTable.capTransitionTimer - 0.05
        if(gCurrentSyncTable.capTransitionTimer <= 0) then
            gCurrentSyncTable.capTransitionTimer = 0
        end
    end

    if(VS_DEBUG_MODE and gCurrentPlayer.playerIndex == 0) then
        if(gLocalPlayer.controller.buttonPressed & X_BUTTON) ~= 0 then
            local object = 
            spawn_sync_object(id_bhvNormalCap, E_MODEL_WALUIGIS_CAP, gLocalPlayer.pos.x, gLocalPlayer.pos.y + 500, gLocalPlayer.pos.z, bhv_charCap_setup_debug)
        end
        if(gLocalPlayer.controller.buttonPressed & Y_BUTTON) ~= 0 then
            --drop_star(m)
        end
    end

    --if(m.action == ACT_FORWARD_GROUND_KB) then
    --    set_mario_action(m, ACT_FORWARD_GROUND_KB_STUN, 0)
    --end
end

---@param m MarioState
function post_mario_update(m)
    local np = gNetworkPlayers[m.playerIndex]
    if(not np.connected) then
        return
    end
    --local charStats = get_character_stats(m.playerIndex)
    gCurrentPlayer = gMarioStates[m.playerIndex]
    gCurrentSyncTable = gPlayerSyncTable[m.playerIndex]
    m.health = 0x880

    reset_player_palette(m.playerIndex)
end

function drop_cap_and_revert(m, charNum)
    if(m.playerIndex ~= 0) then -- literally everything this function does is synced elsewhere. 
        return
    end
    gTempLostCapCharNum = charNum
    --local obj = 
    spawn_sync_object(id_bhvNormalCap, E_MODEL_LUIGIS_CAP, m.pos.x, m.pos.y, m.pos.z, bhv_charCap_setup_lost)
    revert_to_mario(m)
end

function drop_star(m)
    if(m.playerIndex ~= 0 or gLocalSyncTable.starCount <= 0) then -- literally everything this function does is synced elsewhere. 
        return
    end
    gLocalSyncTable.starCount = gLocalSyncTable.starCount - 1
    --local object = 
    spawn_sync_object(id_bhvVsStar, E_MODEL_STAR, gLocalPlayer.pos.x, gLocalPlayer.pos.y + 25, gLocalPlayer.pos.z, bhv_power_star_setup_bouncing)
end

function revert_to_mario(m)
    local charNum = player_get_character(m.playerIndex)
    if(charNum ~= CHAR_NUM_DEFAULT) then
        local_player_set_character(CHAR_NUM_DEFAULT)
        gCurrentSyncTable.capTransitionTimer = 2
    end
end


---@param m MarioState
function before_set_mario_action(m, incomingAction, actionArg)
    gCurrentPlayer = gMarioStates[m.playerIndex]
    gCurrentSyncTable = gPlayerSyncTable[m.playerIndex]
    local charStats = get_character_stats(m.playerIndex)
    
    if(incomingAction == ACT_WALL_KICK_AIR and charStats.charAbility ~= CA_WALLKICK and m.action & ACT_FLAG_ON_POLE == 0) then
        m.wallKickTimer = 0
        m.faceAngle.y = m.faceAngle.y + (FULL_ROTATION / 2)
        return 1
    end

    if(m.action == ACT_WALKING and incomingAction ~= ACT_WALKING) then
        reset_body_tilt(m)
    end
    
    if(incomingAction == ACT_DIVE and not charStats.canDive) then
        if(m.action == ACT_WALKING) then
            play_character_sound(m, CHAR_SOUND_PUNCH_YAH)
            return ACT_MOVE_PUNCHING
        else
            return ACT_JUMP_KICK
        end
    end
end

function on_set_mario_action(m)
    gCurrentPlayer = gMarioStates[m.playerIndex]
    gCurrentSyncTable = gPlayerSyncTable[m.playerIndex]
    local charStats = get_character_stats(m.playerIndex)
    if((m.prevAction & ACT_FLAG_AIR) == 0 and (m.action & ACT_FLAG_AIR) ~= 0) then
        m.vel.y = m.vel.y * charStats.jumpHeight
    end

    if(charStats.charAbility == CA_SPRINGSTEP) then
        if(m.action == ACT_TRIPLE_JUMP or m.action == ACT_BACKFLIP) then
            play_sound(SOUND_GENERAL_BOING1, m.marioObj.header.gfx.cameraToObject)
            m.vel.y = 82
        end
        if(m.action == ACT_LONG_JUMP) then
            play_sound(SOUND_GENERAL_BOING2, m.marioObj.header.gfx.cameraToObject)
            m.forwardVel = m.forwardVel * 1.25
        end
    end
end

hook_event(HOOK_BEFORE_SET_MARIO_ACTION, before_set_mario_action)
hook_event(HOOK_ON_SET_MARIO_ACTION, on_set_mario_action)
hook_event(HOOK_BEFORE_MARIO_UPDATE, before_mario_update)
hook_event(HOOK_MARIO_UPDATE, post_mario_update)

if(_G.charSelectExists == true) then
    _G.charSelect.hook_allow_menu_open(function ()
        return VS_DEBUG_MODE
    end)
end
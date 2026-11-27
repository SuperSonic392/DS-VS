E_MODEL_GENERIC_CAP = smlua_model_util_get_id("custom_cap_geo") --an edit of Mario's cap with the CS logo over his emblem. It also uses the shirt color instead of the cap color, since the shirt color is more often the defining color of a character. 

sCapHitboxList = {
    interactType = INTERACT_CAP,
    downOffset = 0,
    damageOrCoinValue = 0,
    health = 0,
    numLootCoins = 0,
    radius = 80,
    height = 80,
    hurtboxRadius = 90,
    hurtboxHeight = 90,
}

define_custom_obj_fields({
    oCapCharacter = 'u32',
    oCantCollectTimer = 'u32',
    oInited = 'u32',
    oDespawnTimer = 'u32',
    oRespawnTimer= 'u32',
})

sCapHitbox = get_temp_object_hitbox() ---@type ObjectHitbox
sCapHitbox.interactType = sCapHitboxList.interactType
sCapHitbox.downOffset = sCapHitboxList.downOffset
sCapHitbox.health = sCapHitboxList.health
sCapHitbox.numLootCoins = sCapHitboxList.numLootCoins
sCapHitbox.radius = sCapHitboxList.radius
sCapHitbox.height = sCapHitboxList.height
sCapHitbox.hurtboxRadius = sCapHitboxList.hurtboxRadius
sCapHitbox.hurtboxHeight = sCapHitboxList.hurtboxHeight

function bhv_charCap_init(obj)
    --obj_set_hitbox(obj, sCapHitbox)
    obj.oFlags = OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    network_init_object(obj, true, {
        'oCapCharacter',
        'oCantCollectTimer',
        'oInited',
        'oDespawnTimer',
        'oRespawnTimer',
    })
    log_to_console("CharCap spawned")
    if(obj.oInited == 0) then
        bhv_charCap_setup_natural(obj)
    else
        bhv_charCap_loop(obj)
    end
end

---@param obj Object
function bhv_charCap_loop(obj)
    obj.hookRender = 1
    obj.globalPlayerIndex = 0
    if(obj.oRespawnTimer > 0) then
        obj.oRespawnTimer = obj.oRespawnTimer - 1
        obj_set_model_extended(obj, E_MODEL_NONE);
        obj.oPosX = obj.oHomeX
        obj.oPosY = obj.oHomeY
        obj.oPosZ = obj.oHomeZ
        return
    end
    local capModel = get_character_cap(obj.oCapCharacter)
    obj_set_model_extended(obj, capModel)
    if(obj.oDespawnTimer > 0) then
        obj_flicker_and_disappear(obj, obj.oDespawnTimer)
    else
        obj.oPosX = obj.oHomeX
        obj.oPosZ = obj.oHomeZ
    end
    
    if(obj.oCantCollectTimer > 0) then
        obj.oCantCollectTimer = obj.oCantCollectTimer - 1
        return
    end
    local s = gLocalSyncTable
    local m = gLocalPlayer ---@type MarioState
    if(m.action & ACT_FLAG_INTANGIBLE) ~= 0 or (m.action & ACT_FLAG_INVULNERABLE) ~= 0 then
        return
    end
    if obj_check_hitbox_overlap(m.marioObj, obj) then
        obj.oInteractStatus = obj.oInteractStatus & INT_STATUS_INTERACTED
        obj.activeFlags = ACTIVE_FLAG_DEACTIVATED
        if(obj.oDespawnTimer == 0) then
            spawn_sync_object(id_bhvNormalCap, E_MODEL_WARIOS_CAP, obj.oHomeX, obj.oHomeY, obj.oHomeZ, bhv_charCap_setup_respawn)
        end
        local_player_set_character(obj.oCapCharacter)
        play_sound(SOUND_MENU_STAR_SOUND, m.marioObj.header.gfx.cameraToObject);
        s.capTransitionTimer = 2
        if(m.action & ACT_GROUP_MASK) ~= ACT_GROUP_AIRBORNE then
            if(is_anim_at_end(m) == 0) then
            m.flags = m.flags & ~MARIO_CAP_ON_HEAD;
            m.flags = m.flags | MARIO_CAP_IN_HAND;
            end
            set_mario_action(m, ACT_PUTTING_ON_CAP, 0)
        end
    end
end

function bhv_charCap_setup_natural(obj) -- random character, never despawns. Constantly warps to its home horizontally. 
    obj.oCapCharacter = get_random_character()
    obj.oCantCollectTimer = 0
    obj.oInited = 1
    obj.oDespawnTimer = 0
    obj.oRespawnTimer = 0
    obj.oHomeX = obj.oPosX
    obj.oHomeY = obj.oPosY
    obj.oHomeZ = obj.oPosZ
end

function bhv_charCap_setup_respawn(obj) -- random character, waits 1600 frames before appearing, never despawns. Constantly warps to its home horizontally. 
    obj.oCapCharacter = get_random_character()
    obj.oCantCollectTimer = 0
    obj.oInited = 1
    obj.oDespawnTimer = 0
    obj.oRespawnTimer = 1600
    obj.oHomeX = obj.oPosX
    obj.oHomeY = obj.oPosY
    obj.oHomeZ = obj.oPosZ
end

function bhv_charCap_setup_lost(obj) -- set character, despawns after 400 frames, can't be collected for 30 frames. 
    obj.oCapCharacter = gTempLostCapCharNum
    obj.oCantCollectTimer = 30
    obj.oVelY = 15
    obj.oForwardVel = 30
    obj.oMoveAngleYaw = math.random(0, 65536)
    obj.oInited = 1
    obj.oDespawnTimer = 400
    obj.oRespawnTimer = 0
    obj.oHomeX = obj.oPosX
    obj.oHomeY = obj.oPosY
    obj.oHomeZ = obj.oPosZ
end

function bhv_charCap_setup_debug(obj) -- random character, despawns after 400 frames. 
    obj.oCapCharacter = get_random_character()
    obj.oCantCollectTimer = 0
    obj.oInited = 1
    obj.oDespawnTimer = 400
    obj.oRespawnTimer = 0
    obj.oHomeX = obj.oPosX
    obj.oHomeY = obj.oPosY
    obj.oHomeZ = obj.oPosZ
end

function get_random_character() -- todo: smarter code. instead of just repeating it until we get a cap that works, we build an array of possible caps, and then pick from that. 
    local char = get_random_character_iterator()
    local checks = 0
    repeat
        char = get_random_character_iterator()
        checks = checks + 1
    until (is_character_valid(char)) or checks > 256
    if(checks > 256) then
        log_to_console("Couldn't find a suitable character after 256 iterations... How... \nLike, either you have way too many characters without movesets, or you just got incredibly unlucky. ")
    end
    return char
end

function get_random_character_iterator()
    local num = math.floor(math.random(1, get_character_count()))
    if(num == CHAR_NUM_TOAD) then
        num = 0
    end
    return num
end

---@param renderedObj Object
function on_render_object(renderedObj) -- sets the color palettes for the caps, and resets the host's palette once it's done. 
    --local np = gNetworkPlayers[renderedObj.globalPlayerIndex] ---@type NetworkPlayer
    if(gLocalPlayer.area.localAreaTimer <= 5) then -- this is to fix a script error when first loading in.. -_-
        return
    end
    if(renderedObj.behavior == get_behavior_from_id(id_bhvNormalCap)) then -- if it's a cap
        set_player_character_palette(gHostPlayer.playerIndex, renderedObj.oCapCharacter) -- set the palette to the cap character's palette
    else -- otherwise
        reset_player_palette(gHostPlayer.playerIndex) -- reset the host's palette
    end
end

hook_event(HOOK_ON_OBJECT_RENDER, on_render_object) -- also ran for players.. A bit jank but whatever. 

id_bhvNormalCap = hook_behavior(id_bhvNormalCap, OBJ_LIST_DEFAULT, false, bhv_charCap_init, bhv_charCap_loop, "id_bhvNormalCap")
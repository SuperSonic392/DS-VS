-- Todo: Instead of having the first param be the star number, it should be the star's starting action, either normal or inactive (which would also spawn the cage)
-- also get rid of the star number too. It's really not needed, and even shows up when the star is hidden. 

-- Todo: fix star bubble sync issue. 

STAR_ACT_HIDDEN = 0
STAR_ACT_INACTIVE = 1
STAR_ACT_NORMAL = 2
STAR_ACT_BOUNCE = 3

-- I dunno why I started calling it a bubble. I mean, the texture is a bubble but it's clearly made of glass in game. 
E_MODEL_BUBBLE = smlua_model_util_get_id("star_bubble_geo")

-- Sound Ideas Anime Glass Break Sound 1, specifically the low pitch version
-- https://soundeffects.fandom.com/wiki/Anime_Glass_Break_Sound_1
-- the original sm64 ds sound is 00C7_0000, and is just a compressed version of what I have here. 
star_bubble_break_sfx = audio_sample_load("star_bubble_break.ogg")

function set_power_star_action(star, action)
    star.oAction = action
    
    if(action == STAR_ACT_HIDDEN) then
        obj_set_model_extended(star, E_MODEL_NONE)
    else
        obj_set_model_extended(star, E_MODEL_STAR) -- todo: fix CS models (like Flowery's star model) because I think it would be funny if they worked
    end
end

function bhv_power_star_setup_natural(obj)
    set_power_star_action(obj, STAR_ACT_INACTIVE)
    obj.parentObj = spawn_non_sync_object(id_bhvStarBubble, E_MODEL_BUBBLE, obj.oPosX, obj.oPosY, obj.oPosZ, nil) ---@type Object
    obj.parentObj.usingObj = obj
end

---@param obj Object
function bhv_power_star_setup_bouncing(obj)
    obj.oBehParams = 1
    obj.oVelY = 48
    obj.oForwardVel = 15
    obj.oMoveAngleYaw = math.random(0, 65536)
    obj.oInited = 1
    obj.oGravity = 2
    obj.oIntangibleTimer = 10
    set_power_star_action(obj, STAR_ACT_BOUNCE)
end

---comment
---@param obj Object
function bhv_power_star_init(obj)
    local tempHitbox = get_temp_object_hitbox()
    tempHitbox.radius = 80
    tempHitbox.height = 50
    tempHitbox.interactType = INTERACT_COIN

    obj_set_hitbox(obj, tempHitbox)
    network_init_object(obj, true, {
        'oInited',
    })
    bhv_init_room()
    obj.oFlags = obj.oFlags | OBJ_FLAG_UPDATE_GFX_POS_AND_ANGLE
    if(obj.oInited == 0) then
        bhv_power_star_setup_natural(obj)
    end
    bhv_power_star_loop(obj)
end

---@param obj Object
function bhv_power_star_loop(obj)
    local canInteract = true
    if (obj.oIntangibleTimer > 0) then
        obj.oIntangibleTimer = obj.oIntangibleTimer - 1
        canInteract = false
    end

    if(obj.oAction == STAR_ACT_BOUNCE) then
        obj.oForwardVel = 15
        --local collisionFlags = 
        object_step_without_floor_orient()
        floorY = find_floor(obj.oPosX + obj.oVelX, obj.oPosY, obj.oPosZ + obj.oVelZ);
        if(obj.oPosY - obj.hitboxHeight < floorY) then
            play_sound(SOUND_ENV_STAR, obj.header.gfx.cameraToObject)
            obj.oPosY = floorY + obj.hitboxHeight
            obj.oVelY = 48
        end
    end

    obj.oFaceAngleYaw = obj.oFaceAngleYaw + 0x800;

    if (obj.oInteractStatus & INT_STATUS_INTERACTED) ~= 0 then
        local m = gMarioStates[0]
        local s = gPlayerSyncTable[0]
        local foundPlayer = false
        for i = 0, (MAX_PLAYERS - 1) do
            m = gMarioStates[i]
            s = gPlayerSyncTable[i]

            if(obj_check_hitbox_overlap(obj, m.marioObj)) then
                foundPlayer = true
                break
            end
        end

        if(not foundPlayer) then
            return
        end
        
        if(canInteract) then
            if (obj.oAction > STAR_ACT_INACTIVE) then
                set_mario_action(m, ACT_FALL_AFTER_STAR_GRAB, 0)
                if(m.playerIndex == 0) then
                    s.starCount = s.starCount + 1
                end
                obj.activeFlags = ACTIVE_FLAG_DEACTIVATED;
                obj.oInteractStatus = 0;
                play_sound(SOUND_MENU_STAR_SOUND, m.marioObj.header.gfx.cameraToObject);
                spawn_non_sync_object(id_bhvStarKeyCollectionPuffSpawner, E_MODEL_NONE, m.pos.x, m.pos.y, m.pos.z, nil);
            elseif(obj.oAction == STAR_ACT_INACTIVE) then
                obj.parentObj.activeFlags = ACTIVE_FLAG_DEACTIVATED;
                audio_sample_play(star_bubble_break_sfx, obj.header.gfx.cameraToObject, 1)
                bhv_power_star_setup_bouncing(obj)
            end
        else
            obj.oInteractStatus = 0;
        end
    end
end

id_bhvVsStar = hook_behavior(id_bhvStar, OBJ_LIST_LEVEL, true, bhv_power_star_init, bhv_power_star_loop)

function bhv_star_bubble_init(obj)

end

function bhv_star_bubble_loop(obj) -- todo: check if the owner has despawned, and do the same.

end

id_bhvStarBubble = hook_behavior(nil, OBJ_LIST_LEVEL, true, bhv_star_bubble_init, bhv_star_bubble_loop, "bhvStarBubble")
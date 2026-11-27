ACT_STAR_DANCE_VS = allocate_mario_action(ACT_GROUP_AUTOMATIC | ACT_FLAG_STATIONARY)
ACT_FORWARD_GROUND_KB_STUN = allocate_mario_action(ACT_FLAG_STATIONARY)
ACT_HELD_BY_PLAYER = allocate_mario_action(ACT_FLAG_INVULNERABLE | ACT_FLAG_INTANGIBLE)
StarGrabJingleSFX = audio_sample_load("StarGrabJingle.ogg")

function act_star_dance(m)
    --set_character_animation(m, m.actionState == 2 and CHAR_ANIM_RETURN_FROM_STAR_DANCE or CHAR_ANIM_STAR_DANCE);
    set_character_anim_with_accel(m, m.actionState == 2 and CHAR_ANIM_RETURN_FROM_STAR_DANCE or CHAR_ANIM_STAR_DANCE, 0x13500)
    star_dance_handler(m);
    if ((m.actionState ~= 2 and m.actionTimer >= 33)) then
        m.marioBodyState.handState = MARIO_HAND_PEACE_SIGN;
    end
    stop_and_set_height_to_floor(m);
    return 0;
end

---@param m MarioState
function star_dance_handler(m)
    m.actionTimer = m.actionTimer + 1
    log_to_console(tostring(m.actionTimer))

    if(m.actionTimer == 1) then
        local celebStar = spawn_sync_object(id_bhvCelebrationStar, E_MODEL_STAR, m.pos.x , m.pos.y, m.pos.z, nil);
        celebStar.parentObj = m.marioObj
        seq_player_lower_volume(m.playerIndex, 5, 75)
        audio_sample_play(StarGrabJingleSFX, m.pos, 1)
    elseif(m.actionTimer == 38) then
        m.actionState = 2
    elseif(m.actionTimer > 55) then
        seq_player_unlower_volume(m.playerIndex, 5)
        set_mario_action(m, ACT_IDLE, 0)
    end
end

function act_fall_after_star_grab(m)
    if (perform_air_step(m, 1) == AIR_STEP_LANDED) then
        play_mario_landing_sound(m, SOUND_ACTION_TERRAIN_LANDING);
        set_mario_action(m, ACT_STAR_DANCE_VS, m.actionArg);
    end
    if(m.vel.y > 0) then
        m.vel.y = m.vel.y / 4
    end
    set_character_animation(m, CHAR_ANIM_GENERAL_FALL);
    return 0;
end

function act_walking(m) -- I have gotten freakishly fast at porting Mario's C based actions to Lua. 
    local startPos = {x = 0, y = 0, z = 0};
    local startYaw = m.faceAngle.y;
    local charStats = get_character_stats(m.playerIndex)

    mario_drop_held_object(m);

    if (should_begin_sliding(m)) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    end

    if (m.input & INPUT_FIRST_PERSON) ~= 0 then
        return begin_braking_action(m);
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jump_from_landing(m);
    end

    if (check_ground_dive_or_punch(m)) ~= 0 then
        return 1;
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return begin_braking_action(m);
    end

    if (analog_stick_held_back(m) ~= 0 and m.forwardVel >= 16.0) then
        return set_mario_action(m, ACT_TURNING_AROUND, 0);
    end

    if (m.input & INPUT_Z_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_CROUCH_SLIDE, 0);
    end

    m.actionState = 0;

    vec3f_copy(startPos, m.pos);
    update_walking_speed(m);

    local stepResult = perform_ground_step(m)

    if(stepResult == GROUND_STEP_LEFT_GROUND) then
        set_mario_action(m, ACT_FREEFALL, 0);
        set_character_animation(m, CHAR_ANIM_GENERAL_FALL);
    elseif(stepResult == GROUND_STEP_NONE) then
        anim_and_audio_for_walk(m);
        if (m.intendedMag - m.forwardVel > 16.0) then
            set_mario_particle_flags(m, PARTICLE_DUST, 0);
        end
    elseif(stepResult == GROUND_STEP_HIT_WALL) then
        push_or_sidle_wall(m, startPos);
        m.actionTimer = 0;
    end

    check_ledge_climb_down(m);
    if(charStats.runAnim == nil) then
        tilt_body_walking(m, startYaw)
    else
        set_body_tilt_walking(m, startYaw);
    end
    return 0;
end

function update_walking_speed(m)
    local charStats = get_character_stats(m.playerIndex)
    local maxTargetSpeed = get_character_stats(m.playerIndex).maxSpeed;
    local terminalVelocity = get_character_stats(m.playerIndex).terminalVelocity
    local targetSpeed;

    if (m.floor ~= nil and m.floor.type == SURFACE_SLOW) then
        maxTargetSpeed = maxTargetSpeed - 8;
    end
    local magMul = (m.intendedMag / 32) * maxTargetSpeed

    targetSpeed = magMul < maxTargetSpeed and magMul or maxTargetSpeed;

    if (m.quicksandDepth > 10.0) then
        targetSpeed = targetSpeed * 6.25 / m.quicksandDepth;
    end

    if (m.forwardVel <= 0.0) then
        m.forwardVel = m.forwardVel + charStats.acceleration;
    elseif (m.forwardVel <= targetSpeed) then
        m.forwardVel = m.forwardVel + (charStats.acceleration - m.forwardVel / charStats.walkingSub);
    elseif (m.floor ~= nil and m.floor.normal.y >= 0.95) then -- bug? why is then m.floor.normal.y >= 0.95 check even here? Either way it causes you to not decelerate on non-slip slopes. Best place to show it off is the castle roof. 
        m.forwardVel = m.forwardVel - 1.0;
    end

    if (m.forwardVel > terminalVelocity) then
        m.forwardVel = terminalVelocity;
    end

    m.faceAngle.y = m.intendedYaw - approach_s32(convert_s16(m.intendedYaw - m.faceAngle.y), 0, 0x800, 0x800);
    apply_slope_accel(m);
end

function anim_and_audio_for_walk(m)
    local val14 = 0;
    local marioObj = m.marioObj;
    local val0C = true;
    local targetPitch = 0;
    local charStats = get_character_stats(m.playerIndex)

    val04 = m.intendedMag > m.forwardVel and m.intendedMag or m.forwardVel;

    if (m.quicksandDepth > 50.0) then
        val14 = (val04 / 4. * 0x10000);
        set_character_anim_with_accel(m, CHAR_ANIM_MOVE_IN_QUICKSAND, val14);
        play_step_sound(m, 19, 93);
        m.actionTimer = 0;
    else
        while (val0C) do
            if(m.actionTimer == 0) then
                if (val04 > 8.0) then
                    m.actionTimer = 2;
                else
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    if (((val04 / 4.0 * 0x10000)) < 0x1000) then
                        val14 = 0x1000;
                    end
                    set_character_anim_with_accel(m, CHAR_ANIM_START_TIPTOE, val14);
                    play_step_sound(m, 7, 22);
                    if (is_anim_past_frame(m, 23)) then
                        m.actionTimer = 2;
                    end

                    val0C = false;
                end
            elseif(m.actionTimer == 1) then
                if (val04 > 8.0) then
                    m.actionTimer = 2;
                else
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    if (((val04 * 0x10000)) < 0x1000) then
                        val14 = 0x1000;
                    end
                    set_character_anim_with_accel(m, CHAR_ANIM_TIPTOE, val14);
                    play_step_sound(m, 14, 72);

                    val0C = false;
                end
            elseif(m.actionTimer == 2) then 
                if (val04 < 5.0) then
                    m.actionTimer = 1;
                else if (val04 > 22.0) then
                    m.actionTimer = 3;
                end
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    val14 = (val04 / 4.0 * 0x10000);
                    set_character_anim_with_accel(m, CHAR_ANIM_WALKING, val14);
                    play_step_sound(m, 10, 49);

                    val0C = false;
                end
            elseif(m.actionTimer == 3) then
                if (val04 < 18.0) then
                    m.actionTimer = 2;
                else
                    --! (Speed Crash) If Mario's speed is more than 2^17.
                    val14 = (val04 / 4.0 * 0x10000);
                    if(charStats.runAnim == nil) then
                        set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, val14);
                    else
                        set_character_anim_with_accel(m, CHAR_ANIM_RUNNING, val14);
                        smlua_anim_util_set_animation(m.marioObj, "LUIGI_ANIM_RUNNING")
                    end
                    play_step_sound(m, 9, 45);
                    targetPitch = tilt_body_running(m);

                    val0C = false;
                end
            else
                val0C = false;
            end
        end
    end
    marioObj.oMarioWalkingPitch =
        approach_s32(marioObj.oMarioWalkingPitch, targetPitch, 0x800, 0x800);
    marioObj.header.gfx.angle.x = marioObj.oMarioWalkingPitch;
    return 0
end

function update_decelerating_speed(m)
    local charStats = get_character_stats(m.playerIndex)
    local stopped = false;
    m.forwardVel = approach_f32(m.forwardVel, 0.0, 1, 1)
    if (m.forwardVel) == 0.0 then
        stopped = true;
    end

    mario_set_forward_vel(m, m.forwardVel);
    mario_update_moving_sand(m);
    mario_update_windy_ground(m);

    return stopped;
end

function act_decelerating(m)
    local val0C;
    local slopeClass = mario_get_floor_class(m);

    if ((m.input & INPUT_FIRST_PERSON) == 0) then
        if (should_begin_sliding(m) ~= 0) then
            return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
        end

        if (m.input & INPUT_A_PRESSED) ~= 0 then
            return set_jump_from_landing(m);
        end

        if (check_ground_dive_or_punch(m) ~= 0) then
            return 1;
        end

        if (m.input & INPUT_NONZERO_ANALOG) ~= 0 then
            return set_mario_action(m, ACT_WALKING, 0);
        end

        if (m.input & INPUT_Z_PRESSED) ~= 0 then
            return set_mario_action(m, ACT_CROUCH_SLIDE, 0);
        end
    end

    if (update_decelerating_speed(m)) then
        return set_mario_action(m, ACT_IDLE, 0);
    end
    local stepResult = perform_ground_step(m)

    if(stepResult == GROUND_STEP_LEFT_GROUND) then
        set_mario_action(m, ACT_FREEFALL, 0);
    elseif(stepResult == GROUND_STEP_HIT_WALL) then
        if (slopeClass == SURFACE_CLASS_VERY_SLIPPERY) then
            mario_bonk_reflection(m, 1);
        else
            mario_set_forward_vel(m, 0.0);
        end
    end

    if (slopeClass == SURFACE_CLASS_VERY_SLIPPERY) then
        set_character_animation(m, CHAR_ANIM_IDLE_HEAD_LEFT);
        play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject);
        adjust_sound_for_speed(m);
        set_mario_particle_flags(m, PARTICLE_DUST, 0);
    else
        -- (Speed Crash) Crashes if speed exceeds 2^17.
        val0C = (m.forwardVel / 4.0 * 0x10000)
        if (val0C < 0x1000) then
            val0C = 0x1000;
        end

        set_character_anim_with_accel(m, CHAR_ANIM_WALKING, val0C);
        play_step_sound(m, 10, 49);
    end

    return 0;
end

function act_braking(m)
    local charStats = get_character_stats(m.playerIndex)
    if ((m.input & INPUT_FIRST_PERSON) == 0
        and (m.input
            & (INPUT_NONZERO_ANALOG | INPUT_A_PRESSED | INPUT_OFF_FLOOR | INPUT_ABOVE_SLIDE)) ~= 0) then
        return check_common_action_exits(m);
    end

    if (apply_slope_decel(m, 2.0 * charStats.groundFriction) ~= 0) then
        return set_mario_action(m, ACT_BRAKING_STOP, 0);
    end

    if (m.input & INPUT_B_PRESSED) ~= 0 then
        return set_mario_action(m, ACT_MOVE_PUNCHING, 0);
    end

    local stepResult = perform_ground_step(m)

    if(stepResult == GROUND_STEP_LEFT_GROUND) then
        set_mario_action(m, ACT_FREEFALL, 0);
    elseif(stepResult == GROUND_STEP_NONE) then
        set_mario_particle_flags(m, PARTICLE_DUST, 0);
    elseif(stepResult == GROUND_STEP_HIT_WALL) then
        slide_bonk(m, ACT_BACKWARD_GROUND_KB, ACT_BRAKING_STOP);
    end

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject);
    adjust_sound_for_speed(m);
    set_character_animation(m, CHAR_ANIM_SKID_ON_GROUND);
    return 0;
end

function act_turning_around(m)
    local charStats = get_character_stats(m.playerIndex)
    if (m.input & INPUT_ABOVE_SLIDE) ~= 0 then
        return set_mario_action(m, ACT_BEGIN_SLIDING, 0);
    end

    if (m.input & INPUT_A_PRESSED) ~= 0 then
        return set_jumping_action(m, ACT_SIDE_FLIP, 0);
    end

    if (m.input & INPUT_ZERO_MOVEMENT) ~= 0 then
        return set_mario_action(m, ACT_BRAKING, 0);
    end

    if (analog_stick_held_back(m) == 0) then
        return set_mario_action(m, ACT_WALKING, 0);
    end

    if (apply_slope_decel(m, 2.0 * charStats.groundFriction) ~= 0) then
        return begin_walking_action(m, 8.0, ACT_FINISH_TURNING_AROUND, 0);
    end

    play_sound(SOUND_MOVING_TERRAIN_SLIDE + m.terrainSoundAddend, m.marioObj.header.gfx.cameraToObject);

    adjust_sound_for_speed(m);

    local stepResult = perform_ground_step(m)

    if(stepResult == GROUND_STEP_LEFT_GROUND) then
        set_mario_action(m, ACT_FREEFALL, 0);
    elseif(stepResult == GROUND_STEP_NONE) then
        set_mario_particle_flags(m, PARTICLE_DUST, 0);
    end

    if (m.forwardVel >= 18.0) then
        set_character_animation(m, CHAR_ANIM_TURNING_PART1);
    else
        set_character_animation(m, CHAR_ANIM_TURNING_PART2);
        if (is_anim_at_end(m) ~= 0) then
            if (m.forwardVel > 0) then
                begin_walking_action(m, -m.forwardVel, ACT_WALKING, 0);
            else
                begin_walking_action(m, 8.0, ACT_WALKING, 0);
            end
        end
    end

    return 0;
end

function set_body_tilt_walking(m, startYaw)
    local dYaw = m.faceAngle.y - startYaw;
    --! (Speed Crash) These casts can cause a crash if (dYaw * forwardVel / 12) or
    --! (forwardVel * 170) exceed or equal 2^31.
    -- (hi, HyperCat here. I have no idea if it crashes when done in Lua. Those comments are from the ported C code..)
    local charStats = get_character_stats(m.playerIndex)
    local val02 = -(dYaw * m.forwardVel / 12.0) * charStats.runTiltMul;
    local val00 = (m.forwardVel * 170.0) * charStats.runTiltMul;

    if (val02 > 0x1555) then
        val02 = 0x1555;
    end
    if (val02 < -0x1555) then
        val02 = -0x1555;
    end

    if (val00 > 0x1555) then
        val00 = 0x1555;
    end
    if (val00 < 0) then
        val00 = 0;
    end

    m.marioBodyState.torsoAngle.z = approach_s32(m.marioBodyState.torsoAngle.z, val02, 0x400, 0x400);
    m.marioBodyState.torsoAngle.x = approach_s32(m.marioBodyState.torsoAngle.x, val00, 0x400, 0x400);
    m.marioBodyState.allowPartRotation = 1;
end

function reset_body_tilt(m)
    m.marioBodyState.torsoAngle.z = 0
    m.marioBodyState.torsoAngle.x = 0
    m.marioBodyState.allowPartRotation = 0;
end

-- stolen from Arena
function convert_s16(num)
    local min = -32768
    local max = 32767
    while (num < min) do
        num = max + (num - min)
    end
    while (num > max) do
        num = min + (num - max)
    end
    return num
end

function act_forward_ground_kb_stun(m)
    common_ground_knockback_action(m, CHAR_ANIM_FORWARD_KB, 20, 1, 0);
    if(m.marioObj.header.gfx.animInfo.animFrame >= 10) then
        set_anim_to_frame(m, 10)
    end
    m.hurtCounter = 0
    m.invincTimer = 0
    m.actionArg = 0
    for i = 0, (MAX_PLAYERS - 1) do
        if(m.playerIndex ~= i) then
            if(gNetworkPlayers[i].connected) then
                other = gMarioStates[i] ---@type MarioState
                s = gPlayerSyncTable[i]
                if(obj_check_hitbox_overlap(m.marioObj, other.marioObj) and other.action == ACT_PUNCHING) then
                    s.heldByPlayerIndex = network_global_index_from_local(i);
                    m.pos.x = get_hand_foot_pos_x(other, 0)
                    m.pos.y = get_hand_foot_pos_y(other, 0)
                    m.pos.z = get_hand_foot_pos_z(other, 0)
                    set_mario_action(other, ACT_PICKING_UP, 0)
                    set_mario_action(m, ACT_HELD_BY_PLAYER, i)
                    return 1;
                end
            end
        end
    end

    return 0;
end

function act_held_by_player(m)
    s = gPlayerSyncTable[m.playerIndex]
    if(m.playerIndex == 0) then
        s.heldByPlayerIndex = network_global_index_from_local(m.actionArg);
    end
    heldBy = gMarioStates[network_local_index_from_global(s.heldByPlayerIndex)]
    if(heldBy ~= nil) then -- this check prevents a script error on the frame someone gets picked up
        -- averaged position between both hands
        m.pos.x = (get_hand_foot_pos_x(heldBy, 0) + get_hand_foot_pos_x(heldBy, 1)) / 2
        m.pos.y = (get_hand_foot_pos_y(heldBy, 0) + get_hand_foot_pos_y(heldBy, 1)) / 2
        m.pos.z = (get_hand_foot_pos_z(heldBy, 0) + get_hand_foot_pos_z(heldBy, 1)) / 2
        m.faceAngle.y = heldBy.faceAngle.y;

        if(heldBy.action == ACT_AIR_THROW or heldBy.action == ACT_THROWING) then
            m.forwardVel = 35
            m.vel.y = 20
            set_mario_action(m, ACT_THROWN_FORWARD, 0)
        elseif not (heldBy.action == ACT_HOLD_FREEFALL or heldBy.action == ACT_HOLD_WALKING or heldBy.action == ACT_HOLD_DECELERATING or heldBy.action == ACT_HOLD_IDLE or heldBy.action == ACT_HOLD_JUMP or heldBy.action == ACT_HOLD_JUMP_LAND or heldBy.action == ACT_HOLD_JUMP_LAND_STOP) then
            set_mario_action(m, ACT_FREEFALL, 0) -- todo: make an ACT_LIST for this check instead of... this...
        end
    end
    vec3f_copy(m.marioObj.header.gfx.pos, m.pos);
    vec3s_set(m.marioObj.header.gfx.angle, 0, m.faceAngle.y, 0);
end

hook_mario_action(ACT_FORWARD_GROUND_KB_STUN, act_forward_ground_kb_stun)
hook_mario_action(ACT_HELD_BY_PLAYER, act_held_by_player)


hook_mario_action(ACT_FALL_AFTER_STAR_GRAB, act_fall_after_star_grab)
hook_mario_action(ACT_STAR_DANCE_VS, act_star_dance)

-- if another mod decides to overwrite these, it's not my problem. 
hook_mario_action(ACT_WALKING, act_walking)
hook_mario_action(ACT_DECELERATING, act_decelerating)
hook_mario_action(ACT_TURNING_AROUND, act_turning_around)
hook_mario_action(ACT_BRAKING, act_braking)
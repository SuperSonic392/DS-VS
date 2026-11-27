VS_DEBUG_MODE = true -- todo: a way to enable/disable this mid-game so that playtests don't devolve into people spawning a krillion caps. 

FULL_ROTATION = 65536 -- the amount of times I've copy/pasted this definition into my mods needs to be studied. 

-- changing these just works without CS, and the only thing that CS breaks is the voice. 
CHAR_NUM_TOAD = CT_TOAD -- when getting a random hat, if it lands on Toad, we replace it with Mario. 
CHAR_NUM_DEFAULT = CT_TOAD -- the only reason this is separate is because of Extra Characters Plus, before I modified CS to allow me to force disable movesets. 

function load_jump_voc()
	return load_voc(0x00, 0x02)
end

function load_pant_voc()
	return load_voc(0x18, 0x1A)
end

function load_yahoo_haha_yippee_voc()
	return load_voc(0x2B, 0x2F)
end

function load_voc(rangeX, rangeY)
	-- Not sure how much spamming this costs. I should probably look into it. 
	return SOUND_ARG_LOAD(SOUND_BANK_TOAD_VOICE, math.random(rangeX, rangeY), 0x80, SOUND_NO_PRIORITY_LOSS | SOUND_DISCRETE)
end

VOICETABLE_TOAD = {
    [CHAR_SOUND_OKEY_DOKEY] =        gCharacters[CT_TOAD].soundOkeyDokey,
	[CHAR_SOUND_LETS_A_GO] =         gCharacters[CT_TOAD].soundLetsAGo,
	[CHAR_SOUND_GAME_OVER] =         gCharacters[CT_TOAD].soundGameOver,
	[CHAR_SOUND_PUNCH_YAH] =         gCharacters[CT_TOAD].soundPunchYah,
	[CHAR_SOUND_PUNCH_WAH] =         gCharacters[CT_TOAD].soundPunchWah,
	[CHAR_SOUND_PUNCH_HOO] =         gCharacters[CT_TOAD].soundPunchHoo,
	[CHAR_SOUND_YAH_WAH_HOO] =       load_jump_voc, -- for some reason, CS keels over and dies if you try to give it a table with multiple vanilla sounds, lol
	[CHAR_SOUND_HOOHOO] =            gCharacters[CT_TOAD].soundHoohoo,
	[CHAR_SOUND_YAHOO_WAHA_YIPPEE] = load_yahoo_haha_yippee_voc, -- being able to use functions is really cool though. 
	[CHAR_SOUND_UH] =                gCharacters[CT_TOAD].soundUh,
	[CHAR_SOUND_UH2] =               gCharacters[CT_TOAD].soundUh2,
	[CHAR_SOUND_UH2_2] =             gCharacters[CT_TOAD].soundUh2_2,
	[CHAR_SOUND_DOH] =               gCharacters[CT_TOAD].soundDoh,
	[CHAR_SOUND_OOOF] =              gCharacters[CT_TOAD].soundOoof,
	[CHAR_SOUND_OOOF2] =             gCharacters[CT_TOAD].soundOoof2,
	[CHAR_SOUND_HAHA] =              gCharacters[CT_TOAD].soundHaha,
	[CHAR_SOUND_HAHA_2] =            gCharacters[CT_TOAD].soundHaha_2,
	[CHAR_SOUND_YAHOO] =             gCharacters[CT_TOAD].soundYahoo,
	[CHAR_SOUND_DOH] =               gCharacters[CT_TOAD].soundDoh,
	[CHAR_SOUND_WHOA] =              gCharacters[CT_TOAD].soundWhoa,
	[CHAR_SOUND_EEUH] =              gCharacters[CT_TOAD].soundEeuh,
	[CHAR_SOUND_WAAAOOOW] =          gCharacters[CT_TOAD].soundWaaaooow,
	[CHAR_SOUND_TWIRL_BOUNCE] =      gCharacters[CT_TOAD].soundTwirlBounce,
	[CHAR_SOUND_GROUND_POUND_WAH] =  gCharacters[CT_TOAD].soundGroundPoundWah,
	[CHAR_SOUND_WAH2] =              gCharacters[CT_TOAD].soundWah2,
	[CHAR_SOUND_HRMM] =              gCharacters[CT_TOAD].soundHrmm,
	[CHAR_SOUND_HERE_WE_GO] =        gCharacters[CT_TOAD].soundHereWeGo,
	[CHAR_SOUND_SO_LONGA_BOWSER] =   gCharacters[CT_TOAD].soundSoLongaBowser,
--DAMAGE
	[CHAR_SOUND_ATTACKED] =          gCharacters[CT_TOAD].soundAttacked,
	[CHAR_SOUND_PANTING] =           load_pant_voc, -- you are always at max health in this mode, so I'm 99% sure this is impossible to play
	[CHAR_SOUND_PANTING_COLD] =      gCharacters[CT_TOAD].soundPantingCold,
	[CHAR_SOUND_ON_FIRE] =           gCharacters[CT_TOAD].soundOnFire,
--SLEEP SOUNDS
	[CHAR_SOUND_IMA_TIRED] =         gCharacters[CT_TOAD].soundImaTired, -- these cause script errors somehow. I got around it by just preventing the player from sleeping. 
	[CHAR_SOUND_YAWNING] =           gCharacters[CT_TOAD].soundYawning,
	[CHAR_SOUND_SNORING1] =          gCharacters[CT_TOAD].soundSnoring1,
	[CHAR_SOUND_SNORING2] =          gCharacters[CT_TOAD].soundSnoring2,
	[CHAR_SOUND_SNORING3] =          gCharacters[CT_TOAD].soundSnoring3,
--COUGHING (USED IN THE GAS MAZE)
	[CHAR_SOUND_COUGHING1] =         gCharacters[CT_TOAD].soundCoughing1,
	[CHAR_SOUND_COUGHING2] =         gCharacters[CT_TOAD].soundCoughing2,
	[CHAR_SOUND_COUGHING3] =         gCharacters[CT_TOAD].soundCoughing3,
--DEATH
	[CHAR_SOUND_DYING] =             gCharacters[CT_TOAD].soundDying,
	[CHAR_SOUND_DROWNING] =          gCharacters[CT_TOAD].soundDrowning,
	[CHAR_SOUND_MAMA_MIA] =          gCharacters[CT_TOAD].soundMamaMia,
}

-- used to detect taking damage. probably not needed anymore because this was intended to filter out fall damage, which I made not damage you anyway. 
-- I need to rework that entire system anyway. 
-- This list also contains duplicated keys, but I don't really give a shit. 
-- Whenver I do lists like this, it's so that I can check it by just doing: if(ACT_LIST_KNOCKBACK[m.action] == true)
ACT_LIST_KNOCKBACK = {
    [ACT_SOFT_FORWARD_GROUND_KB] = true, [ACT_FORWARD_GROUND_KB] = true, [ACT_HARD_FORWARD_GROUND_KB] = true,
    [ACT_FORWARD_AIR_KB] = true,         [ACT_FORWARD_AIR_KB] = true,    [ACT_HARD_FORWARD_AIR_KB] = true,
    [ACT_FORWARD_WATER_KB] = true,       [ACT_FORWARD_WATER_KB] = true,  [ACT_FORWARD_WATER_KB] = true,
    [ACT_SOFT_BACKWARD_GROUND_KB] = true, [ACT_BACKWARD_GROUND_KB] = true, [ACT_HARD_BACKWARD_GROUND_KB] = true,
    [ACT_BACKWARD_AIR_KB] = true,         [ACT_BACKWARD_AIR_KB] = true,    [ACT_HARD_BACKWARD_AIR_KB] = true,
    [ACT_BACKWARD_WATER_KB] = true,       [ACT_BACKWARD_WATER_KB] = true,  [ACT_BACKWARD_WATER_KB] = true,
};

-- Character Ability enum values and stuff
CA_NONE = 0
CA_WALLKICK = 1
CA_SCUTTLEJUMP = 2
CA_STUNPUNCH = 3
CA_SPRINGSTEP = 4

CHAR_STATS_MARIO = { -- all 'rounder
	charAbility = CA_WALLKICK,
	canDive = true, -- for some reason I didn't feel like making this a Character Ability
	jumpHeight = 1, -- multiplier
	maxSpeed = 32, -- the speed at which the character walks in ACT_WALKING
	terminalVelocity = 48, -- the absolute max speed the character is allowed to have in ACT_WALKING
	walkingSub = 43, -- something something acceleration curve. 
	acceleration = 1.1,
	groundFriction = 1,
	runAnim = nil,
	runTiltMul = 1,
}

CHAR_STATS_LUIGI = { -- jumps high, lower ground friction
	charAbility = CA_SCUTTLEJUMP,
	canDive = true,
	jumpHeight = 1.1,
	maxSpeed = 32,
	terminalVelocity = 48,
	walkingSub = 43,
	acceleration = 1.1,
	groundFriction = 0.5,
	runAnim = "LUIGI_ANIM_RUNNING",
	runTiltMul = .5,
}

CHAR_STATS_TOAD = { -- default character. 
	charAbility = CA_NONE,
	canDive = false, -- this makes it REALLY easy to silly kick, lol
	jumpHeight = 0.9,
	maxSpeed = 40,
	terminalVelocity = 52,
	walkingSub = 43,
	acceleration = 1.1,
	groundFriction = 1,
	runAnim = nil,
	runTiltMul = 1,
}

CHAR_STATS_WARIO = { -- strong but otherwise bad
	charAbility = CA_STUNPUNCH,
	canDive = true,
	jumpHeight = 0.8,
	maxSpeed = 28,
	terminalVelocity = 48,
	walkingSub = 43,
	acceleration = 1.1,
	groundFriction = 1,
	runAnim = nil,
}

CHAR_STATS_WALUIGI = { -- "What a cheater!" - Purple Prizes
	charAbility = CA_SPRINGSTEP,
	canDive = true,
	jumpHeight = 1,
	maxSpeed = 40,
	terminalVelocity = 120,
	walkingSub = 64,
	acceleration = 1,
	groundFriction = 1,
	runAnim = nil,
	runTiltMul = .6,
}

CHAR_STATS_CS = { -- default stats, for Character Select characters. 
	charAbility = CA_NONE,
	canDive = true,
	jumpHeight = 1,
	maxSpeed = 32,
	terminalVelocity = 48,
	walkingSub = 43,
	acceleration = 1.1,
	groundFriction = 1,
	runAnim = nil,
	runTiltMul = 1,
}


CHAR_STAT_LIST = {CHAR_STATS_MARIO, CHAR_STATS_LUIGI, CHAR_STATS_TOAD, CHAR_STATS_WALUIGI, CHAR_STATS_WARIO, CHAR_STATS_CS}

function get_character_stats(playerIndex)
	charNum = player_get_character(playerIndex)
	if(not gNetworkPlayers[playerIndex].connected) then -- hurray, this isn't causing script errors anymore
		return CHAR_STATS_CS
	end
 	if(charNum + 1 > 6) then -- ah, + 1 my beloved. SMLUA's indexing confusion is just funny to me at this point I think I've officially lost it. 
		return CHAR_STATS_CS
	end
	return CHAR_STAT_LIST[charNum + 1]
end

-- non-cs vanilla palette list
-- the actual palettes were stolen from the CS palette list, sorry Squishy. 
PALETTE_LIST = {
        { -- mario
            [PANTS]  = { r = 0x00, g = 0x00, b = 0xff },
            [SHIRT]  = { r = 0xff, g = 0x00, b = 0x00 },
            [GLOVES] = { r = 0xff, g = 0xff, b = 0xff },
            [SHOES]  = { r = 0x72, g = 0x1c, b = 0x0e },
            [HAIR]   = { r = 0x73, g = 0x06, b = 0x00 },
            [SKIN]   = { r = 0xfe, g = 0xc1, b = 0x79 },
            [CAP]    = { r = 0xff, g = 0x00, b = 0x00 },
            [EMBLEM] = { r = 0xff, g = 0x00, b = 0x00 },
        },
        { -- luigi
            [PANTS]  = { r = 0x00, g = 0x00, b = 0xff },
            [SHIRT]  = { r = 0x00, g = 0xff, b = 0x00 },
            [GLOVES] = { r = 0xff, g = 0xff, b = 0xff },
            [SHOES]  = { r = 0x72, g = 0x1c, b = 0x0e },
            [HAIR]   = { r = 0x73, g = 0x06, b = 0x00 },
            [SKIN]   = { r = 0xfe, g = 0xc1, b = 0x79 },
            [CAP]    = { r = 0x00, g = 0xff, b = 0x00 },
            [EMBLEM] = { r = 0x00, g = 0xff, b = 0x00 },
        },
        { -- toad (unused because he's the default character)
            [PANTS]  = { r = 0xff, g = 0xff, b = 0xff },
            [SHIRT]  = { r = 0x4c, g = 0x2c, b = 0xd3 },
            [GLOVES] = { r = 0xff, g = 0xff, b = 0xff },
            [SHOES]  = { r = 0x68, g = 0x40, b = 0x1b },
            [HAIR]   = { r = 0x73, g = 0x06, b = 0x00 },
            [SKIN]   = { r = 0xfe, g = 0xd5, b = 0xa1 },
            [CAP]    = { r = 0xff, g = 0x00, b = 0x00 },
            [EMBLEM] = { r = 0xff, g = 0x00, b = 0x00 },
        },
        { -- waluigi
            [PANTS]  = { r = 0x16, g = 0x16, b = 0x27 },
            [SHIRT]  = { r = 0x61, g = 0x26, b = 0xb0 },
            [GLOVES] = { r = 0xff, g = 0xff, b = 0xff },
            [SHOES]  = { r = 0xfe, g = 0x76, b = 0x00 },
            [HAIR]   = { r = 0x73, g = 0x53, b = 0x00 },
            [SKIN]   = { r = 0xfe, g = 0xc1, b = 0x79 },
            [CAP]    = { r = 0x61, g = 0x26, b = 0xb0 },
            [EMBLEM] = { r = 0xff, g = 0xde, b = 0x00 },
        },
        { -- wario
            [PANTS]  = { r = 0x7f, g = 0x20, b = 0x7a },
            [SHIRT]  = { r = 0xff, g = 0xbd, b = 0x00 },
            [GLOVES] = { r = 0xff, g = 0xff, b = 0xff },
            [SHOES]  = { r = 0x0e, g = 0x72, b = 0x1c },
            [HAIR]   = { r = 0x73, g = 0x53, b = 0x00 },
            [SKIN]   = { r = 0xfe, g = 0xc1, b = 0x79 },
            [CAP]    = { r = 0xff, g = 0xbd, b = 0x00 },
            [EMBLEM] = { r = 0x00, g = 0x00, b = 0xff },
        },
}
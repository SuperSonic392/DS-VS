#include <ultra64.h>
#include "sm64.h"
#include "behavior_data.h"
#include "model_ids.h"
#include "seq_ids.h"
#include "dialog_ids.h"
#include "segment_symbols.h"
#include "level_commands.h"

#include "game/level_update.h"

#include "levels/scripts.h"

#include "make_const_nonconst.h"
#include "levels/vs_castle_grounds/header.h"

/* Fast64 begin persistent block [scripts] */
/* Fast64 end persistent block [scripts] */

const LevelScript level_vs_castle_grounds_entry[] = {
	INIT_LEVEL(),
	LOAD_MIO0(0x7, _vs_castle_grounds_segment_7SegmentRomStart, _vs_castle_grounds_segment_7SegmentRomEnd), 
	LOAD_MIO0(0xa, _water_skybox_mio0SegmentRomStart, _water_skybox_mio0SegmentRomEnd), 
	ALLOC_LEVEL_POOL(),
	MARIO(MODEL_MARIO, 0x00000001, bhvMario), 
	/* Fast64 begin persistent block [level commands] */
	/* Fast64 end persistent block [level commands] */

	AREA(1, vs_castle_grounds_area_1),
		WARP_NODE(0x0A, LEVEL_WF, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF3, LEVEL_CASTLE, 0x01, 0x20, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF0, LEVEL_CASTLE, 0x01, 0x26, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF1, LEVEL_CASTLE, 0x01, 0x23, WARP_NO_CHECKPOINT),
		OBJECT(MODEL_NONE, -5812, 100, -5937, 90, 0, 0, 0x00000000, bhvWaterfallSoundLoop),
		OBJECT(E_MODEL_BUBBLY_TREE, -1333, 711, 1881, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -2566, 438, 2626, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -1900, 401, 2868, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 6399, 494, -1680, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 767, 498, 2598, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 1476, 189, 3280, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 3153, 206, 469, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 6178, 219, 167, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 5457, 528, -3259, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 5868, 698, -4453, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 6408, 869, -5314, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -4711, 342, 433, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 1132, 365, 1977, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -5506, 364, -661, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -6269, 402, -2145, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -5600, 440, -2627, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 1919, 268, 1157, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -5957, 517, -3447, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -2021, 633, 1468, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -109, 613, 3008, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 5774, 413, -1114, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, 5954, 526, -2846, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_BUBBLY_TREE, -5204, 296, 811, 0, 0, 0, 0x00000000, bhvTree),
		OBJECT(E_MODEL_CASTLE_GROUNDS_FLAG, -3213, 3348, -3011, 0, 0, 0, 0x00000000, bhvCastleFlagWaving),
		OBJECT(E_MODEL_CASTLE_GROUNDS_FLAG, 3213, 3348, -3011, 0, 0, 0, 0x00000000, bhvCastleFlagWaving),
		OBJECT(E_MODEL_CASTLE_GROUNDS_FLAG, -3835, 3348, -6647, 0, 0, 0, 0x00000000, bhvCastleFlagWaving),
		OBJECT(E_MODEL_CASTLE_GROUNDS_FLAG, 3835, 3348, -6647, 0, 0, 0, 0x00000000, bhvCastleFlagWaving),
		OBJECT(E_MODEL_MIST, -4494, -1176, -5853, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -4659, -1176, -5663, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -4824, -1176, -5474, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -4964, -1176, -5223, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -5104, -1176, -4973, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -5255, -1176, -4788, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -5407, -1176, -4604, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -5538, -1176, -4512, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_MIST, -5663, -1176, -4443, 90, 0, 1, 0x00000000, bhvWaterMist2),
		OBJECT(E_MODEL_BUTTERFLY, -4508, 406, 4400, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, -4408, 406, 4500, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, -4708, 406, 4100, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, -6003, 473, -2621, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, -6003, 473, -2321, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, 6543, 461, -617, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, 6143, 461, -617, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, 5773, 775, -5722, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, 5873, 775, -5622, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, 5473, 775, -5322, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, -1504, 326, 3196, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, -1204, 326, 3296, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, -6240, 295, 320, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_BUTTERFLY, 6330, 710, -3760, 0, 0, 0, 0x00000000, bhvButterfly),
		OBJECT(E_MODEL_CHAIN_CHOMP, -5385, 1353, -2022, 0, 0, 0, (0 << 24), bhvUnchainedChomp),
		OBJECT(MODEL_NONE, 6503, 777, -2271, 0, 0, 0, 0x00000000, id_bhvNormalCap),
		OBJECT(MODEL_NONE, -5609, 458, 2854, 0, 0, 0, 0x00000000, id_bhvNormalCap),
		OBJECT(MODEL_NONE, -5674, 458, -424, 0, 0, 0, 0x00000000, id_bhvNormalCap),
		OBJECT(MODEL_NONE, 5858, 777, -3254, 0, 0, 0, 0x00000000, id_bhvNormalCap),
		OBJECT(MODEL_NONE, 2575, 56, 1576, 0, 0, 0, 0x00000000, id_bhvNormalCap),
		OBJECT(MODEL_STAR, 0, 1108, 973, 0, 0, 0, (0x1 << 24), bhvStar),
		OBJECT(MODEL_STAR, 6400, 1361, -1681, 0, 0, 0, (0x2 << 24), bhvStar),
		OBJECT(MODEL_STAR, -5819, 697, 3179, 0, 0, 0, (0x3 << 24), bhvStar),
		OBJECT(MODEL_NONE, -1328, 260, 4664, 0, 180, 0, (10 << 16), bhvAirborneWarp),
		TERRAIN(vs_castle_grounds_area_1_collision),
		MACRO_OBJECTS(vs_castle_grounds_area_1_macro_objs),
		SET_BACKGROUND_MUSIC(0x00, SEQ_LEVEL_SLIDE),
		TERRAIN_TYPE(TERRAIN_GRASS),
		/* Fast64 begin persistent block [area commands] */
		/* Fast64 end persistent block [area commands] */
	END_AREA(),
	FREE_LEVEL_POOL(),
	MARIO_POS(1, 0, 0, 0, 0),
	CALL(0, lvl_init_or_update),
	CALL_LOOP(1, lvl_init_or_update),
	CLEAR_LEVEL(),
	SLEEP_BEFORE_EXIT(1),
	EXIT(),
};
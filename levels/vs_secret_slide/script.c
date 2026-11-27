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
#include "levels/vs_secret_slide/header.h"

/* Fast64 begin persistent block [scripts] */
/* Fast64 end persistent block [scripts] */

const LevelScript level_vs_secret_slide_entry[] = {
	INIT_LEVEL(),
	LOAD_MIO0(0x7, _vs_secret_slide_segment_7SegmentRomStart, _vs_secret_slide_segment_7SegmentRomEnd), 
	LOAD_MIO0(0xa, _water_skybox_mio0SegmentRomStart, _water_skybox_mio0SegmentRomEnd), 
	ALLOC_LEVEL_POOL(),
	MARIO(MODEL_MARIO, 0x00000001, bhvMario), 
	/* Fast64 begin persistent block [level commands] */
	/* Fast64 end persistent block [level commands] */

	AREA(1, vs_secret_slide_area_1),
		WARP_NODE(0x0A, level_vs_secret_slide_entry, 0x01, 0x0A, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF3, level_vs_secret_slide_entry, 0x01, 0x20, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF0, level_vs_secret_slide_entry, 0x01, 0x26, WARP_NO_CHECKPOINT),
		WARP_NODE(0xF1, level_vs_secret_slide_entry, 0x01, 0x23, WARP_NO_CHECKPOINT),
		OBJECT(MODEL_NONE, 5416, 6892, -5582, 0, -90, 0, (10 << 16), bhvAirborneWarp),
		TERRAIN(vs_secret_slide_area_1_collision),
		MACRO_OBJECTS(vs_secret_slide_area_1_macro_objs),
		SET_BACKGROUND_MUSIC(0x00, SEQ_LEVEL_SLIDE),
		TERRAIN_TYPE(TERRAIN_SLIDE),
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
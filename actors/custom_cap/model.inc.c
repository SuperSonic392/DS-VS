Lights1 custom_cap_Cap__CAP__lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 custom_cap_Cap_Inside__CAP__lights = gdSPDefLights1(
	0x7F, 0x7F, 0x7F,
	0xFF, 0xFF, 0xFF, 0x28, 0x28, 0x28);

Lights1 custom_cap_Logo__EMBLEM__layer2_lights = gdSPDefLights1(
	0x0, 0x0, 0x0,
	0x0, 0x0, 0x0, 0x28, 0x28, 0x28);

Texture custom_cap_innn_rgba32[] = {
	#include "actors/custom_cap/innn.rgba32.inc.c"
};

Texture custom_cap_custom_mario_logo_blend_rgba32[] = {
	#include "actors/custom_cap/custom_mario_logo_blend.rgba32.inc.c"
};

Vtx custom_cap_Cap_DL_mesh_layer_1_vtx_0[35] = {
	{{{31, 35, 118}, 0, {757, 760}, {0x32, 0x28, 0x6D, 0xFF}}},
	{{{95, 22, 46}, 0, {1267, 883}, {0x44, 0xA1, 0x31, 0xFF}}},
	{{{70, 101, 113}, 0, {1063, 153}, {0x52, 0x27, 0x58, 0xFF}}},
	{{{0, 110, 143}, 0, {496, 68}, {0x00, 0x32, 0x75, 0xFF}}},
	{{{-31, 35, 118}, 0, {235, 760}, {0xCE, 0x28, 0x6D, 0xFF}}},
	{{{-70, 101, 113}, 0, {-71, 153}, {0xAE, 0x27, 0x58, 0xFF}}},
	{{{-95, 22, 46}, 0, {-275, 883}, {0xBC, 0xA1, 0x31, 0xFF}}},
	{{{31, 35, 118}, 0, {0, 0}, {0x32, 0x28, 0x6D, 0xFF}}},
	{{{66, 2, 139}, 0, {0, 0}, {0x59, 0xCA, 0x48, 0xFF}}},
	{{{95, 22, 46}, 0, {0, 0}, {0x44, 0xA1, 0x31, 0xFF}}},
	{{{0, 0, 163}, 0, {0, 0}, {0x00, 0xC8, 0x72, 0xFF}}},
	{{{-31, 35, 118}, 0, {0, 0}, {0xCE, 0x28, 0x6D, 0xFF}}},
	{{{-66, 2, 139}, 0, {0, 0}, {0xA7, 0xCA, 0x48, 0xFF}}},
	{{{-95, 22, 46}, 0, {0, 0}, {0xBC, 0xA1, 0x31, 0xFF}}},
	{{{-32, 17, 109}, 0, {0, 0}, {0x09, 0x84, 0xE4, 0xFF}}},
	{{{32, 17, 109}, 0, {0, 0}, {0xF7, 0x84, 0xE4, 0xFF}}},
	{{{-70, 101, 113}, 0, {0, 0}, {0xAE, 0x27, 0x58, 0xFF}}},
	{{{-135, 70, 23}, 0, {0, 0}, {0x85, 0x1A, 0x11, 0xFF}}},
	{{{-41, 144, 64}, 0, {0, 0}, {0xDB, 0x7A, 0x05, 0xFF}}},
	{{{0, 110, 143}, 0, {0, 0}, {0x00, 0x32, 0x75, 0xFF}}},
	{{{41, 144, 64}, 0, {0, 0}, {0x25, 0x7A, 0x05, 0xFF}}},
	{{{70, 101, 113}, 0, {0, 0}, {0x52, 0x27, 0x58, 0xFF}}},
	{{{135, 70, 23}, 0, {0, 0}, {0x7B, 0x1A, 0x11, 0xFF}}},
	{{{101, 10, -7}, 0, {0, 0}, {0x3D, 0x92, 0x14, 0xFF}}},
	{{{125, 38, -45}, 0, {0, 0}, {0x78, 0xF5, 0xD7, 0xFF}}},
	{{{86, 1, -60}, 0, {0, 0}, {0x35, 0x8E, 0xF1, 0xFF}}},
	{{{52, 0, -118}, 0, {0, 0}, {0x2A, 0xA4, 0xB3, 0xFF}}},
	{{{49, 62, -138}, 0, {0, 0}, {0x2B, 0x35, 0x95, 0xFF}}},
	{{{-49, 62, -138}, 0, {0, 0}, {0xD5, 0x35, 0x95, 0xFF}}},
	{{{-52, 0, -118}, 0, {0, 0}, {0xD6, 0xA4, 0xB3, 0xFF}}},
	{{{-125, 38, -45}, 0, {0, 0}, {0x88, 0xF5, 0xD7, 0xFF}}},
	{{{-86, 1, -60}, 0, {0, 0}, {0xCB, 0x8E, 0xF1, 0xFF}}},
	{{{-101, 10, -7}, 0, {0, 0}, {0xC3, 0x92, 0x14, 0xFF}}},
	{{{-76, 84, -60}, 0, {0, 0}, {0xCC, 0x69, 0xCF, 0xFF}}},
	{{{76, 84, -60}, 0, {0, 0}, {0x34, 0x69, 0xCF, 0xFF}}},
};

Gfx custom_cap_Cap_DL_mesh_layer_1_tri_0[] = {
	gsSPVertex(custom_cap_Cap_DL_mesh_layer_1_vtx_0 + 0, 35, 0),
	gsSP2Triangles(0, 1, 2, 0, 2, 3, 0, 0),
	gsSP2Triangles(3, 4, 0, 0, 3, 5, 4, 0),
	gsSP2Triangles(5, 6, 4, 0, 7, 8, 9, 0),
	gsSP2Triangles(7, 10, 8, 0, 11, 10, 7, 0),
	gsSP2Triangles(12, 10, 11, 0, 12, 11, 13, 0),
	gsSP2Triangles(14, 12, 13, 0, 14, 10, 12, 0),
	gsSP2Triangles(14, 15, 10, 0, 8, 10, 15, 0),
	gsSP2Triangles(9, 8, 15, 0, 13, 16, 17, 0),
	gsSP2Triangles(18, 17, 16, 0, 16, 19, 18, 0),
	gsSP2Triangles(18, 19, 20, 0, 20, 19, 21, 0),
	gsSP2Triangles(21, 22, 20, 0, 22, 21, 9, 0),
	gsSP2Triangles(22, 9, 23, 0, 23, 24, 22, 0),
	gsSP2Triangles(25, 24, 23, 0, 26, 24, 25, 0),
	gsSP2Triangles(26, 27, 24, 0, 28, 27, 26, 0),
	gsSP2Triangles(29, 28, 26, 0, 30, 28, 29, 0),
	gsSP2Triangles(31, 30, 29, 0, 32, 30, 31, 0),
	gsSP2Triangles(17, 30, 32, 0, 13, 17, 32, 0),
	gsSP2Triangles(17, 33, 30, 0, 33, 17, 18, 0),
	gsSP2Triangles(33, 18, 34, 0, 18, 20, 34, 0),
	gsSP2Triangles(20, 22, 34, 0, 24, 34, 22, 0),
	gsSP2Triangles(24, 27, 34, 0, 33, 34, 27, 0),
	gsSP2Triangles(27, 28, 33, 0, 33, 28, 30, 0),
	gsSPEndDisplayList(),
};

Vtx custom_cap_Cap_DL_mesh_layer_1_vtx_1[10] = {
	{{{95, 22, 46}, 0, {0, 0}, {0x44, 0xA1, 0x31, 0xFF}}},
	{{{32, 17, 109}, 0, {0, 0}, {0xF7, 0x84, 0xE4, 0xFF}}},
	{{{-32, 17, 109}, 0, {0, 0}, {0x09, 0x84, 0xE4, 0xFF}}},
	{{{-95, 22, 46}, 0, {0, 0}, {0xBC, 0xA1, 0x31, 0xFF}}},
	{{{-101, 10, -7}, 0, {0, 0}, {0xC3, 0x92, 0x14, 0xFF}}},
	{{{101, 10, -7}, 0, {0, 0}, {0x3D, 0x92, 0x14, 0xFF}}},
	{{{86, 1, -60}, 0, {0, 0}, {0x35, 0x8E, 0xF1, 0xFF}}},
	{{{-86, 1, -60}, 0, {0, 0}, {0xCB, 0x8E, 0xF1, 0xFF}}},
	{{{-52, 0, -118}, 0, {0, 0}, {0xD6, 0xA4, 0xB3, 0xFF}}},
	{{{52, 0, -118}, 0, {0, 0}, {0x2A, 0xA4, 0xB3, 0xFF}}},
};

Gfx custom_cap_Cap_DL_mesh_layer_1_tri_1[] = {
	gsSPVertex(custom_cap_Cap_DL_mesh_layer_1_vtx_1 + 0, 10, 0),
	gsSP2Triangles(0, 1, 2, 0, 0, 2, 3, 0),
	gsSP2Triangles(4, 0, 3, 0, 5, 0, 4, 0),
	gsSP2Triangles(6, 5, 4, 0, 6, 4, 7, 0),
	gsSP2Triangles(6, 7, 8, 0, 8, 9, 6, 0),
	gsSPEndDisplayList(),
};

Vtx custom_cap_Cap_DL_mesh_layer_2_vtx_0[7] = {
	{{{31, 35, 118}, 0, {757, 760}, {0x32, 0x28, 0x6D, 0xFF}}},
	{{{95, 22, 46}, 0, {1267, 883}, {0x44, 0xA1, 0x31, 0xFF}}},
	{{{70, 101, 113}, 0, {1063, 153}, {0x52, 0x27, 0x58, 0xFF}}},
	{{{0, 110, 143}, 0, {496, 68}, {0x00, 0x32, 0x75, 0xFF}}},
	{{{-31, 35, 118}, 0, {235, 760}, {0xCE, 0x28, 0x6D, 0xFF}}},
	{{{-70, 101, 113}, 0, {-71, 153}, {0xAE, 0x27, 0x58, 0xFF}}},
	{{{-95, 22, 46}, 0, {-275, 883}, {0xBC, 0xA1, 0x31, 0xFF}}},
};

Gfx custom_cap_Cap_DL_mesh_layer_2_tri_0[] = {
	gsSPVertex(custom_cap_Cap_DL_mesh_layer_2_vtx_0 + 0, 7, 0),
	gsSP2Triangles(0, 1, 2, 0, 2, 3, 0, 0),
	gsSP2Triangles(3, 4, 0, 0, 3, 5, 4, 0),
	gsSP1Triangle(5, 6, 4, 0),
	gsSPEndDisplayList(),
};


Gfx mat_custom_cap_Cap__CAP_[] = {
	gsSPCopyLightsPlayerPart(SHIRT),
	gsDPPipeSync(),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPEndDisplayList(),
};

Gfx mat_revert_custom_cap_Cap__CAP_[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_custom_cap_Cap_Inside__CAP_[] = {
	gsSPCopyLightsPlayerPart(SHIRT),
	gsDPPipeSync(),
	gsDPSetCombineLERP(SHADE, 0, PRIMITIVE, 0, 0, 0, 0, ENVIRONMENT, SHADE, 0, PRIMITIVE, 0, 0, 0, 0, ENVIRONMENT),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsDPSetPrimColor(0, 0, 115, 115, 115, 255),
	gsSPEndDisplayList(),
};

Gfx mat_revert_custom_cap_Cap_Inside__CAP_[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsSPEndDisplayList(),
};

Gfx mat_custom_cap_Logo__EMBLEM__layer2[] = {
	gsSPSetLights1(custom_cap_Logo__EMBLEM__layer2_lights),
	gsDPPipeSync(),
	gsDPSetCombineLERP(TEXEL0, SHADE, TEXEL1, SHADE, TEXEL0, 0, ENVIRONMENT, 0, TEXEL0, SHADE, TEXEL1, SHADE, TEXEL0, 0, ENVIRONMENT, 0),
	gsDPSetAlphaDither(G_AD_NOISE),
	gsDPSetRenderMode(G_RM_AA_ZB_XLU_SURF, G_RM_AA_ZB_XLU_SURF2),
	gsSPTexture(65535, 65535, 0, 0, 1),
	gsSPCopyPlayerPartToColor(G_COL_ENV, 6, 1),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, custom_cap_innn_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 0, 7, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(7, 0, 0, 1023, 128),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 8, 0, 0, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(0, 0, 0, 124, 124),
	gsDPSetTextureImage(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 1, custom_cap_custom_mario_logo_blend_rgba32),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b_LOAD_BLOCK, 0, 512, 6, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0, G_TX_WRAP | G_TX_NOMIRROR, 0, 0),
	gsDPLoadBlock(6, 0, 0, 1023, 128),
	gsDPSetTile(G_IM_FMT_RGBA, G_IM_SIZ_32b, 8, 512, 1, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0, G_TX_CLAMP | G_TX_NOMIRROR, 5, 0),
	gsDPSetTileSize(1, 0, 0, 124, 124),
	gsSPEndDisplayList(),
};

Gfx mat_revert_custom_cap_Logo__EMBLEM__layer2[] = {
	gsDPPipeSync(),
	gsDPSetAlphaDither(G_AD_DISABLE),
	gsDPSetRenderMode(G_RM_AA_ZB_OPA_DECAL, G_RM_AA_ZB_OPA_DECAL2),
	gsSPEndDisplayList(),
};

Gfx custom_cap_Cap_DL_mesh_layer_1[] = {
	gsSPDisplayList(mat_custom_cap_Cap__CAP_),
	gsSPDisplayList(custom_cap_Cap_DL_mesh_layer_1_tri_0),
	gsSPDisplayList(mat_revert_custom_cap_Cap__CAP_),
	gsSPDisplayList(mat_custom_cap_Cap_Inside__CAP_),
	gsSPDisplayList(custom_cap_Cap_DL_mesh_layer_1_tri_1),
	gsSPDisplayList(mat_revert_custom_cap_Cap_Inside__CAP_),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};

Gfx custom_cap_Cap_DL_mesh_layer_2[] = {
	gsSPDisplayList(mat_custom_cap_Logo__EMBLEM__layer2),
	gsSPDisplayList(custom_cap_Cap_DL_mesh_layer_2_tri_0),
	gsSPDisplayList(mat_revert_custom_cap_Logo__EMBLEM__layer2),
	gsDPPipeSync(),
	gsSPSetGeometryMode(G_LIGHTING),
	gsSPClearGeometryMode(G_TEXTURE_GEN),
	gsDPSetCombineLERP(0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT, 0, 0, 0, SHADE, 0, 0, 0, ENVIRONMENT),
	gsSPTexture(65535, 65535, 0, 0, 0),
	gsDPSetEnvColor(255, 255, 255, 255),
	gsDPSetAlphaCompare(G_AC_NONE),
	gsSPEndDisplayList(),
};


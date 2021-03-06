//----------------------------------------------------------------------------
//  EDGE2 OpenGL Rendering (Unit system)
//----------------------------------------------------------------------------
// 
//  Copyright (c) 1999-2009  The EDGE2 Team.
// 
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//----------------------------------------------------------------------------
//
//  Based on the DOOM source code, released by Id Software under the
//  following copyright:
//
//    Copyright (C) 1993-1996 by id Software, Inc.
//
//----------------------------------------------------------------------------

#ifndef __R_UNITS_H__
#define __R_UNITS_H__

#define MAX_PLVERT  64

// a single vertex to pass to the GL 
typedef struct local_gl_vert_s
{
	GLfloat rgba[4];
	vec3_t pos;
	vec2_t texc[2];
	vec3_t normal;
	GLboolean EDGE2;
}
local_gl_vert_t;

void RGL_InitUnits(void);
void RGL_SoftInitUnits(void);

void RGL_StartUnits(bool sort_em);
void RGL_FinishUnits(void);
void RGL_DrawUnits(void);

typedef enum
{
	BL_NONE = 0,

	BL_Masked   = (1<<0),  // drop fragments when alpha == 0
	BL_Less     = (1<<1),  // drop fragments when alpha < color.a
	BL_Alpha    = (1<<2),  // alpha-blend with the framebuffer
	BL_Add      = (1<<3),  // additive-blend with the framebuffer

	BL_CullBack = (1<<4),  // enable back-face culling
	BL_CullFront= (1<<5),  // enable front-face culling
	BL_NoZBuf   = (1<<6),  // don't update the Z buffer
	BL_ClampY   = (1<<7),  // force texture to be Y clamped
}
blending_mode_e;

#define BL_CULL_BOTH  (BL_CullBack | BL_CullFront)

#define CUSTOM_ENV_BEGIN  0xED9E0000
#define CUSTOM_ENV_END    0xED9E00FF

typedef enum
{
	ENV_NONE = 0,
	// the texture unit is disabled (complete pass-through).

	ENV_SKIP_RGB = CUSTOM_ENV_BEGIN+1,
	// causes the RGB of the texture to be skipped, i.e. the
	// output of the texture unit is the same as the input
	// for the RGB components.  The alpha component is treated
	// normally, i.e. passed on to next texture unit.
}
edge_environment_e;

local_gl_vert_t *RGL_BeginUnit(GLuint shape, int max_vert, 
		                       GLuint env1, GLuint tex1,
							   GLuint env2, GLuint tex2,
							   int pass, int blending);
void RGL_EndUnit(int actual_vert);


#endif /* __R_UNITS_H__ */
//beginunit is renderpolyquad

#ifdef POLYQUADS
//polyquads??
// RAW STUFF

typedef struct raw_polyquad_s
{
	// Quad ?  When true, the number of vertices must be even, and the
	// order must be the same as for glBegin(GL_QUADSTRIP).
	// 
	bool quad;

	vec3_t *verts;
	int num_verts;
	int max_verts;

	// When a polyquad is split, the other pieces are linked from the
	// original through this pointer.
	//
	struct raw_polyquad_s *sisters;

	// 3D bounding box
	vec3_t min, max;
}
raw_polyquad_t;

#define PQ_ADD_VERT(P,X,Y,Z)  do {  \
	(P)->verts[(P)->num_verts].x = (X);  \
	(P)->verts[(P)->num_verts].y = (Y);  \
	(P)->verts[(P)->num_verts].z = (Z);  \
	(P)->num_verts++; } while(0)

raw_polyquad_t *RGL_NewPolyQuad(int maxvert, bool quad);
void RGL_FreePolyQuad(raw_polyquad_t *poly);
void RGL_BoundPolyQuad(raw_polyquad_t *poly);

void RGL_SplitPolyQuad(raw_polyquad_t *poly, int division, 
					   bool separate);
void RGL_SplitPolyQuadLOD(raw_polyquad_t *poly, int max_lod, int base_div);

void RGL_RenderPolyQuad(raw_polyquad_t *poly, void *data,
						void (* CoordFunc)(vec3_t *src, local_gl_vert_t *vert, void *data),
						GLuint tex_id, GLuint tex2_id, int pass, int blending);










#endif //__R_UNITS_H__ 
//--- editor settings ---
// vi:ts=4:sw=4:noexpandtab

/*

Boost Software License - Version 1.0 - August 17th, 2003

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.

*/
module derelict.opengl.extensions.arb_c;

import derelict.opengl.types : usingContexts;
import derelict.opengl.extensions.internal;

// ARB_cl_event
enum ARB_cl_event = "GL_ARB_cl_event";
enum arbCLEventDecls =
q{
struct _cl_context;
struct _cl_event;
enum : uint
{
    GL_SYNC_CL_EVENT_ARB              = 0x8240,
    GL_SYNC_CL_EVENT_COMPLETE_ARB     = 0x8241,
}
extern(System) @nogc nothrow alias  da_glCreateSyncFromCLeventARB = GLsync function(_cl_context*, _cl_event*, GLbitfield);
};

enum arbCLEventFuncs = `da_glCreateSyncFromCLeventARB glCreateSyncFromCLeventARB;`;
enum arbCLEventLoaderImpl = `bindGLFunc(cast(void**)&glCreateSyncFromCLeventARB, "glCreateSyncFromCLeventARB");`;
enum arbCLEventLoader = makeExtLoader(ARB_cl_event, arbCLEventLoaderImpl);
static if(!usingContexts) enum arbCLEvent = arbCLEventDecls ~ arbCLEventFuncs.makeGShared() ~ arbCLEventLoader;

// ARB_compressed_texture_pixel_storage
enum ARB_compressed_texture_pixel_storage = "GL_ARB_compressed_texture_pixel_storage";
enum arbCompressedTexturePixelStorageDecls =
q{
enum : uint
{
    GL_UNPACK_COMPRESSED_BLOCK_WIDTH  = 0x9127,
    GL_UNPACK_COMPRESSED_BLOCK_HEIGHT = 0x9128,
    GL_UNPACK_COMPRESSED_BLOCK_DEPTH  = 0x9129,
    GL_UNPACK_COMPRESSED_BLOCK_SIZE   = 0x912A,
    GL_PACK_COMPRESSED_BLOCK_WIDTH    = 0x912B,
    GL_PACK_COMPRESSED_BLOCK_HEIGHT   = 0x912C,
    GL_PACK_COMPRESSED_BLOCK_DEPTH    = 0x912D,
    GL_PACK_COMPRESSED_BLOCK_SIZE     = 0x912E,
}};

enum arbCompressedTexturePixelStorageLoader = makeExtLoader(ARB_compressed_texture_pixel_storage);
static if(!usingContexts) enum arbCompressedTexturePixelStorage = arbCompressedTexturePixelStorageDecls ~ arbCompressedTexturePixelStorageLoader;

// ARB_conditional_render_inverted
enum ARB_conditional_render_inverted = "GL_ARB_conditional_render_inverted";
enum arbConditionalRenderInvertedDecls =
q{
enum : uint
{
    GL_QUERY_WAIT_INVERTED            = 0x8E17,
    GL_QUERY_NO_WAIT_INVERTED         = 0x8E18,
    GL_QUERY_BY_REGION_WAIT_INVERTED  = 0x8E19,
    GL_QUERY_BY_REGION_NO_WAIT_INVERTED = 0x8E1A,
}};

enum arbConditionalRenderInvertedLoader = makeExtLoader(ARB_conditional_render_inverted);
static if(!usingContexts) enum arbConditionalRenderInverted = arbConditionalRenderInvertedDecls ~ arbConditionalRenderInvertedLoader;

// ARB_conservative_depth
enum ARB_conservative_depth = "GL_ARB_conservative_depth";
enum arbConservativeDepthLoader = makeExtLoader(ARB_conservative_depth);
static if(!usingContexts) enum arbConservativeDepth = arbConservativeDepthLoader;

// ARB_cull_distance
enum ARB_cull_distance = "GL_ARB_cull_distance";
enum arbCullDistanceDecls =
q{
enum : uint
{
    GL_MAX_CULL_DISTANCES = 0x82F9,
    GL_MAX_COMBINED_CLIP_AND_CULL_DISTANCES = 0x82FA,
}};

enum arbCullDistanceLoader = makeExtLoader(ARB_cull_distance);
static if(!usingContexts) enum arbCullDistance = arbCullDistanceDecls ~ arbCullDistanceLoader;
-- Written by Rabia Alhaffar in 12/August/2020
-- raylua, Cross-Platform, Modern, Handwritten, Updated LuaJIT bindings for raylib library.
-- Latest update: 11/November/2021
local ffi = require("ffi")   -- We will use LuaJIT FFI for bindings, And to get OS and architecture to load library file!
local arch = ffi.arch
local sys = ffi.os

-- For SetTraceLogCallback function, We defined vsnprintf from C
ffi.cdef([[
  int vsnprintf(char *, size_t, const char *, va_list);
]])
  
-- For not throwing errors cause of duplicating when using other LuaJIT bindings
if not (type(rl) == "userdata" or type(rl) == "table") then

local lib = ""  -- Keep this empty so it changed when this file loaded/required directly

-- Get OS and architecture to set library file to use
if sys == "Windows" then
    lib = ("lib\\".. sys .. '/' .. arch ..  "\\raylib.gl" .. gl ..  ".dll")
elseif sys == "OSX" then
  lib = "./lib/".. sys .. '/' .. arch ..  "/libraylib.gl" .. gl .. ".dylib"
else
  lib = "./lib/".. sys .. '/' .. arch ..  "/libraylib.gl" .. gl .. ".so"
end

-- raylib.h
ffi.cdef([[
/**********************************************************************************************
*
*   raylib v4.0 - A simple and easy-to-use library to enjoy videogames programming (www.raylib.com)
*
*   FEATURES:
*       - NO external dependencies, all required libraries included with raylib
*       - Multiplatform: Windows, Linux, FreeBSD, OpenBSD, NetBSD, DragonFly,
*                        MacOS, Haiku, Android, Raspberry Pi, DRM native, HTML5.
*       - Written in plain C code (C99) in PascalCase/camelCase notation
*       - Hardware accelerated with OpenGL (1.1, 2.1, 3.3, 4.3 or ES2 - choose at compile)
*       - Unique OpenGL abstraction layer (usable as standalone module): [rlgl]
*       - Multiple Fonts formats supported (TTF, XNA fonts, AngelCode fonts)
*       - Outstanding texture formats support, including compressed formats (DXT, ETC, ASTC)
*       - Full 3d support for 3d Shapes, Models, Billboards, Heightmaps and more!
*       - Flexible Materials system, supporting classic maps and PBR maps
*       - Animated 3D models supported (skeletal bones animation) (IQM)
*       - Shaders support, including Model shaders and Postprocessing shaders
*       - Powerful math module for Vector, Matrix and Quaternion operations: [raymath]
*       - Audio loading and playing with streaming support (WAV, OGG, MP3, FLAC, XM, MOD)
*       - VR stereo rendering with configurable HMD device parameters
*       - Bindings to multiple programming languages available!
*
*   NOTES:
*       - One default Font is loaded on InitWindow()->LoadFontDefault() [core, text]
*       - One default Texture2D is loaded on rlglInit(), 1x1 white pixel R8G8B8A8 [rlgl] (OpenGL 3.3 or ES2)
*       - One default Shader is loaded on rlglInit()->rlLoadShaderDefault() [rlgl] (OpenGL 3.3 or ES2)
*       - One default RenderBatch is loaded on rlglInit()->rlLoadRenderBatch() [rlgl] (OpenGL 3.3 or ES2)
*
*   DEPENDENCIES (included):
*       [rcore] rglfw (Camilla Löwy - github.com/glfw/glfw) for window/context management and input (PLATFORM_DESKTOP)
*       [rlgl] glad (David Herberth - github.com/Dav1dde/glad) for OpenGL 3.3 extensions loading (PLATFORM_DESKTOP)
*       [raudio] miniaudio (David Reid - github.com/mackron/miniaudio) for audio device/context management
*
*   OPTIONAL DEPENDENCIES (included):
*       [rcore] msf_gif (Miles Fogle) for GIF recording
*       [rcore] sinfl (Micha Mettke) for DEFLATE decompression algorythm
*       [rcore] sdefl (Micha Mettke) for DEFLATE compression algorythm
*       [rtextures] stb_image (Sean Barret) for images loading (BMP, TGA, PNG, JPEG, HDR...)
*       [rtextures] stb_image_write (Sean Barret) for image writing (BMP, TGA, PNG, JPG)
*       [rtextures] stb_image_resize (Sean Barret) for image resizing algorithms
*       [rtext] stb_truetype (Sean Barret) for ttf fonts loading
*       [rtext] stb_rect_pack (Sean Barret) for rectangles packing
*       [rmodels] par_shapes (Philip Rideout) for parametric 3d shapes generation
*       [rmodels] tinyobj_loader_c (Syoyo Fujita) for models loading (OBJ, MTL)
*       [rmodels] cgltf (Johannes Kuhlmann) for models loading (glTF)
*       [raudio] dr_wav (David Reid) for WAV audio file loading
*       [raudio] dr_flac (David Reid) for FLAC audio file loading
*       [raudio] dr_mp3 (David Reid) for MP3 audio file loading
*       [raudio] stb_vorbis (Sean Barret) for OGG audio loading
*       [raudio] jar_xm (Joshua Reisenauer) for XM audio module loading
*       [raudio] jar_mod (Joshua Reisenauer) for MOD audio module loading
*
*
*   LICENSE: zlib/libpng
*
*   raylib is licensed under an unmodified zlib/libpng license, which is an OSI-certified,
*   BSD-like license that allows static linking with closed source software:
*
*   Copyright (c) 2013-2021 Ramon Santamaria (@raysan5)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented; you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
**********************************************************************************************/
// Vector2, 2 components
typedef struct Vector2 {
    float x;                // Vector x component
    float y;                // Vector y component
} Vector2;

// Vector3, 3 components
typedef struct Vector3 {
    float x;                // Vector x component
    float y;                // Vector y component
    float z;                // Vector z component
} Vector3;

// Vector4, 4 components
typedef struct Vector4 {
    float x;                // Vector x component
    float y;                // Vector y component
    float z;                // Vector z component
    float w;                // Vector w component
} Vector4;

// Quaternion, 4 components (Vector4 alias)
typedef Vector4 Quaternion;

// Matrix, 4x4 components, column major, OpenGL style, right handed
typedef struct Matrix {
    float m0, m4, m8, m12;  // Matrix first row (4 components)
    float m1, m5, m9, m13;  // Matrix second row (4 components)
    float m2, m6, m10, m14; // Matrix third row (4 components)
    float m3, m7, m11, m15; // Matrix fourth row (4 components)
} Matrix;

// Color, 4 components, R8G8B8A8 (32bit)
typedef struct Color {
    unsigned char r;        // Color red value
    unsigned char g;        // Color green value
    unsigned char b;        // Color blue value
    unsigned char a;        // Color alpha value
} Color;

// Rectangle, 4 components
typedef struct Rectangle {
    float x;                // Rectangle top-left corner position x
    float y;                // Rectangle top-left corner position y
    float width;            // Rectangle width
    float height;           // Rectangle height
} Rectangle;

// Image, pixel data stored in CPU memory (RAM)
typedef struct Image {
    void *data;             // Image raw data
    int width;              // Image base width
    int height;             // Image base height
    int mipmaps;            // Mipmap levels, 1 by default
    int format;             // Data format (PixelFormat type)
} Image;

// Texture, tex data stored in GPU memory (VRAM)
typedef struct Texture {
    unsigned int id;        // OpenGL texture id
    int width;              // Texture base width
    int height;             // Texture base height
    int mipmaps;            // Mipmap levels, 1 by default
    int format;             // Data format (PixelFormat type)
} Texture;

// Texture2D, same as Texture
typedef Texture Texture2D;

// TextureCubemap, same as Texture
typedef Texture TextureCubemap;

// RenderTexture, fbo for texture rendering
typedef struct RenderTexture {
    unsigned int id;        // OpenGL framebuffer object id
    Texture texture;        // Color buffer attachment texture
    Texture depth;          // Depth buffer attachment texture
} RenderTexture;

// RenderTexture2D, same as RenderTexture
typedef RenderTexture RenderTexture2D;

// NPatchInfo, n-patch layout info
typedef struct NPatchInfo {
    Rectangle source;       // Texture source rectangle
    int left;               // Left border offset
    int top;                // Top border offset
    int right;              // Right border offset
    int bottom;             // Bottom border offset
    int layout;             // Layout of the n-patch: 3x3, 1x3 or 3x1
} NPatchInfo;

// GlyphInfo, font characters glyphs info
typedef struct GlyphInfo {
    int value;              // Character value (Unicode)
    int offsetX;            // Character offset X when drawing
    int offsetY;            // Character offset Y when drawing
    int advanceX;           // Character advance position X
    Image image;            // Character image data
} GlyphInfo;

// Font, font texture and GlyphInfo array data
typedef struct Font {
    int baseSize;           // Base size (default chars height)
    int glyphCount;         // Number of glyph characters
    int glyphPadding;       // Padding around the glyph characters
    Texture2D texture;      // Texture atlas containing the glyphs
    Rectangle *recs;        // Rectangles in texture for the glyphs
    GlyphInfo *glyphs;      // Glyphs info data
} Font;

// Camera, defines position/orientation in 3d space
typedef struct Camera3D {
    Vector3 position;       // Camera position
    Vector3 target;         // Camera target it looks-at
    Vector3 up;             // Camera up vector (rotation over its axis)
    float fovy;             // Camera field-of-view apperture in Y (degrees) in perspective, used as near plane width in orthographic
    int projection;         // Camera projection: CAMERA_PERSPECTIVE or CAMERA_ORTHOGRAPHIC
} Camera3D;

typedef Camera3D Camera;    // Camera type fallback, defaults to Camera3D

// Camera2D, defines position/orientation in 2d space
typedef struct Camera2D {
    Vector2 offset;         // Camera offset (displacement from target)
    Vector2 target;         // Camera target (rotation and zoom origin)
    float rotation;         // Camera rotation in degrees
    float zoom;             // Camera zoom (scaling), should be 1.0f by default
} Camera2D;

// Mesh, vertex data and vao/vbo
typedef struct Mesh {
    int vertexCount;        // Number of vertices stored in arrays
    int triangleCount;      // Number of triangles stored (indexed or not)

    // Vertex attributes data
    float *vertices;        // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    float *texcoords;       // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    float *texcoords2;      // Vertex second texture coordinates (useful for lightmaps) (shader-location = 5)
    float *normals;         // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
    float *tangents;        // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
    unsigned char *colors;      // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    unsigned short *indices;    // Vertex indices (in case vertex data comes indexed)

    // Animation vertex data
    float *animVertices;    // Animated vertex positions (after bones transformations)
    float *animNormals;     // Animated normals (after bones transformations)
    unsigned char *boneIds; // Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning)
    float *boneWeights;     // Vertex bone weight, up to 4 bones influence by vertex (skinning)

    // OpenGL identifiers
    unsigned int vaoId;     // OpenGL Vertex Array Object id
    unsigned int *vboId;    // OpenGL Vertex Buffer Objects id (default vertex data)
} Mesh;

// Shader
typedef struct Shader {
    unsigned int id;        // Shader program id
    int *locs;              // Shader locations array (RL_MAX_SHADER_LOCATIONS)
} Shader;

// MaterialMap
typedef struct MaterialMap {
    Texture2D texture;      // Material map texture
    Color color;            // Material map color
    float value;            // Material map value
} MaterialMap;

// Material, includes shader and maps
typedef struct Material {
    Shader shader;          // Material shader
    MaterialMap *maps;      // Material maps array (MAX_MATERIAL_MAPS)
    float params[4];        // Material generic parameters (if required)
} Material;

// Transform, vectex transformation data
typedef struct Transform {
    Vector3 translation;    // Translation
    Quaternion rotation;    // Rotation
    Vector3 scale;          // Scale
} Transform;

// Bone, skeletal animation bone
typedef struct BoneInfo {
    char name[32];          // Bone name
    int parent;             // Bone parent
} BoneInfo;

// Model, meshes, materials and animation data
typedef struct Model {
    Matrix transform;       // Local transform matrix

    int meshCount;          // Number of meshes
    int materialCount;      // Number of materials
    Mesh *meshes;           // Meshes array
    Material *materials;    // Materials array
    int *meshMaterial;      // Mesh material number

    // Animation data
    int boneCount;          // Number of bones
    BoneInfo *bones;        // Bones information (skeleton)
    Transform *bindPose;    // Bones base transformation (pose)
} Model;

// ModelAnimation
typedef struct ModelAnimation {
    int boneCount;          // Number of bones
    int frameCount;         // Number of animation frames
    BoneInfo *bones;        // Bones information (skeleton)
    Transform **framePoses; // Poses array by frame
} ModelAnimation;

// Ray, ray for raycasting
typedef struct Ray {
    Vector3 position;       // Ray position (origin)
    Vector3 direction;      // Ray direction
} Ray;

// RayCollision, ray hit information
typedef struct RayCollision {
    bool hit;               // Did the ray hit something?
    float distance;         // Distance to nearest hit
    Vector3 point;          // Point of nearest hit
    Vector3 normal;         // Surface normal of hit
} RayCollision;

// BoundingBox
typedef struct BoundingBox {
    Vector3 min;            // Minimum vertex box-corner
    Vector3 max;            // Maximum vertex box-corner
} BoundingBox;

// Wave, audio wave data
typedef struct Wave {
    unsigned int frameCount;    // Total number of frames (considering channels)
    unsigned int sampleRate;    // Frequency (samples per second)
    unsigned int sampleSize;    // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    unsigned int channels;      // Number of channels (1-mono, 2-stereo, ...)
    void *data;                 // Buffer data pointer
} Wave;

typedef struct rAudioBuffer rAudioBuffer;

// AudioStream, custom audio stream
typedef struct AudioStream {
    rAudioBuffer *buffer;       // Pointer to internal data used by the audio system

    unsigned int sampleRate;    // Frequency (samples per second)
    unsigned int sampleSize;    // Bit depth (bits per sample): 8, 16, 32 (24 not supported)
    unsigned int channels;      // Number of channels (1-mono, 2-stereo, ...)
} AudioStream;

// Sound
typedef struct Sound {
    AudioStream stream;         // Audio stream
    unsigned int frameCount;    // Total number of frames (considering channels)
} Sound;

// Music, audio stream, anything longer than ~10 seconds should be streamed
typedef struct Music {
    AudioStream stream;         // Audio stream
    unsigned int frameCount;    // Total number of frames (considering channels)
    bool looping;               // Music looping enable

    int ctxType;                // Type of music context (audio filetype)
    void *ctxData;              // Audio context data, depends on type
} Music;

// VrDeviceInfo, Head-Mounted-Display device parameters
typedef struct VrDeviceInfo {
    int hResolution;                // Horizontal resolution in pixels
    int vResolution;                // Vertical resolution in pixels
    float hScreenSize;              // Horizontal size in meters
    float vScreenSize;              // Vertical size in meters
    float vScreenCenter;            // Screen center in meters
    float eyeToScreenDistance;      // Distance between eye and display in meters
    float lensSeparationDistance;   // Lens separation distance in meters
    float interpupillaryDistance;   // IPD (distance between pupils) in meters
    float lensDistortionValues[4];  // Lens distortion constant parameters
    float chromaAbCorrection[4];    // Chromatic aberration correction parameters
} VrDeviceInfo;

// VrStereoConfig, VR stereo rendering configuration for simulator
typedef struct VrStereoConfig {
    Matrix projection[2];           // VR projection matrices (per eye)
    Matrix viewOffset[2];           // VR view offset matrices (per eye)
    float leftLensCenter[2];        // VR left lens center
    float rightLensCenter[2];       // VR right lens center
    float leftScreenCenter[2];      // VR left screen center
    float rightScreenCenter[2];     // VR right screen center
    float scale[2];                 // VR distortion scale
    float scaleIn[2];               // VR distortion scale in
} VrStereoConfig;

//----------------------------------------------------------------------------------
// Enumerators Definition
//----------------------------------------------------------------------------------
// System/Window config flags
// NOTE: Every bit registers one state (use it with bit masks)
// By default all flags are set to 0
typedef enum {
    FLAG_VSYNC_HINT         = 0x00000040,   // Set to try enabling V-Sync on GPU
    FLAG_FULLSCREEN_MODE    = 0x00000002,   // Set to run program in fullscreen
    FLAG_WINDOW_RESIZABLE   = 0x00000004,   // Set to allow resizable window
    FLAG_WINDOW_UNDECORATED = 0x00000008,   // Set to disable window decoration (frame and buttons)
    FLAG_WINDOW_HIDDEN      = 0x00000080,   // Set to hide window
    FLAG_WINDOW_MINIMIZED   = 0x00000200,   // Set to minimize window (iconify)
    FLAG_WINDOW_MAXIMIZED   = 0x00000400,   // Set to maximize window (expanded to monitor)
    FLAG_WINDOW_UNFOCUSED   = 0x00000800,   // Set to window non focused
    FLAG_WINDOW_TOPMOST     = 0x00001000,   // Set to window always on top
    FLAG_WINDOW_ALWAYS_RUN  = 0x00000100,   // Set to allow windows running while minimized
    FLAG_WINDOW_TRANSPARENT = 0x00000010,   // Set to allow transparent framebuffer
    FLAG_WINDOW_HIGHDPI     = 0x00002000,   // Set to support HighDPI
    FLAG_MSAA_4X_HINT       = 0x00000020,   // Set to try enabling MSAA 4X
    FLAG_INTERLACED_HINT    = 0x00010000    // Set to try enabling interlaced video format (for V3D)
} ConfigFlags;

// Trace log level
// NOTE: Organized by priority level
typedef enum {
    LOG_ALL = 0,        // Display all logs
    LOG_TRACE,          // Trace logging, intended for internal use only
    LOG_DEBUG,          // Debug logging, used for internal debugging, it should be disabled on release builds
    LOG_INFO,           // Info logging, used for program execution info
    LOG_WARNING,        // Warning logging, used on recoverable failures
    LOG_ERROR,          // Error logging, used on unrecoverable failures
    LOG_FATAL,          // Fatal logging, used to abort program: exit(EXIT_FAILURE)
    LOG_NONE            // Disable logging
} TraceLogLevel;

// Keyboard keys (US keyboard layout)
// NOTE: Use GetKeyPressed() to allow redefining
// required keys for alternative layouts
typedef enum {
    KEY_NULL            = 0,        // Key: NULL, used for no key pressed
    // Alphanumeric keys
    KEY_APOSTROPHE      = 39,       // Key: '
    KEY_COMMA           = 44,       // Key: ,
    KEY_MINUS           = 45,       // Key: -
    KEY_PERIOD          = 46,       // Key: .
    KEY_SLASH           = 47,       // Key: /
    KEY_ZERO            = 48,       // Key: 0
    KEY_ONE             = 49,       // Key: 1
    KEY_TWO             = 50,       // Key: 2
    KEY_THREE           = 51,       // Key: 3
    KEY_FOUR            = 52,       // Key: 4
    KEY_FIVE            = 53,       // Key: 5
    KEY_SIX             = 54,       // Key: 6
    KEY_SEVEN           = 55,       // Key: 7
    KEY_EIGHT           = 56,       // Key: 8
    KEY_NINE            = 57,       // Key: 9
    KEY_SEMICOLON       = 59,       // Key: ;
    KEY_EQUAL           = 61,       // Key: =
    KEY_A               = 65,       // Key: A | a
    KEY_B               = 66,       // Key: B | b
    KEY_C               = 67,       // Key: C | c
    KEY_D               = 68,       // Key: D | d
    KEY_E               = 69,       // Key: E | e
    KEY_F               = 70,       // Key: F | f
    KEY_G               = 71,       // Key: G | g
    KEY_H               = 72,       // Key: H | h
    KEY_I               = 73,       // Key: I | i
    KEY_J               = 74,       // Key: J | j
    KEY_K               = 75,       // Key: K | k
    KEY_L               = 76,       // Key: L | l
    KEY_M               = 77,       // Key: M | m
    KEY_N               = 78,       // Key: N | n
    KEY_O               = 79,       // Key: O | o
    KEY_P               = 80,       // Key: P | p
    KEY_Q               = 81,       // Key: Q | q
    KEY_R               = 82,       // Key: R | r
    KEY_S               = 83,       // Key: S | s
    KEY_T               = 84,       // Key: T | t
    KEY_U               = 85,       // Key: U | u
    KEY_V               = 86,       // Key: V | v
    KEY_W               = 87,       // Key: W | w
    KEY_X               = 88,       // Key: X | x
    KEY_Y               = 89,       // Key: Y | y
    KEY_Z               = 90,       // Key: Z | z
    KEY_LEFT_BRACKET    = 91,       // Key: [
    KEY_BACKSLASH       = 92,       // Key: '\'
    KEY_RIGHT_BRACKET   = 93,       // Key: ]
    KEY_GRAVE           = 96,       // Key: `
    // Function keys
    KEY_SPACE           = 32,       // Key: Space
    KEY_ESCAPE          = 256,      // Key: Esc
    KEY_ENTER           = 257,      // Key: Enter
    KEY_TAB             = 258,      // Key: Tab
    KEY_BACKSPACE       = 259,      // Key: Backspace
    KEY_INSERT          = 260,      // Key: Ins
    KEY_DELETE          = 261,      // Key: Del
    KEY_RIGHT           = 262,      // Key: Cursor right
    KEY_LEFT            = 263,      // Key: Cursor left
    KEY_DOWN            = 264,      // Key: Cursor down
    KEY_UP              = 265,      // Key: Cursor up
    KEY_PAGE_UP         = 266,      // Key: Page up
    KEY_PAGE_DOWN       = 267,      // Key: Page down
    KEY_HOME            = 268,      // Key: Home
    KEY_END             = 269,      // Key: End
    KEY_CAPS_LOCK       = 280,      // Key: Caps lock
    KEY_SCROLL_LOCK     = 281,      // Key: Scroll down
    KEY_NUM_LOCK        = 282,      // Key: Num lock
    KEY_PRINT_SCREEN    = 283,      // Key: Print screen
    KEY_PAUSE           = 284,      // Key: Pause
    KEY_F1              = 290,      // Key: F1
    KEY_F2              = 291,      // Key: F2
    KEY_F3              = 292,      // Key: F3
    KEY_F4              = 293,      // Key: F4
    KEY_F5              = 294,      // Key: F5
    KEY_F6              = 295,      // Key: F6
    KEY_F7              = 296,      // Key: F7
    KEY_F8              = 297,      // Key: F8
    KEY_F9              = 298,      // Key: F9
    KEY_F10             = 299,      // Key: F10
    KEY_F11             = 300,      // Key: F11
    KEY_F12             = 301,      // Key: F12
    KEY_LEFT_SHIFT      = 340,      // Key: Shift left
    KEY_LEFT_CONTROL    = 341,      // Key: Control left
    KEY_LEFT_ALT        = 342,      // Key: Alt left
    KEY_LEFT_SUPER      = 343,      // Key: Super left
    KEY_RIGHT_SHIFT     = 344,      // Key: Shift right
    KEY_RIGHT_CONTROL   = 345,      // Key: Control right
    KEY_RIGHT_ALT       = 346,      // Key: Alt right
    KEY_RIGHT_SUPER     = 347,      // Key: Super right
    KEY_KB_MENU         = 348,      // Key: KB menu
    // Keypad keys
    KEY_KP_0            = 320,      // Key: Keypad 0
    KEY_KP_1            = 321,      // Key: Keypad 1
    KEY_KP_2            = 322,      // Key: Keypad 2
    KEY_KP_3            = 323,      // Key: Keypad 3
    KEY_KP_4            = 324,      // Key: Keypad 4
    KEY_KP_5            = 325,      // Key: Keypad 5
    KEY_KP_6            = 326,      // Key: Keypad 6
    KEY_KP_7            = 327,      // Key: Keypad 7
    KEY_KP_8            = 328,      // Key: Keypad 8
    KEY_KP_9            = 329,      // Key: Keypad 9
    KEY_KP_DECIMAL      = 330,      // Key: Keypad .
    KEY_KP_DIVIDE       = 331,      // Key: Keypad /
    KEY_KP_MULTIPLY     = 332,      // Key: Keypad *
    KEY_KP_SUBTRACT     = 333,      // Key: Keypad -
    KEY_KP_ADD          = 334,      // Key: Keypad +
    KEY_KP_ENTER        = 335,      // Key: Keypad Enter
    KEY_KP_EQUAL        = 336,      // Key: Keypad =
    // Android key buttons
    KEY_BACK            = 4,        // Key: Android back button
    KEY_MENU            = 82,       // Key: Android menu button
    KEY_VOLUME_UP       = 24,       // Key: Android volume up button
    KEY_VOLUME_DOWN     = 25        // Key: Android volume down button
} KeyboardKey;

// Mouse buttons
typedef enum {
    MOUSE_BUTTON_LEFT    = 0,       // Mouse button left
    MOUSE_BUTTON_RIGHT   = 1,       // Mouse button right
    MOUSE_BUTTON_MIDDLE  = 2,       // Mouse button middle (pressed wheel)
    MOUSE_BUTTON_SIDE    = 3,       // Mouse button side (advanced mouse device)
    MOUSE_BUTTON_EXTRA   = 4,       // Mouse button extra (advanced mouse device)
    MOUSE_BUTTON_FORWARD = 5,       // Mouse button fordward (advanced mouse device)
    MOUSE_BUTTON_BACK    = 6,       // Mouse button back (advanced mouse device)
} MouseButton;

// Mouse cursor
typedef enum {
    MOUSE_CURSOR_DEFAULT       = 0,     // Default pointer shape
    MOUSE_CURSOR_ARROW         = 1,     // Arrow shape
    MOUSE_CURSOR_IBEAM         = 2,     // Text writing cursor shape
    MOUSE_CURSOR_CROSSHAIR     = 3,     // Cross shape
    MOUSE_CURSOR_POINTING_HAND = 4,     // Pointing hand cursor
    MOUSE_CURSOR_RESIZE_EW     = 5,     // Horizontal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NS     = 6,     // Vertical resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NWSE   = 7,     // Top-left to bottom-right diagonal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_NESW   = 8,     // The top-right to bottom-left diagonal resize/move arrow shape
    MOUSE_CURSOR_RESIZE_ALL    = 9,     // The omni-directional resize/move cursor shape
    MOUSE_CURSOR_NOT_ALLOWED   = 10     // The operation-not-allowed shape
} MouseCursor;

// Gamepad buttons
typedef enum {
    GAMEPAD_BUTTON_UNKNOWN = 0,         // Unknown button, just for error checking
    GAMEPAD_BUTTON_LEFT_FACE_UP,        // Gamepad left DPAD up button
    GAMEPAD_BUTTON_LEFT_FACE_RIGHT,     // Gamepad left DPAD right button
    GAMEPAD_BUTTON_LEFT_FACE_DOWN,      // Gamepad left DPAD down button
    GAMEPAD_BUTTON_LEFT_FACE_LEFT,      // Gamepad left DPAD left button
    GAMEPAD_BUTTON_RIGHT_FACE_UP,       // Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
    GAMEPAD_BUTTON_RIGHT_FACE_RIGHT,    // Gamepad right button right (i.e. PS3: Square, Xbox: X)
    GAMEPAD_BUTTON_RIGHT_FACE_DOWN,     // Gamepad right button down (i.e. PS3: Cross, Xbox: A)
    GAMEPAD_BUTTON_RIGHT_FACE_LEFT,     // Gamepad right button left (i.e. PS3: Circle, Xbox: B)
    GAMEPAD_BUTTON_LEFT_TRIGGER_1,      // Gamepad top/back trigger left (first), it could be a trailing button
    GAMEPAD_BUTTON_LEFT_TRIGGER_2,      // Gamepad top/back trigger left (second), it could be a trailing button
    GAMEPAD_BUTTON_RIGHT_TRIGGER_1,     // Gamepad top/back trigger right (one), it could be a trailing button
    GAMEPAD_BUTTON_RIGHT_TRIGGER_2,     // Gamepad top/back trigger right (second), it could be a trailing button
    GAMEPAD_BUTTON_MIDDLE_LEFT,         // Gamepad center buttons, left one (i.e. PS3: Select)
    GAMEPAD_BUTTON_MIDDLE,              // Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
    GAMEPAD_BUTTON_MIDDLE_RIGHT,        // Gamepad center buttons, right one (i.e. PS3: Start)
    GAMEPAD_BUTTON_LEFT_THUMB,          // Gamepad joystick pressed button left
    GAMEPAD_BUTTON_RIGHT_THUMB          // Gamepad joystick pressed button right
} GamepadButton;

// Gamepad axis
typedef enum {
    GAMEPAD_AXIS_LEFT_X        = 0,     // Gamepad left stick X axis
    GAMEPAD_AXIS_LEFT_Y        = 1,     // Gamepad left stick Y axis
    GAMEPAD_AXIS_RIGHT_X       = 2,     // Gamepad right stick X axis
    GAMEPAD_AXIS_RIGHT_Y       = 3,     // Gamepad right stick Y axis
    GAMEPAD_AXIS_LEFT_TRIGGER  = 4,     // Gamepad back trigger left, pressure level: [1..-1]
    GAMEPAD_AXIS_RIGHT_TRIGGER = 5      // Gamepad back trigger right, pressure level: [1..-1]
} GamepadAxis;

// Material map index
typedef enum {
    MATERIAL_MAP_ALBEDO    = 0,     // Albedo material (same as: MATERIAL_MAP_DIFFUSE)
    MATERIAL_MAP_METALNESS,         // Metalness material (same as: MATERIAL_MAP_SPECULAR)
    MATERIAL_MAP_NORMAL,            // Normal material
    MATERIAL_MAP_ROUGHNESS,         // Roughness material
    MATERIAL_MAP_OCCLUSION,         // Ambient occlusion material
    MATERIAL_MAP_EMISSION,          // Emission material
    MATERIAL_MAP_HEIGHT,            // Heightmap material
    MATERIAL_MAP_CUBEMAP,           // Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    MATERIAL_MAP_IRRADIANCE,        // Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    MATERIAL_MAP_PREFILTER,         // Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    MATERIAL_MAP_BRDF               // Brdf material
} MaterialMapIndex;

// Shader location index
typedef enum {
    SHADER_LOC_VERTEX_POSITION = 0, // Shader location: vertex attribute: position
    SHADER_LOC_VERTEX_TEXCOORD01,   // Shader location: vertex attribute: texcoord01
    SHADER_LOC_VERTEX_TEXCOORD02,   // Shader location: vertex attribute: texcoord02
    SHADER_LOC_VERTEX_NORMAL,       // Shader location: vertex attribute: normal
    SHADER_LOC_VERTEX_TANGENT,      // Shader location: vertex attribute: tangent
    SHADER_LOC_VERTEX_COLOR,        // Shader location: vertex attribute: color
    SHADER_LOC_MATRIX_MVP,          // Shader location: matrix uniform: model-view-projection
    SHADER_LOC_MATRIX_VIEW,         // Shader location: matrix uniform: view (camera transform)
    SHADER_LOC_MATRIX_PROJECTION,   // Shader location: matrix uniform: projection
    SHADER_LOC_MATRIX_MODEL,        // Shader location: matrix uniform: model (transform)
    SHADER_LOC_MATRIX_NORMAL,       // Shader location: matrix uniform: normal
    SHADER_LOC_VECTOR_VIEW,         // Shader location: vector uniform: view
    SHADER_LOC_COLOR_DIFFUSE,       // Shader location: vector uniform: diffuse color
    SHADER_LOC_COLOR_SPECULAR,      // Shader location: vector uniform: specular color
    SHADER_LOC_COLOR_AMBIENT,       // Shader location: vector uniform: ambient color
    SHADER_LOC_MAP_ALBEDO,          // Shader location: sampler2d texture: albedo (same as: SHADER_LOC_MAP_DIFFUSE)
    SHADER_LOC_MAP_METALNESS,       // Shader location: sampler2d texture: metalness (same as: SHADER_LOC_MAP_SPECULAR)
    SHADER_LOC_MAP_NORMAL,          // Shader location: sampler2d texture: normal
    SHADER_LOC_MAP_ROUGHNESS,       // Shader location: sampler2d texture: roughness
    SHADER_LOC_MAP_OCCLUSION,       // Shader location: sampler2d texture: occlusion
    SHADER_LOC_MAP_EMISSION,        // Shader location: sampler2d texture: emission
    SHADER_LOC_MAP_HEIGHT,          // Shader location: sampler2d texture: height
    SHADER_LOC_MAP_CUBEMAP,         // Shader location: samplerCube texture: cubemap
    SHADER_LOC_MAP_IRRADIANCE,      // Shader location: samplerCube texture: irradiance
    SHADER_LOC_MAP_PREFILTER,       // Shader location: samplerCube texture: prefilter
    SHADER_LOC_MAP_BRDF             // Shader location: sampler2d texture: brdf
} ShaderLocationIndex;

// Shader uniform data type
typedef enum {
    SHADER_UNIFORM_FLOAT = 0,       // Shader uniform type: float
    SHADER_UNIFORM_VEC2,            // Shader uniform type: vec2 (2 float)
    SHADER_UNIFORM_VEC3,            // Shader uniform type: vec3 (3 float)
    SHADER_UNIFORM_VEC4,            // Shader uniform type: vec4 (4 float)
    SHADER_UNIFORM_INT,             // Shader uniform type: int
    SHADER_UNIFORM_IVEC2,           // Shader uniform type: ivec2 (2 int)
    SHADER_UNIFORM_IVEC3,           // Shader uniform type: ivec3 (3 int)
    SHADER_UNIFORM_IVEC4,           // Shader uniform type: ivec4 (4 int)
    SHADER_UNIFORM_SAMPLER2D        // Shader uniform type: sampler2d
} ShaderUniformDataType;

// Shader attribute data types
typedef enum {
    SHADER_ATTRIB_FLOAT = 0,        // Shader attribute type: float
    SHADER_ATTRIB_VEC2,             // Shader attribute type: vec2 (2 float)
    SHADER_ATTRIB_VEC3,             // Shader attribute type: vec3 (3 float)
    SHADER_ATTRIB_VEC4              // Shader attribute type: vec4 (4 float)
} ShaderAttributeDataType;

// Pixel formats
// NOTE: Support depends on OpenGL version and platform
typedef enum {
    PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1, // 8 bit per pixel (no alpha)
    PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA,    // 8*2 bpp (2 channels)
    PIXELFORMAT_UNCOMPRESSED_R5G6B5,        // 16 bpp
    PIXELFORMAT_UNCOMPRESSED_R8G8B8,        // 24 bpp
    PIXELFORMAT_UNCOMPRESSED_R5G5B5A1,      // 16 bpp (1 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R4G4B4A4,      // 16 bpp (4 bit alpha)
    PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,      // 32 bpp
    PIXELFORMAT_UNCOMPRESSED_R32,           // 32 bpp (1 channel - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32,     // 32*3 bpp (3 channels - float)
    PIXELFORMAT_UNCOMPRESSED_R32G32B32A32,  // 32*4 bpp (4 channels - float)
    PIXELFORMAT_COMPRESSED_DXT1_RGB,        // 4 bpp (no alpha)
    PIXELFORMAT_COMPRESSED_DXT1_RGBA,       // 4 bpp (1 bit alpha)
    PIXELFORMAT_COMPRESSED_DXT3_RGBA,       // 8 bpp
    PIXELFORMAT_COMPRESSED_DXT5_RGBA,       // 8 bpp
    PIXELFORMAT_COMPRESSED_ETC1_RGB,        // 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_RGB,        // 4 bpp
    PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA,   // 8 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGB,        // 4 bpp
    PIXELFORMAT_COMPRESSED_PVRT_RGBA,       // 4 bpp
    PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA,   // 8 bpp
    PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA    // 2 bpp
} PixelFormat;

// Texture parameters: filter mode
// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
typedef enum {
    TEXTURE_FILTER_POINT = 0,               // No filter, just pixel aproximation
    TEXTURE_FILTER_BILINEAR,                // Linear filtering
    TEXTURE_FILTER_TRILINEAR,               // Trilinear filtering (linear with mipmaps)
    TEXTURE_FILTER_ANISOTROPIC_4X,          // Anisotropic filtering 4x
    TEXTURE_FILTER_ANISOTROPIC_8X,          // Anisotropic filtering 8x
    TEXTURE_FILTER_ANISOTROPIC_16X,         // Anisotropic filtering 16x
} TextureFilter;

// Texture parameters: wrap mode
typedef enum {
    TEXTURE_WRAP_REPEAT = 0,                // Repeats texture in tiled mode
    TEXTURE_WRAP_CLAMP,                     // Clamps texture to edge pixel in tiled mode
    TEXTURE_WRAP_MIRROR_REPEAT,             // Mirrors and repeats the texture in tiled mode
    TEXTURE_WRAP_MIRROR_CLAMP               // Mirrors and clamps to border the texture in tiled mode
} TextureWrap;

// Cubemap layouts
typedef enum {
    CUBEMAP_LAYOUT_AUTO_DETECT = 0,         // Automatically detect layout type
    CUBEMAP_LAYOUT_LINE_VERTICAL,           // Layout is defined by a vertical line with faces
    CUBEMAP_LAYOUT_LINE_HORIZONTAL,         // Layout is defined by an horizontal line with faces
    CUBEMAP_LAYOUT_CROSS_THREE_BY_FOUR,     // Layout is defined by a 3x4 cross with cubemap faces
    CUBEMAP_LAYOUT_CROSS_FOUR_BY_THREE,     // Layout is defined by a 4x3 cross with cubemap faces
    CUBEMAP_LAYOUT_PANORAMA                 // Layout is defined by a panorama image (equirectangular map)
} CubemapLayout;

// Font type, defines generation method
typedef enum {
    FONT_DEFAULT = 0,               // Default font generation, anti-aliased
    FONT_BITMAP,                    // Bitmap font generation, no anti-aliasing
    FONT_SDF                        // SDF font generation, requires external shader
} FontType;

// Color blending modes (pre-defined)
typedef enum {
    BLEND_ALPHA = 0,                // Blend textures considering alpha (default)
    BLEND_ADDITIVE,                 // Blend textures adding colors
    BLEND_MULTIPLIED,               // Blend textures multiplying colors
    BLEND_ADD_COLORS,               // Blend textures adding colors (alternative)
    BLEND_SUBTRACT_COLORS,          // Blend textures subtracting colors (alternative)
    BLEND_CUSTOM                    // Belnd textures using custom src/dst factors (use rlSetBlendMode())
} BlendMode;

// Gesture
// NOTE: It could be used as flags to enable only some gestures
typedef enum {
    GESTURE_NONE        = 0,        // No gesture
    GESTURE_TAP         = 1,        // Tap gesture
    GESTURE_DOUBLETAP   = 2,        // Double tap gesture
    GESTURE_HOLD        = 4,        // Hold gesture
    GESTURE_DRAG        = 8,        // Drag gesture
    GESTURE_SWIPE_RIGHT = 16,       // Swipe right gesture
    GESTURE_SWIPE_LEFT  = 32,       // Swipe left gesture
    GESTURE_SWIPE_UP    = 64,       // Swipe up gesture
    GESTURE_SWIPE_DOWN  = 128,      // Swipe down gesture
    GESTURE_PINCH_IN    = 256,      // Pinch in gesture
    GESTURE_PINCH_OUT   = 512       // Pinch out gesture
} Gesture;

// Camera system modes
typedef enum {
    CAMERA_CUSTOM = 0,              // Custom camera
    CAMERA_FREE,                    // Free camera
    CAMERA_ORBITAL,                 // Orbital camera
    CAMERA_FIRST_PERSON,            // First person camera
    CAMERA_THIRD_PERSON             // Third person camera
} CameraMode;

// Camera projection
typedef enum {
    CAMERA_PERSPECTIVE = 0,         // Perspective projection
    CAMERA_ORTHOGRAPHIC             // Orthographic projection
} CameraProjection;

// N-patch layout
typedef enum {
    NPATCH_NINE_PATCH = 0,          // Npatch layout: 3x3 tiles
    NPATCH_THREE_PATCH_VERTICAL,    // Npatch layout: 1x3 tiles
    NPATCH_THREE_PATCH_HORIZONTAL   // Npatch layout: 3x1 tiles
} NPatchLayout;

// Callbacks to hook some internal functions
// WARNING: This callbacks are intended for advance users
typedef void (*TraceLogCallback)(int logLevel, const char *text, va_list args);  // Logging: Redirect trace log messages
typedef unsigned char *(*LoadFileDataCallback)(const char *fileName, unsigned int *bytesRead);      // FileIO: Load binary data
typedef bool (*SaveFileDataCallback)(const char *fileName, void *data, unsigned int bytesToWrite);  // FileIO: Save binary data
typedef char *(*LoadFileTextCallback)(const char *fileName);       // FileIO: Load text data
typedef bool (*SaveFileTextCallback)(const char *fileName, char *text);     // FileIO: Save text data

//------------------------------------------------------------------------------------
// Global Variables Definition
//------------------------------------------------------------------------------------
// It's lonely here...

//------------------------------------------------------------------------------------
// Window and Graphics Device Functions (Module: core)
//------------------------------------------------------------------------------------

// Window-related functions
void InitWindow(int width, int height, const char *title);  // Initialize window and OpenGL context
bool WindowShouldClose(void);                               // Check if KEY_ESCAPE pressed or Close icon pressed
void CloseWindow(void);                                     // Close window and unload OpenGL context
bool IsWindowReady(void);                                   // Check if window has been initialized successfully
bool IsWindowFullscreen(void);                              // Check if window is currently fullscreen
bool IsWindowHidden(void);                                  // Check if window is currently hidden (only PLATFORM_DESKTOP)
bool IsWindowMinimized(void);                               // Check if window is currently minimized (only PLATFORM_DESKTOP)
bool IsWindowMaximized(void);                               // Check if window is currently maximized (only PLATFORM_DESKTOP)
bool IsWindowFocused(void);                                 // Check if window is currently focused (only PLATFORM_DESKTOP)
bool IsWindowResized(void);                                 // Check if window has been resized last frame
bool IsWindowState(unsigned int flag);                      // Check if one specific window flag is enabled
void SetWindowState(unsigned int flags);                    // Set window configuration state using flags
void ClearWindowState(unsigned int flags);                  // Clear window configuration state flags
void ToggleFullscreen(void);                                // Toggle window state: fullscreen/windowed (only PLATFORM_DESKTOP)
void MaximizeWindow(void);                                  // Set window state: maximized, if resizable (only PLATFORM_DESKTOP)
void MinimizeWindow(void);                                  // Set window state: minimized, if resizable (only PLATFORM_DESKTOP)
void RestoreWindow(void);                                   // Set window state: not minimized/maximized (only PLATFORM_DESKTOP)
void SetWindowIcon(Image image);                            // Set icon for window (only PLATFORM_DESKTOP)
void SetWindowTitle(const char *title);                     // Set title for window (only PLATFORM_DESKTOP)
void SetWindowPosition(int x, int y);                       // Set window position on screen (only PLATFORM_DESKTOP)
void SetWindowMonitor(int monitor);                         // Set monitor for the current window (fullscreen mode)
void SetWindowMinSize(int width, int height);               // Set window minimum dimensions (for FLAG_WINDOW_RESIZABLE)
void SetWindowSize(int width, int height);                  // Set window dimensions
void *GetWindowHandle(void);                                // Get native window handle
int GetScreenWidth(void);                                   // Get current screen width
int GetScreenHeight(void);                                  // Get current screen height
int GetMonitorCount(void);                                  // Get number of connected monitors
int GetCurrentMonitor(void);                                // Get current connected monitor
Vector2 GetMonitorPosition(int monitor);                    // Get specified monitor position
int GetMonitorWidth(int monitor);                           // Get specified monitor width (max available by monitor)
int GetMonitorHeight(int monitor);                          // Get specified monitor height (max available by monitor)
int GetMonitorPhysicalWidth(int monitor);                   // Get specified monitor physical width in millimetres
int GetMonitorPhysicalHeight(int monitor);                  // Get specified monitor physical height in millimetres
int GetMonitorRefreshRate(int monitor);                     // Get specified monitor refresh rate
Vector2 GetWindowPosition(void);                            // Get window position XY on monitor
Vector2 GetWindowScaleDPI(void);                            // Get window scale DPI factor
const char *GetMonitorName(int monitor);                    // Get the human-readable, UTF-8 encoded name of the primary monitor
void SetClipboardText(const char *text);                    // Set clipboard text content
const char *GetClipboardText(void);                         // Get clipboard text content

// Custom frame control functions
// NOTE: Those functions are intended for advance users that want full control over the frame processing
// By default EndDrawing() does this job: draws everything + SwapScreenBuffer() + manage frame timming + PollInputEvents()
// To avoid that behaviour and control frame processes manually, enable in config.h: SUPPORT_CUSTOM_FRAME_CONTROL
void SwapScreenBuffer(void);                                // Swap back buffer with front buffer (screen drawing)
void PollInputEvents(void);                                 // Register all input events
void WaitTime(float ms);                                    // Wait for some milliseconds (halt program execution)

// Cursor-related functions
void ShowCursor(void);                                      // Shows cursor
void HideCursor(void);                                      // Hides cursor
bool IsCursorHidden(void);                                  // Check if cursor is not visible
void EnableCursor(void);                                    // Enables cursor (unlock cursor)
void DisableCursor(void);                                   // Disables cursor (lock cursor)
bool IsCursorOnScreen(void);                                // Check if cursor is on the screen

// Drawing-related functions
void ClearBackground(Color color);                          // Set background color (framebuffer clear color)
void BeginDrawing(void);                                    // Setup canvas (framebuffer) to start drawing
void EndDrawing(void);                                      // End canvas drawing and swap buffers (double buffering)
void BeginMode2D(Camera2D camera);                          // Begin 2D mode with custom camera (2D)
void EndMode2D(void);                                       // Ends 2D mode with custom camera
void BeginMode3D(Camera3D camera);                          // Begin 3D mode with custom camera (3D)
void EndMode3D(void);                                       // Ends 3D mode and returns to default 2D orthographic mode
void BeginTextureMode(RenderTexture2D target);              // Begin drawing to render texture
void EndTextureMode(void);                                  // Ends drawing to render texture
void BeginShaderMode(Shader shader);                        // Begin custom shader drawing
void EndShaderMode(void);                                   // End custom shader drawing (use default shader)
void BeginBlendMode(int mode);                              // Begin blending mode (alpha, additive, multiplied, subtract, custom)
void EndBlendMode(void);                                    // End blending mode (reset to default: alpha blending)
void BeginScissorMode(int x, int y, int width, int height); // Begin scissor mode (define screen area for following drawing)
void EndScissorMode(void);                                  // End scissor mode
void BeginVrStereoMode(VrStereoConfig config);              // Begin stereo rendering (requires VR simulator)
void EndVrStereoMode(void);                                 // End stereo rendering (requires VR simulator)

// VR stereo config functions for VR simulator
VrStereoConfig LoadVrStereoConfig(VrDeviceInfo device);     // Load VR stereo config for VR simulator device parameters
void UnloadVrStereoConfig(VrStereoConfig config);           // Unload VR stereo config

// Shader management functions
// NOTE: Shader functionality is not available on OpenGL 1.1
Shader LoadShader(const char *vsFileName, const char *fsFileName);   // Load shader from files and bind default locations
Shader LoadShaderFromMemory(const char *vsCode, const char *fsCode); // Load shader from code strings and bind default locations
int GetShaderLocation(Shader shader, const char *uniformName);       // Get shader uniform location
int GetShaderLocationAttrib(Shader shader, const char *attribName);  // Get shader attribute location
void SetShaderValue(Shader shader, int locIndex, const void *value, int uniformType);               // Set shader uniform value
void SetShaderValueV(Shader shader, int locIndex, const void *value, int uniformType, int count);   // Set shader uniform value vector
void SetShaderValueMatrix(Shader shader, int locIndex, Matrix mat);         // Set shader uniform value (matrix 4x4)
void SetShaderValueTexture(Shader shader, int locIndex, Texture2D texture); // Set shader uniform value for texture (sampler2d)
void UnloadShader(Shader shader);                                    // Unload shader from GPU memory (VRAM)

// Screen-space-related functions
Ray GetMouseRay(Vector2 mousePosition, Camera camera);      // Get a ray trace from mouse position
Matrix GetCameraMatrix(Camera camera);                      // Get camera transform matrix (view matrix)
Matrix GetCameraMatrix2D(Camera2D camera);                  // Get camera 2d transform matrix
Vector2 GetWorldToScreen(Vector3 position, Camera camera);  // Get the screen space position for a 3d world space position
Vector2 GetWorldToScreenEx(Vector3 position, Camera camera, int width, int height); // Get size position for a 3d world space position
Vector2 GetWorldToScreen2D(Vector2 position, Camera2D camera); // Get the screen space position for a 2d camera world space position
Vector2 GetScreenToWorld2D(Vector2 position, Camera2D camera); // Get the world space position for a 2d camera screen space position

// Timing-related functions
void SetTargetFPS(int fps);                                 // Set target FPS (maximum)
int GetFPS(void);                                           // Get current FPS
float GetFrameTime(void);                                   // Get time in seconds for last frame drawn (delta time)
double GetTime(void);                                       // Get elapsed time in seconds since InitWindow()

// Misc. functions
int GetRandomValue(int min, int max);                       // Get a random value between min and max (both included)
void SetRandomSeed(unsigned int seed);                      // Set the seed for the random number generator
void TakeScreenshot(const char *fileName);                  // Takes a screenshot of current screen (filename extension defines format)
void SetConfigFlags(unsigned int flags);                    // Setup init configuration flags (view FLAGS)

void TraceLog(int logLevel, const char *text, ...);         // Show trace log messages (LOG_DEBUG, LOG_INFO, LOG_WARNING, LOG_ERROR...)
void SetTraceLogLevel(int logLevel);                        // Set the current threshold (minimum) log level
void *MemAlloc(int size);                                   // Internal memory allocator
void *MemRealloc(void *ptr, int size);                      // Internal memory reallocator
void MemFree(void *ptr);                                    // Internal memory free

// Set custom callbacks
// WARNING: Callbacks setup is intended for advance users
void SetTraceLogCallback(TraceLogCallback callback);         // Set custom trace log
void SetLoadFileDataCallback(LoadFileDataCallback callback); // Set custom file binary data loader
void SetSaveFileDataCallback(SaveFileDataCallback callback); // Set custom file binary data saver
void SetLoadFileTextCallback(LoadFileTextCallback callback); // Set custom file text data loader
void SetSaveFileTextCallback(SaveFileTextCallback callback); // Set custom file text data saver

// Files management functions
unsigned char *LoadFileData(const char *fileName, unsigned int *bytesRead);     // Load file data as byte array (read)
void UnloadFileData(unsigned char *data);                   // Unload file data allocated by LoadFileData()
bool SaveFileData(const char *fileName, void *data, unsigned int bytesToWrite); // Save data to file from byte array (write), returns true on success
char *LoadFileText(const char *fileName);                   // Load text data from file (read), returns a '\0' terminated string
void UnloadFileText(char *text);                            // Unload file text data allocated by LoadFileText()
bool SaveFileText(const char *fileName, char *text);        // Save text data to file (write), string must be '\0' terminated, returns true on success
bool FileExists(const char *fileName);                      // Check if file exists
bool DirectoryExists(const char *dirPath);                  // Check if a directory path exists
bool IsFileExtension(const char *fileName, const char *ext);// Check file extension (including point: .png, .wav)
const char *GetFileExtension(const char *fileName);         // Get pointer to extension for a filename string (includes dot: '.png')
const char *GetFileName(const char *filePath);              // Get pointer to filename for a path string
const char *GetFileNameWithoutExt(const char *filePath);    // Get filename string without extension (uses static string)
const char *GetDirectoryPath(const char *filePath);         // Get full path for a given fileName with path (uses static string)
const char *GetPrevDirectoryPath(const char *dirPath);      // Get previous directory path for a given path (uses static string)
const char *GetWorkingDirectory(void);                      // Get current working directory (uses static string)
char **GetDirectoryFiles(const char *dirPath, int *count);  // Get filenames in a directory path (memory should be freed)
void ClearDirectoryFiles(void);                             // Clear directory files paths buffers (free memory)
bool ChangeDirectory(const char *dir);                      // Change working directory, return true on success
bool IsFileDropped(void);                                   // Check if a file has been dropped into window
char **GetDroppedFiles(int *count);                         // Get dropped files names (memory should be freed)
void ClearDroppedFiles(void);                               // Clear dropped files paths buffer (free memory)
long GetFileModTime(const char *fileName);                  // Get file modification time (last write time)

// Compression/Encoding functionality
unsigned char *CompressData(unsigned char *data, int dataLength, int *compDataLength);        // Compress data (DEFLATE algorithm)
unsigned char *DecompressData(unsigned char *compData, int compDataLength, int *dataLength);  // Decompress data (DEFLATE algorithm)
char *EncodeDataBase64(const unsigned char *data, int dataLength, int *outputLength);         // Encode data to Base64 string
unsigned char *DecodeDataBase64(unsigned char *data, int *outputLength);                      // Decode Base64 string data

// Persistent storage management
bool SaveStorageValue(unsigned int position, int value);    // Save integer value to storage file (to defined position), returns true on success
int LoadStorageValue(unsigned int position);                // Load integer value from storage file (from defined position)

void OpenURL(const char *url);                              // Open URL with default system browser (if available)

//------------------------------------------------------------------------------------
// Input Handling Functions (Module: core)
//------------------------------------------------------------------------------------

// Input-related functions: keyboard
bool IsKeyPressed(int key);                             // Check if a key has been pressed once
bool IsKeyDown(int key);                                // Check if a key is being pressed
bool IsKeyReleased(int key);                            // Check if a key has been released once
bool IsKeyUp(int key);                                  // Check if a key is NOT being pressed
void SetExitKey(int key);                               // Set a custom key to exit program (default is ESC)
int GetKeyPressed(void);                                // Get key pressed (keycode), call it multiple times for keys queued, returns 0 when the queue is empty
int GetCharPressed(void);                               // Get char pressed (unicode), call it multiple times for chars queued, returns 0 when the queue is empty

// Input-related functions: gamepads
bool IsGamepadAvailable(int gamepad);                   // Check if a gamepad is available
const char *GetGamepadName(int gamepad);                // Get gamepad internal name id
bool IsGamepadButtonPressed(int gamepad, int button);   // Check if a gamepad button has been pressed once
bool IsGamepadButtonDown(int gamepad, int button);      // Check if a gamepad button is being pressed
bool IsGamepadButtonReleased(int gamepad, int button);  // Check if a gamepad button has been released once
bool IsGamepadButtonUp(int gamepad, int button);        // Check if a gamepad button is NOT being pressed
int GetGamepadButtonPressed(void);                      // Get the last gamepad button pressed
int GetGamepadAxisCount(int gamepad);                   // Get gamepad axis count for a gamepad
float GetGamepadAxisMovement(int gamepad, int axis);    // Get axis movement value for a gamepad axis
int SetGamepadMappings(const char *mappings);           // Set internal gamepad mappings (SDL_GameControllerDB)

// Input-related functions: mouse
bool IsMouseButtonPressed(int button);                  // Check if a mouse button has been pressed once
bool IsMouseButtonDown(int button);                     // Check if a mouse button is being pressed
bool IsMouseButtonReleased(int button);                 // Check if a mouse button has been released once
bool IsMouseButtonUp(int button);                       // Check if a mouse button is NOT being pressed
int GetMouseX(void);                                    // Get mouse position X
int GetMouseY(void);                                    // Get mouse position Y
Vector2 GetMousePosition(void);                         // Get mouse position XY
Vector2 GetMouseDelta(void);                            // Get mouse delta between frames
void SetMousePosition(int x, int y);                    // Set mouse position XY
void SetMouseOffset(int offsetX, int offsetY);          // Set mouse offset
void SetMouseScale(float scaleX, float scaleY);         // Set mouse scaling
float GetMouseWheelMove(void);                          // Get mouse wheel movement Y
void SetMouseCursor(int cursor);                        // Set mouse cursor

// Input-related functions: touch
int GetTouchX(void);                                    // Get touch position X for touch point 0 (relative to screen size)
int GetTouchY(void);                                    // Get touch position Y for touch point 0 (relative to screen size)
Vector2 GetTouchPosition(int index);                    // Get touch position XY for a touch point index (relative to screen size)
int GetTouchPointId(int index);                         // Get touch point identifier for given index
int GetTouchPointCount(void);                           // Get number of touch points

//------------------------------------------------------------------------------------
// Gestures and Touch Handling Functions (Module: rgestures)
//------------------------------------------------------------------------------------
void SetGesturesEnabled(unsigned int flags);      // Enable a set of gestures using flags
bool IsGestureDetected(int gesture);              // Check if a gesture have been detected
int GetGestureDetected(void);                     // Get latest detected gesture
float GetGestureHoldDuration(void);               // Get gesture hold time in milliseconds
Vector2 GetGestureDragVector(void);               // Get gesture drag vector
float GetGestureDragAngle(void);                  // Get gesture drag angle
Vector2 GetGesturePinchVector(void);              // Get gesture pinch delta
float GetGesturePinchAngle(void);                 // Get gesture pinch angle

//------------------------------------------------------------------------------------
// Camera System Functions (Module: rcamera)
//------------------------------------------------------------------------------------
void SetCameraMode(Camera camera, int mode);      // Set camera mode (multiple camera modes available)
void UpdateCamera(Camera *camera);                // Update camera position for selected mode

void SetCameraPanControl(int keyPan);             // Set camera pan key to combine with mouse movement (free camera)
void SetCameraAltControl(int keyAlt);             // Set camera alt key to combine with mouse movement (free camera)
void SetCameraSmoothZoomControl(int keySmoothZoom); // Set camera smooth zoom key to combine with mouse (free camera)
void SetCameraMoveControls(int keyFront, int keyBack, int keyRight, int keyLeft, int keyUp, int keyDown); // Set camera move controls (1st person and 3rd person cameras)

//------------------------------------------------------------------------------------
// Basic Shapes Drawing Functions (Module: shapes)
//------------------------------------------------------------------------------------
// Set texture and rectangle to be used on shapes drawing
// NOTE: It can be useful when using basic shapes and one single font,
// defining a font char white rectangle would allow drawing everything in a single draw call
void SetShapesTexture(Texture2D texture, Rectangle source);       // Set texture and rectangle to be used on shapes drawing

// Basic shapes drawing functions
void DrawPixel(int posX, int posY, Color color);                                                   // Draw a pixel
void DrawPixelV(Vector2 position, Color color);                                                    // Draw a pixel (Vector version)
void DrawLine(int startPosX, int startPosY, int endPosX, int endPosY, Color color);                // Draw a line
void DrawLineV(Vector2 startPos, Vector2 endPos, Color color);                                     // Draw a line (Vector version)
void DrawLineEx(Vector2 startPos, Vector2 endPos, float thick, Color color);                       // Draw a line defining thickness
void DrawLineBezier(Vector2 startPos, Vector2 endPos, float thick, Color color);                   // Draw a line using cubic-bezier curves in-out
void DrawLineBezierQuad(Vector2 startPos, Vector2 endPos, Vector2 controlPos, float thick, Color color); // Draw line using quadratic bezier curves with a control point
void DrawLineBezierCubic(Vector2 startPos, Vector2 endPos, Vector2 startControlPos, Vector2 endControlPos, float thick, Color color); // Draw line using cubic bezier curves with 2 control points
void DrawLineStrip(Vector2 *points, int pointCount, Color color);                                  // Draw lines sequence
void DrawCircle(int centerX, int centerY, float radius, Color color);                              // Draw a color-filled circle
void DrawCircleSector(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color);      // Draw a piece of a circle
void DrawCircleSectorLines(Vector2 center, float radius, float startAngle, float endAngle, int segments, Color color); // Draw circle sector outline
void DrawCircleGradient(int centerX, int centerY, float radius, Color color1, Color color2);       // Draw a gradient-filled circle
void DrawCircleV(Vector2 center, float radius, Color color);                                       // Draw a color-filled circle (Vector version)
void DrawCircleLines(int centerX, int centerY, float radius, Color color);                         // Draw circle outline
void DrawEllipse(int centerX, int centerY, float radiusH, float radiusV, Color color);             // Draw ellipse
void DrawEllipseLines(int centerX, int centerY, float radiusH, float radiusV, Color color);        // Draw ellipse outline
void DrawRing(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color); // Draw ring
void DrawRingLines(Vector2 center, float innerRadius, float outerRadius, float startAngle, float endAngle, int segments, Color color);    // Draw ring outline
void DrawRectangle(int posX, int posY, int width, int height, Color color);                        // Draw a color-filled rectangle
void DrawRectangleV(Vector2 position, Vector2 size, Color color);                                  // Draw a color-filled rectangle (Vector version)
void DrawRectangleRec(Rectangle rec, Color color);                                                 // Draw a color-filled rectangle
void DrawRectanglePro(Rectangle rec, Vector2 origin, float rotation, Color color);                 // Draw a color-filled rectangle with pro parameters
void DrawRectangleGradientV(int posX, int posY, int width, int height, Color color1, Color color2);// Draw a vertical-gradient-filled rectangle
void DrawRectangleGradientH(int posX, int posY, int width, int height, Color color1, Color color2);// Draw a horizontal-gradient-filled rectangle
void DrawRectangleGradientEx(Rectangle rec, Color col1, Color col2, Color col3, Color col4);       // Draw a gradient-filled rectangle with custom vertex colors
void DrawRectangleLines(int posX, int posY, int width, int height, Color color);                   // Draw rectangle outline
void DrawRectangleLinesEx(Rectangle rec, float lineThick, Color color);                            // Draw rectangle outline with extended parameters
void DrawRectangleRounded(Rectangle rec, float roundness, int segments, Color color);              // Draw rectangle with rounded edges
void DrawRectangleRoundedLines(Rectangle rec, float roundness, int segments, float lineThick, Color color); // Draw rectangle with rounded edges outline
void DrawTriangle(Vector2 v1, Vector2 v2, Vector2 v3, Color color);                                // Draw a color-filled triangle (vertex in counter-clockwise order!)
void DrawTriangleLines(Vector2 v1, Vector2 v2, Vector2 v3, Color color);                           // Draw triangle outline (vertex in counter-clockwise order!)
void DrawTriangleFan(Vector2 *points, int pointCount, Color color);                                // Draw a triangle fan defined by points (first vertex is the center)
void DrawTriangleStrip(Vector2 *points, int pointCount, Color color);                              // Draw a triangle strip defined by points
void DrawPoly(Vector2 center, int sides, float radius, float rotation, Color color);               // Draw a regular polygon (Vector version)
void DrawPolyLines(Vector2 center, int sides, float radius, float rotation, Color color);          // Draw a polygon outline of n sides
void DrawPolyLinesEx(Vector2 center, int sides, float radius, float rotation, float lineThick, Color color); // Draw a polygon outline of n sides with extended parameters

// Basic shapes collision detection functions
bool CheckCollisionRecs(Rectangle rec1, Rectangle rec2);                                           // Check collision between two rectangles
bool CheckCollisionCircles(Vector2 center1, float radius1, Vector2 center2, float radius2);        // Check collision between two circles
bool CheckCollisionCircleRec(Vector2 center, float radius, Rectangle rec);                         // Check collision between circle and rectangle
bool CheckCollisionPointRec(Vector2 point, Rectangle rec);                                         // Check if point is inside rectangle
bool CheckCollisionPointCircle(Vector2 point, Vector2 center, float radius);                       // Check if point is inside circle
bool CheckCollisionPointTriangle(Vector2 point, Vector2 p1, Vector2 p2, Vector2 p3);               // Check if point is inside a triangle
bool CheckCollisionLines(Vector2 startPos1, Vector2 endPos1, Vector2 startPos2, Vector2 endPos2, Vector2 *collisionPoint); // Check the collision between two lines defined by two points each, returns collision point by reference
bool CheckCollisionPointLine(Vector2 point, Vector2 p1, Vector2 p2, int threshold);                // Check if point belongs to line created between two points [p1] and [p2] with defined margin in pixels [threshold]
Rectangle GetCollisionRec(Rectangle rec1, Rectangle rec2);                                         // Get collision rectangle for two rectangles collision

//------------------------------------------------------------------------------------
// Texture Loading and Drawing Functions (Module: textures)
//------------------------------------------------------------------------------------

// Image loading functions
// NOTE: This functions do not require GPU access
Image LoadImage(const char *fileName);                                                             // Load image from file into CPU memory (RAM)
Image LoadImageRaw(const char *fileName, int width, int height, int format, int headerSize);       // Load image from RAW file data
Image LoadImageAnim(const char *fileName, int *frames);                                            // Load image sequence from file (frames appended to image.data)
Image LoadImageFromMemory(const char *fileType, const unsigned char *fileData, int dataSize);      // Load image from memory buffer, fileType refers to extension: i.e. '.png'
Image LoadImageFromTexture(Texture2D texture);                                                     // Load image from GPU texture data
Image LoadImageFromScreen(void);                                                                   // Load image from screen buffer and (screenshot)
void UnloadImage(Image image);                                                                     // Unload image from CPU memory (RAM)
bool ExportImage(Image image, const char *fileName);                                               // Export image data to file, returns true on success
bool ExportImageAsCode(Image image, const char *fileName);                                         // Export image as code file defining an array of bytes, returns true on success

// Image generation functions
Image GenImageColor(int width, int height, Color color);                                           // Generate image: plain color
Image GenImageGradientV(int width, int height, Color top, Color bottom);                           // Generate image: vertical gradient
Image GenImageGradientH(int width, int height, Color left, Color right);                           // Generate image: horizontal gradient
Image GenImageGradientRadial(int width, int height, float density, Color inner, Color outer);      // Generate image: radial gradient
Image GenImageChecked(int width, int height, int checksX, int checksY, Color col1, Color col2);    // Generate image: checked
Image GenImageWhiteNoise(int width, int height, float factor);                                     // Generate image: white noise
Image GenImageCellular(int width, int height, int tileSize);                                       // Generate image: cellular algorithm, bigger tileSize means bigger cells

// Image manipulation functions
Image ImageCopy(Image image);                                                                      // Create an image duplicate (useful for transformations)
Image ImageFromImage(Image image, Rectangle rec);                                                  // Create an image from another image piece
Image ImageText(const char *text, int fontSize, Color color);                                      // Create an image from text (default font)
Image ImageTextEx(Font font, const char *text, float fontSize, float spacing, Color tint);         // Create an image from text (custom sprite font)
void ImageFormat(Image *image, int newFormat);                                                     // Convert image data to desired format
void ImageToPOT(Image *image, Color fill);                                                         // Convert image to POT (power-of-two)
void ImageCrop(Image *image, Rectangle crop);                                                      // Crop an image to a defined rectangle
void ImageAlphaCrop(Image *image, float threshold);                                                // Crop image depending on alpha value
void ImageAlphaClear(Image *image, Color color, float threshold);                                  // Clear alpha channel to desired color
void ImageAlphaMask(Image *image, Image alphaMask);                                                // Apply alpha mask to image
void ImageAlphaPremultiply(Image *image);                                                          // Premultiply alpha channel
void ImageResize(Image *image, int newWidth, int newHeight);                                       // Resize image (Bicubic scaling algorithm)
void ImageResizeNN(Image *image, int newWidth,int newHeight);                                      // Resize image (Nearest-Neighbor scaling algorithm)
void ImageResizeCanvas(Image *image, int newWidth, int newHeight, int offsetX, int offsetY, Color fill);  // Resize canvas and fill with color
void ImageMipmaps(Image *image);                                                                   // Compute all mipmap levels for a provided image
void ImageDither(Image *image, int rBpp, int gBpp, int bBpp, int aBpp);                            // Dither image data to 16bpp or lower (Floyd-Steinberg dithering)
void ImageFlipVertical(Image *image);                                                              // Flip image vertically
void ImageFlipHorizontal(Image *image);                                                            // Flip image horizontally
void ImageRotateCW(Image *image);                                                                  // Rotate image clockwise 90deg
void ImageRotateCCW(Image *image);                                                                 // Rotate image counter-clockwise 90deg
void ImageColorTint(Image *image, Color color);                                                    // Modify image color: tint
void ImageColorInvert(Image *image);                                                               // Modify image color: invert
void ImageColorGrayscale(Image *image);                                                            // Modify image color: grayscale
void ImageColorContrast(Image *image, float contrast);                                             // Modify image color: contrast (-100 to 100)
void ImageColorBrightness(Image *image, int brightness);                                           // Modify image color: brightness (-255 to 255)
void ImageColorReplace(Image *image, Color color, Color replace);                                  // Modify image color: replace color
Color *LoadImageColors(Image image);                                                               // Load color data from image as a Color array (RGBA - 32bit)
Color *LoadImagePalette(Image image, int maxPaletteSize, int *colorCount);                         // Load colors palette from image as a Color array (RGBA - 32bit)
void UnloadImageColors(Color *colors);                                                             // Unload color data loaded with LoadImageColors()
void UnloadImagePalette(Color *colors);                                                            // Unload colors palette loaded with LoadImagePalette()
Rectangle GetImageAlphaBorder(Image image, float threshold);                                       // Get image alpha border rectangle
Color GetImageColor(Image image, int x, int y);                                                    // Get image pixel color at (x, y) position

// Image drawing functions
// NOTE: Image software-rendering functions (CPU)
void ImageClearBackground(Image *dst, Color color);                                                // Clear image background with given color
void ImageDrawPixel(Image *dst, int posX, int posY, Color color);                                  // Draw pixel within an image
void ImageDrawPixelV(Image *dst, Vector2 position, Color color);                                   // Draw pixel within an image (Vector version)
void ImageDrawLine(Image *dst, int startPosX, int startPosY, int endPosX, int endPosY, Color color); // Draw line within an image
void ImageDrawLineV(Image *dst, Vector2 start, Vector2 end, Color color);                          // Draw line within an image (Vector version)
void ImageDrawCircle(Image *dst, int centerX, int centerY, int radius, Color color);               // Draw circle within an image
void ImageDrawCircleV(Image *dst, Vector2 center, int radius, Color color);                        // Draw circle within an image (Vector version)
void ImageDrawRectangle(Image *dst, int posX, int posY, int width, int height, Color color);       // Draw rectangle within an image
void ImageDrawRectangleV(Image *dst, Vector2 position, Vector2 size, Color color);                 // Draw rectangle within an image (Vector version)
void ImageDrawRectangleRec(Image *dst, Rectangle rec, Color color);                                // Draw rectangle within an image
void ImageDrawRectangleLines(Image *dst, Rectangle rec, int thick, Color color);                   // Draw rectangle lines within an image
void ImageDraw(Image *dst, Image src, Rectangle srcRec, Rectangle dstRec, Color tint);             // Draw a source image within a destination image (tint applied to source)
void ImageDrawText(Image *dst, const char *text, int posX, int posY, int fontSize, Color color);   // Draw text (using default font) within an image (destination)
void ImageDrawTextEx(Image *dst, Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint); // Draw text (custom sprite font) within an image (destination)

// Texture loading functions
// NOTE: These functions require GPU access
Texture2D LoadTexture(const char *fileName);                                                       // Load texture from file into GPU memory (VRAM)
Texture2D LoadTextureFromImage(Image image);                                                       // Load texture from image data
TextureCubemap LoadTextureCubemap(Image image, int layout);                                        // Load cubemap from image, multiple image cubemap layouts supported
RenderTexture2D LoadRenderTexture(int width, int height);                                          // Load texture for rendering (framebuffer)
void UnloadTexture(Texture2D texture);                                                             // Unload texture from GPU memory (VRAM)
void UnloadRenderTexture(RenderTexture2D target);                                                  // Unload render texture from GPU memory (VRAM)
void UpdateTexture(Texture2D texture, const void *pixels);                                         // Update GPU texture with new data
void UpdateTextureRec(Texture2D texture, Rectangle rec, const void *pixels);                       // Update GPU texture rectangle with new data

// Texture configuration functions
void GenTextureMipmaps(Texture2D *texture);                                                        // Generate GPU mipmaps for a texture
void SetTextureFilter(Texture2D texture, int filter);                                              // Set texture scaling filter mode
void SetTextureWrap(Texture2D texture, int wrap);                                                  // Set texture wrapping mode

// Texture drawing functions
void DrawTexture(Texture2D texture, int posX, int posY, Color tint);                               // Draw a Texture2D
void DrawTextureV(Texture2D texture, Vector2 position, Color tint);                                // Draw a Texture2D with position defined as Vector2
void DrawTextureEx(Texture2D texture, Vector2 position, float rotation, float scale, Color tint);  // Draw a Texture2D with extended parameters
void DrawTextureRec(Texture2D texture, Rectangle source, Vector2 position, Color tint);            // Draw a part of a texture defined by a rectangle
void DrawTextureQuad(Texture2D texture, Vector2 tiling, Vector2 offset, Rectangle quad, Color tint);  // Draw texture quad with tiling and offset parameters
void DrawTextureTiled(Texture2D texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, float scale, Color tint);      // Draw part of a texture (defined by a rectangle) with rotation and scale tiled into dest.
void DrawTexturePro(Texture2D texture, Rectangle source, Rectangle dest, Vector2 origin, float rotation, Color tint);           // Draw a part of a texture defined by a rectangle with 'pro' parameters
void DrawTextureNPatch(Texture2D texture, NPatchInfo nPatchInfo, Rectangle dest, Vector2 origin, float rotation, Color tint);   // Draws a texture (or part of it) that stretches or shrinks nicely
void DrawTexturePoly(Texture2D texture, Vector2 center, Vector2 *points, Vector2 *texcoords, int pointCount, Color tint);      // Draw a textured polygon

// Color/pixel related functions
Color Fade(Color color, float alpha);                                 // Get color with alpha applied, alpha goes from 0.0f to 1.0f
int ColorToInt(Color color);                                          // Get hexadecimal value for a Color
Vector4 ColorNormalize(Color color);                                  // Get Color normalized as float [0..1]
Color ColorFromNormalized(Vector4 normalized);                        // Get Color from normalized values [0..1]
Vector3 ColorToHSV(Color color);                                      // Get HSV values for a Color, hue [0..360], saturation/value [0..1]
Color ColorFromHSV(float hue, float saturation, float value);         // Get a Color from HSV values, hue [0..360], saturation/value [0..1]
Color ColorAlpha(Color color, float alpha);                           // Get color with alpha applied, alpha goes from 0.0f to 1.0f
Color ColorAlphaBlend(Color dst, Color src, Color tint);              // Get src alpha-blended into dst color with tint
Color GetColor(unsigned int hexValue);                                // Get Color structure from hexadecimal value
Color GetPixelColor(void *srcPtr, int format);                        // Get Color from a source pixel pointer of certain format
void SetPixelColor(void *dstPtr, Color color, int format);            // Set color formatted into destination pixel pointer
int GetPixelDataSize(int width, int height, int format);              // Get pixel data size in bytes for certain format

//------------------------------------------------------------------------------------
// Font Loading and Text Drawing Functions (Module: text)
//------------------------------------------------------------------------------------

// Font loading/unloading functions
Font GetFontDefault(void);                                                            // Get the default Font
Font LoadFont(const char *fileName);                                                  // Load font from file into GPU memory (VRAM)
Font LoadFontEx(const char *fileName, int fontSize, int *fontChars, int glyphCount);  // Load font from file with extended parameters
Font LoadFontFromImage(Image image, Color key, int firstChar);                        // Load font from Image (XNA style)
Font LoadFontFromMemory(const char *fileType, const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount); // Load font from memory buffer, fileType refers to extension: i.e. '.ttf'
GlyphInfo *LoadFontData(const unsigned char *fileData, int dataSize, int fontSize, int *fontChars, int glyphCount, int type);      // Load font data for further use
Image GenImageFontAtlas(const GlyphInfo *chars, Rectangle **recs, int glyphCount, int fontSize, int padding, int packMethod);      // Generate image font atlas using chars info
void UnloadFontData(GlyphInfo *chars, int glyphCount);                                 // Unload font chars info data (RAM)
void UnloadFont(Font font);                                                           // Unload Font from GPU memory (VRAM)

// Text drawing functions
void DrawFPS(int posX, int posY);                                                     // Draw current FPS
void DrawText(const char *text, int posX, int posY, int fontSize, Color color);       // Draw text (using default font)
void DrawTextEx(Font font, const char *text, Vector2 position, float fontSize, float spacing, Color tint);    // Draw text using font and additional parameters
void DrawTextPro(Font font, const char *text, Vector2 position, Vector2 origin, float rotation, float fontSize, float spacing, Color tint); // Draw text using Font and pro parameters (rotation)
void DrawTextCodepoint(Font font, int codepoint, Vector2 position, float fontSize, Color tint);   // Draw one character (codepoint)

// Text font info functions
int MeasureText(const char *text, int fontSize);                                      // Measure string width for default font
Vector2 MeasureTextEx(Font font, const char *text, float fontSize, float spacing);    // Measure string size for Font
int GetGlyphIndex(Font font, int codepoint);                                          // Get glyph index position in font for a codepoint (unicode character), fallback to '?' if not found
GlyphInfo GetGlyphInfo(Font font, int codepoint);                                     // Get glyph font info data for a codepoint (unicode character), fallback to '?' if not found
Rectangle GetGlyphAtlasRec(Font font, int codepoint);                                 // Get glyph rectangle in font atlas for a codepoint (unicode character), fallback to '?' if not found

// Text codepoints management functions (unicode characters)
int *LoadCodepoints(const char *text, int *count);              // Load all codepoints from a UTF-8 text string, codepoints count returned by parameter
void UnloadCodepoints(int *codepoints);                         // Unload codepoints data from memory
int GetCodepointCount(const char *text);                        // Get total number of codepoints in a UTF-8 encoded string
int GetCodepoint(const char *text, int *bytesProcessed);        // Get next codepoint in a UTF-8 encoded string, 0x3f('?') is returned on failure
const char *CodepointToUTF8(int codepoint, int *byteSize);      // Encode one codepoint into UTF-8 byte array (array length returned as parameter)
char *TextCodepointsToUTF8(int *codepoints, int length);        // Encode text as codepoints array into UTF-8 text string (WARNING: memory must be freed!)

// Text strings management functions (no UTF-8 strings, only byte chars)
// NOTE: Some strings allocate memory internally for returned strings, just be careful!
int TextCopy(char *dst, const char *src);                                             // Copy one string to another, returns bytes copied
bool TextIsEqual(const char *text1, const char *text2);                               // Check if two text string are equal
unsigned int TextLength(const char *text);                                            // Get text length, checks for '\0' ending
const char *TextFormat(const char *text, ...);                                        // Text formatting with variables (sprintf() style)
const char *TextSubtext(const char *text, int position, int length);                  // Get a piece of a text string
char *TextReplace(char *text, const char *replace, const char *by);                   // Replace text string (WARNING: memory must be freed!)
char *TextInsert(const char *text, const char *insert, int position);                 // Insert text in a position (WARNING: memory must be freed!)
const char *TextJoin(const char **textList, int count, const char *delimiter);        // Join text strings with delimiter
const char **TextSplit(const char *text, char delimiter, int *count);                 // Split text into multiple strings
void TextAppend(char *text, const char *append, int *position);                       // Append text at specific position and move cursor!
int TextFindIndex(const char *text, const char *find);                                // Find first text occurrence within a string
const char *TextToUpper(const char *text);                      // Get upper case version of provided string
const char *TextToLower(const char *text);                      // Get lower case version of provided string
const char *TextToPascal(const char *text);                     // Get Pascal case notation version of provided string
int TextToInteger(const char *text);                            // Get integer value from text (negative values not supported)

//------------------------------------------------------------------------------------
// Basic 3d Shapes Drawing Functions (Module: models)
//------------------------------------------------------------------------------------

// Basic geometric 3D shapes drawing functions
void DrawLine3D(Vector3 startPos, Vector3 endPos, Color color);                                    // Draw a line in 3D world space
void DrawPoint3D(Vector3 position, Color color);                                                   // Draw a point in 3D space, actually a small line
void DrawCircle3D(Vector3 center, float radius, Vector3 rotationAxis, float rotationAngle, Color color); // Draw a circle in 3D world space
void DrawTriangle3D(Vector3 v1, Vector3 v2, Vector3 v3, Color color);                              // Draw a color-filled triangle (vertex in counter-clockwise order!)
void DrawTriangleStrip3D(Vector3 *points, int pointCount, Color color);                           // Draw a triangle strip defined by points
void DrawCube(Vector3 position, float width, float height, float length, Color color);             // Draw cube
void DrawCubeV(Vector3 position, Vector3 size, Color color);                                       // Draw cube (Vector version)
void DrawCubeWires(Vector3 position, float width, float height, float length, Color color);        // Draw cube wires
void DrawCubeWiresV(Vector3 position, Vector3 size, Color color);                                  // Draw cube wires (Vector version)
void DrawCubeTexture(Texture2D texture, Vector3 position, float width, float height, float length, Color color); // Draw cube textured
void DrawCubeTextureRec(Texture2D texture, Rectangle source, Vector3 position, float width, float height, float length, Color color); // Draw cube with a region of a texture
void DrawSphere(Vector3 centerPos, float radius, Color color);                                     // Draw sphere
void DrawSphereEx(Vector3 centerPos, float radius, int rings, int slices, Color color);            // Draw sphere with extended parameters
void DrawSphereWires(Vector3 centerPos, float radius, int rings, int slices, Color color);         // Draw sphere wires
void DrawCylinder(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color); // Draw a cylinder/cone
void DrawCylinderEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color); // Draw a cylinder with base at startPos and top at endPos
void DrawCylinderWires(Vector3 position, float radiusTop, float radiusBottom, float height, int slices, Color color); // Draw a cylinder/cone wires
void DrawCylinderWiresEx(Vector3 startPos, Vector3 endPos, float startRadius, float endRadius, int sides, Color color); // Draw a cylinder wires with base at startPos and top at endPos
void DrawPlane(Vector3 centerPos, Vector2 size, Color color);                                      // Draw a plane XZ
void DrawRay(Ray ray, Color color);                                                                // Draw a ray line
void DrawGrid(int slices, float spacing);                                                          // Draw a grid (centered at (0, 0, 0))

//------------------------------------------------------------------------------------
// Model 3d Loading and Drawing Functions (Module: models)
//------------------------------------------------------------------------------------

// Model management functions
Model LoadModel(const char *fileName);                                                // Load model from files (meshes and materials)
Model LoadModelFromMesh(Mesh mesh);                                                   // Load model from generated mesh (default material)
void UnloadModel(Model model);                                                        // Unload model (including meshes) from memory (RAM and/or VRAM)
void UnloadModelKeepMeshes(Model model);                                              // Unload model (but not meshes) from memory (RAM and/or VRAM)
BoundingBox GetModelBoundingBox(Model model);                                         // Compute model bounding box limits (considers all meshes)

// Model drawing functions
void DrawModel(Model model, Vector3 position, float scale, Color tint);                           // Draw a model (with texture if set)
void DrawModelEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint); // Draw a model with extended parameters
void DrawModelWires(Model model, Vector3 position, float scale, Color tint);                      // Draw a model wires (with texture if set)
void DrawModelWiresEx(Model model, Vector3 position, Vector3 rotationAxis, float rotationAngle, Vector3 scale, Color tint); // Draw a model wires (with texture if set) with extended parameters
void DrawBoundingBox(BoundingBox box, Color color);                                               // Draw bounding box (wires)
void DrawBillboard(Camera camera, Texture2D texture, Vector3 position, float size, Color tint);   // Draw a billboard texture
void DrawBillboardRec(Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector2 size, Color tint); // Draw a billboard texture defined by source
void DrawBillboardPro(Camera camera, Texture2D texture, Rectangle source, Vector3 position, Vector3 up, Vector2 size, Vector2 origin, float rotation, Color tint); // Draw a billboard texture defined by source and rotation

// Mesh management functions
void UploadMesh(Mesh *mesh, bool dynamic);                                            // Upload mesh vertex data in GPU and provide VAO/VBO ids
void UpdateMeshBuffer(Mesh mesh, int index, void *data, int dataSize, int offset);    // Update mesh vertex data in GPU for a specific buffer index
void UnloadMesh(Mesh mesh);                                                           // Unload mesh data from CPU and GPU
void DrawMesh(Mesh mesh, Material material, Matrix transform);                        // Draw a 3d mesh with material and transform
void DrawMeshInstanced(Mesh mesh, Material material, Matrix *transforms, int instances); // Draw multiple mesh instances with material and different transforms
bool ExportMesh(Mesh mesh, const char *fileName);                                     // Export mesh data to file, returns true on success
BoundingBox GetMeshBoundingBox(Mesh mesh);                                            // Compute mesh bounding box limits
void GenMeshTangents(Mesh *mesh);                                                     // Compute mesh tangents
void GenMeshBinormals(Mesh *mesh);                                                    // Compute mesh binormals

// Mesh generation functions
Mesh GenMeshPoly(int sides, float radius);                                            // Generate polygonal mesh
Mesh GenMeshPlane(float width, float length, int resX, int resZ);                     // Generate plane mesh (with subdivisions)
Mesh GenMeshCube(float width, float height, float length);                            // Generate cuboid mesh
Mesh GenMeshSphere(float radius, int rings, int slices);                              // Generate sphere mesh (standard sphere)
Mesh GenMeshHemiSphere(float radius, int rings, int slices);                          // Generate half-sphere mesh (no bottom cap)
Mesh GenMeshCylinder(float radius, float height, int slices);                         // Generate cylinder mesh
Mesh GenMeshCone(float radius, float height, int slices);                             // Generate cone/pyramid mesh
Mesh GenMeshTorus(float radius, float size, int radSeg, int sides);                   // Generate torus mesh
Mesh GenMeshKnot(float radius, float size, int radSeg, int sides);                    // Generate trefoil knot mesh
Mesh GenMeshHeightmap(Image heightmap, Vector3 size);                                 // Generate heightmap mesh from image data
Mesh GenMeshCubicmap(Image cubicmap, Vector3 cubeSize);                               // Generate cubes-based map mesh from image data

// Material loading/unloading functions
Material *LoadMaterials(const char *fileName, int *materialCount);                    // Load materials from model file
Material LoadMaterialDefault(void);                                                   // Load default material (Supports: DIFFUSE, SPECULAR, NORMAL maps)
void UnloadMaterial(Material material);                                               // Unload material from GPU memory (VRAM)
void SetMaterialTexture(Material *material, int mapType, Texture2D texture);          // Set texture for a material map type (MATERIAL_MAP_DIFFUSE, MATERIAL_MAP_SPECULAR...)
void SetModelMeshMaterial(Model *model, int meshId, int materialId);                  // Set material for a mesh

// Model animations loading/unloading functions
ModelAnimation *LoadModelAnimations(const char *fileName, unsigned int *animCount);   // Load model animations from file
void UpdateModelAnimation(Model model, ModelAnimation anim, int frame);               // Update model animation pose
void UnloadModelAnimation(ModelAnimation anim);                                       // Unload animation data
void UnloadModelAnimations(ModelAnimation* animations, unsigned int count);           // Unload animation array data
bool IsModelAnimationValid(Model model, ModelAnimation anim);                         // Check model animation skeleton match

// Collision detection functions
bool CheckCollisionSpheres(Vector3 center1, float radius1, Vector3 center2, float radius2);       // Check collision between two spheres
bool CheckCollisionBoxes(BoundingBox box1, BoundingBox box2);                                     // Check collision between two bounding boxes
bool CheckCollisionBoxSphere(BoundingBox box, Vector3 center, float radius);                      // Check collision between box and sphere
RayCollision GetRayCollisionSphere(Ray ray, Vector3 center, float radius);                        // Get collision info between ray and sphere
RayCollision GetRayCollisionBox(Ray ray, BoundingBox box);                                        // Get collision info between ray and box
RayCollision GetRayCollisionModel(Ray ray, Model model);                                          // Get collision info between ray and model
RayCollision GetRayCollisionMesh(Ray ray, Mesh mesh, Matrix transform);                           // Get collision info between ray and mesh
RayCollision GetRayCollisionTriangle(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3);                // Get collision info between ray and triangle
RayCollision GetRayCollisionQuad(Ray ray, Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4);        // Get collision info between ray and quad

//------------------------------------------------------------------------------------
// Audio Loading and Playing Functions (Module: audio)
//------------------------------------------------------------------------------------

// Audio device management functions
void InitAudioDevice(void);                                     // Initialize audio device and context
void CloseAudioDevice(void);                                    // Close the audio device and context
bool IsAudioDeviceReady(void);                                  // Check if audio device has been initialized successfully
void SetMasterVolume(float volume);                             // Set master volume (listener)

// Wave/Sound loading/unloading functions
Wave LoadWave(const char *fileName);                            // Load wave data from file
Wave LoadWaveFromMemory(const char *fileType, const unsigned char *fileData, int dataSize); // Load wave from memory buffer, fileType refers to extension: i.e. '.wav'
Sound LoadSound(const char *fileName);                          // Load sound from file
Sound LoadSoundFromWave(Wave wave);                             // Load sound from wave data
void UpdateSound(Sound sound, const void *data, int sampleCount); // Update sound buffer with new data
void UnloadWave(Wave wave);                                     // Unload wave data
void UnloadSound(Sound sound);                                  // Unload sound
bool ExportWave(Wave wave, const char *fileName);               // Export wave data to file, returns true on success
bool ExportWaveAsCode(Wave wave, const char *fileName);         // Export wave sample data to code (.h), returns true on success

// Wave/Sound management functions
void PlaySound(Sound sound);                                    // Play a sound
void StopSound(Sound sound);                                    // Stop playing a sound
void PauseSound(Sound sound);                                   // Pause a sound
void ResumeSound(Sound sound);                                  // Resume a paused sound
void PlaySoundMulti(Sound sound);                               // Play a sound (using multichannel buffer pool)
void StopSoundMulti(void);                                      // Stop any sound playing (using multichannel buffer pool)
int GetSoundsPlaying(void);                                     // Get number of sounds playing in the multichannel
bool IsSoundPlaying(Sound sound);                               // Check if a sound is currently playing
void SetSoundVolume(Sound sound, float volume);                 // Set volume for a sound (1.0 is max level)
void SetSoundPitch(Sound sound, float pitch);                   // Set pitch for a sound (1.0 is base level)
void WaveFormat(Wave *wave, int sampleRate, int sampleSize, int channels);  // Convert wave data to desired format
Wave WaveCopy(Wave wave);                                       // Copy a wave to a new wave
void WaveCrop(Wave *wave, int initSample, int finalSample);     // Crop a wave to defined samples range
float *LoadWaveSamples(Wave wave);                              // Load samples data from wave as a floats array
void UnloadWaveSamples(float *samples);                         // Unload samples data loaded with LoadWaveSamples()

// Music management functions
Music LoadMusicStream(const char *fileName);                    // Load music stream from file
Music LoadMusicStreamFromMemory(const char *fileType, unsigned char *data, int dataSize); // Load music stream from data
void UnloadMusicStream(Music music);                            // Unload music stream
void PlayMusicStream(Music music);                              // Start music playing
bool IsMusicStreamPlaying(Music music);                         // Check if music is playing
void UpdateMusicStream(Music music);                            // Updates buffers for music streaming
void StopMusicStream(Music music);                              // Stop music playing
void PauseMusicStream(Music music);                             // Pause music playing
void ResumeMusicStream(Music music);                            // Resume playing paused music
void SeekMusicStream(Music music, float position);              // Seek music to a position (in seconds)
void SetMusicVolume(Music music, float volume);                 // Set volume for music (1.0 is max level)
void SetMusicPitch(Music music, float pitch);                   // Set pitch for a music (1.0 is base level)
float GetMusicTimeLength(Music music);                          // Get music time length (in seconds)
float GetMusicTimePlayed(Music music);                          // Get current music time played (in seconds)

// AudioStream management functions
AudioStream LoadAudioStream(unsigned int sampleRate, unsigned int sampleSize, unsigned int channels); // Load audio stream (to stream raw audio pcm data)
void UnloadAudioStream(AudioStream stream);                      // Unload audio stream and free memory
void UpdateAudioStream(AudioStream stream, const void *data, int frameCount); // Update audio stream buffers with data
bool IsAudioStreamProcessed(AudioStream stream);                // Check if any audio stream buffers requires refill
void PlayAudioStream(AudioStream stream);                       // Play audio stream
void PauseAudioStream(AudioStream stream);                      // Pause audio stream
void ResumeAudioStream(AudioStream stream);                     // Resume audio stream
bool IsAudioStreamPlaying(AudioStream stream);                  // Check if audio stream is playing
void StopAudioStream(AudioStream stream);                       // Stop audio stream
void SetAudioStreamVolume(AudioStream stream, float volume);    // Set volume for audio stream (1.0 is max level)
void SetAudioStreamPitch(AudioStream stream, float pitch);      // Set pitch for audio stream (1.0 is base level)
void SetAudioStreamBufferSizeDefault(int size);                 // Default size for new audio streams
]])

-- rlgl.h
ffi.cdef([[
/**********************************************************************************************
*
*   rlgl v4.0 - A multi-OpenGL abstraction layer with an immediate-mode style API
*
*   An abstraction layer for multiple OpenGL versions (1.1, 2.1, 3.3 Core, 4.3 Core, ES 2.0)
*   that provides a pseudo-OpenGL 1.1 immediate-mode style API (rlVertex, rlTranslate, rlRotate...)
*
*   When chosing an OpenGL backend different than OpenGL 1.1, some internal buffer are
*   initialized on rlglInit() to accumulate vertex data.
*
*   When an internal state change is required all the stored vertex data is renderer in batch,
*   additioanlly, rlDrawRenderBatchActive() could be called to force flushing of the batch.
*
*   Some additional resources are also loaded for convenience, here the complete list:
*      - Default batch (RLGL.defaultBatch): RenderBatch system to accumulate vertex data
*      - Default texture (RLGL.defaultTextureId): 1x1 white pixel R8G8B8A8
*      - Default shader (RLGL.State.defaultShaderId, RLGL.State.defaultShaderLocs)
*
*   Internal buffer (and additional resources) must be manually unloaded calling rlglClose().
*
*
*   CONFIGURATION:
*
*       GRAPHICS_API_OPENGL_11
*       GRAPHICS_API_OPENGL_21
*       GRAPHICS_API_OPENGL_33
*       GRAPHICS_API_OPENGL_43
*       GRAPHICS_API_OPENGL_ES2
*       Use selected OpenGL graphics backend, should be supported by platform
*       Those preprocessor defines are only used on rlgl module, if OpenGL version is
*       required by any other module, use rlGetVersion() to check it
*
*       RLGL_IMPLEMENTATION
*       Generates the implementation of the library into the included file.
*       If not defined, the library is in header only mode and can be included in other headers
*       or source files without problems. But only ONE file should hold the implementation.
*
*       RLGL_RENDER_TEXTURES_HINT
*       Enable framebuffer objects (fbo) support (enabled by default)
*       Some GPUs could not support them despite the OpenGL version
*
*       RLGL_SHOW_GL_DETAILS_INFO
*       Show OpenGL extensions and capabilities detailed logs on init
*
*       RLGL_ENABLE_OPENGL_DEBUG_CONTEXT
*       Enable debug context (only available on OpenGL 4.3)
*
*   rlgl capabilities could be customized just defining some internal
*   values before library inclusion (default values listed):
*
*       RL_DEFAULT_BATCH_BUFFER_ELEMENTS   8192    // Default internal render batch elements limits
*       RL_DEFAULT_BATCH_BUFFERS              1    // Default number of batch buffers (multi-buffering)
*       RL_DEFAULT_BATCH_DRAWCALLS          256    // Default number of batch draw calls (by state changes: mode, texture)
*       RL_DEFAULT_BATCH_MAX_TEXTURE_UNITS    4    // Maximum number of textures units that can be activated on batch drawing (SetShaderValueTexture())
*
*       RL_MAX_MATRIX_STACK_SIZE             32    // Maximum size of internal Matrix stack
*       RL_MAX_SHADER_LOCATIONS              32    // Maximum number of shader locations supported
*       RL_CULL_DISTANCE_NEAR              0.01    // Default projection matrix near cull distance
*       RL_CULL_DISTANCE_FAR             1000.0    // Default projection matrix far cull distance
*
*   When loading a shader, the following vertex attribute and uniform
*   location names are tried to be set automatically:
*
*       RL_DEFAULT_SHADER_ATTRIB_NAME_POSITION     "vertexPosition"    // Binded by default to shader location: 0
*       RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD     "vertexTexCoord"    // Binded by default to shader location: 1
*       RL_DEFAULT_SHADER_ATTRIB_NAME_NORMAL       "vertexNormal"      // Binded by default to shader location: 2
*       RL_DEFAULT_SHADER_ATTRIB_NAME_COLOR        "vertexColor"       // Binded by default to shader location: 3
*       RL_DEFAULT_SHADER_ATTRIB_NAME_TANGENT      "vertexTangent"     // Binded by default to shader location: 4
*       RL_DEFAULT_SHADER_ATTRIB_NAME_TEXCOORD2    "vertexTexCoord2"   // Binded by default to shader location: 5
*       RL_DEFAULT_SHADER_UNIFORM_NAME_MVP         "mvp"               // model-view-projection matrix
*       RL_DEFAULT_SHADER_UNIFORM_NAME_VIEW        "matView"           // view matrix
*       RL_DEFAULT_SHADER_UNIFORM_NAME_PROJECTION  "matProjection"     // projection matrix
*       RL_DEFAULT_SHADER_UNIFORM_NAME_MODEL       "matModel"          // model matrix
*       RL_DEFAULT_SHADER_UNIFORM_NAME_NORMAL      "matNormal"         // normal matrix (transpose(inverse(matModelView))
*       RL_DEFAULT_SHADER_UNIFORM_NAME_COLOR       "colDiffuse"        // color diffuse (base tint color, multiplied by texture color)
*       RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE0  "texture0"          // texture0 (texture slot active 0)
*       RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE1  "texture1"          // texture1 (texture slot active 1)
*       RL_DEFAULT_SHADER_SAMPLER2D_NAME_TEXTURE2  "texture2"          // texture2 (texture slot active 2)
*
*   DEPENDENCIES:
*
*      - OpenGL libraries (depending on platform and OpenGL version selected)
*      - GLAD OpenGL extensions loading library (only for OpenGL 3.3 Core, 4.3 Core)
*
*
*   LICENSE: zlib/libpng
*
*   Copyright (c) 2014-2021 Ramon Santamaria (@raysan5)
*
*   This software is provided "as-is", without any express or implied warranty. In no event
*   will the authors be held liable for any damages arising from the use of this software.
*
*   Permission is granted to anyone to use this software for any purpose, including commercial
*   applications, and to alter it and redistribute it freely, subject to the following restrictions:
*
*     1. The origin of this software must not be misrepresented; you must not claim that you
*     wrote the original software. If you use this software in a product, an acknowledgment
*     in the product documentation would be appreciated but is not required.
*
*     2. Altered source versions must be plainly marked as such, and must not be misrepresented
*     as being the original software.
*
*     3. This notice may not be removed or altered from any source distribution.
*
**********************************************************************************************/
enum {
    RL_LINES                                = 0x0001,      // GL_LINES
    RL_TRIANGLES                            = 0x0004,      // GL_TRIANGLES
    RL_QUADS                                = 0x0007,      // GL_QUADS
    
    // GL equivalent data types
    RL_UNSIGNED_BYTE                        = 0x1401,      // GL_UNSIGNED_BYTE
    RL_FLOAT                                = 0x1406,      // GL_FLOAT
    
    
    // Matrix modes (equivalent to OpenGL)
    RL_MODELVIEW                            = 0x1700,      // GL_MODELVIEW
    RL_PROJECTION                           = 0x1701,      // GL_PROJECTION
    RL_TEXTURE                              = 0x1702,      // GL_TEXTURE
    
    // Texture parameters (equivalent to OpenGL defines)
    RL_TEXTURE_WRAP_S                       = 0x2802,      // GL_TEXTURE_WRAP_S
    RL_TEXTURE_WRAP_T                       = 0x2803,      // GL_TEXTURE_WRAP_T
    RL_TEXTURE_MAG_FILTER                   = 0x2800,      // GL_TEXTURE_MAG_FILTER
    RL_TEXTURE_MIN_FILTER                   = 0x2801,      // GL_TEXTURE_MIN_FILTER

    RL_TEXTURE_FILTER_NEAREST               = 0x2600,      // GL_NEAREST
    RL_TEXTURE_FILTER_LINEAR                = 0x2601,      // GL_LINEAR
    RL_TEXTURE_FILTER_MIP_NEAREST           = 0x2700,      // GL_NEAREST_MIPMAP_NEAREST
    RL_TEXTURE_FILTER_NEAREST_MIP_LINEAR    = 0x2702,      // GL_NEAREST_MIPMAP_LINEAR
    RL_TEXTURE_FILTER_LINEAR_MIP_NEAREST    = 0x2701,      // GL_LINEAR_MIPMAP_NEAREST
    RL_TEXTURE_FILTER_MIP_LINEAR            = 0x2703,      // GL_LINEAR_MIPMAP_LINEAR
    RL_TEXTURE_FILTER_ANISOTROPIC           = 0x3000,      // Anisotropic filter (custom identifier)

    RL_TEXTURE_WRAP_REPEAT                  = 0x2901,      // GL_REPEAT
    RL_TEXTURE_WRAP_CLAMP                   = 0x812F,      // GL_CLAMP_TO_EDGE
    RL_TEXTURE_WRAP_MIRROR_REPEAT           = 0x8370,      // GL_MIRRORED_REPEAT
    RL_TEXTURE_WRAP_MIRROR_CLAMP            = 0x8742,      // GL_MIRROR_CLAMP_EXT
    
    // Buffer usage hint
    RL_STREAM_DRAW                          = 0x88E0,      // GL_STREAM_DRAW
    RL_STREAM_READ                          = 0x88E1,      // GL_STREAM_READ
    RL_STREAM_COPY                          = 0x88E2,      // GL_STREAM_COPY
    RL_STATIC_DRAW                          = 0x88E4,      // GL_STATIC_DRAW
    RL_STATIC_READ                          = 0x88E5,      // GL_STATIC_READ
    RL_STATIC_COPY                          = 0x88E6,      // GL_STATIC_COPY
    RL_DYNAMIC_DRAW                         = 0x88E8,      // GL_DYNAMIC_DRAW
    RL_DYNAMIC_READ                         = 0x88E9,      // GL_DYNAMIC_READ
    RL_DYNAMIC_COPY                         = 0x88EA,      // GL_DYNAMIC_COPY

    // GL Shader type
    RL_FRAGMENT_SHADER                      = 0x8B30,      // GL_FRAGMENT_SHADER
    RL_VERTEX_SHADER                        = 0x8B31,      // GL_VERTEX_SHADER
    RL_COMPUTE_SHADER                       = 0x91B9       // GL_COMPUTE_SHADER
};

//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
typedef enum {
    OPENGL_11 = 1,
    OPENGL_21,
    OPENGL_33,
    OPENGL_43,
    OPENGL_ES_20
} rlGlVersion;

typedef enum {
    RL_ATTACHMENT_COLOR_CHANNEL0 = 0,
    RL_ATTACHMENT_COLOR_CHANNEL1,
    RL_ATTACHMENT_COLOR_CHANNEL2,
    RL_ATTACHMENT_COLOR_CHANNEL3,
    RL_ATTACHMENT_COLOR_CHANNEL4,
    RL_ATTACHMENT_COLOR_CHANNEL5,
    RL_ATTACHMENT_COLOR_CHANNEL6,
    RL_ATTACHMENT_COLOR_CHANNEL7,
    RL_ATTACHMENT_DEPTH = 100,
    RL_ATTACHMENT_STENCIL = 200,
} rlFramebufferAttachType;

typedef enum {
    RL_ATTACHMENT_CUBEMAP_POSITIVE_X = 0,
    RL_ATTACHMENT_CUBEMAP_NEGATIVE_X,
    RL_ATTACHMENT_CUBEMAP_POSITIVE_Y,
    RL_ATTACHMENT_CUBEMAP_NEGATIVE_Y,
    RL_ATTACHMENT_CUBEMAP_POSITIVE_Z,
    RL_ATTACHMENT_CUBEMAP_NEGATIVE_Z,
    RL_ATTACHMENT_TEXTURE2D = 100,
    RL_ATTACHMENT_RENDERBUFFER = 200,
} rlFramebufferAttachTextureType;

// Dynamic vertex buffers (position + texcoords + colors + indices arrays)
typedef struct rlVertexBuffer {
    int elementCount;           // Number of elements in the buffer (QUADS)

    float *vertices;            // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
    float *texcoords;           // Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
    unsigned char *colors;      // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
    unsigned int *indices;      // Vertex indices (in case vertex data comes indexed) (6 indices per quad)
    unsigned int vaoId;         // OpenGL Vertex Array Object id
    unsigned int vboId[4];      // OpenGL Vertex Buffer Objects id (4 types of vertex data)
} rlVertexBuffer;

// Draw call type
// NOTE: Only texture changes register a new draw, other state-change-related elements are not
// used at this moment (vaoId, shaderId, matrices), raylib just forces a batch draw call if any
// of those state-change happens (this is done in core module)
typedef struct rlDrawCall {
    int mode;                   // Drawing mode: LINES, TRIANGLES, QUADS
    int vertexCount;            // Number of vertex of the draw
    int vertexAlignment;        // Number of vertex required for index alignment (LINES, TRIANGLES)
    //unsigned int vaoId;       // Vertex array id to be used on the draw -> Using RLGL.currentBatch->vertexBuffer.vaoId
    //unsigned int shaderId;    // Shader id to be used on the draw -> Using RLGL.currentShaderId
    unsigned int textureId;     // Texture id to be used on the draw -> Use to create new draw call if changes

    //Matrix projection;      // Projection matrix for this draw -> Using RLGL.projection by default
    //Matrix modelview;       // Modelview matrix for this draw -> Using RLGL.modelview by default
} rlDrawCall;

// rlRenderBatch type
typedef struct rlRenderBatch {
    int bufferCount;            // Number of vertex buffers (multi-buffering support)
    int currentBuffer;          // Current buffer tracking in case of multi-buffering
    rlVertexBuffer *vertexBuffer; // Dynamic buffer(s) for vertex data

    rlDrawCall *draws;          // Draw calls array, depends on textureId
    int drawCounter;            // Draw calls counter
    float currentDepth;         // Current depth value for next draw
} rlRenderBatch;

// Trace log level
// NOTE: Organized by priority level
typedef enum rlTraceLogLevel {
    RL_LOG_ALL = 0,            // Display all logs
    RL_LOG_TRACE,              // Trace logging, intended for internal use only
    RL_LOG_DEBUG,              // Debug logging, used for internal debugging, it should be disabled on release builds
    RL_LOG_INFO,               // Info logging, used for program execution info
    RL_LOG_WARNING,            // Warning logging, used on recoverable failures
    RL_LOG_ERROR,              // Error logging, used on unrecoverable failures
    RL_LOG_FATAL,              // Fatal logging, used to abort program: exit(EXIT_FAILURE)
    RL_LOG_NONE                // Disable logging
} rlTraceLogLevel;

// Texture formats (support depends on OpenGL version)
typedef enum rlPixelFormat {
    RL_PIXELFORMAT_UNCOMPRESSED_GRAYSCALE = 1,     // 8 bit per pixel (no alpha)
    RL_PIXELFORMAT_UNCOMPRESSED_GRAY_ALPHA,        // 8*2 bpp (2 channels)
    RL_PIXELFORMAT_UNCOMPRESSED_R5G6B5,            // 16 bpp
    RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8,            // 24 bpp
    RL_PIXELFORMAT_UNCOMPRESSED_R5G5B5A1,          // 16 bpp (1 bit alpha)
    RL_PIXELFORMAT_UNCOMPRESSED_R4G4B4A4,          // 16 bpp (4 bit alpha)
    RL_PIXELFORMAT_UNCOMPRESSED_R8G8B8A8,          // 32 bpp
    RL_PIXELFORMAT_UNCOMPRESSED_R32,               // 32 bpp (1 channel - float)
    RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32,         // 32*3 bpp (3 channels - float)
    RL_PIXELFORMAT_UNCOMPRESSED_R32G32B32A32,      // 32*4 bpp (4 channels - float)
    RL_PIXELFORMAT_COMPRESSED_DXT1_RGB,            // 4 bpp (no alpha)
    RL_PIXELFORMAT_COMPRESSED_DXT1_RGBA,           // 4 bpp (1 bit alpha)
    RL_PIXELFORMAT_COMPRESSED_DXT3_RGBA,           // 8 bpp
    RL_PIXELFORMAT_COMPRESSED_DXT5_RGBA,           // 8 bpp
    RL_PIXELFORMAT_COMPRESSED_ETC1_RGB,            // 4 bpp
    RL_PIXELFORMAT_COMPRESSED_ETC2_RGB,            // 4 bpp
    RL_PIXELFORMAT_COMPRESSED_ETC2_EAC_RGBA,       // 8 bpp
    RL_PIXELFORMAT_COMPRESSED_PVRT_RGB,            // 4 bpp
    RL_PIXELFORMAT_COMPRESSED_PVRT_RGBA,           // 4 bpp
    RL_PIXELFORMAT_COMPRESSED_ASTC_4x4_RGBA,       // 8 bpp
    RL_PIXELFORMAT_COMPRESSED_ASTC_8x8_RGBA        // 2 bpp
} rlPixelFormat;

// Texture parameters: filter mode
// NOTE 1: Filtering considers mipmaps if available in the texture
// NOTE 2: Filter is accordingly set for minification and magnification
typedef enum {
    RL_TEXTURE_FILTER_POINT = 0,               // No filter, just pixel aproximation
    RL_TEXTURE_FILTER_BILINEAR,                // Linear filtering
    RL_TEXTURE_FILTER_TRILINEAR,               // Trilinear filtering (linear with mipmaps)
    RL_TEXTURE_FILTER_ANISOTROPIC_4X,          // Anisotropic filtering 4x
    RL_TEXTURE_FILTER_ANISOTROPIC_8X,          // Anisotropic filtering 8x
    RL_TEXTURE_FILTER_ANISOTROPIC_16X,         // Anisotropic filtering 16x
} rlTextureFilter;

// Color blending modes (pre-defined)
typedef enum rlBlendMode {
    RL_BLEND_ALPHA = 0,                // Blend textures considering alpha (default)
    RL_BLEND_ADDITIVE,                 // Blend textures adding colors
    RL_BLEND_MULTIPLIED,               // Blend textures multiplying colors
    RL_BLEND_ADD_COLORS,               // Blend textures adding colors (alternative)
    RL_BLEND_SUBTRACT_COLORS,          // Blend textures subtracting colors (alternative)
    RL_BLEND_CUSTOM                    // Belnd textures using custom src/dst factors (use SetBlendModeCustom())
} rlBlendMode;

// Shader location point type
typedef enum rlShaderLocationIndex {
    RL_SHADER_LOC_VERTEX_POSITION = 0, // Shader location: vertex attribute: position
    RL_SHADER_LOC_VERTEX_TEXCOORD01,   // Shader location: vertex attribute: texcoord01
    RL_SHADER_LOC_VERTEX_TEXCOORD02,   // Shader location: vertex attribute: texcoord02
    RL_SHADER_LOC_VERTEX_NORMAL,       // Shader location: vertex attribute: normal
    RL_SHADER_LOC_VERTEX_TANGENT,      // Shader location: vertex attribute: tangent
    RL_SHADER_LOC_VERTEX_COLOR,        // Shader location: vertex attribute: color
    RL_SHADER_LOC_MATRIX_MVP,          // Shader location: matrix uniform: model-view-projection
    RL_SHADER_LOC_MATRIX_VIEW,         // Shader location: matrix uniform: view (camera transform)
    RL_SHADER_LOC_MATRIX_PROJECTION,   // Shader location: matrix uniform: projection
    RL_SHADER_LOC_MATRIX_MODEL,        // Shader location: matrix uniform: model (transform)
    RL_SHADER_LOC_MATRIX_NORMAL,       // Shader location: matrix uniform: normal
    RL_SHADER_LOC_VECTOR_VIEW,         // Shader location: vector uniform: view
    RL_SHADER_LOC_COLOR_DIFFUSE,       // Shader location: vector uniform: diffuse color
    RL_SHADER_LOC_COLOR_SPECULAR,      // Shader location: vector uniform: specular color
    RL_SHADER_LOC_COLOR_AMBIENT,       // Shader location: vector uniform: ambient color
    RL_SHADER_LOC_MAP_ALBEDO,          // Shader location: sampler2d texture: albedo (same as: RL_SHADER_LOC_MAP_DIFFUSE)
    RL_SHADER_LOC_MAP_METALNESS,       // Shader location: sampler2d texture: metalness (same as: RL_SHADER_LOC_MAP_SPECULAR)
    RL_SHADER_LOC_MAP_NORMAL,          // Shader location: sampler2d texture: normal
    RL_SHADER_LOC_MAP_ROUGHNESS,       // Shader location: sampler2d texture: roughness
    RL_SHADER_LOC_MAP_OCCLUSION,       // Shader location: sampler2d texture: occlusion
    RL_SHADER_LOC_MAP_EMISSION,        // Shader location: sampler2d texture: emission
    RL_SHADER_LOC_MAP_HEIGHT,          // Shader location: sampler2d texture: height
    RL_SHADER_LOC_MAP_CUBEMAP,         // Shader location: samplerCube texture: cubemap
    RL_SHADER_LOC_MAP_IRRADIANCE,      // Shader location: samplerCube texture: irradiance
    RL_SHADER_LOC_MAP_PREFILTER,       // Shader location: samplerCube texture: prefilter
    RL_SHADER_LOC_MAP_BRDF             // Shader location: sampler2d texture: brdf
} rlShaderLocationIndex;

// Shader uniform data type
typedef enum rlShaderUniformDataType {
    RL_SHADER_UNIFORM_FLOAT = 0,       // Shader uniform type: float
    RL_SHADER_UNIFORM_VEC2,            // Shader uniform type: vec2 (2 float)
    RL_SHADER_UNIFORM_VEC3,            // Shader uniform type: vec3 (3 float)
    RL_SHADER_UNIFORM_VEC4,            // Shader uniform type: vec4 (4 float)
    RL_SHADER_UNIFORM_INT,             // Shader uniform type: int
    RL_SHADER_UNIFORM_IVEC2,           // Shader uniform type: ivec2 (2 int)
    RL_SHADER_UNIFORM_IVEC3,           // Shader uniform type: ivec3 (3 int)
    RL_SHADER_UNIFORM_IVEC4,           // Shader uniform type: ivec4 (4 int)
    RL_SHADER_UNIFORM_SAMPLER2D        // Shader uniform type: sampler2d
} rlShaderUniformDataType;

// Shader attribute data types
typedef enum rlShaderAttributeDataType {
    RL_SHADER_ATTRIB_FLOAT = 0,        // Shader attribute type: float
    RL_SHADER_ATTRIB_VEC2,             // Shader attribute type: vec2 (2 float)
    RL_SHADER_ATTRIB_VEC3,             // Shader attribute type: vec3 (3 float)
    RL_SHADER_ATTRIB_VEC4              // Shader attribute type: vec4 (4 float)
} rlShaderAttributeDataType;

//------------------------------------------------------------------------------------
// Functions Declaration - Matrix operations
//------------------------------------------------------------------------------------
void rlMatrixMode(int mode);                    // Choose the current matrix to be transformed
void rlPushMatrix(void);                        // Push the current matrix to stack
void rlPopMatrix(void);                         // Pop lattest inserted matrix from stack
void rlLoadIdentity(void);                      // Reset current matrix to identity matrix
void rlTranslatef(float x, float y, float z);   // Multiply the current matrix by a translation matrix
void rlRotatef(float angle, float x, float y, float z);  // Multiply the current matrix by a rotation matrix
void rlScalef(float x, float y, float z);       // Multiply the current matrix by a scaling matrix
void rlMultMatrixf(float *matf);                // Multiply the current matrix by another matrix
void rlFrustum(double left, double right, double bottom, double top, double znear, double zfar);
void rlOrtho(double left, double right, double bottom, double top, double znear, double zfar);
void rlViewport(int x, int y, int width, int height); // Set the viewport area

//------------------------------------------------------------------------------------
// Functions Declaration - Vertex level operations
//------------------------------------------------------------------------------------
void rlBegin(int mode);                         // Initialize drawing mode (how to organize vertex)
void rlEnd(void);                               // Finish vertex providing
void rlVertex2i(int x, int y);                  // Define one vertex (position) - 2 int
void rlVertex2f(float x, float y);              // Define one vertex (position) - 2 float
void rlVertex3f(float x, float y, float z);     // Define one vertex (position) - 3 float
void rlTexCoord2f(float x, float y);            // Define one vertex (texture coordinate) - 2 float
void rlNormal3f(float x, float y, float z);     // Define one vertex (normal) - 3 float
void rlColor4ub(unsigned char r, unsigned char g, unsigned char b, unsigned char a);  // Define one vertex (color) - 4 byte
void rlColor3f(float x, float y, float z);          // Define one vertex (color) - 3 float
void rlColor4f(float x, float y, float z, float w); // Define one vertex (color) - 4 float

//------------------------------------------------------------------------------------
// Functions Declaration - OpenGL style functions (common to 1.1, 3.3+, ES2)
// NOTE: This functions are used to completely abstract raylib code from OpenGL layer,
// some of them are direct wrappers over OpenGL calls, some others are custom
//------------------------------------------------------------------------------------

// Vertex buffers state
bool rlEnableVertexArray(unsigned int vaoId);     // Enable vertex array (VAO, if supported)
void rlDisableVertexArray(void);                  // Disable vertex array (VAO, if supported)
void rlEnableVertexBuffer(unsigned int id);       // Enable vertex buffer (VBO)
void rlDisableVertexBuffer(void);                 // Disable vertex buffer (VBO)
void rlEnableVertexBufferElement(unsigned int id);// Enable vertex buffer element (VBO element)
void rlDisableVertexBufferElement(void);          // Disable vertex buffer element (VBO element)
void rlEnableVertexAttribute(unsigned int index); // Enable vertex attribute index
void rlDisableVertexAttribute(unsigned int index);// Disable vertex attribute index
void rlEnableStatePointer(int vertexAttribType, void *buffer);    // Enable attribute state pointer
void rlDisableStatePointer(int vertexAttribType);                 // Disable attribute state pointer

// Textures state
void rlActiveTextureSlot(int slot);               // Select and active a texture slot
void rlEnableTexture(unsigned int id);            // Enable texture
void rlDisableTexture(void);                      // Disable texture
void rlEnableTextureCubemap(unsigned int id);     // Enable texture cubemap
void rlDisableTextureCubemap(void);               // Disable texture cubemap
void rlTextureParameters(unsigned int id, int param, int value); // Set texture parameters (filter, wrap)

// Shader state
void rlEnableShader(unsigned int id);             // Enable shader program
void rlDisableShader(void);                       // Disable shader program

// Framebuffer state
void rlEnableFramebuffer(unsigned int id);        // Enable render texture (fbo)
void rlDisableFramebuffer(void);                  // Disable render texture (fbo), return to default framebuffer
void rlActiveDrawBuffers(int count);              // Activate multiple draw color buffers

// General render state
void rlEnableColorBlend(void);                     // Enable color blending
void rlDisableColorBlend(void);                   // Disable color blending
void rlEnableDepthTest(void);                     // Enable depth test
void rlDisableDepthTest(void);                    // Disable depth test
void rlEnableDepthMask(void);                     // Enable depth write
void rlDisableDepthMask(void);                    // Disable depth write
void rlEnableBackfaceCulling(void);               // Enable backface culling
void rlDisableBackfaceCulling(void);              // Disable backface culling
void rlEnableScissorTest(void);                   // Enable scissor test
void rlDisableScissorTest(void);                  // Disable scissor test
void rlScissor(int x, int y, int width, int height); // Scissor test
void rlEnableWireMode(void);                      // Enable wire mode
void rlDisableWireMode(void);                     // Disable wire mode
void rlSetLineWidth(float width);                 // Set the line drawing width
float rlGetLineWidth(void);                       // Get the line drawing width
void rlEnableSmoothLines(void);                   // Enable line aliasing
void rlDisableSmoothLines(void);                  // Disable line aliasing
void rlEnableStereoRender(void);                  // Enable stereo rendering
void rlDisableStereoRender(void);                 // Disable stereo rendering
bool rlIsStereoRenderEnabled(void);               // Check if stereo render is enabled

void rlClearColor(unsigned char r, unsigned char g, unsigned char b, unsigned char a); // Clear color buffer with color
void rlClearScreenBuffers(void);                  // Clear used screen buffers (color and depth)
void rlCheckErrors(void);                         // Check and log OpenGL error codes
void rlSetBlendMode(int mode);                    // Set blending mode
void rlSetBlendFactors(int glSrcFactor, int glDstFactor, int glEquation); // Set blending mode factor and equation (using OpenGL factors)

//------------------------------------------------------------------------------------
// Functions Declaration - rlgl functionality
//------------------------------------------------------------------------------------
// rlgl initialization functions
void rlglInit(int width, int height);           // Initialize rlgl (buffers, shaders, textures, states)
void rlglClose(void);                           // De-inititialize rlgl (buffers, shaders, textures)
void rlLoadExtensions(void *loader);            // Load OpenGL extensions (loader function required)
int rlGetVersion(void);                         // Get current OpenGL version
int rlGetFramebufferWidth(void);                // Get default framebuffer width
int rlGetFramebufferHeight(void);               // Get default framebuffer height

unsigned int rlGetTextureIdDefault(void);       // Get default texture id
unsigned int rlGetShaderIdDefault(void);        // Get default shader id
int *rlGetShaderLocsDefault(void);              // Get default shader locations

// Render batch management
// NOTE: rlgl provides a default render batch to behave like OpenGL 1.1 immediate mode
// but this render batch API is exposed in case of custom batches are required
rlRenderBatch rlLoadRenderBatch(int numBuffers, int bufferElements);  // Load a render batch system
void rlUnloadRenderBatch(rlRenderBatch batch);                        // Unload render batch system
void rlDrawRenderBatch(rlRenderBatch *batch);                         // Draw render batch data (Update->Draw->Reset)
void rlSetRenderBatchActive(rlRenderBatch *batch);                    // Set the active render batch for rlgl (NULL for default internal)
void rlDrawRenderBatchActive(void);                                   // Update and draw internal render batch
bool rlCheckRenderBatchLimit(int vCount);                             // Check internal buffer overflow for a given number of vertex
void rlSetTexture(unsigned int id);           // Set current texture for render batch and check buffers limits

//------------------------------------------------------------------------------------------------------------------------

// Vertex buffers management
unsigned int rlLoadVertexArray(void);                               // Load vertex array (vao) if supported
unsigned int rlLoadVertexBuffer(void *buffer, int size, bool dynamic);            // Load a vertex buffer attribute
unsigned int rlLoadVertexBufferElement(void *buffer, int size, bool dynamic);     // Load a new attributes element buffer
void rlUpdateVertexBuffer(unsigned int bufferId, void *data, int dataSize, int offset);    // Update GPU buffer with new data
void rlUnloadVertexArray(unsigned int vaoId);
void rlUnloadVertexBuffer(unsigned int vboId);
void rlSetVertexAttribute(unsigned int index, int compSize, int type, bool normalized, int stride, void *pointer);
void rlSetVertexAttributeDivisor(unsigned int index, int divisor);
void rlSetVertexAttributeDefault(int locIndex, const void *value, int attribType, int count); // Set vertex attribute default value
void rlDrawVertexArray(int offset, int count);
void rlDrawVertexArrayElements(int offset, int count, void *buffer);
void rlDrawVertexArrayInstanced(int offset, int count, int instances);
void rlDrawVertexArrayElementsInstanced(int offset, int count, void *buffer, int instances);

// Textures management
unsigned int rlLoadTexture(void *data, int width, int height, int format, int mipmapCount); // Load texture in GPU
unsigned int rlLoadTextureDepth(int width, int height, bool useRenderBuffer);               // Load depth texture/renderbuffer (to be attached to fbo)
unsigned int rlLoadTextureCubemap(void *data, int size, int format);                        // Load texture cubemap
void rlUpdateTexture(unsigned int id, int offsetX, int offsetY, int width, int height, int format, const void *data);  // Update GPU texture with new data
void rlGetGlTextureFormats(int format, int *glInternalFormat, int *glFormat, int *glType);  // Get OpenGL internal formats
const char *rlGetPixelFormatName(unsigned int format);              // Get name string for pixel format
void rlUnloadTexture(unsigned int id);                              // Unload texture from GPU memory
void rlGenTextureMipmaps(unsigned int id, int width, int height, int format, int *mipmaps); // Generate mipmap data for selected texture
void *rlReadTexturePixels(unsigned int id, int width, int height, int format);              // Read texture pixel data
unsigned char *rlReadScreenPixels(int width, int height);           // Read screen pixel data (color buffer)

// Framebuffer management (fbo)
unsigned int rlLoadFramebuffer(int width, int height);              // Load an empty framebuffer
void rlFramebufferAttach(unsigned int fboId, unsigned int texId, int attachType, int texType, int mipLevel);  // Attach texture/renderbuffer to a framebuffer
bool rlFramebufferComplete(unsigned int id);                        // Verify framebuffer is complete
void rlUnloadFramebuffer(unsigned int id);                          // Delete framebuffer from GPU

// Shaders management
unsigned int rlLoadShaderCode(const char *vsCode, const char *fsCode);    // Load shader from code strings
unsigned int rlCompileShader(const char *shaderCode, int type);           // Compile custom shader and return shader id (type: RL_VERTEX_SHADER, RL_FRAGMENT_SHADER, RL_COMPUTE_SHADER)
unsigned int rlLoadShaderProgram(unsigned int vShaderId, unsigned int fShaderId); // Load custom shader program
void rlUnloadShaderProgram(unsigned int id);                              // Unload shader program
int rlGetLocationUniform(unsigned int shaderId, const char *uniformName); // Get shader location uniform
int rlGetLocationAttrib(unsigned int shaderId, const char *attribName);   // Get shader location attribute
void rlSetUniform(int locIndex, const void *value, int uniformType, int count);   // Set shader value uniform
void rlSetUniformMatrix(int locIndex, Matrix mat);                        // Set shader value matrix
void rlSetUniformSampler(int locIndex, unsigned int textureId);           // Set shader value sampler
void rlSetShader(unsigned int id, int *locs);                             // Set shader currently active (id and locations)

// Compute shader management
unsigned int rlLoadComputeShaderProgram(unsigned int shaderId);           // Load compute shader program
void rlComputeShaderDispatch(unsigned int groupX, unsigned int groupY, unsigned int groupZ);  // Dispatch compute shader (equivalent to *draw* for graphics pilepine)

// Shader buffer storage object management (ssbo)
unsigned int rlLoadShaderBuffer(unsigned long long size, const void *data, int usageHint);    // Load shader storage buffer object (SSBO)
void rlUnloadShaderBuffer(unsigned int ssboId);                           // Unload shader storage buffer object (SSBO)
void rlUpdateShaderBufferElements(unsigned int id, const void *data, unsigned long long dataSize, unsigned long long offset); // Update SSBO buffer data
unsigned long long rlGetShaderBufferSize(unsigned int id);                // Get SSBO buffer size
void rlReadShaderBufferElements(unsigned int id, void *dest, unsigned long long count, unsigned long long offset);    // Bind SSBO buffer
void rlBindShaderBuffer(unsigned int id, unsigned int index);             // Copy SSBO buffer data

// Buffer management
void rlCopyBuffersElements(unsigned int destId, unsigned int srcId, unsigned long long destOffset, unsigned long long srcOffset, unsigned long long count); // Copy SSBO buffer data
void rlBindImageTexture(unsigned int id, unsigned int index, unsigned int format, int readonly);  // Bind image texture

// Matrix state management
Matrix rlGetMatrixModelview(void);                                  // Get internal modelview matrix
Matrix rlGetMatrixProjection(void);                                 // Get internal projection matrix
Matrix rlGetMatrixTransform(void);                                  // Get internal accumulated transform matrix
Matrix rlGetMatrixProjectionStereo(int eye);                        // Get internal projection matrix for stereo render (selected eye)
Matrix rlGetMatrixViewOffsetStereo(int eye);                        // Get internal view offset matrix for stereo render (selected eye)
void rlSetMatrixProjection(Matrix proj);                            // Set a custom projection matrix (replaces internal projection matrix)
void rlSetMatrixModelview(Matrix view);                             // Set a custom modelview matrix (replaces internal modelview matrix)
void rlSetMatrixProjectionStereo(Matrix right, Matrix left);        // Set eyes projection matrices for stereo rendering
void rlSetMatrixViewOffsetStereo(Matrix right, Matrix left);        // Set eyes view offsets matrices for stereo rendering

// Quick and dirty cube/quad buffers load->draw->unload
void rlLoadDrawCube(void);     // Load and draw a cube
void rlLoadDrawQuad(void);     // Load and draw a quad
]])

-- raymath.h
ffi.cdef([[
typedef struct float3 { float v[3]; } float3;
typedef struct float16 { float v[16]; } float16;

//----------------------------------------------------------------------------------
// Module Functions Definition - Utils math
//----------------------------------------------------------------------------------

// Clamp float value
float Clamp(float value, float min, float max);

// Calculate linear interpolation between two floats
float Lerp(float start, float end, float amount);

// Normalize input value within input range
float Normalize(float value, float start, float end);

// Remap input value within input range to output range
float Remap(float value, float inputStart, float inputEnd, float outputStart, float outputEnd);

//----------------------------------------------------------------------------------
// Module Functions Definition - Vector2 math
//----------------------------------------------------------------------------------

// Vector with components value 0.0f
Vector2 Vector2Zero(void);

// Vector with components value 1.0f
Vector2 Vector2One(void);

// Add two vectors (v1 + v2)
Vector2 Vector2Add(Vector2 v1, Vector2 v2);

// Add vector and float value
Vector2 Vector2AddValue(Vector2 v, float add);

// Subtract two vectors (v1 - v2)
Vector2 Vector2Subtract(Vector2 v1, Vector2 v2);

// Subtract vector by float value
Vector2 Vector2SubtractValue(Vector2 v, float sub);

// Calculate vector length
float Vector2Length(Vector2 v);

// Calculate vector square length
float Vector2LengthSqr(Vector2 v);

// Calculate two vectors dot product
float Vector2DotProduct(Vector2 v1, Vector2 v2);

// Calculate distance between two vectors
float Vector2Distance(Vector2 v1, Vector2 v2);

// Calculate angle from two vectors in X-axis
float Vector2Angle(Vector2 v1, Vector2 v2);

// Scale vector (multiply by value)
Vector2 Vector2Scale(Vector2 v, float scale);

// Multiply vector by vector
Vector2 Vector2Multiply(Vector2 v1, Vector2 v2);

// Negate vector
Vector2 Vector2Negate(Vector2 v);

// Divide vector by vector
Vector2 Vector2Divide(Vector2 v1, Vector2 v2);

// Normalize provided vector
Vector2 Vector2Normalize(Vector2 v);

// Calculate linear interpolation between two vectors
Vector2 Vector2Lerp(Vector2 v1, Vector2 v2, float amount);

// Calculate reflected vector to normal
Vector2 Vector2Reflect(Vector2 v, Vector2 normal);

// Rotate vector by angle
Vector2 Vector2Rotate(Vector2 v, float angle);

// Move Vector towards target
Vector2 Vector2MoveTowards(Vector2 v, Vector2 target, float maxDistance);

//----------------------------------------------------------------------------------
// Module Functions Definition - Vector3 math
//----------------------------------------------------------------------------------

// Vector with components value 0.0f
Vector3 Vector3Zero(void);

// Vector with components value 1.0f
Vector3 Vector3One(void);

// Add two vectors
Vector3 Vector3Add(Vector3 v1, Vector3 v2);

// Add vector and float value
Vector3 Vector3AddValue(Vector3 v, float add);

// Subtract two vectors
Vector3 Vector3Subtract(Vector3 v1, Vector3 v2);

// Subtract vector by float value
Vector3 Vector3SubtractValue(Vector3 v, float sub);

// Multiply vector by scalar
Vector3 Vector3Scale(Vector3 v, float scalar);

// Multiply vector by vector
Vector3 Vector3Multiply(Vector3 v1, Vector3 v2);

// Calculate two vectors cross product
Vector3 Vector3CrossProduct(Vector3 v1, Vector3 v2);

// Calculate one vector perpendicular vector
Vector3 Vector3Perpendicular(Vector3 v);

// Calculate vector length
float Vector3Length(const Vector3 v);

// Calculate vector square length
float Vector3LengthSqr(const Vector3 v);

// Calculate two vectors dot product
float Vector3DotProduct(Vector3 v1, Vector3 v2);

// Calculate distance between two vectors
float Vector3Distance(Vector3 v1, Vector3 v2);

// Calculate angle between two vectors in XY and XZ
Vector2 Vector3Angle(Vector3 v1, Vector3 v2);

// Negate provided vector (invert direction)
Vector3 Vector3Negate(Vector3 v);

// Divide vector by vector
Vector3 Vector3Divide(Vector3 v1, Vector3 v2);

// Normalize provided vector
Vector3 Vector3Normalize(Vector3 v);

// Orthonormalize provided vectors
// Makes vectors normalized and orthogonal to each other
// Gram-Schmidt function implementation
void Vector3OrthoNormalize(Vector3 *v1, Vector3 *v2);

// Transforms a Vector3 by a given Matrix
Vector3 Vector3Transform(Vector3 v, Matrix mat);

// Transform a vector by quaternion rotation
Vector3 Vector3RotateByQuaternion(Vector3 v, Quaternion q);

// Calculate linear interpolation between two vectors
Vector3 Vector3Lerp(Vector3 v1, Vector3 v2, float amount);

// Calculate reflected vector to normal
Vector3 Vector3Reflect(Vector3 v, Vector3 normal);

// Get min value for each pair of components
Vector3 Vector3Min(Vector3 v1, Vector3 v2);

// Get max value for each pair of components
Vector3 Vector3Max(Vector3 v1, Vector3 v2);

// Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
// NOTE: Assumes P is on the plane of the triangle
Vector3 Vector3Barycenter(Vector3 p, Vector3 a, Vector3 b, Vector3 c);

// Projects a Vector3 from screen space into object space
// NOTE: We are avoiding calling other raymath functions despite available
Vector3 Vector3Unproject(Vector3 source, Matrix projection, Matrix view);

// Get Vector3 as float array
float3 Vector3ToFloatV(Vector3 v);

//----------------------------------------------------------------------------------
// Module Functions Definition - Matrix math
//----------------------------------------------------------------------------------

// Compute matrix determinant
float MatrixDeterminant(Matrix mat);

// Get the trace of the matrix (sum of the values along the diagonal)
float MatrixTrace(Matrix mat);

// Transposes provided matrix
Matrix MatrixTranspose(Matrix mat);

// Invert provided matrix
Matrix MatrixInvert(Matrix mat);

// Normalize provided matrix
Matrix MatrixNormalize(Matrix mat);

// Get identity matrix
Matrix MatrixIdentity(void);

// Add two matrices
Matrix MatrixAdd(Matrix left, Matrix right);

// Subtract two matrices (left - right)
Matrix MatrixSubtract(Matrix left, Matrix right);

// Get two matrix multiplication
// NOTE: When multiplying matrices... the order matters!
Matrix MatrixMultiply(Matrix left, Matrix right);

// Get translation matrix
Matrix MatrixTranslate(float x, float y, float z);

// Create rotation matrix from axis and angle
// NOTE: Angle should be provided in radians
Matrix MatrixRotate(Vector3 axis, float angle);

// Get x-rotation matrix (angle in radians)
Matrix MatrixRotateX(float angle);

// Get y-rotation matrix (angle in radians)
Matrix MatrixRotateY(float angle);

// Get z-rotation matrix (angle in radians)
Matrix MatrixRotateZ(float angle);

// Get xyz-rotation matrix (angles in radians)
Matrix MatrixRotateXYZ(Vector3 ang);

// Get zyx-rotation matrix (angles in radians)
Matrix MatrixRotateZYX(Vector3 ang);

// Get scaling matrix
Matrix MatrixScale(float x, float y, float z);

// Get perspective projection matrix
Matrix MatrixFrustum(double left, double right, double bottom, double top, double near, double far);

// Get perspective projection matrix
// NOTE: Angle should be provided in radians
Matrix MatrixPerspective(double fovy, double aspect, double near, double far);

// Get orthographic projection matrix
Matrix MatrixOrtho(double left, double right, double bottom, double top, double near, double far);

// Get camera look-at matrix (view matrix)
Matrix MatrixLookAt(Vector3 eye, Vector3 target, Vector3 up);

// Get float array of matrix data
float16 MatrixToFloatV(Matrix mat);

//----------------------------------------------------------------------------------
// Module Functions Definition - Quaternion math
//----------------------------------------------------------------------------------

// Add two quaternions
Quaternion QuaternionAdd(Quaternion q1, Quaternion q2);

// Add quaternion and float value
Quaternion QuaternionAddValue(Quaternion q, float add);

// Subtract two quaternions
Quaternion QuaternionSubtract(Quaternion q1, Quaternion q2);

// Subtract quaternion and float value
Quaternion QuaternionSubtractValue(Quaternion q, float sub);

// Get identity quaternion
Quaternion QuaternionIdentity(void);

// Computes the length of a quaternion
float QuaternionLength(Quaternion q);

// Normalize provided quaternion
Quaternion QuaternionNormalize(Quaternion q);

// Invert provided quaternion
Quaternion QuaternionInvert(Quaternion q);

// Calculate two quaternion multiplication
Quaternion QuaternionMultiply(Quaternion q1, Quaternion q2);

// Scale quaternion by float value
Quaternion QuaternionScale(Quaternion q, float mul);

// Divide two quaternions
Quaternion QuaternionDivide(Quaternion q1, Quaternion q2);

// Calculate linear interpolation between two quaternions
Quaternion QuaternionLerp(Quaternion q1, Quaternion q2, float amount);

// Calculate slerp-optimized interpolation between two quaternions
Quaternion QuaternionNlerp(Quaternion q1, Quaternion q2, float amount);

// Calculates spherical linear interpolation between two quaternions
Quaternion QuaternionSlerp(Quaternion q1, Quaternion q2, float amount);

// Calculate quaternion based on the rotation from one vector to another
Quaternion QuaternionFromVector3ToVector3(Vector3 from, Vector3 to);

// Get a quaternion for a given rotation matrix
Quaternion QuaternionFromMatrix(Matrix mat);

// Get a matrix for a given quaternion
Matrix QuaternionToMatrix(Quaternion q);

// Get rotation quaternion for an angle and axis
// NOTE: angle must be provided in radians
Quaternion QuaternionFromAxisAngle(Vector3 axis, float angle);

// Get the rotation angle and axis for a given quaternion
void QuaternionToAxisAngle(Quaternion q, Vector3 *outAxis, float *outAngle);

// Get the quaternion equivalent to Euler angles
// NOTE: Rotation order is ZYX
Quaternion QuaternionFromEuler(float pitch, float yaw, float roll);

// Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
// NOTE: Angles are returned in a Vector3 struct in radians
Vector3 QuaternionToEuler(Quaternion q);

// Transform a quaternion given a transformation matrix
Quaternion QuaternionTransform(Quaternion q, Matrix mat);
]])

-- easings.h
ffi.cdef([[
// Linear Easing functions
float EaseLinearNone(float t, float b, float c, float d);
float EaseLinearIn(float t, float b, float c, float d);
float EaseLinearOut(float t, float b, float c, float d);
float EaseLinearInOut(float t,float b, float c, float d);

// Sine Easing functions
float EaseSineIn(float t, float b, float c, float d);
float EaseSineOut(float t, float b, float c, float d);
float EaseSineInOut(float t, float b, float c, float d);

// Circular Easing functions
float EaseCircIn(float t, float b, float c, float d);
float EaseCircOut(float t, float b, float c, float d);
float EaseCircInOut(float t, float b, float c, float d);

// Cubic Easing functions
float EaseCubicIn(float t, float b, float c, float d);
float EaseCubicOut(float t, float b, float c, float d);
float EaseCubicInOut(float t, float b, float c, float d);

// Quadratic Easing functions
float EaseQuadIn(float t, float b, float c, float d);
float EaseQuadOut(float t, float b, float c, float d);
float EaseQuadInOut(float t, float b, float c, float d);

// Exponential Easing functions
float EaseExpoIn(float t, float b, float c, float d);
float EaseExpoOut(float t, float b, float c, float d);
float EaseExpoInOut(float t, float b, float c, float d);

// Back Easing functions
float EaseBackIn(float t, float b, float c, float d);
float EaseBackOut(float t, float b, float c, float d);
float EaseBackInOut(float t, float b, float c, float d);

// Bounce Easing functions
float EaseBounceOut(float t, float b, float c, float d);
float EaseBounceIn(float t, float b, float c, float d);
float EaseBounceInOut(float t, float b, float c, float d);

// Elastic Easing functions
float EaseElasticIn(float t, float b, float c, float d);
float EaseElasticOut(float t, float b, float c, float d);
float EaseElasticInOut(float t, float b, float c, float d);
]])

local raylib = ffi.load(lib)
local mt = { __index = raylib }
local rl = setmetatable({}, mt)

-- null implementation
rl.NUL = "\0"
rl.NULL = function(v) return v == nil end

-- Some definitions moved to here by Lua code, This is a direct port of the code
rl.PI = 3.14159265358979323846
rl.DEG2RAD = rl.PI / 180.0
rl.RAD2DEG = 180.0 / rl.PI

-- Some Basic Colors
-- NOTE: Custom raylib color palette for amazing visuals on WHITE background
rl.LIGHTGRAY  = ffi.new("Color",  200, 200, 200, 255)   -- Light Gray
rl.GRAY       = ffi.new("Color",  130, 130, 130, 255)   -- Gray
rl.DARKGRAY   = ffi.new("Color",  80, 80, 80, 255)      -- Dark Gray
rl.YELLOW     = ffi.new("Color",  253, 249, 0, 255)     -- Yellow
rl.GOLD       = ffi.new("Color",  255, 203, 0, 255)     -- Gold
rl.ORANGE     = ffi.new("Color",  255, 161, 0, 255)     -- Orange
rl.PINK       = ffi.new("Color",  255, 109, 194, 255)   -- Pink
rl.RED        = ffi.new("Color",  230, 41, 55, 255)     -- Red
rl.MAROON     = ffi.new("Color",  190, 33, 55, 255)     -- Maroon
rl.GREEN      = ffi.new("Color",  0, 228, 48, 255)      -- Green
rl.LIME       = ffi.new("Color",  0, 158, 47, 255)      -- Lime
rl.DARKGREEN  = ffi.new("Color",  0, 117, 44, 255)      -- Dark Green
rl.SKYBLUE    = ffi.new("Color",  102, 191, 255, 255)   -- Sky Blue
rl.BLUE       = ffi.new("Color",  0, 121, 241, 255)     -- Blue
rl.DARKBLUE   = ffi.new("Color",  0, 82, 172, 255)      -- Dark Blue
rl.PURPLE     = ffi.new("Color",  200, 122, 255, 255)   -- Purple
rl.VIOLET     = ffi.new("Color",  135, 60, 190, 255)    -- Violet
rl.DARKPURPLE = ffi.new("Color",  112, 31, 126, 255)    -- Dark Purple
rl.BEIGE      = ffi.new("Color",  211, 176, 131, 255)   -- Beige
rl.BROWN      = ffi.new("Color",  127, 106, 79, 255)    -- Brown
rl.DARKBROWN  = ffi.new("Color",  76, 63, 47, 255)      -- Dark Brown

rl.WHITE      = ffi.new("Color",  255, 255, 255, 255)   -- White
rl.BLACK      = ffi.new("Color",  0, 0, 0, 255)         -- Black
rl.BLANK      = ffi.new("Color",  0, 0, 0, 0)           -- Blank (Transparent)
rl.MAGENTA    = ffi.new("Color",  255, 0, 255, 255)     -- Magenta
rl.RAYWHITE   = ffi.new("Color",  245, 245, 245, 255)   -- My own White (raylib logo)

rl.SHADER_LOC_MAP_DIFFUSE  = rl.SHADER_LOC_MAP_ALBEDO
rl.SHADER_LOC_MAP_SPECULAR = rl.SHADER_LOC_MAP_METALNESS
rl.MATERIAL_MAP_DIFFUSE   = rl.MATERIAL_MAP_ALBEDO
rl.MATERIAL_MAP_SPECULAR  = rl.MATERIAL_MAP_METALNESS

-- Temporal hack to avoid breaking old codebases using
-- deprecated raylib implementation of these functions
rl.FormatText      = rl.TextFormat
rl.SubText         = rl.TextSubtext
rl.LoadText        = rl.LoadFileText
rl.GetImageData    = rl.LoadImageColors
rl.ColorAlpha      = rl.Fade
rl.FILTER_POINT    = rl.TEXTURE_FILTER_POINT
rl.FILTER_BILINEAR = rl.TEXTURE_FILTER_BILINEAR
rl.MAP_DIFFUSE     = rl.MATERIAL_MAP_DIFFUSE
rl.UNCOMPRESSED_R8G8B8A8 = rl.PIXELFORMAT_UNCOMPRESSED_R8G8B8A8

-- Add backwards compatibility support for deprecated names
rl.MOUSE_LEFT_BUTTON   = rl.MOUSE_BUTTON_LEFT
rl.MOUSE_RIGHT_BUTTON  = rl.MOUSE_BUTTON_RIGHT
rl.MOUSE_MIDDLE_BUTTON = rl.MOUSE_BUTTON_MIDDLE

-- RLGL stuff
rl.RL_CULL_DISTANCE_NEAR           = 0.01      -- Default near cull distance
rl.RL_CULL_DISTANCE_FAR            = 1000.0    -- Default far cull distance
rl.RL_SHADER_LOC_MAP_DIFFUSE       = rl.RL_SHADER_LOC_MAP_ALBEDO
rl.RL_SHADER_LOC_MAP_SPECULAR      = rl.RL_SHADER_LOC_MAP_METALNESS

-- rlights.h
ffi.cdef([[
//----------------------------------------------------------------------------------
// Types and Structures Definition
//----------------------------------------------------------------------------------
typedef enum {
    LIGHT_DIRECTIONAL,
    LIGHT_POINT
} LightType;

typedef struct {
    bool enabled;
    LightType type;
    Vector3 position;
    Vector3 target;
    Color color;
    int enabledLoc;
    int typeLoc;
    int posLoc;
    int targetLoc;
    int colorLoc;
} Light;

void CreateLight(int type, Vector3 pos, Vector3 targ, Color color, Shader shader);         // Defines a light and get locations from PBR shader
void UpdateLightValues(Shader shader, Light light);                                        // Send to PBR shader light values
]])

rl.MAX_LIGHTS        = 4        -- Max lights supported by shader
rl.LIGHT_DISTANCE    = 3.5      -- Light distance from world center
rl.LIGHT_HEIGHT      = 1.0      -- Light height position

rl.lights = ffi.new("Light[4]", ffi.new("Light"), ffi.new("Light"), ffi.new("Light"), ffi.new("Light"))
rl.lightsCount = 0 -- Current amount of created lights

-- Defines a light and get locations from PBR shader
rl.CreateLight = function(type, pos, targ, color, shader)
  local light = ffi.new("Light")
  if rl.lightsCount < rl.MAX_LIGHTS then
    light.enabled = true
    light.type = type
    light.position = pos
    light.target = targ
    light.color = color

    local enabledName = "lights[x].enabled\0"
    local typeName = "lights[x].type\0"
    local posName = "lights[x].position\0"
    local targetName = "lights[x].target\0"
    local colorName = "lights[x].color\0"
        
    enabledName:gsub("x", "0"..lightsCount)
    typeName:gsub("x", "0"..lightsCount)
    posName:gsub("x", "0"..lightsCount)
    targetName:gsub("x", "0"..lightsCount)
    colorName:gsub("x", "0"..lightsCount)
    
    light.enabledLoc = rl.GetShaderLocation(shader, enabledName)
    light.typeLoc = rl.GetShaderLocation(shader, typeName)
    light.posLoc = rl.GetShaderLocation(shader, posName)
    light.targetLoc = rl.GetShaderLocation(shader, targetName)
    light.colorLoc = rl.GetShaderLocation(shader, colorName)

    rl.UpdateLightValues(shader, light)

    rl.lights[rl.lightsCount] = light
    rl.lightsCount = rl.lightsCount + 1
  end
end

-- Send to PBR shader light values
rl.UpdateLightValues = function(shader, light)
  -- Send to shader light enabled state and type
  rl.SetShaderValue(shader, light.enabledLoc, light.enabled, rl.UNIFORM_INT)
  rl.SetShaderValue(shader, light.typeLoc, light.type, rl.UNIFORM_INT)

  -- Send to shader light position values
  rl.current_light_position = ffi.new("float[3]", light.position.x, light.position.y, light.position.z)
  rl.SetShaderValue(shader, light.posLoc, rl.current_light_position, rl.UNIFORM_VEC3)

  -- Send to shader light target position values
  rl.current_light_target = ffi.new("float[3]", light.target.x, light.target.y, light.target.z)
  rl.SetShaderValue(shader, light.targetLoc, rl.current_light_target, rl.UNIFORM_VEC3)

  -- Send to shader light color values
  rl.current_light_diff = ffi.new("float[4]", light.color.r / 255.0, light.color.g / 255.0, light.color.b / 255.0, light.color.a / 255.0)
  rl.SetShaderValue(shader, light.colorLoc, rl.current_light_diff, rl.UNIFORM_VEC4)
end

-- Types creation
rl.Vector2 = function(...)
  return ffi.new("Vector2", ...)
end

rl.Vector3 = function(...)
  return ffi.new("Vector3", ...)
end

rl.Vector4 = function(...)
  return ffi.new("Vector4", ...)
end

rl.Quaternion = function(...)
  return ffi.new("Quaternion", ...)
end

rl.Color = function(...)
  return ffi.new("Color", ...)
end

rl.Matrix = function(...)
  return ffi.new("Matrix", ...)
end

rl.Rectangle = function(...)
  return ffi.new("Rectangle", ...)
end

rl.BoundingBox = function(...)
  return ffi.new("BoundingBox", ...)
end

rl.NPatchInfo = function(...)
  return ffi.new("NPatchInfo", ...)
end

rl.Camera = function(...)
  return ffi.new("Camera", ...)
end

rl.Camera3D = function(...)
  return ffi.new("Camera3D", ...)
end

rl.Camera2D = function(...)
  return ffi.new("Camera2D", ...)
end

rl.MaterialMap = function(...)
  return ffi.new("MaterialMap", ...)
end

rl.Ray = function(...)
  return ffi.new("Ray", ...)
end

rl.VrDeviceInfo = function(...)
  return ffi.new("VrDeviceInfo", ...)
end

rl.VrStereoConfig = function(...)
  return ffi.new("VrStereoConfig", ...)
end

rl.new = function(ctype, ...)
  return ffi.new(ctype, ...)
end

-- For rlights.h
rl.Light = function(...)
  return ffi.new("Light", ...)
end

-- For raymath.h
rl.float3 = function(...)
  return ffi.new("float3", ...)
end

rl.float16 = function(...)
  return ffi.new("float16", ...)
end

-- SetTraceLogCallback implementation, All thanks goes to Astie Teddy (@TSnake41)
local C_SetTraceLogCallback = rl.SetTraceLogCallback 
function rl.SetTraceLogCallback(callback)
  C_SetTraceLogCallback(function(level, text, args)
    local buffer = ffi.new("char[?]", 512)
    ffi.C.vsnprintf(buffer, 512, text, args)
    callback(level, ffi.string(buffer))
  end)
end

local C_SetLoadFileDataCallback = rl.SetLoadFileDataCallback
function rl.SetLoadFileDataCallback(callback)
  C_SetLoadFileDataCallback(function(filename, bytesRead)
    local buffer = ffi.new("char[?]", 512)
    ffi.C.vsnprintf(buffer, 512, filename)
    
    return callback(ffi.string(buffer), bytesRead)
  end)
end

-- FileIO: Save binary data
local C_SetSaveFileDataCallback = rl.SetSaveFileDataCallback
function rl.SetSaveFileDataCallback(callback)
  -- data is void*
  C_SetSaveFileDataCallback(function(filename, data, bytesToWrite)
    local buffer = ffi.new("char[?]", 512)
    ffi.C.vsnprintf(buffer, 512, filename)
    
    return callback(ffi.string(buffer), data, bytesToWrite)
  end)
end

-- FileIO: Load text data
local C_SetLoadFileTextCallback = rl.SetLoadFileTextCallback
function rl.SetLoadFileTextCallback(callback)
  C_SetLoadFileTextCallback(function(filename)
    local buffer = ffi.new("char[?]", 512)
    ffi.C.vsnprintf(buffer, 512, filename)

    return callback(ffi.string(buffer))
  end)
end

-- FileIO: Save text data
local C_SetSaveFileTextCallback = rl.SetSaveFileTextCallback
function rl.SetSaveFileTextCallback(callback)
  C_SetSaveFileTextCallback(function(filename, text)
    local buff1 = ffi.new("char[?]", 512)
    ffi.C.vsnprintf(buff1, 512, filename)
    
    local buff2 = ffi.new("char[?]", 512)
    ffi.C.vsnprintf(buff2, 512, text)

    return callback(ffi.string(buff1), ffi.string(buff2))
  end)
end

-- Examples variables
-- Maximum value of a float, from bit pattern 01111111011111111111111111111111
rl.FLT_MAX = 340282346638528859811704183484516925440.0

setmetatable(_G, { __index = rl })
return rl

end
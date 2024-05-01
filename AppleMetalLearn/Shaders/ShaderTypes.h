//
//  Definitions.h
//  AppleMetalLearn
//
//  Created by barkar on 07.04.2024.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h


//использоввание типов и макросов в зависимости где компилится
#ifdef __METAL_VERSION__
#define NS_ENUM(_type, _name) enum _name : _type _name; enum _name : _type
typedef metal::int32_t EnumBackingType;
#else
#import <Foundation/Foundation.h>
typedef NSInteger EnumBackingType;
#endif


#include <simd/simd.h>

//индексы буферов и аттрибутов
typedef NS_ENUM(EnumBackingType, BufferIndex)
{
    BufferIndexMeshPositions = 0, //pos
    BufferIndexMeshGenerics  = 1, //uv
    BufferIndexUniforms      = 2, 
    BufferIndexParams        = 3,
    BufferIndexMaterial      = 4
};

typedef NS_ENUM(EnumBackingType, VertexAttribute)
{
    VertexAttributePosition  = 0,
    VertexAttributeTexcoord  = 1,
    VertexAttributeNormal    = 2,
    VertexAttributeTangent   = 3,
   // VertexAttributeBitangent = 4,
    //VertexAttributeColor     = 4,
};

typedef NS_ENUM(EnumBackingType, TextureIndex)
{
    TextureIndexColor    = 0,
    TextureIndexAdditional = 1,
    TextureIndexEmission = 2,
    TextureIndexShadowMap = 3
};

typedef NS_ENUM(EnumBackingType, RenderTargetIndex){
    RenderTargetLighting = 0,
    RenderTargetAlbedoShadow = 1,
    RenderTargetNormalRoughtness = 2,
    RenderTargetEmissionMetallic = 3,
    RenderTargetDepth = 4
} ;

//TODO: pack to float4
typedef struct{
    uint width;
    uint height;
    uint tiling;
    uint lightCount;
    vector_float3 cameraPosition;
    float scaleFactor;
} Params;

typedef struct{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float3x3 normalMatrix;
    matrix_float4x4 shadowProjectionMatrix;
    matrix_float4x4 shadowViewMatrix;
    vector_float3 mainLighWorldPos;
} Uniforms;

typedef struct {
    vector_float3 baseColor;
    float roughness;
    float metallic;
    vector_float3 emissionColor;
}MaterialProperties;

typedef enum {
    unused = 0,
    directionalLightType = 1,
    spotLightType = 2,
    pointLightType = 3,
    ambientLightType = 4
}LightType;

typedef struct {
    LightType type;
    vector_float3 position;
    vector_float3 color;
    float radius;
    vector_float3 attenuation;
    float coneangle;
    vector_float3 coneDirection;
    float coneAttenuation;
}Light;



#endif //

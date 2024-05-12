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
    BufferIndexFrameData      = 2, 
    BufferIndexParams        = 3,
    BufferIndexMaterial      = 4,
    BufferIndexLights        = 5
};

typedef NS_ENUM(EnumBackingType, VertexAttribute)
{
    VertexAttributePosition  = 0,
    VertexAttributeTexcoord  = 1,
    VertexAttributeNormal    = 2,
    VertexAttributeTangent   = 3,
};

typedef NS_ENUM(EnumBackingType, TextureIndex)
{
    TextureIndexColor    = 0,
    TextureIndexAdditional = 1,
    TextureIndexEmission = 2,
    TextureIndexShadowMap = 3,
    TextureIndexDepth = 4
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
    vector_float3 cameraPosition;
    float scaleFactor;
    uint width;
    uint height;
    uint tiling;
} Params;

typedef struct{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 projectionMatrixInverse;
    matrix_float4x4 modelMatrix;
    matrix_float4x4 viewMatrix;
    matrix_float3x3 normalMatrix;
    matrix_float4x4 shadowProjectionMatrix;
    matrix_float4x4 shadowViewMatrix;
    vector_float3 mainLighWorldPos;
} FrameData;

typedef struct {
    vector_float3 baseColor;
    vector_float3 emissionColor;
    float roughness;
    float metallic;
}MaterialProperties;

typedef enum {
    unused = 0,
    directionalLightType = 1,
    spotLightType = 2,
    pointLightType = 3,
    ambientLightType = 4
}LightType;

typedef struct {
    vector_float3 position;
    vector_float3 color;
    vector_float3 attenuation;
    vector_float3 coneDirection;
    float radius;
    float coneangle;
    float coneAttenuation;
}Light;

typedef struct{
    vector_float3 position;
    vector_float3 color;
    vector_float3 attenuation;
    float radius;
    float constantOffset;
}PointLight;

#endif //

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
    BufferIndexUniforms      = 2
};

typedef NS_ENUM(EnumBackingType, VertexAttribute)
{
    VertexAttributePosition  = 0,
    VertexAttributeTexcoord  = 1,
    VertexAttributeNormal    = 2,
    VertexAttributeTangent   = 3,
    VertexAttributeBitangent = 4,
    VertexAttributeColor     = 5,
};

typedef NS_ENUM(EnumBackingType, TextureIndex)
{
    TextureIndexColor    = 0,
};

typedef NS_ENUM(EnumBackingType, RenderTargetIndex){
    RenderTargetAlbedo = 1,
    RenderTargetNormal = 2,
    RenderTargetPosition = 3,
} ;

//TODO: pack to float4
typedef struct{
    uint width;
    uint height;
    uint tiling;
    uint lightCount;
    vector_float4 cameraPosition;
    float scaleFactor;
} Params

typedef struct{
    matrix_float4x4 projectionMatrix;
    matrix_float4x4 modelViewMatrix;
    matrix_float4x4 normalMatrix;
    matrix_float4x4 shadowProjectionMatrix;
    matrix_float4x4 shadowViewMatrix;
} Uniforms;

typedef struct {
    vector_float3 baseColor;
    float roughness;
    float metallic;
    float emission;
}Material

#endif /* Definitions_h */

//
//  ShaderDefs.h
//  AppleMetalLearn
//
//  Created by barkar on 15.04.2024.
//

#ifndef ShaderDefs_h
#define ShaderDefs_h

#import "ShaderTypes.h"
using namespace metal;

typedef struct{
    float4 positionOS   [[attribute(VertexAttributePosition)]];
    float2 texCoord     [[attribute(VertexAttributeTexcoord)]];
    half3 normalOS      [[attribute(VertexAttributeNormal)]];
    half4 tangentOS     [[attribute(VertexAttributeTangent)]];
} Attributes;


typedef struct{
    float4 positionCS [[position]];
    float3 positionWS;
    float3 positionVS;
    float3 shadowCoord;
    float2 texCoord ;
    half3 normalWS;
    half3 tangentWS;
    half3 bitangentWS;
    half4 color;
} Varyings;


typedef struct{
    float4 positionCS [[position]];
    float3 positionVS;
} VaryingsSimpeQuad;


typedef struct{
    float4 postition [[position]];
} InOutLightMask;


typedef struct{
    float4 position [[position]];
    float3 positionVS;
    uint instanceID [[flat]];
} PointLightInOut;


#endif /* ShaderDefs_h */

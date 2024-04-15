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
    float3 normalOS      [[attribute(VertexAttributeNormal)]];
    float3 tangentOS     [[attribute(VertexAttributeTangent)]];
    float3 bitangentOS   [[attribute(VertexAttributeBitangent)]];
    float4 color         [[attribute(VertexAttributeColor)]];
} Attributes;


typedef struct{
    float4 positionCS [[position]];
    float4 positionWS;
    float2 texCoord ;
    float3 normalWS;
    float3 tangentWS;
    float3 bitangentWS;
    float4 color;
    //float4 shafdowCoord;
} Varyings;


#endif /* ShaderDefs_h */

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
    //half4 bitangentOS   [[attribute(VertexAttributeBitangent)]];
} Attributes;


typedef struct{
    float4 positionCS [[position]];
    float3 positionWS;
    float3 positionVS;
    float2 texCoord ;
    half3 normalWS;
    half3 tangentWS;
    half3 bitangentWS;
    half4 color;
    float3 shadowCoord; 
} Varyings;


typedef struct{
    float4 positionCS [[position]];
    float3 positionVS;
} VaryingsSimpeQuad;




#endif /* ShaderDefs_h */

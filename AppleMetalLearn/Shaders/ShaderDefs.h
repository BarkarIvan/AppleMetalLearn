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
    half3 tangentOS     [[attribute(VertexAttributeTangent)]];
    //half4 bitangentOS   [[attribute(VertexAttributeBitangent)]];
    half4 color         [[attribute(VertexAttributeColor)]];
} Attributes;


typedef struct{
    float4 positionCS [[position]];
    float4 positionWS;
    float2 texCoord ;
    half3 normalWS;
    half3 tangentWS;
    half3 bitangentWS;
    half4 color;
    //float4 shafdowCoord;
} Varyings;


#endif /* ShaderDefs_h */

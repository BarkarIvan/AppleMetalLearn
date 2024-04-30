//
//  Vertex.metal
//  AppleMetalLearn
//
//  Created by barkar on 15.04.2024.
//

#include <metal_stdlib>
using namespace metal;

#import "ShaderTypes.h"
#import "ShaderDefs.h"

vertex Varyings vertex_main (
            Attributes IN [[stage_in]],
            constant Uniforms &uniforms [[buffer(BufferIndexUniforms)]])
{
    float4 positionWS = uniforms.modelMatrix * IN.positionOS;
    float4 positionCS = uniforms.projectionMatrix * uniforms.viewMatrix * float4(positionWS.xyz, 1.0);
    half3x3 normalMatrix = half3x3(uniforms.normalMatrix);
    half3 normalWS = normalMatrix * IN.normalOS.xyz;
    half3 tanWS = normalMatrix * IN.tangentOS.xyz;
    
                           
    Varyings OUT{
        .positionCS = positionCS,
        .positionWS = positionWS.xyz / positionWS.w,
        .texCoord = IN.texCoord,
        .normalWS = normalize(normalWS),
        .tangentWS = normalize(tanWS),
        .bitangentWS = normalize(normalMatrix * (cross(IN.normalOS.xyz, IN.tangentOS.xyz) * IN.tangentOS.w)),
        .shadowCoord = (uniforms.shadowProjectionMatrix * uniforms.shadowViewMatrix *  positionWS).xyz
    };
    return OUT;
}

//quad
constant float3 vertices[6] = {
  float3(-1,  1,  0),    // triangle 1
  float3( 1, -1,  0),
  float3(-1, -1,  0),
  float3(-1,  1,  0),    // triangle 2
  float3( 1,  1,  0),
  float3( 1, -1,  0)
};

vertex VaryingsSimpeQuad vertex_quad(uint vertexID [[vertex_id]])
{
    VaryingsSimpeQuad OUT{
        .positionCS = float4(vertices[vertexID],1.0)
    };
    return OUT;
}


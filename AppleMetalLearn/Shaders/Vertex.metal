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
    float4 positionWS = uniforms.modelMatrix * float4(IN.positionOS.xyz, 1.0);
    float4 positionCS = uniforms.projectionMatrix * uniforms.viewMatrix * positionWS;
    half3x3 normalMatrix = half3x3(uniforms.normalMatrix);
    half3 normalWS = normalMatrix * IN.normalOS;
    half3 mainLightDir = half3(uniforms.mainLighWorldPos.xyz);
    
                           
    Varyings OUT{
        .positionCS = positionCS,
        .positionWS = positionWS,
        .texCoord = IN.texCoord,
        .normalWS = normalWS,
        .tangentWS = normalMatrix * IN.tangentOS.xyz,
        .bitangentWS = normalMatrix * (cross(IN.tangentOS.xyz, IN.normalOS.xyz) * IN.tangentOS.w),
        .shadowCoord = (uniforms.shadowProjectionMatrix * uniforms.shadowViewMatrix *  positionWS).xyz
    };
    return OUT;
}

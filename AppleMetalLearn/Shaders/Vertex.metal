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
    float4 positionCS = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * IN.positionOS;
    half3x3 normalMatrix = half3x3(uniforms.normalMatrix);
    float4 positionWS = uniforms.modelMatrix * IN.positionOS;
   
    Varyings OUT{
        .positionCS = positionCS,
        .positionWS = positionWS,
        .texCoord = IN.texCoord,
        .normalWS = normalMatrix * IN.normalOS,
        .tangentWS = normalMatrix*IN.tangentOS.xyz,
        .bitangentWS = normalMatrix*(cross(IN.tangentOS.xyz, IN.normalOS.xyz) * IN.tangentOS.w),
        
        .shadowCoord = uniforms.shadowViewProjectionMatrix * uniforms.modelMatrix * IN.positionOS
    };
    return OUT;
}

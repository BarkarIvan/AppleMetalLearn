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
    
    float4 positionWS = uniforms.modelMatrix * IN.positionOS;
    Varyings OUT
    {
        .positionCS = positionCS,
        .positionWS = positionWS,
        .texCoord = IN.texCoord,
        .normalWS = uniforms.normalMatrix * IN.normalOS,
        .tangentWS = uniforms.normalMatrix * IN.tangentOS,
        .bitangentWS = uniforms.normalMatrix * IN.bitangentOS
        //shadow coords
    };
    return OUT;
}

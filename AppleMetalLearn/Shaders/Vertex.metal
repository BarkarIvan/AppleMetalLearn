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
    half3x3 normalhalf = half3x3(uniforms.normalMatrix);
    float4 positionWS = uniforms.modelMatrix * IN.positionOS;
    Varyings OUT;
    
        OUT.positionCS = positionCS,
        OUT.positionWS = positionWS,
        OUT.texCoord = IN.texCoord,
        OUT.normalWS = normalhalf * IN.normalOS,
        OUT.tangentWS = normalhalf * half3(IN.tangentOS),
    OUT.bitangentWS = normalhalf * (cross(OUT.tangentWS, OUT.normalWS) * IN.tangentOS.w) ;
        //shadow coords
    
    return OUT;
}

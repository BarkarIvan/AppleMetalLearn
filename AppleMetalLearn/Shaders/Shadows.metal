//
//  Shadows.metal
//  AppleMetalLearn
//
//  Created by barkar on 23.04.2024.
//

#include <metal_stdlib>
using namespace metal;
#import "ShaderDefs.h"
#import "ShaderTypes.h"

struct VertexIn
{
    float4 position [[attribute(VertexAttributePosition)]];
    half3 normal [[attribute(VertexAttributeNormal)]];
};



vertex float4 vertex_depth (const VertexIn in [[stage_in]],
                            constant Uniforms &uniforms [[buffer(BufferIndexUniforms)]])
{
    matrix_float4x4 modelViewProjectionMatrix = uniforms.shadowViewProjectionMatrix  * uniforms.modelMatrix;
    float4 p = in.position;
   // p.xyz +=   float3(in.normal * 0.001);
    
    return modelViewProjectionMatrix * (p) ;
}



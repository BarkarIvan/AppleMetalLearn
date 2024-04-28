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
};



vertex float4 vertex_depth (const VertexIn in [[stage_in]],
                            constant Uniforms &uniforms [[buffer(BufferIndexUniforms)]])
{
    matrix_float4x4 modelViewProjectionMatrix = uniforms.shadowProjectionMatrix  * uniforms.shadowViewMatrix *  uniforms.modelMatrix;
    float4 position = float4( in.position.xyz,1.0);
    
    return modelViewProjectionMatrix * position;
}



//
//  DirectionalLight.metal
//  AppleMetalLearn
//
//  Created by barkar on 29.04.2024.
//

#include <metal_stdlib>
using namespace metal;
#import "Lighting.h"
#import "ShaderDefs.h"

fragment half4 deffered_directional_light_traditional(
                    VaryingsSimpeQuad       IN            [[stage_in]],
                    constant Uniforms &     uniforms      [[buffer(BufferIndexUniforms)]],
                    texture2d<half>         albedoShadow  [[texture(RenderTargetAlbedoShadow)]],
                    texture2d<half>         normal        [[texture(RenderTargetNormal)]],
                    texture2d<half>         roughMetallic [[texture(RenderTargetRoughtnessMetallic)]],
                    texture2d<float>        depthGBuffer  [[texture(RenderTargetDepth)]]
                                                      )
{
    uint2 position = uint2(IN.positionCS.xy);
    
}


//
//  Lighting.metal
//  AppleMetalLearn
//
//  Created by barkar on 25.04.2024.
//

#include <metal_stdlib>
using namespace metal;
#import "Lighting.h"


float calculateShadow (float4 shadowCoord, depth2d<float> shadowMap)
{
    float2 shadowTextureCoord = (shadowCoord.xyz / shadowCoord.w).xy;
    shadowCoord = shadowCoord * 0.5 + 0.5;
    shadowCoord.y = 1 - shadowCoord.y;
    
    constexpr sampler shadowMapSampler(
                                       coord::normalized,
                                       filter::linear,
                                       address::clamp_to_edge,
                                       compare_func::less);
    float shadowSample = shadowMap.sample_compare(shadowMapSampler, shadowCoord.xy, shadowCoord.z);
    
    return shadowSample;
}


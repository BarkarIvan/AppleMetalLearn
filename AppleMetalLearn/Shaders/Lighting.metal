//
//  Lighting.metal
//  AppleMetalLearn
//
//  Created by barkar on 25.04.2024.
//

#include <metal_stdlib>
using namespace metal;
#import "Lighting.h"


float calculateShadow (float3 shadowCoord, depth2d<float> shadowMap)
{
    float3 shadowTextureCoord = shadowCoord;
    
    //to cpu?
    shadowTextureCoord.xy = shadowTextureCoord.xy * 0.5 + 0.5;
    shadowTextureCoord.y = 1 - shadowTextureCoord.y;
    
    constexpr sampler shadowMapSampler(coord::normalized,
                                       filter::linear,
                                       mip_filter::none,
                                       address::clamp_to_edge,
                                       compare_func::less);
    float shadowSample = shadowMap.sample_compare(shadowMapSampler, shadowTextureCoord.xy, shadowTextureCoord.z - SHADOW_BIAS);
    
    return shadowSample;
}


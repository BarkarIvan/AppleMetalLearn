//
//  CGTools.metal
//  AppleMetalLearn
//
//  Created by barkar on 30.04.2024.
//


#include <metal_stdlib>
using namespace metal;
#import "CGTools.h"

half3 reconstruct_normal_tangent_space(half2 vec)
{
    
    half3 out;
    out.xy = half2(vec.x, vec.y) * 2.0 - 1.0;
    out.z = sqrt(1 - (out.x * out.x) - (out.y * out.y));
    return out;
}


half3 reconstruct_normal_world_space(half2 vec)
{
    half3 out;
    out.xy = half2(vec.x, vec.y);
    out.z = sqrt(1 - (out.x * out.x) - (out.y * out.y));
    return out;
}

half2 safeNormalize(half2 vec)
{
    half dv3 = max(HALF_MIN, dot(vec, vec));
    return vec * rsqrt(dv3);
}


half3 safeNormalize(half3 vec)
{
    half dv3 = max(HALF_MIN, dot(vec, vec));
    return vec * rsqrt(dv3);
}


float3 safeNormalize(float3 vec)
{
    float dv3 = max(FLT_MIN, dot(vec, vec));
    return vec * rsqrt(dv3);
}

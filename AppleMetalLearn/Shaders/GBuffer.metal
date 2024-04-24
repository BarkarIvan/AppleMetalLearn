//
//  GBuffer.metal
//  AppleMetalLearn
//
//  Created by barkar on 15.04.2024.
//

#include <metal_stdlib>
using namespace metal;

#import "ShaderDefs.h"


//TODO: to utils
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


//to def
struct GBufferOut{
    half4 albedo [[color(RenderTargetAlbedoMetallic)]];
    half4 normal [[color(RenderTargetNormRoughShadow)]];
    float4 roughMetallic [[color(RenderTargetRoughtnessMetallic)]];
};


fragment GBufferOut fragment_GBuffer(
                    Varyings IN [[stage_in]],
                    texture2d<half> albedo[[texture(TextureIndexColor)]],
                    texture2d<half> NormRoughMetallic[[texture(TextureIndexAdditional)]],
                    constant MaterialProperties &materialProperties [[buffer(BufferIndexMaterial)]])
{
    GBufferOut OUT;
    constexpr sampler linearSampler(mip_filter::linear,
                                    mag_filter::linear,
                                    min_filter::linear);
    
    half4 additionalData = NormRoughMetallic.sample(linearSampler, IN.texCoord);
    
    half3 normalTS;
    half2 data = half2(additionalData.x, additionalData.y) * 2.0 - 1.0;
  
    normalTS.xy =  safeNormalize(data.xy);
    normalTS.z = sqrt((normalTS.x * normalTS.x) - (normalTS.y * normalTS.y));
    half3x3 tantgenToWorld = half3x3((IN.tangentWS), (IN.bitangentWS), (IN.normalWS));
    half3 normalWS = tantgenToWorld * normalTS;
    
    OUT.albedo = albedo.sample(linearSampler, IN.texCoord);//float4(material.baseColor, 1.0);
    OUT.albedo.a = 1.0;//shadows?
    
    OUT.normal.xyz = normalWS;
    OUT.normal.a = 1.0;
    
    OUT.roughMetallic = float4(additionalData.z, additionalData.w, 0.0,1.0);
    return OUT;
}


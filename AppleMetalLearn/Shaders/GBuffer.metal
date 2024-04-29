//
//  GBuffer.metal
//  AppleMetalLearn
//
//  Created by barkar on 15.04.2024.
//

#include <metal_stdlib>
using namespace metal;

#import "Lighting.h"
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
    half4 albedo [[color(RenderTargetAlbedoShadow)]];
    half4 normal [[color(RenderTargetNormal)]];
    float4 roughMetallic [[color(RenderTargetRoughtnessMetallic)]];
};


fragment GBufferOut fragment_GBuffer(
                    Varyings IN [[stage_in]],
                    constant Uniforms &uniforms [[buffer(BufferIndexUniforms)]],
                    constant MaterialProperties &materialProperties [[buffer(BufferIndexMaterial)]],
                    texture2d<half> albedo[[texture(TextureIndexColor)]],
                    texture2d<half> NormRoughMetallic[[texture(TextureIndexAdditional)]],
                    depth2d<float>  shadowMap[[texture(TextureIndexShadowMap)]])
{
    GBufferOut OUT;
    constexpr sampler linearSampler(mip_filter::linear,
                                    mag_filter::linear,
                                    min_filter::linear,
                                    address::repeat);
    
    half4 normRoughMetSample = NormRoughMetallic.sample(linearSampler, IN.texCoord);
    
    half3 normalTS;
    normalTS.xy = half2(normRoughMetSample.x, normRoughMetSample.y) * 2.0 - 1.0;
    normalTS.z = sqrt(1 - (normalTS.x * normalTS.x) - (normalTS.y * normalTS.y));
   
    half3x3 tantgenToWorld = half3x3(IN.tangentWS, IN.bitangentWS, IN.normalWS);
    half3 normalWS = tantgenToWorld * normalTS;
    normalWS = normalize(normalWS);
    
    //half3 lightDir = half3(normalize(uniforms.mainLighWorldPos));
    //half NdotL = max(half(0.0), dot(normalWS, lightDir));
    
    half shadow = calculateShadow(IN.shadowCoord, shadowMap);
    //shadow *= NdotL;
    
    OUT.albedo.xyz = albedo.sample(linearSampler, IN.texCoord).xyz;
    OUT.albedo.a = shadow;
    
    OUT.normal.xyz =  normalWS;
    OUT.normal.a = 1.0;
    
    OUT.roughMetallic = float4(normRoughMetSample.z, normRoughMetSample.w, 0.0,1.0);
    return OUT;
}




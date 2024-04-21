//
//  GBuffer.metal
//  AppleMetalLearn
//
//  Created by barkar on 15.04.2024.
//

#include <metal_stdlib>
using namespace metal;

#import "ShaderDefs.h"

//to def
struct GBufferOut{
    half4 albedo [[color(RenderTargetAlbedoMetallic)]];
    half4 normal [[color(RenderTargetNormRoughShadow)]];
    float4 positiob [[color(RenderTargetPosition)]];
};


fragment GBufferOut fragment_GBuffer(
                    Varyings IN [[stage_in]],
                    //temp
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
    half2 data = additionalData.xy * 2.0 - 1.0;
    half dp3 = max(HALF_MIN, dot(data, data));
    half2 safeNormalize = data * rsqrt(dp3);
    normalTS.xy =  safeNormalize;////normalize(additionalData.xy * 2.0 - 1.0);
    normalTS.z = sqrt((normalTS.x * normalTS.x) - (normalTS.y * normalTS.y));
    half3x3 tantgenToWorld = half3x3((IN.tangentWS), (IN.bitangentWS), (IN.normalWS));
    half3 normalWS = (normalTS) * tantgenToWorld;
    
    OUT.albedo = albedo.sample(linearSampler, IN.texCoord);//float4(material.baseColor, 1.0);
    OUT.albedo.a = materialProperties.metallic;
    //albedo.a = shadow
    
    OUT.normal = abs(half4(normalize(normalWS), 1.0));//half4(normalize(IN.normalWS), 1.0);
    OUT.positiob = float4(additionalData.z, additionalData.w, 0.0,1.0);
    return OUT;
}


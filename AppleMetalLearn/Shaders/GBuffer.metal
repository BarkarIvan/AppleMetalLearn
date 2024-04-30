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

#import "CGTools.h"

//TODO: to utils



//to def
struct GBufferOut{
    half4 albedo [[color(RenderTargetAlbedoShadow)]];
    half4 normal [[color(RenderTargetNormalRoughMetallic)]];
    float4 emission [[color(RenderTargetEmission)]];
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
    
    half3 normalTS = reconstruct_normal_tangent_space(half2(normRoughMetSample.x, normRoughMetSample.y));
    normalTS = normalize(normalTS);
    half3x3 tantgenToWorld = half3x3(IN.tangentWS, IN.bitangentWS, IN.normalWS);
    half3 normalWS = tantgenToWorld * normalTS;
    normalWS = normalize(normalWS);
    
    half shadow = calculateShadow(IN.shadowCoord, shadowMap);
    
    OUT.albedo.xyz = albedo.sample(linearSampler, IN.texCoord).xyz;
    OUT.albedo.a = shadow;
    
    OUT.normal.xyz = normalWS;
    OUT.normal.a = normRoughMetSample.z;
    
    
    OUT.emission = 0.0;
    OUT.emission.a = normRoughMetSample.w;
    
    return OUT;
}




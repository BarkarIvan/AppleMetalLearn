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
    half4 normal [[color(RenderTargetNormalRoughtness)]];
    half4 emission [[color(RenderTargetEmissionMetallic)]];
    float depthVS [[color(RenderTargetDepth)]];
};


fragment GBufferOut fragment_GBuffer(
                    Varyings IN [[stage_in]],
                    constant FrameData &uniforms [[buffer(BufferIndexFrameData)]],
                    constant MaterialProperties &materialProperties [[buffer(BufferIndexMaterial)]],
                    texture2d<half> albedo[[texture(TextureIndexColor)]],
                    texture2d<half> normRoughMetallic[[texture(TextureIndexAdditional)]],
                    texture2d<half> emission[[texture(TextureIndexEmission)]],
                    depth2d<float>  shadowMap[[texture(TextureIndexShadowMap)]])
{
    GBufferOut OUT;
    constexpr sampler linearSampler(mip_filter::linear,
                                    mag_filter::linear,
                                    min_filter::linear,
                                    address::repeat);
    
    half4 normRoughMetSample = normRoughMetallic.sample(linearSampler, IN.texCoord);
    
    half3 normalTS = reconstruct_normal(half2(normRoughMetSample.x, normRoughMetSample.y));
    normalTS = normalize(normalTS);
    half3x3 tantgenToWorld = half3x3(IN.tangentWS, IN.bitangentWS, IN.normalWS);
    half3 normalWS = tantgenToWorld * normalTS;
    normalWS = normalize(normalWS);
    
    //half3 lightDir = half3(normalize(uniforms.mainLighWorldPos));
    //half NdotL = max(half(0.0), dot(normalWS, lightDir));
    
    half shadow = calculateShadow(IN.shadowCoord, shadowMap);
    //shadow *= NdotL;
    
    OUT.albedo.xyz = albedo.sample(linearSampler, IN.texCoord).xyz;
    OUT.albedo.a = shadow;
    
    OUT.normal.xy = normalWS.xy;
    OUT.normal.z = normalWS.z;//normRoughMetSample.z;
    OUT.normal.a = normRoughMetSample.w;
    
    OUT.emission = emission.sample(linearSampler, IN.texCoord);
    OUT.depthVS  = IN.positionVS.z;
    return OUT;
}




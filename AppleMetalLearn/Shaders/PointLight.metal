//
//  PointLight.metal
//  AppleMetalLearn
//
//  Created by barkar on 05.05.2024.
//

#include <metal_stdlib>
using namespace metal;
#import "ShaderTypes.h"
#import "ShaderDefs.h"


half4 deffered_point_light_common(PointLightInOut IN,
                                  device Light *lights,
                                  constant Uniforms &uniforms,
                                  half4 lighting,
                                  float depth,
                                  half4 normalRoughtness,
                                  half4 emissionMettalic,
                                  half4 albedoShadow)
{
    //use eye-depth
    float3 positionVS = IN.positionVS * (depth/IN.positionVS.z);
    //
    float3 lightPos = lights[IN.instanceID].position.xyz;
    float lightDist = length(lightPos - positionVS);
    float lightRadius = lights[IN.instanceID].radius;
    
    if(lightDist < lightRadius)
    {
        float4 lightPosVS = float4(lightPos, 1.0);
        float3 fragmentPosVSToLightPosVS = lightPosVS.xyz - positionVS;
        float3 lightDir = normalize(fragmentPosVSToLightPosVS);
        
        half3 lightColor = half3(lights[IN.instanceID].color);
        //diffuse contrib
        half NdotL = max(dot(float3(normalRoughtness.xyz), lightDir), 0.0f);
        
        half4 diffuseConntributio = half4(albedoShadow.xyz * NdotL * lightColor, 1.0);
        //specularContrrib
       // half3 specularContributionn =
        float attenuation = 1.0 - (lightDist / lightRadius);
        attenuation *= attenuation;
        
        lighting += (diffuseConntributio + half4(lightColor,0)) * attenuation;
    }
    return lighting;
}


fragment half4 deffered_point_light_fragment(
                                             PointLightInOut IN [[stage_in]],
                                             constant Uniforms &uniforms [[buffer(BufferIndexUniforms)]],
                                             device Light *lights  [[buffer(BufferIndexLights)]],
                                             texture2d<half> albedoShadowTexture [[texture(RenderTargetAlbedoShadow)]],
                                             texture2d<half> normalRoughtnessTexture [[texture(RenderTargetNormalRoughtness)]],
                                             texture2d<half> emissionMettalicTexture [[texture(RenderTargetEmissionMetallic)]],
                                             texture2d<float> gBufferDepthTexture [[texture(RenderTargetDepth)]])
{
    uint2 position = uint2(IN.position.xy);
    half4 lighting = half4(0);//emission?
    float depth = gBufferDepthTexture.read(position.xy).x;
    half4 normalRoughtness = normalRoughtnessTexture.read(position.xy);
    half4 albedoShadow = albedoShadowTexture.read(position.xy);
    half4 emissionMetallic = emissionMettalicTexture.read(position.xy);
    
    return deffered_point_light_common(IN, lights, uniforms, lighting, depth, normalRoughtness, emissionMetallic, albedoShadow);
}

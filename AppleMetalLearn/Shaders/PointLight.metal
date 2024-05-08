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
        
        half4 lightColor = half4(half3(lights[IN.instanceID].color), 1.0);
        //diffuse contrib
        half NdotL = max(dot(normalRoughtness.xyz, half3(lightDir)), 0.0h);
        
    half4 diffuseConntributio = NdotL * lightColor * half4(albedoShadow.xyz,1.0);//half4(albedoShadow * NdotL * lightColor, 1.0);
        //specularContrrib
       // half3 specularContributionn =
        float attenuation = 1.0 - (lightDist / lightRadius);
        //attenuation *= attenuation;
        
    lighting += ((diffuseConntributio) * attenuation);// * attenuation;
    }
    return lighting;//// lighting; //half4(diffuseConntributio);
}


fragment half4 deffered_point_light_fragment(
                                             PointLightInOut IN [[stage_in]],
                                             constant Uniforms &uniforms [[buffer(BufferIndexUniforms)]],
                                             device Light *lights  [[buffer(BufferIndexLights)]],
                                             texture2d<half> albedoShadowTexture [[texture(TextureIndexColor)]],
                                             texture2d<half> normalRoughtnessTexture [[texture(TextureIndexAdditional)]],
                                             texture2d<half> emissionMettalicTexture [[texture(TextureIndexEmission)]],
                                             texture2d<float> gBufferDepthTexture [[texture(TextureIndexDepth)]])
{
    uint2 position = uint2(IN.position.xy);
    half4 lighting = half4(0);//emission?
    float depth = gBufferDepthTexture.read(position.xy).x;
    half4 normalRoughtness = normalRoughtnessTexture.read(position.xy);
    half4 albedoShadow = albedoShadowTexture.read(position.xy);
    half4 emissionMetallic = emissionMettalicTexture.read(position.xy);
    
    
    Light l = lights[IN.instanceID];
    half3 color = (half3)l.color;
    
    return  deffered_point_light_common(IN, lights, uniforms, lighting, depth, normalRoughtness, emissionMetallic, albedoShadow);
}

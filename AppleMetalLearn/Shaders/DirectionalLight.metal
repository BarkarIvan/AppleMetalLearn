//
//  DirectionalLight.metal
//  AppleMetalLearn
//
//  Created by barkar on 29.04.2024.
//

#include <metal_stdlib>
using namespace metal;
#import "ShaderDefs.h"


#import "CGTools.h"



half4 calculate_deffered_directional_light(VaryingsSimpeQuad IN,
                                           constant Uniforms &uniforms,
                                           half4 albedo_shadow,
                                           half4 normalRouhMetallic)

{
    
    float3 mainLightdir = safeNormalize(uniforms.mainLighWorldPos.xyz);
    half3 normalWS =  normalRouhMetallic.xyz;
    
    half NdotL = max(0.0h, dot(normalWS, half3(mainLightdir)));
    
   //colors?
    half4 color = saturate(NdotL);// * albedo_shadow.a);
    color.a = 1.0;
    return color;
}


fragment half4 deffered_directional_light_traditional(
                    VaryingsSimpeQuad       IN            [[stage_in]],
                    constant Uniforms       &uniforms     [[buffer(BufferIndexUniforms)]],
                    texture2d<half>         albedoShadow  [[texture(TextureIndexColor)]],
                    texture2d<half>         normal        [[texture(TextureIndexAdditional)]],
                    texture2d<half> emission [[texture(TextureIndexEmission)]])
                 //   texture2d<float>        depthGBuffer  [[texture(RenderTargetDepth)]])
                                                      
{
    uint2 position = uint2(IN.positionCS.xy);
    //float depth = depthGBuffer.read(position.xy).x;
    half4 albedo_shadow = albedoShadow.read(position.xy);
    half4 normRgMt = normal.read(position.xy);
    return calculate_deffered_directional_light(IN, uniforms, albedo_shadow, normRgMt);
    
}

 

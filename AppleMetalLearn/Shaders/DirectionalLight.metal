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
                                           constant FrameData &uniforms,
                                           half4 albedo_shadow,
                                           half4 normalRouhMetallic)

{
    
    float3 mainLightdir = normalize(uniforms.mainLighWorldPos);
    half3 normalWS = normalRouhMetallic.xyz;
    
    half NdotL = max(0.0h, dot(normalWS, half3(mainLightdir)));
    
   //colors?
    half4 color = NdotL * albedo_shadow.a;
    color.xyz = albedo_shadow.rgb * color.rgb;
    color.a = 1.0;
    return color;
}


fragment half4 deffered_directional_light_traditional(
                    VaryingsSimpeQuad       IN            [[stage_in]],
                    constant FrameData       &uniforms     [[buffer(BufferIndexFrameData)]],
                    texture2d<half>         albedoShadow  [[texture(TextureIndexColor)]],
                    texture2d<half>         normal        [[texture(TextureIndexAdditional)]],
                     texture2d<half> emission [[texture(TextureIndexEmission)]],
                     texture2d<float>        depthGBuffer  [[texture(RenderTargetDepth)]])
                                                      
{
    uint2 position = uint2(IN.positionCS.xy);
    //float3 viewDir = normalize(IN.positionVS)* depth;
   
    half4 albedo_shadow = albedoShadow.read(position.xy);
    half4 normRgMt = normal.read(position.xy);
    return calculate_deffered_directional_light(IN, uniforms, albedo_shadow, normRgMt);
    
}

 

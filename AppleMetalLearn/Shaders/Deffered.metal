//
//  GBuffer.metal
//  AppleMetalLearn
//
//  Created by barkar on 15.04.2024.
//

#include <metal_stdlib>
using namespace metal;

#import "ShaderDefs.h"

struct GBufferOut{
    float4 albedo [[color(RenderTargetAlbedo)]];
    half4 normal [[color(RenderTargetNormal)]];
    float4 positiob [[color(RenderTargetPosition)]];
};


fragment GBufferOut fragment_GBuffer(
                                     Varyings IN [[stage_in]],
                                     //shadowTexture
                                     constant Material &material [[buffer(BufferIndexMaterial)]])
{
    GBufferOut OUT;
    OUT.albedo = float4(1,1,0,1);//float4(material.baseColor, 1.0);
    //albedo.a = shadow
    OUT.normal = half4(normalize(IN.normalWS),1.0);
    OUT.positiob = float4(IN.positionWS);
    return OUT;
}


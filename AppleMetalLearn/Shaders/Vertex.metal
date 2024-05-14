//
//  Vertex.metal
//  AppleMetalLearn
//
//  Created by barkar on 15.04.2024.
//

#include <metal_stdlib>
using namespace metal;

#import "ShaderTypes.h"
#import "ShaderDefs.h"

vertex Varyings vertex_main (
            Attributes IN [[stage_in]],
            constant FrameData &uniforms [[buffer(BufferIndexFrameData)]])
{
    float4 modelPos = float4(IN.positionOS.xyz, 1.0);
    float4 positionWS = uniforms.modelMatrix * modelPos;
    float4 positionVS =  uniforms.viewMatrix * positionWS;
    float4 positionCS = uniforms.projectionMatrix * positionVS;
    half3x3 normalMatrix = half3x3(uniforms.normalMatrix);
    half3 normalWS = normalMatrix * IN.normalOS.xyz;
    half3 tanWS = normalMatrix * IN.tangentOS.xyz;
    
                           
    Varyings OUT{
        .positionCS = positionCS,
        .positionWS = positionWS.xyz / positionWS.w,
        .positionVS = positionVS.xyz,
        .texCoord = IN.texCoord,
        .normalWS = normalize(normalWS),
        .tangentWS = normalize(tanWS),
        .bitangentWS = normalize(normalMatrix * (cross(IN.normalOS.xyz, IN.tangentOS.xyz) * IN.tangentOS.w)),
        .shadowCoord = (uniforms.shadowProjectionMatrix * uniforms.shadowViewMatrix *  positionWS).xyz
    };
    return OUT;
}

//quad
constant float3 vertices[6] = {
  float3(-1,  1,  0),    // triangle 1
  float3( 1, -1,  0),
  float3(-1, -1,  0),
  float3(-1,  1,  0),    // triangle 2
  float3( 1,  1,  0),
  float3( 1, -1,  0)
};

vertex VaryingsSimpeQuad vertex_quad(uint vertexID [[vertex_id]],
                                     constant FrameData &uniforms [[buffer(BufferIndexFrameData)]])
{
    float4 positionCS = float4(vertices[vertexID],1.0);
    
    //eye depth
    float4 unprojected_vs_coord = uniforms.projectionMatrixInverse * positionCS;
    float3 positionVS = unprojected_vs_coord.xyz/unprojected_vs_coord.w;
    
    VaryingsSimpeQuad OUT{
        .positionCS = positionCS,
        //eyye depth
        .positionVS = positionVS
        
    };
    return OUT;
}

vertex InOutLightMask vertex_light_mask (const device float4 * postions     [[buffer(BufferIndexMeshPositions)]],
                                        const device PointLight   *lights        [[buffer(BufferIndexLights)]],
                                        constant FrameData    &uniforms      [[buffer(BufferIndexFrameData)]],
                                         uint                instanceID     [[instance_id]],
                                         uint                vertexID       [[vertex_id]])
{
    InOutLightMask OUT;
    
    PointLight light = lights[instanceID];
    float4 positioVS = uniforms.viewMatrix * float4(postions[vertexID].xyz * light.radius + light.position.xyz, 1.0);
    OUT.postition = uniforms.projectionMatrix *  positioVS;
    
    return OUT;
}


vertex PointLightInOut deferred_point_light_vertex(const device float4 *vertices [[buffer(BufferIndexMeshPositions)]],
                                                   const device PointLight *lights [[buffer(BufferIndexLights)]],
                                                   constant FrameData &uniforms [[buffer(BufferIndexFrameData)]],
                                                   uint instance_ID [[instance_id]],
                                                   uint vertex_ID [[vertex_id]]
                                                   )
{
    PointLightInOut OUT;
    PointLight light = lights[ instance_ID];
    OUT.instanceID = instance_ID;
    OUT.positionVS = (uniforms.viewMatrix * float4(vertices[vertex_ID].xyz * light.radius + light.position.xyz, 1.0)).xyz;
    OUT.position = uniforms.projectionMatrix *  float4(OUT.positionVS.xyz, 1.0);
   
    return OUT;
}

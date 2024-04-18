//
//  TBDRRenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 18.04.2024.
//

import MetalKit

struct TBDRRenderPass: RenderPass{
    
    
    
    let name = "TBDR Render Pass"
    var descriptor: MTLRenderPassDescriptor?
    
    var gBufferPipelineState: MTLRenderPipelineState
    var directioLightPipelineState: MTLRenderPipelineState
    var pointLightPipelineState: MTLRenderPipelineState
    
    
    mutating func resize(view: MTKView, size: CGSize) {
        <#code#>
    }
    
    func draw(commandBuffer: any MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        <#code#>
    }
}

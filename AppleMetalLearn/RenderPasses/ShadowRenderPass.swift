//
//  ShadowRenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 23.04.2024.
//

import MetalKit

struct ShadowRenderPass: RenderPass
{

    let name: String = "Shadow Render Pass"
    
    var descriptor: MTLRenderPassDescriptor? = MTLRenderPassDescriptor()
    var depthStencilState: MTLDepthStencilState? = Self.buildDepthStencilState()
    var pipelineState: MTLRenderPipelineState
    var shadowTextute: MTLTexture?
    var debugTexture: MTLTexture?
    var size: CGSize = CGSize(width: 2048, height: 2048) //config
    
    
    init()
    {
        pipelineState = PipelineStates.createShadowPipelineState()
        shadowTextute = Self.makeTexture(size: size, pixelFormat: .depth32Float, name: "Shadow pass texture")
        
        //debug
        debugTexture = Self.makeTexture(size: size, pixelFormat: .rgba8Unorm, name: "Debug Shadow Pass")
        //debug
    }
    
    
    mutating func resize(view: MTKView, size: CGSize) {
        
    }
    
    func draw(commandBuffer: any MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params)
    {
        guard let descriptor = descriptor else {return}
       
        descriptor.depthAttachment.texture = shadowTextute
        descriptor.depthAttachment.loadAction = .clear
        descriptor.depthAttachment.storeAction = .store
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else{ return}
        
        renderEncoder.label = "Shadow pass command buffer"
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        for model in scene.models
        {
            renderEncoder.pushDebugGroup(model.name)
            model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
            renderEncoder.popDebugGroup()
            
        }
        renderEncoder.endEncoding()
    }
}

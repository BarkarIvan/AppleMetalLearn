//
//  ShadowRenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 23.04.2024.
//

import MetalKit

struct DirectionalLightShadowPass: RenderPass
{

    let name: String = "Shadow Render Pass"
    
    var descriptor: MTLRenderPassDescriptor? = MTLRenderPassDescriptor()
    var depthStencilState: MTLDepthStencilState?
    var pipelineState: MTLRenderPipelineState
    var destinationTexture: MTLTexture?
    var debugTexture: MTLTexture?
    var size: CGSize = CGSize(width: 2048, height: 2048) //config
    
    
    init()
    {
        pipelineState = PipelineStates.createShadowPipelineState()
        depthStencilState = DepthStencilStates.createShadowDepthStencilState()
        destinationTexture = Self.makeTexture(size: size, pixelFormat: .depth32Float, name: "Shadow pass texture")
    }
    
    
    mutating func resize(view: MTKView, size: CGSize) {
        
    }
    
    func draw(commandBuffer: any MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params)
    {
        guard let descriptor = descriptor else {return}
       
        descriptor.depthAttachment.texture = destinationTexture
        descriptor.depthAttachment.loadAction = .clear
        descriptor.depthAttachment.storeAction = .store
        
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else{ return}
        
        renderEncoder.label = "Shadow pass command buffer"
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setDepthBias(0.015, slopeScale: 7, clamp: 0.02)
        
        for model in scene.models
        {
            renderEncoder.pushDebugGroup(model.name)
            //TODO: материал не нужен
            model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
            renderEncoder.popDebugGroup()
            
        }
        renderEncoder.endEncoding()
    }
}

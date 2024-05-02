//
//  GBufferRenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//

import MetalKit

struct GBufferRenderPass: RenderPass{
    let name = "GBuffer Render Pass"
    var descriptor: MTLRenderPassDescriptor?
    
    var pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState?
    weak var shadowMap: MTLTexture?
    
    //RENAME!!!
    var albedoTexture: MTLTexture?
    var normalRoughtnessTexture: MTLTexture?
    var emissionTexture: MTLTexture?
    var emissionMetallicTexture: MTLTexture?
    var GBufferDepthTexture: MTLTexture?
    var depthTexture: MTLTexture?
    
    init(view: MTKView){
        pipelineState = PipelineStates.createGBufferPipelineState( vertexFunctionName: "vertex_main", fragmentFunctionName: "fragment_GBuffer")
        depthStencilState = Self.buildDepthStencilState()
        descriptor = MTLRenderPassDescriptor()
    }
    
    mutating func resize(view: MTKView, size: CGSize) {
        albedoTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.albedo, name: "Albedo-Shadow texture")
        normalRoughtnessTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.normal, name: "Normal-Roughtness texture")
        emissionTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.roughMetallic, name: "Emission-Metallic Texture")
        GBufferDepthTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.depth, name: "GBUffer Depth Texture" )
       // depthTexture = Self.makeTexture(size: size, pixelFormat: .depth32Float, name: "Depth texture Texture")
    }
    
    func draw(in view: MTKView, commandBuffer: MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {

        /*
        let textures = [albedoTexture, normalRoughtnessTexture, emissionTexture, GBufferDepthTexture]
        
        for (index, texture) in textures.enumerated(){
            let attachment = descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue + index]//???
            attachment?.texture = texture
            attachment?.loadAction = .clear
            attachment?.storeAction = .store
            attachment?.clearColor = MTLClearColor(red: 0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
         */
        
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].texture = albedoTexture
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].texture = normalRoughtnessTexture
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].texture = emissionTexture
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].texture = GBufferDepthTexture
        
        
        descriptor?.depthAttachment.texture = view.depthStencilTexture
        descriptor?.stencilAttachment.texture = view.depthStencilTexture
        descriptor?.depthAttachment.storeAction = .store
        descriptor?.stencilAttachment.storeAction = .store
        
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else{
            return
        }
        renderEncoder.pushDebugGroup("G-Buffer Render Pass")
        renderEncoder.pushDebugGroup("Set states")
        
        renderEncoder.label = name
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.popDebugGroup()

        // set shadowmap
        renderEncoder.setFragmentTexture(shadowMap, index: TextureIndex.shadowMap.rawValue)
        
        for model in scene.models{
            renderEncoder.pushDebugGroup(model.name)
            model.render(encoder: renderEncoder, uniforms: uniforms, params: params)
            renderEncoder.popDebugGroup()
        }
        renderEncoder.popDebugGroup()

        renderEncoder.endEncoding()
    }
    
    
}

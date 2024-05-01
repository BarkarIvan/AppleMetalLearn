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
    var GBufferDepth: MTLTexture?
    var depthTexture: MTLTexture?
    
    init(view: MTKView){
        pipelineState = PipelineStates.createGBufferPipelineState( vertexFunctionName: "vertex_main", fragmentFunctionName: "fragment_GBuffer")
        depthStencilState = Self.buildDepthStencilState()
        descriptor = MTLRenderPassDescriptor()
    }
    
    mutating func resize(view: MTKView, size: CGSize) {
        albedoTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.albedo, name: "Albedo texture")
        normalRoughtnessTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.normal, name: "Normal texture")
        emissionTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.roughMetallic, name: "Roughtness-Metallic Texture")
        GBufferDepth = Self.makeTexture(size: size, pixelFormat: PixelFormats.depth, name: "GBUffer Depth")
        depthTexture = Self.makeTexture(size: size, pixelFormat: .depth32Float, name: "Depth texture")
    }
    
    func draw(commandBuffer: MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {

        let textures = [albedoTexture, normalRoughtnessTexture, emissionTexture, GBufferDepth]
        
        for (index, texture) in textures.enumerated(){
            let attachment = descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue + index]//???
            attachment?.texture = texture
            attachment?.loadAction = .clear
            attachment?.storeAction = .store
            attachment?.clearColor = MTLClearColor(red: 0, green: 0.0, blue: 0.0, alpha: 0.0)
        }
        descriptor?.depthAttachment.texture = depthTexture
        descriptor?.depthAttachment.storeAction = .dontCare
        
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else{
            return
        }
        renderEncoder.pushDebugGroup("G-Buffer Render Pass")
        renderEncoder.pushDebugGroup("Set states")
        
        renderEncoder.label = name
       // renderEncoder.setCullMode(.back)
        //renderEncoder.setFrontFacing(.clockwise)
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        renderEncoder.popDebugGroup()

        // shadowMap
        
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

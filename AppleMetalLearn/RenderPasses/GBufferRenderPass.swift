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
    
    static func buildDepthStencilState() -> MTLDepthStencilState?{
        let deescriptor = MTLDepthStencilDescriptor()
        let stencilDescriptor = MTLStencilDescriptor()
        stencilDescriptor.depthStencilPassOperation = .replace
        deescriptor.frontFaceStencil = stencilDescriptor
        deescriptor.backFaceStencil = stencilDescriptor
        deescriptor.depthCompareFunction = .less
        deescriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: deescriptor)
    }
    
    mutating func resize(view: MTKView, size: CGSize) {
        albedoTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.albedo, name: "Albedo-Shadow texture")
        normalRoughtnessTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.normal, name: "Normal-Roughtness texture")
        emissionTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.roughMetallic, name: "Emission-Metallic Texture")
        GBufferDepthTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.depth, name: "GBUffer Depth Texture" )
      
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
        //TODO CYCLE
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].texture = albedoTexture
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].texture = normalRoughtnessTexture
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].texture = emissionTexture
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].texture = GBufferDepthTexture
        
        let clarColor:MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].clearColor = clarColor
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].clearColor = clarColor
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].clearColor = clarColor
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].clearColor = clarColor
        
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
        renderEncoder.setStencilReferenceValue(128)
        
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

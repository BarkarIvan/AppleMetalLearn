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
    

    var albedoShadowTexture: MTLTexture?
    var normalRoughtnessTexture: MTLTexture?
    var emissionTexture: MTLTexture?
    var emissionMetallicTexture: MTLTexture?
    var GBufferDepthTexture: MTLTexture?
    var depthTexture: MTLTexture?
    
    init(view: MTKView){
        pipelineState = PipelineStates.createGBufferPipelineState( vertexFunctionName: "vertex_main", fragmentFunctionName: "fragment_GBuffer")
        depthStencilState = DepthStensilPipelineStates.buildGBufferDepthStencilState()
        descriptor = MTLRenderPassDescriptor()
    }
    
   
    
    mutating func resize(view: MTKView, size: CGSize) {
        albedoShadowTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.gBufferAlbedoShadow, name: "Albedo-Shadow texture")
        normalRoughtnessTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.gbufferNormalRoughtess, name: "Normal-Roughtness texture")
        emissionTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.gBufferEmissionMetallic, name: "Emission-Metallic Texture")
        GBufferDepthTexture = Self.makeTexture(size: size, pixelFormat: PixelFormats.gBufferDepth, name: "GBUffer Depth Texture" )
      
    }
    
    func draw(in view: MTKView, commandBuffer: MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        //TODO CYCLE
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].texture = albedoShadowTexture
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].texture = normalRoughtnessTexture
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].texture = emissionTexture
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].texture = GBufferDepthTexture
        
        let clearColor:MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.albedoShadow.rawValue].clearColor = clearColor
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.normalRoughtness.rawValue].clearColor = clearColor
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.emissionMetallic.rawValue].clearColor = clearColor
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].loadAction = .clear
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].storeAction = .store
        descriptor?.colorAttachments[RenderTargetIndex.depth.rawValue].clearColor = clearColor
        
        descriptor?.depthAttachment.texture = view.depthStencilTexture
        descriptor?.stencilAttachment.texture = view.depthStencilTexture
        descriptor?.depthAttachment.storeAction = .store
        descriptor?.stencilAttachment.storeAction = .store
        
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else{
            return
        }
        renderEncoder.pushDebugGroup("G-Buffer Render Pass")
        renderEncoder.label = name
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setStencilReferenceValue(128)
        
        //SET SHADOWMAP TEXTURE
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

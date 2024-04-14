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
    weak var shadowTexture: MTLTexture?
    
    var albedoTexture: MTLTexture?
    var normaltexture: MTLTexture?
    var positionTexture: MTLTexture?
    var depthTexture: MTLTexture?
    
    init(view: MTKView){
        pipelineState = PipelineStates.createGBufferPipelineState(colorPixelFormat: view.colorPixelFormat, vertexFunctionName: "vertex_main", fragmentFunctionName: "fragment_GBuffer")
        depthStencilState = Self.buildDepthStencilState()
        descriptor = MTLRenderPassDescriptor()
    }
    
    mutating func resize(view: MTKView, size: CGSize) {
        albedoTexture = Self.makeTexture(size: size, pixelFormat: .bgra8Unorm_srgb, name: "Albedo texture")
        normaltexture = Self.makeTexture(size: size, pixelFormat: .rgba16Float, name: "Normal texture")
        positionTexture = Self.makeTexture(size: size, pixelFormat: .rgba16Float, name: "Position Texture")
        depthTexture = Self.makeTexture(size: size, pixelFormat: .depth32Float, name: "Depth texture")
    }
    
    func draw(commandBuffer: MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        
        let textures = [albedoTexture, normaltexture, positionTexture]
        
        for (index, texture) in textures.enumerated(){
            let attachment = descriptor?.colorAttachments[RenderTargetIndex.albedo.rawValue + index]
            attachment?.texture = texture
            attachment?.loadAction = .clear
            attachment?.storeAction = .store
            attachment?.clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1.0)
        }
        descriptor?.depthAttachment.texture = depthTexture
        descriptor?.depthAttachment.storeAction = .dontCare
        
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else{
            return
        }
        renderEncoder.label = name
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        
        //TODO:
        //renderEncoder.setFragmentTexture(shadowTexture, index: TextureIndex.shadow.rawValue)
        
        for model in scene.models{
            renderEncoder.pushDebugGroup(model.name)
            model.render(commandBuffer: <#T##MTLCommandBuffer#>, scene: <#T##GameScene#>, uniforms: <#T##Uniforms#>, params: <#T##Params#>)
        }
    }
    
    
}

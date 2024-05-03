//
//  DirectionalLightRenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 30.04.2024.
//

import MetalKit

struct DirectionalLightRenderPass: RenderPass
{
    let name = "Directional light Pass"
    var descriptor: MTLRenderPassDescriptor?
    
    var pipelineState: MTLRenderPipelineState
    let depthStencilState: MTLDepthStencilState?
    
    weak var albedoShadowTexture: MTLTexture?
    weak var normalRoughtnessMetallicTexture: MTLTexture?
    weak var emissionTeexture: MTLTexture?
    weak var depthTexture: MTLTexture?
    
    init(view: MTKView)
    {
        pipelineState = PipelineStates.createeDirectionalLightPipelineState(vertexFunctionName: "vertex_quad", fragmentFunctionName: "deffered_directional_light_traditional", colorPixelFormat: .bgra8Unorm_srgb);// view.colorPixelFormat)
        depthStencilState = Self.buildDepthStencilState()
        
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState?{
        let deescriptor = MTLDepthStencilDescriptor()
        let stencilDescriptor = MTLStencilDescriptor()
        stencilDescriptor.stencilCompareFunction = .equal
        stencilDescriptor.readMask = 0xFF
        stencilDescriptor.writeMask = 0x0
        deescriptor.frontFaceStencil = stencilDescriptor
        deescriptor.backFaceStencil = stencilDescriptor
        //deescriptor.depthCompareFunction = .less
       // deescriptor.isDepthWriteEnabled = true
        return Renderer.device.makeDepthStencilState(descriptor: deescriptor)
    }
    
    mutating func resize(view: MTKView, size: CGSize) {}
    
    func draw(in view: MTKView, commandBuffer:  MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        
        descriptor?.depthAttachment.texture = view.depthStencilTexture
        descriptor?.stencilAttachment.texture = view.depthStencilTexture
        
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {return}
        
        renderEncoder.label = name
        renderEncoder.setDepthStencilState(depthStencilState)
        
        var uniforms = uniforms
        
        //unniforms buffer
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        renderEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        
        //SET GBUFFER TEXTURES
        renderEncoder.setFragmentTexture(albedoShadowTexture, index: TextureIndex.color.rawValue)
        
        renderEncoder.setFragmentTexture(normalRoughtnessMetallicTexture, index: TextureIndex.additional.rawValue)
        renderEncoder.setFragmentTexture(emissionTeexture, index: TextureIndex.emission.rawValue)
        renderEncoder.setFragmentTexture(depthTexture, index: TextureIndex.depth.rawValue)
        
        renderEncoder.pushDebugGroup("Directional Light Pass")
        renderEncoder.setRenderPipelineState(pipelineState)
            
       renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
        renderEncoder.popDebugGroup()
        renderEncoder.endEncoding()      
        
    }
    
    
    
}

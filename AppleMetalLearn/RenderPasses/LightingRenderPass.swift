//
//  DirectionalLightRenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 30.04.2024.
//

import MetalKit

struct LightingRenderPass: RenderPass
{
    let name = "Lighting Pass"
    var descriptor: MTLRenderPassDescriptor?
    
    var directionalLightPassRenderPipelineState: MTLRenderPipelineState
    var lightMaskPipelineState: MTLRenderPipelineState

    let directionalLightPassDepthStencilState: MTLDepthStencilState?
    let lightMaskDepthStencilState: MTLDepthStencilState?
    
    weak var albedoShadowTexture: MTLTexture?
    weak var normalRoughtnessMetallicTexture: MTLTexture?
    weak var emissionTeexture: MTLTexture?
    weak var depthTexture: MTLTexture?
    
    init(view: MTKView)
    {
        descriptor = MTLRenderPassDescriptor()
        
        //create in renderr?
        directionalLightPassRenderPipelineState = PipelineStates.createeDirectionalLightPipelineState(vertexFunctionName: "vertex_quad", fragmentFunctionName: "deffered_directional_light_traditional", colorPixelFormat: .bgra8Unorm_srgb);// view.colorPixelFormat)
        directionalLightPassDepthStencilState = Self.buildDirectionalLightDepthStencilState()
        
        lightMaskPipelineState = PipelineStates.createLightMaskPipelieState(vertexFunctionName: "vertex_light_mask", colorPixelFormat: view.colorPixelFormat)
        lightMaskDepthStencilState = Self.buildLightMaskDepthStencilState()
        
    }
    //to depth states
    static func buildDirectionalLightDepthStencilState() -> MTLDepthStencilState?{
        let deescriptor = MTLDepthStencilDescriptor()
        let stencilDescriptor = MTLStencilDescriptor()
        stencilDescriptor.stencilCompareFunction = .equal
        stencilDescriptor.readMask = 0xFF
        stencilDescriptor.writeMask = 0x0
        deescriptor.frontFaceStencil = stencilDescriptor
        deescriptor.backFaceStencil = stencilDescriptor
        return Renderer.device.makeDepthStencilState(descriptor: deescriptor)
    }
    
    static func buildLightMaskDepthStencilState() -> MTLDepthStencilState?{
        let stencilStateDescriptor = MTLStencilDescriptor()
        stencilStateDescriptor.depthFailureOperation = .incrementClamp
        
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.backFaceStencil = stencilStateDescriptor
        descriptor.frontFaceStencil = stencilStateDescriptor
       
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
    
    
    mutating func resize(view: MTKView, size: CGSize) {}
    
    
    func draw(in view: MTKView, commandBuffer:  MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {

        descriptor?.depthAttachment.loadAction = .load
        descriptor?.stencilAttachment.loadAction = .load
       
        
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {return}
       
        //DIRECTIONAL LIGHT PASS
        
        renderEncoder.label = name
        renderEncoder.setDepthStencilState(directionalLightPassDepthStencilState)
        renderEncoder.setStencilReferenceValue(128)
        
        var uniforms = uniforms
        
        //unniforms buffer
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        renderEncoder.setFragmentBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        
        //SET GBUFFER TEXTURES
        renderEncoder.setFragmentTexture(albedoShadowTexture, index: TextureIndex.color.rawValue)
        
        renderEncoder.setFragmentTexture(normalRoughtnessMetallicTexture, index: TextureIndex.additional.rawValue)
        renderEncoder.setFragmentTexture(emissionTeexture, index: TextureIndex.emission.rawValue)
        renderEncoder.setFragmentTexture(depthTexture, index: TextureIndex.depth.rawValue)
        
        renderEncoder.pushDebugGroup("Directional light Pass Commands")
        renderEncoder.setRenderPipelineState(directionalLightPassRenderPipelineState)
            
       renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
        renderEncoder.popDebugGroup()
        ///
        ///
        ///
        //LIGH MASK PASS
        renderEncoder.pushDebugGroup("Point Light Mask Commands")
        renderEncoder.setDepthStencilState(lightMaskDepthStencilState)
        renderEncoder.setRenderPipelineState(lightMaskPipelineState)
        renderEncoder.setStencilReferenceValue(128)
        renderEncoder.setCullMode(.front)
        
        renderEncoder.setVertexBuffer(scene.lighting.pointsLightsBuffer, offset: 0, index: BufferIndex.lights.rawValue)
        
        renderEncoder.pushDebugGroup("Light Mask Pass")
        
        guard let mesh = scene.icosahedron?.meshes.first,
              let submesh = mesh.submeshes.first else{
            
            return}
        for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: index)
        }
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer, indexBufferOffset: submesh.indexBufferOffset,
                                            instanceCount: scene.lighting.pointLightsArray.count)
        
        renderEncoder.popDebugGroup()
        renderEncoder.popDebugGroup()
        
        renderEncoder.endEncoding()
        
    }
    
    
    
}

//
//  LightingRenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 17.04.2024.
//

import MetalKit

struct LightingRenderPass: RenderPass{
    
    
    let name = "Lighting Render Pass"
    var descriptor: MTLRenderPassDescriptor?
    var directionalLightPipelineState: MTLRenderPipelineState
    var pointLightPipelineState: MTLRenderPipelineState
    
    let depthStencilState: MTLDepthStencilState?
    
    weak var albedoTexture: MTLTexture?
    weak var normalTxture: MTLTexture?
    weak var positionTexture: MTLTexture?
    
    var icosahedron = Model(name: "icosahedron", primitiveType: .icosahedron)
    
    static func buildDepthStencilState() -> MTLDepthStencilState{
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.isDepthWriteEnabled = false
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)!
    }
    
    
    
    mutating func resize(view: MTKView, size: CGSize) {}
    
    func draw(commandBuffer: MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {return}
      
        renderEncoder.pushDebugGroup("LightingRenderPass")

        renderEncoder.label = name
        renderEncoder.setDepthStencilState(depthStencilState)
        
        renderEncoder.pushDebugGroup("Set Data")
        var uniforms = uniforms
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        renderEncoder.setFragmentTexture(albedoTexture, index: TextureIndex.albedo.rawValue)
        renderEncoder.setFragmentTexture(normalTxture, index: TextureIndex.normal.rawValue)
        renderEncoder.setFragmentTexture(positionTexture, index: TextureIndex.normal.rawValue+1)
        renderEncoder.popDebugGroup()

        //draw dir light
        //draw point light
        
        renderEncoder.popDebugGroup()
        
        renderEncoder.endEncoding()
    }
    
    func drawDirectionalLight(renderEncoder: MTLRenderCommandEncoder, scene: GameScene, params: Params){
        
        renderEncoder.pushDebugGroup("Directioanl light")
        renderEncoder.setRenderPipelineState(directionalLightPipelineState)
        var params = params
        params.lightCount = UInt32(scene.lighting.directionalLightsArray.count)
        renderEncoder.setFragmentBytes(&params, length: MemoryLayout<Params>.stride, index: BufferIndex.params.rawValue)
        renderEncoder.setFragmentBuffer(scene.lighting.directionalLightsBuffer, offset: 0, index: BufferIndex.lighting.rawValue)
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        renderEncoder.popDebugGroup()
    }
    
    func drawPointLights(renderEncoder: MTLRenderCommandEncoder, scene: GameScene, params: Params){
        renderEncoder.pushDebugGroup("PointLights")
        renderEncoder.setRenderPipelineState(pointLightPipelineState)
        renderEncoder.setVertexBuffer(scene.lighting.pointLightsBuffer, offset: 0, index: BufferIndex.lighting.rawValue)
        
        var params = params
        params.lightCount = UInt32(scene.lighting.pointLightsArray.count)
        renderEncoder.setFragmentBytes(&params, length: MemoryLayout<Params>.stride, index: BufferIndex.params.rawValue)
        
        guard let mesh = icosahedron.meshes.first,
              let submeshes = mesh.submeshes.first else {return}
        for (index, vertexBuffer) in mesh.vertexBuffers.enumerated() {
            
            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: index)
        }
        
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submeshes.indexCount, indexType: submeshes.indexType, indexBuffer: submeshes.indexBuffer, indexBufferOffset: submeshes.indexBufferOffset, instanceCount: scene.lighting.pointLightsArray.count)
        renderEncoder.popDebugGroup()
    }
}

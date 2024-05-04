//
//  LightMaskPipelieState.swift
//  AppleMetalLearn
//
//  Created by barkar on 04.05.2024.
//

import MetalKit

struct LightMaskRenderPass :RenderPass
{
    var name = "Light mask render pass"
    
    var descriptor: MTLRenderPassDescriptor?
    let depthStencilState: MTLDepthStencilState?
    var pipelineState: MTLRenderPipelineState
    
    init (view: MTKView){
        pipelineState = PipelineStates.createLightMaskPipelieState(vertexFunctionName: "vertex_light_mask", colorPixelFormat: view.colorPixelFormat)
        depthStencilState = Self.buildDepthStencilState()
    }
    
    static func buildDepthStencilState() -> MTLDepthStencilState?{
        let stencilStateDescriptor = MTLStencilDescriptor()
        stencilStateDescriptor.depthFailureOperation = .incrementClamp
        
        let descriptor = MTLDepthStencilDescriptor()
        descriptor.depthCompareFunction = .lessEqual
        descriptor.backFaceStencil = stencilStateDescriptor
        descriptor.frontFaceStencil = stencilStateDescriptor
       
        return Renderer.device.makeDepthStencilState(descriptor: descriptor)
    }
    
    mutating func resize(view: MTKView, size: CGSize) {
        
    }
    
    func draw(in view: MTKView, commandBuffer: any MTLCommandBuffer, scene: GameScene, uniforms: Uniforms, params: Params) {
        
        descriptor?.depthAttachment.loadAction = .load
        descriptor?.stencilAttachment.loadAction = .load
        
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {return}
        
        
        renderEncoder.label = name
        renderEncoder.setDepthStencilState(depthStencilState)
        renderEncoder.setRenderPipelineState(pipelineState)
        renderEncoder.setStencilReferenceValue(128)
        renderEncoder.setCullMode(.front)
        
        //TODO: ring buffer
        var uniforms = uniforms
        renderEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: BufferIndex.uniforms.rawValue)
        
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
        renderEncoder.endEncoding()
        
        
    }
    
    
}

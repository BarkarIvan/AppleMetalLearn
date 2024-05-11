
import MetalKit

struct LightingRenderPass: RenderPass
{
    let name = "Lighting Pass"
    var descriptor: MTLRenderPassDescriptor?
    
    var directionalLightPassRenderPipelineState: MTLRenderPipelineState
    var lightMaskPipelineState: MTLRenderPipelineState
    var pointLightsRenderPipelineState: MTLRenderPipelineState
    
    let directionalLightPassDepthStencilState: MTLDepthStencilState?
    let lightMaskDepthStencilState: MTLDepthStencilState?
    let pointLightsDepthStencilState: MTLDepthStencilState?
    
    weak var albedoShadowTexture: MTLTexture?
    weak var normalRoughtnessMetallicTexture: MTLTexture?
    weak var emissionTeexture: MTLTexture?
    weak var depthTexture: MTLTexture?
    
    init(view: MTKView)
    {
        descriptor = MTLRenderPassDescriptor()
        
        //create render pipeline states
        directionalLightPassRenderPipelineState = PipelineStates.createeDirectionalLightPipelineState(vertexFunctionName: "vertex_quad", fragmentFunctionName: "deffered_directional_light_traditional", colorPixelFormat: view.colorPixelFormat);
        
        directionalLightPassDepthStencilState = DepthStensilPipelineStates.buildDirectionalLightDepthStencilState()
        
        lightMaskPipelineState = PipelineStates.createLightMaskPipelieState(vertexFunctionName: "vertex_light_mask", colorPixelFormat: view.colorPixelFormat)
        lightMaskDepthStencilState = DepthStensilPipelineStates.buildLightMaskDepthStencilState()
        
        pointLightsRenderPipelineState = PipelineStates.createPointLightPipelineState(vertexFunctionName: "deferred_point_light_vertex", fragmentFunctionName: "deffered_point_light_fragment", colorPixelFormat: view.colorPixelFormat)
        pointLightsDepthStencilState = DepthStensilPipelineStates.buildPointLightsDepthStencilState()
    }
    
    
    mutating func resize(view: MTKView, size: CGSize) {}
    
    
    func draw(in view: MTKView, commandBuffer:  MTLCommandBuffer, scene: GameScene, frameData: FrameData, params: Params) {
      
        descriptor?.depthAttachment.loadAction = .load
        descriptor?.stencilAttachment.loadAction = .load
        
        //create reder encoder
        guard let descriptor = descriptor,
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else {return}
       
        renderEncoder.label = name

        //DIRECTIONAL LIGHT PASS
        renderEncoder.setDepthStencilState(directionalLightPassDepthStencilState)
        renderEncoder.setStencilReferenceValue(128)
        
        var frameData = frameData
        
        //unniforms buffer
        //TODO to buffer
        renderEncoder.setVertexBytes(&frameData, length: MemoryLayout<FrameData>.stride, index: BufferIndex.frameData.rawValue)
        renderEncoder.setFragmentBytes(&frameData, length: MemoryLayout<FrameData>.stride, index: BufferIndex.frameData.rawValue)
        
        //SET GBUFFER TEXTURES
        renderEncoder.setFragmentTexture(albedoShadowTexture, index: TextureIndex.color.rawValue)
        renderEncoder.setFragmentTexture(normalRoughtnessMetallicTexture, index: TextureIndex.additional.rawValue)
        renderEncoder.setFragmentTexture(emissionTeexture, index: TextureIndex.emission.rawValue)
        renderEncoder.setFragmentTexture(depthTexture, index: TextureIndex.depth.rawValue)
        
        renderEncoder.pushDebugGroup("Directional light Pass")
        renderEncoder.setRenderPipelineState(directionalLightPassRenderPipelineState)
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 6)
        
        renderEncoder.popDebugGroup()
        
        //LIGH MASK PASS
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
        
        ///POINT LIGHTS PASS
        renderEncoder.setRenderPipelineState(pointLightsRenderPipelineState)
        renderEncoder.setDepthStencilState(pointLightsDepthStencilState)
        renderEncoder.setStencilReferenceValue(128)
        renderEncoder.setCullMode(.back)
        
        renderEncoder.setFragmentBuffer(scene.lighting.pointsLightsBuffer, offset: 0, index: BufferIndex.lights.rawValue)

      
        renderEncoder.pushDebugGroup("Point lights Pass")
        
        guard let mesh = scene.icosahedron?.meshes.first,
              let submesh = mesh.submeshes.first 
        else{return}
     
        renderEncoder.drawIndexedPrimitives(type: .triangle, indexCount: submesh.indexCount, indexType: submesh.indexType, indexBuffer: submesh.indexBuffer, indexBufferOffset: submesh.indexBufferOffset,
                                            instanceCount: scene.lighting.pointLightsArray.count)
        
        renderEncoder.popDebugGroup()
        renderEncoder.popDebugGroup()
        
        renderEncoder.endEncoding()
        
    }
}

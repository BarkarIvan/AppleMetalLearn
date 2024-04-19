//
//  GameScene.swift
//  AppleMetalLearn
//
//  Created by barkar on 13.04.2024.
//

let maxFramesInFlight = 3

import MetalKit

struct GameScene
{
    
    var currentFramNum: Int = 0
    var currentBufferIndex: Int = 0
    var gbufferTextures = GBufferTextures()

    var shadowMap: MTLTexture
    private var uniforms = [BufferView<Uniforms>]()
    
    let shadowPojectionMatrix : simd_float4x4
    let simpleQuadVertexBuffer: BufferView<SimpleVertex>
    
    
    lazy var testModel: Model = {
        Model(name: "RubberToy.usdz")
    }()
    
    var models: [Model] = []
    var camera = FPCamera()
    
    var defaultview: Transform{
        Transform(
            position: [0, 0, 0],
            rotation: [0.0,0.0,0.0])
    }
    
    var lighting = SceneLighting()
    
    init(device: MTLDevice){
        
        camera.far = 10
        camera.transform = defaultview
        testModel.position = [0,0,-5]
        testModel.scale = [0.5,0.5,0.5]
        testModel.rotation = [0,45,45]
        models = [testModel]
        
        //to cereate Shadowm map func
        let shadowMapTextureDesciptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .depth32Float, width: 2048, height: 2048, mipmapped: false)
        shadowMapTextureDesciptor.resourceOptions = .storageModePrivate
        shadowMapTextureDesciptor.usage = [.renderTarget, .shaderRead]
        
        guard let shadowMap = device.makeTexture(descriptor: shadowMapTextureDesciptor)
        else{
            fatalError("Fail shadowMap creation \(shadowMapTextureDesciptor.description)")
        }
        shadowMap.label = "Shadow Map"
        self.shadowMap = shadowMap
        
        //to simple quad func
        let quadVertices: [SimpleVertex] = [
            .init(position: .init(x: -1, y: -1)),
            .init(position: .init(x: -1, y:  1)),
            .init(position: .init(x:  1, y: -1)),
                                           
            .init(position: .init(x:  1, y: -1)),
             .init(position: .init(x: -1, y:  1)),
            .init(position: .init(x:  1, y:  1))
             ]
        
        simpleQuadVertexBuffer = .init(device: device, array: quadVertices)
    }
    
    mutating func update(size: CGSize){
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float){
        currentFramNum += 1
        updateInput()
        camera.update(deltaTime: deltaTime)
    }
    
    mutating func updateInput(){
        let input = InputController.shared
        if input.touchPressed{
            camera.transform = Transform()
        }
    }
    
    
    
    ////
    
   
    
    
    func setGBufferTextures(renderEncoder: MTLRenderCommandEncoder)
    {
        
        renderEncoder.setFragmentTexture(gbufferTextures.albedoMetallic, index: RenderTargetIndex.albedoMetallic.rawValue)
        
        renderEncoder.setFragmentTexture(gbufferTextures.normalRoughnessShadow, index: RenderTargetIndex.nomalRoughtnessShadow.rawValue)
        
        renderEncoder.setFragmentTexture(gbufferTextures.depth, index: RenderTargetIndex.depth.rawValue)
    }
    
    func setGbufferTextures(_ renderPassDescrriptor: MTLRenderPassDescriptor)
    {
        renderPassDescrriptor.colorAttachments[RenderTargetIndex.albedoMetallic.rawValue].texture = gbufferTextures.albedoMetallic
        
        renderPassDescrriptor.colorAttachments[RenderTargetIndex.albedoMetallic.rawValue].texture = gbufferTextures.albedoMetallic
        
        renderPassDescrriptor.colorAttachments[RenderTargetIndex.nomalRoughtnessShadow.rawValue].texture = gbufferTextures.normalRoughnessShadow
        
        renderPassDescrriptor.colorAttachments[RenderTargetIndex.depth.rawValue].texture = gbufferTextures.depth
    }
    
    
    
}

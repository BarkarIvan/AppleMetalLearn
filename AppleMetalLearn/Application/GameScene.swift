//
//  GameScene.swift
//  AppleMetalLearn
//
//  Created by barkar on 13.04.2024.
//

import MetalKit

struct GameScene{
    
    //lazy var testModel: Model = {
    //  Model(name: "RubberToy.usdz")
    // }()
    
    var models: [Model] = []
    var camera = FPCamera()
    
    var defaultview: Transform{
        Transform(
            position: [0, 0, 0],
            rotation: [0.0,0.0,0.0])
    }
    
    var lighting = SceneLighting()
    //icosaherof meesh for point lights
    var icosahedron : Model?
    
    init(){
        camera.far = 10
        camera.transform = defaultview
        
        let testMaterial = MaterialController.createMaterial(materialName: "Default", albedoTextureName: "Albedo.tga", additioanTextureNamee: "NRM.png", emissionTextureName: "Emission.tga", baseColor: [1,1,1], roughtness: 1.0, metallic: 1.0, emissionColor: [1,1,1])
        
        var testModel: Model = {
            Model(name: "toy.obj", materials: [testMaterial])
        }()
        
        var platonic: Model = {
            Model(name: "platonic.obj", materials: [testMaterial])
        }()
        
        lighting.allLightsArray[0].position = [0.1,4.0,0.1]
        testModel.position = [0,0,5]
        testModel.scale = [1,1,1]
        testModel.rotation = [0,120,-45]
        
        platonic.position = testModel.position + [0,0.9,0]
        platonic.scale = [0.3, 0.3, 0.3]
        platonic.rotation = [45, 45, 45]
        models = [testModel, platonic]
        
        for _ in 1...20
        {
            let d: Float = Float(2)
            let position = simd_float3(
                .random(in: -d...d),
                .random(in: -d...d),
                .random(in: -d...d)
            )
            let color = simd_float3(
                .random(in: 0...1),
                .random(in: 0...1),
                .random(in: 0...1)
            )
            let attenuation = simd_float3(
                .random(in: 0.5...1),
                .random(in: 0.5...1),
                .random(in: 0.5...1)
            )
            
            lighting.addPointLight(position: testModel.position + position, color: color, radius: 0.5, attenuation: attenuation)
        }
        
        do {
            let bufferAllocator = MTKMeshBufferAllocator(device: Renderer.device)
            //scale coeff for unit sphere
            let unitIncribe = sqrt(3.0) / 12.0 * (3.0 + sqrt(5.0))
            let icosahedronMDLMesh = MDLMesh.newIcosahedron(withRadius: Float(1.0 / unitIncribe), inwardNormals: false, allocator: bufferAllocator)
            
            let icosahedronDescriptor = MDLVertexDescriptor()
            icosahedronDescriptor.attributes[VertexAttribute.position.rawValue] = MDLVertexAttribute(
                name: MDLVertexAttributePosition, format: .float4, offset: 0, bufferIndex: BufferIndex.meshPositions.rawValue)
            
            icosahedronDescriptor.layouts[BufferIndex.meshPositions.rawValue] = MDLVertexBufferLayout(stride: MemoryLayout<SIMD3<Float>>.stride)
            
            icosahedronMDLMesh.vertexDescriptor = icosahedronDescriptor
            
            do{
                let mtkMesh = try MTKMesh(mesh: icosahedronMDLMesh, device: Renderer.device)
                icosahedron = Model(name: "icosahedron", mdlMesh: icosahedronMDLMesh, mtkMesh: mtkMesh)
            }catch{
                fatalError("Failed to create icosahedron MTKMesh: \(error.localizedDescription)")
            }
        }
    }
    
    mutating func update(size: CGSize){
        camera.update(size: size)
    }
    
    mutating func update(deltaTime: Float){
        updateInput()
        camera.update(deltaTime: deltaTime)
    }
    
    mutating func updateInput(){
        let input = InputController.shared
        if input.touchPressed{
            camera.transform = Transform()
        }
    }
    
    
}

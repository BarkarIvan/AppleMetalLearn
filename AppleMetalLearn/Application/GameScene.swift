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
            position: [0, 2, -10],
            rotation: [degrees_to_radians(20),0.0,0.0])
    }
    
    var lighting = SceneLighting()
    //icosaherof meesh for point lights
    var icosahedron : Model?
    
    init(){
        camera.far = 30
        camera.transform = defaultview
        camera.rotation = [0.0, 0.0, 0.0]
        
        let testMaterial = MaterialController.createMaterial(materialName: "Default", albedoTextureName: "Albedo.png", additioanTextureNamee: "NRM.png", emissionTextureName: "Emission.tga", baseColor: [1,1,1], roughtness: 1.0, metallic: 1.0, emissionColor: [1,1,1])
        
        var toyModel: Model = {
            Model(name: "sphere.obj", materials: [testMaterial])
        }()
        
        var platonic: Model = {
            Model(name: "platonic.obj", materials: [testMaterial])
        }()
        
        var plane: Model = { Model(name: "plane.obj", materials: [testMaterial])}()
        
        lighting.allLightsArray[0].position = [0.1,4.0,0.1]
        toyModel.position = [0,1,0]
        toyModel.scale = [1,1,1]
        toyModel.rotation = [0,120,-45]
        
        plane.position = [0,0,0]
        plane.scale = [10,1,10]
        plane.rotation = [0,0,0]
        
        platonic.position = toyModel.position + [0,0.9,0]
        platonic.scale = [0.3, 0.3, 0.3]
        platonic.rotation = [45, 45, 45]
        models = [toyModel, platonic, plane]
        
        for _ in 1...8
        {
            let d: Float = Float(2)
            var position = simd_float3(0.0,0.0,0.0)
            let randomxz =  randomVectorInsideCircle(radius: 2)
            position.x = randomxz.x
            position.z = randomxz.y
            
            let color = simd_float3(
                .random(in: 1.0...1.0),
                .random(in: 1.0...1.0),
                .random(in: 1.0...1.0)
            )
                        
            let attenuation = simd_float3(1, 1, 20) //1 4 10
            
            
            lighting.addPointLight(position: position, color: color, attenuation: attenuation)
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
        models[0].transform.rotation.y += 1 * deltaTime
        models[0].transform.rotation.x += 0.5 * deltaTime
        models[0].transform.rotation.z += 0.5 * deltaTime
        models[1].transform.rotation.x += 1 * deltaTime
    
    }
    
    mutating func updateInput(){
        let input = InputController.shared
        if input.touchPressed{
            camera.transform = Transform()
        }
    }
    
    
}

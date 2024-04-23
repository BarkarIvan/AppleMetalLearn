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
    
    init(){
        
        camera.far = 10
        camera.transform = defaultview
        
        let testMaterial = MaterialController.createMaterial(materialName: "Default", albedoTextureName: "Albedo.tga", additioanTextureNamee: "NRM.tga", emissionTextureName: "Emission.tga", baseColor: [1,1,1], roughtness: 1.0, metallic: 1.0, emissionColor: [1,1,1])
        
        var testModel: Model = {
            Model(name: "RubberToy.usdz", materials: [testMaterial])
        }()
        
        testModel.position = [0,0,-5]
        testModel.scale = [0.5,0.5,0.5]
        testModel.rotation = [0,90,45]
        models = [testModel]
        
        
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

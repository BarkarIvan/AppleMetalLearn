//
//  GameScene.swift
//  AppleMetalLearn
//
//  Created by barkar on 13.04.2024.
//

import MetalKit

struct GameScene{
    
    lazy var testModel: Model = {
        Model(name: "testModel.usdz")
    }()
    
    var models: [Model] = []
    var camera = FPCamera()
    
    var defaultview: Transform{
        Transform(
            position: [3.2, 3.1, 1.0],
            rotation: [-0.6,10.7,0.0])
    }
    
    var lighting = SceneLighting()
    
    init(){
        
        camera.far = 10
        camera.transform = defaultview
        testModel.position = [0,0,0]
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

//
//  SceneLighting.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//

import MetalKit

class SceneLighting{
    
    static let shared  = SceneLighting()//синглтон?
    
    var allLightsArray: [Light] = []
    var directionalLightsArray: [Light] = []
    var pointLightsArray: [Light] = []
    var lightBuffer: MTLBuffer?
    var directionalLightsBuffer: MTLBuffer?
    var pointsLightsBuffer: MTLBuffer?
    
    
    init()
    {
        setupDefaultLight()
    }
    
    private func setupDefaultLight()
    {
        let directionalLight = buildDefaultLight()
        directionalLightsArray.append(directionalLight)
        allLightsArray.append(directionalLight)
        updateBuffers()
    }
    
    private func buildDefaultLight() -> Light
    {
        var light = Light()
        light.color  = [1,1,1]
        light.position = [3,3,-2]
        light.attenuation = [1,0,0]
        light.type = directionalLightType
        return light
    }
    
    func getMainLighht() -> Light
    {
        return allLightsArray[0]
    }
    
    func addPointLight(position: simd_float3, color: simd_float3, attenuation: simd_float3){
        
        var light = buildDefaultLight()
        light.position = position
        light.color = color
        light.attenuation = attenuation
        light.type = pointLightType
        
        allLightsArray.append(light)
        pointLightsArray.append(light)
        updateBuffers()
    }
    
    
    private func updateBuffers() {

        if !allLightsArray.isEmpty {
            lightBuffer = createBuffer(lightsArray: allLightsArray)
        } else {
            lightBuffer = nil
        }

        if !directionalLightsArray.isEmpty {
            directionalLightsBuffer = createBuffer(lightsArray: directionalLightsArray)
        } else {
            directionalLightsBuffer = nil
        }

        if !pointLightsArray.isEmpty {
            pointsLightsBuffer = createBuffer(lightsArray: pointLightsArray)
        } else {
            pointsLightsBuffer = nil
        }
    }

    
    
    private func createBuffer(lightsArray: [Light]) -> MTLBuffer{
        
        var lights = lightsArray
        return Renderer.device.makeBuffer(bytes: &lights, length: MemoryLayout<Light>.stride * lights.count, options: [])!
        
    }
    
}


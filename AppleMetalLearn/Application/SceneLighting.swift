//
//  SceneLighting.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//

import MetalKit

struct SceneLighting{
    
    static func buildDefaultLight() -> Light{
        var light = Light()
        light.position = [0,0,0]
        light.color = simd_float3(repeating: 1.0)
        light.attenuation = [1,0,0]
        light.type = directionalLightType
        return light
    }
    
    //default directional
    let directionalLight: Light = {
        var light = Self.buildDefaultLight()
        light.position = [0,3,-2]
        light.color = simd_float3(repeating: 1)
        return light
    }()
    
    
    var lights: [Light]
    var directionalLightsArray: [Light]
    var pointLightsArray: [Light]
    var lightBuffer: MTLBuffer
    var directionalLightsBuffer: MTLBuffer
    var pointLightsBuffer: MTLBuffer
    
    
    static func createPointLight( position: simd_float3, color: simd_float3, attenuation: simd_float3) -> Light
    {
        var light = Self.buildDefaultLight()
        light.type = pointLightType
        light.position = position
        light.color = color
        light.attenuation = attenuation
       return light
        }
    
    init(){
        directionalLightsArray = [directionalLight]
        pointLightsArray = []
        let pointLight = Self.createPointLight( position: [0,1,0], color: [1.0,1.0,1.0], attenuation: [4,4,4])
        pointLightsArray.append(pointLight)
        lights = directionalLightsArray + pointLightsArray
        lightBuffer = Self.createBuffer(lightsArray: lights)
        directionalLightsBuffer = Self.createBuffer(lightsArray: directionalLightsArray)
        pointLightsBuffer = Self.createBuffer(lightsArray: pointLightsArray)
    }
    
    //буффекр исторчников
    static func createBuffer(lightsArray: [Light]) -> MTLBuffer{
        var lights = lightsArray
        return Renderer.device.makeBuffer(bytes: &lights, length: MemoryLayout<Light>.stride * lights.count, options: [])!
        
    }
    
}


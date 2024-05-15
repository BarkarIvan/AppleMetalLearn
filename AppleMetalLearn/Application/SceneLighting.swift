//
//  SceneLighting.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//

import MetalKit



class SceneLighting{
    
    static let shared  = SceneLighting()
    
    var allLightsArray: [Light] = []
    var directionalLightsArray: [Light] = []
    var pointLightsArray: [PointLight] = []
    //var lightBuffer: MTLBuffer?
    //var directionalLightsBuffer: MTLBuffer?
    //var pointsLightsBuffer: MTLBuffer?
   
    
    
    init()
    {
        setupDefaultLight()
    }
    
    private func setupDefaultLight()
    {
        let directionalLight = buildDefaultLight()
        directionalLightsArray.append(directionalLight)
        allLightsArray.append(directionalLight)
       // updateBuffers()
    }
    
    private func buildDefaultLight() -> Light
    {
        var light = Light()
        light.color  = [1,1,1]
        light.position = [3,3,-2]
        light.attenuation = [1,0,0]
        //light.type = directionalLightType
        return light
    }
    
    func getMainLighht() -> Light
    {
        return allLightsArray[0]
    }
    
    func addPointLight(position: simd_float3, color: simd_float3)
    {
        var light = PointLight()
        light.position = position
        light.color = color
       // light.attenuation = attenuation
        light.radius = calculatePointLightRadius(color: color)
        light.constantOffset = 0.1
        print("light r = \(light.radius)")
        pointLightsArray.append(light)
    }
    
    private func calculatePointLightRadius(color: simd_float3) -> Float
    {
        let minLuminance: Float = 0.03
        let luminaceCoeffs = simd_float3(0.2126, 0.7152, 0.0722)
        let luminance = simd_dot(color, luminaceCoeffs)
        
        return sqrt(luminance / minLuminance)
    }
    
    
}


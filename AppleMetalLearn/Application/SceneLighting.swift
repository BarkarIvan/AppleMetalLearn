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
        //light.type = directionalLightType
        return light
    }
    
    func getMainLighht() -> Light
    {
        return allLightsArray[0]
    }
    
    func addPointLight(position: simd_float3, color: simd_float3, attenuation: simd_float3){
        
        var light = PointLight()
        light.position = position
        light.color = color
        light.attenuation = attenuation
        light.radius = calculatePointLightRadius(color: color, attenuation: attenuation)
        print("light r = \(light.radius)")
        pointLightsArray.append(light)
        updateBuffers()
    }
    private func calculatePointLightRadius(color: simd_float3, attenuation: simd_float3) -> Float
    {
        
        
        
        var root1: Float = 0
        let minLuminance: Float = 0.03 //todo: to config
        let luminaceCoeffs = simd_float3(0.2126, 0.7152, 0.0722)
        let luminance = simd_dot(color, luminaceCoeffs)
        
        return sqrt(luminance / minLuminance)
        let a = attenuation.z //quadr
        let b = attenuation.y //linear
        let c = attenuation.x - ( luminance / minLuminance)
       
        //TODO: to quadratic solver
        let discriminant = b * b - 4 * a * c
        if discriminant > 0 {
             root1 = (-b + sqrt(discriminant)) / (2 * a)
            let root2 = (-b + sqrt(discriminant)) / (2 * a)
            print ("d>0 \(root1) and \(root2)")
        }else if discriminant == 0{
             root1 = -b / (2 * a)
            print ("root \(root1)")
        }else{
            root1 = 0
        }
        return root1
        //return sqrt(percievedBrightnness/threshold)
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
            pointsLightsBuffer?.label = "Point lights buffer"
        } else {
            pointsLightsBuffer = nil
        }
    }

    //refactor to buffer view
    private func createBuffer(lightsArray: [Light]) -> MTLBuffer{
        
        var lights = lightsArray
        return Renderer.device.makeBuffer(bytes: &lights, length: MemoryLayout<Light>.stride * lights.count, options: [])!
        
    }
    
    private func createBuffer(lightsArray: [PointLight]) -> MTLBuffer{
        
        var lights = lightsArray
        return Renderer.device.makeBuffer(bytes: &lights, length: MemoryLayout<Light>.stride * lights.count, options: [])!
        
    }
    
}


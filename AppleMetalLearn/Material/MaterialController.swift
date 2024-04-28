//
//  MaterialController.swift
//  AppleMetalLearn
//
//  Created by barkar on 21.04.2024.
//
import MetalKit

enum MaterialController
{
    static var materials: [String:Material] = [:]
    
    static func createMaterial(materialName: String, albedoTextureName: String, additioanTextureNamee: String, emissionTextureName: String, baseColor: vector_float3, roughtness: Float, metallic: Float, emissionColor: vector_float3 ) -> Material
    {
        
        if let material = materials[materialName]{
            return material
        }
        
        let albedoTexture = TextureController.loadTexture(filename:  albedoTextureName)
        let additionnaTexture = TextureController.loadTexture(filename: additioanTextureNamee)
        let emissionTexture = TextureController.loadTexture(filename: emissionTextureName)
        
        var materialProperties = MaterialProperties();
        materialProperties.baseColor = baseColor
        materialProperties.emissionColor = emissionColor
        materialProperties.metallic = metallic
        materialProperties.roughness = metallic
        
        let material = Material(properties: materialProperties, baseColorTexture: albedoTexture, normalXYRoughMetallic: additionnaTexture, emissionTexture: emissionTexture)
        materials[materialName] = material
        
        return material
        
    }
}

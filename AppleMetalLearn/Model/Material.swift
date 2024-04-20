//
//  Material.swift
//  AppleMetalLearn
//
//  Created by barkar on 20.04.2024.
//

import MetalKit

struct Material
{
    var albedo: MTLTexture
    var normalRoughMetallic: MTLTexture
    var emission: MTLTexture
    
    init(_ mdlMaterial: MDLMaterial, textureLoader: MTKTextureLoader)
    {
        
        albedo = Material.makeTexture(from: mdlMaterial, materialSemantic: .userDefined, textureLoader: textureLoader)
        normalRoughMetallic = Material.makeTexture(from: mdlMaterial, materialSemantic: .userDefined, textureLoader: textureLoader)
        emission = Material.makeTexture(from: mdlMaterial, materialSemantic: .emission, textureLoader: textureLoader)
    }
    
    
    static private func makeTexture (from material: MDLMaterial,
                                     materialSemantic: MDLMaterialSemantic,
                                     textureLoader: MTKTextureLoader) -> MTLTexture
    {
        var newTexture: MTLTexture!
        for property in material.properties(with: materialSemantic)
        {
            let textureLoaderOptions: [MTKTextureLoader.Option: Any] =
            [.textureUsage: MTLTextureUsage.shaderRead.rawValue,
             .textureStorageMode: MTLStorageMode.private.rawValue]
            
            switch property.type 
            {
            case .string:
                if let stringValue = property.stringValue
                {
                    if let texture = try? textureLoader.newTexture(name: stringValue, scaleFactor: 1.0, bundle: nil, options: textureLoaderOptions)
                    {
                            newTexture = texture
                    }
                }
           
            case .URL:
                if let textueURL = property.urlValue
                {
                    if let texture = try? textureLoader.newTexture(URL: textueURL, options: textureLoaderOptions)
                    {
                        newTexture = texture
                    }
                }
            @unknown default:
                //whitee 1x1?
                fatalError("texture data not found")
            }
        }
        return newTexture
    }
}

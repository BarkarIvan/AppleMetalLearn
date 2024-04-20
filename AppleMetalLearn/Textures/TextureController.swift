//
//  TextureController.swift
//  AppleMetalLearn
//
//  Created by barkar on 10.04.2024.
//

import MetalKit

enum TextureController{
    static var textures: [String: MTLTexture] = [:]
    
    static func loadTexture(device: MTLDevice, texture: MDLTexture, name: String) -> MTLTexture?
    {
        if let texture = textures[name]{
            return texture
        }
        let textureLoader = MTKTextureLoader(device: device)
        let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [.origin: MTKTextureLoader.Origin.bottomLeft,
            .generateMipmaps : true]
        let texture = try? textureLoader.newTexture(texture: texture, options: textureLoaderOptions)
        textures[name] = texture
        return texture
    }
    
    
    static func loadTexture(device: MTLDevice, name: String) -> MTLTexture? {
       
        if let texture = textures[name] {
         return texture
       }
        
       let textureLoader = MTKTextureLoader(device: device)
       let texture: MTLTexture?
       texture = try? textureLoader.newTexture(
         name: name,
         scaleFactor: 1.0,
         bundle: Bundle.main,
         options: nil)
      
        if texture != nil {
         textures[name] = texture
       }
        
       return texture
     }
   }

//
//  TextureController.swift
//  AppleMetalLearn
//
//  Created by barkar on 10.04.2024.
//

import MetalKit

enum TextureController{
    static var textures: [String: MTLTexture] = [:]
    
    static func loadTexture(texture: MDLTexture, name: String) -> MTLTexture?
    {
        if let texture = textures[name]{
            return texture
        }
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [.origin: MTKTextureLoader.Origin.bottomLeft,
               .generateMipmaps : true]
        let texture = try? textureLoader.newTexture(texture: texture, options: textureLoaderOptions)
        textures[name] = texture
        return texture
    }
    
    
    static func loadTexture(name: String) -> MTLTexture? {
        if let texture = textures[name] {
            return texture
        }
        let textureLoader = MTKTextureLoader(device: Renderer.device)
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
    static func loadTexture(filename: String) -> MTLTexture?
    {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Texture \(filename) not found")
          //  return nil
        }
        return loadTexture(from: url)
    }
    
    static func loadTexture(from url: URL) -> MTLTexture?
    {
        let textureLoader = MTKTextureLoader(device: Renderer.device)
        do{
            let textureLoaderOptions: [MTKTextureLoader.Option: Any] = [.origin: MTKTextureLoader.Origin.bottomLeft, .generateMipmaps : true]
            let texture = try textureLoader.newTexture(URL: url, options: textureLoaderOptions)
            let cacheKey = url.lastPathComponent
            textures[cacheKey] = texture
            return texture
            
        }catch{
            print ("no texture")
            return nil
        }
    }
    
    
}


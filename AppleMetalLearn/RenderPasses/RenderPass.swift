//
//  RenderPass.swift
//  AppleMetalLearn
//
//  Created by barkar on 14.04.2024.
//

import MetalKit

protocol RenderPass{
    var name: String {get}
    var descriptor: MTLRenderPassDescriptor?{get set}
   
    mutating func resize(view: MTKView, size: CGSize)
    
    func draw(in view: MTKView, commandBuffer: MTLCommandBuffer, scene: GameScene, frameData: FrameData, params: Params)
    
}

extension RenderPass{
    static func makeTexture(size:CGSize, pixelFormat: MTLPixelFormat, name: String, storageMode: MTLStorageMode = .private, usage: MTLTextureUsage = [.shaderRead, .renderTarget]) -> MTLTexture?
    {
        let width = Int(size.width)
        let height = Int(size.height)
        
        guard width > 0 && height > 0 else {return nil}
        let textureDescriptorr = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: pixelFormat, width: width, height: height, mipmapped: false)
        textureDescriptorr.storageMode = storageMode
        textureDescriptorr.usage = usage
        
        guard let texture = Renderer.device.makeTexture(descriptor: textureDescriptorr) else {fatalError("Render pass texture creation failed")}
        texture.label = name
        return texture
    }
}

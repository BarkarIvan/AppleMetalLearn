//
//  TBDRenderer.swift
//  AppleMetalLearn
//
//  Created by barkar on 20.04.2024.
//

import MetalKit

class TBDRenderer: Renderer
{
    init(device: MTLDevice,
         scene: GameScene,
         renderDestinnation: RenderDestination,
         didBeginFrame: @escaping() -> Void)
    {
        super.init(device: device, scene: scene, renderDestination: renderDestinnation, isSinglePass: true, didBeginFrame: didBeginFrame)
    }
    
    
    let gBufferAndLightsPassDesctriptor: MTLRenderPassDescriptor = {
        let descriptor = MTLRenderPassDescriptor()
        //не нужен .store так как меморлесс и не гоняем по шине в системную память
        descriptor.colorAttachments[RenderTargetIndex.albedoMetallic.rawValue].storeAction = .dontCare
        descriptor.colorAttachments[RenderTargetIndex.nomalRoughtnessShadow.rawValue].storeAction = .dontCare
        descriptor.colorAttachments[RenderTargetIndex.depth.rawValue].storeAction = .dontCare
        
        return descriptor
    }()
    
}
extension TBDRenderer{
    
    // mtkView dlegate коллбек на сен уориентации девайса
    override func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
        guard let device = view.device else {
            fatalError("MTKVieew not have a MTLDevice")
        }
        
        var storageMode = MTLStorageMode.memoryless
        
        drawableSizeWillChange?(device, size, storageMode)
        setGbufferTextures(gBufferAndLightsPassDesctriptor)
        
        if view.isPaused{
            view.draw()
        }
        
    }
    
    
    override func draw(in view:MTKView)
    {
        var commandBuffer = beginFrame()
        commandBuffer.label = "Shadow commands"
        // encodeShaddowpass
        //commit
        
        commandBuffer = beginDrawableCommands()
        commandBuffer.label = "GBuffer and light commands"
        
        //финальный пасс рисуует если дравабл свободен, если нет - скип
        if let drawableTexture = view.currentDrawable?.texture
        {
            //change to lighting
            gBufferAndLightsPassDesctriptor.colorAttachments[RenderTargetIndex.albedoMetallic.rawValue].texture = drawableTexture
            gBufferAndLightsPassDesctriptor.depthAttachment.texture = view.depthStencilTexture
            gBufferAndLightsPassDesctriptor.stencilAttachment.texture = view.depthStencilTexture
            
            encodePass(into: commandBuffer, using: gBufferAndLightsPassDesctriptor, label: "GBuffer and lights")
            {
                renderEncoder in
                encodeGBufferStage(using: renderEncoder)
                //lights
            }
        }
        endFrame(commandBuffer)
        
    }
}
    


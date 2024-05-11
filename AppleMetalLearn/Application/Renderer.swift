//
//  Renderer.swift
//  AppleMetalLearn
//
//  Created by barkar on 07.04.2024.
//

import Metal
import MetalKit
import simd

// выравнивание в 64 байт
let alignedUniformsSize = (MemoryLayout<FrameData>.size + 0x3F) & -0x40

let maxFramesInFlight = 3


class Renderer: NSObject
{
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var frameData = FrameData()
    var params = Params()
    
    var shadowRenderPass: DirectionalShadowRenderPass
    var gBufferRenderPass: GBufferRenderPass
    var lightingRenderPass: LightingRenderPass

    private let inFlightSemaphore: DispatchSemaphore
    private let didFrameStart: () -> Void
    
    var shadowCamera = OrthographicCamera()
    
    init (metalView: MTKView, didFrameStart: @escaping() -> Void){
        guard
            let device = MTLCreateSystemDefaultDevice(),
            let commandQueue = device.makeCommandQueue() else {
            fatalError("No GPU available")
        }
        Self.device = device
        Self.commandQueue = commandQueue
        metalView.device = device
        
        Self.library = device.makeDefaultLibrary()
        
        shadowRenderPass = DirectionalShadowRenderPass()
        gBufferRenderPass = GBufferRenderPass(view: metalView)
        lightingRenderPass = LightingRenderPass(view: metalView)
        
        
        //max frames in flight
        inFlightSemaphore = DispatchSemaphore(value: maxFramesInFlight)
        self.didFrameStart = didFrameStart
        super.init()
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        
        params.scaleFactor = Float(UIScreen.main.scale)
    }
    
    func frameInitialCommangBuffer () -> MTLCommandBuffer
    {
        inFlightSemaphore.wait()
        guard let commandBuffer = Self.commandQueue.makeCommandBuffer()
                else
        {fatalError("Failde to create new cmd")}
        
        didFrameStart()
        return commandBuffer
    }
    
    func toDrawableCommandBuffer() -> MTLCommandBuffer
    {
        guard let commandBuffer = Self.commandQueue.makeCommandBuffer()
        else{
            fatalError("Failde to create  command buffer for drawable")
        }
        commandBuffer.addCompletedHandler{[weak self] _ in self?.inFlightSemaphore.signal()
        }
        return commandBuffer
    }
    
    
    func frameEnd (_ commandBuffer: MTLCommandBuffer, view: MTKView){
        if let drawable = view.currentDrawable {
            commandBuffer.present(drawable)
        }
        commandBuffer.commit()
    }
}



extension Renderer {
    func mtkView(
    _ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        shadowRenderPass.resize(view: view, size: size)
        gBufferRenderPass.resize(view: view, size: size)
    }
    
    
    func updateUniforms(scene: GameScene){
        
        
        frameData.viewMatrix = scene.camera.viewMatrix
        frameData.projectionMatrix = scene.camera.projectionMatrix
        frameData.projectionMatrixInverse = scene.camera.projectionMatrix.inverse
        //params.lightCount = UInt32(scene.lighting.allLightsArray.count)
        params.cameraPosition = scene.camera.position
        

        //lighting
        let directionalLight = scene.lighting.getMainLighht()
        shadowCamera = OrthographicCamera.createShadowCamera(using: scene.camera, lightPositionn: directionalLight.position)
        let shadowViewMatrix: float4x4 = float4x4(eye: shadowCamera.position, center: shadowCamera.center, up: [0,1,0])
        frameData.shadowProjectionMatrix = shadowCamera.projectionMatrix
        frameData.shadowViewMatrix = shadowViewMatrix
        frameData.mainLighWorldPos = directionalLight.position
        
    }
    
    func draw(scene: GameScene, in view: MTKView){
        //guard
            var commandBuffer = frameInitialCommangBuffer()
           
        
        commandBuffer.label = "Shadow and GBUffer Commands"
        
        updateUniforms(scene: scene)
        //shadowpass
        shadowRenderPass.draw(in: view, commandBuffer: commandBuffer, scene: scene, frameData: frameData, params: params)
      
        //gbuffer pass
        gBufferRenderPass.shadowMap = shadowRenderPass.destinationTexture
        gBufferRenderPass.draw(in: view, commandBuffer: commandBuffer, scene: scene, frameData: frameData, params: params)
        //run non non-drawable commads
        commandBuffer.commit()
        
        commandBuffer = toDrawableCommandBuffer()
        commandBuffer.label = "Lighting CommandBuffer"
        //directional light pass
        lightingRenderPass.albedoShadowTexture = gBufferRenderPass.albedoShadowTexture
        lightingRenderPass.normalRoughtnessMetallicTexture = gBufferRenderPass.normalRoughtnessTexture
        lightingRenderPass.emissionTeexture = gBufferRenderPass.emissionTexture
        lightingRenderPass.depthTexture = gBufferRenderPass.GBufferDepthTexture
        
        //ВЫНЕСТИ
        //if drawable is available
        if let drawableTexture = view.currentDrawable?.texture{
            lightingRenderPass.descriptor?.depthAttachment.texture = view.depthStencilTexture
            lightingRenderPass.descriptor?.stencilAttachment.texture = view.depthStencilTexture
            lightingRenderPass.descriptor?.colorAttachments[0].texture = drawableTexture
            lightingRenderPass.descriptor?.colorAttachments[0].loadAction = .clear
            
            
            lightingRenderPass.draw(in: view, commandBuffer: commandBuffer, scene: scene, frameData: frameData, params: params)
        }
        //present and commit cmd
        frameEnd(commandBuffer, view: view)

        
    }
    
   
    
}

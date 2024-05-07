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
let alignedUniformsSize = (MemoryLayout<Uniforms>.size + 0x3F) & -0x40

let maxBuffersInFlight = 3


class Renderer: NSObject{
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    static var library: MTLLibrary!
    
    var uniforms = Uniforms()
    var params = Params()
    
    var shadowRenderPass: DirectionalShadowRenderPass
    var gBufferRenderPass: GBufferRenderPass
    var lightingRenderPass: LightingRenderPass
   // var lightMaskReenderPass: LightMaskRenderPass
    
    var shadowCamera = OrthographicCamera()
    
    init (metalView: MTKView){
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
       // lightMaskReenderPass = LightMaskRenderPass(view: metalView)

        
        super.init()
        //set view colors
        metalView.clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1)
        metalView.depthStencilPixelFormat = .depth32Float_stencil8
        metalView.colorPixelFormat = .bgra8Unorm_srgb
        
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        
        params.scaleFactor = Float(UIScreen.main.scale)
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
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        uniforms.projectionMatrixInverse = scene.camera.projectionMatrix.inverse
        params.lightCount = UInt32(scene.lighting.allLightsArray.count)
        params.cameraPosition = scene.camera.position
        

        //lightung
        let directionalLight = scene.lighting.getMainLighht()
        shadowCamera = OrthographicCamera.createShadowCamera(using: scene.camera, lightPositionn: directionalLight.position)
        let shadowViewMatrix: float4x4 = float4x4(eye: shadowCamera.position, center: shadowCamera.center, up: [0,1,0])
        uniforms.shadowProjectionMatrix = shadowCamera.projectionMatrix
        uniforms.shadowViewMatrix = shadowViewMatrix
        uniforms.mainLighWorldPos = directionalLight.position

        //let directional = scene.lighting.lights[0]
        
    }
    
    func draw(scene: GameScene, in view: MTKView){
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor   else {return}
        
        updateUniforms(scene: scene)
        //shadowpass
        shadowRenderPass.draw(in: view, commandBuffer: commandBuffer, scene: scene, uniforms: uniforms, params: params)
        
        //gbuffer pass
        gBufferRenderPass.shadowMap = shadowRenderPass.destinationTexture
        gBufferRenderPass.draw(in: view, commandBuffer: commandBuffer, scene: scene, uniforms: uniforms, params: params)
        
        //directional light pass
        lightingRenderPass.albedoShadowTexture = gBufferRenderPass.albedoTexture
        lightingRenderPass.normalRoughtnessMetallicTexture = gBufferRenderPass.normalRoughtnessTexture
        lightingRenderPass.emissionTeexture = gBufferRenderPass.emissionTexture
        lightingRenderPass.depthTexture = gBufferRenderPass.GBufferDepthTexture
        
       // lightingRenderPass.descriptor = descriptor
        //ВЫНЕСТИ
        lightingRenderPass.descriptor?.depthAttachment.texture = view.depthStencilTexture
        lightingRenderPass.descriptor?.stencilAttachment.texture = view.depthStencilTexture
        lightingRenderPass.descriptor?.colorAttachments[0].texture = view.currentDrawable?.texture
        lightingRenderPass.descriptor?.colorAttachments[0].loadAction = .clear
        
        
        lightingRenderPass.draw(in: view, commandBuffer: commandBuffer, scene: scene, uniforms: uniforms, params: params)
        //lightmask
        //lightingRenderPass.descriptor?.colorAttachments[0].loadAction = .load
        
        //lightMaskReenderPass.descriptor = lightingRenderPass.descriptor
       // lightMaskReenderPass.draw(in: view, commandBuffer: commandBuffer, scene: scene, uniforms: uniforms, params: params)
        
        //forward transparent
        
        //opacity
        guard let drawable = view.currentDrawable else {return}
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
    
}

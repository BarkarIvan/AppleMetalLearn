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
    
   // var shadowRenderPass: Shadow
    var gBufferRenderPass: GBufferRenderPass
    
   // var shadowCamera = OrthographicCamera()
    
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
        
        gBufferRenderPass = GBufferRenderPass(view: metalView)
        
        super.init()
        metalView.clearColor = MTLClearColor(red: 0.5, green: 0.5, blue: 0.0, alpha: 1)
        metalView.depthStencilPixelFormat = .depth32Float
        
        mtkView(metalView, drawableSizeWillChange: metalView.drawableSize)
        
        params.scaleFactor = Float(UIScreen.main.scale)
    }
}

extension Renderer {
    func mtkView(
    _ view: MTKView, drawableSizeWillChange size: CGSize)
    {
        gBufferRenderPass.resize(view: view, size: size)
    }
    
    func updateUniforms(scene: GameScene){
        uniforms.viewMatrix = scene.camera.viewMatrix
        uniforms.projectionMatrix = scene.camera.projectionMatrix
        params.lightCount = 0;//UInt32(scene.lighting.lights.count)
        params.cameraPosition = scene.camera.position
        
        //TODO: shadows camera and matrices
        //let directional = scene.lighting.lights[0]
        
    }
    
    func draw(scene: GameScene, in view: MTKView){
        guard
            let commandBuffer = Self.commandQueue.makeCommandBuffer(),
            let descriptor = view.currentRenderPassDescriptor   else {return}
        
        updateUniforms(scene: scene)
        
        //shadowpass
        
        gBufferRenderPass.draw(commandBuffer: commandBuffer, scene: scene, uniforms: uniforms, params: params)
        
        //forward transparent
        
        //opacity
        guard let drawable = view.currentDrawable else {return}
        commandBuffer.present(drawable)
        commandBuffer.commit()
        
    }
    
}
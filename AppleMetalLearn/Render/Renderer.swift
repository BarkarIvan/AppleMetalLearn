//
//  Renderer.swift
//  AppleMetalLearn
//
//  Created by barkar on 07.04.2024.
//

import Metal
import MetalKit
import simd

class Renderer: NSObject{
    
    lazy var shadowRenderPassDescriptor: MTLRenderPassDescriptor = {
        let descriptor = MTLRenderPassDescriptor()
        //descriptor.depthAttachment.texture = scene.shadowMap
        descriptor.depthAttachment.storeAction = .store
        return descriptor
    }()

    
    //семафор ддля синзхронизации GPU-CPU
    private let inFlightsemaphore: DispatchSemaphore
    private let commandQueue: MTLCommandQueue
    private let didBeginFrame: () -> Void //вызывается в начале каждого кадра
    
  //  var setupGbufferTextures: (MTLRenderPassDescriptor) -> Void
    
    // If provided, this will be called at the end of every frame, and should return a drawable that will be presented.
    var GetCurrentDrawable: (()->CAMetalDrawable?)?
    
    var setGbufferTextures: (MTLRenderPassDescriptor) -> Void
    
    //исполняется если размер drawable изменился
    var drawableSizeWillChange: ((MTLDevice, CGSize, MTLStorageMode) -> Void)?
    
    var scene: GameScene
    
    var pipelineStates: PipelineStates
    var depthStencilStates: DepthStencilStates
    
    let device: MTLDevice
    
    
    init(device: MTLDevice, scene: GameScene, renderDestination: RenderDestination, isSinglePass: Bool, didBeginFrame: @escaping() -> Void){
        
        self.device = device
        self.scene = scene
        
       pipelineStates = PipelineStates(device: device, renderDestination: renderDestination, singlePass: isSinglePass)
        
        depthStencilStates = DepthStencilStates(device: device)
        
        inFlightsemaphore = DispatchSemaphore(value: 3)//maxFramesInFlight
        
        guard let commandQueue = device.makeCommandQueue()
        else
        {
            fatalError("Fail to make cmdQueue")
        }
        
        self.commandQueue = commandQueue
        self.didBeginFrame = didBeginFrame
        self.setGbufferTextures = scene.setGbufferTextures
        super.init()
        
    }
    
       //НАЧАЛО КАДРА
    //исполняем в начале кадра и ждем семафор, собираем команды для кадра
    func beginFrame() -> MTLCommandBuffer{
        
        //ждем если обрабатывается максимуум кадров
        inFlightsemaphore.wait()
        //новый cmd
        guard let commandBuffer = commandQueue.makeCommandBuffer()
        else{fatalError("New command buffer failed")}
        
        didBeginFrame()
        return commandBuffer
    }
    
    
    //подготовка кмд
    //комманды что не зависят от drawable ккодируем отдельно
    //для того чтобы начатть выполнение пердыдущего кмд до того как drawable освободится
    func beginDrawableCommands() -> MTLCommandBuffer
    {
        guard let commandBuffer = commandQueue.makeCommandBuffer()
        else{fatalError("failed command bufferr")}
        //хендлер завершения который говорит семфору что буффры для этого кадра больше не нужнны
        commandBuffer.addCompletedHandler{[weak self] _ in self?.inFlightsemaphore.signal()
        }
        return commandBuffer
    }
         
    
    //выполняем завершение кадра  вкключая выыод дравабл на экран  и коммит комманд буфера
    func endFrame(_ commandBuffer: MTLCommandBuffer)
    {
        if let drawablee = GetCurrentDrawable?()
        {
            commandBuffer.present(drawablee)
        }
        commandBuffer.commit()
    }
    
    
    //шаблоны "стратегий"
    func encodePass(into commandBuffer: MTLCommandBuffer,
                    using descriptor: MTLRenderPassDescriptor,
                    label: String,
                    _ encodingBlock:(MTLRenderCommandEncoder) -> Void)
    {
        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else{
            fatalError("Failed make commands \(descriptor.description)")
        }
    }
    
    
    func encodeStange(using renderEncoder: MTLRenderCommandEncoder,
                      label: String,
                      _ eencodingBlock: () -> Void)
    {
        renderEncoder.pushDebugGroup(label)
        eencodingBlock()
        renderEncoder.popDebugGroup()
    }
    
    
    func encodeGBufferStage(using renderEncoder: MTLRenderCommandEncoder)
    {
        encodeStange(using: renderEncoder, label: "GBuffer Stag")
        {
            renderEncoder.setRenderPipelineState(pipelineStates.gBufferGeneration)
            renderEncoder.setDepthStencilState(depthStencilStates.gBuffergeneration)
            renderEncoder.setCullMode(.back)
            renderEncoder.setStencilReferenceValue(128)
            renderEncoder.setVertexBuffer(scene.fd, offset: 0, index: BufferIndex.frameData.rawValue)
            renderEncoder.setFragmentBuffer(<#T##buffer: (any MTLBuffer)?##(any MTLBuffer)?#>, offset: <#T##Int#>, index: <#T##Int#>)
            renderEncoder.setFragmentTexture(scene.shadowMap, index: TextureIndex.shadow.rawValue)
        }
    }
    
}

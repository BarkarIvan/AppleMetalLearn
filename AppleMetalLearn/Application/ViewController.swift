import MetalKit

class ViewController: UIViewController
{
    var renderView: MTKView!
    var renderer: Renderer!
    var scene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let device = MTLCreateSystemDefaultDevice() else
        {fatalError("Error to create system device")}
        
        renderView = MTKView(frame: view.frame, device: device)
        renderView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(renderView)
        
        NSLayoutConstraint.activate([
            renderView.topAnchor.constraint(equalTo: view.topAnchor),
            renderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            renderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            renderView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        renderView.depthStencilPixelFormat = .depth32Float_stencil8
        renderView.colorPixelFormat = .bgra8Unorm_srgb
        scene = GameScene(device: device)
        
        renderer = TBDRenderer(device: device, scene: scene, renderDestinnation: renderView)
        {
            [weak self] in
            guard let strongSelf = self else {return}
            
            if !strongSelf.renderView.isPaused
            {
                strongSelf.scene.update(deltaTime: 0)
                //update input
            }
        }
        
        renderer.GetCurrentDrawable = {
            [weak self] in
            self?.renderView.currentDrawable
        }
        
        renderer.drawableSizeWillChange = drawableSizeWillChange
        renderer.mtkView(renderView, drawableSizeWillChange: renderView.drawableSize)
        
        // The renderer serves as the MTKViewDelegate.
        renderView.delegate = renderer
    }
    
    var drawableSizeWillChange: ((MTLDevice, CGSize, MTLStorageMode) -> Void) { { [weak self] device, size, gBufferStorageMode in
            self?.scene.camera.update(size: size)
        
            // Re-create GBuffer textures to match the new drawable size.
            self?.scene.gbufferTextures.makeTextures(device: device, size: size, storageMode: gBufferStorageMode)
        }
    }
    
    

}



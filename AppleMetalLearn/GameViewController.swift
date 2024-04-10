//
//  GameViewController.swift
//  AppleMetalLearn
//
//  Created by barkar on 07.04.2024.
//

import UIKit
import MetalKit

class GameViewController: UIViewController{
    
    var renderer: Renderer!
    var mtkView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mtkView = view as? MTKView else{
            print("View of GameViewController is not an TKView")
            return
        }
        
        guard let defaultMTDevice = MTLCreateSystemDefaultDevice() else{
            print ("Metal not supported")
            return
        }
        
        mtkView.device = defaultMTDevice;
        mtkView.backgroundColor = UIColor.black;
        
        guard let newRenderer = Renderer(metalKitView: mtkView)else{
            print("Renderer not init")
            return
        }
        
        renderer = newRenderer
        renderer.mtkView(mtkView, drawableSizeWillChange: mtkView.drawableSize)
        mtkView.delegate = renderer
    }
}

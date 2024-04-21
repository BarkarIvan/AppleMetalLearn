//
//  Material.swift
//  AppleMetalLearn
//
//  Created by barkar on 21.04.2024.
//

import Foundation
import Metal

struct Material {
    var properties: MaterialProperties
    var baseColorTexture: MTLTexture?
    var normalXYRoughMetallic: MTLTexture?
    var emissionTexture: MTLTexture?
}

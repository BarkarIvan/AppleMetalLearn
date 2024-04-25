//
//  Lighting.h
//  AppleMetalLearn
//
//  Created by barkar on 25.04.2024.
//

#ifndef Lighting_h
#define Lighting_h
#import "ShaderTypes.h"

float calculateShadow (float4 shadowCoord, depth2d<float> shadowMap);


#endif /* Lighting_h */

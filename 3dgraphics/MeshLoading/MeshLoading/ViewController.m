//
//  ViewController.m
//  MeshLoading
//
//  Created by Jon Manning on 10/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "ViewController.h"
#import "GameObject.h"
#import "Camera.h"
#import "Mesh.h"
#import "Transform.h"
#import "MeshRenderer.h"
#import "Animation.h"

@interface ViewController () {
    Camera* mainCamera;
    
    NSMutableArray* _gameObjects;
}

@end

@implementation ViewController

- (GameObject*) makeCamera {
    GameObject* newCameraObject = [[GameObject alloc] init];
    Camera* camera = [[Camera alloc] init];
    camera.fieldOfView = GLKMathDegreesToRadians(90);
    camera.nearClippingPlane = 0.1;
    camera.farClippingPlane = 100.0;
    newCameraObject.transform.localPosition = GLKVector3Make(0, 0, 0);
    camera.clearColor = GLKVector4Make(1, 1, 1, 1);
    [newCameraObject addComponent:camera];
    return newCameraObject;
}

- (GameObject*) makeBox {
    GameObject* newBoxObject = [[GameObject alloc] init];
    
    NSError* error = nil;
    NSURL* url = [[NSBundle mainBundle] URLForResource:@"Box" withExtension:@"mesh"];
    Mesh* mesh = [Mesh meshWithContentsOfURL:url error:&error];
    
    if (error) {
        return nil;
    }
    
    MeshRenderer* renderer = [[MeshRenderer alloc] init];
    renderer.mesh = mesh;
    [newBoxObject addComponent:renderer];
    
    newBoxObject.transform.localPosition = GLKVector3Make(0, 0, 1);
    
    return newBoxObject;
    
}

- (void) createScene {
    
    // Create the camera object
    GameObject* cameraObject = [self makeCamera];
    mainCamera = cameraObject.camera;
    cameraObject.transform.localPosition = GLKVector3Make(0, 0, 6);
    [_gameObjects addObject:cameraObject];
    
    // Create the box
    GameObject* childBox = [self makeBox];
    
    NSError* error = nil;
    childBox.meshRenderer.effect = [Material effectWithVertexShaderNamed:@"DiffuseTextureVertexShader" fragmentShaderNamed:@"DiffuseTextureFragmentShader" error:&error];
    
    NSURL* textureURL = [[NSBundle mainBundle] URLForResource:@"Transparency" withExtension:@"png"];
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfURL:textureURL options:nil error:nil];
    
    childBox.meshRenderer.effect.texture2d0.enabled = YES;
    childBox.meshRenderer.effect.texture2d0.name = texture.name;
    
    childBox.meshRenderer.effect.light0.enabled = YES;
    childBox.meshRenderer.effect.light0.position = GLKVector4Make(5, 0, 0, 0);
    childBox.meshRenderer.effect.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    childBox.meshRenderer.effect.lightModelAmbientColor = GLKVector4Make(0.3, 0.3, 0.3, 1);
    
    childBox.transform.localPosition = GLKVector3Make(0, 5, 0);
    
    //[_gameObjects addObject:childBox];
    
    GameObject* parentBox = [self makeBox];
    [parentBox.transform addChild:childBox.transform];
    parentBox.transform.localPosition = GLKVector3Make(0, 0,
                                                       10);
    parentBox.meshRenderer.effect = [Material effectWithVertexShaderNamed:@"NormalMapVertexShader" fragmentShaderNamed:@"ToonFragmentShader" error:&error];
    
    NSURL* diffuseMapTextureURL = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"png"];
    NSURL* normalMapTextureURL = [[NSBundle mainBundle] URLForResource:@"ExampleNormal" withExtension:@"png"];
    GLKTextureInfo* diffuseMapTexture = [GLKTextureLoader textureWithContentsOfURL:diffuseMapTextureURL options:nil error:nil];
    GLKTextureInfo* normalMapTexture = [GLKTextureLoader textureWithContentsOfURL:normalMapTextureURL options:nil error:nil];
    parentBox.meshRenderer.effect.texture2d0.enabled = YES;
    parentBox.meshRenderer.effect.texture2d0.name = diffuseMapTexture.name;
    
    parentBox.meshRenderer.effect.texture2d1.enabled = YES;
    parentBox.meshRenderer.effect.texture2d1.name = normalMapTexture.name;
    
    parentBox.meshRenderer.effect.light0.enabled = YES;
    parentBox.meshRenderer.effect.light0.position = GLKVector4Make(5, 0, 0, 0);
    parentBox.meshRenderer.effect.light0.diffuseColor = GLKVector4Make(1.0, 1.0, 1.0, 1.0);
    parentBox.meshRenderer.effect.lightModelAmbientColor = GLKVector4Make(0.0, 0.0, 0.0, 1);
    
    
    [_gameObjects addObject:parentBox];
    
    
    Animation* bounceScale = [[Animation alloc] initWithAnimationBlock:^(GameObject *object, float t) {
        
        t = 2*M_PI*t;
        float scale = fabsf(sinf(t));
        
        object.transform.localScale = GLKVector3Make(scale, scale, scale);
    }];
    
    [bounceScale startAnimating];
    [childBox addComponent:bounceScale];
    
    Animation* rotate = [[Animation alloc] initWithAnimationBlock:^(GameObject *object, float t) {
        float angle = 2*M_PI*t;
        
        object.transform.localRotation = GLKVector3Make(0, angle, 0);
        
    }];
    
    rotate.duration = 100;
    
    [rotate startAnimating];
    [parentBox addComponent:rotate];
    
    // Move from original position to a position 5 units higher
    GLKVector3 originalPosition = cameraObject.transform.localPosition;
    GLKVector3 destinationPosition = GLKVector3Add(originalPosition, GLKVector3Make(0, 5, 0));
    Animation* moveUpDown = [[Animation alloc] initWithAnimationBlock:^(GameObject *object, float t) {
        
        object.transform.localPosition = GLKVector3Lerp(originalPosition, destinationPosition, t);
        
    }];
    
    [moveUpDown startAnimating];
    
    //[cameraObject addComponent:moveUpDown];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GLKView* view = (GLKView*)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:view.context];

    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    glEnable(GL_DEPTH_TEST);
    
    // Create the list of game objects
    _gameObjects = [NSMutableArray array];
    
    [self createScene];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) update {
    
    float deltaTime = self.timeSinceLastUpdate;
    
    for (GameObject* object in _gameObjects) {
        [object update:deltaTime];
    }
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [mainCamera prepareToDraw];

    for (GameObject* object in _gameObjects) {
        if (object.meshRenderer) {
            [object.meshRenderer renderWithCamera:mainCamera];
        }
    }
}


@end

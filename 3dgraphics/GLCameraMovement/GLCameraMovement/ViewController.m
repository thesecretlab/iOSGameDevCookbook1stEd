//
//  ViewController.m
//  GLCameraMovement
//
//  Created by Jon Manning on 08/05/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

const float dragSpeed = 1.0f / 120.0f;

typedef struct {
    GLKVector3 position; // the location of each vertex in space
    GLKVector2 textureCoordinates; // the texture coordinates for each vertex
} Vertex;

const Vertex CubeVertices[] = {
    {{-1, -1, 1}, {0,0}}, // bottom left front
    {{1, -1, 1}, {1,0}},  // bottom right front
    {{1, 1, 1}, {1,1}},   // top right front
    {{-1, 1, 1}, {0,1}},  // top left front
    
    {{-1, -1, -1}, {1,0}}, // bottom left back
    {{1, -1, -1}, {0,0}},  // bottom right back
    {{1, 1, -1}, {0,1}},   // top right back
    {{-1, 1, -1}, {1,1}},  // top left back
};

const GLubyte CubeTriangles[] = {
    0, 1, 2, // front face 1
    2, 3, 0, // front face 2
    
    4, 5, 6, // back face 1
    6, 7, 4, // back face 2
    
    7, 4, 0, // left face 1
    0, 3, 7, // left face 2
    
    2, 1, 5,   // right face 1
    5, 6, 2,   // right face 2
    
    7, 3, 6, // top face 1
    6, 2, 3, // top face 2
    
    4, 0, 5, // bottom face 1
    5, 1, 0, // bottom face 2
};

@interface ViewController () {
    GLuint _vertexBuffer; // contains the collection of vertices used to describe position of each corner
    GLuint _indexBuffer;  // indicates which vertices should be used in each triangle used to make up the square
    
    GLKBaseEffect* _squareEffect; // describes how the square is going to be rendered
    
    float rotation;
    
    GLKVector3 _cameraPosition;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    GLKView* view = (GLKView*)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [EAGLContext setCurrentContext:view.context];
    
    // Objects that are drawn should not cover up things that are in front of them.
    // Use a depth buffer to store depth information...
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    // ...and make OpenGL refer to it when drawing.
    glEnable(GL_DEPTH_TEST);
    
    // Create the vertex array buffer, in which OpenGL will store the vertices
    
    // OpenGL, give me a buffer
    glGenBuffers(1, &_vertexBuffer);
    
    // Make this buffer be the active array buffer
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    // Put this data into the active array buffer. It's as big as the 'SquareVertices' array,
    // use the data from that array; also, this data isn't going to change
    glBufferData(GL_ARRAY_BUFFER, sizeof(CubeVertices), CubeVertices, GL_STATIC_DRAW);
    
    
    // Now do the same thing for the index buffer, which indicates which vertices
    // to use when drawing the triangles
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(CubeTriangles), CubeTriangles, GL_STATIC_DRAW);
    
    // Prepare the GL effect, which is used to tell OpenGL how to draw our triangle
    _squareEffect = [[GLKBaseEffect alloc] init];
    
    // First, we set up the projection matrix
    float aspectRatio = self.view.bounds.size.width / self.view.bounds.size.height;
    float fieldOfViewDegrees = 60.0;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fieldOfViewDegrees), aspectRatio, 0.1, 10.0);
    _squareEffect.transform.projectionMatrix = projectionMatrix;
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"Texture" ofType:@"png"];
    NSError* error = nil;
    
    GLKTextureInfo* texture = [GLKTextureLoader textureWithContentsOfFile:imagePath options:nil error:&error];
    
    if (error != nil) {
        NSLog(@"Problem loading texture: %@", error);
    }
    
    _squareEffect.texture2d0.name = texture.name;
    
    UIPanGestureRecognizer* pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self.view addGestureRecognizer:pan];
    
    _cameraPosition.z = -6;
}

- (void) dragged:(UIPanGestureRecognizer*)pan {
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [pan translationInView:pan.view];
        _cameraPosition.x += translation.x * dragSpeed;
        _cameraPosition.y -= translation.y * dragSpeed;
        
        [pan setTranslation:CGPointZero inView:pan.view];
    }
}

- (void) update {
    
    // Find out how much time has passed since the last update
    NSTimeInterval timeInterval = self.timeSinceLastUpdate;
    
    // We want to rotate at 15 degrees per second, so multiply
    // this amount times the time since the last update and
    // update the 'rotation' variable.
    float rotationSpeed = 15 * timeInterval;
    rotation += rotationSpeed;
    
    // Now construct a model view matrix that places the object 6 units away from the camera and
    // rotates it appropriately
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(_cameraPosition.x, _cameraPosition.y, _cameraPosition.z);
    
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(rotation));
    
    // Apply this to the effect so that the drawing will use this positioning
    _squareEffect.transform.modelviewMatrix = modelViewMatrix;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    // Erase the view by filling it with black
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // Tell the effect that it should prepare OpenGL to draw using the
    // settings we've configured it with
    [_squareEffect prepareToDraw];
    
    
    // OpenGL already knows that the vertex array (GL_ARRAY_BUFFER) contains vertex data.
    // We now tell it how to find useful info in that array.
    
    // OK, OpenGL, here's how the data is laid out for the position of each vertex in the vertex array.
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), offsetof(Vertex, position));
    
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, textureCoordinates));
    
    
    // Now that OpenGL knows where to find vertex positions, it can draw them.
    int numberOfVertices = sizeof(CubeTriangles)/sizeof(CubeTriangles[0]);
    glDrawElements(GL_TRIANGLES, numberOfVertices, GL_UNSIGNED_BYTE, 0);
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

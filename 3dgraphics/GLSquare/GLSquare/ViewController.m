//
//  ViewController.m
//  GLSquare
//
//  Created by Jon Manning on 25/04/13.
//  Copyright (c) 2013 Secret Lab. All rights reserved.
//

#import "ViewController.h"

typedef struct {
    GLKVector3 position;
} Vertex;

const Vertex SquareVertices[] = {
    {-1, -1 , 0}, // bottom left
    {1, -1 , 0},  // bottom right
    {1, 1 , 0},   // top right
    {-1, 1 , 0},  // top left
};

const GLubyte SquareTriangles[] = {
    0, 1, 2, // BL -> BR -> TR
    2, 3, 0  // TR -> TL -> BL
};

@interface ViewController () {
    GLuint _vertexBuffer; // contains the collection of vertices used to describe position of each corner
    GLuint _indexBuffer;  // indicates which vertices should be used in each triangle used to make up the square
    
    GLKBaseEffect* _squareEffect; // describes how the square is going to be rendered
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
    
    // Create the vertex array buffer, in which OpenGL will store the vertices
    
    // OpenGL, give me a buffer
    glGenBuffers(1, &_vertexBuffer);
    
    // Make this buffer be the active array buffer
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    
    // Put this data into the active array buffer. It's as big as the 'SquareVertices' array,
    // use the data from that array; also, this data isn't going to change
    glBufferData(GL_ARRAY_BUFFER, sizeof(SquareVertices), SquareVertices, GL_STATIC_DRAW);
    
    
    // Now do the same thing for the index buffer, which indicates which vertices
    // to use when drawing the triangles
    glGenBuffers(1, &_indexBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(SquareTriangles), SquareTriangles, GL_STATIC_DRAW);
    
    // Prepare the GL effect, which is used to tell OpenGL how to draw our triangle
    _squareEffect = [[GLKBaseEffect alloc] init];
    
    // First, we set up the projection matrix
    float aspectRatio = self.view.bounds.size.width / self.view.bounds.size.height;
    float fieldOfViewDegrees = 60.0;
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(fieldOfViewDegrees), aspectRatio, 0.1, 10.0);
    _squareEffect.transform.projectionMatrix = projectionMatrix;
    
    // Next, we describe how the square should be positioned (6 units away from the camera)
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -6.0f);
    _squareEffect.transform.modelviewMatrix = modelViewMatrix;
    
    // Tell the effect that it should colour everything with a single colour (in this case, red)
    _squareEffect.useConstantColor = YES;
    _squareEffect.constantColor = GLKVector4Make(1.0, 0.0, 0.0, 1.0);

}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    
    // Erase the view by filling it with black
    glClearColor(0.0, 0.0, 0.0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Tell the effect that it should prepare OpenGL to draw using the
    // settings we've configured it with
    [_squareEffect prepareToDraw];
    
    
    // OpenGL already knows that the vertex array (GL_ARRAY_BUFFER) contains vertex data.
    // We now tell it how to find useful info in that array.
    
    // OK, OpenGL, here's how the data is laid out for the position of each vertex in the vertex array.
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 0, 0);
    
    // Now that OpenGL knows where to find vertex positions, it can draw them.
    int numberOfVertices = sizeof(SquareTriangles)/sizeof(SquareTriangles[0]);
    glDrawElements(GL_TRIANGLES, numberOfVertices, GL_UNSIGNED_BYTE, 0);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

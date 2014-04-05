//
//  Material.m
//  MeshLoading
//
//  Created by Jon Manning on 11/11/2013.
//  Copyright (c) 2013 Jon Manning. All rights reserved.
//

#import "Material.h"

@interface Material () {
    // References to the shaders and the program
    GLuint _vertexShader;
    GLuint _fragmentShader;
    GLuint _shaderProgram;
    
    // Uniform locations:
    
    // Matrices, for converting points into different coordinate spaces
    GLuint _modelViewMatrixLocation;
    GLuint _projectionMatrixLocation;
    GLuint _normalMatrixLocation;
    
    // Textures, for getting texture info
    GLuint _texture0Location;
    GLuint _texture1Location;
    
    // Light information
    GLuint _lightPositionLocation;
    GLuint _lightColorLocation;
    GLuint _ambientLightColorLocation;
}

// Where to find the shader files
@property (strong) NSURL* vertexShaderURL;
@property (strong) NSURL* fragmentShaderURL;

@end

@implementation Material

// Creates a material by looking for a pair of named shaders.
+ (Material*)effectWithVertexShaderNamed:(NSString*)vertexShaderName fragmentShaderNamed:(NSString*)fragmentShaderName error:(NSError**)error {
    
    NSURL* fragmentShaderURL = [[NSBundle mainBundle] URLForResource:fragmentShaderName withExtension:@"fsh"];
    NSURL* vertexShaderURL = [[NSBundle mainBundle] URLForResource:vertexShaderName withExtension:@"vsh"];
    
    return [Material effectWithVertexShader:vertexShaderURL fragmentShader:fragmentShaderURL error:error];
}

// Creates a material by loading shaders from the provided URLs. Returns nil if the shaders can't be loaded.
+ (Material*)effectWithVertexShader:(NSURL *)vertexShaderURL fragmentShader:(NSURL *)fragmentShaderURL error:(NSError**)error {
    
    Material* material = [[Material alloc] init];
    material.vertexShaderURL = vertexShaderURL;
    material.fragmentShaderURL = fragmentShaderURL;
    
    if ([material prepareShaderProgramWithError:error] == NO)
        return nil;
    
    return material;
    
}

// Called when the shader is about to be used
- (void)prepareToDraw {
    // Select the program
    glUseProgram(_shaderProgram);
    
    // Give the model-view matrix to the shader
    glUniformMatrix4fv(_modelViewMatrixLocation, 1, GL_FALSE, self.transform.modelviewMatrix.m);
    
    // Also give the projection matrix
    glUniformMatrix4fv(_projectionMatrixLocation, 1, GL_FALSE, self.transform.projectionMatrix.m);
    
    // Provide the normal matrix to the shader, too
    glUniformMatrix3fv(_normalMatrixLocation, 1, GL_FALSE, self.transform.normalMatrix.m);
    
    // If texture 0 is enabled, tell the shader where to find it
    if (self.texture2d0.enabled) {
        // "OpenGL, I'm now talking about texture 0."
        glActiveTexture(GL_TEXTURE0);
        // "Make texture 0 use the texture data that's referred to by self.texture2d0.name."
        glBindTexture(GL_TEXTURE_2D, self.texture2d0.name);
        // "Finally, tell the shader that the uniform variable "texture0" refers to texture 0.
        glUniform1i(_texture0Location, 0);
    }
    
    // Likewise with texture 1
    if (self.texture2d1.enabled) {
        glActiveTexture(GL_TEXTURE1);
        glBindTexture(GL_TEXTURE_2D, self.texture2d1.name);
        glUniform1i(_texture1Location, 1);
    }
    
    // Pass light information into the shader, if it's enabled
    if (self.light0.enabled) {
        glUniform3fv(_lightPositionLocation, 1, self.light0.position.v);
        glUniform4fv(_lightColorLocation, 1, self.light0.diffuseColor.v);
        glUniform4fv(_ambientLightColorLocation, 1, self.lightModelAmbientColor.v);
    }
    
    // With this set, fragments with an alpha of less than 1 will be semi-transparent
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glBlendEquation(GL_ADD);
        
}

// Returns YES if the shader compiled correctly, NO if it didn't (and puts an NSError in 'error')
- (BOOL)shaderIsCompiled:(GLuint)shader error:(NSError**)error {
    
    // Ask OpenGL if the shader compiled correctly
    int success;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &success);
    
    // If not, find out why and send back an NSError object
    if (success == 0) {
        
        if (error != nil) {
            char errorLog[1024];
            glGetShaderInfoLog(shader, sizeof(errorLog), NULL, errorLog);
            NSString* errorString = [NSString stringWithCString:errorLog encoding:NSUTF8StringEncoding];
            
            *error = [NSError errorWithDomain:@"Material" code:NSFileReadCorruptFileError userInfo:@{@"Log":errorString}];
        }
        
        return NO;
    }
    
    return YES;
}

// Returns YES if the program linked successfully, NO if it didn't (and puts an NSError in 'error')
- (BOOL) programIsLinked:(GLuint)program error:(NSError**)error {
    
    // Ask OpenGL if the program has been successfully linked.
    int success;
    glGetProgramiv(program, GL_LINK_STATUS, &success);
    
    // If not, find out why and send back an NSError
    if (success == 0) {
        if (error != nil) {
            char errorLog[1024];
            glGetProgramInfoLog(program, sizeof(errorLog), NULL, errorLog);
            NSString* errorString = [NSString stringWithCString:errorLog encoding:NSUTF8StringEncoding];
            
            *error = [NSError errorWithDomain:@"Material" code:NSFileReadCorruptFileError userInfo:@{NSUnderlyingErrorKey:errorString}];
        }
        return NO;
    }
    
    return YES;
}

// Loads and prepares the shaders. Returns YES if it succeeded, NO if otherwise.
- (BOOL)prepareShaderProgramWithError:(NSError**)error {
    
    // Load the source code to the vertex and fragment shaders
    NSString* vertexShaderSource = [NSString stringWithContentsOfURL:self.vertexShaderURL encoding:NSUTF8StringEncoding error:error];
    if (vertexShaderSource == nil)
        return NO;
    
    NSString* fragmentShaderSource = [NSString stringWithContentsOfURL:self.fragmentShaderURL encoding:NSUTF8StringEncoding error:error];
    if (fragmentShaderSource == nil)
        return NO;
    
    // Create and compile the vertex shader
    _vertexShader = glCreateShader(GL_VERTEX_SHADER);
    const char* vertexShaderSourceString = [vertexShaderSource cStringUsingEncoding:NSUTF8StringEncoding];
    
    glShaderSource(_vertexShader, 1, &vertexShaderSourceString, NULL);
    glCompileShader(_vertexShader);
    
    if ([self shaderIsCompiled:_vertexShader error:error] == NO)
        return NO;
    
    // Create and compile the fragment shader
    _fragmentShader = glCreateShader(GL_FRAGMENT_SHADER);
    const char* fragmentShaderSourceString = [fragmentShaderSource cStringUsingEncoding:NSUTF8StringEncoding];
    
    glShaderSource(_fragmentShader, 1, &fragmentShaderSourceString, NULL);
    glCompileShader(_fragmentShader);
    
    if ([self shaderIsCompiled:_fragmentShader error:error] == NO)
        return NO;
    
    // Both of the shaders are now compiled, so we can link them together and form a program
    _shaderProgram = glCreateProgram();
    glAttachShader(_shaderProgram, _vertexShader);
    glAttachShader(_shaderProgram, _fragmentShader);
    
    // First, we tell OpenGL what index number we want the various attributes to be called.
    // This allows us to tell OpenGL about where to find vertex attribute data.
    glBindAttribLocation(_shaderProgram, MaterialAttributePosition, "position");
    glBindAttribLocation(_shaderProgram, MaterialAttributeColor, "color");
    glBindAttribLocation(_shaderProgram, MaterialAttributeNormal, "normal");
    glBindAttribLocation(_shaderProgram, MaterialAttributeTextureCoordinates, "texcoords");
    
    // Now that we've told OpenGL how we want to refer to each attribute, we link the program
    glLinkProgram(_shaderProgram);
    
    if ([self programIsLinked:_shaderProgram error:error] == NO)
        return NO;
    
    // Get the location of where the uniforms are located
    _modelViewMatrixLocation  = glGetUniformLocation(_shaderProgram, "modelViewMatrix");
    _projectionMatrixLocation = glGetUniformLocation(_shaderProgram, "projectionMatrix");
    _normalMatrixLocation = glGetUniformLocation(_shaderProgram, "normalMatrix");
    
    _texture0Location = glGetUniformLocation(_shaderProgram, "texture0");
    _texture1Location = glGetUniformLocation(_shaderProgram, "texture1");
    
    _lightPositionLocation = glGetUniformLocation(_shaderProgram, "lightPosition");
    _lightColorLocation = glGetUniformLocation(_shaderProgram, "lightColor");
    _ambientLightColorLocation = glGetUniformLocation(_shaderProgram, "ambientLightColor");
    
    return YES;
    
}

// Delete the program and shaders, to free up resources
- (void)dealloc {
    glDeleteProgram(_shaderProgram);
    glDeleteShader(_fragmentShader);
    glDeleteShader(_vertexShader);
}

@end

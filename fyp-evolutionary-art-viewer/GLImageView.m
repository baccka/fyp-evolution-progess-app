
#import "GLImageView.h"
#import "geneticArtist.h"

#import <OpenCL/OpenCL.h>
#import <OpenGL/gl.h>

NSOpenGLPixelFormat *getGLPixelFormat() {
    NSOpenGLPixelFormatAttribute attributes[] = {
        NSOpenGLPFAAccelerated,
        NSOpenGLPFADepthSize, 24,
        NSOpenGLPFAOpenGLProfile, NSOpenGLProfileVersionLegacy,
        NSOpenGLPFAColorSize, 24,
        NSOpenGLPFADoubleBuffer,
        NSOpenGLPFAAlphaSize, 8,
        NSOpenGLPFAAllowOfflineRenderers,
        0
    };
    
    return [[NSOpenGLPixelFormat alloc] initWithAttributes:attributes];
}

@implementation GLImageView {
    BOOL _hasTexture;
    GLuint _texture;
}

- (instancetype)initWithFrame:(NSRect)frameRect pixelFormat:(NSOpenGLPixelFormat *)format {
    if (!(self = [super initWithFrame:frameRect pixelFormat:format]))
        return nil;
    
    return self;
}

- (GLuint)allocateTextureWithData:(const float *)data size:(int)size {
    [self _deleteTexture];
    glEnable(GL_TEXTURE_2D);
    glGenTextures(1, &_texture);

    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, size, size, 0, GL_RGBA, GL_FLOAT, data);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
    glTexParameteri (GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    
    _hasTexture = YES;
    
    [self display];
    
    return _texture;
}

- (void)_deleteTexture {
    if (!_hasTexture)
        return;
    
    glDeleteTextures(1, &_texture);
    
    _texture = 0;
    _hasTexture = NO;
}

- (void)clear {
    [self _deleteTexture];
    [self display];
}

- (void)reshape {
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    glEnable(GL_TEXTURE_2D);
    glDisable(GL_DEPTH_TEST);
    glShadeModel(GL_SMOOTH);
    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    NSRect rect = self.frame;
    glViewport(0, 0, rect.size.width, rect.size.height);
    glOrtho(0.0f, 512.0f, 512.0f, 0.0f, 0.0f, 1.0f);
}

- (void)drawRect:(NSRect)dirtyRect {
    glClear(GL_COLOR_BUFFER_BIT);
    
    if (!_hasTexture) {
        glFlush();
        return;
    }
    
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(GL_TEXTURE_2D, _texture);
    
    glBegin(GL_QUADS);
    {
        glTexCoord2f(0.0f, 0.0f); glVertex3f(0.0f,   0.0f,   0.0f);
        glTexCoord2f(1.0f, 0.0f); glVertex3f(512.0f, 0.0f,   0.0f);
        glTexCoord2f(1.0f, 1.0f); glVertex3f(512.0f, 512.0f, 0.0f);
        glTexCoord2f(0.0f, 1.0f); glVertex3f(0.0f,   512.0f, 0.0f);
    }
    glEnd();
    
    glFlush();
    glSwapAPPLE();
}

- (void)dealloc {
    [self _deleteTexture];
}

@end


#import <AppKit/AppKit.h>
#import <OpenGL/OpenGL.h>

NSOpenGLPixelFormat *getGLPixelFormat();

@interface GLImageView : NSOpenGLView

- (GLuint)allocateTextureWithData:(const float *)data size:(int)size;
- (void)clear;

@end

import Foundation

// A swift wrapper around the C++ implementation of the evolutionary image generator.
class ImageGenerator {
    private let generator: COpaquePointer
    private let queue: dispatch_queue_t!
    
    init() {
		guard let resourcePath = NSBundle.mainBundle().resourcePath else {
			fatalError("No resources")
		}
		generator = resourcePath.withCString {
			createImageGenerator($0)
		}
        queue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)
    }
    
    deinit {
        destroyImageGenerator(generator)
    }
    
    func run(iterations: Int, callback: (pixels: UnsafePointer<Float>, size: Int, iteration: Int) -> ()) {
        dispatch_async(queue) {
            for i in 0..<iterations {
                let pixels = generatePixels(self.generator)
                dispatch_sync(dispatch_get_main_queue()) {
                    callback(pixels: pixels, size: 512, iteration: i)
                }
            }
        }
    }
}

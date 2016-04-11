import Cocoa
import OpenGL

var currentPixels: [Float] = []

class ViewController: NSViewController {

    var imageView: GLImageView!
    private var imageGenerator: ImageGenerator!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageGenerator = ImageGenerator()
    }

    override func viewDidAppear() {
        let format = getGLPixelFormat()
        
        imageView = GLImageView(frame: NSZeroRect, pixelFormat: format!)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false;
        view.addSubview(imageView);
        let container = view
        NSLayoutConstraint(item: imageView, attribute: .Bottom, relatedBy: .Equal, toItem: container, attribute: .Bottom, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Top, relatedBy: .Equal, toItem: container, attribute: .Top, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Left, relatedBy: .Equal, toItem: container, attribute: .Left, multiplier: 1, constant: 0).active = true
        NSLayoutConstraint(item: imageView, attribute: .Right, relatedBy: .Equal, toItem: container, attribute: .Right, multiplier: 1, constant: 0).active = true
        
        view.display()
		// Run the image generation process.
        imageGenerator.run(25) { pixels, size, iteration in
			currentPixels.removeAll()
			currentPixels.appendContentsOf(UnsafeBufferPointer(start: pixels, count: size * size * 4))
            self.imageView.allocateTextureWithData(pixels, size: Int32(size))
        }
	}
}

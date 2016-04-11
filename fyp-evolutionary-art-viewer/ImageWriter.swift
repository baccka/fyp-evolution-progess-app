import Cocoa

private enum SaveImageError: ErrorType {
	case FileExists
}

// Used to save the images.
func saveToPNG(pixels: [Float], width: Int, height: Int) {
	guard let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height, bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false, colorSpaceName: NSDeviceRGBColorSpace, bytesPerRow: 0, bitsPerPixel: 0) else {
		fatalError("Couldn't create an output bitmap")
	}
	for x in 0..<width {
		for y in 0..<height {
			let index = (y * width + x) * 4
			let (red, green, blue) = (pixels[index], pixels[index + 1], pixels[index + 2])
			bitmap.setColor(NSColor(deviceRed: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: 1), atX: x, y: y)
		}
	}
	let now = NSDate()
	do {
		try saveToPNG("evolutionary-art-\(now).png", bitmap: bitmap)
	} catch {
		fatalError("Failed to save the image")
	}
}

private func saveToPNG(filename: String, bitmap: NSBitmapImageRep) throws {
	guard let imageData = bitmap.representationUsingType(NSBitmapImageFileType.NSPNGFileType, properties: [:]) else {
		fatalError("Invalid image data")
	}
	guard let documentsURL =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first else {
		fatalError("No documents folder?")
	}
	let destinationURL = documentsURL.URLByAppendingPathComponent(filename)
	guard !NSFileManager().fileExistsAtPath(destinationURL.path!) else {
		throw SaveImageError.FileExists
	}
	let result = imageData.writeToURL(destinationURL, atomically: true)
	print("Saved:", result)
}

//
//  ViewController.swift
//  ImageCompressor
//
//  Created by dumbass.cn on 3/4/20.
//  Copyright © 2020 dumbass.cn. All rights reserved.
//

import Cocoa
import zopflipng
import Accelerate.vImage
import Quartz

class ViewController: NSViewController {

    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var dragView: DestinationView!
    override func viewDidLoad() {
        super.viewDidLoad()        
        dragView.delegate = self
    }

    
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

extension ViewController : DestinationviewDelegate {
    
    func destinationview(_ sender: DestinationView, didDraggedImageWithURLs urls: [URL], atPosition point: NSPoint) {
        
        urls.enumerated().forEach { offset, element in
            
//            let data = try! Data(contentsOf: element)
            
            let image = NSImage(contentsOf: element)
            let cgImage = image?.cgImage(forProposedRect: nil, context: nil, hints: nil)
            
            let srcBuffer = try! vImage_Buffer(cgImage: cgImage!)
            
            var opt = CZopfliPNGOptions()
            
            let data = srcBuffer.data.assumingMemoryBound(to: UInt8.self)

            
            var originPNG = data[0]
            
            var resultPNG: UnsafeMutablePointer<UInt8>?
            
            var resultSize = 0
            
            let result = CZopfliPNGOptimize(data, Int(srcBuffer.width * srcBuffer.height), &opt, 0, &resultPNG, &resultSize)
            
            print(result)
            
        }
        
    }
    
}


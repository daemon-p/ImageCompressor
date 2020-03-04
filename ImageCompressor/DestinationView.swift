//
//  DestinationView.swift
//  ImageCompressor
//
//  Created by dumbass.cn on 3/4/20.
//  Copyright © 2020 dumbass.cn. All rights reserved.
//

import AppKit

protocol DestinationviewDelegate : class {
    func destinationview(_ sender: DestinationView, didDraggedImageWithURLs urls: [URL], atPosition point: NSPoint)
}

class DestinationView : NSView {
    
    private var isReceivingDragEvent = false {
        didSet {
            needsDisplay = true
        }
    }
    
    private var filterOptions: [NSPasteboard.ReadingOptionKey: Any] {
        [.urlReadingContentsConformToTypes : NSImage.imageTypes]
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }
    
    private func setup() {
        registerForDraggedTypes([.URL])
    }
    
    weak var delegate: DestinationviewDelegate?
    
    private func inspectContent(_ dragInfo: NSDraggingInfo) -> Bool {
        dragInfo.draggingPasteboard.canReadObject(forClasses: [NSURL.self], options: filterOptions)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
        guard isReceivingDragEvent else {
            return
        }
        
        NSColor.selectedControlColor.set()
        let path = NSBezierPath(rect: bounds)
        path.lineWidth = 10
        path.stroke()
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        let valid = inspectContent(sender)
        isReceivingDragEvent = valid
        return valid ? .copy : .init()
    }
    
    override func draggingExited(_ sender: NSDraggingInfo?) {
        isReceivingDragEvent = false
    }
    
    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        inspectContent(sender)
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        isReceivingDragEvent = false
        
        let point = convert(sender.draggingLocation, from: nil)

        guard let urls = sender.draggingPasteboard.readObjects(
            forClasses: [NSURL.self], options: filterOptions) as? [URL], !urls.isEmpty else {
            return false
        }
        
        delegate?.destinationview(self, didDraggedImageWithURLs: urls, atPosition: point)
        
        return true
    }
    
}

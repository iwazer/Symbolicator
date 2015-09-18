//
//  PathTextField.swift
//  Symbolicator
//
//  Created by 岩澤 英治 on 2015/09/18.
//  Copyright © 2015年 iwazer. All rights reserved.
//

import Cocoa

class PathTextField: NSTextField {

    override func drawRect(dirtyRect: NSRect) {
        super.drawRect(dirtyRect)

        // Drawing code here.
        self.registerForDraggedTypes([NSFilenamesPboardType,NSStringPboardType])
    }
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        Swift.print("draggingEntered")
        return super.draggingEntered(sender)
    }
    
    override func draggingUpdated(sender: NSDraggingInfo) -> NSDragOperation {
        Swift.print("draggingUpdated")
        return super.draggingUpdated(sender)
    }
    
    override func draggingEnded(sender: NSDraggingInfo?) {
        Swift.print("draggingEnded")
    }
    
    override func draggingExited(sender: NSDraggingInfo?) {
        Swift.print("draggingExited")
    }
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        Swift.print("prepareForDragOperation")
        return super.prepareForDragOperation(sender)
    }
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        Swift.print("performDragOperation")
        let pb = sender.draggingPasteboard()
        if (pb.types?.contains(NSFilenamesPboardType) == true) {
            let paths = pb.propertyListForType(NSFilenamesPboardType)
            let filePath = paths?.firstItem as! String
            self.stringValue = ""
            self.stringValue = filePath
            pb.clearContents()
            pb.setData(filePath.dataUsingEncoding(NSUTF8StringEncoding), forType: NSPasteboardTypeString)
        }
        return false
    }
    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        Swift.print("concludeDragOperation")
        return super.concludeDragOperation(sender)
    }
    
}

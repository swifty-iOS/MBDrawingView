//
//  MBDrawingView.swift
//  DrawingViewDemo
//
//  Created by Manish Bhande on 30/05/2019.
//  Copyright © 2019 Manish Bhande. All rights reserved.
//

import UIKit

/// Use this clss to create any drawing
/// This layer base drawing to increase performance
open class MBDrawingView: UIView {
    
    /// Set pencil size for drawing
    public var pencilSize: CGFloat {
        get { return drawingLayer.lineWidth }
        set { drawingLayer.lineWidth = max(0, newValue) }
    }
    
    /// Set pencil color for drawing
    public var pencilColor: UIColor? {
        get { return drawingLayer.strokeColor == nil ? nil : UIColor(cgColor: drawingLayer.strokeColor!) }
        set { drawingLayer.strokeColor = newValue?.cgColor }
    }
    
    /// Check the view has drawing or not
    public var hasDrawing: Bool {
        return layer.sublayers?.count ?? 0 > 1
    }
    
    /// Get image of actual drawing
    ///
    /// - Returns: UImage
    public func capture() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    /// Clear all drawing
    public func clear() {
        layer.sublayers = nil
        layer.insertSublayer(drawingLayer, at: 0)
    }
    
    /// Undo the last drawing operation
    public func undo() {
        guard let count = layer.sublayers?.count, count >= 2 else { return }
        layer.sublayers?[count-2].removeFromSuperlayer()
    }

    //---------------------------------------------------------
    
    // MARK: -  Drawing logic
    
    private var lastPoint: CGPoint!
    private var isSwiping = false
    private var drawingLayer = CAShapeLayer()
    private var paths = UIBezierPath()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override open func draw(_ rect: CGRect) {
        super.draw(rect)
        clipsToBounds = true
    }
    
    
    // MARK: - Touch Handings
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isSwiping = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        isSwiping = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            if point(inside: currentPoint, with: event) {
                drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            }
            lastPoint = currentPoint
        }
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !isSwiping, let touch = touches.first {
            let currentPoint = touch.location(in: self)
            if point(inside: currentPoint, with: event) {
                drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
            }
            lastPoint = currentPoint
        }
        createDrawingLayer()
    }
    
}

// MARK: - Internal Use only
private extension MBDrawingView {
    
    /// Default set for drawings
    func setup() {
        layer.insertSublayer(drawingLayer, at: 0)
        drawingLayer.lineCap = .round
        pencilColor = UIColor.black
        pencilSize = 2.0
    }
    
    /// Draw a line from point to point
    ///
    /// - Parameters:
    ///   - fromPoint: Start point
    ///   - toPoint: End point
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        paths.move(to: fromPoint)
        paths.addLine(to: toPoint)
        drawingLayer.path = paths.cgPath
    }
    
    /// Create new layer for each sequence drawing
    func createDrawingLayer() {
        paths.removeAllPoints()
        let newlayer = CAShapeLayer()
        layer.insertSublayer(newlayer, above: drawingLayer)
        newlayer.lineCap = .round
        newlayer.lineWidth = pencilSize
        newlayer.strokeColor = pencilColor?.cgColor
        drawingLayer = newlayer
        
    }
    
}

//
//  ViewController.swift
//  DrawingViewDemo
//
//  Created by Manish Bhande on 30/05/2019.
//  Copyright © 2019 Manish Bhande. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var pencilSlider: UISlider!
    @IBOutlet weak var redColorSlider: UISlider!
    @IBOutlet weak var blueColorSilder: UISlider!
    @IBOutlet weak var greenColorSlider: UISlider!
    @IBOutlet weak var pencelSizeLabel: UILabel!
    @IBOutlet weak var viewLineSize: UIView!
    @IBOutlet weak var constarineLineSizeView: NSLayoutConstraint!

    @IBOutlet weak var pencilIcon: UIImageView!
    @IBOutlet weak var viewDrawing: MBDrawingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func setup() {
        pencilSliderAction(pencilSlider)
        updateColor()
    }

    func updateColor() {
        let color = UIColor(red: redColorSlider.value.cgFloat/255.0,
                                          green: greenColorSlider.value.cgFloat/255.0,
                                          blue: blueColorSilder.value.cgFloat/255.0, alpha: 1)
        viewDrawing.pencilColor = color
        pencilIcon.backgroundColor = color
    }

    @IBAction func pencilSliderAction(_ sender: UISlider) {
        viewDrawing.pencilSize = CGFloat(Int(sender.value))
        pencelSizeLabel.text = "\(viewDrawing.pencilSize)"
        viewLineSize.layer.cornerRadius = viewDrawing.pencilSize/2
        constarineLineSizeView.constant = viewDrawing.pencilSize
    }

    @IBAction func colorSliderAction(_ sender: UISlider) {
        updateColor()
    }

    @IBAction func deleteAction(_ sender: Any) {
        print(viewDrawing.hasDrawing)
        viewDrawing.clear()
    }

    @IBAction func undoAction(_ sender: Any) {
        viewDrawing.undo()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? CaptureViewController {
            controller.image = viewDrawing.capture()
        }
    }
}

extension Float {

    var cgFloat: CGFloat { return CGFloat(self) }
}

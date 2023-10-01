//
//  CircularProgressBarView.swift
//  CGAssessment
//
//  Created by Diego Henrique Silva Oliveira on 07/09/23.
//

import UIKit

class CircularProgressBarView: UIView {

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createCircularPath()
    }

    // MARK: - Private Properties

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    // MARK: - Private Methods

    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2,
                                                           y: frame.size.height / 2),
                                        radius: 30, startAngle: startPoint,
                                        endAngle: endPoint, clockwise: true)

        circleLayer.path = circularPath.cgPath

        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 10.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.background4?.cgColor

        layer.addSublayer(circleLayer)

        progressLayer.path = circularPath.cgPath

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.background5?.cgColor

        layer.addSublayer(progressLayer)
    }

    // MARK: - Public Methods

    func progressAnimation(duration: TimeInterval, progress: Double) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = progress
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false

        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}

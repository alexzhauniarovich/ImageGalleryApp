import UIKit

@IBDesignable
class SpinnerView: UIView {

    @IBInspectable public var color: UIColor = AppColors.appTheme.value

    struct Pose {
        let secondsSincePriorPose: CFTimeInterval
        let start: CGFloat
        let length: CGFloat
    }

    // MARK: - Public fields

    override var layer: CAShapeLayer { super.layer as! CAShapeLayer }
    override class var layerClass: AnyClass { CAShapeLayer.self }
    
    // MARK: Private fields
    
    private let poses: [Pose] = [
        Pose(secondsSincePriorPose: 0.0, start: 0.000, length: 0.7),
        Pose(secondsSincePriorPose: 0.6, start: 0.500, length: 0.5),
        Pose(secondsSincePriorPose: 0.6, start: 1.000, length: 0.3),
        Pose(secondsSincePriorPose: 0.6, start: 1.500, length: 0.1),
        Pose(secondsSincePriorPose: 0.2, start: 1.875, length: 0.1),
        Pose(secondsSincePriorPose: 0.2, start: 2.250, length: 0.3),
        Pose(secondsSincePriorPose: 0.2, start: 2.625, length: 0.5),
        Pose(secondsSincePriorPose: 0.2, start: 3.000, length: 0.7)
    ]

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.fillColor = nil
        layer.lineWidth = 4
        layer.strokeColor = color.cgColor
        layer.lineCap = .round

        setPath()
    }
    
    // MARK: - Public functions

    func animate() {
        var time: CFTimeInterval = 0
        var times = [CFTimeInterval]()
        var start: CGFloat = 0
        var rotations = [CGFloat]()
        var strokeEnds = [CGFloat]()

        let totalSeconds = poses.reduce(0) { $0 + $1.secondsSincePriorPose }

        for pose in poses {
            time += pose.secondsSincePriorPose
            times.append(time / totalSeconds)
            start = pose.start
            rotations.append(start * 2 * .pi)
            strokeEnds.append(pose.length)
        }

        times.append(times.last!)
        rotations.append(rotations[0])
        strokeEnds.append(strokeEnds[0])

        animateKeyPath(keyPath: "strokeEnd", duration: totalSeconds, times: times, values: strokeEnds)
        animateKeyPath(keyPath: "transform.rotation", duration: totalSeconds, times: times, values: rotations)

        animateStrokeHueWithDuration(duration: totalSeconds * 5)
    }

    func startAnimating() {
        animate()
        isHidden = false
    }

    func stopAnimating() {
        layer.removeAllAnimations()
        isHidden = true
    }
    
    // MARK: - Private functions

    private func animateKeyPath(keyPath: String, duration: CFTimeInterval, times: [CFTimeInterval], values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: keyPath)
        animation.keyTimes = times as [NSNumber]?
        animation.values = values
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.duration = duration
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }

    private func animateStrokeHueWithDuration(duration: CFTimeInterval) {
        let count = 36
        let animation = CAKeyframeAnimation(keyPath: "strokeColor")
        animation.keyTimes = (0 ... count).map { NSNumber(value: CFTimeInterval($0) / CFTimeInterval(count)) }
        animation.values = (0 ... count).map { _ in color.cgColor }
        animation.duration = duration
        animation.calculationMode = CAAnimationCalculationMode.linear
        animation.repeatCount = Float.infinity
        layer.add(animation, forKey: animation.keyPath)
    }
    
    private func setPath() {
        layer.path = UIBezierPath(ovalIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2)).cgPath
    }
}

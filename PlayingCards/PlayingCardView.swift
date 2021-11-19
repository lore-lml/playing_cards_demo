//
//  PlayingCardView.swift
//  PlayingCards
//
//  Created by Lorenzo Limoli on 17/11/21.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    @IBInspectable
    var rank: Int = 12 { didSet{ setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var suite: String = "♦️" { didSet{ setNeedsDisplay(); setNeedsLayout() } }
    @IBInspectable
    var isFaceUp: Bool = true { didSet{ setNeedsDisplay(); setNeedsLayout() } }
    var faceCardScale: CGFloat = SizeRatio.faceCardImageSizeToBoundsSize{ didSet{ setNeedsDisplay() } }
    
//    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer){
//        switch recognizer.state{
//        case .changed, .ended:
//            faceCardScale *= recognizer.scale
//            recognizer.scale = 1.0 // Reset the recognizer scale otherwise it will scale in an exponential way
//        default: break
//        }
//    }
    
    private func centeredAtributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString{
        var font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: UIFont.TextStyle.body).scaledFont(for: font)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        return NSAttributedString(string: string, attributes: [
                .font: font,
                .paragraphStyle: paragraphStyle
        ])
    }
    
    private var cornerString: NSAttributedString{
        return centeredAtributedString("\(rankString)\n\(suite)", fontSize: cornerFontSize)
    }
    
    private lazy var upperLeftCornerLabel: UILabel = createCornerLabel()
    private lazy var lowerRightCornerLabel: UILabel = createCornerLabel()
    
    private func createCornerLabel() -> UILabel{
        let label = UILabel()
        label.numberOfLines = 0 //infinite lines
        addSubview(label)
        return label
    }
    
    private func configureCornerLabel(_ label: UILabel){
        label.attributedText = cornerString
        label.frame.size = CGSize.zero
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        
        configureCornerLabel(lowerRightCornerLabel)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height)
        lowerRightCornerLabel.transform = CGAffineTransform.identity.rotated(by: Double.pi)
    }
    
    private func drawPips(){
        let pipsPatternPerRank: [[Int]] = [
            [1],
            [1,1],
            [1,1,1],
            [2,2],
            [2,1,2],
            [2,2,2],
            [2,1,2,2],
            [2,2,2,2],
            [2,2,1,2,2],
            [2,2,2,2,2],
        ]
        
        let createPipString = {(pipRect: CGRect) -> NSAttributedString in
            let maxVerticalPip = 5.0//CGFloat(pipsPatternPerRank.map{$0.count}.max() ?? 0)
            let maxHorizontalPip = 2.0//CGFloat(pipsPatternPerRank.map{$0.max() ?? 0}.max() ?? 0)
            let verticalPipRowSpacing = CGFloat(pipRect.size.height / maxVerticalPip)
            let attemptedPipString = self.centeredAtributedString(self.suite, fontSize: verticalPipRowSpacing)
            let probablyOkPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkPipString = self.centeredAtributedString(self.suite, fontSize: probablyOkPipStringFontSize)
            if probablyOkPipString.size().width > pipRect.size.width / maxHorizontalPip{
                return self.centeredAtributedString(self.suite, fontSize: probablyOkPipStringFontSize / (probablyOkPipString.size().width / (pipRect.size.width / maxHorizontalPip)))
            }else{
                return probablyOkPipString
            }
        }
        
        if pipsPatternPerRank.indices.contains(rank-1){
            let pipsPerRow = pipsPatternPerRank[rank-1]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset)
                .insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow{
                switch pipCount{
                case 1: pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default: break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else{
//            return
//        }
        
//        context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0.0, endAngle: 2.0*Double.pi, clockwise: true)
//        context.setLineWidth(5.0)
//        UIColor.green.setFill()
//        UIColor.red.setStroke()
//        context.strokePath()
//        context.fillPath() //At this point, the path has been consumed, so fill path does nothing unless all the previous instructions are repetead
        
//        let path = UIBezierPath()
//        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0.0, endAngle: 2.0*Double.pi, clockwise: true)
//        path.lineWidth = 5.0
//        UIColor.green.setFill()
//        UIColor.red.setStroke()
//        path.stroke()
//        path.fill()
        
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        if isFaceUp{
            //if let faceCardImage = UIImage(named: rankString){
            
            //If you want to see images within the interface builder (after having set @IBDesignable on the class view), use this:
            if let faceCardImage = UIImage(named: rankString, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                faceCardImage.draw(in: bounds.zoomed(by: faceCardScale))
            }else{
                drawPips()
            }
        }else{
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                cardBackImage.draw(in: bounds)
            }
        }
    }

}

extension PlayingCardView{
    private struct SizeRatio{
        static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let cornerOffsetToCornerRadius: CGFloat = 0.33
        static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
    }
    
    private var cornerRadius: CGFloat{
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    private var cornerOffset: CGFloat{
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    private var cornerFontSize: CGFloat{
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
    }
    private var rankString: String{
        switch rank{
        case 1: return "A"
        case 2...10: return String(rank)
        case 11: return "J"
        case 12: return "Q"
        case 13: return "K"
        default: return "?"
        }
    }
}

extension CGRect{
    var leftHalf: CGRect{
        return CGRect(x: minX, y: minY, width: width/2, height: height)
    }
    
    var rightHalf: CGRect{
        return CGRect(x: midX, y: minY, width: width/2, height: height)
    }
    
    func inset(by size: CGSize) -> CGRect{
        return insetBy(dx: size.width, dy: size.height)
    }
    
    func sized(to size: CGSize) -> CGRect{
        return CGRect(origin: origin, size: size)
    }
    
    func zoomed(by scale: CGFloat) -> CGRect{
        let newWidth = width * scale
        let newHeight = height * scale
        return insetBy(dx: (width - newWidth) / 2, dy: (height - newHeight) / 2)
    }
}

extension CGPoint{
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint{
        return CGPoint(x: x+dx, y: y+dy)
    }
}

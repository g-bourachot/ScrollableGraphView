//
//  PointLabelsDrawingView.swift
//  GraphView
//
//  Created by Guillaume Bourachot on 03/05/2019.
//

import UIKit
import Foundation

public struct PointLabelsDrawingSettings {
    public var labelColor: UIColor = .black
    public var labelFont: UIFont = .boldSystemFont(ofSize: 20)
    public var labelYOffset: CGFloat = 0
    public var labelXOffset: CGFloat = 0
    
    public init() {}
}

internal class PointLabelsDrawingView : UIView {
    
    //MARK: - Variables
    var graphViewDrawingDelegate: ScrollableGraphViewDrawingDelegate! = nil
    var settings : PointLabelsDrawingSettings = PointLabelsDrawingSettings.init()
    private var pointDictionary = [Int:(CGPoint,Double)]()
    private var topMargin: CGFloat = 10
    private var bottomMargin: CGFloat = 10
    
    //MARK: - Life cycle
    init(frame: CGRect, topMargin: CGFloat, bottomMargin: CGFloat, settings: PointLabelsDrawingSettings) {
        super.init(frame: frame)
        self.topMargin = topMargin
        self.bottomMargin = bottomMargin
        self.settings = settings
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Public functions
    func setPoints(for values:[Int:Double]){
        self.addPointLabels(for:values)
    }
    
    //MARK: - Private functions
    private func createLabel(at position: CGPoint, withText text: String) -> UILabel {
        let boundingSize = self.boundingSize(forText: text)
        let frame = CGRect(
                origin: CGPoint(x: position.x - (boundingSize.width / 2) + self.settings.labelXOffset, y: position.y - (boundingSize.height / 2) - self.settings.labelYOffset),
                size: boundingSize)
        let label = UILabel(frame: frame)
        label.text = text
        label.textColor = self.settings.labelColor
        label.font = self.settings.labelFont
        return label
    }
    
    private func boundingSize(forText text: String) -> CGSize {
        return (text as NSString).size(withAttributes: convertToOptionalNSAttributedStringKeyDictionary([convertFromNSAttributedStringKey(NSAttributedString.Key.font):self.settings.labelFont]))
    }
    
    private func addPointLabels(for values:[Int:Double]){
        for (key,value) in values {
            let position = graphViewDrawingDelegate.calculatePosition(atIndex: key, value: value)
            if let existingPosition = self.pointDictionary[key], existingPosition.0 == position {
                continue
            } else {
                self.pointDictionary[key] = (position, value)
            }
        }
        self.subviews.forEach({ $0.removeFromSuperview()})
        for point in self.pointDictionary {
            let cleanStringValue = point.value.1.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", point.value.1) : String(point.value.1)
            let leftLabel = createLabel(at: point.value.0, withText: cleanStringValue)
            self.addSubview(leftLabel)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromNSAttributedStringKey(_ input: NSAttributedString.Key) -> String {
    return input.rawValue
}

//
//  PointLabelsDrawingView.swift
//  GraphView
//
//  Created by Guillaume Bourachot on 03/05/2019.
//

import UIKit
import Foundation

struct PointLabelsDrawingSettings {
    var labelColor: UIColor = .black
    var labelFont: UIFont = .boldSystemFont(ofSize: 20)
    var labelYOffset: CGFloat = 0
    var labelXOffset: CGFloat = 0
}

internal class PointLabelsDrawingView : UIView {
    
    //MARK: - Variables
    var graphViewDrawingDelegate: ScrollableGraphViewDrawingDelegate! = nil
    var settings : PointLabelsDrawingSettings = PointLabelsDrawingSettings.init()
    private var labels = [UILabel]()
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
    func setPoints(for values:[Double]){
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
    
    private func addPointLabels(for values:[Double]){
        var index = -1
        for value in values {
            index = index + 1
            let position = graphViewDrawingDelegate.calculatePosition(atIndex: index, value: value)
            let leftLabel = createLabel(at: position, withText: String(value))
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

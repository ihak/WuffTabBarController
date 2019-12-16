//
//  WoofTabView.swift
//  WoofTabBarController
//
//  Created by Faizan Naseem on 22/11/2019.
//  Copyright © 2019 Arpatech Pvt. Ltd. All rights reserved.
//

import UIKit

public class WoofTabBarView: UIView {

    var barItems = [WoofTabBarItem]()
    var delegate: WoofTabBarViewDelegate?

    let bezierView = BezierView()
    let stackView = UIStackView()
    var defaultSelectedIndex = 3
    
    public var bezierBackgroundColor: UIColor = .white
    public var circleBackgroundColor: UIColor = .white
    public var notificationBubbleColor: UIColor = .orange
    public var notificationTextColor: UIColor = .white
    
    public var imageTint: UIColor?
    public var bezieranimationDuration = 0.15
    public var circleAnimationDuration = 0.2
    
    public typealias offset = CGSize
    public typealias radius = Double
    public typealias opacity = Double
    public typealias color = UIColor
    
    public var shadow: (radius, opacity, offset, color)?
    
    var selectedIndex = -1 {
        didSet {
            guard oldValue > -1 else {
                return
            }
            unSelectItem(index: oldValue)
        }
    }
     
    convenience init(barItems: [WoofTabBarItem]) {
        self.init()
        self.barItems.append(contentsOf: barItems)
    }
    
    override public func layoutSubviews() {
        guard stackView.superview == nil else {
            return
        }
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually

        for item in barItems {
            let barItemView = WoofTabBarItemView()
            barItemView.circleBackgroundColor = self.circleBackgroundColor
            barItemView.circleAnimationDuration(duration: self.circleAnimationDuration)
            barItemView.item = item
            barItemView.imageTintColor = self.imageTint
            barItemView.delegate = self
            if let shadow = self.shadow {
                barItemView.shadow(opacity: shadow.1, radius: shadow.0, offset: shadow.2, color: shadow.3)
            }
            barItemView.notificationTextColor = self.notificationTextColor
            barItemView.notificationBubbleBackgroundClor = self.notificationBubbleColor
            stackView.addArrangedSubview(barItemView)            
        }
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(stackView)
        
        stackView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        
        bezierView.shapeBackgroundColor(color: bezierBackgroundColor)
        bezierView.animationDuration(duration: bezieranimationDuration)
        if let shadow = self.shadow {
            bezierView.shadow(opacity: shadow.1, radius: shadow.0, offset: shadow.2, color: shadow.3)
        }
        
        bezierView.translatesAutoresizingMaskIntoConstraints = false
        self.insertSubview(bezierView, belowSubview: stackView)
        
        NSLayoutConstraint.activate([
            bezierView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bezierView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bezierView.topAnchor.constraint(equalTo: self.topAnchor),
            bezierView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        bezierView.addShapeLayer()
    }
    
    override public var intrinsicContentSize: CGSize {
        return CGSize(width: 300.0, height: 60.0)
    }
    
    private func unSelectItem(index: Int) {
        if let item = self.stackView.arrangedSubviews[index] as? WoofTabBarItemView {
            item.unSelect()
        }
    }
    
    private func selectItem(index: Int, animated: Bool) {
        if let item = self.stackView.arrangedSubviews[index] as? WoofTabBarItemView {
            item.select(animated: animated)
        }
    }
    
    private func changeCurveShape(position: CGPoint, animated: Bool = true) {
        bezierView.moveCurve(to: position.x, animated: animated)
    }
    
    private func indexOfItemView(itemView: WoofTabBarItemView) -> Int? {
        return self.stackView.arrangedSubviews.firstIndex(of: itemView)
    }
}

extension WoofTabBarView: WoofTabBarItemViewDelegate {
    func isDefaultItem(itemView: WoofTabBarItemView) -> Bool {
        if let defaultItem = self.stackView.arrangedSubviews[defaultSelectedIndex] as? WoofTabBarItemView {
            guard defaultItem == itemView else {
                return false
            }
            self.changeCurveShape(position: itemView.center, animated: false)
            self.selectedIndex = defaultSelectedIndex
            return true
        }
        return false
    }
    
    func shouldTap(itemView: WoofTabBarItemView) -> Bool {
        if let index = indexOfItemView(itemView: itemView), let delegate = self.delegate {
            return delegate.shouldSelectItem(itemView: itemView, atIndex: index)
        }
        return true
    }
    
    func shouldAnimate(itemView: WoofTabBarItemView) -> Bool {
        if let index = indexOfItemView(itemView: itemView), let delegate = self.delegate {
            return delegate.shouldAnimateItem(itemView: itemView, atIndex: index)
        }
        return true
    }
    
    func didTap(itemView: WoofTabBarItemView) {
        if let index = indexOfItemView(itemView: itemView) {
            guard index != selectedIndex else {
                return
            }
            self.changeCurveShape(position: itemView.center, animated: self.shouldAnimate(itemView: itemView))
            self.selectedIndex = index
            print("selected index", selectedIndex)
            self.delegate?.didSelectItem(itemView: itemView, atIndex: index)
        }
    }
    
    func didAnimate(itemView: WoofTabBarItemView) {
        if let index = indexOfItemView(itemView: itemView) {
            delegate?.didAnimateItem(itemView: itemView, atIndex: index)
        }
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

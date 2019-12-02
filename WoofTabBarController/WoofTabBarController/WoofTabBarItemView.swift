//
//  TabBarItemView.swift
//  WoofTabBarController
//
//  Created by Faizan Naseem on 22/11/2019.
//  Copyright © 2019 Arpatech Pvt. Ltd. All rights reserved.
//

import UIKit

public class WoofTabBarItemView: UIView {

    var item: WoofTabBarItem!
    
    // contains the image and notification view
    var imageContainer = UIView()
    
    // circular view that highlights when item is selected
    var backCircleView = UIView()
    
    var delegate: WoofTabBarItemViewDelegate?
    
    override public func draw(_ rect: CGRect) {
        guard imageContainer.superview == nil else {
            return
        }
        
        backgroundColor = .clear
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
        
        // contains icon image and notification bubble view
        // receives touches and animates
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(imageContainer)
        NSLayoutConstraint.activate([
            imageContainer.heightAnchor.constraint(equalToConstant: 40.0),
            imageContainer.widthAnchor.constraint(equalToConstant: 40.0),
            imageContainer.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            imageContainer.centerYAnchor.constraint(equalTo: containerView.centerYAnchor, constant: -8.0)
        ])
        
        imageContainer.layer.cornerRadius = 20.0
        imageContainer.clipsToBounds = true
        imageContainer.backgroundColor = .clear
        
        // Add tap gesture to imageContainer view
        addTapGesture(view: imageContainer)
        
        // circle container view - hides the circle view when its below the bar
        // by cliping bounds.
        let backCircleContainer = UIView()
        backCircleContainer.clipsToBounds = true
        backCircleContainer.translatesAutoresizingMaskIntoConstraints = false
        backCircleContainer.backgroundColor = .clear
        containerView.insertSubview(backCircleContainer, belowSubview: imageContainer)
        NSLayoutConstraint.activate([
            backCircleContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -22.0),
            backCircleContainer.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            backCircleContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            backCircleContainer.widthAnchor.constraint(equalToConstant: 50.0)
        ])

        backCircleView.translatesAutoresizingMaskIntoConstraints = false
        backCircleView.backgroundColor = .white
        backCircleView.layer.cornerRadius = 20.0
        backCircleContainer.addSubview(backCircleView)
        NSLayoutConstraint.activate([
            backCircleView.topAnchor.constraint(equalTo: backCircleContainer.bottomAnchor),
            backCircleView.centerXAnchor.constraint(equalTo: backCircleContainer.centerXAnchor),
            backCircleView.widthAnchor.constraint(equalToConstant: 40),
            backCircleView.heightAnchor.constraint(equalToConstant: 40)
        ])

        let image = UIImageView(image: UIImage(named: item.image))
        image.contentMode = .scaleAspectFit
        image.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        image.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 5.0),
            image.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor, constant: -5.0),
            image.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor, constant: 5.0),
            image.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor, constant: -5.0)
        ])
        
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.text = item.title
        label.font = .systemFont(ofSize: 13)
        label.adjustsFontSizeToFitWidth = true
        
        label.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(label)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 3.0),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -3.0),
            label.topAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
        
        let notificationBubbleContainer = UIView()
        notificationBubbleContainer.translatesAutoresizingMaskIntoConstraints = false
        notificationBubbleContainer.layer.cornerRadius = 10
        notificationBubbleContainer.backgroundColor = .orange
        
        imageContainer.addSubview(notificationBubbleContainer)
        NSLayoutConstraint.activate([
            notificationBubbleContainer.heightAnchor.constraint(equalToConstant: 20.0),
            notificationBubbleContainer.widthAnchor.constraint(equalToConstant: 20.0),
            notificationBubbleContainer.topAnchor.constraint(equalTo: imageContainer.topAnchor, constant: 5.0),
            notificationBubbleContainer.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: -20.0)
        ])
        
        
        let notificationBubbleLabel = UILabel()
        notificationBubbleLabel.textAlignment = .center
        notificationBubbleLabel.textColor = .white
        notificationBubbleLabel.font = .boldSystemFont(ofSize: 9)
        notificationBubbleLabel.adjustsFontSizeToFitWidth = true
        notificationBubbleLabel.text = item.count
        notificationBubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        notificationBubbleContainer.addSubview(notificationBubbleLabel)
        NSLayoutConstraint.activate([
            notificationBubbleLabel.topAnchor.constraint(equalTo: notificationBubbleContainer.topAnchor, constant: 3.0),
            notificationBubbleLabel.bottomAnchor.constraint(equalTo: notificationBubbleContainer.bottomAnchor, constant: -3.0),
            notificationBubbleLabel.leadingAnchor.constraint(equalTo: notificationBubbleContainer.leadingAnchor, constant: 3.0),
            notificationBubbleLabel.trailingAnchor.constraint(equalTo: notificationBubbleContainer.trailingAnchor, constant: -3.0)
        ])
        
        // hides notification bubble
        if item.notificationCount <= 0 {
            notificationBubbleContainer.isHidden = true
        }
        
        // select default item
        if delegate?.isDefaultItem(itemView: self) == true {
            self.select(animated: false)
        }
    }

    override public var intrinsicContentSize: CGSize {
        CGSize(width: 50.0, height: 70.0)
    }
    
    private func addTapGesture(view: UIView) {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func animateContainerUp(duration: Double = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            var t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: -20.0)
            t = t.scaledBy(x: 1.2, y: 1.2)
            self.imageContainer.transform = t
            
            t = CGAffineTransform.identity
            t = t.translatedBy(x: 0.0, y: -78.0)
            t = t.scaledBy(x: 1.2, y: 1.2)
            self.backCircleView.transform = t
            self.backCircleView.alpha = 1.0
        }) { (_) in
            self.delegate?.didAnimate(itemView: self)
        }
    }
    
    private func animateContainerBack(duration: Double = 0.2) {
        UIView.animate(withDuration: duration, animations: {
            self.imageContainer.transform = .identity
            self.backCircleView.transform = .identity
            self.backCircleView.alpha = 0.0
        }, completion: nil)
    }
    
    @objc private func handleTap() {
        guard let delegate = self.delegate else {
            animateContainerUp()
            return
        }
        
        if delegate.shouldTap(itemView: self) {
            if delegate.shouldAnimate(itemView: self) {
                animateContainerUp()
            }
            else {
                animateContainerUp(duration: 0.0)
            }
            
            delegate.didTap(itemView: self)
        }
    }
    
    func unSelect(animated: Bool = true) {
        if animated == false {
            animateContainerBack(duration: 0.0)
        }
        else {
            animateContainerBack()
        }
    }
    
    func select(animated: Bool = true) {
        if animated == false {
            animateContainerUp(duration: 0.0)
        }
        else {
            animateContainerUp()
        }
    }
}

protocol WoofTabBarItemViewDelegate {
    func isDefaultItem(itemView: WoofTabBarItemView) -> Bool
    func didTap(itemView: WoofTabBarItemView)
    func shouldTap(itemView: WoofTabBarItemView) -> Bool
    func shouldAnimate(itemView: WoofTabBarItemView) -> Bool
    func didAnimate(itemView: WoofTabBarItemView)
}

extension WoofTabBarItemViewDelegate {
    func didTap(itemView: WoofTabBarItemView) {
    }
    
    func shouldTap(itemView: WoofTabBarItemView) -> Bool {
        return true
    }
    
    func shouldAnimate(itemView: WoofTabBarItemView) -> Bool {
        return true
    }
    
    func didAnimate(itemView: WoofTabBarItemView) {
    }
}
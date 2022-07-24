//
//  UIView+Blur.swift
//  PlateFull
//
//  Created by Trofim Petyanov on 24.07.2022.
//

import UIKit

extension UIView {
    func applyBlurEffect() {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffecrView = UIVisualEffectView(effect: blurEffect)
        blurEffecrView.frame = bounds
        blurEffecrView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffecrView, at: 0)
    }
}

//
//  YMCirclePickerCollectionViewCell.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 31.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

// MARK: - YMCirclePickerCollectionViewCellPresentation

struct YMCirclePickerCollectionViewCellPresentation {

    var image: UIImage?
    var subView: UIView?
}

// MARK: - YMCirclePickerCollectionViewCellPresentation

class YMCirclePickerCollectionViewCell: UICollectionViewCell, NibLoadable {

    // MARK: - Properties

    /// ReuseIdentifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    private let maskShapeLayer = CAShapeLayer()

    var presentation: YMCirclePickerCollectionViewCellPresentation? {
        didSet {
            updateUI()
        }
    }

    // MARK: - Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!

    // MARK: - Lifecycle

    override func layoutSublayers(of layer: CALayer) {

        super.layoutSublayers(of: layer)
        maskShapeLayer.path = UIBezierPath(
            roundedRect: contentView.bounds,
            cornerRadius: contentView.bounds.width / 2.0
        ).cgPath
    }

    private func updateUI() {

        guard let presentation = self.presentation else { return }
        if let image = presentation.image {
            imageView.image = image
            containerView.isHidden = true
            layer.mask = maskShapeLayer
        }

        if let subView = presentation.subView,
           !containerView.subviews.contains(subView) {
            imageView.isHidden = true
            containerView.addSubview(subView)
            subView.translatesAutoresizingMaskIntoConstraints = false
            subView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .zero).isActive = true
            subView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: .zero).isActive = true
            subView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .zero).isActive = true
            subView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: .zero).isActive = true
            layoutIfNeeded()
        }
    }
}

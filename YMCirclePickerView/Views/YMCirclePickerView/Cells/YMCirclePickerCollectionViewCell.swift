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

    var image: UIImage
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
        imageView.image = presentation.image
        layer.mask = maskShapeLayer
    }
}

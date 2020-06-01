//
//  YMCirclePickerView.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 31.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

public struct YMCirclePickerViewStylePresentation {

    /// Selection View
    var selectionColor: UIColor = .white
    var selectionLineWidth: CGFloat = 1.0

    /// Title Label
    var titleLabelDistance: CGFloat = 0.0
}

// MARK: - YMCirclePickerView

public struct YMCirclePickerViewPresentation {

    public var layoutPresentation: YMCirclePickerViewLayoutPresentation
    public var stylePresentation: YMCirclePickerViewStylePresentation
}

// MARK: - YMCirclePickerViewDelegate

public protocol YMCirclePickerViewDelegate: AnyObject {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int)
}

public extension YMCirclePickerViewDelegate {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int) {}
}

// MARK: - YMCirclePickerViewDataSource

public protocol YMCirclePickerViewDataSource: AnyObject {

    func ymCirclePickerView<T: YMCirclePickerModel>(ymCirclePickerView: YMCirclePickerView, itemForIndex index: Int) -> T
    func ymCirclePickerViewNumberOfItemsInPicker(ymCirclePickerView: YMCirclePickerView) -> Int
}

// MARK: - YMCirclePickerView

public class YMCirclePickerView: UIView, NibLoadable {

    // MARK: - Outlets

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var selectionView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: Constraints

    @IBOutlet private weak var collectionTitleVerticalConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectionViewHeightContstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectionViewWidthContstraint: NSLayoutConstraint!

    // MARK: - Properties

    weak var delegate: YMCirclePickerViewDelegate? = nil
    weak var dataSource: YMCirclePickerViewDataSource? = nil

    var presentation: YMCirclePickerViewPresentation? {
        didSet {
            updateUI()
        }
    }

    // MARK: - Lifecycle

    public override func awakeFromNib() {

        super.awakeFromNib()
        configureCollectionView()
    }

    private func configureCollectionView() {

        collectionView.register(
            YMCirclePickerCollectionViewCell.nib,
            forCellWithReuseIdentifier: YMCirclePickerCollectionViewCell.reuseIdentifier
        )
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
    }

    private func updateUI() {

        guard let presentation = self.presentation else { return }

        collectionView.collectionViewLayout = YMCirclePickerViewLayout(
            presentation: presentation.layoutPresentation
        )

        // Selection view

        selectionViewHeightContstraint.constant = presentation.layoutPresentation.itemSize.height + presentation.stylePresentation.selectionLineWidth
        selectionViewWidthContstraint.constant = presentation.layoutPresentation.itemSize.width + presentation.stylePresentation.selectionLineWidth

        layoutIfNeeded()

        let circlePath = UIBezierPath(
            arcCenter: selectionView.center,
            radius: selectionView.frame.size.width / 2.0,
            startAngle: CGFloat(0),
            endAngle: CGFloat(Double.pi * 2),
            clockwise: true
        )

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = presentation.stylePresentation.selectionColor.cgColor
        shapeLayer.lineWidth = presentation.stylePresentation.selectionLineWidth
        selectionView.layer.addSublayer(shapeLayer)
    }
}

// MARK: - UICollectionViewDataSource

extension YMCirclePickerView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dataSource?.ymCirclePickerViewNumberOfItemsInPicker(ymCirclePickerView: self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YMCirclePickerCollectionViewCell.reuseIdentifier,
            for: indexPath
            ) as? YMCirclePickerCollectionViewCell,
            let model = dataSource?.ymCirclePickerView(
                ymCirclePickerView: self,
                itemForIndex: indexPath.row
            ) else { return UICollectionViewCell() }

        if let image = model.image {
            cell.presentation = YMCirclePickerCollectionViewCellPresentation(image: image)
        }

        if let title = model.title {
            titleLabel.text = title
        } else if let attributedTitle = model.attributedTitle {
            titleLabel.attributedText = attributedTitle
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension YMCirclePickerView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // TODO
    }
}

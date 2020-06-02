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

    public static var `default` = YMCirclePickerViewPresentation(
        layoutPresentation: YMCirclePickerViewLayoutPresentation(
            itemSize: CGSize(width: 60.0, height: 60.0),
            unselectedItemSize: CGSize(width: 20.0, height: 20.0),
            spacing: 10.0
        ),
        stylePresentation: YMCirclePickerViewStylePresentation(
            selectionColor: .white,
            selectionLineWidth: 1.0,
            titleLabelDistance: 10.0
        )
    )
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

public class YMCirclePickerView: UIView {

    // MARK: - Outlets

    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var selectionView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!

    // MARK: Constraints

    @IBOutlet private weak var collectionTitleVerticalConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectionViewHeightContstraint: NSLayoutConstraint!
    @IBOutlet private weak var selectionViewWidthContstraint: NSLayoutConstraint!

    // MARK: - Properties

    public weak var delegate: YMCirclePickerViewDelegate? = nil
    public weak var dataSource: YMCirclePickerViewDataSource? = nil

    public var presentation: YMCirclePickerViewPresentation? {
        didSet {
            updateUI()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit() {

        guard let contentView = self.fromNib() else { fatalError("View could not load from nib") }

        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        let margins = self.layoutMarginsGuide
        contentView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 0).isActive = true
        contentView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0).isActive = true
        contentView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0).isActive = true

        configureCollectionView()
    }

    // MARK: - Lifecycle

    open override func awakeFromNib() {

        super.awakeFromNib()
        commonInit()
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
        collectionView.backgroundColor = .clear
        collectionView.decelerationRate = .fast
    }

    private func updateUI() {

        guard let presentation = self.presentation else { return }

        collectionViewHeightConstraint.constant = presentation.layoutPresentation.itemSize.height
        collectionView.collectionViewLayout = YMCirclePickerViewLayout(
            presentation: presentation.layoutPresentation
        )
        collectionView.collectionViewLayout.invalidateLayout()

        // Selection view

        selectionViewHeightContstraint.constant = presentation.layoutPresentation.itemSize.height + presentation.stylePresentation.selectionLineWidth
        selectionViewWidthContstraint.constant = presentation.layoutPresentation.itemSize.width + presentation.stylePresentation.selectionLineWidth

        // Distance between collection and title

        collectionTitleVerticalConstraint.constant = presentation.stylePresentation.titleLabelDistance

        layoutIfNeeded()

        selectionView.layer.cornerRadius = (selectionView.frame.size.width / 2.0)
        selectionView.layer.borderWidth = presentation.stylePresentation.selectionLineWidth
        selectionView.layer.borderColor = presentation.stylePresentation.selectionColor.cgColor
    }
}

// MARK: - Bundle extension

extension YMCirclePickerView {

    public static var bundle: Bundle {
        return Bundle(for: self)
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

        delegate?.ymCirclePickerView(ymCirclePickerView: self, didSelectItemAt: indexPath.item)
    }
}

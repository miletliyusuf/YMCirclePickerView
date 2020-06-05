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
    var titleLabelFont: UIFont
    var titleLabelTextColor: UIColor
    var titleLabelDistance: CGFloat = 0.0

    public init(
        selectionColor: UIColor,
        selectionLineWidth: CGFloat = 1.0,
        titleLabelFont: UIFont = .systemFont(ofSize: 18.0),
        titleLabelTextColor: UIColor = .black,
        titleLabelDistance: CGFloat = 0.0
    ) {

        self.selectionColor = selectionColor
        self.selectionLineWidth = selectionLineWidth
        self.titleLabelFont = titleLabelFont
        self.titleLabelTextColor = titleLabelTextColor
        self.titleLabelDistance = titleLabelDistance
    }
}

// MARK: - YMCirclePickerView

public struct YMCirclePickerViewPresentation {

    public var layoutPresentation: YMCirclePickerViewLayoutPresentation
    public var stylePresentation: YMCirclePickerViewStylePresentation

    public init(
        layoutPresentation: YMCirclePickerViewLayoutPresentation,
        stylePresentation: YMCirclePickerViewStylePresentation
    ) {
        self.layoutPresentation = layoutPresentation
        self.stylePresentation = stylePresentation
    }

    public static var `default` = YMCirclePickerViewPresentation(
        layoutPresentation: YMCirclePickerViewLayoutPresentation(
            itemSize: CGSize(width: 60.0, height: 60.0),
            unselectedItemSize: CGSize(width: 30.0, height: 30.0),
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

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, itemForIndex index: Int) -> YMCirclePickerModel?
    func ymCirclePickerViewNumberOfItemsInPicker(ymCirclePickerView: YMCirclePickerView) -> Int
}

// MARK: - YMCirclePickerView

public class YMCirclePickerView: UIView {

    private enum Constants {

        static let initialFrame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
    }

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
        super.init(frame: frame == .zero ? Constants.initialFrame : frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    /// Use to avoid fast double tap
    private var canSelectItem = true {
        didSet {
            collectionView.isUserInteractionEnabled = canSelectItem
        }
    }

    private var count: Int = 0

    func commonInit() {

//        let bundle = Bundle(for: YMCirclePickerView.self)
//        let nib = UINib(nibName: "YMCirclePickerView", bundle: bundle)
//        bundle.loadNibNamed(<#T##name: String##String#>, owner: <#T##Any?#>, options: <#T##[UINib.OptionsKey : Any]?#>)
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
        collectionView.collectionViewLayout.invalidateLayout()
    }

    private func updateUI() {

        guard let presentation = self.presentation else { return }

        collectionViewHeightConstraint.constant = presentation.layoutPresentation.itemSize.height
        collectionView.collectionViewLayout = YMCirclePickerViewLayout(
            presentation: presentation.layoutPresentation
        )

        // Selection view

        selectionViewHeightContstraint.constant = presentation.layoutPresentation.itemSize.height + presentation.stylePresentation.selectionLineWidth
        selectionViewWidthContstraint.constant = presentation.layoutPresentation.itemSize.width + presentation.stylePresentation.selectionLineWidth

        // Distance between collection and title

        collectionTitleVerticalConstraint.constant = presentation.stylePresentation.titleLabelDistance

        layoutIfNeeded()

        // Title Label

        titleLabel.font = presentation.stylePresentation.titleLabelFont
        titleLabel.textColor = presentation.stylePresentation.titleLabelTextColor

        selectionView.layer.cornerRadius = (selectionView.frame.size.width / 2.0)
        selectionView.layer.borderWidth = presentation.stylePresentation.selectionLineWidth
        selectionView.layer.borderColor = presentation.stylePresentation.selectionColor.cgColor

        setTitle(at: self.presentation?.layoutPresentation.initialIndex ?? 0)
        scrollToItem(at: self.presentation?.layoutPresentation.initialIndex ?? 0)
    }

    private func setTitle(at index: Int) {

        guard let model: YMCirclePickerModel = dataSource?.ymCirclePickerView(
            ymCirclePickerView: self,
            itemForIndex: index
            ) else { return }
        if let title = model.title {
            titleLabel.text = title
        }
    }

    private func scrollToItem(at index: Int) {

        let itemWidth = presentation?.layoutPresentation.itemSize.width ?? 0
        let horizontalInset = (collectionView.bounds.size.width - itemWidth) / 2.0
        let spacing = presentation?.layoutPresentation.spacing ?? 0.0
        let x = CGFloat(index) * (itemWidth + spacing) - horizontalInset
        collectionView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

    private func getSafeIndex(for index: Int) -> Int {

        var safeIndex = index
        if safeIndex >= count { safeIndex = (count - 1) }
        if safeIndex < 0 { safeIndex = 0 }
        return safeIndex
    }
}

// MARK: - UICollectionViewDataSource

extension YMCirclePickerView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        count = dataSource?.ymCirclePickerViewNumberOfItemsInPicker(ymCirclePickerView: self) ?? 0
        return count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YMCirclePickerCollectionViewCell.reuseIdentifier,
            for: indexPath
            ) as? YMCirclePickerCollectionViewCell,
            let model: YMCirclePickerModel = dataSource?.ymCirclePickerView(
                ymCirclePickerView: self,
                itemForIndex: indexPath.row
            ) else { return UICollectionViewCell() }

        if let image = model.image {
            cell.presentation = YMCirclePickerCollectionViewCellPresentation(image: image)
        }

        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension YMCirclePickerView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard canSelectItem else { return }
        canSelectItem = false

        let index = getSafeIndex(for: indexPath.item)

        scrollToItem(at: index)
        setTitle(at: index)
        delegate?.ymCirclePickerView(
            ymCirclePickerView: self,
            didSelectItemAt: index
        )
    }
}

// MARK: - UIScrollViewDelegate

extension YMCirclePickerView: UIScrollViewDelegate {

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        let itemSize: CGFloat = presentation?.layoutPresentation.itemSize.width ?? 0.0
        let offset = collectionView.bounds.width / 2.0 + collectionView.contentOffset.x - itemSize / 2.0
        let index = Int(round(offset / (itemSize + (presentation?.layoutPresentation.spacing ?? 0.0))))
        let safeIndex = getSafeIndex(for: index)
        delegate?.ymCirclePickerView(ymCirclePickerView: self, didSelectItemAt: safeIndex)
        setTitle(at: safeIndex)
        canSelectItem = true
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        canSelectItem = true
    }

    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        canSelectItem = true
    }
}

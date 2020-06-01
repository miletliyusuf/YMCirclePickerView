//
//  YMCirclePickerView.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 31.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

// MARK: - YMCirclePickerView

public struct YMCirclePickerViewPresentation {

    public var layoutPresentation: YMCirclePickerViewLayoutPresentation
}

// MARK: - YMCirclePickerViewDelegate

public protocol YMCirclePickerViewDelegate: AnyObject {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int)
}

public extension YMCirclePickerViewDelegate {

    func ymCirclePickerView(ymCirclePickerView: YMCirclePickerView, didSelectItemAt index: Int) {}
}

// MARK: - YMCirclePickerView

public class YMCirclePickerView: UIView, NibLoadable {

    // MARK: - Outlets

    @IBOutlet private weak var collectionView: UICollectionView!

    // MARK: - Properties

    weak var delegate: YMCirclePickerViewDelegate? = nil

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
    }
}

// MARK: - UICollectionViewDataSource

extension YMCirclePickerView: UICollectionViewDataSource {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return 0 //TODO
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: YMCirclePickerCollectionViewCell.reuseIdentifier,
            for: indexPath
            ) as? YMCirclePickerCollectionViewCell else { return UICollectionViewCell() }

        // TODO
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension YMCirclePickerView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        // TODO
    }
}

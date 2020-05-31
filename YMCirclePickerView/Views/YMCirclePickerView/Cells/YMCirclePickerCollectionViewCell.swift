//
//  YMCirclePickerCollectionViewCell.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 31.05.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

class YMCirclePickerCollectionViewCell: UICollectionViewCell, NibLoadable {

    /// ReuseIdentifier
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

//
//  YMCirclePickerModel.swift
//  YMCirclePickerView
//
//  Created by Yusuf Miletli on 1.06.2020.
//  Copyright © 2020 Miletli. All rights reserved.
//

import Foundation
import UIKit

/// Collection model conforming protocol
open class YMCirclePickerModel: NSObject {

    public var title: String?
    public var attributedTitle: NSAttributedString?
    public var image: UIImage?
    public var imageURL: URL?

    public override init() {

        super.init()
    }
}

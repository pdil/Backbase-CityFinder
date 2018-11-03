//
//  Mock.swift
//  Backbase-CityFinderTests
//
//  Created by Paolo Di Lorenzo on 11/3/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import Foundation
@testable import Backbase_CityFinder

class MockBundle: BundleProtocol {
    
    func url(forResource name: String?, withExtension ext: String?) -> URL? {
        return Bundle(for: MockBundle.self).url(forResource: name, withExtension: ext)
    }
    
}

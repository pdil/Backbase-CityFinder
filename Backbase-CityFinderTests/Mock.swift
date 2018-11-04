//
//  Mock.swift
//  Backbase-CityFinderTests
//
//  Created by Paolo Di Lorenzo on 11/3/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import UIKit
@testable import Backbase_CityFinder


class MockBundle: BundleProtocol {
    
    func url(forResource name: String?, withExtension ext: String?) -> URL? {
        return Bundle(for: MockBundle.self).url(forResource: name, withExtension: ext)
    }
    
}


class MockDataSource: NSObject, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
}

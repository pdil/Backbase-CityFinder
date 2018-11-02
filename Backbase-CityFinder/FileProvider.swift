//
//  FileProvider.swift
//  Backbase-CityFinder
//
//  Created by Paolo Di Lorenzo on 11/1/18.
//  Copyright © 2018 Paolo Di Lorenzo. All rights reserved.
//

import Foundation

struct FileProvider {
    
    /// The Bundle from which to retrieve the file.
    var bundle: Bundle
    
    /// The file's name.
    var fileName: String
    
    /// The file's extension.
    var fileExtension: String?
    
    init(fileName: String, fileExtension: String? = nil, bundle: Bundle = .main) {
        self.bundle = bundle
        self.fileName = fileName
        self.fileExtension = fileExtension
    }
    
    /**
     Returns the contents of file specified for this file provider.
     
     - returns: A `Data` representation of the contents of the file specified in the
        initializer of the receiver.
    */
    func contents() throws -> Data? {
        guard let url = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            return nil
        }
        
        return try Data(contentsOf: url)
    }
    
}

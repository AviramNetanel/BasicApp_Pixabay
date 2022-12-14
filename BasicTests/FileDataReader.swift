//
//  FileDataReader.swift
//  BasicTests
//
//  Created by Aviram Netanel on 03/12/2022.
//

import Foundation


class FileDataReader {
    
    func read(from fileName: String, fileExtension: String ) -> Data {
        let bundle = Bundle(for: FileDataReader.self)
        
        guard let path = bundle.url(forResource: fileName, withExtension: fileExtension) else {
            fatalError("File is expected")
        }
        
        do {
          return try Data(contentsOf: path)
        } catch {
            fatalError("Couldn't read data")
        }
    }
}

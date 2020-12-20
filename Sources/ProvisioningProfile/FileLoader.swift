//
//  FileLoader.swift
//  
//
//  Created by Chris Mash on 26/11/2020.
//

import Foundation

internal class FileLoader {
    
    internal enum Error: Swift.Error {
        case fileNotFound
        case incorrectEncoding
    }
    
    internal static func loadFile(bundle: Bundle,
                                  filename: String,
                                  extension ext: String,
                                  encoding: String.Encoding) throws -> String {
        
        guard let url = bundle.url(forResource: filename,
                                   withExtension: ext) else {
            // File doesn't exist in the bundle
            throw Error.fileNotFound
        }
        
        return try FileLoader.loadFile(url: url, encoding: encoding)
    }
    
    private static func loadFile(url: URL,
                                 encoding: String.Encoding) throws -> String {
        
        let data = try Data(contentsOf: url)
        guard let content = String(data: data, encoding: encoding) else {
            // Failed to convert data using supplied encoding
            throw Error.incorrectEncoding
        }
        
        return content
    }
    
}

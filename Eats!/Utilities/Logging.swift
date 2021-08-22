//
//  Logging.swift
//  Eats!
//              Basic logger we can expand to save to disk or cloud later.
//
//  Created by Randy Hill on 8/21/21.
//

import Foundation

class Log {
    enum Level {
        case info, debug, error
        
        // Match to colored emoji header string so different types of log output are quicker/easier to percieve in console.
        var header: String {
            switch self {
            case .info:     return "📗 "
            case .debug:    return "⚠️ "
            case .error:    return "🛑 "
            }
        }
    }

    static func info(_ message: String, filename:String = #file, functionName:String = #function, line:Int = #line) {
        logToCurrentOutput(Level.info.header + message, filename: filename, functionName: functionName, line: line)
    }
    
    static func error(_ message: String, filename:String = #file, functionName:String = #function, line:Int = #line) {
        logToCurrentOutput(Level.error.header + "ERROR: " + message, filename: filename, functionName: functionName, line: line)
    }
    
    // Force quit app but log reason why first.
    static func fail(_ message: String, filename:String = #file, functionName:String = #function, line:Int = #line) {
        logToCurrentOutput(Level.error.header + "TERMINATED APP DUE TO: " + message, filename: filename, functionName: functionName, line: line)
        fatalError()
    }

    static func assert(_ isTrue: Bool, _ message: String = "", filename:String = #file, functionName:String = #function, line:Int = #line) {
        if !isTrue {
            logToCurrentOutput(Level.debug.header + "Assert failure: " + message, filename: filename, functionName: functionName, line: line)
        }
    }

    private static func logToCurrentOutput(_ message: String, filename:String = #file, functionName:String = #function, line:Int = #line) {
        print("\(message)\nAt:\(filename), function: \(functionName), line: \(line)")
    }
}

//
//  File.swift
//  
//
//  Created by Arnav Anshul on 9/4/21.
//

import ArgumentParser
import Foundation

extension Command {
    struct Homebrew: ParsableCommand {
        static var configuration: CommandConfiguration {
            .init(
                commandName: "homebrew",
                abstract: "Setup Homebrew",
                subcommands: []
            )
        }

        func run() throws {
            try! Command.launch(tool: URL(fileURLWithPath: "/usr/bin/which"), arguments: ["brew"]) { (status, outputData, errorData) in
                let output = String(data: outputData, encoding: .utf8) ?? ""
                let error = String(data: errorData, encoding: .utf8) ?? ""
                print("done, status: \(status), output: \(output), error: \(error)")
            }
        }
    }

    static func launch(tool: URL, arguments: [String], completionHandler: @escaping (Int32, Data, Data) -> Void) throws {
        let task = Process()
        if #available(macOS 10.13, *) {
            task.executableURL = tool
            task.arguments = arguments

            let outputPipe = Pipe()
            let errorPipe = Pipe()

            task.standardOutput = outputPipe
            task.standardError = errorPipe

            try task.run()

            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

            completionHandler(task.terminationStatus, outputData, errorData)
        } else {
            // Fallback on earlier versions
        }

    }
}

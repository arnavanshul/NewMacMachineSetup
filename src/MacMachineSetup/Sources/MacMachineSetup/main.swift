//
//  main.swift
//
//
//  Created by Arnav Anshul on 9/4/21.
//

import ArgumentParser
import Foundation

enum Command {}

extension Command {
    struct Main: ParsableCommand {
        static let which = "/usr/bin/which"
        static var configuration: CommandConfiguration {
            .init(commandName: "macMachineSetup",
                  abstract: "A program to set up a new mac machine",
                  version: "0.0.1",
                  subcommands: [
                    Command.Homebrew.self
                  ])
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
            task.waitUntilExit()

            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

            completionHandler(task.terminationStatus, outputData, errorData)
        } else {
            // Fallback on earlier versions
        }
    }

    static func checkIfExists(commandString: String) throws -> Bool {
        var exists = false
        try Command.launch(tool: URL(fileURLWithPath: Command.Main.which), arguments: [commandString]) { (status, outputData, errorData) in
            let output = String(data: outputData, encoding: .utf8) ?? ""
            let error = String(data: errorData, encoding: .utf8) ?? ""
            print("Task completed\n")
            print("Status: \(status == 0 ? "Success" : "Failure")\n")
            if output.isEmpty == false {
                print("Output : \(output)\n")
                exists = output.hasSuffix(commandString)
            } else {
                print("Error : \(error)\n")
            }
        }

        return exists
    }
}

Command.Main.main()

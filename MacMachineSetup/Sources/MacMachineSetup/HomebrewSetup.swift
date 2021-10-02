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

//        @Argument(help: "The first number")
//        var factor1: Double
//
//        @Argument(help: "The second number")
//        var factor2: Double

        func run() throws {
//            let sum = self.factor1 + self.factor2
//            print("\(self.factor1) + \(self.factor2) = \(sum)")


//            print("About to run homebrew")
//            let task = Process()
//            task.launchPath = "/usr/bin/which"
//            task.arguments = ["brew"]
//
//            let pipe = Pipe()
//            task.standardOutput = pipe
//
//            task.launch()
//
//            let data = pipe.fileHandleForReading.readDataToEndOfFile()

//            task.waitUntilExit()

//            let output = String(data: data, encoding: .utf8)
//
//            print(output)

            try! Command.launch(tool: URL(fileURLWithPath: "/usr/bin/which"), arguments: ["brew"]) { (status, outputData) in
                let output = String(data: outputData, encoding: .utf8) ?? ""
                print("done, status: \(status), output: \(output)")
            }
        }
    }

    static func launch(tool: URL, arguments: [String], completionHandler: @escaping (Int32, Data) -> Void) throws {
//        let group = DispatchGroup()
//        let pipe = Pipe()
//        var standardOutData = Data()
//
//        group.enter()
//        let proc = Process()
//        if #available(macOS 10.13, *) {
//            proc.executableURL = tool
//        } else {
//            // Fallback on earlier versions
//        }
//        proc.arguments = arguments
//        proc.standardOutput = pipe.fileHandleForWriting
//        proc.terminationHandler = { _ in
//            print("Process now terminated with termination status \(proc.terminationStatus) and termination reason \(proc.terminationReason)")
//            proc.terminationHandler = nil
//            group.leave()
//        }
//
//        group.enter()
//        DispatchQueue.global().async {
//            // Doing long-running synchronous I/O on a global concurrent queue block
//            // is less than ideal, but I’ve convinced myself that it’s acceptable
//            // given the target ‘market’ for this code.
//
//            let data = pipe.fileHandleForReading.readDataToEndOfFile()
//            pipe.fileHandleForReading.closeFile()
//            DispatchQueue.main.async {
//                standardOutData = data
//                group.leave()
//            }
//        }
//
//        group.notify(queue: .main) {
//            completionHandler(proc.terminationStatus, standardOutData)
//        }
//
//        if #available(macOS 10.13, *) {
//            try proc.run()
//        } else {
//            // Fallback on earlier versions
//        }
//
//        // We have to close our reference to the write side of the pipe so that the
//        // termination of the child process triggers EOF on the read side.
//
//        pipe.fileHandleForWriting.closeFile()

        let task = Process()
        if #available(macOS 10.13, *) {
            task.executableURL = tool
            task.arguments = arguments

            let outputPipe = Pipe()
            let errorPipe = Pipe()

            task.standardOutput = outputPipe
            task.standardError = errorPipe

            task.terminationHandler = { terminatedTask in
                print("Task : \(terminatedTask.executableURL) \nTermination Status : \(terminatedTask.terminationStatus)\nTermination Reason : \(terminatedTask.terminationReason)")
                print("Termination Status : \(terminatedTask.terminationStatus)")
                print("Termination Reason : \(terminatedTask.terminationReason)")
            }

            try task.run()

            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

            let output = String(data: outputData, encoding: .utf8)
            let error = String(data: errorData, encoding: .utf8)

            print("Output \n\(output)")
            print("Error \n\(error)")

            completionHandler(task.terminationStatus, outputData)
        } else {
            // Fallback on earlier versions
        }

    }
}

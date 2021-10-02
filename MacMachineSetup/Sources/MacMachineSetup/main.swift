//
//  main.swift
//
//
//  Created by Arnav Anshul on 9/4/21.
//

import ArgumentParser

enum Command {}

extension Command {
    struct Main: ParsableCommand {
        static var configuration: CommandConfiguration {
            .init(commandName: "macMachineSetup",
                  abstract: "A program to set up a new mac machine",
                  version: "0.0.1",
                  subcommands: [
                    Command.Homebrew.self
                  ])
        }
    }
}

Command.Main.main()

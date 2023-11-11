//
//  File.swift
//  
//
//  Created by Arnav Anshul on 9/4/21.
//

import ArgumentParser
import Foundation

extension Command {
    /// Checks and installs Homebrew if needed
    /// Runs the following command `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`
    struct Homebrew: ParsableCommand {
        static var configuration: CommandConfiguration {
            .init(
                commandName: "brew",
                abstract: "Setup Homebrew",
                subcommands: []
            )
        }

        func run() throws {
            let installed = try Command.checkIfExists(commandString: Homebrew._commandName)
            if installed { return }
            
        }
    }
}

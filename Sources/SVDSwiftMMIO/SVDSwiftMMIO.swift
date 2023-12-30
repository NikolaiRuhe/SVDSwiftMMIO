import Foundation
import ArgumentParser
import SVD

@main
struct SVDSwiftMMIO: ParsableCommand {
    @Argument(help: "The SVD input file to parse.")
    var svdInputFile: String

    @Argument(help: "The output directory (will be created on demand).")
    var outputDirectory: String

    var outputDirectoryURL: URL { URL(filePath: outputDirectory, directoryHint: .isDirectory) }

    mutating func run() throws {
        let url = URL(filePath: svdInputFile, directoryHint: .notDirectory)
        let device = try Device(contentsOf: url)
        try createOutputDirectory()

        try device.createSourceFile(in: outputDirectoryURL)

        for peripheral in device.peripherals {
            try peripheral.createSourceFile(in: outputDirectoryURL)
        }
    }

    func createOutputDirectory() throws {
        let outputDirectoryURL = URL(filePath: outputDirectory, directoryHint: .isDirectory)

        var isDirectory: ObjCBool = false
        guard !FileManager.default.fileExists(atPath: outputDirectoryURL.path, isDirectory: &isDirectory) else {
            if isDirectory.boolValue { return }
            Self.exit(withError: SVDSwiftMMIOError(message: "not a directory: \(outputDirectory)"))
        }

        try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true)
    }
}

struct SVDSwiftMMIOError: Error { var message: String }



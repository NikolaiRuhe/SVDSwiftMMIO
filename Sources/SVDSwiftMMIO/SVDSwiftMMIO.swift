import Foundation
import ArgumentParser
import SVD

/// A command line tool that reads SVD files and emits swift source code.
@main
struct SVDSwiftMMIO: ParsableCommand, SourceCodeConfiguration {
    @Argument(help: "The SVD input file to parse.")
    var svdInputFile: String

    @Argument(help: "The output directory (will be created on demand).")
    var outputDirectory: String

    var outputDirectoryURL: URL { URL(filePath: outputDirectory, directoryHint: .isDirectory) }

    func run() throws {
        let url = URL(filePath: svdInputFile, directoryHint: .notDirectory)
        let device = try Device(contentsOf: url)
        try createOutputDirectory()

        let descriptors: [any SVDSwiftMMIOSourceGeneration] = device.peripherals + [device]
        for descriptor in descriptors {
            var source = GeneratedSourceCode(filename: descriptor.name.rawValue + ".swift", configuration: self)
            descriptor.appendSourceCode(to: &source)
            try source.writeToFile()
        }
    }

    func createOutputDirectory() throws {
        let outputDirectoryURL = URL(filePath: outputDirectoryURL.path, directoryHint: .isDirectory)

        var isDirectory: ObjCBool = false
        guard !FileManager.default.fileExists(atPath: outputDirectory, isDirectory: &isDirectory) else {
            if isDirectory.boolValue { return }
            Self.exit(withError: SVDSwiftMMIOError(message: "not a directory: \(outputDirectory)"))
        }

        try FileManager.default.createDirectory(at: outputDirectoryURL, withIntermediateDirectories: true)
    }
}

struct SVDSwiftMMIOError: Error { var message: String }

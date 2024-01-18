import Foundation

/// Collects lines of source code. Handles indentation in scopes.
struct GeneratedSourceCode {
    var filename: String
    var configuration: SourceCodeConfiguration
    var lines: [String] = []
    var indentation: Int = 0

    /// Append a chunk of source code. Lines will fixed for indentation level.
    static func +=(lhs: inout Self, rhs: String) -> Void {
        lhs.lines += rhs
            .split(separator: "\n", omittingEmptySubsequences: false)
            .map { $0.isEmpty ? "\n" : String(repeating: " ", count: lhs.indentation * 4) + $0 + "\n"}
    }

    /// Append a chunk of code with indentation.
    mutating func beginScope(_ prefix: () -> String, body: (inout Self) -> Void, endScope suffix: () -> String = { "}" }) {
        self += prefix()
        indentation += 1
        body(&self)
        indentation -= 1
        self += suffix()
    }

    /// Write the gathered source code to a file. Optionally perform macro
    /// expansion.
    func writeToFile() throws {
        let sourceURL = configuration.outputDirectoryURL.appending(path: filename)

        let sourceCode = lines.joined()
        let data = Data(sourceCode.utf8)

        print("writing \(sourceURL.lastPathComponent)")
        try data.write(to: sourceURL)
    }
}

protocol SourceCodeConfiguration {
    var outputDirectoryURL: URL { get }
}

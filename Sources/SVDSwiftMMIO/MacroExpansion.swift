import Foundation
import SwiftSyntax
import SwiftParser
import SwiftSyntaxMacros
import SwiftSyntaxMacroExpansion
import SwiftParserDiagnostics
import MMIOMacros
import MMIOUtilities


extension String {
    mutating func expandMacros() {

        // Parse the original source file.
        let origSourceFile = SwiftParser.Parser.parse(source: self)

        // Expand all macros in the source.
        let context = BasicMacroExpansionContext(
            sourceFiles: [origSourceFile: .init(moduleName: "TestModule", fullFilePath: "test.swift")]
        )

        let expandedSourceFile = origSourceFile.expand(
            macros: mmioMacros,
            in: context,
            indentationWidth: .spaces(4)
        )

        let diagnostics = ParseDiagnosticsGenerator.diagnostics(for: expandedSourceFile)
        if !diagnostics.isEmpty {
            fatalError(
            """
            Expanded source should not contain any syntax errors, but contains:
            \(diagnostics))

            Expanded syntax tree was:
            \(expandedSourceFile.debugDescription)
            """
            )
        }

        if context.diagnostics.count != diagnostics.count {
            fatalError("""
            Expected \(diagnostics.count) diagnostics but received \(context.diagnostics.count):
            \(context.diagnostics.map(\.debugDescription).joined(separator: "\n"))
            """)
        }

        // We have all MMIO macros expanded now.
        self = expandedSourceFile.description

        // For some unknown reason the register descriptor conformances lack
        // qualified names. We fix this using regular expressions.
        guard let peripheralName = self.firstMatch(of: #/public struct (?'name'\w+) {/#)?.name else {
            return
        }

        replace(
            #/extension (?'name'\w+): RegisterValue \{/#,
            with: { "extension \(peripheralName).\($0.name): RegisterValue {" }
        )
    }

    var mmioMacros: [String: Macro.Type] { [
        "RegisterBankMacro": RegisterBankMacro.self,
        "RegisterBank": RegisterBankScalarMemberMacro.self,
        "Register": RegisterMacro.self,
        "Reserved": ReservedMacro.self,
        "ReadWrite": ReadWriteMacro.self,
        "ReadOnly": ReadOnlyMacro.self,
        "WriteOnly": WriteOnlyMacro.self,

        // Currently, we're not using arrays of registers. When we do, we'll
        // probably need two passes of macro expansion, as the interface of
        // swift-Syntax' `expand` function does not allow to expand macros
        // with identical names.
        // "RegisterBank": RegisterBankArrayMemberMacro.self,
    ] }
}

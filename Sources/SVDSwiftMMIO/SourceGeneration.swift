import Foundation
import SVD

protocol SVDSwiftMMIOSourceGeneration {
    var name: SVD.Identifier { get }
    func appendSourceCode(to source: inout GeneratedSourceCode)
}

extension Device: SVDSwiftMMIOSourceGeneration {
    func appendSourceCode(to source: inout GeneratedSourceCode) {
        source += """
        // RP2040 System View Description

        import MMIO
        import MMIOExtensions
        """

        if !description.isEmpty {
            source += description.docComment
        }

        source += "public enum \(name.rawValue) {}"
    }
}

extension Peripheral: SVDSwiftMMIOSourceGeneration {
    func appendSourceCode(to source: inout GeneratedSourceCode) {
        source += """
        import MMIO
        import MMIOExtensions

        """

        if let description {
            source += description.docComment
        }

        source += "@RegisterBank"

        source.beginScope {
            "public struct \(name) {"
        } body: { source in
            source += """

            public static var `default`: Self { .init(unsafeAddress: \(baseAddress)) }

            """

            var isFirst = true
            for register in registers {
                if isFirst {
                    isFirst = false
                } else {
                    source += ""
                }
                register.appendSourceCode(to: &source)
            }
        }
    }
}

extension Register {
    func appendSourceCode(to source: inout GeneratedSourceCode) {
        if let description {
            source += description.docComment
        }

        source += "@RegisterBank(offset: \(addressOffset))"
        source += "public var \(name): Register<\(name)_Descriptor>"
        source += "\n"
        source += "@Register(bitWidth: \(size.value))"

        if fields.isEmpty {
            source += "public struct \(name)_Descriptor {}"
        } else {
            source.beginScope {
                "public struct \(name)_Descriptor {"
            } body: { source in
                var isFirst = true
                for field in fields {
                    if isFirst {
                        isFirst = false
                    } else {
                        source += ""
                    }
                    field.appendSourceCode(to: &source)
                }
            }
        }
    }
}

extension Register.Field {
    func appendSourceCode(to source: inout GeneratedSourceCode) {
        if let description {
            source += description.docComment
        }

        source += """
        \(access.mmioMacro)(bits: \(bitRange.swiftDescription), as: \(fieldType).self)
        public var \(name): \(name)_Field
        """

        if enumeratedValues.isEmpty { return }

        source.beginScope { """

            public enum \(fieldType): UInt, BitFieldProjectable {
            """
        } body: { source in
            for enumValue in enumeratedValues {
                if let description = enumValue.description {
                    source += description.docComment
                }
                let value = enumValue.value.map { " = \($0)" } ?? ""
                source += "case \(name.rawValue)_\(enumValue.name)\(value)"
            }
            source += """

            public static var bitWidth: Int { \(bitRange.count) }
            """
        }
    }

    var fieldType: String {
        enumeratedValues.isEmpty ? bitRange.count == 1 ? "Bool" : "BitField\(bitRange.count)" : "\(name.rawValue)_Values"
    }
}


extension BitRange {
    public var swiftDescription: String {
        "\(lsb)..<\(msb + 1)"
    }
}

extension Optional<Access> {
    var mmioMacro: String {
        switch self {
        case .readOnly:  "@ReadOnly"
        case .writeOnly: "@WriteOnly"
        case .readWrite: "@ReadWrite"
        default:         "@ReadWrite"
        }
    }
}

extension String {
    var docComment: String {
        self
            .split(separator: "\n")
            .flatMap { $0.split(separator: "\\n") }
            .map { "/// " + $0.trimmingCharacters(in: .whitespaces) }
            .joined(separator: "\n")
    }
}

extension Identifier {
    var swiftName: String { rawValue.lowercased() }
}

import Foundation
import SVD

protocol SVDSwiftMMIOSourceGeneration {
    var name: SVD.Identifier { get }
    var sourceCode: String { get }

    var sourceFilename: String { get }
    func createSourceFile(in directoryURL: URL) throws
}

extension SVDSwiftMMIOSourceGeneration {
    var sourceFilename: String {
        name.rawValue + ".swift"
    }

    func createSourceFile(in directoryURL: URL) throws {
        let data = sourceCode.data(using: .utf8)!
        let sourceURL = directoryURL.appending(path: sourceFilename)
        try data.write(to: sourceURL)
    }
}

extension Device: SVDSwiftMMIOSourceGeneration {

    public var sourceCode: String {
        """
        // RP2040 System View Description

        import MMIO
        import MMIOExtensions

        \(description.docComment(indentation: 0))
        public enum \(name.rawValue) {}
        """
    }
}

extension Peripheral: SVDSwiftMMIOSourceGeneration {
    public var sourceCode: String {
        """
        import MMIO
        import MMIOExtensions

        \(description?.docComment(indentation: 0) ?? "")@RegisterBank
        public struct \(name) {

            public static var `default`: Self { .init(unsafeAddress: \(baseAddress)) }

        \(registers.map {
            $0.swiftRegisterBankDescription
            + "\n\n"
            + $0.swiftDescription
        }.joined(separator: "\n\n"))
        }
        """
    }
}

extension Register {
    public var swiftRegisterBankDescription: String {
        """
        \(description?.docComment(indentation: 1) ?? "")    @RegisterBank(offset: \(addressOffset))
            public var \(name.rawValue.lowercased()): Register<\(name)>
        """
    }

    public var swiftDescription: String {
        """
            @Register(bitWidth: \(size.value))
            public struct \(name) {\(fields.isEmpty ? "" : "\n\(fields.map { $0.swiftDescription }.joined(separator: "\n\n"))\n")    }
        """
    }
}

extension Register.Field {
    public var swiftDescription: String {
        if enumeratedValues.isEmpty {
            return """
            \(description?.docComment(indentation: 2) ?? "")        @\(access?.swiftDescription ?? "ReadWrite")(bits: \(bitRange.swiftDescription)\(bitRange.count == 1 ? ", as: Bool.self" : ", as: BitField\(bitRange.count).self"))
                    public var \(name.rawValue.lowercased()): \(name.rawValue)_Field
            """
        }

        return """
        \(description?.docComment(indentation: 2) ?? "")        @\(access?.swiftDescription ?? "ReadWrite")(bits: \(bitRange.swiftDescription), as: \(name.rawValue)_Values.self)
                public var \(name.rawValue.lowercased()): \(name.rawValue)_Field

                public enum \(name.rawValue)_Values: UInt, BitFieldProjectable {
        \(enumeratedValues
            .map { "\($0.description?.docComment(indentation: 3) ?? "")            case \(name.rawValue)_\($0.name)\($0.value.map { " = \($0)"} ?? "")" }
            .joined(separator: "\n"))

                    public static var bitWidth: Int { \(bitRange.count) }
                }
        """
    }
}


extension BitRange {
    public var swiftDescription: String {
        "\(lsb)..<\(msb + 1)"
    }
}

extension Access {
    var swiftDescription: String {
        switch self {
        case .readOnly: return "ReadOnly"
        case .writeOnly: return "WriteOnly"
        case .readWrite: return "ReadWrite"
        default: return "ReadWrite"
        }
    }
}

extension String {
    func docComment(indentation: Int = 0) -> String {
        self
            .split(separator: "\n")
            .flatMap { $0.split(separator: "\\n") }
            .map { String(repeating: "    ", count: indentation) + "/// " + $0.trimmingCharacters(in: .whitespaces) + "\n" }
            .joined()
    }
}

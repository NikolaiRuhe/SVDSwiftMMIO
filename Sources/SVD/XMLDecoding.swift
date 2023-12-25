import Foundation

extension Device: XMLDecodable {

    /// Parse the SVD file at `url`.
    public init(contentsOf url: URL) throws {
        var node = try XMLNode(contentsOf: url)

        node.resolveSiblingReferences() // resolves "derivedFrom" attributes
        node.resolveParentReferences()  // resolves "registerPropertiesGroup"

        self = try Device(node)
    }

    fileprivate init(_ node: XMLNode) throws {
        self.vendor                  = try node.decode(\Self.vendor,                  forKey: "vendor")
        self.vendorID                = try node.decode(\Self.vendorID,                forKey: "vendorID")
        self.name                    = try node.decode(\Self.name,                    forKey: "name")
        self.series                  = try node.decode(\Self.series,                  forKey: "series")
        self.version                 = try node.decode(\Self.version,                 forKey: "version")
        self.description             = try node.decode(\Self.description,             forKey: "description")
        self.licenseText             = try node.decode(\Self.licenseText,             forKey: "licenseText")
        self.cpu                     = try node.decode(\Self.cpu,                     forKey: "cpu")
        self.headerSystemFilename    = try node.decode(\Self.headerSystemFilename,    forKey: "headerSystemFilename")
        self.headerDefinitionsPrefix = try node.decode(\Self.headerDefinitionsPrefix, forKey: "headerDefinitionsPrefix")
        self.addressUnitBits         = try node.decode(\Self.addressUnitBits,         forKey: "addressUnitBits")
        self.width                   = try node.decode(\Self.width,                   forKey: "width")
        self.peripherals             = try node.decode(\Self.peripherals,             forKey: "peripherals")
        self.vendorExtensions        = ()
    }
}

extension CPU: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        self.name                = try node.decode(\Self.name,                forKey: "name")
        self.revision            = try node.decode(\Self.revision,            forKey: "revision")
        self.endian              = try node.decode(\Self.endian,              forKey: "endian")
        self.mpuPresent          = try node.decode(\Self.mpuPresent,          forKey: "mpuPresent")
        self.fpuPresent          = try node.decode(\Self.fpuPresent,          forKey: "fpuPresent")
        self.fpuDP               = try node.decode(\Self.fpuDP,               forKey: "fpuDP")
        self.dspPresent          = try node.decode(\Self.dspPresent,          forKey: "dspPresent")
        self.icachePresent       = try node.decode(\Self.icachePresent,       forKey: "icachePresent")
        self.dcachePresent       = try node.decode(\Self.dcachePresent,       forKey: "dcachePresent")
        self.itcmPresent         = try node.decode(\Self.itcmPresent,         forKey: "itcmPresent")
        self.dtcmPresent         = try node.decode(\Self.dtcmPresent,         forKey: "dtcmPresent")
        self.vtorPresent         = try node.decode(\Self.vtorPresent,         forKey: "vtorPresent")
        self.nvicPrioBits        = try node.decode(\Self.nvicPrioBits,        forKey: "nvicPrioBits")
        self.vendorSystickConfig = try node.decode(\Self.vendorSystickConfig, forKey: "vendorSystickConfig")
        self.deviceNumInterrupts = try node.decode(\Self.deviceNumInterrupts, forKey: "deviceNumInterrupts")
    }
}

extension Peripheral: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        self.derivedFrom         = node.attributes["derivedFrom"].map { Identifier(rawValue: $0)! }
        self.name                = try node.decode(\Self.name,                forKey: "name")
        self.version             = try node.decode(\Self.version,             forKey: "version")
        self.description         = try node.decode(\Self.description,         forKey: "description")
        self.alternatePeripheral = try node.decode(\Self.alternatePeripheral, forKey: "alternatePeripheral")
        self.groupName           = try node.decode(\Self.groupName,           forKey: "groupName")
        self.prependToName       = try node.decode(\Self.prependToName,       forKey: "prependToName")
        self.appendToName        = try node.decode(\Self.appendToName,        forKey: "appendToName")
        self.headerStructName    = try node.decode(\Self.headerStructName,    forKey: "headerStructName")
        self.disableCondition    = try node.decode(\Self.disableCondition,    forKey: "disableCondition")
        self.baseAddress         = try node.decode(\Self.baseAddress,         forKey: "baseAddress")
        self.addressBlocks       = try node.decode(\Self.addressBlocks,       all: "addressBlock")
        self.interrupts          = try node.decode(\Self.interrupts,          all: "interrupt")
        self.registers           = try node.decode(\Self.registers,           forKey: "registers")
    }
}

extension AddressBlock: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        self.offset     = try node.decode(\Self.offset,     forKey: "offset")
        self.size       = try node.decode(\Self.size,       forKey: "size")
        self.usage      = try node.decode(\Self.usage,      forKey: "usage")
        self.protection = try node.decode(\Self.protection, forKey: "protection")
    }
}

extension Interrupt: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        self.name        = try node.decode(\Self.name,        forKey: "name")
        self.description = try node.decode(\Self.description, forKey: "description")
        self.value       = try node.decode(\Self.value,       forKey: "value")
    }
}

extension Register: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        self.derivedFrom         = node.attributes["derivedFrom"].map { Identifier(rawValue: $0)! }
        self.name                = try node.decode(\Self.name,                forKey: "name")
        self.displayName         = try node.decode(\Self.displayName,         forKey: "displayName")
        self.description         = try node.decode(\Self.description,         forKey: "description")
        self.alternateGroup      = try node.decode(\Self.alternateGroup,      forKey: "alternateGroup")
        self.alternateRegister   = try node.decode(\Self.alternateRegister,   forKey: "alternateRegister")
        self.addressOffset       = try node.decode(\Self.addressOffset,       forKey: "addressOffset")
        self.size                = try node.decode(\Self.size,                forKey: "size")
        self.access              = try node.decode(\Self.access,              forKey: "access")
        self.protection          = try node.decode(\Self.protection,          forKey: "protection")
        self.resetValue          = try node.decode(\Self.resetValue,          forKey: "resetValue")
        self.resetMask           = try node.decode(\Self.resetMask,           forKey: "resetMask")
        self.dataType            = try node.decode(\Self.dataType,            forKey: "dataType")
        self.modifiedWriteValues = try node.decode(\Self.modifiedWriteValues, forKey: "modifiedWriteValues")
        self.writeConstraint     = try node.decode(\Self.writeConstraint,     forKey: "writeConstraint")
        self.readAction          = try node.decode(\Self.readAction,          forKey: "readAction")
        self.fields              = try node.decode(\Self.fields,              forKey: "fields")
    }
}

extension Register.Field: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        self.derivedFrom         = node.attributes["derivedFrom"].map { Identifier(rawValue: $0)! }
        self.name                = try node.decode(\Self.name,                forKey: "name")
        self.description         = try node.decode(\Self.description,         forKey: "description")
        self.bitRange            = try node.decode(\Self.bitRange,            forKey: "bitRange")
        self.access              = try node.decode(\Self.access,              forKey: "access")
        self.modifiedWriteValues = try node.decode(\Self.modifiedWriteValues, forKey: "modifiedWriteValues")
        self.writeConstraint     = try node.decode(\Self.writeConstraint,     forKey: "writeConstraint")
        self.readAction          = try node.decode(\Self.readAction,          forKey: "readAction")
        self.enumeratedValues    = try node.decode(\Self.enumeratedValues,    forKey: "enumeratedValues")
    }
}

extension Register.Field.EnumeratedValue: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        self.name        = try node.decode(\Self.name,        forKey: "name")
        self.description = try node.decode(\Self.description, forKey: "description")
        self.value       = try node.decode(\Self.value,       forKey: "value")
        self.isDefault   = try node.decode(\Self.isDefault,   forKey: "isDefault")
    }
}

public struct XMLError: Error {
    public var message: String
    public init(_ message: String) { self.message = message }
}


fileprivate struct XMLNode {
    var name: String
    var children: [XMLNode] = []
    var attributes: [String: String]
    var characters: String = ""

    init(contentsOf url: URL) throws {
        guard let parser = XMLParser(contentsOf: url) else { throw XMLError("can't read \(url)") }
        let delegate = ParserDelegate()
        parser.delegate = delegate
        guard parser.parse() else { throw XMLError("parsing error: \(parser.parserError?.localizedDescription ?? "")") }

        guard let root = delegate.stack.popLast() else { throw XMLError("internal parser error") }
        guard delegate.stack.isEmpty else { throw XMLError("internal parser error") }
        guard let node = root.children.first else { throw XMLError("internal parser error") }

        self = node
    }

    init(name: String, attributes: [String: String]) {
        self.name = name
        self.attributes = attributes
    }

    var string: String {
        get throws {
            guard children.isEmpty && attributes.isEmpty else {
                throw XMLError("expected a string in \(name)")
            }
            return characters
        }
    }

    func description(depth: Int = 0) -> String {
        if characters.isEmpty {
            return String(repeating: " ", count: 4 * depth)
            + "<\(name)>"
            + children.map { $0.description(depth: depth + 1) }.joined()
            + "</\(name)>"
        } else {
            return String(repeating: " ", count: 4 * depth) + "<\(name)>" + characters + "<\(name)>"
        }
    }

    subscript(_ name: String) -> XMLNode? {
        children.first(where: { $0.name == name })
    }

    /// resolve "derivedFrom" attributes
    mutating func resolveSiblingReferences() {
        for index in children.indices {
            children[index].resolveSiblingReferences()
            guard let prototypeName = children[index].attributes["derivedFrom"] else { continue }
            guard let prototype = children.first(where: { $0["name"]?.characters == prototypeName }) else {
                print("warning: prototype not found: \(prototypeName)")
                continue
            }
            children[index].copyDerivedProperties(from: prototype)
        }
    }

    mutating func copyDerivedProperties(from prototype: XMLNode) {
        for prototypeChild in prototype.children {
            if !children.contains(where: { $0.name == prototypeChild.name }) {
                children.append(prototypeChild)
            }
        }
    }

    /// resolve "registerPropertiesGroup" elements
    mutating func resolveParentReferences() {
        let registerProperties = ["size", "access", "protection", "resetValue", "resetMask"]

        passProperties(registerProperties, toChildrenIn: "peripherals") { peripheral in
            peripheral.passProperties(registerProperties, toChildrenIn: "registers") { register in
                register.passProperties(["access"], toChildrenIn: "fields") { _ in }
            }
        }
    }

    mutating func passProperties(_ propertyNames: [String], toChildrenIn containerName: String, drillDown: (inout XMLNode) -> Void) {
        let properties = propertyNames.compactMap { self[$0] }
        guard let containerIndex = children.firstIndex(where: { $0.name == containerName }) else {
            return
        }
        func withChildrenOfContainer(body: (inout XMLNode) -> Void) {
            for index in children[containerIndex].children.indices {
                body(&children[containerIndex].children[index])
            }
        }
        withChildrenOfContainer { child in
            for property in properties {
                if child.children.contains(where: { $0.name == property.name }) { continue }
                child.children.append(property)
            }
            drillDown(&child)
        }
    }

    func decode<X, T: XMLDecodable>(_ keyPath: KeyPath<X, T>, forKey key: String) throws -> T {
        guard let node = self[key] else {
            throw XMLError("missing element: \(name).\(key)")
        }
        return try T(node)
    }

    func decode<X, T: XMLDecodable>(_ keyPath: KeyPath<X, Optional<T>>, forKey key: String) throws -> T? {
        guard let node = self[key] else {
            return nil
        }
        return try T(node)
    }

    func decode<X, T: XMLDecodable>(_ keyPath: KeyPath<X, Array<T>>, forKey key: String) throws -> [T] {
        guard let node = self[key] else {
            return []
        }
        return try node.children.map { try T($0) }
    }

    func decode<X, T: XMLDecodable>(_ keyPath: KeyPath<X, Array<T>>, all key: String) throws -> [T] {
        try children
            .filter { $0.name == key }
            .map { try T($0) }
    }

    final class ParserDelegate: NSObject, XMLParserDelegate {
        var stack: [XMLNode] = [XMLNode(name: "root", attributes: [:])]

        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
            stack.append(XMLNode(name: elementName, attributes: attributeDict))
        }

        func parser(_ parser: XMLParser, foundCharacters string: String) {
            stack[stack.endIndex - 1].characters += string
        }

        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
            var node = stack.popLast()!
            node.characters = node.characters.trimmingCharacters(in: .whitespacesAndNewlines)

            if !node.characters.isEmpty && !(node.attributes.isEmpty && node.children.isEmpty) {
                fatalError("mixed elements not supported")
            }
            stack[stack.endIndex - 1].children.append(node)
        }
    }
}


fileprivate protocol XMLDecodable {
    init(_ node: XMLNode) throws
}

extension String: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws { self = try node.string }
}

extension ScaledNonNegativeInteger: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        var string = Substring(try node.string.lowercased())

        switch string.last {
        case "k": self.shift = 10; string = string.dropLast()
        case "m": self.shift = 20; string = string.dropLast()
        case "g": self.shift = 30; string = string.dropLast()
        case "t": self.shift = 40; string = string.dropLast()
        default:  self.shift = 0
        }

        var radix = 10
        if string.hasPrefix("0x") {
            string = string.dropFirst(2)
            radix = 16
        } else if string.hasPrefix("0b") {
            string = string.dropFirst(2)
            radix = 2
        } else if string.hasPrefix("#") {
            string = string.dropFirst(1)
            radix = 2
        }

        guard let base = Int(string, radix: radix) else {
            throw XMLError("conversion error")
        }
        self.base = base
    }
}

extension BitRange: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        let string = Substring(try node.string)
        guard string.first == "[" && string.last == "]" else {
            throw XMLError("conversion error")
        }
        let components = string.dropFirst().dropLast().split(separator: ":")
        guard components.count == 2 else {
            throw XMLError("conversion error")
        }
        guard let msb = Int(components[0]), let lsb = Int(components[1]) else {
            throw XMLError("conversion error")
        }
        self.lsb = lsb
        self.msb = msb
    }

}

extension Bool: XMLDecodable {
    fileprivate init(_ node: XMLNode) throws {
        switch try node.string.lowercased() {
        case "1", "true":  self = true
        case "0", "false": self = false
        default:           throw XMLError("conversion error")
        }
    }
}

extension XMLDecodable where Self: RawRepresentable, RawValue == String {
    init(_ node: XMLNode) throws {
        guard let value = Self.init(rawValue: try node.string) else {
            throw XMLError("conversion error")
        }
        self = value
    }
}

extension Identifier: XMLDecodable {}
extension Access: XMLDecodable {}

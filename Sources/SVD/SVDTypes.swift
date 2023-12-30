// The types defined in this file are a representation of the CMSIS "System View
// Description" implemented in Swift.
//
// See https://www.keil.com/pack/doc/CMSIS/SVD/html/index.html
//
// The Swift implementation leaves out various details, like arrays of
// registers, which are not used in the RP2040 SVD file. It also presents a
// flattened view where references and default values are already resolved.
//
// The Swift implementation was derived from [SVD Schema File v1.3.9](https://github.com/ARM-software/CMSIS_5/blob/develop/CMSIS/Utilities/CMSIS-SVD.xsd)
//
// A similar C++ model code can be found here: https://github.com/Open-CMSIS-Pack/devtools/tree/main/tools/svdconv/SVDModel
//
//
// ----------------------- SVD File Structure: ---------------------------------
//
//            ╔════════╗
//            ║ Device ║         One Device ...
//            ╚════╤═══╝
//          ┌──────┴──────┐
//    ╔═════╧══════╗   ╔══╧══╗
//    ║ Peripheral ║   ║ CPU ║   ... contains one CPU description ...
//    ╚═════╤══════╝   ╚═════╝   ... and one or more peripherals.
//     ╔════╧═════╗
//     ║ Register ║              Peripherals contain zero or more registers, ...
//     ╚════╤═════╝
//      ╔═══╧═══╗
//      ║ Field ║                ... each containing zero or more fields.
//      ╚═══════╝
//

import Foundation


public struct Device {

    /// The vendor of the device using the full name.
    public var vendor: String?

    /// The vendor abbreviation without spaces or special characters.
    ///
    /// A short name for referring to the vendor (e.g. Texas Instruments = TI).
    /// This information is used to define the directory.
    public var vendorID: Identifier?

    /// Identifies the device or device series. Device names are required to be
    /// unique.
    public var name: Identifier

    /// Name of the device series
    public var series: String?

    /// The version of the SVD file.
    ///
    /// Silicon vendors maintain the description throughout the life-cycle of
    /// the device and ensure that all updated and released copies have a unique
    /// version string. Higher numbers indicate a more recent version.
    public var version: String

    /// Describe the main features of the device (for example CPU, clock
    /// frequency, peripheral overview).
    public var description: String

    /// This text will be copied into the header section of the generated device
    /// header file and shall contain the legal disclaimer.
    ///
    /// New lines can be inserted by using \n. This section is mandatory if the
    /// SVD file is used for generating the device header file.
    public var licenseText: String?

    /// Specifies the details of the processor included in the device.
    public var cpu: CPU?

    /// Specifies the filename without extension of the CMSIS System Device
    /// include file.
    ///
    /// This tag is used by the header file generator for customizing the
    /// include statement referencing the CMSIS system file within the CMSIS
    /// device header file. By default the filename is "system_<device.name>" In
    /// cases a device series shares a single system header file, the name of
    /// the series shall be used instead of the individual device name.
    public var headerSystemFilename: Identifier?

    /// Specifies the string being prepended to all names of types defined in
    /// generated device header file.
    public var headerDefinitionsPrefix: Identifier?

    /// Specifies the size of the minimal addressable unit in bits.
    ///
    /// Define the number of data bits uniquely selected by each address.
    /// The value for Cortex-M-based devices is 8 (byte-addressable).
    public var addressUnitBits: ScaledNonNegativeInteger

    /// The number of data bit-width of the maximum single data transfer
    /// supported by the bus infrastructure. This information is relevant for
    /// debuggers when accessing registers, because it might be required to
    /// issue multiple accesses for resources of a bigger size. The expected
    /// value for Cortex-M-based devices is 32.
    /// 
    /// This sets the maximum size of a single register that can be defined for
    /// an address space
    public var width: ScaledNonNegativeInteger

    // NOTE: `registerPropertiesGroup` elements are flattened into registers.

    /// All peripherals. At least one peripheral must be present in a valid SVD
    /// file.
    public var peripherals: [Peripheral]

    // NOTE: vendorExtensions are not supported by this implementation.
    public var vendorExtensions: Void
}

public struct CPU {
    /// ARM processor name: Cortex-Mx / SCxxx
    public var name: String

    /// The Hardware revision of the processor.
    ///
    /// The version format is rNpM (N,M = [0 - 99]).
    public var revision: String

    /// Specifies the endianess of the processor/device. One of `little`, `big`
    /// `selectable`, `other`
    public var endian: String

    /// Indicate whether the processor is equipped with a memory protection unit
    /// (MPU).
    public var mpuPresent: Bool?

    /// Indicate whether the processor is equipped with a hardware floating
    /// point unit (FPU). Cortex-M4, Cortex-M7, Cortex-M33 and Cortex-M35P are
    /// the only available Cortex-M processor with an optional FPU.
    public var fpuPresent: Bool?

    /// Indicate whether the processor is equipped with a double precision
    /// floating point unit. This element is valid only when <fpuPresent> is set
    /// to true. Currently, only Cortex-M7 processors can have a double
    /// precision floating point unit.
    public var fpuDP: Bool?

    /// Indicates whether the processor implements the optional SIMD DSP
    /// extensions (DSP). Cortex-M33 and Cortex-M35P are the only available
    /// Cortex-M processor with an optional DSP extension. For ARMv7M SIMD DSP
    /// extensions are a mandatory part of Cortex-M4 and Cortex-M7.
    public var dspPresent: Bool?

    /// Indicate whether the processor has an instruction cache. Note: only for
    /// Cortex-M7-based devices.
    public var icachePresent: Bool?

    /// Indicate whether the processor has a data cache. Note: only for
    /// Cortex-M7-based devices.
    public var dcachePresent: Bool?

    /// Indicate whether the processor has an instruction tightly coupled
    /// memory. Note: only an option for Cortex-M7-based devices.
    public var itcmPresent: Bool?

    /// Indicate whether the processor has a data tightly coupled memory.
    /// Note: only for Cortex-M7-based devices.
    public var dtcmPresent: Bool?

    /// Indicate whether the Vector Table Offset Register (VTOR) is implemented
    /// in Cortex-M0+ based devices. If not specified, then VTOR is assumed to
    /// be present.
    public var vtorPresent: Bool?

    /// Define the number of bits available in the Nested Vectored Interrupt
    /// Controller (NVIC) for configuring priority.
    public var nvicPrioBits: ScaledNonNegativeInteger

    /// Indicate whether the processor implements a vendor-specific System Tick
    /// Timer. If false, then the Arm-defined System Tick Timer is available.
    /// If true, then a vendor-specific System Tick Timer must be implemented.
    public var vendorSystickConfig: Bool

    /// The total number of interrupts implemented by the device.
    public var deviceNumInterrupts: ScaledNonNegativeInteger?

    // NOTE: Support for `sauRegions` not implemented.
}

public struct Peripheral {

    // If set, this peripheral is a verbatim copy of the named prototype.
    public var derivedFrom: Identifier?

    // NOTE: support for dimElementGroup not implemented

    /// The name of a peripheral. This name is used for the System View and
    /// device header file.
    public var name: Identifier

    /// The version of the peripheral description.
    public var version: String?

    /// Provides a high level functional description of the peripheral.
    public var description: String?

    /// Alternative description for an address range that is already fully
    /// by a peripheral described. In this case the peripheral name must be
    /// unique within the device description.
    public var alternatePeripheral: Identifier?

    /// Assigns this peripheral to a group of peripherals.
    /// This is only used bye the System View.
    public var groupName: String?

    /// A prefix that is placed in front of each register name of this
    /// peripheral. The device header file will show the registers in a C-Struct
    /// of the peripheral without the prefix.
    public var prependToName: Identifier?

    /// Postfix that is appended to each register name of this peripheral.
    /// The device header file will sho the registers in a C-Struct of the
    /// peripheral without the postfix.
    public var appendToName: Identifier?

    /// The name for the peripheral structure typedef used in the device header
    /// generation instead of the peripheral name.
    public var headerStructName: Identifier?

    /// Contains a logical expression based on constants and register or
    /// bit-field values. If the condition is evaluated to true, the peripheral
    /// display will be disabled.
    public var disableCondition: String?

    /// The absolute base address of a peripheral.
    public var baseAddress: ScaledNonNegativeInteger

    // NOTE: `registerPropertiesGroup` elements are flattened into registers.

    /// One or more address ranges that are assigned exclusively to this
    /// peripheral.
    public var addressBlocks: [AddressBlock]

    /// One or more interrupts by name, description and value.
    public var interrupts: [Interrupt]

    /// `registers` contains all registers owned by the peripheral.
    public var registers: [Register]

    // NOTE: Support for register clusters not implemented.
}

/// An address range uniquely mapped to this peripheral.
///
/// A peripheral must have at least one address block.
public struct AddressBlock {

    /// The start address of an address block relative to the peripheral
    /// baseAddress.
    public var offset: ScaledNonNegativeInteger

    /// The number of addressUnitBits being covered by this address block.
    /// The end address of an address block results from the sum of baseAddress,
    /// offset, and (size - 1).
    public var size: ScaledNonNegativeInteger

    /// The following predefined values can be used:
    /// `registers`, `buffer`, `reserved`
    public var usage: String

    /// Set the protection level for an address block.
    public var protection: String?
}

/// A peripheral can have multiple interrupts. This entry allows the debugger
/// to show interrupt names instead of interrupt numbers.
public struct Interrupt {
    public var name: String
    public var description: String?
    public var value: ScaledNonNegativeInteger
}

/// A register can represent a single value or can be subdivided into individual
/// bit-fields of specific functionality and semantics.
///
/// The description of registers is the most essential part of SVD.

public struct Register {

    // If set, this register is a verbatim copy of the named register.
    public var derivedFrom: Identifier?

    /// String to identify the register. Register names are required to be
    /// unique within the scope of a peripheral.
    public var name: Identifier

    /// When specified, then this string can be used by a graphical frontend to
    /// visualize the register. Otherwise the name element is displayed.
    public var displayName: String?

    /// A reference manual level description about the register and its purpose.
    public var description: String?

    /// Specifies a group name associated with all alternate register that have
    /// the same name. At the same time, it indicates that there is a register
    /// definition allocating the same absolute address in the address space.
    public var alternateGroup: Identifier?

    /// This tag can reference a register that has been defined above to current
    /// location in the description and that describes the memory location
    /// already. This tells the SVDConv's address checker that the redefinition
    /// of this particular register is intentional. The register name needs to
    /// be unique within the scope of the current peripheral. A register
    /// description is defined either for a unique address location or could be
    /// a redefinition of an already described address. In the latter case, the
    /// register can be either marked alternateRegister and needs to have a
    /// unique name, or it can have the same register name but is assigned to a
    /// register subgroup through the tag alternateGroup (specified in version
    /// 1.0).
    public var alternateRegister: Identifier?

    /// The address of the register relative to the baseOffset of the
    /// peripheral.
    public var addressOffset: ScaledNonNegativeInteger

    /// The bit width of the register.
    public var size: ScaledNonNegativeInteger

    /// Access rights of the register.
    public var access: Access?

    /// Protection rights of the register.
    public var protection: String?

    /// Value of the register at reset.
    public var resetValue: ScaledNonNegativeInteger?

    /// Identifies which register bits have a defined reset value.
    public var resetMask: ScaledNonNegativeInteger?

    /// CMSIS compliant native dataType for a register (i.e. signed, unsigned,
    /// pointer)
    public var dataType: String?

    /// Manipulation of data written to a register. If not specified, the value
    /// written to the field is the value stored in the field. The other options
    /// define bitwise operations.
    public var modifiedWriteValues: String?

    /// Three mutually exclusive options exist to set write-constraints:
    /// `writeAsRead`, `useEnumeratedValues`, `range`
    public var writeConstraint: String?

    /// If set, it specifies the side effect following a read operation. If not
    /// set, the register is not modified.
    public var readAction: String?

    /// Contains all fields that belong to this register, if any.
    public var fields: [Field]

    /// A bit-field has a name that is unique within the register.
    ///
    /// A field may define an enumeratedValue in order to make the display more
    /// intuitive to read.
    public struct Field {

        // If set, this field is a verbatim copy of the named field.
        public var derivedFrom: Identifier?

        /// Name string used to identify the field. Field names must be unique
        /// within a register.
        public var name: Identifier

        /// Reference manual level information about the function and options of
        /// a field.
        public var description: String?

        // NOTE: support for bitRangeLsbMsbStyle/bitRangeOffsetWidthStyle not implemented

        /// Bit field described by [<msb>:<lsb>].
        public var bitRange: BitRange

        /// Predefined permissions for the field.
        public var access: Access?

        /// Manipulation of data written to a field. If not specified, the value
        /// written to the field is the value stored in the field. The other
        /// options are bitwise operations.
        public var modifiedWriteValues: String?

        /// Three mutually exclusive options exist to set write-constraints:
        /// `writeAsRead`, `useEnumeratedValues`, `range`
        public var writeConstraint: String?

        /// If set, it specifies the side effect following a read operation. If
        /// not set, the register is not modified.
        public var readAction: String?

        public var enumeratedValues: [EnumeratedValue]

        /// The concept of enumerated values creates a map between unsigned
        /// integers and an identifier string.
        ///
        /// In addition, a description string can be associated with each entry
        /// in the map.
        public struct EnumeratedValue {
            public var name: Identifier
            public var description: String?
            public var value: String?
            public var isDefault: Bool?
        }
    }
}

/// A string that is a valid C identifier.
public struct Identifier: RawRepresentable, CustomStringConvertible {
    public init() { self.rawValue = "_" }
    public init?(rawValue: String) { self.rawValue = rawValue }
    public var rawValue: String
    public var description: String { rawValue }
}

public struct ScaledNonNegativeInteger: CustomStringConvertible {
    public var base: Int
    public var shift: Int

    public init(_ base: Int = 0, shift: Int = 0) {
        self.base = base
        self.shift = shift
    }

    public var value: Int { base << shift }

    public var description: String {
        var suffix: String {
            switch shift {
            case 0:  ""
            case 10: "k"
            case 20: "M"
            case 30: "G"
            case 40: "T"
            default: fatalError("unexpected shift value")
            }
        }
        if value < 65536 {
            return String(format: "0x%04x", value) + suffix
        } else {
            return String(format: "0x%08x", value) + suffix
        }
    }
}

public struct BitRange: CustomStringConvertible {
    public var lsb: Int
    public var msb: Int
    public var count: Int { msb - lsb + 1 }

    public init(lsb: Int = 0, msb: Int = 0) {
        self.lsb = lsb
        self.msb = msb
    }

    public var description: String { "[\(msb):\(lsb)]" }
}

public enum Access: String {
    case readOnly = "read-only"
    case writeOnly = "write-only"
    case readWrite = "read-write"
    case writeOnce = "writeOnce"
    case readWriteOnce = "read-writeOnce"
}

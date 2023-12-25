import XCTest
import SVD

final class SVDTests: XCTestCase {
    func testSVDPicoSDKIntegrity() throws {
        let device = try SVD.Device(contentsOf: PicoSDK.rp2040HardwareSVDURL)

        XCTAssertFalse(device.peripherals.isEmpty)

        for peripheral in device.peripherals {
            XCTAssertFalse(peripheral.registers.isEmpty)
        }
    }

    func testSVDPicoSDKDump() throws {
        let device = try SVD.Device(contentsOf: PicoSDK.rp2040HardwareSVDURL)
        for peripheral in device.peripherals {
            print(
                "Peripheral: \(peripheral.name)"
                + (peripheral.derivedFrom.map { " (derived from \($0))" } ?? "")
                + " @ \(peripheral.baseAddress)"
            )

            for register in peripheral.registers {
                print(
                    "    Register: \(register.name) @ \(register.addressOffset)"
                )

                for field in register.fields {
                    print("        Field: \(field.name) \(field.bitRange)")
                }
            }
        }
    }
}

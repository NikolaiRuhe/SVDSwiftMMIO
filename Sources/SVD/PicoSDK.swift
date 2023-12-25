import Foundation


public struct PicoSDK {

    /// The base URL of the installed Pico SDK
    public static let url: URL = locatePicoSDK()

    /// URL of the RP2040's SVD file in the SDK
    public static let rp2040HardwareSVDURL = url.appending(path: "src/rp2040/hardware_regs/rp2040.svd", directoryHint: .notDirectory)
}


private func locatePicoSDK() -> URL {
    func picoSDKURL(at path: String, appending pathComponent: String? = nil) -> URL? {
        var url = URL(fileURLWithPath: path, isDirectory: true)
        if let pathComponent {
            url = url.appending(component: pathComponent, directoryHint: .isDirectory)
        }
        let versionUrl = url.appending(path: "pico_sdk_version.cmake", directoryHint: .isDirectory)
        return FileManager.default.fileExists(atPath: versionUrl.path, isDirectory: nil) ? url : nil
    }

    if let path = ProcessInfo.processInfo.environment["PICO_SDK_PATH"],
       let url = picoSDKURL(at: path) {
        return url
    }
    var searchURL = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()

    repeat {
        if let url = picoSDKURL(at: searchURL.path, appending: "pico-sdk") {
            return url
        }
        searchURL.deleteLastPathComponent()
    } while !searchURL.path().isEmpty

    fatalError("PICO_SDK_PATH not set. Can't find Pico SDK.")
}

# SVDSwiftMMIO

The SVDSwiftMMIO tool reads ["System View Description"](https://www.keil.com/pack/doc/CMSIS/SVD/html/index.html) (SVD) files and emits
Swift source code from the contained peripheral descriptions.

The emitted code (a "Peripheral Access Package") provides access to the MCU's
memory mapped registers. It is based on [Swift MMIO](https://github.com/apple/swift-mmio).

### Usage

I'm currently using the tool to generate source code for the RP2040: 

    > SVDSwiftMMIO $(PICO_SDK_PATH)/src/rp2040/hardware_regs/rp2040.svd ~/Desktop/RP2040MMIO

This will generate a folder "RP2040MMIO" on your Desktop containing a swift
implementation file for each of the RP2040's peripherals.  

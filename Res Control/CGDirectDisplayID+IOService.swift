//
//  CGDirectDisplayID+IOService.swift
//  Res Switcher
//
//  Created by Doug Mason on 1/2/21.
//

import Foundation

extension CGDirectDisplayID {
    func productName() -> String? {
        let ioServicePort = self.getIOService()
        if ioServicePort == 0 {
            print("Can not get valid io_service_t.")
            return nil
        }
        
        guard let info = IODisplayCreateInfoDictionary(ioServicePort, UInt32(kIODisplayOnlyPreferredName)).takeRetainedValue() as? [String : AnyObject] else {
            print("IODisplayCreateInfoDictionary can not convert to [String : AnyObject]")
            return nil
        }
        
        if let productName = info["DisplayProductName"] as? [String : String],
           let firstKey = Array(productName.keys).first {
            return productName[firstKey]!
        }
        
        return nil
    }
    
    private func getIOService() -> io_service_t {
        var serialPortIterator = io_iterator_t()
        var ioServ: io_service_t = 0

        let matching = IOServiceMatching("IODisplayConnect")

        let kernResult = IOServiceGetMatchingServices(kIOMasterPortDefault, matching, &serialPortIterator)
        if KERN_SUCCESS == kernResult && serialPortIterator != 0 {
            ioServ = IOIteratorNext(serialPortIterator)

            while ioServ != 0 {
                let info = IODisplayCreateInfoDictionary(ioServ, UInt32(kIODisplayOnlyPreferredName)).takeRetainedValue() as NSDictionary as! [String: AnyObject]
                let venderID = info[kDisplayVendorID] as? UInt32
                let productID = info[kDisplayProductID] as? UInt32
                let serialNumber = info[kDisplaySerialNumber] as? UInt32 ?? 0

                if CGDisplayVendorNumber(self) == venderID &&
                    CGDisplayModelNumber(self) == productID &&
                    CGDisplaySerialNumber(self) == serialNumber {
                    print("found the target io_service_t")
                    break
                }

                ioServ = IOIteratorNext(serialPortIterator)
            }

            IOObjectRelease(serialPortIterator)
        }

        return ioServ
    }
}

 

#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit



// MARK: - Initializers
public extension UIColor {
	
	/// SwifterSwift: Create UIColor from hexadecimal value with optional transparency.
	///
	/// - Parameters:
	///   - hex: hex Int (example: 0xDECEB5).
	///   - transparency: optional transparency value (default is 1).
    convenience init?(hex: Int, transparency: CGFloat = 1) {
		var trans = transparency
		if trans < 0 { trans = 0 }
		if trans > 1 { trans = 1 }
		
		let red = (hex >> 16) & 0xff
		let green = (hex >> 8) & 0xff
		let blue = hex & 0xff
		self.init(red: red, green: green, blue: blue, transparency: trans)
	}
	
	/// SwifterSwift: Create UIColor from hexadecimal string with optional transparency (if applicable).
	///
	/// - Parameters:
	///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
	///   - transparency: optional transparency value (default is 1).
    convenience init?(hexString: String, transparency: CGFloat = 1) {
		var string = ""
		if hexString.lowercased().hasPrefix("0x") {
			string =  hexString.replacingOccurrences(of: "0x", with: "")
		} else if hexString.hasPrefix("#") {
			string = hexString.replacingOccurrences(of: "#", with: "")
		} else {
			string = hexString
		}
		
		if string.count == 3 { // convert hex to 6 digit format if in short format
			var str = ""
			string.forEach({ str.append(String(repeating: String($0), count: 2)) })
			string = str
		}
		
		guard let hexValue = Int(string, radix: 16) else {
			return nil
		}
		
		self.init(hex: Int(hexValue), transparency: transparency)
	}
	
	
	/// SwifterSwift: Create UIColor from RGB values with optional transparency.
	///
	/// - Parameters:
	///   - red: red component.
	///   - green: green component.
	///   - blue: blue component.
	///   - transparency: optional transparency value (default is 1).
	convenience init?(red: Int, green: Int, blue: Int, transparency: CGFloat = 1) {
		guard red >= 0 && red <= 255 else {
			return nil
		}
		guard green >= 0 && green <= 255 else {
			return nil
		}
		guard blue >= 0 && blue <= 255 else {
			return nil
		}
		var trans = transparency
		if trans < 0 { trans = 0 }
		if trans > 1 { trans = 1 }
		self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
	}

}
 
 extension String {
    var roundString: String {
        if let v = Float(self) {
            return String(format: "%.0f", v)
        }
        return ""
    }
 }
 
 
#endif

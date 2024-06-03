import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroTesting

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnumMacrosImplementation)
import EnumMacrosImplementation

let testMacros: [String: Macro.Type] = [
    "CaseCheckable": CaseCheckableMacro.self,
]
#endif

final class CaseCheckableTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(macros: [CaseCheckableMacro.self]) {
            super.invokeTest()
        }
    }
    func testMacro() throws {
        #if canImport(EnumMacrosImplementation)
        
        assertMacro {
            """
            enum TestCase {
                case firstOption(firstValue: String)
                case secondOption(secondValue: String, thirdValue: Int)
                case thirdOpton(firstValue: String, secondValue: String)
                case fourthOption
            
                var isFirstoption: Bool {
                    switch self {
                        case .firstOption:
                            true
                        default:
                            false
                    }
                }
            
                var isSecondoption: Bool {
                    switch self {
                        case .secondOption:
                            true
                        default:
                            false
                    }
                }
            
                var isThirdopton: Bool {
                    switch self {
                        case .thirdOpton:
                            true
                        default:
                            false
                    }
                }
            
                var isFourthoption: Bool {
                    switch self {
                        case .fourthOption:
                            true
                        default:
                            false
                    }
                }
            
                var firstValue: String? {
                    switch self {
                    case .firstOption(let firstValue):
                        return firstValue
                    case .thirdOpton(let firstValue, _):
                        return firstValue
                        default:
                        return nil
                    }
                }
            
                var thirdValue: Int? {
                    switch self {
                    case .secondOption(_, let thirdValue):
                        return thirdValue
                        default:
                        return nil
                    }
                }
            
                var secondValue: String? {
                    switch self {
                    case .secondOption(let secondValue, _):
                        return secondValue
                    case .thirdOpton(_, let secondValue):
                        return secondValue
                        default:
                        return nil
                    }
                }
            }
            """
        } expansion: {
            """
            enum TestCase {
                case firstOption(firstValue: String)
                case secondOption(secondValue: String, thirdValue: Int)
                case thirdOpton(firstValue: String, secondValue: String)
                case fourthOption

                var isFirstoption: Bool {
                    switch self {
                        case .firstOption:
                            true
                        default:
                            false
                    }
                }

                var isSecondoption: Bool {
                    switch self {
                        case .secondOption:
                            true
                        default:
                            false
                    }
                }

                var isThirdopton: Bool {
                    switch self {
                        case .thirdOpton:
                            true
                        default:
                            false
                    }
                }

                var isFourthoption: Bool {
                    switch self {
                        case .fourthOption:
                            true
                        default:
                            false
                    }
                }

                var firstValue: String? {
                    switch self {
                    case .firstOption(let firstValue):
                        return firstValue
                    case .thirdOpton(let firstValue, _):
                        return firstValue
                        default:
                        return nil
                    }
                }

                var thirdValue: Int? {
                    switch self {
                    case .secondOption(_, let thirdValue):
                        return thirdValue
                        default:
                        return nil
                    }
                }

                var secondValue: String? {
                    switch self {
                    case .secondOption(let secondValue, _):
                        return secondValue
                    case .thirdOpton(_, let secondValue):
                        return secondValue
                        default:
                        return nil
                    }
                }
            }
            """
        }
        #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
        #endif
    }
}

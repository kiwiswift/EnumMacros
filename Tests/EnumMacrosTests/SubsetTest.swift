import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroTesting

#if canImport(EnumMacrosImplementation)
import EnumMacrosImplementation
#endif

final class SubsetTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(isRecording: false,
                         macros: [SubsetMacro.self]) {
            super.invokeTest()
        }
    }
    func testMacro() throws {
#if canImport(EnumMacrosImplementation)

        assertMacro {
            """
            enum UserRole {
            case admin
            case moderator
            case user
            case guest
            }

            @Subset<UserRole, Another, AndOther, Other1, Other2>
            enum AdminRole {
            case admin
            case moderator
            }
            """
        } expansion: {
            """
            enum UserRole {
            case admin
            case moderator
            case user
            case guest
            }
            enum AdminRole {
            case admin
            case moderator

                init?(_ superset: UserRole) {
                    switch superset {
                    case .admin:
                        self = .admin
                    case .moderator:
                        self = .moderator
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

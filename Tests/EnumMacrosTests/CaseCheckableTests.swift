import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest
import MacroTesting

// Macro implementations build for the host, so the corresponding module is not available when cross-compiling. Cross-compiled tests may still make use of the macro itself in end-to-end tests.
#if canImport(EnumMacrosImplementation)
import EnumMacrosImplementation
#endif

final class CaseCheckableTests: XCTestCase {

    override func invokeTest() {
        withMacroTesting(isRecording: false,
                         macros: [CaseCheckableMacro.self]) {
            super.invokeTest()
        }
    }
    func test_EnumWithCaseCheckableMacro() throws {
        #if canImport(EnumMacrosImplementation)
        
        assertMacro {
            """
            @CaseCheckable
            enum NetworkResponse {
                case loaded(data: Data)
                case partiallyLoaded(data: Data, error: Error)
                case failure(error: Error)
                case loading
                case noConnection
            }

            """
        } expansion: {
            """
            enum NetworkResponse {
                case loaded(data: Data)
                case partiallyLoaded(data: Data, error: Error)
                case failure(error: Error)
                case loading
                case noConnection

                var isLoaded: Bool {
                    switch self {
                        case .loaded:
                            true
                        default:
                            false
                    }
                }

                var isPartiallyLoaded: Bool {
                    switch self {
                        case .partiallyLoaded:
                            true
                        default:
                            false
                    }
                }

                var isFailure: Bool {
                    switch self {
                        case .failure:
                            true
                        default:
                            false
                    }
                }

                var isLoading: Bool {
                    switch self {
                        case .loading:
                            true
                        default:
                            false
                    }
                }

                var isNoConnection: Bool {
                    switch self {
                        case .noConnection:
                            true
                        default:
                            false
                    }
                }

                var data: Data? {
                    switch self {
                    case .loaded(let data):
                        return data
                    case .partiallyLoaded(let data, _):
                        return data
                        default:
                        return nil
                    }
                }

                var error: Error? {
                    switch self {
                    case .partiallyLoaded(_, let error):
                        return error
                    case .failure(let error):
                        return error
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

    func test_CaseWithMacro() {
    #if canImport(EnumMacrosImplementation)

        assertMacro {
            """
            enum NetworkResponse {
                case loaded(data: Data)
                @CaseCheckable
                case partiallyLoaded(data: Data, error: Error)
                case failure(error: Error)
                case loading
                case noConnection
            }

            """
        } expansion: {
            """
            enum NetworkResponse {
                case loaded(data: Data)
                case partiallyLoaded(data: Data, error: Error)
                case failure(error: Error)
                case loading
                case noConnection
            }
            """
        }
    #else
        throw XCTSkip("macros are only supported when running tests for the host platform")
    #endif
    }
}

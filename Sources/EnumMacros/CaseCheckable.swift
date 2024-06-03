// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that enhances enums with associated values by generating additional
/// properties for case checking and accessing parameter values. For example,
///
/// Applying `@CaseCheckable` to an enum:
///
///     @CaseCheckable
///     enum MyEnum {
///         case firstOption(firstValue: String)
///         case secondOption(secondValue: String, thirdValue: Int)
///         case thirdOption(firstValue: String, secondValue: String)
///         case fourthOption
///     }
///
/// generates the following code:
///
///     extension MyEnum {
///         var isFirstOption: Bool {
///             switch self {
///                 case .firstOption: true
///                 default: false
///             }
///         }
///
///         var isSecondOption: Bool {
///             switch self {
///                 case .secondOption: true
///                 default: false
///             }
///         }
///
///         var isThirdOption: Bool {
///             switch self {
///                 case .thirdOption: true
///                 default: false
///             }
///         }
///
///         var isFourthOption: Bool {
///             switch self {
///                 case .fourthOption:  true
///                 default:  false
///             }
///         }
///
///         var firstValue: String? {
///             switch self {
///                 case .firstOption(let value):  return value
///                 case .thirdOption(let value, _): return value
///                 default: return nil
///             }
///         }
///
///         var secondValue: String? {
///             switch self {
///                 case .secondOption(let value, _): return value
///                 case .thirdOption(_, let value): return value
///                 default: return nil
///             }
///         }
///
///         var thirdValue: Int? {
///             switch self {
///                 case .secondOption(_, let value): return value
///                 default: return nil
///             }
///         }
///     }
///
/// This macro works by analyzing the enum cases and their associated values.
/// It generates a Boolean property for each case to check if the enum instance
/// matches that case, and generates properties for accessing the associated values
/// by their parameter names.
/// 
@attached(member, names: arbitrary)
public macro CaseCheckable() = #externalMacro(module: "EnumMacrosImplementation", type: "CaseCheckableMacro")

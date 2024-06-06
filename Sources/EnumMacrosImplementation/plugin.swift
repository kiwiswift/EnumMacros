import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct EnumMacrosPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CaseCheckableMacro.self,
    ]
}

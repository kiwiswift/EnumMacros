import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CaseCheckableMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, 
                                 providingMembersOf declaration: some DeclGroupSyntax,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {

        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self)
        else {
            fatalError("Only enums allowed")
        }

        let enumSyntax = EnumSyntax(declaration: enumDeclaration)
        return enumSyntax.cases.map(\.caseCheck) + enumSyntax.parametesValueGetter
    }
}

@main
struct CaseCheckablePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        CaseCheckableMacro.self,
    ]
}

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct CaseCheckableMacro: MemberMacro {
    public static func expansion(of node: AttributeSyntax, 
                                 providingMembersOf declaration: some DeclGroupSyntax,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {

        guard let enumDeclaration = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError.onlyApplicableToEnum(macroName: "CaseCheckable")
        }

        let enumSyntax = EnumSyntax(declaration: enumDeclaration)

        let casesCheck = enumSyntax.cases.map(\.caseCheck)
        let parametersGetters = enumSyntax.parametesValueGetter
        return casesCheck + parametersGetters
    }
}

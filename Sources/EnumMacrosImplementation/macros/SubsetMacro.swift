import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SubsetMacro: MemberMacro {
    
    public static func expansion(of node: AttributeSyntax,
                                 providingMembersOf declaration: some DeclGroupSyntax,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {

        guard let enumDecl = declaration.as(EnumDeclSyntax.self) else {
            throw MacroError.onlyApplicableToEnum(macroName: "Subset")
        }

        // Retrieve generic parameter
        let supersetArguments = node
            .attributeName.as(IdentifierTypeSyntax.self)?
            .genericArgumentClause?
            .arguments

        guard let supersetType = supersetArguments?
            .first?
            .argument else {
            // TODO: Handle error
            fatalError()
        }

        let members = enumDecl.memberBlock.members

        let caseDecl = members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        let elements = caseDecl.flatMap { $0.elements }

        let initializer = try InitializerDeclSyntax("init?(_ superset: \(supersetType))") {
            try SwitchExprSyntax("switch superset") {
                for element in elements {
                    SwitchCaseSyntax(
                        """
                        case .\(element.name):
                            self = .\(element.name)
                        """
                    )
                }
                SwitchCaseSyntax("default: return nil")
            }
        }


        return [DeclSyntax(initializer)]
    }

}

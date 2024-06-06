//
//  File.swift
//  
//
//  Created by Christiano Gontijo on 02/06/2024.
//

import SwiftSyntax

struct EnumSyntax {
    struct CaseSyntax {
        struct ParameterSyntax: Hashable, Comparable {

            let name: String?
            let typeName: String
            init(declaration: EnumCaseParameterSyntax) {
                self.name = declaration.firstName?.text
                self.typeName = declaration.type.description
            }

            static func < (lhs: EnumSyntax.CaseSyntax.ParameterSyntax, rhs: EnumSyntax.CaseSyntax.ParameterSyntax) -> Bool {
                lhs.name ?? "" < rhs.name ?? ""
            }
        }
        let name: String
        let parameters: [ParameterSyntax]

        var caseCheck: DeclSyntax {
            """
            var is\(raw: name.capitalisedFirstLetter): Bool {
                switch self {
                    case .\(raw: name):
                        true
                    default:
                        false
                }
            }
            """
        }

        func switchCaseWithValueBindingSyntax(forArgumentWithName argumentName: String) -> String? {

            guard let argumentIndex = self.parameters.map(\.name).firstIndex(of: argumentName)
            else { return nil }

            var arguments = Array(repeating: "_", count: parameters.count)
            arguments[argumentIndex] = "let \(argumentName)"

            return """
                case .\(self.name)(\(arguments.joined(separator: ", "))):
                    return \(argumentName)
            """
        }

        init?(declaration: EnumCaseDeclSyntax) {
            let elements = declaration.elements
            guard let name = elements.first?.name.text else { return nil }
            self.name = name
            guard let parameterClauses = elements.first?.parameterClause else {
                self.parameters = []
                return
            }
            self.parameters = parameterClauses.parameters.map { ParameterSyntax(declaration: $0) }
        }
    }

    let cases: [CaseSyntax]

    var parametesValueGetter: [DeclSyntax] {
        let parameters = cases.flatMap { $0.parameters }
        // TODO: Handle error when no parameters are found or when a parameter with same name has two types
        let parametersSyntax: [DeclSyntax] = Set(parameters).sorted().compactMap { parameter in
            guard let parameterName = parameter.name else { return nil }
            let casesWithParameter = cases.compactMap { $0.switchCaseWithValueBindingSyntax(forArgumentWithName: parameterName) }.joined(separator: "\n")
            return
                """
                var \(raw: parameterName): \(raw: parameter.typeName)? {
                    switch self {\n\(raw: casesWithParameter)
                        default: return nil
                    }
                }
                """
        }

        return parametersSyntax
    }

    init(declaration: EnumDeclSyntax) {
        let casesDeclarations = declaration.memberBlock.members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        self.cases = casesDeclarations.compactMap { CaseSyntax(declaration: $0) }
    }

}



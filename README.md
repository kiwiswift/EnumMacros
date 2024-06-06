
# EnumMacros

A collection of Swift macros to enhance enum syntax. This package currently includes the following macros:
- `CaseCheckableMacro`: Generates properties for case checking and accessing associated values.
- `SubsetMacro`: Generates an initializer for enums to create a subset from a superset.

## Overview

### CaseCheckableMacro

The `CaseCheckableMacro` macro provides:
- Boolean properties for each enum case to check if the instance matches that case.
- Properties for accessing associated values by their parameter names.

### SubsetMacro

The `SubsetMacro` macro generates an initializer that allows creating an enum instance from a superset enum.

## Example

### CaseCheckableMacro

Consider an enum representing different states of a network response:

```swift
enum NetworkResponse {
    case loaded(data: Data)
    case partiallyLoaded(data: Data, error: Error)
    case failure(error: Error)
    case loading
    case noConnection
}
```

The macro generates the following code:

```swift
enum NetworkResponse {
    case loaded(data: Data)
    case partiallyLoaded(data: Data, error: Error)
    case failure(error: Error)
    case loading
    case noConnection

    var isLoaded: Bool {
        switch self {
        case .loaded: true
        default: false
        }
    }

    var isPartiallyLoaded: Bool {
        switch self {
        case .partiallyLoaded: true
        default: false
        }
    }

    var isFailure: Bool {
        switch self {
        case .failure: true
        default: false
        }
    }

    var isLoading: Bool {
        switch self {
        case .loading: true
        default: false
        }
    }

    var isNoConnection: Bool {
        switch self {
        case .noConnection: true
        default: false
        }
    }

    var data: Data? {
        switch self {
        case .loaded(let data): return data
        case .partiallyLoaded(let data, _): return data
        default: return nil
        }
    }

    var error: Error? {
        switch self {
        case .partiallyLoaded(_, let error): return error
        case .failure(let error): return error
        default: return nil
        }
    }
}
```
This allows you to easily check the state of the response and access associated values:

```swift
let response: NetworkResponse = .success(data: someData)

if response.isSuccess {
    print("Data received: \(response.data!)")
} else if response.isFailure {
    print("Error occurred: \(response.error!)")
}
```

### SubsetMacro

Consider a scenario where you have a superset enum representing all possible user roles, and you want a subset enum for administrative roles:

```swift
enum UserRole {
    case admin
    case moderator
    case user
    case guest
}

enum AdminRole {
    case admin
    case moderator
}

```

The macro generates the following code:

```swift
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
```


This allows you to create an AdminRole instance from a UserRole instance, ensuring only admin roles are considered:
```swift
let role: UserRole = .admin

if let adminRole = AdminRole(role) {
    print("This is an administrative role: \(adminRole)")
} else {
    print("This is not an administrative role.")
}
```

## Usage

1. Add the `EnumMacros` package to your Swift project.
2. Annotate your enums with `@CaseCheckable` or `@Subset(SupersetEnum)`.

### Example for `CaseCheckableMacro`

```swift
@CaseCheckable
enum NetworkResponse {
    case success(data: Data)
    case failure(error: Error)
    case loading
    case noConnection
}
```

### Example for `SubsetMacro`

```swift
enum UserRole {
    case admin
    case moderator
    case user
    case guest
}

@Subset<UserRole>
enum AdminRole {
    case admin
    case moderator
}
```

## Implementation Details

The project consists of the following components:

### `EnumSyntax`

Represents the syntax structure of an enum and its cases.

- **Properties**:
  - `cases`: An array of `CaseSyntax` objects representing the cases of the enum.
  
- **Computed Properties**:
  - `parametesValueGetter`: Generates computed properties for accessing the values of the enum's associated parameters.

- **Initializer**:
  - `init(declaration: EnumDeclSyntax)`: Initializes the `EnumSyntax` object by parsing the enum declaration.

### `CaseSyntax`

Represents the syntax structure of a single enum case.

- **Properties**:
  - `name`: The name of the enum case.
  - `parameters`: An array of `ParameterSyntax` objects representing the parameters of the enum case.
  
- **Computed Properties**:
  - `caseCheck`: Generates a computed property that checks if the enum instance matches the case.

- **Methods**:
  - `switchCaseWithValueBindingSyntax(forArgumentWithName argumentName: String) -> String?`: Generates a switch case for binding the associated value of the parameter with the given name.

- **Initializer**:
  - `init?(declaration: EnumCaseDeclSyntax)`: Initializes the `CaseSyntax` object by parsing the enum case declaration.

### `ParameterSyntax`

Represents the syntax structure of a single parameter in an enum case.

- **Properties**:
  - `name`: The name of the parameter.
  - `typeName`: The type of the parameter.
  
- **Initializer**:
  - `init(declaration: EnumCaseParameterSyntax)`: Initializes the `ParameterSyntax` object by parsing the parameter declaration.

### `CaseCheckableMacro`

Conforms to the `MemberMacro` protocol and provides the macro expansion logic for case checking and value accessing properties.

- **Methods**:
  - `expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax]`: Expands the macro by generating the additional computed properties for the enum.

### `SubsetMacro`

Conforms to the `MemberMacro` protocol and provides the macro expansion logic for creating a subset enum from a superset enum.

- **Methods**:
  - `expansion(of node: AttributeSyntax, providingMembersOf declaration: some DeclGroupSyntax, in context: some MacroExpansionContext) throws -> [DeclSyntax]`: Expands the macro by generating the initializer for the subset enum.

### `EnumMacrosPlugin`

Registers the macros with the compiler plugin system.

- **Properties**:
  - `providingMacros`: An array containing the `CaseCheckableMacro` and `SubsetMacro` types.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any changes or enhancements.


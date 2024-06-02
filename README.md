# CaseCheckableMacro

This Swift Macro automatically generating Swift syntax for enum case checking and computed properties for enum parameters.

## Overview

### Purpose

The `CaseCheckableMacro` simplifies the process of working with enums in Swift by automatically generating:

1. **Case Check Methods**: For each case in an enum, a method is generated to check if the enum instance is of that specific case.
2. **Parameter Value Getters**: For enums with associated values, computed properties are generated to access these values directly.

### How It Works

- **EnumSyntax**: A supporting structure that parses the enum declaration and provides the necessary data for generating the required syntax.
- **CaseCheckableMacro**: Uses `EnumSyntax` to generate the Swift syntax for case checking and parameter value getters.
- **CaseCheckablePlugin**: A Swift compiler plugin that provides the macro to the compiler, enabling the automated syntax generation during compilation.


## Components

### EnumSyntax

The `EnumSyntax` structure is responsible for analyzing an enum declaration and providing the necessary data to generate the required Swift syntax.

#### Structure

- **EnumSyntax**:
   - `cases`: An array of `CaseSyntax` representing all cases in the enum.
   - `parametesValueGetter`: An array of `DeclSyntax` representing the computed properties for accessing enum parameters.

- **CaseSyntax**:
   - `name`: The name of the enum case.
   - `parameters`: An array of `ParameterSyntax` representing the parameters of the enum case.
   - `caseCheck`: A computed property generating the syntax for checking the enum case.
   - `switchCaseWithValueBindingSyntax(forArgumentWithName:)`: A method generating the switch case syntax for value binding.

- **ParameterSyntax**:
   - `name`: The name of the parameter (if any).
   - `typeName`: The type of the parameter.

#### Methods

- **EnumSyntax**:
   - `init(declaration: EnumDeclSyntax)`: Initializes an `EnumSyntax` instance from an enum declaration.
   - `parametesValueGetter`: Generates the computed properties for accessing enum parameters.

- **CaseSyntax**:
   - `init?(declaration: EnumCaseDeclSyntax)`: Initializes a `CaseSyntax` instance from a case declaration.
   - `caseCheck`: Generates the syntax for checking the enum case.
   - `switchCaseWithValueBindingSyntax(forArgumentWithName:)`: Generates the switch case syntax for value binding.

- **ParameterSyntax**:
   - `init(declaration: EnumCaseParameterSyntax)`: Initializes a `ParameterSyntax` instance from a parameter declaration.


### CaseCheckableMacro

- `CaseCheckableMacro` is a struct conforming to the `MemberMacro` protocol.
- It provides a method for expanding attribute syntax, generating Swift syntax for enum case checking and computed properties for enum parameters.

### CaseCheckablePlugin

- `CaseCheckablePlugin` is the main entry point.
- It conforms to the `CompilerPlugin` protocol and provides the `CaseCheckableMacro` for macro expansion.

## Usage

1. **Import the CaseCheckable Package**:
   ```swift
   import CaseCheckable
2. Define Your Enum and Apply the @CaseCheckable Attribute:
    ```swift
    @CaseCheckable
    enum TestCase {
        case firstOption(firstValue: String)
        case secondOption(secondValue: String, thirdValue: Int)
        case thirdOption(firstValue: String, secondValue: String)
        case fourthOption
    }
    ```
3. Use the Generated Methods and Properties:
    ```swift
    let enumValue = TestCase.thirdOption(firstValue: "first", secondValue: "second")
    print(enumValue.isThirdOption) // true
    print(enumValue.firstValue)    // "first"
    print(enumValue.secondValue)   // "second"
    print(enumValue.thirdValue)    // nil (only available in `secondOption`)
    ```

   In this example, applying the @CaseCheckable attribute to TestCase automatically generates the necessary methods for case checking and accessing associated values.

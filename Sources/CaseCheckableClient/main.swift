import CaseCheckable

@CaseCheckable
enum TestCase {
    case firstOption(firstValue: String)
    case secondOption(secondValue: String, thirdValue: Int)
    case thirdOpton(firstValue: String, secondValue: String)
    case fourthOption
}


let enumValue = TestCase.thirdOpton(firstValue: "first", secondValue: "second")
print(enumValue.isThirdopton)
print(enumValue.firstValue)
print(enumValue.secondValue)
print(enumValue.thirdValue)

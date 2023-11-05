import Foundation

@MainActor
class SharedData: ObservableObject {
    @Published var incomeHistory: [Income] = []
    @Published var expenseHistory: [Expense] = []
    @Published var dataIncomeLoaded = false
    @Published var dataExpenseLoaded = false
    @Published var userId = ""
}

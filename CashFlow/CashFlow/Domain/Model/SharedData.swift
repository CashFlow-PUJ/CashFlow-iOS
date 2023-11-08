import Foundation

@MainActor
class SharedData: ObservableObject {
    @Published var incomeHistory: [Income] = []
    @Published var expenseHistory: [Expense] = []
    @Published var dataIncomeLoaded = false
    @Published var dataExpenseLoaded = false
    @Published var isUserIdLoading: Bool = true
    @Published var userId = ""
    @Published var id = ""
    
    func resetValues() {
        incomeHistory = []
        expenseHistory = []
        dataIncomeLoaded = false
        dataExpenseLoaded = false
        isUserIdLoading = true
        userId = ""
        id = ""
    }
}

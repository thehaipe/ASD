import SwiftUI

//MARK: - ContentView
struct ContentView: View {
    @State private var selectedMethod: SortingMethod? = .selection

    var body: some View {
        NavigationSplitView {
            List(SortingMethod.allCases, selection: $selectedMethod) { method in
                NavigationLink(value: method) {
                    Label(method.rawValue, systemImage: method.iconName)
                }
            }
            .listStyle(.sidebar)
            .navigationTitle("Sorting Methods")
        } detail: {
            if let method = selectedMethod {
                SortingDetailView(method: method)
            } else {
                Text("Select a sorting method")
            }
        }
    }
}



#Preview {
    ContentView()
}

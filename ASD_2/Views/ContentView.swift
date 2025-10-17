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

// MARK: - SortingDetailView
struct SortingDetailView: View {
    let method: SortingMethod
    
    @State private var input = ""
    @State private var sortedResult: [Int] = []
    @State private var sortedCities: [String] = []
    @State private var steps: [[Int]] = []
    @State private var stringSteps: [[String]] = []
    
    var body: some View {
        // Якщо вибрано Matrix QuickSort — показуємо окремий екран
        if method == .matrixQuickSort {
            MatrixSortView()
        } else {
            HStack(alignment: .top, spacing: 40) {
                VStack(alignment: .center, spacing: 20) {
                    Text("\(method.rawValue)")
                        .font(.largeTitle)
                    
                    TextField("Enter values separated by spaces", text: $input)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 300)
                    
                    Button("Sort") {
                        let numbers = input
                            .split(separator: " ")
                            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
                        let cities = input
                            .split(separator: " ")
                            .map { String($0).trimmingCharacters(in: .whitespaces) }
                        
                        switch method {
                        case .selection:
                            steps = selectionSort(prepareArray_13(numbers))
                            sortedResult = steps.last ?? []
                        case .shell:
                            stringSteps = shellSort(prepareArray_14(cities))
                            sortedCities = stringSteps.last ?? []
                        case .megreSort:
                            let numbers = input
                                .split(separator: " ")
                                .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

                            let prepared = prepareArray_Merge(numbers)
                            let mergeSteps = mergeSort(prepared)
                            steps = mergeSteps.map { $0.map { Int($0) } }
                            sortedResult = steps.last?.map { Int($0) } ?? []
                            
                        case .matrixQuickSort:
                            break // нічого не робимо — бо MatrixSortView окремо
                        }
                    }
                    .frame(width: 200, height: 20)
                    .buttonStyle(.borderedProminent)
                    Button("Random Array"){
                        // Generate 10 random numbers (Double), convert to Ints for general usage, join as space-separated string
                        //i think its good idea
                        let randomDoubles = random_10_nums()
                        let ints = randomDoubles.map { Int($0.rounded()) }
                        input = ints.map(String.init).joined(separator: " ")
                    }
                    .frame(width: 200, height: 20).buttonStyle(.borderedProminent)
                    
                    switch method {
                    case .selection:
                        if !sortedResult.isEmpty {
                            Text("Sorted: \(sortedResult.map(String.init).joined(separator: ", "))")
                                .font(.headline)
                        }
                    case .shell:
                        if !sortedCities.isEmpty {
                            Text("Sorted: \(sortedCities.joined(separator: ", "))")
                                .font(.headline)
                        }
                    case .megreSort:
                        if !sortedResult.isEmpty {
                            Text("Sorted: \(sortedResult.map(String.init).joined(separator: ", "))")
                                .font(.headline)
                        }
                    case .matrixQuickSort:
                        EmptyView()
                    }
                    
                    Spacer()
                }
                .padding(.top, 70)
                
                Divider()
                
                VStack(alignment: .leading) {
                    Text("Iterations")
                        .font(.title2)
                    
                    if method == .selection {
                        List(steps.indices, id: \.self) { index in
                            Text("Step \(index): \(steps[index].map(String.init).joined(separator: ", "))")
                        }
                        .frame(minWidth: 250, maxHeight: .infinity)
                    } else if method == .shell {
                        List(stringSteps.indices, id: \.self) { index in
                            Text("Step \(index): \(stringSteps[index].joined(separator: ", "))")
                        }
                        .frame(minWidth: 250, maxHeight: .infinity)
                    } else if method == .megreSort {
                        List(steps.indices, id: \.self) { index in
                            Text("Step \(index): \(steps[index].map(String.init).joined(separator: ", "))")
                        }
                        .frame(minWidth: 250, maxHeight: .infinity)
                    }

                }
            }
            .padding()
        }
    }
}


#Preview {
    ContentView()
}

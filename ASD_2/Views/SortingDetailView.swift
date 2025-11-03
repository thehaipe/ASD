// MARK: - SortingDetailView
struct SortingDetailView: View {
    let method: SortingMethod
    
    @State private var input = ""
    @State private var sortedResult: [Int] = []
    @State private var sortedDoubles: [Double] = []
    @State private var sortedCities: [String] = []
    @State private var steps: [[Int]] = []
    @State private var doubleSteps: [[Double]] = []
    @State private var stringSteps: [[String]] = []
    @State private var countInfo: [(value: Double, count: Int)] = []
    
    var body: some View {
        if method == .matrixQuickSort {
            MatrixSortView()
        } else {
            HStack(alignment: .top, spacing: 40) {
                // MARK: - LEFT SIDE
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
                            
                        case .countingSort:
                            let prepared = prepareArray_17(numbers)
                            let result = CountingSort_17(prepared)
                            doubleSteps = result.steps
                            countInfo = result.countInfo
                            sortedDoubles = doubleSteps.last ?? []
                            
                        case .megreSort:
                            let doubles = input
                                .split(separator: " ")
                                .compactMap { Double($0.trimmingCharacters(in: .whitespaces)) }

                            let prepared = prepareArray_Merge(doubles)
                            let mergeSteps = mergeSort(prepared)
                            steps = mergeSteps.map { $0.map { Int($0) } }
                            sortedResult = steps.last?.map { Int($0) } ?? []
                            
                        case .matrixQuickSort:
                            break
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button("Random Array") {
                        let random = (1...8).map { _ in Int.random(in: 1...20) }
                        input = random.map(String.init).joined(separator: " ")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    // MARK: - Sorted Result
                    switch method {
                    case .selection, .megreSort:
                        if !sortedResult.isEmpty {
                            Text("Sorted: \(sortedResult.map(String.init).joined(separator: ", "))")
                                .font(.headline)
                        }
                    case .countingSort:
                        if !sortedDoubles.isEmpty {
                            Text("Sorted: \(sortedDoubles.map { String(format: "%.2f", $0) }.joined(separator: ", "))")
                                .font(.headline)
                            
                            // Масив підрахунку
                            if !countInfo.isEmpty {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text("Count Array:")
                                        .font(.headline)
                                        .padding(.top, 10)
                                    
                                    ForEach(countInfo.indices, id: \.self) { index in
                                        Text("\(String(format: "%.2f", countInfo[index].value)): \(countInfo[index].count) times")
                                            .font(.subheadline)
                                    }
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                        }
                    case .shell:
                        if !sortedCities.isEmpty {
                            Text("Sorted: \(sortedCities.joined(separator: ", "))")
                                .font(.headline)
                        }
                    case .matrixQuickSort:
                        EmptyView()
                    }
                    
                    Spacer()
                }
                .padding(.top, 70)
                
                Divider()
                
                // MARK: - RIGHT SIDE (Iterations)
                VStack(alignment: .leading) {
                    Text("Iterations")
                        .font(.title2)
                    
                    if method == .selection || method == .megreSort {
                        List(steps.indices, id: \.self) { index in
                            Text("Step \(index): \(steps[index].map(String.init).joined(separator: ", "))")
                        }
                        .frame(minWidth: 250, maxHeight: .infinity)
                    } else if method == .countingSort {
                        List(doubleSteps.indices, id: \.self) { index in
                            Text("Step \(index): \(doubleSteps[index].map { String(format: "%.2f", $0) }.joined(separator: ", "))")
                        }
                        .frame(minWidth: 250, maxHeight: .infinity)
                    } else if method == .shell {
                        List(stringSteps.indices, id: \.self) { index in
                            Text("Step \(index): \(stringSteps[index].joined(separator: ", "))")
                        }
                        .frame(minWidth: 250, maxHeight: .infinity)
                    }
                }
            }
            .padding()
        }
    }
}
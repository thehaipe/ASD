//
//  CompareView.swift
//  ASD_2
//
//  Created by Valentyn on 02.11.2025.
//

import SwiftUI

// Локальна модель результату для побудови списку та діаграми
struct BenchmarkResult: Identifiable, Hashable {
    let id = UUID()
    let algorithm: String
    let size: Int
    let duration: TimeInterval // секунди
}

struct CompareView: View {
    @State private var inputSize: String = "1000"
    @State private var latestResults: [BenchmarkResult] = [] // результати останнього запуску для списку
    @State private var history: [BenchmarkResult] = []       // історія запусків для діаграми (різні size)
    @State private var isRunning = false
    
    // Список алгоритмів, які порівнюємо
    private var algorithms: [(name: String, sort: ([Int]) -> ([Int], TimeInterval))] = [
        ("Selection", selectionSortInts),
        ("Shell",     shellSortInts),
        ("Merge",     mergeSortInts),
        ("Quick",     quickSortInts),
        ("Counting",  countingSortInts)
    ]
    
    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            // Ліва панель: керування
            VStack(alignment: .leading, spacing: 12) {
                Text("Compare Sorting Algorithms")
                    .font(.title)
                
                HStack {
                    Text("Array size:")
                    TextField("Enter size", text: $inputSize)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 120)
                        //.keyboardType(.numberPad)
                }
                
                HStack(spacing: 12) {
                    Button(isRunning ? "Running..." : "Run Benchmarks") {
                        runBenchmarks()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(isRunning)
                    
                    Button("Clear History") {
                        history.removeAll()
                        latestResults.removeAll()
                    }
                    .buttonStyle(.bordered)
                    
                    if isRunning {
                        ProgressView()
                            .controlSize(.small)
                            .padding(.leading, 4)
                    }
                }
                
                Spacer()
            }
            .frame(minWidth: 280)
            .padding()
            
            Divider()
            
            // Права панель: результати + діаграма
            VStack(alignment: .leading, spacing: 16) {
                Text("Latest Results")
                    .font(.headline)
                
                if latestResults.isEmpty {
                    Text(isRunning ? "Running..." : "No results yet. Enter size and press Run Benchmarks.")
                        .foregroundColor(.secondary)
                } else {
                    List(latestResults) { result in
                        HStack {
                            Text(result.algorithm)
                            Spacer()
                            Text("n=\(result.size)")
                                .foregroundStyle(.secondary)
                            Text(String(format: "%.6f s", result.duration))
                                .monospacedDigit()
                        }
                    }
                    .frame(minHeight: 180, maxHeight: 260)
                }
                
                Text("Performance Chart (duration vs. size)")
                    .font(.headline)
                
                if history.isEmpty {
                    Text("Run benchmarks with different sizes to populate the chart.")
                        .foregroundColor(.secondary)
                } else {
                    ChartView(results: history)
                        .frame(height: 260)
                        .padding(.vertical, 8)
                        .background(Color.gray.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Spacer()
            }
            .padding()
        }
    }
    
    private func runBenchmarks() {
        guard let size = Int(inputSize), size > 0 else { return }
        isRunning = true
        latestResults.removeAll()
        
        // Генеруємо вхідний масив один раз на головному потоці
        let input = ramdom_nums(size_of_array: size)
        
        // Лічильник завершених задач
        var completed = 0
        let total = algorithms.count
        
        // Запускаємо кожен алгоритм у своєму фонового завданні з високим пріоритетом
        for algo in algorithms {
            Task.detached(priority: .userInitiated) {
                // Обчислення на фоні
                let (_, duration) = algo.sort(input)
                let result = BenchmarkResult(algorithm: algo.name, size: size, duration: duration)
                
                // Оновлення UI поступово
                await MainActor.run {
                    latestResults.append(result)
                    history.append(result)
                    completed += 1
                    if completed == total {
                        isRunning = false
                    }
                }
            }
        }
    }
}

// MARK: - Простий стовпчиковий графік без сторонніх бібліотек
private struct ChartView: View {
    let results: [BenchmarkResult]
    
    // Групуємо дані: алгоритм -> [(size, duration)]
    private var grouped: [String: [BenchmarkResult]] {
        Dictionary(grouping: results, by: { $0.algorithm })
    }
    
    // Всі різні розміри, відсортовані
    private var sortedSizes: [Int] {
        Array(Set(results.map { $0.size })).sorted()
    }
    
    // Максимальна тривалість для нормалізації висот
    private var maxDuration: TimeInterval {
        results.map { $0.duration }.max() ?? 1.0
    }
    
    // Фіксовані кольори для стабільності відповідності "алгоритм -> колір"
    private let fixedColors: [String: Color] = [
        "Selection": .blue,
        "Shell": .orange,
        "Merge": .green,
        "Quick": .red,
        "Counting": .purple
    ]
    private let fallbackColor: Color = .gray
    
    // Мінімальна висота для ненульових значень
    private let minBarHeight: CGFloat = 10
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Легенда
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(grouped.keys).sorted(), id: \.self) { name in
                        HStack(spacing: 6) {
                            color(for: name)
                                .frame(width: 12, height: 12)
                                .clipShape(Circle())
                            Text(name).font(.caption)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())
                    }
                }
                .padding(.bottom, 4)
            }
            
            // Вісі та стовпчики
            GeometryReader { geo in
                let width = geo.size.width
                let height = geo.size.height
                let groupCount = sortedSizes.count
                let barGroupSpacing: CGFloat = 16
                let barsPerGroup = max(1, grouped.keys.count)
                let barWidth: CGFloat = max(6, (width - CGFloat(groupCount + 1) * barGroupSpacing) / CGFloat(max(1, groupCount * barsPerGroup)))
                
                ZStack(alignment: .bottomLeading) {
                    HStack(alignment: .bottom, spacing: barGroupSpacing) {
                        ForEach(sortedSizes, id: \.self) { size in
                            HStack(alignment: .bottom, spacing: 6) {
                                ForEach(Array(grouped.keys).sorted(), id: \.self) { algo in
                                    let value = grouped[algo]?.first(where: { $0.size == size })?.duration ?? 0
                                    let normalized = maxDuration > 0 ? value / maxDuration : 0
                                    let rawHeight = CGFloat(normalized) * (height - 24)
                                    // Якщо значення ненульове, гарантуємо мінімум 6 пікселів
                                    let barHeight = (value > 0) ? max(minBarHeight, rawHeight) : 0
                                    
                                    Rectangle()
                                        .fill(color(for: algo))
                                        .frame(width: barWidth, height: barHeight)
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                }
            }
            .frame(height: 200)
            
            // Підписи осі X
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(sortedSizes, id: \.self) { size in
                        Text("n=\(size)")
                            .font(.caption)
                            .frame(minWidth: 24)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding(8)
    }
    
    private func color(for name: String) -> Color {
        fixedColors[name, default: fallbackColor]
    }
}

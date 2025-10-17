//
//  MatrixSortView.swift
//  ASD_2
//
//  Created by Valentyn on 09.10.2025.
//

import SwiftUI
import UniformTypeIdentifiers

struct MatrixSortView: View {
    @State private var matrix: [[Double]] = []
    @State private var fileURL: URL?
    @State private var outputPath: String = ""
    @State private var sortSteps: [[[Double]]] = []
    @State private var showAlert = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("QuickSort Matrix by Row Sum")
                .font(.largeTitle)
            
            Button("Обрати файл матриці") {
                openFileDialog()
            }
            .buttonStyle(.borderedProminent)
            
            if !matrix.isEmpty {
                Text("Початкова матриця:")
                    .font(.headline)
                
                VStack(alignment: .leading) {
                    ForEach(matrix.indices, id: \.self) { i in
                        Text(matrix[i].map { String(format: "%.2f", $0) }.joined(separator: " "))
                    }
                }
                .padding(.horizontal)
                
                Button("Відсортувати (QuickSort)") {
                    sortMatrix()
                }
                .buttonStyle(.borderedProminent)
            }
            
            if !outputPath.isEmpty {
                Text("Результат збережено у:")
                    .font(.headline)
                Text(outputPath)
                    .font(.caption)
                    .foregroundColor(.green)
                    .contextMenu {
                        Button("Copy") {
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(outputPath, forType: .string)
                        }
                    }
            }
        }
        .padding()
        .alert("Помилка", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Не вдалося зчитати матрицю з файлу.")
        }
    }
    
    // MARK: - File open dialog
    func openFileDialog() {
        let panel = NSOpenPanel()
        panel.allowedContentTypes = [.plainText]
        panel.allowsMultipleSelection = false
        if panel.runModal() == .OK, let url = panel.url {
            self.fileURL = url
            readMatrix(from: url)
        }
    }
    
    // MARK: - Read matrix
    func readMatrix(from url: URL) {
        do {
            let content = try String(contentsOf: url, encoding: .utf8)
            let rows = content.split(separator: "\n")
            self.matrix = rows.map { row in
                row.split(separator: " ").compactMap { Double($0) }
            }
        } catch {
            showAlert = true
        }
    }
    
    // MARK: - QuickSort (з фіксацією кроків)
    func sortMatrix() {
        sortSteps = quickSortMatrixSteps(matrix)
        if let last = sortSteps.last {
            matrix = last
        }
        saveQuickSortMatrixSteps(sortSteps)
    }
    
    // MARK: - Алгоритм QuickSort
    func quickSortMatrixSteps(_ matrix: [[Double]]) -> [[[Double]]] {
        var matrix = matrix
        var steps: [[[Double]]] = [matrix]
        
        func quickSort(_ arr: inout [[Double]], low: Int, high: Int) {
            if low < high {
                let p = partition(&arr, low: low, high: high)
                steps.append(arr)
                quickSort(&arr, low: low, high: p - 1)
                quickSort(&arr, low: p + 1, high: high)
            }
        }
        
        func partition(_ arr: inout [[Double]], low: Int, high: Int) -> Int {
            let pivot = arr[high].reduce(0, +)
            var i = low
            for j in low..<high {
                if arr[j].reduce(0, +) < pivot {
                    arr.swapAt(i, j)
                    steps.append(arr)
                    i += 1
                }
            }
            arr.swapAt(i, high)
            steps.append(arr)
            return i
        }
        
        quickSort(&matrix, low: 0, high: matrix.count - 1)
        return steps
    }
    
    // MARK: - Save result with row sums
    func saveQuickSortMatrixSteps(_ steps: [[[Double]]]) {
        var output = ""
        
        for (index, step) in steps.enumerated() {
            let sums = step.map { $0.reduce(0, +) }
            output += "Step \(index + 1):\n"
            output += "Суми рядків: \(sums.map { String(format: "%.2f", $0) }.joined(separator: ", "))\n"
            output += step.map { $0.map { String(format: "%.2f", $0) }.joined(separator: " ") }.joined(separator: "\n")
            output += "\n\n"
        }
        
        let currentPath = FileManager.default.currentDirectoryPath
        let resultURL = URL(fileURLWithPath: currentPath).appendingPathComponent("matrix_quicksort_steps.txt")
        
        do {
            try output.write(to: resultURL, atomically: true, encoding: .utf8)
            outputPath = resultURL.path
            print("✅ Результати збережено: \(resultURL.path)")
        } catch {
            print("❌ Помилка запису файлу: \(error.localizedDescription)")
        }
    }
}

#Preview {
    MatrixSortView()
}

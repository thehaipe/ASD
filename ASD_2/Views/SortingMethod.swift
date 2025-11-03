//
//  SortingMethod.swift
//  ASD_2
//
//  Created by Valentyn on 25.09.2025.
//
// MARK: - Enum для вибору методів сортування (Sidebar)
enum SortingMethod: String, CaseIterable, Identifiable {
    case selection = "Selection Sort"
    case shell = "Shell Sort"
    case matrixQuickSort = "QuickSort"
    case megreSort = "Merge Sort"
    case countingSort = "Count Sort"
    case compare = "Compare" // Додано: окремий екран для порівняння

    var id: String { rawValue }

    var iconName: String {
        switch self {
        case .selection: return "arrow.up.arrow.down"
        case .shell: return "arrow.left.and.right"
        case .matrixQuickSort: return "tablecells"
        case .megreSort: return "tablecells"
        case .countingSort: return "plus.circle"
        case .compare: return "chart.bar.doc.horizontal" // Іконка для Compare
        }
    }
}

func random_10_nums() -> [Double] {
    var result : [Double] = []
    for _ in 0..<10 {
        result.append(Double.random(in: -100..<100))
    }
    return result
}

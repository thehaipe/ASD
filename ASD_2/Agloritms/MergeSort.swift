import Foundation

func mergeSort(_ array: [Double]) -> [[Double]] {
    var steps: [[Double]] = [array]
    
    func merge(_ left: [Double], _ right: [Double]) -> [Double] {
        var merged: [Double] = []
        var leftIndex = 0
        var rightIndex = 0
        
        while leftIndex < left.count && rightIndex < right.count {
            //умова спадання
            if left[leftIndex] > right[rightIndex] {
                merged.append(left[leftIndex])
                leftIndex += 1
            } else {
                merged.append(right[rightIndex])
                rightIndex += 1
            }
        }
        merged += left[leftIndex...]
        merged += right[rightIndex...]
        return merged
    }
    
    func mergeSortRec(_ arr: [Double]) -> [Double] {
        guard arr.count > 1 else { return arr }
        
        let middle = arr.count / 2
        let left = Array(arr[..<middle])
        let right = Array(arr[middle...])
        
        let sortedLeft = mergeSortRec(left)
        let sortedRight = mergeSortRec(right)
        
        let merged = merge(sortedLeft, sortedRight)
        steps.append(merged)
        return merged
    }
    
    _ = mergeSortRec(array)
    return steps
}

// MARK: - Підготовка масиву до сортування, варіант 16
func prepareArray_Merge(_ array: [Double]) -> [Double] {
    guard let minElement = array.min() else { return array }
    return array.map { $0 < 0 ? $0 * minElement : $0 }
}

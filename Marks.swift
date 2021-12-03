



import Foundation

// Get the file path/filename from the command line. Needs to be provided after "-path"
guard let firstPath = UserDefaults.standard.string(forKey: "path1") else {
    print("Path not provided.")
    exit(1)
}
guard let secondPath = UserDefaults.standard.string(forKey: "path2") else {
    print("Path not provided.")
    exit(1)
}

let fileUrl = URL(fileURLWithPath: firstPath)
print(fileUrl)

guard FileManager.default.fileExists(atPath: fileUrl.firstPath) else {
    print("File expected at \(fileUrl.absoluteString) is missing.")
    exit(1)
}
guard FileManager.default.fileExists(atPath: fileUrl.secondPath) else {
    print("File expected at \(fileUrl.absoluteString) is missing.")
    exit(1)
}
// open the file for reading
guard let filePointer: UnsafeMutablePointer<FILE> = fopen(fileUrl.path, "r") else {
    preconditionFailure("Could not open file at \(fileUrl.absoluteString)")
}

var lineByteArrayPointer: UnsafeMutablePointer<CChar>?
var lineCap: Int = 0
var bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)

defer {
fclose(filePointer)
}

var list = [Int]()

while bytesRead > 0 {
    let lineAsString = String.init(cString: lineByteArrayPointer!)
    let value = Int((lineAsString).trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
    list.append(value)
    bytesRead = getline(&lineByteArrayPointer, &lineCap, filePointer)
}

print(list)
list.sort()
print("The mean is:", mean(numbers: list))
print("The median is:", calculateMedian(array: list))

func mean(numbers: [Int]) -> Int {
    var total: Int = 0
    for number in numbers {
        total += Int(number)
    }
    return total / Int(numbers.count)
}

func calculateMedian(array: [Int]) -> Float {
    let sorted = array.sorted()
    if sorted.count % 2 == 0 {
        return Float((sorted[(sorted.count / 2)] + sorted[(sorted.count / 2) - 1]) / 2)
    } else {
        return Float(sorted[(sorted.count - 1) / 2])
    }
}

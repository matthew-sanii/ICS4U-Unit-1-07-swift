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

let fileUrl1 = URL(fileURLWithPath: firstPath)
let fileUrl2 = URL(fileURLWithPath: secondPath)
print(fileUrl1)
print(fileUrl2)

guard FileManager.default.fileExists(atPath: fileUrl1.path) else {
    print("File expected at \(fileUrl1.absoluteString) is missing.")
    exit(1)
}
guard FileManager.default.fileExists(atPath: fileUrl2.path) else {
    print("File expected at \(fileUrl2.absoluteString) is missing.")
    exit(1)
}
// open the file for reading
guard let firstFilePointer: UnsafeMutablePointer<FILE> = fopen(fileUrl1.path, "r") else {
    preconditionFailure("Could not open file at \(fileUrl1.absoluteString)")
}
guard let secondFilePointer: UnsafeMutablePointer<FILE> = fopen(fileUrl2.path, "r") else {
    preconditionFailure("Could not open file at \(fileUrl2.absoluteString)")
}
var lineByteArrayPointer: UnsafeMutablePointer<CChar>?
var lineCap: Int = 0
var bytesRead1 = getline(&lineByteArrayPointer, &lineCap, firstFilePointer)
var bytesRead2 = getline(&lineByteArrayPointer, &lineCap, secondFilePointer)

defer {
fclose(firstFilePointer)
fclose(secondFilePointer)
}

var list = Array(count: bytesRead1, Array(count: bytesRead2))
list[0][0].append("")
let bytesTotal1 = bytesRead1
let bytesTotal2 = bytesRead2

while bytesRead1 > 0 {
    let lineAsString = String.init(cString: lineByteArrayPointer!)
    let value = String((lineAsString).trimmingCharacters(in: .whitespacesAndNewlines))
    list[0][bytesTotal1].append(value)
    bytesRead1 = getline(&lineByteArrayPointer, &lineCap, firstFilePointer)
}

print(list)

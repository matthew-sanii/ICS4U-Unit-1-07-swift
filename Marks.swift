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

var list = [[String]]()
var list3 = [String]()
list[0][0].append("")

while bytesRead1 > 0 {
    let lineAsString = String.init(cString: lineByteArrayPointer!)
    let value = String((lineAsString).trimmingCharacters(in: .whitespacesAndNewlines))
    list3.append(value)
    bytesRead1 = getline(&lineByteArrayPointer, &lineCap, firstFilePointer)
}
list.append(list3)

while bytesRead2 > 0 {
    var list2 = [String]()
    let lineAsString2 = String.init(cString: lineByteArrayPointer!)
    let value2 = String((lineAsString2).trimmingCharacters(in: .whitespacesAndNewlines))
    list2.append(value2)
    for _ in list {
        let mark = Int.random(in: 0...10)
        let marks = Float(mark)
        let deviate = Float.random(in: 0...3)
        let deviation = 75 + (marks * deviate)
        let marked = Int(round(deviation))
        let value3 = String(marked)
        list2.append(value3)
    }
    list.append(list2)
}

print(list)

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
// Get filename of file created array will be exported to.
guard let thirdPath = UserDefaults.standard.string(forKey: "path3") else {
    print("Output path not provided.")
    exit(1)
}

let fileUrl1: URL = URL(fileURLWithPath: firstPath)
let fileUrl2: URL = URL(fileURLWithPath: secondPath)
let fileUrl3: URL = URL(fileURLWithPath: thirdPath)

guard FileManager.default.fileExists(atPath: fileUrl1.path) else {
    print("File expected at \(fileUrl1.absoluteString) is missing.")
    exit(1)
}
guard FileManager.default.fileExists(atPath: fileUrl2.path) else {
    print("File expected at \(fileUrl2.absoluteString) is missing.")
    exit(1)
}
guard FileManager.default.fileExists(atPath: fileUrl3.path) else {
    print("File expected at \(fileUrl3.absoluteString) is missing.")
    exit(1)
}

// open the file for reading
guard let firstFilePointer: UnsafeMutablePointer<FILE> = fopen(fileUrl1.path, "r") else {
    preconditionFailure("Could not open file at \(fileUrl1.absoluteString)")
}
guard let secondFilePointer: UnsafeMutablePointer<FILE> = fopen(fileUrl2.path, "r") else {
    preconditionFailure("Could not open file at \(fileUrl2.absoluteString)")
}

var lineByteArrayPointer1: UnsafeMutablePointer<CChar>?
var lineByteArrayPointer2: UnsafeMutablePointer<CChar>?
var lineCap: Int = 0

var bytesRead1 = getline(&lineByteArrayPointer1, &lineCap, firstFilePointer)
var bytesRead2 = getline(&lineByteArrayPointer2, &lineCap, secondFilePointer)
if bytesRead1 == -1 || bytesRead2 == -1 {
    print("One of the input files were empty.")
    exit(0)
}

defer {
fclose(firstFilePointer)
fclose(secondFilePointer)
}

var list = [[String]]()
var list3 = [String]()
var size = 0
list3.append(" ")

while bytesRead1 > 0 {
    let lineAsString = String.init(cString: lineByteArrayPointer1!)
    let value = String((lineAsString).trimmingCharacters(in: .whitespacesAndNewlines))
    list3.append(value)
    bytesRead1 = getline(&lineByteArrayPointer1, &lineCap, firstFilePointer)
    size += 1
}

let maxSize = size
list.append(list3)
while bytesRead2 > 0 {
    var list2 = [String]()
    let lineAsString2 = String.init(cString: lineByteArrayPointer2!)
    let value2 = String((lineAsString2).trimmingCharacters(in: .whitespacesAndNewlines))
    list2.append(value2)
    while size > 0 {
        let mark = Int.random(in: 1...8)
        let marks = Float(mark)
        let deviate = Float.random(in: -3...3)
        let deviation = 75 + (marks * deviate)
        let marked = Int(round(deviation))
        let value3 = String(marked)
        list2.append(value3)
        size -= 1
    }
    size += maxSize
    list.append(list2)
    bytesRead2 = getline(&lineByteArrayPointer2, &lineCap, secondFilePointer)
}

size += 1
var arrayAsString = ""
var row = 0
while size != 0 {
    let rowAsString = list[row].joined(separator: ", ")
    size -= 1
    row += 1
    arrayAsString += rowAsString
    arrayAsString += "\n"
}

let manager = FileManager.default
do {
    try arrayAsString.write(to: fileUrl3, atomically: true, encoding: .utf8)
} catch {
    print("error creating file")
}

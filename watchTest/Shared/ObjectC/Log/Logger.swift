/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A debug utility for writing logs into a log file.
 
 //
 - 애플기본샘플 Document 폴더에 logs폴더 파일기록남김.
 - 추가수정사항 object-c 와 호환되도록 수정함.
 
*/

import Foundation

// WKWatchConnectivityRefreshBackgroundTask mostly happens when the watch app is in the background,
// and background task budget is limited, so Xcode isn't suitable for debugging in this case.
//
@objc
class Logger: NSObject {
    
    @objc public static let shared = Logger()
    @objc private var fileHandle: FileHandle!

    
    private override init() {
        super.init()

        self.fileHandle = try? FileHandle(forUpdating: self.fileURL)
        assert(self.fileHandle != nil, "Failed to create the file handle!")
    }
    
    // Return the folder URL, and create the folder if it doesn't exist yet.
    // Return nil to trigger a crash if the folder creation fails.
    //
    @objc
    private var _folderURL: URL?
    
    @objc
    private var folderURL: URL! {
        guard _folderURL == nil else { return _folderURL }
        
        var folderURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        folderURL.appendPathComponent("Logs")
        
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true)
            } catch {
                print("Failed to create the log folder: \(folderURL)! \n\(error)")
                return nil // To trigger crash.
            }
        }
        _folderURL = folderURL
        return folderURL
    }
    
    // Return the file URL, and create the file if it doesn't exist yet.
    // Return nil to trigger a crash if the file creation fails.
    //
    @objc
    private var _fileURL: URL?
    @objc
    private var fileURL: URL! {
        guard _fileURL == nil else { return _fileURL }

        let dateFormatter = DateFormatter()
        //dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy_MM_dd"
        let dateString = dateFormatter.string(from: Date())
    
        var fileURL: URL = self.folderURL
        fileURL.appendPathComponent("\(dateString).log")
        
        if !FileManager.default.fileExists(atPath: fileURL.path) {
            if !FileManager.default.createFile(atPath: fileURL.path, contents: nil, attributes: nil) {
                print("Failed to create the log file: \(fileURL)!")
                return nil // To trigger crash.
            }
        }
        _fileURL = fileURL
        print("fileURL: \(fileURL)")
        return fileURL
    }
    
    // Avoid creating DateFormatter frequently, as Logger counts into the execution budget.
    //
    @objc
    private lazy var timeStampFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .medium
        return dateFormatter
    }()
    
    // Use this dispatch queue to make the log file access thread-safe.
    // Public methods use performBlockAndWait to access the resource; private methods don't.
    //
    private lazy var ioQueue: DispatchQueue = {
        return DispatchQueue(label: "ioQueue")
    }()
    
    private func performBlockAndWait<T>(_ block: () -> T) -> T {
        return ioQueue.sync {
            return block()
        }
    }
    
    // Get the current log file URL.
    //
    @objc
    func getFileURL() -> URL {
        return performBlockAndWait { return fileURL }
    }
    
    // Append a line of text to the end of the file.
    // Use FileHandle to seek to the end directly.
    //
    @objc
    func append(line: String) {
        let timeStamp = timeStampFormatter.string(from: Date())
        let timedLine = timeStamp + ": " + line + "\n"
        
//        print(line)
        
        if let data = timedLine.data(using: .utf8) {
            performBlockAndWait {
                self.fileHandle.seekToEndOfFile()
                self.fileHandle.write(data)
            }
        }        
    }
    
    // Read the file content and return it as a string.
    //
    @objc
    func content() -> String {
        return performBlockAndWait {
            fileHandle.seek(toFileOffset: 0) // Read from the very beginning.
            return String(data: fileHandle.availableData, encoding: .utf8) ?? ""
        }
    }
    
    // Clear all logs. Reset the folder and file URL for later use.
    //
    @objc
    func clearLogs() {
        performBlockAndWait {
            self.fileHandle.closeFile()
            do {
                try FileManager.default.removeItem(at: self.folderURL)
            } catch {
                print("Failed to clear the log folder!\n\(error)")
            }
            
            // Create a new file handle.
            //
            self._folderURL = nil
            self._fileURL = nil
            self.fileHandle = try? FileHandle(forUpdating: self.fileURL)
            assert(self.fileHandle != nil, "Failed to create the file handle!")
        }
    }
}

//
//  DatabaseManager.swift
//  TagTheBus
//
//  Created by Aadhar on 23/11/19.
//  Copyright © 2019 Aadhar. All rights reserved.
//

import UIKit
import SQLite3
import FMDB

class DatabaseManager: NSObject {
    
    static let shared = DatabaseManager()
    var databasePath = ""
    
    override init() {
        super.init()
        databasePath = databaseFilePath()
    }
    
    // Private Methods
    private func databaseFilePath() -> String {
        do {
            let documents = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documents.appendingPathComponent(DBConstants.dbName)
            return fileURL.path
        } catch let error as NSError {
            print(error)
            return ""
        }
    }
    
    private func executeStatements(_ query: String) -> Bool {
        let database = FMDatabase(path: databasePath)
        var status = false
        if database.open() {
            status = database.executeStatements(query)
        }
        database.close()
        return status
    }
    
    func createStationsTable() {
        if FileManager.default.fileExists(atPath: databasePath) {
            return
        }
        let allColumnWithDataType = DBConstants.StationsTableColumns.allCases.map({ "\($0.rawValue) \($0.dataType)" }).joined(separator: ", ")
        let createTable = "CREATE TABLE IF NOT EXISTS \(DBConstants.Tables.stations.rawValue) (\(allColumnWithDataType));"
        let tableCreated = executeStatements(createTable)
        print(tableCreated ? "Table created" : "Error while creating \(DBConstants.Tables.stations.rawValue)" )
    }
    
    func insertImageDetail(with station: StationImageDetailModel) -> Int? {
        var newIndex: Int?
        let imageName = "\(station.stationId)_\(Int(station.date.timeIntervalSince1970)).png"
        guard let image = station.image, DocumentsManager.save(image: image, with: imageName) else {
            return newIndex
        }
        let database = FMDatabase(path: databasePath)
        if database.open() {
            let columns: [DBConstants.StationsTableColumns] = [.stationId, .image, .title, .createDateTime]
            let columnsString = columns.map({ $0.rawValue }).joined(separator: ", ")
            let values = "\(station.stationId), '\(imageName)', '\(station.title.validStringToStoreInDB)', \(station.date.timeIntervalSince1970)"
            let insert = "INSERT INTO \(DBConstants.Tables.stations.rawValue) (\(columnsString)) VALUES (\(values));"
            let status = database.executeStatements(insert)
            if status {
                newIndex = Int(database.lastInsertRowId)
            }
        }
        database.close()
        return newIndex
    }
    
    func getImageDetails(from stationId: Int) -> [StationImageDetailModel] {
        var stationImages = [StationImageDetailModel]()
        let database = FMDatabase(path: databasePath)
        if database.open() {
            let fetch = "SELECT * FROM \(DBConstants.Tables.stations.rawValue) WHERE \(DBConstants.StationsTableColumns.stationId.rawValue) = \(stationId);"
            if let results = database.executeQuery(fetch, withArgumentsIn: []) {
                while results.next() {
                    if let result = results.resultDictionary as? [String: Any] {
                        let stationImage = StationImageDetailModel(with: result)
                        stationImages.append(stationImage)
                    }
                }
            }
        }
        database.close()
        return stationImages
    }
    
    func deleteImageDetail(from stationImageId: Int, imageName: String) -> Bool {
        let delete = "DELETE FROM \(DBConstants.Tables.stations.rawValue) WHERE \(DBConstants.StationsTableColumns.id.rawValue) = \(stationImageId);"
        let status = executeStatements(delete)
        if status {
            DocumentsManager.deleteFile(for: imageName)
        }
        return status
    }
}

struct DBConstants {
    static let dbName = "TagTheBus.sqlite"
    static let uniqueString = "_d_b_t_a_g_t_h_e_b_u_s_d_b_"
    static let replacementString = "'"
    
    enum Tables: String {
        case stations = "StationsTable"
    }
    
    enum StationsTableColumns: String, CaseIterable {
        case id = "ColumnId"
        case stationId = "StationId"
        case image = "Image"
        case title = "Title"
        case createDateTime = "CreateDateTime"
        
        var dataType: String {
            switch self {
            case .id:
                return "INTEGER PRIMARY KEY AUTOINCREMENT"
            case .stationId:
                return "INTEGER"
            case .createDateTime:
                return "DOUBLE"
            default:
                return "TEXT"
            }
        }
    }
    
}

extension String {
    var validStringToStoreInDB: String {
        return self.replacingOccurrences(of: DBConstants.replacementString, with: DBConstants.uniqueString)
    }
    
    var validStringFromDB: String {
        return self.replacingOccurrences(of: DBConstants.uniqueString, with: DBConstants.replacementString)
    }
}

//
//  AppManager+Firestore.swift
//  Salmonia3
//
//  Created by devonly on 2021/12/31.
//

import Foundation
import SalmonStats
import SplatNet2
import Combine

extension AppManager {
    /// Firebaseにデータを保存
    private func create<T: FSCodable>(_ object: T, merge: Bool = false) throws {
        let data = try encoder.encode(object)
        firestore
            .collection("records")
            .document(String(format: "%10d", object.startTime))
            .collection("waves")
            .document(object.id).setData(data, merge: merge)
    }
    
    private func create<T: FSCodable>(_ objects: [T], merge: Bool = false) throws {
        for object in objects {
            try create(object, merge: merge)
        }
    }
    
    /// Firestoreにデータをアップロード
    internal func register(_ results: [(UploadResult.Response, Result.Response)]) {
        let records: [FSRecordWave] = results.flatMap({ result in result.1.waveDetails.map({ FSRecordWave(from: result.1, wave: $0, salmonId: result.0.salmonId) })})
        try? create(records)
    }
    
    /// Firebaseからデータをプライマリキーを指定して読み込み
    func object<T: FSCodable>(type: T.Type, primaryKey: String) -> AnyPublisher<T, SP2Error> {
        Future { [self] promise in
            firestore.collection(String(describing: T.self)).document(primaryKey).getDocument(completion: { [self] (document, _) in
                guard let document = document, let data = document.data() else {
                    promise(.failure(SP2Error.dataDecodingFailed))
                    return
                }
                do {
                    promise(.success(try decoder.decode(T.self, from: data)))
                } catch {
                    promise(.failure(SP2Error.dataDecodingFailed))
                }
            })
        }
        .eraseToAnyPublisher()
    }
    
    /// Firebaseから指定した型のデータを全て取得
    func objects<T: FSCodable>(_ type: T.Type) -> AnyPublisher<[T], SP2Error> {
        Future { [self] promise in
            firestore
                .collection(String(describing: T.self))
                .getDocuments(completion: { [self] (snapshot, _) in
                if let snapshot = snapshot, !snapshot.documents.isEmpty {
                    promise(.success(snapshot.documents.compactMap({ try? decoder.decode(T.self, from: $0.data()) })))
                }
            })
        }
        .eraseToAnyPublisher()
    }
}

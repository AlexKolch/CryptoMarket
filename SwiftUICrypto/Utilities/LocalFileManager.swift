//
//  LocalFileManager.swift
//  SwiftUICrypto
//
//  Created by Алексей Колыченков on 30.09.2024.
//

import Foundation
import SwiftUI
///универсальный класс для сохранения и получения любого изображения

final class LocalFileManager {
    static let shared = LocalFileManager(); private init() {}
    
    func save(image: UIImage, nameImage: String, nameFolder: String) {
        //Создай папку
        createFolderNameifNeeded(folderName: nameFolder)
        //Получи путь к изображению
        guard
            let data = image.pngData(),
            let url = getURLForImage(name: nameImage, nameFolder: nameFolder)
        else { print("Ошибка конвертирования image при сохранении"); return }
        //Сохрани изображение по пути
        do {
            try data.write(to: url)
        } catch let error {
            print("Ошибка записи на диск. ImageName: \(nameImage). Ошибка - \(error.localizedDescription)")
        }
    }
    
    func getImage(nameImage: String, nameFolder: String) -> UIImage? {
        guard let imageURL = getURLForImage(name: nameImage, nameFolder: nameFolder),
        FileManager.default.fileExists(atPath: imageURL.path) //если url и файл сущ
        else {return nil}
        
        return UIImage(contentsOfFile: imageURL.path) //получаем изображение из файла
    }
    
    ///проверить что папка создана. Иначе создать папку
    private func createFolderNameifNeeded(folderName: String) {
        guard let urlFolder = getURLForFolder(path: folderName) else {return}
        
        //Если папки по такому url не сущ создадим ее
        if !FileManager.default.fileExists(atPath: urlFolder.path) {
            do {
                try FileManager.default.createDirectory(at: urlFolder, withIntermediateDirectories: true) //создаем папку
            } catch let error {
                print("Ошибка создания директории. Имя папки: \(folderName). Ошибка - \(error.localizedDescription)")
            }
        }
    }
    
    ///получаем url папки
    private func getURLForFolder(path toFolder: String) -> URL? {
        ///получем url каталога с кэшем, если она будет полная и зачистится, мы сможем загрузить ихображения заново
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(toFolder) //к каталогу добавляем имя папки FileManager/folderName
    }
    
    ///url для сохранения image в папке
    private func getURLForImage(name image: String, nameFolder: String) -> URL? {
        guard let folderURL = getURLForFolder(path: nameFolder) else { print("Не получилось создать url папки"); return nil }
        return folderURL.appendingPathComponent(image + ".png") //добавялем к url папки имя изображения FileManager/folderName/imageName.png
    }
}

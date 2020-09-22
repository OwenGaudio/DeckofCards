//
//  CardController.swift
//  DeckofCards36
//
//  Created by Owen Gaudio on 9/22/20.
//  Copyright © 2020 Owen Gaudio. All rights reserved.
//

import Foundation
import UIKit.UIImage

class CardController {
    
    static let baseURL = URL(string: "https://deckofcardsapi.com/api/deck")
    static let newEndpoint = "new/draw"
    
    static func fetchCard(completion: @escaping (Result <Card, CardError>) -> Void) {
      // 1 - Prepare URL
        guard let baseURL = baseURL else {return completion(.failure(.invalidURL))}
        let newURL = baseURL.appendingPathComponent(newEndpoint)
        
        var components = URLComponents(url: newURL, resolvingAgainstBaseURL: true)
        let query = URLQueryItem(name: "count", value: "1")
        components?.queryItems = [query]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL))}
        
        print(finalURL)
      // 2 - Contact server
        URLSession.shared.dataTask(with: finalURL) { (data,_,error) in
            // 3 - Handle errors from the server
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            // 4 - Check for json data
            guard let data = data else { return completion(.failure(.noData))}
            // 5 - Decode json into a Card
            do {
                let tld = try JSONDecoder().decode(TopLevelObject.self, from: data)
                guard let card = tld.cards.first else { return completion(.failure(.noData))}
                return completion(.success(card))
            } catch {
                return completion(.failure(.thrownError(error)))
            }
        }.resume()
    }
    
    static func fetchImage(for card: Card, completion: @escaping (Result <UIImage, CardError>) -> Void) {
        // 1 - Prepare URL
        let cardURL = card.image
        // 2 - Contact server
        URLSession.shared.dataTask(with: cardURL){ (data, _, error) in
            // 3 - Handle errors from the server
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            // 4 - Check for image data
            guard let data = data else { return completion(.failure(.unableToDecode))}
            // 5 - Initialize an image from the data
            guard let image = UIImage(data: data) else {return completion(.failure(.noData))}
            return completion(.success(image))
        }.resume()
    }
}

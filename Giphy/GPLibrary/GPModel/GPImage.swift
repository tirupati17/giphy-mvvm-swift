//
//  GPImage.swift
//  Giphy
//
//  Created by Tirupati Balan on 10/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

struct GPImage: Codable {
    let type, id, slug: String?
    let url, bitlyGIFURL, bitlyURL, embedURL: String?
    let username: String?
    let source: String?
    let rating, contentURL, sourceTLD: String?
    let sourcePostURL: String?
    let isSticker: Int?
    let importDatetime, trendingDatetime: String?
    let images: Images?
    let title: String?
    let analytics: Analytics?
    
    enum CodingKeys: String, CodingKey {
        case type, id, slug, url
        case bitlyGIFURL = "bitly_gif_url"
        case bitlyURL = "bitly_url"
        case embedURL = "embed_url"
        case username, source, rating
        case contentURL = "content_url"
        case sourceTLD = "source_tld"
        case sourcePostURL = "source_post_url"
        case isSticker = "is_sticker"
        case importDatetime = "import_datetime"
        case trendingDatetime = "trending_datetime"
        case images, title, analytics
    }
}

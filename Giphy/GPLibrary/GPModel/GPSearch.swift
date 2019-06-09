//
//  GPSearch.swift
//  Giphy
//
//  Created by Tirupati Balan on 09/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation

// To parse the JSON, add this file to your project and do:
// let gPSearch = try? newJSONDecoder().decode(GPSearch.self, from: jsonData)

import Foundation

// MARK: - GPSearch
struct GPSearch: Codable {
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

// MARK: - Analytics
struct Analytics: Codable {
    let onload, onclick, onsent: Onclick?
}

// MARK: - Onclick
struct Onclick: Codable {
    let url: String?
}

// MARK: - Images
struct Images: Codable {
    let fixedHeightStill, originalStill: The480_WStill?
    let fixedWidth: FixedHeight?
    let fixedHeightSmallStill: The480_WStill?
    let fixedHeightDownsampled: FixedHeight?
    let preview: DownsizedSmall?
    let fixedHeightSmall: FixedHeight?
    let downsizedStill, downsized, downsizedLarge, fixedWidthSmallStill: The480_WStill?
    let previewWebp, fixedWidthStill: The480_WStill?
    let fixedWidthSmall: FixedHeight?
    let downsizedSmall: DownsizedSmall?
    let fixedWidthDownsampled: FixedHeight?
    let downsizedMedium: The480_WStill?
    let original, fixedHeight: FixedHeight?
    let looping: Looping?
    let originalMp4: DownsizedSmall?
    let previewGIF, the480WStill: The480_WStill?
    
    enum CodingKeys: String, CodingKey {
        case fixedHeightStill = "fixed_height_still"
        case originalStill = "original_still"
        case fixedWidth = "fixed_width"
        case fixedHeightSmallStill = "fixed_height_small_still"
        case fixedHeightDownsampled = "fixed_height_downsampled"
        case preview
        case fixedHeightSmall = "fixed_height_small"
        case downsizedStill = "downsized_still"
        case downsized
        case downsizedLarge = "downsized_large"
        case fixedWidthSmallStill = "fixed_width_small_still"
        case previewWebp = "preview_webp"
        case fixedWidthStill = "fixed_width_still"
        case fixedWidthSmall = "fixed_width_small"
        case downsizedSmall = "downsized_small"
        case fixedWidthDownsampled = "fixed_width_downsampled"
        case downsizedMedium = "downsized_medium"
        case original
        case fixedHeight = "fixed_height"
        case looping
        case originalMp4 = "original_mp4"
        case previewGIF = "preview_gif"
        case the480WStill = "480w_still"
    }
}

// MARK: - The480_WStill
struct The480_WStill: Codable {
    let url: String?
    let width, height, size: String?
}

// MARK: - DownsizedSmall
struct DownsizedSmall: Codable {
    let width, height: String?
    let mp4: String?
    let mp4Size: String?
    
    enum CodingKeys: String, CodingKey {
        case width, height, mp4
        case mp4Size = "mp4_size"
    }
}

// MARK: - FixedHeight
struct FixedHeight: Codable {
    let url: String?
    let width, height, size: String?
    let mp4: String?
    let mp4Size: String?
    let webp: String?
    let webpSize, frames: String?
    
    enum CodingKeys: String, CodingKey {
        case url, width, height, size, mp4
        case mp4Size = "mp4_size"
        case webp
        case webpSize = "webp_size"
        case frames
    }
}

// MARK: - Looping
struct Looping: Codable {
    let mp4: String?
    let mp4Size: String?
    
    enum CodingKeys: String, CodingKey {
        case mp4
        case mp4Size = "mp4_size"
    }
}

//
//  GPSearchViewControllerModelTests.swift
//  GiphyTests
//
//  Created by Tirupati Balan on 13/06/19.
//  Copyright © 2019 Celerstudio. All rights reserved.
//

import Foundation
import XCTest

@testable import Giphy

class GPImageTests : XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testGPSearchViewControllerModelAttributes() {
        let model = GPSearchViewControllerModel(gpImages: [self.testGPImageAttributes()], pagination: self.testPaginationAttributes(), meta: self.testMetaAttributes())
        XCTAssertEqual(model.gpImages, [self.testGPImageAttributes()])
        XCTAssertEqual(model.pagination, self.testPaginationAttributes())
        XCTAssertEqual(model.meta, self.testMetaAttributes())
    }
    
    // MARK: Test after application launch
    func testGPImageAttributes() -> GPImage {
        let model = GPImage(type: "1", id: "10", slug: "slug_here", url: "url_here", bitlyGIFURL: "gif_url_here", bitlyURL: "bitly_url_here", embedURL: "embed_url", username: "username", source: "source_here", rating: "rating_here", contentURL: "content_here", sourceTLD: "source_tld", sourcePostURL: "source_post_url", isSticker: 10, importDatetime: "date_time", trendingDatetime: "date_time", images: self.testImagesAttributes(), title: "hello", analytics: self.testAnalyticsAttributes())
        XCTAssertEqual(model.type, "1")
        XCTAssertEqual(model.id, "10")
        XCTAssertEqual(model.slug, "slug_here")
        XCTAssertEqual(model.url, "url_here")
        XCTAssertEqual(model.bitlyGIFURL, "gif_url_here")
        XCTAssertEqual(model.bitlyURL, "bitly_url_here")
        XCTAssertEqual(model.embedURL, "embed_url")
        XCTAssertEqual(model.username, "username")
        XCTAssertEqual(model.source, "source_here")
        XCTAssertEqual(model.rating, "rating_here")
        XCTAssertEqual(model.contentURL, "content_here")
        XCTAssertEqual(model.sourceTLD, "source_tld")
        XCTAssertEqual(model.sourcePostURL, "source_post_url")
        XCTAssertEqual(model.isSticker, 10)
        XCTAssertEqual(model.importDatetime, "date_time")
        XCTAssertEqual(model.trendingDatetime, "date_time")
        XCTAssertEqual(model.images, self.testImagesAttributes())
        XCTAssertEqual(model.title, "hello")
        XCTAssertEqual(model.analytics, self.testAnalyticsAttributes())
        return model
    }
    
    func testImagesAttributes() -> Images {
        let model = Images(fixedHeightStill: self.testThe480_WStillAttributes(),
                           originalStill: self.testThe480_WStillAttributes(),
                           fixedWidth: self.testFixedHeightAttributes(),
                           fixedHeightSmallStill: self.testThe480_WStillAttributes(),
                           fixedHeightDownsampled: self.testFixedHeightAttributes(),
                           preview: self.testDownsizedSmallAttributes(),
                           fixedHeightSmall: self.testFixedHeightAttributes(),
                           downsizedStill: self.testThe480_WStillAttributes(),
                           downsized: self.testThe480_WStillAttributes(),
                           downsizedLarge: self.testThe480_WStillAttributes(),
                           fixedWidthSmallStill: self.testThe480_WStillAttributes(),
                           previewWebp: self.testThe480_WStillAttributes(),
                           fixedWidthStill: self.testThe480_WStillAttributes(),
                           fixedWidthSmall: self.testFixedHeightAttributes(),
                           downsizedSmall: self.testDownsizedSmallAttributes(),
                           fixedWidthDownsampled: self.testFixedHeightAttributes(),
                           downsizedMedium: self.testThe480_WStillAttributes(),
                           original: self.testFixedHeightAttributes(),
                           fixedHeight: self.testFixedHeightAttributes(),
                           looping: self.testLoopingAttributes(),
                           originalMp4: self.testDownsizedSmallAttributes(),
                           previewGIF: self.testThe480_WStillAttributes(),
                           the480WStill: self.testThe480_WStillAttributes())
        
        XCTAssertEqual(model.fixedHeightStill!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.originalStill!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.fixedWidth!, self.testFixedHeightAttributes())
        XCTAssertEqual(model.fixedHeightSmallStill!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.fixedHeightDownsampled!, self.testFixedHeightAttributes())
        XCTAssertEqual(model.preview!, self.testDownsizedSmallAttributes())
        XCTAssertEqual(model.fixedHeightSmall!, self.testFixedHeightAttributes())
        XCTAssertEqual(model.downsizedStill!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.downsized!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.downsizedLarge!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.fixedWidthSmallStill!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.previewWebp!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.fixedWidthStill!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.fixedWidthSmall!, self.testFixedHeightAttributes())
        XCTAssertEqual(model.downsizedSmall!, self.testDownsizedSmallAttributes())
        XCTAssertEqual(model.fixedWidthDownsampled!, self.testFixedHeightAttributes())
        XCTAssertEqual(model.downsizedMedium!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.original!, self.testFixedHeightAttributes())
        XCTAssertEqual(model.fixedHeight!, self.testFixedHeightAttributes())
        XCTAssertEqual(model.looping!, self.testLoopingAttributes())
        XCTAssertEqual(model.originalMp4!, self.testDownsizedSmallAttributes())
        XCTAssertEqual(model.previewGIF!, self.testThe480_WStillAttributes())
        XCTAssertEqual(model.the480WStill!, self.testThe480_WStillAttributes())
        
        return model
    }

    func testPaginationAttributes() -> Pagination {
        let model = Pagination(totalCount: 1000, count: 10, offset: 0)
        XCTAssertEqual(model.totalCount, 1000)
        XCTAssertEqual(model.count, 10)
        XCTAssertEqual(model.offset, 0)
        return model
    }
    
    func testMetaAttributes() -> Meta {
        let model = Meta(status: 0, msg: "Hello", responseID: "qwertyuiop")
        XCTAssertEqual(model.status, 0)
        XCTAssertEqual(model.msg, "Hello")
        XCTAssertEqual(model.responseID, "qwertyuiop")
        return model
    }
    
    func testLoopingAttributes() -> Looping {
        let model = Looping(mp4: "yes", mp4Size: "40")
        XCTAssertEqual(model.mp4, "yes")
        XCTAssertEqual(model.mp4Size, "40")
        return model
    }
    
    func testFixedHeightAttributes() -> FixedHeight {
        let model = FixedHeight(url: "url_here", width: "50", height: "40", size: "10", mp4: "yes", mp4Size: "110", webp: "yes", webpSize: "45", frames: "50px")
        XCTAssertEqual(model.url, "url_here")
        XCTAssertEqual(model.width, "50")
        XCTAssertEqual(model.height, "40")
        XCTAssertEqual(model.size, "10")
        XCTAssertEqual(model.mp4, "yes")
        XCTAssertEqual(model.mp4Size, "110")
        XCTAssertEqual(model.webp, "yes")
        XCTAssertEqual(model.webpSize, "45")
        XCTAssertEqual(model.frames, "50px")
        return model
    }
    
    func testDownsizedSmallAttributes() -> DownsizedSmall {
        let model = DownsizedSmall(width: "40", height: "20", mp4: "yes", mp4Size: "50")
        XCTAssertEqual(model.width, "40")
        XCTAssertEqual(model.height, "20")
        XCTAssertEqual(model.mp4, "yes")
        XCTAssertEqual(model.mp4Size, "50")
        return model
    }
    
    func testThe480_WStillAttributes() -> The480_WStill {
        let model = The480_WStill(url: "url_here", width: "50", height: "40", size: "30")
        XCTAssertEqual(model.url, "url_here")
        XCTAssertEqual(model.width, "50")
        XCTAssertEqual(model.height, "40")
        XCTAssertEqual(model.size, "30")
        return model
    }

    func testAnalyticsAttributes() -> Analytics {
        let model = Analytics(onload: self.testOnclickAttributes(), onclick: self.testOnclickAttributes(), onsent: self.testOnclickAttributes())
        XCTAssertEqual(model.onload, self.testOnclickAttributes())
        XCTAssertEqual(model.onclick, self.testOnclickAttributes())
        XCTAssertEqual(model.onsent, self.testOnclickAttributes())
        return model
    }

    func testOnclickAttributes() -> Onclick {
        let model = Onclick(url: "url_here")
        XCTAssertEqual(model.url, "url_here")
        return model
    }

}

//
//  Movie.swift
//  MovieApp
//
//  Created by Vong Nyuksoon on 12/03/2022.
//
/**
 API URL: https://api.themoviedb.org/3/movie/top_rated?api_key=API_KEY&language=en-US&page=1
 
 JSON Result:
 {
 "page": 1,
 "results": [
 {
 "poster_path": "/9O7gLzmreU0nGkIB6K3BsJbzvNv.jpg",
 "adult": false,
 "overview": "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.",
 "release_date": "1994-09-10",
 "genre_ids": [
 18,
 80
 ],
 "id": 278,
 "original_title": "The Shawshank Redemption",
 "original_language": "en",
 "title": "The Shawshank Redemption",
 "backdrop_path": "/xBKGJQsAIeweesB79KC89FpBrVr.jpg",
 "popularity": 6.741296,
 "vote_count": 5238,
 "video": false,
 "vote_average": 8.32
 }
 ]
 */

import Foundation

// MARK: - Movie
struct Movie: Codable, Identifiable {
    let posterPath: String?
    let adult: Bool?
    let overview, releaseDate: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalTitle, originalLanguage , title, backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?
    let voteAverage: Double?
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
        case adult, overview
        case releaseDate = "release_date"
        case genreIDS = "genre_ids"
        case id
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case title
        case backdropPath = "backdrop_path"
        case popularity
        case voteCount = "vote_count"
        case video
        case voteAverage = "vote_average"
    }
    
    
    // MARK: - Movie.Review
    struct Review: Codable, Identifiable, Equatable {
        let author: String
        let authorDetails: AuthorDetail
        let content, createdAt, id, updatedAt: String
        let url: String

        enum CodingKeys: String, CodingKey {
            case author
            case authorDetails = "author_details"
            case content
            case createdAt = "created_at"
            case id
            case updatedAt = "updated_at"
            case url
        }
        
        static func == (lhs: Movie.Review, rhs: Movie.Review) -> Bool {
            lhs.id == rhs.id
        }
        
        var formattedCreatedAt: String {
            let dateFormatter = DateFormatter()
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            
            let localDate = dateFormatter.date(from: createdAt) ?? .distantPast
            dateFormatter.timeStyle = .short
            dateFormatter.dateStyle = .long
            
            return dateFormatter.string(from: localDate)
        }
    }
    
    var wrappedTitle: String {
        title ?? originalTitle ?? "Unknown title"
    }
    
    var wrappedPopularity: Double {
        popularity ?? 0.0
    }
    
    var wrappedVoteCount: Int {
        voteCount ?? 0
    }
    
    var wrappedVoteAverage: Double {
        voteAverage ?? 0.0
    }
    
    var wrappedAdult: Bool {
        adult ?? false
    }
    
    var wrappedOverview: String {
        overview ?? "No overview"
    }
    
    var wrappedReleaseDate: String {
        releaseDate ?? "Unknown date"
    }
    
    var wrappedVideo: Bool {
        video ?? false
    }
    
    var wrappedPosterPath: String {
        APIEndpoints.imageBaseUrl + (posterPath ?? "")
    }
    
    var wrappedBackdropPath: String {
        APIEndpoints.imageBaseUrl + (backdropPath ?? "")
    }
    
}

extension Movie {
    
    static let fakedMovie = Movie(posterPath: "/5hNcsnMkwU2LknLoru73c76el3z.jpg", adult: false, overview: "Framed in the 1940s for the double murder of his wife and her lover, upstanding banker Andy Dufresne begins a new life at the Shawshank prison, where he puts his accounting skills to work for an amoral warden. During his long stretch in prison, Dufresne comes to be admired by the other inmates -- including an older prisoner named Red -- for his integrity and unquenchable sense of hope.", releaseDate: "1994-09-10", genreIDS: [18, 80], id: 278, originalTitle: "The Shawshank Redemption", originalLanguage: "en", title: "The Shawshank Redemption", backdropPath: "/5hNcsnMkwU2LknLoru73c76el3z.jpg", popularity: 6.741296, voteCount: 5238, video: false, voteAverage: 8.32)
    
}

extension Movie.Review {
    typealias Review = Movie.Review
    
    static let mockedReview: Review = Review(author: "John Doe", authorDetails: .mockedAuthorDetail1, content: "(As I'm writing this review, Darth Vader's theme music begins to build in my mind...)\r\n\r\nWell, it actually has a title, what the Darth Vader theme. And that title is \"The Imperial March\", composed by the great John Williams, whom, as many of you may already know, also composed the theme music for \"Jaws\" - that legendary score simply titled, \"Main Title (Theme From Jaws)\".\r\n\r\nNow, with that lil' bit of trivia aside, let us procede with the fabled film currently under review: Star Wars. It had been at a drive-in theater in some small Illinois town or other where my mother, my older brother, and I had spent our weekly \"Movie Date Night\" watching this George Lucas directed cult masterpiece from our car in the parking lot. On the huge outdoor screen, the film appeared to be a silent one, but thanks to an old wire-attached speaker, we were able to hear both the character dialogue and soundtrack loud and clear. We even had ourselves a carful of vittles and snacks - walked back to our vehicle, of course, from the wide-opened cinema's briefly distant concession stand. Indeed, it had been a lovely summer evening that July.\r\n\r\nFrom the time the film started, with my brother and I following along as our mother sped-read the opening crawl, I began to feel rather antsy, thinking that this movie, the first in a franchise that would soon be world-renowned, was going to be boring, due to its genre being Science Fiction: A respectably likable, but not a passionately lovable genre of mine DURING THAT TIME. I just didn't believe I was going to like Star Wars all that much ... But I soon found myself intrigued ... And awed.\r\n\r\nGeorge Lucas is a man with a phenomenal, and I do mean phenomenal imagination. Apart from his human characters (Han, Luke, Leia, and Obi-Wan Kenobi, among others), the droids: C-3P0, R2-D2, R2-series, and IG-88, not to mention those unusual characters like Jabba the Hutt, Yoda, and Chewbacca, just to name a few, are all creations of Lucas's phenomenal imagination. And I was completely in awe of each one of these strange beings. Then there was Vader ... And the evil Emperor ... And the Stormtroopers ... And the Spacecraft ... And the galaxies (I'll admit that I am a huge lover of the Universe in all its Celestial glory) ... And the magnificent planets ... The Lightsabers ... And so on. Star Wars is a gorgeously shot space opera; it is truly an epic masterpiece. We enjoyed this film tremendously. And my brother was a die-hard fan from that night onward. He, my brother, had even received for Christmas that year, nearly every Star Wars action figure that my mother could find, including two of the spacecraft: The Millennium Falcon and Star Destroyer. The Death Star space station had too been wrapped beneath our Christmas tree - tagged with his name. It was totally crazy, what the new Star Wars era. Frenzied! But it was great ... Even still, to this day.\r\n\r\nI don't personally know anyone whom has yet to see Star Wars, but that certainly doesn't suggest there are still a few people out there who haven't. And if you're one of the latter, then you should know that this classic space opera comes highly recommended. The entire series is told backwards, so you'll definitely want to see Star Wars first, followed by its two sequels: The Empire Strikes Back and Return of the Jedi ... In that order. I trust that you'll too discover yourself to be a lifelong cult fan in the wake. 😊", createdAt: "2017-02-13T22:23:01.268Z", id: "58a231c5925141179e000674", updatedAt: "2017-02-13T23:16:19.538Z", url: "https://www.themoviedb.org/review/58a231c5925141179e000674")
}

//
//  MovieWidget.swift
//  MovieWidget
//
//  Created by Vong Nyuksoon on 06/06/2022.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> MovieEntry {
        MovieEntry(date: Date(), poster: UIImage(named: "placeholder")!, title: "Sample Movie", rating: 5.0, family: context.family)
    }
    func getSnapshot(in context: Context, completion: @escaping (MovieEntry) -> Void) {
        let date = Date()
        let entry: MovieEntry = MovieEntry(date: date, poster: UIImage(named: "placeholder")!, title: "Sample Movie", rating: 5.0, family: context.family)
        
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<MovieEntry>) -> Void) {
        print("--------TIMELINE STARTED")
        WebService.fetchFirstMovie { firstMovie in
            
            let entry: MovieEntry
            
            // Create a timeline entry for "now."
            let date = Date()
            
            // Update popular list every hour
            let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: date)!
            
            if let firstMovie = firstMovie {
                entry = MovieEntry(date: date, poster: firstMovie.poster, title: firstMovie.title, rating: firstMovie.rating, family: context.family)
            } else {
                entry = MovieEntry(date: date, poster: UIImage(named: "placeholder")!, title: "No movies", rating: 0.0, family: context.family)
                
            }
            
            // Create the timeline with the entry and a reload policy with the date
            // for the next update.
            let timeline = Timeline(
                entries: [entry],
                policy: .after(nextDate)
            )
            
            print("--------TIMELINE ENDED")
            
            // Call the completion to pass the timeline to WidgetKit.
            completion(timeline)
        }
    }
}

struct MovieEntry: TimelineEntry {
    let date: Date
    let poster: UIImage
    let title: String
    let rating: Double
    //        let configuration: ConfigurationIntent
    let family: WidgetFamily
}

struct MovieWidgetEntryView : View {
    var entry: Provider.Entry
    
    let gradient = LinearGradient(
        stops: [
            Gradient.Stop(color: Color("WidgetBackground").opacity(0.95), location: .zero),
            Gradient.Stop(color: Color("PrimaryColor"), location: 1.75),
            Gradient.Stop(color: Color("PrimaryColor"), location: 2.0)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
    
    @ViewBuilder
    var body: some View {
        switch entry.family {
        case .systemLarge:
            VStack(alignment: .leading, spacing: 8) {
                
                Text(entry.date, style: .date)
                    .font(.subheadline)
                    .opacity(0.7)
                
                Spacer()
                
                Text(entry.title)
                    .font(.title)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                
                RatingView(rating: entry.rating)
                    .font(.subheadline)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            .background(
                ZStack {
                    Image(uiImage: entry.poster)
                        .resizable()
                        .scaledToFill()
                    
                    gradient.ignoresSafeArea()
                        .colorMultiply(Color("PrimaryColor").opacity(0.9))
                        .opacity(0.9)
                }
            )
            .foregroundColor(.white)
            
        case .systemSmall:
            VStack(alignment: .leading, spacing: 8) {
                
                Text(entry.date, style: .date)
                    .font(.caption2)
                    .opacity(0.7)
                
                Spacer()
                
                Text(entry.title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .fixedSize(horizontal: false, vertical: true)
                
                RatingView(rating: entry.rating)
                    .font(.caption2)
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            
            .background(
                ZStack {
                    Image(uiImage: entry.poster)
                        .resizable()
                        .scaledToFill()
                    
                    gradient.ignoresSafeArea()
                        .colorMultiply(Color("PrimaryColor").opacity(0.9))
                        .opacity(0.9)
                }
            )
            .foregroundColor(.white)
            
        default:
            ZStack {
                gradient.ignoresSafeArea()
                
                HStack {
                    Image(uiImage: entry.poster)
                        .resizable()
                        .frame(width: 120, height: 120)
                        .scaledToFit()
                        .cornerRadius(12)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(entry.title)
                            .font(.title2)
                            .fontWeight(.medium)
                        
                        RatingView(rating: entry.rating)
                            .font(.footnote)
                        
                        Spacer()
                        Text(entry.date, style: .date)
                            .opacity(0.7)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .foregroundColor(.white)
            //            .background(ContainerRelativeShape().fill(gradient))
        }
    }
}

@main
struct MovieWidget: Widget {
    let kind: String = "MovieWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(
            kind: kind,
            provider: Provider()) { entry in
                MovieWidgetEntryView(entry: entry)
            }
            .configurationDisplayName("My Widget")
            .description("This is an example widget.")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

struct MovieWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MovieWidgetEntryView(entry: MovieEntry(
                date: Date(),
                poster: UIImage(named: "placeholder")!,
                title: "Sample Movie",
                rating: 5.0,
                family: WidgetFamily.systemSmall
            ))
                .previewDisplayName("Small widget")
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            MovieWidgetEntryView(entry: MovieEntry(
                date: Date(),
                poster: UIImage(named: "placeholder")!,
                title: "Sample Movie",
                rating: 5.0,
                family: WidgetFamily.systemMedium
            ))
                .previewDisplayName("Medium widget")
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            MovieWidgetEntryView(entry: MovieEntry(
                date: Date(),
                poster: UIImage(named: "placeholder")!,
                title: "Sample Movie",
                rating: 5.0,
                family: WidgetFamily.systemLarge
            ))
                .previewDisplayName("Small widget")
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

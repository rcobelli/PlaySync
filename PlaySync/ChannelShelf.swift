/*
 See the LICENSE.txt file for this sample’s licensing information.
 
 Abstract:
 A view that shows a shelf of movies.
 */

import SwiftUI

struct ChannelShelf: View {
	@State private var action: Int? = 0
	var channels: [Channel]
	
	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: 40) {
				ForEach(channels) { ch in
					NavigationLink(destination: PlayerView(channel1: ch.channelNum), label: {
						VStack(alignment: .leading) {
							ThumbnailGenerator(categories: ch.categories)
								.hoverEffect(.highlight)
							Text(ch.title)
								.font(.body)
								.padding(12)
								.lineLimit(2)
							Spacer(minLength: 0)
							Text(ch.categories.filter({ cat in
								!cat.contains("ESPN") && !cat.contains("ACC") && !cat.contains("SEC") && !cat.contains("FOX") && !cat.contains("Sports") && !cat.contains("HD") && !cat.contains("Competition") && !cat.contains("Paramount+")
							})
							.joined(separator: ", "))
							.font(.caption2)
							.foregroundStyle(.secondary)
							.lineLimit(1)
							.padding(12)
						}
					}).frame(width: 375)
				}
			}
		}
		.scrollClipDisabled()
		.buttonStyle(.borderless)
	}
}

#Preview {
	ChannelShelf(channels: [
		Channel(channelNum: 1,
				title: "Alpha Bravo Charlie Delta Echo Foxtrott Gulf Hotel Indigio Juliette Kilo Lima ",
				icon: URL(string: "https://artwork.api.espn.com/artwork/collections/airings/ec2d8275-a137-4cb6-a8bf-3a380875ac4d/default?width=640&amp;apikey=1ngjw23osgcis1i1vbj96lmfqs")!,
				categories: ["ESPN", "Soccer"]),
		Channel(channelNum: 2,
				title: "Bravo",
				icon: URL(string: "https://artwork.api.espn.com/artwork/collections/airings/ec2d8275-a137-4cb6-a8bf-3a380875ac4d/default?width=640&amp;apikey=1ngjw23osgcis1i1vbj96lmfqs")!,
				categories: ["ESPN", "Soccer"])
	])
}

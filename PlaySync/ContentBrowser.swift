//
//  ContentView.swift
//  PlaySync
//
//  Created by Ryan Cobelli on 8/30/24.
//

import SwiftUI

struct ContentBrowser: View {
	private var showcaseHeight: CGFloat = 800
	@State var channels: [Channel] = []
	@State var selectedChannels: [Channel?] = [nil, nil, nil, nil]
	@State var categoriesSet: Set<String> = []
	@FocusState var startPlaybackFocused
	
	var body: some View {
		NavigationStack {
			
			VStack(alignment: .leading, spacing: 26) {
				// The header/showcase view.
				HStack() {
					Text("Rybel ").font(.largeTitle).bold() +
					Text("PlaySync").font(.largeTitle).fontWeight(.thin)
					Spacer()
					Text("\(selectedChannels.count)").font(.title2).foregroundStyle(selectedChannels.count == 4 ? .green : .black)
				}
				.frame(maxWidth: .infinity, alignment: .leading)
				.focusSection()
				HStack() {
					Button("\(Image(systemName: "arrow.clockwise"))", action: loadData)
					NavigationLink("\(Image(systemName: "play.tv"))", value: "")
						.disabled(selectedChannels.count != 4)
						.navigationDestination(for: String.self) { _ in
							PlayerView(channel1: selectedChannels[0],
									   channel2: selectedChannels[1],
									   channel3: selectedChannels[2],
									   channel4: selectedChannels[3]
							)
						}
						.focused($startPlaybackFocused)
				}.zIndex(1000)
				
				ScrollView(.vertical) {
					LazyVStack(alignment: .leading) {
						ForEach(categoriesSet.sorted(), id: \.self) { cat in
							Text(cat).font(.title3)
							ScrollView(.horizontal) {
								LazyHStack(spacing: 40) {
									ForEach(channels.filter({ channel in channel.categories.joined().contains(cat)})) { ch in
										Button(action: {
											if selectedChannels.contains(ch) {
												selectedChannels.remove(at: selectedChannels.firstIndex(of: ch)!)
											} else {
												selectedChannels.insert(ch, at: 0)
											}
											
											startPlaybackFocused = selectedChannels.count == 4
										}, label: {
											VStack {
												ThumbnailGenerator(broadcaster: ch.broadcaster, categories: ch.categories, selected: selectedChannels.contains(ch)).hoverEffect(.highlight).frame(maxWidth:350)
												Text(ch.title)
													.font(.body)
													.lineLimit(2)
												Spacer()
												Text(ch.categories.filter({ c in c != cat}).joined(separator: ", ")).font(.caption2)
											}
										})
										.buttonStyle(.borderless)
										.frame(maxWidth: 375)
									}
								}
								.scrollClipDisabled()
							}
						}
					}
					.scrollClipDisabled()
				}
			}
			.background(alignment: .top) {
				HeroHeaderView()
			}
			.scrollClipDisabled()
			.frame(maxHeight: .infinity, alignment: .top)
		}.onAppear(perform: loadData)
	}
}


extension ContentBrowser
{
	func loadData() {
		selectedChannels = []
		categoriesSet = []
		APIManager.shared.getChannels(success: { channels in
			self.channels = channels
			
			let _ = channels.map({ ch in
				ch.categories.map({ cat in
					categoriesSet.insert(cat)
				})
			})
			
		}, failure: { reason in
			print(reason)
		})
	}
}

#Preview {
	ContentBrowser()
}

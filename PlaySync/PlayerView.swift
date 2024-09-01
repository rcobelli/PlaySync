//
//  PlayerView.swift
//  PlaySync
//
//  Created by Ryan Cobelli on 8/30/24.
//

import SwiftUI
import AVKit

struct PlayerView: View {
	@State private var player1 = AVPlayer()
	@State private var player2 = AVPlayer()
	@State private var player3 = AVPlayer()
	@State private var player4 = AVPlayer()
	@FocusState private var focusedPlayer1: Bool
	@FocusState private var focusedPlayer2: Bool
	@FocusState private var focusedPlayer3: Bool
	@FocusState private var focusedPlayer4: Bool
	@State var channel1 : Channel
	@State var channel2 : Channel
	@State var channel3 : Channel
	@State var channel4 : Channel
	@State private var labelsVisible = true
	@State private var channel1FullScreen = false
	@State private var channel2FullScreen = false
	@State private var channel3FullScreen = false
	@State private var channel4FullScreen = false
	
	var body: some View {
		Grid(horizontalSpacing: 0, verticalSpacing: 0) {
			GridRow {
				Button(action: {
					channel1FullScreen = true
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
						player1.isMuted = false
					})
				}) {
					if labelsVisible {
						Text(channel1.title)
					}
					VideoPlayer(player: player1)
				}
				.focused($focusedPlayer1)
				.onChange(of: $focusedPlayer1.wrappedValue) { _, currFocus in
					player1.isMuted = !currFocus
				}
				.border(Color.white, width: focusedPlayer1 ? 3 : 0)
				.buttonStyle(.borderless)
				.fullScreenCover(isPresented: $channel1FullScreen, content: {
					VideoPlayer(player: player1)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.ignoresSafeArea(edges: .all)
				})
				
				Button(action: {
					channel2FullScreen = true
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
						player2.isMuted = false
					})
				}) {
					if labelsVisible {
						Text(channel2.title)
					}
					VideoPlayer(player: player2)
				}
				.focused($focusedPlayer2)
				.onChange(of: $focusedPlayer2.wrappedValue) {  _, currFocus in
					player2.isMuted = !currFocus
				}
				.border(Color.white, width: focusedPlayer2 ? 3 : 0)
				.buttonStyle(.borderless)
				.fullScreenCover(isPresented: $channel2FullScreen, content: {
					VideoPlayer(player: player2)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.ignoresSafeArea(edges: .all)
				})
			}
			GridRow {
				Button(action: {
					channel3FullScreen = true
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
						player3.isMuted = false
					})
				}) {
					if labelsVisible {
						Text(channel3.title)
					}
					VideoPlayer(player: player3)
				}
				.focused($focusedPlayer3)
				.onChange(of: $focusedPlayer3.wrappedValue) {  _, currFocus in
					player3.isMuted = !currFocus
				}
				.border(Color.white, width: focusedPlayer3 ? 3 : 0)
				.buttonStyle(.borderless)
				.fullScreenCover(isPresented: $channel3FullScreen, content: {
					VideoPlayer(player: player3)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.ignoresSafeArea(edges: .all)
				})
				
				Button(action: {
					channel4FullScreen = true
					DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
						player4.isMuted = false
					})
				}) {
					if labelsVisible {
						Text(channel4.title)
					}
					VideoPlayer(player: player4)
				}
				.focused($focusedPlayer4)
				.onChange(of: $focusedPlayer4.wrappedValue) {  _, currFocus in
					player4.isMuted = !currFocus
				}
				.border(Color.white, width: focusedPlayer4 ? 3 : 0)
				.buttonStyle(.borderless)
				.fullScreenCover(isPresented: $channel4FullScreen, content: {
					VideoPlayer(player: player4)
						.frame(maxWidth: .infinity, maxHeight: .infinity)
						.ignoresSafeArea(edges: .all)
				})
			}.padding(0)
		}
		.onAppear {
			UIApplication.shared.isIdleTimerDisabled = true
			
			player1.replaceCurrentItem(with: AVPlayerItem(url: URL(string: "http://10.0.0.136:8000/channels/\(channel1.channelNum).m3u8")!))
			player2.replaceCurrentItem(with: AVPlayerItem(url: URL(string: "http://10.0.0.136:8000/channels/\(channel2.channelNum).m3u8")!))
			player3.replaceCurrentItem(with: AVPlayerItem(url: URL(string: "http://10.0.0.136:8000/channels/\(channel3.channelNum).m3u8")!))
			player4.replaceCurrentItem(with: AVPlayerItem(url: URL(string: "http://10.0.0.136:8000/channels/\(channel4.channelNum).m3u8")!))
			
			player1.isMuted = true
			player2.isMuted = true
			player3.isMuted = true
			player4.isMuted = true
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
				player1.play()
				player1.seekToLive()
				player2.play()
				player2.seekToLive()
				player3.play()
				player3.seekToLive()
				player4.play()
				player4.seekToLive()
			})
			
			
			DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: {
				labelsVisible = false
			})
		}
		.onDisappear {
			UIApplication.shared.isIdleTimerDisabled = false
			
			player1.pause()
			player2.pause()
			player3.pause()
			player4.pause()
		}
		.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
		.edgesIgnoringSafeArea(.all)
	}
}

extension AVPlayer {
	func seekToLive() {
		if let items = currentItem?.seekableTimeRanges, !items.isEmpty {
			let range = items[items.count - 1]
			let timeRange = range.timeRangeValue
			let startSeconds = CMTimeGetSeconds(timeRange.start)
			let durationSeconds = CMTimeGetSeconds(timeRange.duration)

			seek(to: CMTimeMakeWithSeconds(startSeconds + durationSeconds, preferredTimescale: 1))
		}
	}
}


#Preview {
	PlayerView(channel1: Channel(channelNum: 1, title: "Alpha", broadcaster: "ESPN", categories: []),
			   channel2: Channel(channelNum: 2, title: "Bravo", broadcaster: "ESPN", categories: []),
			   channel3: Channel(channelNum: 3, title: "Charlie", broadcaster: "ESPN", categories: []),
			   channel4: Channel(channelNum: 4, title: "Delta", broadcaster: "ESPN", categories: []))
}

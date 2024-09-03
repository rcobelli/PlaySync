/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The data model for generating sample code artwork.
*/

import SwiftUI

let colors: [Color] = [
    .red,
    .orange,
    .yellow,
    .green,
    .teal,
    .mint,
    .cyan,
    .blue,
    .indigo,
    .purple,
    .pink,
    .brown,
    .gray
]

struct ThumbnailGenerator: View {
    var size: CGSize = CGSize(width: 350, height: 200)
    var color: Color
	var icon: Image
	var selected: Bool

	init(broadcaster: String, categories: [String], selected: Bool = false) {
		self.selected = selected
		
		if broadcaster == "ESPN" {
			color = .red
		} else if broadcaster == "FOX" {
			color = .blue
		} else {
			color = .teal
		}
		
		
		if categories.joined().contains("Serie") || categories.joined().contains("Soccer") {
			icon = Image(systemName: "soccerball")
		} else if categories.joined().contains("Football") {
			icon = Image(systemName: "football")
		} else if categories.joined().contains("Auto racing") || categories.joined().contains("F1") {
			icon = Image(systemName: "car.side")
		} else if categories.joined().contains("Race") || categories.joined().contains("racing") {
			icon = Image(systemName: "medal")
		} else if categories.joined().contains("Rugby") {
			icon = Image(systemName: "figure.rugby")
		} else if categories.joined().contains("Golf") {
			icon = Image(systemName: "figure.golf")
		} else if categories.joined().contains("Basketball") {
			icon = Image(systemName: "basketball")
		} else if categories.joined().contains("Baseball") {
			icon = Image(systemName: "baseball")
		} else if categories.joined().contains("Sailing") {
			icon = Image(systemName: "sailboat")
		} else if categories.joined().contains("Tennis") {
			icon = Image(systemName: "tennis.racket")
		} else if categories.joined().contains("Volleyball") {
			icon = Image(systemName: "volleyball")
		} else if categories.joined().contains("Dogs") {
			icon = Image(systemName: "dog")
		} else if categories.joined().contains("Lacrosse") {
			icon = Image(systemName: "figure.lacrosse")
		} else {
			icon = Image(systemName: "sportscourt")
		}
    }

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(color.gradient)
                .saturation(0.8)
                .aspectRatio(size.width / size.height, contentMode: .fill)
				.border(Color.white, width: selected ? 10 : 0)

            Text("\(icon)")
                .font(.system(size: 160, design: .rounded))
                .minimumScaleFactor(0.2)
                .foregroundColor(.white)

        }
    }
}

#Preview("AppIcon") {
	ThumbnailGenerator(broadcaster: "ESPN", categories: ["Soccer"])
}

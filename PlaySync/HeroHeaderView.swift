/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A view that shows the header for a hero view.
*/

import SwiftUI

struct HeroHeaderView: View {
    
    var body: some View {
        Image("hero")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay {
                // The view builds the material gradient by filling an area with
                // a material, and then masking that area using a linear
                // gradient.
                Rectangle()
                    .fill(.regularMaterial)
                    .mask {
                        maskView
                    }
            }
            .ignoresSafeArea()
    }

    var maskView: some View {
        // The gradient makes direct use of the `belowFold` property to
        // determine the opacity of its stops.  This way, when `belowFold`
        // changes, the gradient can animate the change to its opacity smoothly.
        // If you swap out the gradient with an opaque color, SwiftUI builds a
        // cross-fade between the solid color and the gradient, resulting in a
        // strange fade-out-and-back-in appearance.
        LinearGradient(
            stops: [
				.init(color: .black, location: 0.35),
				.init(color: .black.opacity(0.9), location: 1.0)
            ],
            startPoint: .bottom, endPoint: .top
        )
    }
}

#Preview {
    HeroHeaderView()
}

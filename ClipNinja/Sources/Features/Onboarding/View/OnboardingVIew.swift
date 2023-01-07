//
//  SwiftUIView.swift
//  
//
//  Created by Libor Huspenina on 07.01.2023.
//

import SwiftUI

struct OnboardingView<ViewModel: OnboardingViewModel>: View {

    @StateObject private var viewModel: ViewModel

    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(viewModel.title)
                .font(.title)

            ForEach(viewModel.descriptions, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row, id: \.self) {
                        Text($0.description)
                            .bold($0.prominent)
                            .foregroundColor($0.prominent ? Colors.prominent : Colors.defaultTextColor)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding()
    }
}

class ViewModelStub: OnboardingViewModel {
    var title: String = "Welcome!"
    var descriptions: [[DescriptiveText]] = [
        [.init(prominent: false, description: "Let's learn how this works!")],
        [.init(prominent: false, description: "Use arrows to navigate through "), .init(prominent: true, description: "CLIPS"), .init(prominent: false, description: ".")]
    ]

    func onEvent(_ event: OnboardingEvent) { }
}

struct OnboardingView_Previews: PreviewProvider {


    static var previews: some View {
        OnboardingView(viewModel: ViewModelStub())
            .frame(width: 450, height: 400)
    }
}

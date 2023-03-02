//
//  ContentView.swift
//  20230301-FisehaGezahegn-Chase
//
//  Created by Fiseha Gezahegn on 3/1/23.
//

import SwiftUI

struct WeatherSearchView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherSearchView()
    }
}

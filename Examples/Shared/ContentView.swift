//
//  ContentView.swift
//  Examples
//
//  Created by Chris Mash on 20/12/2020.
//

import SwiftUI
import ProvisioningProfile

struct ContentView: View {
    var body: some View {
        VStack {
            // Name of the profile
            ProvisioningProfile.profile()?.name.map {
                Text("Profile:\n\($0)")
            }
            
            Divider()

            // formatted expiry date
            ProvisioningProfile.profile()?.formattedExpiryDate.map {
                Text("Formatted expiry date:\n\($0)")
            }

            Divider()

            // raw expiry date
            ProvisioningProfile.profile()?.expiryDate.map {
                Text("Raw expiry date:\n\($0)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

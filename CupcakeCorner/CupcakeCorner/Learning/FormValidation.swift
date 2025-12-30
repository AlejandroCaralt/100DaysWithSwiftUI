//
//  FormValidation.swift
//  CupcakeCorner
//
//  Created by Alejandro Caralt on 10/12/25.
//

import SwiftUI

struct FormValidation: View {
    @State private var username = ""
    @State private var email = ""

    var disableForm: Bool {
        username.count < 5 || email.count < 5
    }

    var body: some View {
        Form {
            Section {
                TextField("Username", text: $username)
                TextField("Email", text: $email)
            }
            
            Section {
                Button("Create acount") {
                    print("Creating account...")
                }
            }
            .disabled(disableForm)
        }
    }
}

#Preview {
    FormValidation()
}

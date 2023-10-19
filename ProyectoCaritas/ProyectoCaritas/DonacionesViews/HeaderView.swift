//
//  HeaderView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 19/10/23.
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        VStack {
            
            Text("DONACIONES")
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .bold()
                .frame(width:1000)
                .padding(.bottom, 30)
                .padding(.top, 80)
                .background(ColorPrincipal)
                .foregroundColor(.white)
                
                
            
        }
        
        .edgesIgnoringSafeArea(.top)
        .padding(.bottom, -40)
    
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

//
//  ReciboView.swift
//  ProyectoCaritas
//
//  Created by Alumno on 20/10/23.
//

import SwiftUI

struct ReciboView: View {
    @State var recibo: recibosActivos
    @State private var confirmarAccion: Bool = false
    @State private var errorAlert: Bool = false
    @State private var comentarios: Bool = false
    @Environment(\.presentationMode) var presentationMode

    var token: String

    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading){
                    VStack(alignment: .leading){
                        HStack(alignment: .center){
                            
                            Text("#\(String(format: "%06d", Int(recibo.id)!))")
                                .font(.largeTitle)
                                .bold()
                                .padding(.leading, 20)
                            Spacer()
                            
                            Text("$\(Int(recibo.cantidad))")
                                .font(.title)
                                .foregroundColor(Color(red: 0.003, green: 0.208, blue: 0.327))
                            
                                .font(.title)
                                .padding(.trailing, 20)
                                .foregroundColor(Color(red: 0.003, green: 0.208, blue: 0.327))
                            
                        }.padding(.bottom, 8)
                        
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }

                HStack {
                    Spacer()

                    Button(action: {
                        confirmarAccion.toggle()
                    }) {
                        Text("Cobrado")
                            .padding(.horizontal, 20)
                            .padding(.vertical, 34)
                            .font(Font.system(size: 26, design: .default))
                        
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(ColorPrincipal)
                    .alert("¿Deseas marcar el recibo como cobrado?", isPresented: $confirmarAccion) {
                        Button("Si") {
                            let response = cobrarRecibo(recibo: recibo.id, token: token)
                            if response == false {
                                errorAlert.toggle()
                                presentationMode.wrappedValue.dismiss()
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                        Button("No") {}
                    }

                    NavigationLink(destination: ComentariosView(recibo: recibo.id, token: token), isActive: $comentarios) {
                        Text("No Cobrado")
                            .font(Font.system(size: 26, design: .default))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 20)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)

                    Spacer()
                }
                .padding(.bottom, 20)
            }
            .padding(.top, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .background(Color.white)
        }
    }
}


struct ReciboView_Previews: PreviewProvider {
    static var previews: some View {
        ReciboView(recibo: recibosActivos(cantidad: 200.0, id: "1", cobrado: 2 ,donante: Donante(id: "", nombres: "", apellidos: "", direccion: "", latitude: 0.0, longitude: 0.0, telCelular: "", telCasa: "")), token:"")
    }
}

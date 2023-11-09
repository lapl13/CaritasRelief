//
//  ComentariosView.swift
//  ProyectoCaritas
//
//  Created by J. Lugo on 21/10/23.
//

import SwiftUI

struct ComentariosView: View {
    var recibo:String
    var token:String
    @Environment(\.dismiss) private var dismiss
    @State private var confirmation = false
    @State private var done = false
    @State private var text:String = ""
    var body: some View {
        VStack{
            ZStack{
                HeaderView(titulo: "COMENTARIOS")
            }
            
            TextField("e.g. Cliente no estaba, no tenía el dinero, etc.", text:$text,axis: .vertical)
            
                .textFieldStyle(.roundedBorder)
                .frame(width: 350)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(10,reservesSpace: true)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(.black))
                .font(.system(size: 20))
            Spacer()
            Button(action: confirm){
                Text("Enviar")
                    .padding(.horizontal,120 )
                    .padding(.vertical,12)
                    .font(.title)
            }.buttonStyle(.borderedProminent)
                .tint(ColorPrincipal)
                .alert("¿Estas seguro de que deseas enviar los comentarios?",isPresented: $confirmation){
                    Button("No"){}
                    Button("Si"){
                        sendComments(recibo: recibo, comentarios: text, token: token)
                        done.toggle()
                        
                    }
                }
                .alert("Comentarios enviados exitosamente",isPresented: $done){
                    Button("Ok"){
                        dismiss()
                    }
                }
        }
    }
    func confirm(){
        confirmation.toggle()
        
    }
}

struct ComentariosView_Previews: PreviewProvider {
    static var previews: some View {
        ComentariosView(recibo: "", token: "")
    }
}

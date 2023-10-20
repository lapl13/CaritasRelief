//
//  ModelData.swift
//  ProyectoCaritas
//
//  Created by J. Lugo on 18/10/23.
//

import Foundation
import SwiftUI

var ColorPrincipal = Color(red:0,green: 156/255,blue: 166/255)
var ColorSecundario = Color(red:0,green: 59/255,blue: 92/255)

struct User:Codable{
    let token: String
    let role: Int
    let user: [Int]
}

struct Response: Codable {
    let data: DataResponse
}

struct DataResponse: Codable {
    let recibos: [Recibo]
}


struct ReceiptDataClass:Codable{
    let recibos:[Recibo]
}

struct Recibo:Codable, Identifiable{
    let id: String
    let idDonante, cantidad: Int
    let cobrado: Bool
    let fecha: String
    let comentarioHorario: String
    let activo: Bool
    let donante: Persona
}

struct Persona:Codable{
    let nombres:String
    let apellidos:String
    let direccion:String
}

func login(username: String, password: String) -> User? {
    var user: User?
    
    let body = """
    {
        "username": "\(username)",
        "password": "\(password)"
    }
    """
    
    guard let url = URL(string: "http://localhost:5122/auth/login") else {
        return nil
    }
    
    var request = URLRequest(url: url)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = body.data(using: .utf8)
    
    let semaphore = DispatchSemaphore(value: 0)
    
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer { semaphore.signal() }
        let jsonDecoder = JSONDecoder()
        if let data = data {
            do {
                user = try jsonDecoder.decode(User.self, from: data)
            } catch {
                print(error)
            }
        }
    }
    
    task.resume()
    semaphore.wait()
    
    return user
}


func getRecibos(token:String) -> [Recibo] {
    let graphQLQuery = """
        {
          recibos(where: { recolector: { id: { eq: 2 } } }) {
            id
            idDonante
            cantidad
            cobrado
            fecha
            comentarioHorario
            activo
            recolector {
              nombres
              apellidos
            }
            donante {
              nombres
              apellidos
              direccion
            }
          }
        }
        """
    guard let url = URL(string: "http://localhost:5053/graphql") else {
        return []
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    // Replace "YOUR_AUTH_TOKEN_HERE" with your actual authorization token
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

    let requestBody = ["query": graphQLQuery]
    do {
        let jsonData = try JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = jsonData
    } catch {
        print("Error creating request body: \(error)")
        return []
    }

    var lista: [Recibo] = []

    let semaphore = DispatchSemaphore(value: 0)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        defer {
            semaphore.signal()
        }

        if let error = error {
            print("Error: \(error)")
            return
        }

        if let data = data {
            let jsonDecoder = JSONDecoder()
            do {
                let response = try jsonDecoder.decode(Response.self, from: data)
                lista = response.data.recibos
            } catch {
                print("Error decoding GraphQL response: \(error)")
            }
        }
    }
    task.resume()

    semaphore.wait()
    return lista
}
/*

// Usage:
let recibos = getRecibos()
for recibo in recibos {
    print("Recibo ID: \(recibo.id)")
    // Add additional processing as needed
}
*/

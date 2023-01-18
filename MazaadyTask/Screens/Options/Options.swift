//
//  Options.swift
//  MazaadyTask
//
//  Created iMokhles on 17/01/2023.
//  

/// Options Model
struct  Options: Codable {
    
    // Your Model Structure
    let id: Int?
    let name, slug: String?
    let parent: Int?
    let child: Bool?
    
}

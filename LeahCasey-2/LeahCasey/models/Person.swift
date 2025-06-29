//
//  Person.swift
//  Multiple Screen App
//
//  Created by Sabin Tabirca on 10/02/2025.
//
import Foundation

class Person{
    var name, position, age, nationality, goals, url, image, favourite : String
    
    init(name: String, position:String, age: String, nationality: String,  goals:String, url: String, image: String, favourite:String) {
        self.name = name
        self.position = position
        self.age = age
        self.nationality = nationality
        self.goals = goals
        self.url = url
        self.image = image
        self.favourite = favourite
    }
}


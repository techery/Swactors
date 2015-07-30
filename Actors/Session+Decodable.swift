//
//  Session+Decodable.swift
//  Actors
//
//  Created by Anastasiya Gorban on 7/30/15.
//  Copyright (c) 2015 Techery. All rights reserved.
//

import Argo
import Runes

extension Session: Decodable {
  static func create(token: String) -> Session {
    return Session(token: token)
  }

  static func decode(j: JSON) -> Decoded<Session> {
    return Session.create
      <^> j <| "token"
  }
}
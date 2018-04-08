//
//  Thread.swift
//  Naeps
//
//  Created by Mikael on 4/8/18.
//  Copyright © 2018 Mikael-Melkonyan. All rights reserved.
//

import Foundation

func main(_ dispatch: @escaping (() -> ())) {
    DispatchQueue.main.async {
        dispatch()
    }
}

func background(_ dispatch: @escaping (() -> ())) {
    DispatchQueue.global(qos: .background).async {
        dispatch()
    }
}

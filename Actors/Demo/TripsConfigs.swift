//
// Created by Anastasiya Gorban on 8/7/15.
// Copyright (c) 2015 Techery. All rights reserved.
//

import Foundation

class TripsConfigs: PlistConfigs {
    struct Keys {
        static let baseURL = "base_api_url"
        static let settingsURL = "configuration_json_url"
    }

    init() {
        super.init(fileName: "Development-Config")
    }    
}

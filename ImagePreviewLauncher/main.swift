//
//  main.swift
//  ImagePreviewLauncher
//
//  Created by Yohta Watanave on 2020/02/19.
//  Copyright © 2020 Yohta Watanave. All rights reserved.
//

import Foundation

DistributedNotificationCenter.default()
    .post(name: NSNotification.Name("SHOW_IMAGE"), object: "tech.watanave.ImagePreview")


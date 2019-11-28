//
//  CircleImage.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ng on 2019/10/9.
//  Copyright © 2019 Hem1ng. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    var body: some View {
        Image("screenshot")
            //设置大小
            .frame(width: 240, height: 240, alignment: .center)
            //调用.clipShape(Circle())方法，创建圆形视图
            .clipShape(Circle())
            //添加圆形边框，填充白色，宽度为4
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            //添加阴影，半径为10
            .shadow(radius: 10)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}

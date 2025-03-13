//
//  FormView.swift
//  HTProject_SwiftUI
//
//  Created by Hem1ngT4i on 2021/6/19.
//  Copyright © 2021 Hem1ngT4i. All rights reserved.
//

import SwiftUI

struct FormView: View {
    
    //@State会自动关注属性值的变化，一旦值发生变化，则会重新load视图，双向绑定
    @State private var userName = ""
    @State private var password = ""
    @State private var age = 0
    @State private var male = true
    @State private var info = "Here is some editable text..."
    @State private var progress = 0.5
    
    var body: some View {
        NavigationView {
            if #available(iOS 14.0, *) {
                Form { //不使用group，Form最多只能显示10个子元素
                    //            Text("hello, world")
                    //                     ...
                    //            Text("hello, world")
                    
                    //使用group，每个group最多能显示10个子元素
                    //注意，group并不会渲染，只会让Form突破10个子元素的限制
                    //            Group {
                    //                Text("hello, world")
                    //                      ...
                    //                Text("hello, world")
                    //            }
                    
                    //使用Section，每个Section最多能显示10个子元素
                    //            Section {
                    //                Text("hello, world")
                    //                      ...
                    //                Text("hello, world")
                    //            }
                    
                    Section() {
                        Text("form_userName").bold()
                        TextField("Input your user name here!", text: $userName)
                            .autocapitalization(.none)
                            .disableAutocorrection(false)
                        Text("form_password").bold()
                        SecureField("Input your password here!", text: $password)
                        Toggle("Gender", isOn: $male)
                        Picker("Age", selection: $age) {
                            ForEach(18 ..< 100) {
                                Text("\($0)")
                            }
                        }
                        TextEditor(text: $info)
                            .foregroundColor(.blue)
                            .lineLimit(5)
                            .lineSpacing(5)
                        Button("Login") {
                            print("Log in successfully")
                        }
                        Label("Test", systemImage: "iphone").foregroundColor(.black)
//                        Link("Link", destination: URL(string: "https://www.baidu.com")!)
                        ProgressView(value: progress)
                    }
                    
                    Section {
                        Text("User name is: \(userName)")
                        Text("Password is: \(password)")
                        Menu {
                            Text("A")
                            Text("B")
                            Text("C")
                        } label: {
                            Label("ABC", systemImage: "book")
                        }
                    }
                }
                .navigationTitle("Form")
            }
        }
    }
}

struct FormView_Previews: PreviewProvider {
    static var previews: some View {
        FormView()
            .environment(\.locale, .init(identifier: "en"))
    }
}

//
//  ContentView.swift
//  Calculator
//
//  Created by Yip Ling Shan on 14/10/2023.
//

import SwiftUI

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct ContentView: View {
    
    
    @StateObject private var calculatorVM = CalculatorViewModel()
    @State private var orientation = UIDeviceOrientation.unknown

    

    func buttonWidth(item: CalcuButton) -> CGFloat{
        let width = (UIScreen.main.bounds.width - (5*12))/4
        
        if item == .zero && UIDevice.current.userInterfaceIdiom == .pad{
            return width * 2 * 0.5 + 12
        }else if item == .zero{
            return width * 2 + 12
        }else if UIDevice.current.userInterfaceIdiom == .pad{
            
            return width * 0.5
        }
        return width
    }
    func buttonHeight()-> CGFloat{
        let height = (UIScreen.main.bounds.width - (5*12))/5
        if UIDevice.current.userInterfaceIdiom == .pad{
            return height * 0.5
        }
        return height
    }
    
    var body: some View {
        
        Group {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                VStack
                {
                    HStack
                    {
                        Spacer()
                        Text(calculatorVM.value)
                            .bold()
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                        
                    }
                    if orientation.isPortrait {
                        
                                ForEach (calculatorVM.buttons, id: \.self) { row in
                                    HStack (spacing: 12){
                                        ForEach(row, id: \.self){ item in
                                            Button(action: {
                                                calculatorVM.didTap(button: item)
                                            }, label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width:self.buttonWidth(item: item),height: self.buttonHeight())
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            
                                                   
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom, 3)
                                }
                                //.padding()
                        }else if orientation.isLandscape {
                    
                                ForEach (calculatorVM.buttons2, id: \.self) { row in
                                    HStack (spacing: 12){
                                        ForEach(row, id: \.self){ item in
                                            Button(action: {
                                                calculatorVM.didTap(button: item)
                                            }, label:{
                                                Text(item.rawValue)
                                                    .font(.system(size:32))
                                                    .frame(width:self.buttonWidth(item: item)/2,height: self.buttonHeight()/4)
                                                    .background(item.buttonColor)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(self.buttonHeight()/2)
                                            
                                                   
                                            })
                                            
                                        }
                                    }
                                    .padding(.bottom, 3)
                                }
                                //.padding()
                            }
                        }
                    }
                }
                .onRotate { newOrientation in
                    orientation = newOrientation
                }

        
        
        /*ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack
            {
                HStack
                {
                    Spacer()
                    Text(calculatorVM.value)
                        .bold()
                        .font(.system(size: 100))
                        .foregroundColor(.white)
                    
                }
                ForEach (calculatorVM.buttons, id: \.self) { row in
                    HStack (spacing: 12){
                        ForEach(row, id: \.self){ item in
                            Button(action: {
                                calculatorVM.didTap(button: item)
                            }, label:{
                                Text(item.rawValue)
                                    .font(.system(size:32))
                                    .frame(width:self.buttonWidth(item: item),height: self.buttonHeight())
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonHeight()/2)
                            
                                   
                            })
                            
                        }
                    }
                    .padding(.bottom, 3)
                }
                //.padding()
            }
        }*/
        
    }
}


#Preview {
    ContentView()
}

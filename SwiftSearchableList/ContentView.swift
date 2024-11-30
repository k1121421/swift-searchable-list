//
//  ContentView.swift
//  SwiftSearchableList
//
//  Created by Keita Nakashima on 2024/11/30.
//

import SwiftUI

enum ListType: Int, CaseIterable{
    case normal = 1
    case custom = 2
}

struct ContentView: View {
    
    @State var selectList: ListType = .normal
    @State var presentSheet1 = false
    @State var presentSheet2 = false
    @State var countryCode : String = "-81"
    @State var countryName : String = "Japan"
    @State var countryNameJa : String = "日本"
    @State var countryFlag : String = "🇯🇵"
    @State var countryPattern : String = "### #### ####"
    @State var countryLimit : Int = 17
    @State var mobPhoneNumber = ""
    @State private var searchCountry: String = ""
    
    let countries: [CountryPhoneData] = Bundle.main.decode("CountryNumbers.json")
    
    var body: some View {
        VStack {
            
            Picker("リストタイプを選択", selection: $selectList) {
                Text("Default").tag(ListType.normal)
                Text("Custom").tag(ListType.custom)
            }
            .pickerStyle(.segmented)
            
            Button(action: {
                switch selectList {
                case .normal:
                    self.presentSheet1 = true
                case .custom:
                    self.presentSheet2 = true
                }
            }) {
                HStack(spacing: 0) {
                    Text("\(countryFlag) \(countryCode) \(countryName)")
                        .padding(10)
                        .frame(minWidth: 80, minHeight: 47)
                        .background(Color(.systemGray6), in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .foregroundColor(.black)
                    
                    Image(systemName: "chevron.down")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 10, height: 6)
                        .padding(.leading, 6)
                }
            }
            
            Spacer()
        }
        .sheet(isPresented: $presentSheet1) {
            NavigationView {
                List(filteredCountries) { country in
                    HStack {
                        Text(country.flag)
                        Text(country.name)
                            .font(.headline)
                        Spacer()
                        Text(country.dial_code)
                            .foregroundColor(.secondary)
                    }
                    .onTapGesture {
                        self.countryFlag = country.flag
                        self.countryCode = country.dial_code
                        self.countryName = country.name
                        self.countryNameJa = country.name_ja
                        self.countryPattern = country.pattern
                        self.countryLimit = country.limit
                        presentSheet1 = false
                        searchCountry = ""
                    }
                }
                .listStyle(.plain)
                .searchable(text: $searchCountry, prompt: "国や地域名を入力...")
            }
        }
        .sheet(isPresented: $presentSheet2) {
            NavigationView {
                
                VStack(spacing: 0) {
                    ZStack {
                        Text("国または地域を選択")
                            .font(.system(size: 18))
                            .bold()
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                presentSheet2 = false
                            }) {
                                Text("キャンセル")
                                    .background(Color.clear)
                                    .foregroundColor(Color.blue)
                            }
                        }
                        .padding()
                    }
                    
                    Divider()
                        .padding(0)
                    
                    TextField(
                        "",
                        text: $searchCountry,
                        prompt: Text("国や地域名を入力...")
                            .foregroundColor(.gray.opacity(0.5))
                            .fontWeight(.bold)
                    )
                    .textFieldStyle(.capsule)
                    .font(.system(size: 18))
                    .padding()
                    
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            
                            Spacer().frame(height: 2)
                            
                            if (searchCountry.isEmpty) {
                                HStack {
                                    HStack(spacing: 0) {
                                        
                                        VStack {
                                            HStack {
                                                Text(countryName)
                                                    .fontWeight(.bold)
                                                Text(countryCode)
                                                Spacer()
                                            }
                                            
                                            HStack {
                                                Text(countryNameJa)
                                                    .foregroundColor(.gray)
                                                Spacer()
                                            }
                                        }
                                        
                                        Spacer()
                                        
                                        RadioButton(isSelected: true)
                                    }
                                    .padding(.horizontal, 16)
                                    .frame(maxWidth: .infinity, minHeight: 80)
                                }
                                .background(Color(red: 0.99, green: 0.99, blue: 0.86, opacity: 1.0))
                                .cornerRadius(18)
                                .padding(.horizontal, 16)
                                .onTapGesture {
                                    presentSheet2 = false
                                    searchCountry = ""
                                }
                            } else {
                                Text("検索結果")
                                    .font(.system(size: 18))
                                    .fontWeight(.bold)
                                    .padding(.leading, 16)
                            }
                            
                            Spacer().frame(height: 4)
                            
                            if (groupedItems.isEmpty) {
                                
                                Spacer().frame(height: 4)
                                
                                Text("見つかりませんでした")
                                    .font(.system(size: 18))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.gray)
                                    .fontWeight(.bold)
                                
                                Spacer().frame(height: 1)
                                
                                Text("国または地域名がお間違いないか確認してください")
                                    .font(.system(size: 14))
                                    .frame(maxWidth: .infinity)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                            } else {
                                ForEach(groupedItems.keys.sorted(), id: \.self) { key in
                                    VStack(alignment: .leading, spacing: 4) {
                                        // セクションヘッダー（最初の1回だけ表示）
                                        if (groupedItems[key]?.first) != nil && searchCountry.isEmpty {
                                            Text(key)
                                                .font(.headline)
                                                .padding(.leading, 16)
                                                .padding(.top, 8)
                                        }
                                        
                                        // セクション内の要素
                                        ForEach(groupedItems[key]!) { country in
                                            HStack {
                                                HStack(spacing: 0) {
                                                    VStack {
                                                        HStack {
                                                            Text(country.name)
                                                                .fontWeight(.bold)
                                                            Text(country.dial_code)
                                                            Spacer()
                                                        }
                                                        
                                                        HStack {
                                                            Text(country.name_ja)
                                                                .foregroundColor(.gray)
                                                            Spacer()
                                                        }
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    RadioButton(isSelected: countryCode == country.dial_code)
                                                }
                                                .padding(.horizontal, 16)
                                                .frame(maxWidth: .infinity, minHeight: 80)
                                            }
                                            .background(countryCode == country.dial_code ? Color(red: 0.99, green: 0.99, blue: 0.86, opacity: 1.0) : Color.white)
                                            .cornerRadius(18)
                                            .onTapGesture {
                                                self.countryFlag = country.flag
                                                self.countryCode = country.dial_code
                                                self.countryName = country.name
                                                self.countryNameJa = country.name_ja
                                                self.countryPattern = country.pattern
                                                self.countryLimit = country.limit
                                                presentSheet2 = false
                                                searchCountry = ""
                                            }
                                        }
                                        .padding(.vertical, 6)
                                        .padding(.horizontal, 12)
                                    }
                                }
                            }
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemGray6))
                }
                .padding(0)
            }
            .presentationDetents([.large, .large])
        }
        .presentationDetents([.large, .large])

    }
    
    var groupedItems: [String: [CountryPhoneData]] {
       Dictionary(grouping: filteredCountries.sorted(by: { $0.name < $1.name }), by: { String($0.name.prefix(1)) })
    }

    var filteredCountries: [CountryPhoneData] {
       if searchCountry.isEmpty {
           return countries
       } else {
           return countries.filter { $0.name.starts(with: searchCountry) }
       }
    }
}

struct RadioButton: View {
    var isSelected: Bool

    var body: some View {
        ZStack {
            if isSelected {
                Circle()
                    .strokeBorder(Color.indigo, lineWidth: 2)
                    .frame(width: 20, height: 20)
                
                Circle()
                    .fill(Color.indigo)
                    .frame(width: 12, height: 12)
            } else {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: 2)
                    .frame(width: 20, height: 20)
            }
        }
    }
}

struct CapsuleTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(.thickMaterial)
            .foregroundColor(.black)
            .cornerRadius(30)
            .font(.headline)
    }
}


extension TextFieldStyle where Self == CapsuleTextFieldStyle {
    static var capsule: CapsuleTextFieldStyle {
        .init()
    }
}
               
extension Bundle {
   
   func decode<T: Decodable>(_ file: String) -> T {
       guard let url = self.url(forResource: file, withExtension: nil) else {
           fatalError("Failed to locate \(file) in bundle.")
       }

       guard let data = try? Data(contentsOf: url) else {
           fatalError("Failed to load \(file) from bundle.")
       }

       let decoder = JSONDecoder()

       guard let loaded = try? decoder.decode(T.self, from: data) else {
           fatalError("Failed to decode \(file) from bundle.")
       }

       return loaded
   }
   
}


#Preview {
    ContentView()
}

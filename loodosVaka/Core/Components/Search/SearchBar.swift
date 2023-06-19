

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    var onCommit: () -> Void
    
    var body: some View {
        HStack {
            TextField("Search Movies...", text: $text, onCommit: {
                onCommit()
            })
            .padding(15)
            .padding(.horizontal, 10)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .frame(width: 270)
            
            Button(action: onCommit) {
                Image(systemName: "magnifyingglass")
                    .padding()
            }
            .background(Color(.systemGray6))
            .foregroundColor(Color.gray)
            .clipShape(Circle())
        }
    }
}


struct SearchBar_Previews: PreviewProvider {
    @State static var previewText: String = ""

       static var previews: some View {
           SearchBar(text: $previewText, onCommit: {
               print("Preview search for \(previewText)")
           })
    }
}

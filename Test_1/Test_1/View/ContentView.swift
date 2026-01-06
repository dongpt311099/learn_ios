import SwiftUI

struct ContentView: View {
    @State private var counter = 0

       var body: some View {
           VStack {
               Text("Counter: \(counter)")
                   .font(.largeTitle)
                   .padding()

               Button(action: {
                   counter += 1
               }) {
                   Text("Increment")
                       .padding()
                       .background(Color.blue)
                       .foregroundColor(.white)
                       .cornerRadius(8)
               }
               
               Text("Increment")
                   .padding()
                   .background(Color.blue)
                   .foregroundColor(.white)
                   .cornerRadius(8)
           }
       }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

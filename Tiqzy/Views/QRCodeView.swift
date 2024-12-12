import SwiftUI

struct QRCodeView: View {
    let qrCodeImage: UIImage

    var body: some View {
        VStack {
            Text("Scan to Learn More")
                .font(.custom("Poppins-Medium", size: 20))
                .padding()

            Image(uiImage: qrCodeImage)
                .resizable()
                .interpolation(.none)
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()

            Spacer()
        }
        .padding()
    }
}

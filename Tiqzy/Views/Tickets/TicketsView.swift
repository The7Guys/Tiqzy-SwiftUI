import SwiftUI

struct TicketsView: View {
    let tickets: [TicketGroup] = [
        TicketGroup(date: "Mon 25/11/2024", tickets: [
            Ticket(title: "Canal Cruise", seat: nil, date: "25/11/24", time: nil, name: nil, imageName: "cruise", qrCode: "qrCode"),
            Ticket(title: "Canal Cruise", seat: "4C", date: "25/11/24", time: "10-10:30 AM", name: "Maria Davis", imageName: "cruise", qrCode: "qrCode")
        ]),
        TicketGroup(date: "Wed 27/11/2024", tickets: [
            Ticket(title: "Heineken Experience", seat: nil, date: "27/11/24", time: "12 - 14:00 AM", name: "Liam Davis", imageName: "heineken", qrCode: "qrCode")
        ])
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Your tickets")
                    .font(.custom("Poppins-SemiBold", size: 24))
                    .padding(.horizontal)
                    .padding(.top)
                
                ForEach(tickets, id: \.date) { group in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(group.date)
                            .font(.custom("Poppins-Regular", size: 18))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                        
                        ForEach(group.tickets) { ticket in
                            TicketCard(ticket: ticket)
                        }
                    }
                }
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
}

struct TicketCard: View {
    let ticket: Ticket
    
    var body: some View {
        HStack(spacing: 0) {
            // QR Code Section
            VStack {
                Image(ticket.qrCode)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
            }
            .frame(width: 100)
            .background(Color.white)
            .clipShape(CustomTicketShape())
            
            // Ticket Info Section
            VStack(alignment: .leading, spacing: 4) {
                Text(ticket.title)
                    .font(.custom("Poppins-SemiBold", size: 18))
                    .foregroundColor(.black)
                
                if let seat = ticket.seat {
                    Text("Seat: \(seat)")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.black.opacity(0.8))
                }
                
                Text("Date: \(ticket.date)")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundColor(.black.opacity(0.8))
                
                if let time = ticket.time {
                    Text("Time: \(time)")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.black.opacity(0.8))
                }
                
                if let name = ticket.name {
                    Text("Name: \(name)")
                        .font(.custom("Poppins-Regular", size: 14))
                        .foregroundColor(.black.opacity(0.8))
                }
            }
            .padding()
            
            Spacer()
            
            // Ticket Image Section
            Image(ticket.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 100, height: 80)
                .cornerRadius(8)
            
            Image(systemName: "location.fill")
                .foregroundColor(.blue)
                .padding(.trailing, 16)
        }
        .background(LinearGradient(gradient: Gradient(colors: [Color.purple.opacity(0.2), Color.blue.opacity(0.2)]), startPoint: .leading, endPoint: .trailing))
        .cornerRadius(12)
        .overlay(
            CustomTicketShape()
                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

// MARK: - Ticket Model
struct Ticket: Identifiable {
    let id = UUID()
    let title: String
    let seat: String?
    let date: String
    let time: String?
    let name: String?
    let imageName: String
    let qrCode: String
}

struct TicketGroup {
    let date: String
    let tickets: [Ticket]
}

// MARK: - Custom Shape for Ticket
struct CustomTicketShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let curveSize: CGFloat = 15

        // Top Edge
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))

        // Right Edge
        path.addLine(to: CGPoint(x: rect.width, y: rect.height / 2 - curveSize))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height / 2 + curveSize),
            control: CGPoint(x: rect.width + curveSize, y: rect.height / 2)
        )
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))

        // Bottom Edge
        path.addLine(to: CGPoint(x: 0, y: rect.height))

        // Left Edge
        path.addLine(to: CGPoint(x: 0, y: rect.height / 2 + curveSize))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height / 2 - curveSize),
            control: CGPoint(x: -curveSize, y: rect.height / 2)
        )
        path.addLine(to: CGPoint(x: 0, y: 0))

        return path
    }
}

// MARK: - Preview
#Preview {
    TicketsView()
}

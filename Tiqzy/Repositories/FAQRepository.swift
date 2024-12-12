import Foundation

protocol FAQRepositoryProtocol {
    func fetchFAQs() -> [FAQItemModel]
}

class FAQRepository: FAQRepositoryProtocol {
    func fetchFAQs() -> [FAQItemModel] {
        return [
            FAQItemModel(question: "How can I book an event?", answer: "You can browse events in the app and click on 'Book Now' to complete your booking.", isExpanded: false),
            FAQItemModel(question: "What payment methods are accepted?", answer: "We accept credit cards, debit cards, and PayPal.", isExpanded: false),
            FAQItemModel(question: "Can I cancel my booking?", answer: "Yes, you can cancel your booking within 24 hours of purchase for a full refund.", isExpanded: false),
            FAQItemModel(question: "Is customer support available 24/7?", answer: "Yes, our customer support is available around the clock.", isExpanded: false),
            FAQItemModel(question: "How do I change my booking?", answer: "You can change your booking by going to the 'My Bookings' section in the app.", isExpanded: false),
            FAQItemModel(question: "What if the event is cancelled?", answer: "You will be notified and fully refunded in case of an event cancellation.", isExpanded: false),
            FAQItemModel(question: "Can I transfer my ticket?", answer: "Ticket transfers depend on the event organizer's policy.", isExpanded: false),
            FAQItemModel(question: "How do I get my tickets?", answer: "Your tickets will be emailed to you and can also be accessed in the app.", isExpanded: false),
            FAQItemModel(question: "Do I need to print my ticket?", answer: "No, you can show the digital ticket on your phone.", isExpanded: false),
            FAQItemModel(question: "How do I contact support?", answer: "You can reach us at support@tiqzy.com or +1 (800) 123-4567.", isExpanded: false)
        ]
    }
}

import Foundation
import Combine

protocol OrderRepositoryProtocol {
    func fetchOrders() -> AnyPublisher<[Order], Error>
    func createOrder(order: Order) -> AnyPublisher<Order, Error>
}

class MockOrderRepository: OrderRepositoryProtocol {
    private var mockOrders: [Order] = [
        Order(
            emailAddress: "testuser@example.com",
            userName: "test_user",
            userId: "12345",
            orderItems: [
                Order.OrderItem(itemId: "item1", quantity: 2, timeslot: "10:00 AM", price: 25.0),
                Order.OrderItem(itemId: "item2", quantity: 1, timeslot: "2:00 PM", price: 15.0)
            ]
        ),
        Order(
            emailAddress: "anotheruser@example.com",
            userName: "another_user",
            userId: "67890",
            orderItems: [
                Order.OrderItem(itemId: "item3", quantity: 3, timeslot: "1:00 PM", price: 30.0)
            ]
        )
    ]

    // Simulate fetching all orders
    func fetchOrders() -> AnyPublisher<[Order], Error> {
        Just(mockOrders)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    // Simulate creating a new order
    func createOrder(order: Order) -> AnyPublisher<Order, Error> {
        mockOrders.append(order)
        return Just(order)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

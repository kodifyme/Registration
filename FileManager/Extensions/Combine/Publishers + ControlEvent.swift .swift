//
//  Publishers + ControlEvent.swift
//  FileManager
//
//  Created by KOДИ on 04.12.2024.
//

import UIKit
import Combine

extension Publishers {
    struct ControlEvent<Control: UIControl>: Publisher {
        typealias Output = Void
        typealias Failure = Never

        let control: Control
        let controlEvents: UIControl.Event

        init(control: Control, events: UIControl.Event) {
            self.control = control
            self.controlEvents = events
        }

        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = Subscription(subscriber: subscriber, control: control, event: controlEvents)
            subscriber.receive(subscription: subscription)
        }
    }

    struct ControlProperty<Control: UIControl, Output>: Publisher {
        typealias Failure = Never

        let control: Control
        let controlEvents: UIControl.Event
        let keyPath: KeyPath<Control, Output>

        init(control: Control, events: UIControl.Event, keyPath: KeyPath<Control, Output>) {
            self.control = control
            self.controlEvents = events
            self.keyPath = keyPath
        }

        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Output == S.Input {
            let subscription = Subscription(subscriber: subscriber, control: control, event: controlEvents, keyPath: keyPath)
            subscriber.receive(subscription: subscription)
        }
    }
}

extension Publishers.ControlEvent {
    final class Subscription<S: Subscriber, Control: UIControl>: Combine.Subscription where S.Input == Void {
        private var subscriber: S?
        weak private var control: Control?

        init(subscriber: S, control: Control, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }

        func request(_ demand: Subscribers.Demand) {
            // Нет необходимости в управлении спросом
        }

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            _ = subscriber?.receive(())
        }
    }
}

extension Publishers.ControlProperty {
    final class Subscription<S: Subscriber, Control: UIControl, Output>: Combine.Subscription where S.Input == Output {
        private var subscriber: S?
        weak private var control: Control?
        let keyPath: KeyPath<Control, Output>

        init(subscriber: S, control: Control, event: UIControl.Event, keyPath: KeyPath<Control, Output>) {
            self.subscriber = subscriber
            self.control = control
            self.keyPath = keyPath
            control.addTarget(self, action: #selector(eventHandler), for: event)
            // Отправляем начальное значение
            _ = subscriber.receive(control[keyPath: keyPath])
        }

        func request(_ demand: Subscribers.Demand) {
            // Нет необходимости в управлении спросом
        }

        func cancel() {
            subscriber = nil
        }

        @objc private func eventHandler() {
            guard let control = control else { return }
            _ = subscriber?.receive(control[keyPath: keyPath])
        }
    }
}

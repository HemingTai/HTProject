//
//  Async+Extension.swift
//  HTProject
//
//  Created by Hem1ngT4i on 2025/3/18.
//  Copyright © 2025 Hem1ngT4i. All rights reserved.
//

import Foundation
import _Concurrency

typealias Job = Task<Void, Error>
typealias Deferred<T> = Task<T, Error>
typealias AsyncClosureWithThrows<T> = () async throws -> T

func launch(@_implicitSelfCapture _ asyncBlock: @escaping AsyncClosureWithThrows<Void>) -> Job {
    createTask { try await asyncBlock() }
}

private func createTask<T>(detached: Bool = false, _ asyncBlock: @escaping AsyncClosureWithThrows<T>) -> Deferred<T> {
    let block = { try await asyncBlock() }
    return detached ? Task.detached(operation: block) : Task(operation: block)
}

class Jobs {
    private var list = [Job]()
    
    var runningJobs: [Job] {
        list
    }
    
    func add(_ job: Job) {
        list += job
    }
    
    func remove(_ job: Job) {
        list -= job
    }
    
    func cancelAll() {
        list.forEach { $0.cancel() }
    }
}

protocol TaskScope {
    var jobs: Jobs { get}
}

extension TaskScope {
    func runTask(_ closure: @escaping AsyncClosureWithThrows<()>) -> Job {
        let job = launch {
            do {
                try await closure()
            } catch {
                if !(error is CancellationError) {
                    
                }
            }
        }
        jobs.add(job)
        job.invokeOnCompletion(onCancelling: true) {
            jobs.remove(job)
        }
        return job
    }
}

extension Task {
    
    @discardableResult
    func invokeOnSuccess(handler: @escaping (Success) -> Void) -> Task {
        runTaskWithCallback(task: self, onSuccess: handler)
        return self
    }
    
    @discardableResult
    func invokeOnFailure(handler: @escaping (Failure) -> Void) -> Task {
        runTaskWithCallback(task: self, onFailure: handler)
        return self
    }
    
    @discardableResult
    func invokeOnCompletion(onCancelling: Bool = false, handler: @escaping () -> Void) -> Task {
        let successHandler: (Success) -> Void = { _ in }
        let failureHandler: (Failure) -> Void = { _ in }
        onCancelling ? runTaskWithCallback(task: self, onSuccess: successHandler, onFailure: failureHandler, onCancelling: handler) : runTaskWithCallback(task: self, onSuccess: successHandler, onFailure: failureHandler)
        return self
    }
}

private func runTaskWithCallback<T, E>(
    task: Task<T, E>,
    onSuccess: @escaping (T) -> Void = { _ in },
    onFailure: @escaping (E) -> Void = { _ in },
    onCancelling: @escaping () -> Void = { }
) {
    Task.detached(priority: .high) {
        do {
            let result = try await task.value
            if !task.isCancelled {
                onSuccess(result)
            } else {
                onCancelling()
            }
        } catch {
            if let e = error as? E {
                onFailure(e)
            }
        }
    }
}


/*
 * Copyright © 2017 Naeem G Shaikh. All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import RealmSwift

enum UIState {
  case loading
  case success([Post])
  case failure(MyError)
}

protocol PostDelegate: class {
  var state: UIState { get set }
}

protocol PostHandler: class {
  var delegate: PostDelegate? { get set }
  func fetchPosts()
}

final class PostController: PostHandler {

  fileprivate let connectable: Connectable
  var delegate: PostDelegate?
  
  init(connectable: Connectable) {
    self.connectable = connectable
  }
  
  func fetchSavedPosts() -> [Post] {
    var posts: [Post] = []
    do {
      let container = try Container()
      let savedPosts = container.values(Post.self)
      for savedPost in savedPosts {
        posts.append(savedPost)
      }
    }
    catch let error as NSError {
      print(error.localizedDescription)
    }
    return posts
  }
  
  func fetchPosts() {
    
    guard let delegate = self.delegate else { fatalError("did you forgot to set the delegate?") }
    
    delegate.state = .loading
    
    let posts = fetchSavedPosts()
    
    if posts.isEmpty {
      let resource = Resource(path: "/posts", method: .GET)
      
      let parsingCompletion = createParsingCompletion(delegate)
      let networkCompletion = createNetworkCompletion(delegate, parseCompletion: parsingCompletion)
      
      connectable.makeConnection(resource, completion: networkCompletion)
    }
    else {
      delegate.state = .success(posts)
    }
  }
}

private typealias ParseCompletion = (Result<[Post], MyError>) -> Void
private typealias NetworkCompletion = (Result<Data, MyError>) -> Void

private func createParsingCompletion(_ delegate: PostDelegate) -> ParseCompletion {
  
  return { postResult in
    DispatchQueue.main.async {
      switch postResult {
      case .success(let posts): delegate.state = .success(posts)
      case .failure(let error): delegate.state = .failure(error)
      }
    }
  }
}

private func createNetworkCompletion(_ delegate: PostDelegate, parseCompletion: @escaping ParseCompletion) -> NetworkCompletion {
  
  return { dataResult in
    DispatchQueue.global(qos: DispatchQoS.QoSClass.background).async {
      switch dataResult {
      case .success(let data): parse(data, completion: parseCompletion)
      case .failure(let error): delegate.state = .failure(error)
      }
    }
  }
}

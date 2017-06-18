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

extension Post: Persistable {
  
  public init(managedObject: PostObject) {
    id = managedObject.id
    userId = managedObject.userId
    title = managedObject.title
    body = managedObject.body
  }
  
  public func managedObject() -> PostObject {
    let post = PostObject()
    post.id = id
    post.userId = userId
    post.title = title
    post.body = body
    return post
  }
}

extension Post {
  
  public enum PropertyValue: PropertyValueType {
    case id(Int)
    case userId(Int)
    case title(String)
    case body(String)
    
    public var propertyValuePair: PropertyValuePair {
      switch self {
      case .id(let id):
        return ("id", id)
      case .userId(let userId):
        return ("userId", userId)
      case .title(let title):
        return ("title", title)
      case .body(let body):
        return ("bosy", body)
      }
    }
  }
}

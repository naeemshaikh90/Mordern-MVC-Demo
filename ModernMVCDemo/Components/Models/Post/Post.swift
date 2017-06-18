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

public struct Post {
  let id: Int
  let userId: Int
  let title: String
  let body: String
}

extension Post: Mappables {
  
  static func mapToModel(_ o: AnyObject) -> Result<Post, MyError> {
    
    guard
      let dic = o as? [String: AnyObject],
      let userId = dic["userId"] as? Int,
      let id = dic["id"] as? Int,
      let title = dic["title"] as? String,
      let body = dic["body"] as? String
      else { return .failure(.parser) }
    
    let post = Post(
      id: id,
      userId: userId,
      title: title,
      body: body
    )
    
    saveOfflineData(post)
    return .success(post)
  }
}

fileprivate func saveOfflineData(_ element: Post) {
  do {
    let container = try Container()
    try! container.write { transaction in
      transaction.add(element, update: true)
    }
  }
  catch let error as NSError {
    print(error.localizedDescription)
  }
}


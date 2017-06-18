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

import UIKit

final class PostUIController {
  
  fileprivate var view: UIView
  fileprivate let loadingView: LoadingView
  fileprivate let tableViewDataSource: TableViewDataSource<PostCellController, PostCell>
  fileprivate let tableViewDelegate: TableViewDelegate<PostCellController, PostCell>
  
  var state: UIState = .loading {
    willSet(newState) {
      update(newState)
    }
  }
  
  init(view: UIView, tableView: UITableView) {
    
    self.view = view
    self.loadingView = LoadingView(frame: CGRect(origin: .zero, size: tableView.frame.size))
    self.tableViewDataSource = TableViewDataSource<PostCellController, PostCell>(tableView: tableView)
    self.tableViewDelegate = TableViewDelegate<PostCellController, PostCell>(tableView: tableView)
    
    tableView.dataSource = tableViewDataSource
    tableView.delegate = tableViewDelegate
    update(state)
  }
}

extension PostUIController: PostDelegate {
  
  func update(_ newState: UIState) {
    
    switch(state, newState) {
      
    case (.loading, .loading): loadingToLoading()
    case (.loading, .success(let post)): loadingToSuccess(post)
    case (.loading, .failure(let error)): loadingToFailure(error)
      
    default: fatalError("Not yet implemented \(state) to \(newState)")
    }
  }
  
  func loadingToLoading() {
    view.addSubview(loadingView)
    loadingView.frame = CGRect(origin: .zero, size: view.frame.size)
  }
  
  func loadingToSuccess(_ post: [Post]) {
    loadingView.removeFromSuperview()
    tableViewDataSource.dataSource = post.map(PostCellController.init)
    tableViewDelegate.dataSource = post.map(PostCellController.init)
  }
  
  func loadingToFailure(_ error: MyError) {
    loadingView.removeFromSuperview()
    print(error.localizedDescription)
  }
}

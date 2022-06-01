//
//  ViewController.swift
//  observer-pattern
//
//  Created by Victor Roldan on 30/05/22.
//

import UIKit
import Combine

class ViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    
    var viewModel = ViewModel()
    var anyCancellable : [AnyCancellable] = []
    var timer = Timer()
    var count : Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscriptions()
        
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTitle), userInfo: nil, repeats: true)
        
    }
    
    @objc func updateTitle(){
        
        count += 1
        print("count: ", count)
        if count > 5{
            anyCancellable.removeAll()
        }
        viewModel.updateTitle(title: "Nuevo Título \(count)")
    }
    
    func subscriptions(){
        viewModel.title.sink { _ in } receiveValue: {[weak self] title in
            //reaccionar a los cambios
            self?.titleLabel.text = title
        }.store(in: &anyCancellable)
        
        viewModel.$color.sink {[weak self] color in
            self?.view.backgroundColor = color
        }.store(in: &anyCancellable)
    }


}

class ViewModel {
    //Subject/Observable
    var title = PassthroughSubject<String, Error>()
    @Published var color : UIColor = .black
    var title2 = ""
    
    func updateTitle(title : String){
        self.title.send(title)
        
        let colors : [UIColor] = [.black, .white, .blue, .systemPink, .red, .cyan]
        let aa = colors.randomElement()
        color = colors[Int.random(in: 0..<colors.count)]
        
    }
    
}

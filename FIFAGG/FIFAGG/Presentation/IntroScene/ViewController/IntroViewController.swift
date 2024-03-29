//
//  IntroViewController.swift
//  FIFAGG
//
//  Created by Joseph Cha on 2022/06/27.
//

import SnapKit
import RxSwift
import UIKit

class IntroViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: IntroViewModel?
    
    private lazy var introImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "gamecontroller")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        setUpLayout()
    }
}

// MARK: Private
private extension IntroViewController {
    func bind() {
        let input = IntroViewModel.Input()
        
        let output = viewModel?.convert(from: input, disposedBag: disposeBag)
    }
    
    func setUpLayout() {
        view.addSubview(introImageView)
        
        introImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(300.0)
            $0.height.equalTo(300.0)
        }
    }
}

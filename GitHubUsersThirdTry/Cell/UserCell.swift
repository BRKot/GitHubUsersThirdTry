import UIKit
import SnapKit

class UserCell: UICollectionViewCell{
    
    var imageView: UIImageView!
    var loginLabel: UILabel!
    var countSubscribersLabel: UILabel!
    var countRepositoriesLabel: UILabel!
    
    static let identifier = "CustomCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAvatar()
        configureLoginLabel()
        configureCountSubscribersLabel()
        configureCountRepositoriesLabel()
        self.layer.cornerRadius = 24
        self.backgroundColor = UIColor(named: "CardColor")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAvatar(){
        imageView = UIImageView()
        contentView.addSubview(imageView)
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(imageView.snp.width).multipliedBy(1)
        }
    }
    
    func configureLoginLabel(){
        loginLabel = UILabel()
        loginLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loginLabel.textColor = UIColor.black
        contentView.addSubview(loginLabel)
        
        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func configureCountSubscribersLabel(){
        countSubscribersLabel = UILabel()
        countSubscribersLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        countSubscribersLabel.textColor = UIColor(named: "AddLabelColor")
        contentView.addSubview(countSubscribersLabel)
        
        countSubscribersLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }
        
    }
    
    func configureCountRepositoriesLabel(){
        countRepositoriesLabel = UILabel()
        countRepositoriesLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        countRepositoriesLabel.textColor = UIColor(named: "AddLabelColor")
        countRepositoriesLabel.numberOfLines = 0
        contentView.addSubview(countRepositoriesLabel)
        
        countRepositoriesLabel.snp.makeConstraints { make in
            make.top.equalTo(countSubscribersLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
    }
    
}

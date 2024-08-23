import UIKit
import SnapKit

class DeatailUserCell: UICollectionViewCell{
    
    var imageView: UIImageView!
    var userName: UILabel!
    var company: UILabel!
    var email: UILabel!
    var blog: UILabel!
    var location: UILabel!
    var additionalInformationStackView: UIStackView!
    var bio: UILabel!
    
    static let identifier = "DetailUserCard"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 24
        configureAvatar()
        self.backgroundColor = UIColor(named: "CardColor")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureAdditionalInformation(user: User){
        additionalInformationStackView = UIStackView()
        additionalInformationStackView.axis = .vertical
        additionalInformationStackView.alignment = .top
        additionalInformationStackView.distribution = .fill
        additionalInformationStackView.spacing = 5
        self.addSubview(additionalInformationStackView)
        additionalInformationStackView.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.equalTo(imageView.snp.top).offset(0)
        }
        if let name = user.name{
            additionalInformationStackView.addArrangedSubview(configureUserName(name: name))
        }
        if let companyName = user.company{
            additionalInformationStackView.addArrangedSubview(configureCompany(companyName: companyName))
        }
        if let email = user.email{
            additionalInformationStackView.addArrangedSubview(configureEmail(usersEmail: email))
        }
        if let blog = user.blog{
            additionalInformationStackView.addArrangedSubview(configureBlog(blogName: blog))
        }
        if let location = user.location{
            additionalInformationStackView.addArrangedSubview(configureLocation(locationName: location))
        }
        configureBIO(bioText: user.bio)
        
        
    }
    
    func configureBIO(bioText: String?){
        var title = UILabel()
        title.text = "Информация"
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        bio = UILabel()
        bio.text = bioText ?? "Отсутствует"
        bio.textColor = UIColor(named: "AddLabelColor")
        bio.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        self.addSubview(bio)
        bio.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    func configureAvatar(){
        imageView = UIImageView()
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
            make.bottom.equalToSuperview().inset(16).priority(.high)
            make.height.equalTo(imageView.snp.width).multipliedBy(1)
        }
    }
    
    func configureUserName(name: String) -> UILabel{
        userName = UILabel()
        userName.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        userName.text = name
        userName.textColor = UIColor.black
        
        return userName
    }
    
    func configureCompany(companyName: String) -> UILabel{
        company = UILabel()
        company.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        company.textColor = UIColor(named: "AddLabelColor")
        company.text = companyName

        return company
    }
    
    func configureEmail(usersEmail: String) -> UILabel{
        email = UILabel()
        email.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        email.textColor = UIColor(named: "AddLabelColor")
        email.text = usersEmail
        
        return email
    }
    
    func configureBlog(blogName: String) -> UILabel{
        blog = UILabel()
        blog.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        blog.textColor = UIColor.link
        blog.text = blogName
        blog.isUserInteractionEnabled = true
        blog.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelTapped)))
        
       return blog
    }
    
    func configureLocation(locationName: String) -> UILabel{
        location = UILabel()
        location.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        location.textColor = UIColor(named: "AddLabelColor")
        location.text = locationName
        
        return location
    }
    
    @objc func labelTapped() {
        if let url = URL(string: blog.text ?? "") {
               // Проверяем, что URL корректен и открываем его
               if UIApplication.shared.canOpenURL(url) {
                   UIApplication.shared.open(url, options: [:], completionHandler: nil)
               }
           }
       }
}

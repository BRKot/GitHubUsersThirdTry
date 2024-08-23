import SnapKit
import UIKit


protocol UserInformationCardView{
    func configureUserCard(userInfo: User)->Void
    func refreshCollectionView()->Void
    func configureCell(indexCell: Int, userInformation: User)->Void
    func configureAvatars(indexCell: Int, userInformation: User)->Void
    func configureUserAvatar(userAvatar: Data)
    func setupCollectionView()
    func configureTitle(title: String)->Void
}

class UserInformationCardViewController: UIViewController {
        
    var collectionView: UICollectionView!
    var presenter: UserInformationCardPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        presenter?.setupUI()
    }
}

extension UserInformationCardViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            return presenter?.numberCell ?? 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeatailUserCell.identifier, for: indexPath) as? DeatailUserCell else {
                return UICollectionViewCell()
            }
            return cell
        }else{
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
                return UICollectionViewCell()
            }
            presenter?.configure(cell: cell, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader && indexPath.section == 1 {  // Только для второй секции
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath)
            header.backgroundColor = .white
            
            let label = UILabel(frame: header.bounds)
            label.text = "Подписчики"
            label.textColor = .black
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            header.addSubview(label)
            
            
            return header
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1{
            presenter?.selectedCell(index: indexPath.row)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
           if section == 1 {
               return CGSize(width: collectionView.frame.size.width, height: 50)
           }
           return CGSize.zero
       }
}

extension UserInformationCardViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            let width = collectionView.bounds.width
            let height = width * (95 / 163)
            
            return CGSize(width: width, height: height)
        }else{
            let totalSpacing: CGFloat = 10
            let numberOfItemsPerRow: CGFloat = 2
            let width = (collectionView.bounds.width - (numberOfItemsPerRow - 1) * totalSpacing - collectionView.contentInset.left - collectionView.contentInset.right) / numberOfItemsPerRow
            let height = width * (117 / 79)
            
            return CGSize(width: width, height: height)
        }
        
    }
}

extension UserInformationCardViewController: UserInformationCardView{
    func configureTitle(title: String) {
        self.title = title
    }
    
    func setupCollectionView() {
        // Создаем layout
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        // Объявляем коллекцию
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Регистрируем кастомную ячейку и header
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.identifier)
        collectionView.register(DeatailUserCell.self, forCellWithReuseIdentifier: DeatailUserCell.identifier)
        collectionView.register(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0)
            maker.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            maker.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            maker.bottom.equalToSuperview().inset(0)
        }
        
    }
    
    func configureUserCard(userInfo: User) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DeatailUserCell else { return }
        (cell as DeatailUserCell).configureAdditionalInformation(user: userInfo)
    }
    
    func configureUserAvatar(userAvatar: Data) {
        guard let cell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? DeatailUserCell else { return }
        cell.imageView.image = UIImage(data: userAvatar)
    }
    
    func configureCell(indexCell: Int, userInformation: User) {
        guard let cell = collectionView.cellForItem(at: IndexPath(row: indexCell, section: 1)) as? UserCell else {return}
        if let countFolowers = userInformation.folowers, let countRepos = userInformation.public_repos {
            cell.countSubscribersLabel.text = "\(countFolowers) подписчиков"
            cell.countRepositoriesLabel.text = "\(countRepos) репозиториев"
        }
    }
    
    func configureAvatars(indexCell: Int, userInformation: User) {
        guard let cell = collectionView.cellForItem(at: IndexPath(row: indexCell, section: 1)) as? UserCell else { return }
        if let imageData = userInformation.imageData {
            cell.imageView.image = UIImage(data: imageData)
        }
    }
    
    func refreshCollectionView() {
        self.collectionView.reloadData()
    }
}

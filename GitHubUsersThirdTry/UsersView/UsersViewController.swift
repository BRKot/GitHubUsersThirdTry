import SnapKit
import UIKit

protocol UsersView{
    func refreshCollectionView()->Void
    func configureCell(indexCell: Int, userInformation: User)->Void
    func configureAvatars(indexCell: Int, userInformation: User)->Void
}

class UsersViewController: UIViewController {

    var presenter: UsersPresenter?
    
    private var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
      //  presenter = UsersPresenter(view: self)
        presenter?.setupUI()
        self.title = "Пользователи"
        view.backgroundColor = UIColor.white
        setupCollectionView()
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: UserCell.identifier)
        
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(16)
            maker.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(16)
            maker.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-16)
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
}

extension UsersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.numberCell ?? 0 // Количество ячеек
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
            return UICollectionViewCell()
        }
        guard let user = presenter?.getUserData(row: indexPath.row) else { return cell}
        
        cell.loginLabel.text = user.login
        if let countFolowers = user.folowers, let countRepos = user.public_repos {
            cell.countSubscribersLabel.text = "\(countFolowers) подписчиков"
            cell.countRepositoriesLabel.text = "\(countRepos) репозиториев"
        }
        if let imageData = user.imageData{
            cell.imageView.image = UIImage(data: imageData)
        }
        
        cell.tag = user.id
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.selectedCell(index: indexPath.row)
    }
}

extension UsersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalSpacing: CGFloat = 10
        let numberOfItemsPerRow: CGFloat = 2
        
        let width = (collectionView.bounds.width - (numberOfItemsPerRow - 1) * totalSpacing - collectionView.contentInset.left - collectionView.contentInset.right) / numberOfItemsPerRow
        let height = width * (117 / 79)
        return CGSize(width: width, height: height)
    }
}

extension UsersViewController: UsersView{
    func configureCell(indexCell: Int, userInformation: User) {
        guard let cell = collectionView.visibleCells.first(where: {$0.tag == userInformation.id}) as? UserCell else { return }
        if let countFolowers = userInformation.folowers, let countRepos = userInformation.public_repos {
            cell.countSubscribersLabel.text = "\(countFolowers) подписчиков"
            cell.countRepositoriesLabel.text = "\(countRepos) репозиториев"
        }
    }
    
    func configureAvatars(indexCell: Int, userInformation: User) {
        guard let cell = collectionView.visibleCells.first(where: {$0.tag == userInformation.id}) as? UserCell else { return }
        if let imageData = userInformation.imageData {
            cell.imageView.image = UIImage(data: imageData)
            cell.imageView.layer.cornerRadius = 12
        }
    }
    
    func refreshCollectionView() {
        self.collectionView.reloadData()
    }
    
}

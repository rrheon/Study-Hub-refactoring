import UIKit

class NicknameViewController: UIViewController {
    
    var email: String?
    var password: String?
    var gender: String?
    var nickname: String?
    
    private let femaleButton = UIButton(type: .system)
    private let maleButton = UIButton(type: .system)
    private let nicknameTextField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        
        // '회원가입' 텍스트
        let titleLabel = UILabel()
        titleLabel.text = "회원가입"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.boldSystemFont(ofSize: 22) // Set the font size and boldness here
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        // '3/4' 텍스트
        let progressLabel = UILabel()
        progressLabel.text = "3/4"
        progressLabel.textColor = .gray
        progressLabel.font = UIFont.boldSystemFont(ofSize: 20)
        progressLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(progressLabel)
        
        // '닉네임을 설정해주세요' 텍스트
        let nicknamePromptLabel = UILabel()
        nicknamePromptLabel.text = "스터디 참여에 필요한 정보를 알려주세요"
        nicknamePromptLabel.textColor = .white
        nicknamePromptLabel.font = UIFont.boldSystemFont(ofSize: 22)
        nicknamePromptLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknamePromptLabel)
        
        // '성별은 추후에 수정이 불가해요' 텍스트
        let genderfixLabel = UILabel()
        genderfixLabel.text = "성별은 추후에 수정이 불가해요"
        genderfixLabel.textColor = .gray
        genderfixLabel.font = UIFont.systemFont(ofSize: 13)
        genderfixLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genderfixLabel)
        
        // '닉네임' 텍스트
        let nicknameLabel = UILabel()
        nicknameLabel.text = "닉네임"
        nicknameLabel.textColor = .white
        nicknameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameLabel)
        
        //graydivide
        let nicknameTextFielddividerLine = UIView()
        nicknameTextFielddividerLine.backgroundColor = .gray
        nicknameTextFielddividerLine.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameTextFielddividerLine)
        
        // 닉네임 입력창
        nicknameTextField.placeholder = "닉네임을 입력하세요"
        nicknameTextField.attributedPlaceholder = NSAttributedString(string: "닉네임을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        nicknameTextField.textColor = .white
        nicknameTextField.backgroundColor = .black
        nicknameTextField.borderStyle = .roundedRect
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nicknameTextField)
        // 키보드 생성
        nicknameTextField.becomeFirstResponder()
        
        // 키보드 내리기를 위한 탭 제스처 추가
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        
        let genderLabel = UILabel()
        genderLabel.text = "성별"
        genderLabel.textColor = .white
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genderLabel)
        
        femaleButton.setTitle("여자", for: .normal)
        femaleButton.setTitleColor(UIColor(hexCode: "#8F8F8F"), for: .normal)
        femaleButton.backgroundColor = UIColor(hexCode: "#363636")
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.layer.cornerRadius = 5
        femaleButton.layer.borderWidth = 1
        femaleButton.layer.borderColor = UIColor(hexCode: "#636363").cgColor
        femaleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(femaleButton)
        
        maleButton.setTitle("남자", for: .normal)
        maleButton.setTitleColor(UIColor(hexCode: "#8F8F8F"), for: .normal)
        maleButton.backgroundColor = UIColor(hexCode: "#363636")
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.layer.cornerRadius = 5
        maleButton.layer.borderWidth = 1
        maleButton.layer.borderColor = UIColor(hexCode: "#636363").cgColor
        maleButton.addTarget(self, action: #selector(genderButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(maleButton)
        
        
        // '다음' 버튼
        let nextButton = UIButton(type: .system)
        nextButton.setTitle("다음", for: .normal)
        nextButton.setTitleColor(.white, for: .normal)
        nextButton.backgroundColor = UIColor(hexCode: "FF5935")
        nextButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.layer.cornerRadius = 10
        nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        view.addSubview(nextButton)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            progressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 50),
            progressLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -350),
            
            nicknamePromptLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 10),
            nicknamePromptLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            genderfixLabel.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 40),
            genderfixLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            nicknameLabel.topAnchor.constraint(equalTo: nicknamePromptLabel.bottomAnchor, constant: 80),
            nicknameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            nicknameTextField.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 20),
            nicknameTextField.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70), // Adjusted to make space for the '인증' button
            nicknameTextField.heightAnchor.constraint(equalToConstant: 30),
            
            
            // Divider line constraints
            nicknameTextFielddividerLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nicknameTextFielddividerLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nicknameTextFielddividerLine.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 5),
            nicknameTextFielddividerLine.heightAnchor.constraint(equalToConstant: 1),
            
            genderLabel.topAnchor.constraint(equalTo: nicknameTextFielddividerLine.bottomAnchor, constant: 40),
            genderLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            femaleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
            femaleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            femaleButton.widthAnchor.constraint(equalToConstant: 180),
            femaleButton.heightAnchor.constraint(equalToConstant: 45),
            
            maleButton.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 20),
            maleButton.leadingAnchor.constraint(equalTo: femaleButton.trailingAnchor, constant: 5),
            maleButton.widthAnchor.constraint(equalToConstant: 180),
            maleButton.heightAnchor.constraint(equalToConstant: 45),
            
            nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextButton.topAnchor.constraint(equalTo: nicknameTextFielddividerLine.bottomAnchor, constant: 350),
            nextButton.heightAnchor.constraint(equalToConstant: 55),
            nextButton.widthAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    // 키보드 내리기 위한 탭 제스처 핸들러
    @objc func handleTap() {
        // 키보드를 내립니다.
        view.endEditing(true)
    }
    
    @objc func genderButtonTapped(_ sender: UIButton) {
        // Reset button colors
        femaleButton.backgroundColor = UIColor(hexCode: "#363636")
        femaleButton.setTitleColor(UIColor(hexCode: "#8F8F8F"), for: .normal)
        femaleButton.layer.borderColor = UIColor(hexCode: "#636363").cgColor
        maleButton.backgroundColor = UIColor(hexCode: "#363636")
        maleButton.setTitleColor(UIColor(hexCode: "#8F8F8F"), for: .normal)
        maleButton.layer.borderColor = UIColor(hexCode: "#636363").cgColor
        
        
        // Change the color of the tapped button
        sender.backgroundColor = UIColor(hexCode: "#6F2B1C")
        sender.setTitleColor(UIColor(hexCode: "#FFD7CC"), for: .normal)
        sender.layer.borderColor = UIColor(hexCode: "#FF5530").cgColor
        
        if sender == femaleButton {
            gender = "FEMALE"
        } else if sender == maleButton {
            gender = "MALE"
        }
    }
    
    
    @objc func nextButtonTapped() {
        
        let nickname = nicknameTextField.text

        // 서버에 POST 요청을 보냅니다.
        sendNicknameToServer(nickname: nickname)
    }

    // 서버에 GET 요청을 보내는 메서드
    func sendNicknameToServer(nickname: String?) {
        guard let nickname = nickname, !nickname.isEmpty else {
            // 닉네임이 비어있을 경우에 대한 처리
            return
        }
        
        // API 엔드포인트 URL과 쿼리 파라미터 준비
        var urlComponents = URLComponents(string: "https://study-hub.site:443/api/users/duplication-nickname")!
        urlComponents.queryItems = [URLQueryItem(name: "nickname", value: nickname)]

        guard let url = urlComponents.url else {
            // 잘못된 URL 처리
            return
        }

        // URLRequest 생성 (GET 요청으로 수정)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // URLSession을 사용하여 서버 요청을 보냅니다.
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            // 서버 응답 처리
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                // 서버로부터 ACCEPTED 응답을 받았을 때의 처리
                if let responseString = String(data: data, encoding: .utf8) {
                    print("서버 응답: \(responseString)")
                }
                DispatchQueue.main.async {
                    // "사용 가능한 닉네임입니다" 알림 표시
                    self?.showAlert(message: "사용 가능한 닉네임입니다") {
                        // 확인 버튼을 눌렀을 때 실행할 코드
                        self?.navigateToDepartmentViewController()
                    }
                }
            } else {
                // 기타 오류 응답일 때의 처리
                if let responseString = String(data: data ?? Data(), encoding: .utf8) {
                    print("서버 응답: \(responseString)")
                }
                DispatchQueue.main.async {
                    // nicknameTextFielddividerLine 색상을 빨강색으로 변경
                    // "중복된 닉네임입니다" 경고 표시
                    self?.showAlert(message: "중복된 닉네임입니다") {
                        // 확인 버튼을 눌렀을 때 실행할 코드 (예를 들어 다른 처리나 다이얼로그 닫기)
                        self?.navigateToDepartmentViewController()
                    }
                }
            }
        }
        task.resume()
    }

    // UIAlertController를 사용하여 알림을 표시하는 메서드
    func showAlert(message: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            // 확인 버튼을 눌렀을 때 실행할 코드
            completion?()
        })
        present(alert, animated: true, completion: nil)
    }
    
    // DepartmentViewController로 화면 전환하는 메서드
    func navigateToDepartmentViewController() {
        let departmentVC = DepartmentViewController()
        departmentVC.email = email
        departmentVC.password = password
        departmentVC.gender = gender
        departmentVC.nickname = nicknameTextField.text
        
        // Use the navigation controller to push the DepartmentViewController onto the navigation stack
        navigationController?.pushViewController(departmentVC, animated: true)
    }
}

//
//  EditnicknameViewController.swift
//  STUDYHUB2
//
//  Created by HYERYEONG on 11/14/23.
//

import UIKit

import SnapKit

class EditnicknameViewController: UIViewController {

    var nickname: String?
  
  private let headerStackView: UIStackView = {
    let headerStackView = UIStackView()
    headerStackView.axis = .horizontal
    headerStackView.alignment = .center
    headerStackView.spacing = 8
    return headerStackView
  }()
  
  private lazy var backButton: UIButton = {
    let backButton = UIButton(type: .system)
    backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    backButton.tintColor = .white
    backButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
    return backButton
  }()

 private lazy var changenameLabel = createLabel(title: "닉네임 변경",
                                                    textColor: .white,
                                                    fontSize: 18)
    
    lazy var completeButton: UIButton = {
      let completeButton = UIButton()
        completeButton.setTitle("완료", for: .normal)
        completeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        completeButton.setTitleColor(UIColor(hexCode: "#6F2B1C"), for: .normal)
        completeButton.translatesAutoresizingMaskIntoConstraints = false
        completeButton.addTarget(self, action: #selector(completeButtonTapped), for: .touchUpInside)

      return completeButton
    }()
    
  
  private lazy var headerContentStackView = createStackView(axis: .vertical,
                                                            spacing: 40)
    
    
  private lazy var newnicknameLabel = createLabel(title: "새로운 닉네임을 알려주세요",
                                                    textColor: .black,
                                                    fontSize: 16)
    


    private lazy var newnicknameTextField: UITextField = {
        let textField = createTextField(title: "")
        
        if let nickname = nickname {
            textField.attributedPlaceholder = NSAttributedString(string: nickname, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        }
        
        textField.textColor = .black
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return textField
    }()
    
    private let characterCountLabel: UILabel = {
        let countLabel = UILabel()
        countLabel.textColor = UIColor(hexCode: "#8F8F8F")
        countLabel.text = "0/10"
        countLabel.font = UIFont.systemFont(ofSize: 12)
        return countLabel
    }()
    
    private lazy var nicknamenotuseLabel: UILabel = {
        let nicknamenotuseLabel = UILabel()
        nicknamenotuseLabel.text = "이미 존재하는 닉네임이에요"
        nicknamenotuseLabel.font = UIFont.systemFont(ofSize: 12)
        nicknamenotuseLabel.textColor = .red
        nicknamenotuseLabel.isHidden = true
        
        return nicknamenotuseLabel
    }()

    
  let scrollView = UIScrollView()
  
  // MARK: - viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .black
      
      // Load access token
      if let accessToken = TokenManager.shared.loadAccessToken() {
          print("Access Token: \(accessToken)")
          // Now you can use the accessToken as needed in this view controller
      } else {
          print("Access Token not found.")
      }
    
    setUpLayout()
    makeUI()
  }

  // MARK: - setUpLayout
  func setUpLayout(){
      headerStackView.addArrangedSubview(backButton)
      headerStackView.addArrangedSubview(changenameLabel)
      headerStackView.addArrangedSubview(completeButton)
      
      headerContentStackView.addArrangedSubview(newnicknameLabel)
      headerContentStackView.addArrangedSubview(newnicknameTextField)
      headerContentStackView.addArrangedSubview(characterCountLabel)
      headerContentStackView.addArrangedSubview(nicknamenotuseLabel)





    view.addSubview(headerStackView)
     
   
  
    // 키보드 내리기를 위한 탭 제스처 추가
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    view.addGestureRecognizer(tapGesture)
    
    
    // Create a scroll view to make the content scrollable
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(headerContentStackView)
    view.addSubview(scrollView)
    
    scrollView.backgroundColor = .white
    
    headerContentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
  }
  // MARK: - makeUI
  func makeUI(){
    headerStackView.snp.makeConstraints { make in
      make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
      make.leading.equalTo(view.snp.leading).offset(-60)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
    }
      
      backButton.snp.makeConstraints { make in
        make.leading.equalTo(headerStackView.snp.leading).offset(-20)
      }
      
      changenameLabel.snp.makeConstraints { make in
      make.centerX.equalTo(headerStackView.snp.centerX).offset(80)
    }
      
      completeButton.snp.makeConstraints { make in
          make.leading.equalTo(changenameLabel.snp.leading).offset(180)
    }
      
      // Header content stack view constraints
      headerContentStackView.snp.makeConstraints { make in
        make.top.equalTo(scrollView.snp.top).offset(20)
        make.leading.equalTo(scrollView.snp.leading)
        make.trailing.equalTo(scrollView.snp.trailing)
        make.bottom.equalTo(scrollView.snp.bottom)
        make.width.equalTo(scrollView.snp.width)
      }
      
      newnicknameLabel.snp.makeConstraints { make in
        make.top.equalTo(headerStackView.snp.bottom).offset(45)
        make.leading.equalTo(view).offset(20)
      }
      
      newnicknameTextField.snp.makeConstraints { make in
        make.top.equalTo(newnicknameLabel.snp.bottom).offset(10)
        make.trailing.equalTo(view).offset(-10)
        make.width.equalTo(335)
        make.height.equalTo(50)
      }
      
      characterCountLabel.snp.makeConstraints { make in
          make.top.equalTo(newnicknameTextField.snp.bottom).offset(10)
          make.leading.equalTo(view).offset(350)
      }
      
      nicknamenotuseLabel.snp.makeConstraints { make in
          make.top.equalTo(newnicknameTextField.snp.bottom).offset(5)
          make.leading.equalTo(view).offset(20)
      }
      
    
    scrollView.snp.makeConstraints { make in
      make.top.equalTo(headerStackView.snp.bottom).offset(16)
      make.leading.equalTo(view)
      make.trailing.equalTo(view)
      make.bottom.equalTo(view)
    }
  }
  
    
    // MARK: - TextField Editing Change
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let text = textField.text else { return }
        
        if text.isEmpty {
            completeButton.setTitleColor(UIColor(hexCode: "#6F2B1C"), for: .normal)
        } else {
            completeButton.setTitleColor(UIColor(hexCode: "#FF5530"), for: .normal)

        }
        
        let characterCount = text.count
        
        let attributedString = NSMutableAttributedString(string: "\(characterCount)/10")
        attributedString.addAttribute(.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: 1))
        characterCountLabel.attributedText = attributedString

        if characterCount > 10 {
            textField.text = String(text.prefix(10)) // Restrict input to 10 characters
            characterCountLabel.text = "10/10"
        } else {
            characterCountLabel.text = "\(characterCount)/10"
        }
    }
    
    
    @objc func completeButtonTapped() {
        let nickname = newnicknameTextField.text
        
        //닉네임 중복확인
        sendNicknameToServer(nickname: nickname)
    }
    
    
  
  // 키보드 내리기 위한 탭 제스처 핸들러
  @objc func handleTap() {
    // 키보드를 내립니다.
    view.endEditing(true)
  }
  

  @objc func goBack() {
    
    self.dismiss(animated: true, completion: nil)
  }
    
    
    // MARK: - 닉네임 중복확인
    func sendNicknameToServer(nickname: String?) {
        guard let nickname = nickname, !nickname.isEmpty else {
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
                }
                DispatchQueue.main.async {
                    // "사용 가능한 닉네임입니다"
                    self?.nicknamenotuseLabel.isHidden = true
                    self?.newnicknameTextField.layer.borderColor = UIColor.black.cgColor
                    self?.updateNicknameWithServer(nickname: nickname)

                }
            } else {
                // 기타 오류 응답일 때의 처리
                if let responseString = String(data: data ?? Data(), encoding: .utf8) {
                }
                DispatchQueue.main.async {
                    // "중복된 닉네임입니다"
                    self?.completeButton.setTitleColor(UIColor(hexCode: "#6F2B1C"), for: .normal)
                    self?.nicknamenotuseLabel.isHidden = false
                    self?.newnicknameTextField.layer.borderColor = UIColor.red.cgColor
                    
                }
            }
        }
        task.resume()
    }


    // MARK: - 닉네임 변경
    func updateNicknameWithServer(nickname: String) {
        // API 엔드포인트 URL 설정
        let urlString = "https://study-hub.site:443/api/users/nickname"
        guard let url = URL(string: urlString) else {
            // 잘못된 URL 처리
            return
        }

        // URLRequest 생성 (PUT 요청)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"

        // 헤더에 Access Token 추가
        if let accessToken = TokenManager.shared.loadAccessToken() {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            // Access Token이 없을 경우에 대한 처리
            return
        }

        // HTTP Body 설정
        let body: [String: Any] = [
            "nickname": nickname
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            // JSON Serialization 에러 처리
            return
        }

        // URLSession을 사용하여 서버 요청을 보냅니다.
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            // 서버 응답 처리
            if let data = data,
               let response = response as? HTTPURLResponse,
               response.statusCode == 200 {
                // 서버로부터 OK 응답을 받았을 때의 처리
                if let responseString = String(data: data, encoding: .utf8) {
                    print("닉네임 변경 성공 - 서버 응답: \(responseString)")

                    DispatchQueue.main.async { [weak self] in
                        // 닉네임 변경 완료 후 MyInformViewController로 이동
                        self?.navigateToMyInformViewController(with: nickname)
                    }
                }
            } else {
                // 기타 오류 응답일 때의 처리
                if let responseString = String(data: data ?? Data(), encoding: .utf8) {
                    if let accessToken = TokenManager.shared.loadAccessToken() {
                        print("액세스토큰: \(accessToken)")

                    } else {
                        // Handle the case where the access token is not available
                        print("Access Token not available.")
                        return
                    }
                    print("닉네임: \(nickname)")
                    print("닉네임 변경 실패 - 서버 응답: \(responseString)")
                }
                DispatchQueue.main.async {
                    print("닉네임 변경 실패")
                }
            }
        }
        task.resume()
    }

    // Helper function to navigate to MyInformViewController
    private func navigateToMyInformViewController(with nickname: String) {

    }

}

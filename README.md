
# 스터디 매칭 앱 서비스
![스터디허브](https://github.com/user-attachments/assets/732c1f38-c352-4e79-b395-33ab04e1695d)

# 📎 Study-Hub

| 앱 소개 | 학생들이 함께 공부하고 정보를 나눌 스터디원을 구할 수 있는 iOS 앱 서비스 |
| --- | --- |
| 개발 기간 | 2023.10.07 ~ 2024.03.01 |
| 개발 인원 | iOS(2), Android(2), Server(2), Designer(1) |
| 담당 역할 | iOS Developer |
| 사용 기술 | Swift, UIKit, Snapkit, Keychain, Moya, Kingfisher, RxSwift |

## 담당 업무

- UIKit과 SnapKit을 활용한 화면 구현 및 리팩토링
- Keychain을 활용한 사용자 JWT 토큰 관리 기능 구현
- Moya 라이브러리를 통한 서버 RESTful API 연동
- Kingfisher 라이브러리를 활용한 사용자 프로필 이미지 관리 기능 구현
- 스터디 생성, 수정, 삭제 기능 구현
- 스터디 참여 기능 구현
- 스터디 신청 수락 및 거절 기능 구현
- 댓글 기능 구현
- 북마크 기능 구현
- 사용자 정보 수정 기능 구현

## 주요 성과

- **서버 API 연동**: Moya 라이브러리를 활용해 RESTful API와 안정적으로 연동하며 네트워크 작업 효율화.
- **JWT 토큰 관리 최적화**: Keychain을 사용하여 사용자 인증 토큰(JWT)을 안전하고 효율적으로 저장 및 관리.
- **비동기 데이터 처리 전환**: 클로저 및 Delegate 기반 코드에서 RxSwift를 도입하여 데이터 처리와 UI 업데이트 간소화 및 반응형 프로그래밍 구현.
- **UI 구조화 및 리팩토링**: ViewController에서 UI 요소를 별도 컴포넌트로 분리하여 가독성 및 유지보수성 향상.
- **이미지 관리 최적화**: Kingfisher 라이브러리를 활용해 사용자 프로필 이미지를 효율적으로 캐싱 및 처리.
- **주요 기능 구현**: 스터디 생성, 수정, 삭제, 참여, 신청 관리, 댓글 및 북마크 기능 등 사용자 경험 향상을 위한 주요 기능 구현 완료.

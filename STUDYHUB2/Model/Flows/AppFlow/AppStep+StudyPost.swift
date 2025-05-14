//
//  AppStep+StudyPost.swift
//  STUDYHUB2
//
//  Created by 최용헌 on 3/27/25.
//

import UIKit
import RxFlow
import RxRelay

/// 스터디 관련 화면 이동
enum StudyPostStep {
  // 북마크 화면
  case bookmarkScreenIsRequired
  
  // 이용방법 화면
  case howToUseScreenIsRequired
  
  // 스터디 상세 화면
  case studyDetailScreenIsRequired(postID: Int)

  // 댓글 전체 화면
  case commentDetailScreenIsRequired(postID: Int)
  
  // 스터디 신청 화면
  case applyStudyScreenIsRequired(data: BehaviorRelay<PostDetailData?>)
}

extension AppFlow{
  func navigateStudy(step: StudyPostStep) -> FlowContributors {
    switch step {
    case .bookmarkScreenIsRequired:
      return navToBookmarkScreen()
    case .howToUseScreenIsRequired:
      return navToHowToUseScreen()
    case .studyDetailScreenIsRequired(let postID):
      return navToStudyDetailScreen(postID: postID)
    case .commentDetailScreenIsRequired(let postID):
      return navToCommentDetailScreen(postID: postID)
    case .applyStudyScreenIsRequired(let data):
      return navToApplyStudy(with: data)
    }
  }
  
  
  /// 북마크 화면으로 이동
  func navToBookmarkScreen() -> FlowContributors {
    let viewModel: BookmarkViewModel = BookmarkViewModel()
    let vc = BookmarkViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 스터디 신청하기 화면으로 이동
  func navToApplyStudy(with data: BehaviorRelay<PostDetailData?>) -> FlowContributors {
    let viewModel: ApplyStudyViewModel = ApplyStudyViewModel(data)
    let vc = ApplyStudyViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 이용방법 화면으로 이동
  func navToHowToUseScreen() -> FlowContributors {
    let vc = HowToUseViewController()
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNext: vc))
  }
  
  
  /// 스터디 디테일 화면으로 이동
  func navToStudyDetailScreen(postID: Int) -> FlowContributors {
    let viewModel: PostedStudyViewModel = PostedStudyViewModel(with: postID)
    let vc = PostedStudyViewController(with: viewModel)
    self.rootViewController.navigationBar.isHidden = false
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
  
  /// 전체댓글 화면으로 이동
  /// - Parameter postID: 스터디의 postID
  func navToCommentDetailScreen(postID: Int) -> FlowContributors {
    let viewModel: CommentViewModel = CommentViewModel(with: postID)
    let vc = CommentViewController(with: viewModel)
    self.rootViewController.pushViewController(vc, animated: true)
    return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: viewModel))
  }
}

import UIKit

import FSCalendar
import SnapKit

final class CalendarViewController: UIViewController {
  let viewModel: CreateStudyViewModel
  private var calendar: FSCalendar?
  
  private lazy var titleLabel = createLabel(
    title: viewModel.dateFormatter.string(from: Date()),
    textColor: .black,
    fontType: "Pretendard",
    fontSize: 18
  )
    
  private lazy var previousButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    button.tintColor = .black
    button.addTarget(self, action: #selector(self.prevCurrentPage), for: .touchUpInside)
    return button
  }()
  
  private lazy var nextButton: UIButton = {
    let button = UIButton()
    button.setImage(
      UIImage(systemName: "chevron.right")?.withRenderingMode(.alwaysTemplate),
      for: .normal
    )
    button.tintColor = .black
    button.addTarget(self, action: #selector(self.nextCurrentPage), for: .touchUpInside)
    return button
  }()
  
  private lazy var completeButton: UIButton = {
    let button = UIButton()
    button.setTitle("완료", for: .normal)
    button.setTitleColor(.o50, for: .normal)
    button.addTarget(self, action: #selector(self.completeButtonTapped), for: .touchUpInside)
    return button
  }()
  
  
  /// init - 캘린더 init
  /// - Parameter viewModel: 스터디 생성 ViewModel
  init(viewModel: CreateStudyViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: .none)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.calendar = FSCalendar(frame: .zero)
    calendar?.delegate = self
    calendar?.locale = Locale(identifier: "ko_KR")
    
    setupLayout()
    setupCalendarUI()
    
    view.backgroundColor = .white
  }// viewDidLoad
  
  // MARK: - setupLayout
  
  
  /// UI 설정
  func setupLayout() {
    if let cal = calendar {
      view.addSubview(cal)
      cal.snp.makeConstraints { make in
        make.top.equalTo(view.snp.top).offset(100)
        make.leading.trailing.bottom.equalTo(view)
      }
    }
    
    view.addSubview(titleLabel)
    titleLabel.snp.makeConstraints { make in
      make.leading.equalTo(calendar!).offset(50)
      make.top.equalTo(calendar!).offset(-60)
    }
    
    view.addSubview(previousButton)
    previousButton.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.trailing.equalTo(titleLabel.snp.leading).offset(-20)
    }
    
    view.addSubview(nextButton)
    nextButton.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.leading.equalTo(titleLabel.snp.trailing).offset(20)
    }
    
    view.addSubview(completeButton)
    completeButton.snp.makeConstraints { make in
      make.centerY.equalTo(titleLabel)
      make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
    }
  }
  
  // MARK: - setupCalendarUI
  
  
  /// 캘린더 UI 설정
  func setupCalendarUI() {
    calendar?.allowsSelection = true
    calendar?.allowsMultipleSelection = false
    
    calendar?.dataSource = self
    calendar?.scrollEnabled = false
    
    self.calendar?.calendarWeekdayView.weekdayLabels[0].text = "일"
    self.calendar?.calendarWeekdayView.weekdayLabels[1].text = "월"
    self.calendar?.calendarWeekdayView.weekdayLabels[2].text = "화"
    self.calendar?.calendarWeekdayView.weekdayLabels[3].text = "수"
    self.calendar?.calendarWeekdayView.weekdayLabels[4].text = "목"
    self.calendar?.calendarWeekdayView.weekdayLabels[5].text = "금"
    self.calendar?.calendarWeekdayView.weekdayLabels[6].text = "토"
    
    calendar?.headerHeight = 0
    calendar?.appearance.titleFont = UIFont(name: "Pretendare-Medium", size: 14)
    self.calendar?.appearance.weekdayTextColor = UIColor.bg80
    calendar?.appearance.headerMinimumDissolvedAlpha = 0.0
    self.calendar?.appearance.titlePlaceholderColor = UIColor.red.withAlphaComponent(0.2)
    self.calendar?.appearance.titleDefaultColor = UIColor.black.withAlphaComponent(0.8)
    self.calendar?.placeholderType = .none
    
    if viewModel.startDate.value == "선택하기" {
      calendar?.appearance.titleTodayColor = .o50
      calendar?.appearance.todayColor = .o10
    } else {
      calendar?.appearance.titleTodayColor = .black
      calendar?.appearance.todayColor = .white
    }
    
    calendar?.reloadData()
  }

  func calendar(
    _ calendar: FSCalendar,
    willDisplay cell: FSCalendarCell,
    for date: Date,
    at monthPosition: FSCalendarMonthPosition
  ) {
    let calendarCurrent = Calendar.current
    let currentMonth = calendarCurrent.component(.month, from: Date())
    let cellMonth = calendarCurrent.component(.month, from: date)
    
    if cellMonth == currentMonth {
      let currentDay = calendarCurrent.component(.day, from: Date())
      let cellDay = calendarCurrent.component(.day, from: date)
      
      // 현재 날짜보다 작은 애들은 회색처리
    if cellDay < currentDay {
        cell.isHidden = false
        cell.titleLabel.textColor = .bg40
      // 현재 날짜는 색칠
      } else if cellDay == currentDay && viewModel.startDate.value == "선택하기" {
        cell.isHidden = false
        cell.titleLabel.textColor = .o50
        // seletedDay말고 시작날짜로 해야할듯
      } else if viewModel.selectedDay > cellDay {
        cell.titleLabel.textColor = .bg40
      } else if viewModel.selectedDay == cellDay {
        cell.titleLabel.textColor = .o50
        
        cell.shapeLayer?.path = UIBezierPath(ovalIn: cell.bounds).cgPath
        cell.shapeLayer?.fillColor = UIColor.o10.cgColor
      }
    }
  }
  
  // MARK: - 날짜 선택 시 콜백 메소드
  
  public func calendar(
    _ calendar: FSCalendar,
    didSelect date: Date,
    at monthPosition: FSCalendarMonthPosition
  ) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    viewModel.seletedDate = dateFormatter.string(from: date)
    
    let isToday = Calendar.current.isDate(date, inSameDayAs: Date())
    
    if !isToday {
      calendar.appearance.todayColor = .white
      calendar.appearance.titleTodayColor = .black
    } else if isToday{
      calendar.appearance.todayColor = nil
    }

    calendar.appearance.selectionColor = .o50
  }
  
  
  /// 캘린더 페이지 이동
  /// - Parameter month: 월
  func movePage(month: Int){
    let cal = Calendar.current
    var dateComponents = DateComponents()
    dateComponents.month = month
    viewModel.dateFormatter.dateFormat = "yyyy년 MM월"
    
    self.viewModel.currentPage = cal.date(
      byAdding: dateComponents,
      to: self.viewModel.currentPage ?? self.viewModel.today
    )
    if let currentPage = self.viewModel.currentPage {
      self.calendar?.setCurrentPage(currentPage, animated: true)
    }
  }
  
  
  /// 다음 페이지로 이동
  /// - Parameter sender: UIButton - 다음 페이지 이동 버튼
  @objc private func nextCurrentPage(_ sender: UIButton) {
    movePage(month: 1)
  }
  
  /// 이전 페이지로 이동
  /// - Parameter sender: UIButton - 이전 페이지 이동 버튼
  @objc private func prevCurrentPage(_ sender: UIButton) {
    movePage(month: -1)
  }

  
  /// 완료버튼 action
  /// - Parameter sender: UIButton - 완료버튼
  @objc private func completeButtonTapped(_ sender: UIButton) {
    // 선택한 날짜 확인
    guard let data = viewModel.seletedDate else { return }
    
    if viewModel.isStartDateButton.value {
      viewModel.startDate.accept(data)
    } else {
      viewModel.endDate.accept(data)
    }
    viewModel.selectedDay = Int(data.suffix(2)) ?? 0
    self.dismiss(animated: true, completion: nil)
  }
}

extension CalendarViewController: FSCalendarDelegate,
                                  FSCalendarDataSource,
                                  FSCalendarDelegateAppearance {
  func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    self.titleLabel.text = self.viewModel.dateFormatter.string(from: calendar.currentPage)
  }
  
  // 현재 날짜를 선택할 수 있는지 여부
  
  func calendar(
    _ calendar: FSCalendar,
    shouldSelect date: Date,
    at monthPosition: FSCalendarMonthPosition
  ) -> Bool {
    let currentDate = Date()
    let calendar = Calendar.current
    
    let dateFormatter = viewModel.dateFormatter
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let startDate = dateFormatter.date(from: viewModel.startDate.value),
      viewModel.isEndDateButton.value {
      if date < startDate {
        return false
      }
    }
    
    if calendar.isDate(date, inSameDayAs: currentDate) {
      return true
    }
    
    return date > currentDate
  }

  // 기본 색상 설정
  
  func calendar(
    _ calendar: FSCalendar,
    appearance: FSCalendarAppearance,
    titleDefaultColorFor date: Date
  ) -> UIColor? {
    let currentDate = Date()
    let calendar = Calendar.current
        
    let dateFormatter = viewModel.dateFormatter
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let startDate = dateFormatter.date(from: viewModel.startDate.value),
      viewModel.isEndDateButton.value {
      if date < startDate {
        return UIColor.bg40
      }
    }
    if calendar.isDate(date, inSameDayAs: currentDate) || date > currentDate {
      return appearance.titleDefaultColor
    } else {
      return UIColor.bg40
    }
  }
}

extension CalendarViewController: CreateUIprotocol {}

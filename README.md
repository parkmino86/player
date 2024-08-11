# Player Management System

이 프로젝트는 SQLite 기반 로컬 데이터베이스를 사용하는 선수 관리 시스템입니다. 사용자는 팀을 생성하고, 팀에 선수를 추가하거나 제거할 수 있습니다. 데이터베이스 관리와 마이그레이션을 포함한 여러 기능을 제공합니다.

## 기능 요약

- **팀 및 선수 관리**: 팀 생성, 선수 추가 및 삭제, 팀과 선수 간의 관계 관리.
- **SQLite 기반 로컬 데이터베이스**: 데이터를 로컬에 저장하고 관리.
- **데이터베이스 마이그레이션**: 데이터베이스의 구조를 단계적으로 업데이트하기 위한 마이그레이션 시스템.
- **데이터베이스 오류 처리**: 데이터베이스 관련 오류를 처리하는 로직 구현.

## 프로젝트 구조

```plaintext
player/
│
├── Entities/                          # 데이터베이스 엔티티 및 모델 정의
│   ├── Player/
│   │   ├── PlayerDBModel.swift        # Player 데이터베이스 모델
│   ├── Team/
│   │   ├── TeamDBModel.swift          # Team 데이터베이스 모델
│   ├── TeamPlayer/
│   │   ├── TeamPlayerDBModel.swift    # Team-Player 관계 데이터베이스 모델
│
├── Features/                          # 주요 기능 관련 코드
│   ├── Team/                          # 팀 관리 관련 뷰 및 ViewModel
│   │   ├── AddTeam/                   # 팀 추가 관련 코드
│   │   │   ├── AddTeamView.swift      # 팀 추가 뷰
│   │   │   ├── AddTeamViewModel.swift # 팀 추가 ViewModel
│   │   ├── TeamList/                  # 팀 목록 관련 코드
│   │   │   ├── TeamListView.swift     # 팀 목록 뷰
│   │   │   ├── TeamListViewModel.swift # 팀 목록 ViewModel
│   │   ├── TeamPlayerList/            # 팀의 선수 목록 관리
│   │       ├── AddTeamPlayerView.swift      # 선수 추가 뷰
│   │       ├── AddTeamPlayerViewModel.swift # 선수 추가 ViewModel
│   │       ├── TeamPlayerListView.swift     # 팀 선수 목록 뷰
│   │       ├── TeamPlayerListViewModel.swift # 팀 선수 목록 ViewModel
│   ├── Player/                        # 선수 관리 관련 뷰 및 ViewModel
│   │   ├── AddPlayerView.swift        # 선수 추가 뷰
│   │   ├── PlayerListView.swift       # 전체 선수 목록 뷰
│   │   ├── PlayerViewModel.swift      # 선수 관리 ViewModel
│
├── Core/                              # 코어 로직 관련 코드
│   ├── database/                      # SQLite 데이터베이스 및 마이그레이션 관련 파일
│   │   ├── Migrations/                # 마이그레이션 파일들 (V1 ~ V4)
│   │   │   ├── MigrationV1.swift      # 초기 테이블 생성
│   │   │   ├── MigrationV2.swift      # team_player 관계 테이블 추가
│   │   │   ├── MigrationV3.swift      # player 테이블에서 score 필드를 backnumber로 변경
│   │   │   ├── MigrationV4.swift      # 외래 키 수정 및 테이블 이름 변경
│   │   ├── DatabaseManager.swift      # 데이터베이스 관리 및 마이그레이션 로직
│   │   ├── DatabaseError.swift        # 데이터베이스 관련 오류 처리
│
├── Tests/                             # 테스트 코드
│   ├── databaseTests/                 # 데이터베이스 관련 테스트
│   │   ├── databaseTests.swift        # 데이터베이스 테스트 코드
│   │   └── Package.swift              # 테스트 패키지 설정
│
└── playerApp/                         # 프로젝트 메인 파일 및 설정
    ├── player.xcodeproj               # Xcode 프로젝트 파일
    ├── playerApp.swift                # 애플리케이션 진입점
    └── ContentView.swift              # 기본 ContentView

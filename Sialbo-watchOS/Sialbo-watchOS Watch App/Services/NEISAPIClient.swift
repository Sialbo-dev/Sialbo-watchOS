//
//  NEISAPIClient.swift
//  Sialbo-watchOS Watch App
//
//  나이스 교육정보 개방포털 Open API 호출
//

import Foundation

struct NEISAPIClient {
    struct RawPeriod {
        let date: Date
        let periodNumber: Int
        let subject: String
    }

    enum APIError: Error {
        case invalidResponse
    }

    private let baseURL = "https://open.neis.go.kr/hub"

    // 학교 검색

    func searchSchools(query: String) async throws -> [School] {
        var components = URLComponents(string: "\(baseURL)/schoolInfo")!
        components.queryItems = [
            URLQueryItem(name: "KEY", value: Secrets.neisAPIKey),
            URLQueryItem(name: "Type", value: "json"),
            URLQueryItem(name: "pIndex", value: "1"),
            URLQueryItem(name: "pSize", value: "50"),
            URLQueryItem(name: "SCHUL_NM", value: query),
        ]
        let data = try await fetch(components.url!)
        let rows: [SchoolRow] = Self.firstRows(from: data)

        return rows.compactMap { row in
            guard let kind = SchoolKind(neisSchoolKindName: row.SCHUL_KND_SC_NM) else { return nil }
            return School(
                officeCode: row.ATPT_OFCDC_SC_CODE,
                schoolCode: row.SD_SCHUL_CODE,
                name: row.SCHUL_NM,
                address: row.ORG_RDNMA,
                kind: kind
            )
        }
    }

    // 시간표 조회

    /// 학년-반 존재 여부 확인 + 화면 표시용 시간표를 함께 얻기 위한 원본 교시 목록
    func fetchRawTimetable(school: School, grade: Int, classNumber: Int, from: Date, to: Date) async throws -> [RawPeriod] {
        var components = URLComponents(string: "\(baseURL)/\(school.kind.timetableEndpoint)")!
        components.queryItems = [
            URLQueryItem(name: "KEY", value: Secrets.neisAPIKey),
            URLQueryItem(name: "Type", value: "json"),
            URLQueryItem(name: "pIndex", value: "1"),
            URLQueryItem(name: "pSize", value: "1000"),
            URLQueryItem(name: "ATPT_OFCDC_SC_CODE", value: school.officeCode),
            URLQueryItem(name: "SD_SCHUL_CODE", value: school.schoolCode),
            URLQueryItem(name: "GRADE", value: String(grade)),
            URLQueryItem(name: "CLASS_NM", value: String(classNumber)),
            URLQueryItem(name: "TI_FROM_YMD", value: Self.ymd(from)),
            URLQueryItem(name: "TI_TO_YMD", value: Self.ymd(to)),
        ]
        let data = try await fetch(components.url!)
        let rows: [TimetableRow] = Self.firstRows(from: data)

        return rows.compactMap { row in
            guard let date = Self.dateFromYmd(row.ALL_TI_YMD), let periodNumber = Int(row.PERIO) else { return nil }
            return RawPeriod(date: date, periodNumber: periodNumber, subject: row.ITRT_CNTNT)
        }
    }

    /// 한 주치 시간표
    func fetchTimetable(school: School, grade: Int, classNumber: Int, from: Date, to: Date, scheduleSettings: ScheduleSettings) async throws -> [DaySchedule] {
        let rawPeriods = try await fetchRawTimetable(school: school, grade: grade, classNumber: classNumber, from: from, to: to)
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: rawPeriods) { calendar.startOfDay(for: $0.date) }

        return grouped.map { date, periods in
            let calculated = PeriodTimeCalculator.periods(
                from: periods.map { ($0.periodNumber, $0.subject) },
                date: date,
                scheduleSettings: scheduleSettings,
                kind: school.kind
            )
            return DaySchedule(date: date, periods: calculated)
        }.sorted { $0.date < $1.date }
    }

    // 이번 주 범위

    static func currentWeekRange(referenceDate: Date = .now) -> (from: Date, to: Date) {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: referenceDate) // 일=1 ... 토=7
        let daysSinceMonday = (weekday + 5) % 7
        let monday = calendar.date(byAdding: .day, value: -daysSinceMonday, to: calendar.startOfDay(for: referenceDate))!
        let friday = calendar.date(byAdding: .day, value: 4, to: monday)!
        return (monday, friday)
    }

    // 네트워킹 / 파싱 공통

    private func fetch(_ url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        return data
    }

    private struct APISection<Row: Decodable>: Decodable {
        let row: [Row]?
    }

    // 디코딩 실패 시 빈 배열로 처리.
    private static func firstRows<Row: Decodable>(from data: Data) -> [Row] {
        guard let decoded = try? JSONDecoder().decode([String: [APISection<Row>]].self, from: data) else {
            return []
        }
        return decoded.values.first?.compactMap(\.row).flatMap { $0 } ?? []
    }

    private static let ymdFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.timeZone = .current
        return formatter
    }()

    private static func ymd(_ date: Date) -> String {
        ymdFormatter.string(from: date)
    }

    private static func dateFromYmd(_ value: String) -> Date? {
        ymdFormatter.date(from: value)
    }
}

private struct SchoolRow: Decodable {
    let ATPT_OFCDC_SC_CODE: String
    let SD_SCHUL_CODE: String
    let SCHUL_NM: String
    let ORG_RDNMA: String
    let SCHUL_KND_SC_NM: String
}

private struct TimetableRow: Decodable {
    let ALL_TI_YMD: String
    let PERIO: String
    let ITRT_CNTNT: String
}

private extension SchoolKind {
    var timetableEndpoint: String {
        switch self {
        case .elementary: return "elsTimetable"
        case .middle: return "misTimetable"
        case .high: return "hisTimetable"
        }
    }
}

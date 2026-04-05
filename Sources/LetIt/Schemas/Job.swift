public enum JobLocation: String {
    case remote = "REMOTE"
    case onsite = "ONSITE"
    case hybrid = "HYBRID"
}

public enum JobType: String {
    case fullTime = "FULL_TIME"
    case partTime = "PART_TIME"
    case contract = "CONTRACT"
    case freelance = "FREELANCE"
    case internship = "INTERNSHIP"
}

public enum JobCategory: String {
    case programming = "PROGRAMMING"
    case blockchain = "BLOCKCHAIN"
    case design = "DESIGN"
    case marketing = "MARKETING"
    case customerSupport = "CUSTOMER_SUPPORT"
    case writing = "WRITING"
    case product = "PRODUCT"
    case service = "SERVICE"
    case humanResource = "HUMAN_RESOURCE"
    case others = "ELSE"
}

public enum JobExperienceLevel: String {
    case all = "ALL"
    case junior = "JUNIOR"
    case mid = "MID"
    case senior = "SENIOR"
    case noExperienceRequired = "NO_EXPERIENCE_REQUIRED"
}

public enum JobStatus: String {
    case draft = "DRAFT"
    case paid = "PAID"
    case confirmed = "CONFIRMED"
    case hold = "HOLD"
    case review = "REVIEW"
    case closed = "CLOSED"
}

public struct UserJobCreatedByUser: Decodable {
    public let slug: String
}

# AI Fraud Detection Example

This example demonstrates how to use the AI-powered fraud detection service.

## Overview

The fraud detection service analyzes transactions in real-time to identify potentially fraudulent activity using machine learning models.

## Basic Fraud Analysis

### Example 1: Analyze Single Transaction

```bash
curl -X POST http://localhost:8002/api/ai/fraud/analyze \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "transaction_id": "txn-12345",
    "amount": 5000.00,
    "transaction_type": "WITHDRAWAL",
    "timestamp": "2025-12-30T23:00:00Z",
    "account_created_date": "2020-01-01T00:00:00Z",
    "channel": "ONLINE",
    "country": "US",
    "home_country": "US",
    "daily_transaction_count": 5,
    "daily_transaction_amount": 8000.00
  }'
```

**Response:**

```json
{
  "transaction_id": "txn-12345",
  "risk_score": 0.625,
  "risk_level": "MEDIUM",
  "recommended_action": "REVIEW",
  "fraud_indicators": [
    "High transaction amount",
    "Transaction during unusual hours",
    "High transaction frequency"
  ],
  "features_analyzed": 12,
  "analysis_timestamp": "2025-12-30T23:00:05Z",
  "model_version": "1.0.0"
}
```

## Python Example

```python
import requests

API_BASE = "http://localhost:8002"
token = "your_jwt_token"

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json"
}

transaction_data = {
    "transaction_id": "txn-67890",
    "amount": 10000.00,
    "transaction_type": "TRANSFER",
    "timestamp": "2025-12-30T02:00:00Z",
    "account_created_date": "2025-12-01T00:00:00Z",  # New account
    "channel": "ONLINE",
    "country": "RU",  # Foreign country
    "home_country": "US",
    "daily_transaction_count": 15,
    "daily_transaction_amount": 25000.00
}

response = requests.post(
    f"{API_BASE}/api/ai/fraud/analyze",
    json=transaction_data,
    headers=headers
)

result = response.json()
print(f"Risk Level: {result['risk_level']}")
print(f"Risk Score: {result['risk_score']}")
print(f"Action: {result['recommended_action']}")
print("Fraud Indicators:")
for indicator in result['fraud_indicators']:
    print(f"  - {indicator}")
```

## Batch Analysis

### Example 2: Analyze Multiple Transactions

```javascript
const axios = require("axios");

const API_BASE = "http://localhost:8002";
const token = "your_jwt_token";

const batchData = {
  batch_id: "batch_20251230_001",
  transactions: [
    {
      transaction_id: "txn-001",
      amount: 500.0,
      transaction_type: "TRANSFER",
      timestamp: "2025-12-30T10:00:00Z",
      account_created_date: "2020-01-01T00:00:00Z",
      channel: "ONLINE",
      country: "US",
      home_country: "US",
      daily_transaction_count: 2,
      daily_transaction_amount: 700.0,
    },
    {
      transaction_id: "txn-002",
      amount: 15000.0,
      transaction_type: "WITHDRAWAL",
      timestamp: "2025-12-30T03:00:00Z",
      account_created_date: "2025-12-28T00:00:00Z",
      channel: "ONLINE",
      country: "NG",
      home_country: "US",
      daily_transaction_count: 20,
      daily_transaction_amount: 30000.0,
    },
  ],
};

axios
  .post(`${API_BASE}/api/ai/fraud/batch-analyze`, batchData, {
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
  })
  .then((response) => {
    console.log("Batch Analysis Results:");
    console.log(`Total Transactions: ${response.data.total_transactions}`);
    console.log(`High Risk: ${response.data.high_risk_count}`);
    console.log(`Medium Risk: ${response.data.medium_risk_count}`);
    console.log(`Low Risk: ${response.data.low_risk_count}`);

    response.data.results.forEach((result) => {
      console.log(`\nTransaction ${result.transaction_id}:`);
      console.log(`  Risk: ${result.risk_level} (${result.risk_score})`);
      console.log(`  Action: ${result.recommended_action}`);
    });
  })
  .catch((error) => console.error("Error:", error));
```

## Integration Example

### Example 3: Integrate with Transaction Service

```java
@Service
public class TransactionService {

    @Autowired
    private FraudDetectionClient fraudClient;

    @Autowired
    private TransactionRepository transactionRepository;

    public Transaction createTransaction(TransactionRequest request) {
        // Create transaction
        Transaction transaction = new Transaction();
        transaction.setAmount(request.getAmount());
        transaction.setType(request.getType());

        // Analyze for fraud before processing
        FraudAnalysisResult fraudResult = fraudClient.analyze(
            buildFraudRequest(transaction)
        );

        transaction.setFraudRiskScore(fraudResult.getRiskScore());
        transaction.setFraudRiskLevel(fraudResult.getRiskLevel());

        // Handle based on risk level
        switch (fraudResult.getRiskLevel()) {
            case "HIGH":
                transaction.setStatus(TransactionStatus.BLOCKED);
                sendSecurityAlert(transaction);
                break;
            case "MEDIUM":
                transaction.setStatus(TransactionStatus.PENDING_REVIEW);
                notifyReviewTeam(transaction);
                break;
            case "LOW":
            case "MINIMAL":
                transaction.setStatus(TransactionStatus.APPROVED);
                processTransaction(transaction);
                break;
        }

        return transactionRepository.save(transaction);
    }
}
```

## Risk Level Interpretation

| Risk Level | Risk Score Range | Recommended Action | Description                        |
| ---------- | ---------------- | ------------------ | ---------------------------------- |
| MINIMAL    | 0.0 - 0.29       | APPROVE            | Low risk, proceed normally         |
| LOW        | 0.3 - 0.49       | MONITOR            | Slight elevation, monitor activity |
| MEDIUM     | 0.5 - 0.79       | REVIEW             | Manual review recommended          |
| HIGH       | 0.8 - 1.0        | BLOCK              | High risk, block transaction       |

## Feature Importance

The fraud detection model considers these features:

1. **Amount-based** - Transaction amount, log-scaled amount
2. **Time-based** - Hour of day, day of week, weekend/night flags
3. **Account-based** - Account age, account creation date
4. **Transaction-based** - Transaction type, channel
5. **Location-based** - Country, foreign country flag
6. **Velocity-based** - Daily transaction count and amount

## See Also

- [AI Recommendations Example](ai_recommendations.md)
- [API Reference](../API.md)
- [Usage Guide](../USAGE.md)

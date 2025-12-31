# AI Recommendations Example

Examples of using AI-powered financial recommendations and insights.

## Product Recommendations

### Example 1: Get Personalized Product Recommendations

```bash
curl -X POST http://localhost:8002/api/ai/recommendations/products \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "customer_id": "user-12345",
    "age": 32,
    "annual_income": 85000,
    "current_savings": 15000,
    "monthly_expenses": 4500,
    "total_debt": 20000,
    "credit_score": 740,
    "financial_goals": ["home_purchase", "retirement"],
    "current_products": ["checking_account", "credit_card"],
    "transaction_history": []
  }'
```

**Response:**

```json
{
  "customer_id": "user-12345",
  "recommendations": [
    {
      "product": {
        "id": "SA001",
        "name": "High Yield Savings",
        "apy": 4.5,
        "min_balance": 1000,
        "features": ["high_interest", "online_banking"]
      },
      "category": "savings_account",
      "score": 0.85,
      "reason": "Excellent rate for building emergency fund",
      "priority": "high"
    },
    {
      "product": {
        "id": "I002",
        "name": "Balanced Portfolio",
        "expected_return": 8.2,
        "risk_level": "medium",
        "features": ["growth_income", "diversified"]
      },
      "category": "investment",
      "score": 0.78,
      "reason": "Grow wealth for long-term goals",
      "priority": "medium"
    }
  ],
  "customer_profile": {
    "life_stage": "early_career",
    "risk_tolerance": "medium",
    "financial_health": {
      "savings_rate": 0.215,
      "debt_to_income": 0.235,
      "emergency_fund_months": 3.3,
      "credit_score": 740
    }
  },
  "generated_at": "2025-12-30T12:00:00Z"
}
```

## Financial Advice

### Example 2: Get Personalized Financial Advice

```python
import requests

def get_financial_advice(customer_data):
    API_BASE = "http://localhost:8002"
    token = "your_jwt_token"

    headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    }

    response = requests.post(
        f"{API_BASE}/api/ai/recommendations/financial-advice",
        json=customer_data,
        headers=headers
    )

    return response.json()

customer = {
    "customer_id": "user-67890",
    "age": 28,
    "annual_income": 60000,
    "current_savings": 5000,
    "monthly_expenses": 3000,
    "total_debt": 25000,
    "credit_score": 680,
    "financial_goals": ["debt_consolidation", "emergency_fund"]
}

advice_result = get_financial_advice(customer)

print(f"Financial Health Score: {advice_result['financial_health_score']['overall_score']}")
print(f"Grade: {advice_result['financial_health_score']['grade']}")

print("\nAdvice:")
for item in advice_result['advice']:
    print(f"\n[{item['priority'].upper()}] {item['title']}")
    print(f"  {item['description']}")
    print("  Action Items:")
    for action in item['action_items']:
        print(f"    - {action}")
```

## Spending Insights

### Example 3: Analyze Spending Patterns

```javascript
const analyzeSpending = async () => {
  const API_BASE = "http://localhost:8002";
  const token = "your_jwt_token";

  const spendingData = {
    customer_id: "user-12345",
    transaction_history: [
      { category: "groceries", amount: 450, date: "2025-12-01T10:00:00Z" },
      { category: "dining", amount: 280, date: "2025-12-05T19:00:00Z" },
      { category: "utilities", amount: 200, date: "2025-12-10T14:00:00Z" },
      { category: "entertainment", amount: 150, date: "2025-12-15T20:00:00Z" },
      { category: "groceries", amount: 380, date: "2025-12-18T11:00:00Z" },
      { category: "transportation", amount: 120, date: "2025-12-20T08:00:00Z" },
      { category: "dining", amount: 95, date: "2025-12-22T18:30:00Z" },
      { category: "shopping", amount: 300, date: "2025-12-25T15:00:00Z" },
    ],
  };

  const response = await fetch(
    `${API_BASE}/api/ai/recommendations/spending-insights`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(spendingData),
    },
  );

  const result = await response.json();

  console.log(`Total Spending: $${result.total_spending}`);
  console.log(`\nTop Spending Categories:`);
  result.top_categories.forEach((cat) => {
    console.log(`  ${cat.category}: $${cat.amount} (${cat.percentage}%)`);
  });

  console.log(`\nMonthly Trend: ${result.monthly_trend}`);
  console.log(`\nInsights:`);
  result.insights.forEach((insight) => console.log(`  - ${insight}`));
};

analyzeSpending();
```

## Dashboard Integration

### Example 4: Build Financial Dashboard

```typescript
import React, { useEffect, useState } from 'react';
import { Box, Card, CardContent, Typography, Grid } from '@mui/material';

interface FinancialDashboardProps {
  customerId: string;
  token: string;
}

export const FinancialDashboard: React.FC<FinancialDashboardProps> = ({ customerId, token }) => {
  const [recommendations, setRecommendations] = useState<any>(null);
  const [healthScore, setHealthScore] = useState<any>(null);
  const [insights, setInsights] = useState<any>(null);

  useEffect(() => {
    fetchFinancialData();
  }, [customerId]);

  const fetchFinancialData = async () => {
    const API_BASE = 'http://localhost:8002';
    const headers = {
      'Authorization': `Bearer ${token}`,
      'Content-Type': 'application/json'
    };

    // Fetch customer data first
    const customerData = await fetchCustomerData(customerId);

    // Get recommendations
    const recsResponse = await fetch(`${API_BASE}/api/ai/recommendations/products`, {
      method: 'POST',
      headers,
      body: JSON.stringify(customerData)
    });
    setRecommendations(await recsResponse.json());

    // Get financial advice
    const adviceResponse = await fetch(`${API_BASE}/api/ai/recommendations/financial-advice`, {
      method: 'POST',
      headers,
      body: JSON.stringify(customerData)
    });
    const adviceData = await adviceResponse.json();
    setHealthScore(adviceData.financial_health_score);

    // Get spending insights
    const insightsResponse = await fetch(`${API_BASE}/api/ai/recommendations/spending-insights`, {
      method: 'POST',
      headers,
      body: JSON.stringify({
        customer_id: customerId,
        transaction_history: customerData.transaction_history
      })
    });
    setInsights(await insightsResponse.json());
  };

  return (
    <Box>
      <Grid container spacing={3}>
        <Grid item xs={12} md={4}>
          <Card>
            <CardContent>
              <Typography variant="h6">Financial Health</Typography>
              <Typography variant="h2">{healthScore?.grade}</Typography>
              <Typography>Score: {healthScore?.overall_score}/100</Typography>
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12} md={8}>
          <Card>
            <CardContent>
              <Typography variant="h6">Recommended Products</Typography>
              {recommendations?.recommendations.map((rec: any) => (
                <Box key={rec.product.id} my={2}>
                  <Typography variant="subtitle1">{rec.product.name}</Typography>
                  <Typography variant="body2">{rec.reason}</Typography>
                </Box>
              ))}
            </CardContent>
          </Card>
        </Grid>

        <Grid item xs={12}>
          <Card>
            <CardContent>
              <Typography variant="h6">Spending Analysis</Typography>
              <Typography>Total: ${insights?.total_spending}</Typography>
              {insights?.top_categories.map((cat: any) => (
                <Typography key={cat.category}>
                  {cat.category}: ${cat.amount} ({cat.percentage}%)
                </Typography>
              ))}
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </Box>
  );
};
```

## See Also

- [Fraud Detection Example](ai_fraud_detection.md)
- [Account Management Example](account_management.md)
- [API Reference](../API.md)

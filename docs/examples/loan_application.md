# Loan Application Example

Examples for applying for and managing loans.

## Apply for Loan

```bash
curl -X POST http://localhost:8002/api/loans/apply \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "loanType": "PERSONAL",
    "amount": 10000.00,
    "termMonths": 36,
    "purpose": "Home improvement",
    "employmentStatus": "FULL_TIME",
    "annualIncome": 75000.00
  }'
```

## See Also

- [API Reference](../API.md)

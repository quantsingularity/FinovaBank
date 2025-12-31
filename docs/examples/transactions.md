# Transactions Example

Examples for managing financial transactions.

## Transfer Money

### Example 1: Basic Transfer

```bash
curl -X POST http://localhost:8002/api/transactions \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "sourceAccountId": "acc-uuid-1",
    "destinationAccountId": "acc-uuid-2",
    "amount": 500.00,
    "currency": "USD",
    "type": "TRANSFER",
    "description": "Monthly savings"
  }'
```

## Transaction History

```python
def get_transactions(token, account_id=None, start_date=None):
    params = {}
    if account_id:
        params['accountId'] = account_id
    if start_date:
        params['startDate'] = start_date

    response = requests.get(
        'http://localhost:8002/api/transactions',
        params=params,
        headers={'Authorization': f'Bearer {token}'}
    )
    return response.json()
```

## See Also

- [Account Management](account_management.md)
- [API Reference](../API.md)

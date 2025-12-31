# Account Management Example

Examples for creating and managing bank accounts.

## Create Account

### Example 1: Create Checking Account

```bash
TOKEN="your_jwt_token"

curl -X POST http://localhost:8002/api/accounts \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "accountType": "CHECKING",
    "initialBalance": 1000.00,
    "currency": "USD",
    "accountName": "Primary Checking"
  }'
```

## List Accounts

```python
import requests

def list_accounts(token):
    response = requests.get(
        'http://localhost:8002/api/accounts',
        headers={'Authorization': f'Bearer {token}'}
    )
    return response.json()

accounts = list_accounts('your_token')
for account in accounts['content']:
    print(f"{account['accountNumber']}: ${account['balance']}")
```

## Check Balance

```javascript
async function checkBalance(accountId, token) {
  const response = await fetch(
    `http://localhost:8002/api/accounts/${accountId}/balance`,
    {
      headers: { Authorization: `Bearer ${token}` },
    },
  );
  return await response.json();
}
```

## See Also

- [Transactions Example](transactions.md)
- [API Reference](../API.md)

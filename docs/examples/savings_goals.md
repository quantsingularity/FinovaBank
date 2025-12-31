# Savings Goals Example

Examples for creating and tracking savings goals.

## Create Savings Goal

```javascript
const createSavingsGoal = async (goalData, token) => {
  const response = await fetch("http://localhost:8002/api/savings-goals", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${token}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: "Vacation Fund",
      targetAmount: 5000.0,
      targetDate: "2026-06-01",
      monthlyContribution: 200.0,
      linkedAccountId: "acc-uuid-1",
    }),
  });
  return await response.json();
};
```

## See Also

- [API Reference](../API.md)

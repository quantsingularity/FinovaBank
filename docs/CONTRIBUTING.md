# Contributing to FinovaBank

Thank you for your interest in contributing to FinovaBank! This guide will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation Guidelines](#documentation-guidelines)
- [Pull Request Process](#pull-request-process)

## Code of Conduct

All contributors must adhere to our Code of Conduct:

- **Be respectful** - Treat everyone with respect
- **Be collaborative** - Work together effectively
- **Be inclusive** - Welcome diverse perspectives
- **Be professional** - Maintain professional communication

## Getting Started

### Prerequisites

Before contributing, ensure you have:

- Java 17+ installed
- Maven 3.6+ installed
- Node.js 16+ installed
- Docker and Docker Compose
- Git configured with your GitHub account
- IDE (IntelliJ IDEA, VS Code recommended)

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/FinovaBank.git
cd FinovaBank

# Add upstream remote
git remote add upstream https://github.com/abrar2030/FinovaBank.git
```

### Setup Development Environment

```bash
# Install backend dependencies
cd backend
mvn clean install

# Install frontend dependencies
cd ../web-frontend
npm install

# Start development environment
cd ..
docker-compose up -d
```

## Development Workflow

### Branch Strategy

- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - New features
- `bugfix/*` - Bug fixes
- `hotfix/*` - Urgent production fixes

### Creating a Feature Branch

```bash
# Update your fork
git fetch upstream
git checkout develop
git merge upstream/develop

# Create feature branch
git checkout -b feature/your-feature-name

# Make your changes
# ...

# Commit with meaningful message
git add .
git commit -m "feat: add feature description"

# Push to your fork
git push origin feature/your-feature-name
```

### Commit Message Convention

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes
- `perf`: Performance improvements
- `ci`: CI/CD changes

**Examples:**

```
feat(auth): add two-factor authentication

Implement 2FA using TOTP for enhanced security.
Users can enable/disable 2FA in account settings.

Closes #123
```

```
fix(transactions): prevent race condition in transfers

Add pessimistic locking to prevent concurrent
modifications of account balances.

Fixes #456
```

## Coding Standards

### Java/Spring Boot

**Style Guide:**

- Follow [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- Use meaningful variable and method names
- Keep methods small and focused (< 50 lines)
- Write self-documenting code

**Code Organization:**

```
src/main/java/com/finova/<service>/
├── config/          # Configuration classes
├── controller/      # REST controllers
├── dto/             # Data Transfer Objects
├── model/           # Domain models / Entities
├── repository/      # Data access layer
├── service/         # Business logic
│   ├── Interface.java
│   └── InterfaceImpl.java
├── security/        # Security configurations
└── util/            # Utility classes
```

**Best Practices:**

```java
// Use constructor injection
@Service
public class AccountServiceImpl implements AccountService {
    private final AccountRepository accountRepository;

    public AccountServiceImpl(AccountRepository accountRepository) {
        this.accountRepository = accountRepository;
    }
}

// Use meaningful names
public Account findAccountByNumber(String accountNumber) {
    return accountRepository.findByAccountNumber(accountNumber)
        .orElseThrow(() -> new AccountNotFoundException(accountNumber));
}

// Handle exceptions properly
@ExceptionHandler(AccountNotFoundException.class)
public ResponseEntity<ErrorResponse> handleAccountNotFound(AccountNotFoundException ex) {
    ErrorResponse error = new ErrorResponse(
        HttpStatus.NOT_FOUND.value(),
        ex.getMessage()
    );
    return new ResponseEntity<>(error, HttpStatus.NOT_FOUND);
}
```

### TypeScript/React

**Style Guide:**

- Follow [Airbnb React/JSX Style Guide](https://airbnb.io/javascript/react/)
- Use functional components with hooks
- Keep components small and reusable
- Use TypeScript for type safety

**Component Structure:**

```typescript
// MyComponent.tsx
import React from 'react';
import { Box, Typography } from '@mui/material';

interface MyComponentProps {
  title: string;
  onAction: () => void;
}

export const MyComponent: React.FC<MyComponentProps> = ({ title, onAction }) => {
  const [state, setState] = React.useState<string>('');

  return (
    <Box>
      <Typography variant="h5">{title}</Typography>
      <button onClick={onAction}>Click Me</button>
    </Box>
  );
};
```

### Python (AI Service)

**Style Guide:**

- Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/)
- Use type hints
- Write docstrings for functions and classes

**Example:**

```python
def calculate_risk_score(transaction_data: Dict[str, Any]) -> float:
    """
    Calculate fraud risk score for a transaction.

    Args:
        transaction_data: Dictionary containing transaction details

    Returns:
        Risk score between 0.0 and 1.0

    Raises:
        ValueError: If transaction_data is invalid
    """
    if not transaction_data:
        raise ValueError("Transaction data cannot be empty")

    # Implementation...
    return risk_score
```

## Testing Guidelines

### Unit Tests

**Coverage Requirements:**

- Minimum 80% code coverage
- Test all business logic
- Test error cases

**Example (Java/JUnit):**

```java
@SpringBootTest
class AccountServiceTest {

    @Mock
    private AccountRepository accountRepository;

    @InjectMocks
    private AccountServiceImpl accountService;

    @Test
    void testCreateAccount_Success() {
        // Given
        AccountCreateRequest request = new AccountCreateRequest();
        request.setAccountType("CHECKING");

        Account expectedAccount = new Account();
        when(accountRepository.save(any())).thenReturn(expectedAccount);

        // When
        Account result = accountService.createAccount(request);

        // Then
        assertNotNull(result);
        verify(accountRepository).save(any());
    }

    @Test
    void testFindAccount_NotFound() {
        // Given
        when(accountRepository.findById(anyLong())).thenReturn(Optional.empty());

        // When & Then
        assertThrows(AccountNotFoundException.class,
            () -> accountService.findById(1L));
    }
}
```

**Example (React/Jest):**

```typescript
import { render, screen, fireEvent } from '@testing-library/react';
import { Dashboard } from './Dashboard';

describe('Dashboard Component', () => {
  it('renders account balance', () => {
    render(<Dashboard />);
    expect(screen.getByText(/Account Balance/i)).toBeInTheDocument();
  });

  it('handles transfer button click', () => {
    const mockTransfer = jest.fn();
    render(<Dashboard onTransfer={mockTransfer} />);

    fireEvent.click(screen.getByText(/Transfer Money/i));
    expect(mockTransfer).toHaveBeenCalled();
  });
});
```

### Integration Tests

Test inter-service communication and API endpoints:

```java
@SpringBootTest(webEnvironment = SpringBootTest.WebEnvironment.RANDOM_PORT)
@AutoConfigureMockMvc
class AccountControllerIntegrationTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    void testCreateAccount_Integration() throws Exception {
        String requestBody = "{\"accountType\":\"CHECKING\",\"initialBalance\":1000}";

        mockMvc.perform(post("/api/accounts")
                .contentType(MediaType.APPLICATION_JSON)
                .content(requestBody))
                .andExpect(status().isCreated())
                .andExpect(jsonPath("$.accountType").value("CHECKING"));
    }
}
```

### Running Tests

```bash
# Backend tests
cd backend
mvn test

# Frontend tests
cd web-frontend
npm test

# AI service tests
cd backend/ai-service
pytest

# All tests
./scripts/run_all_tests.sh
```

## Documentation Guidelines

### Code Documentation

**Java:**

```java
/**
 * Service for managing user accounts.
 *
 * <p>Provides operations for creating, updating, and querying accounts.
 * All operations are transactional and thread-safe.
 *
 * @author Your Name
 * @since 1.0
 */
@Service
public class AccountService {

    /**
     * Creates a new account for the user.
     *
     * @param request the account creation request
     * @return the created account
     * @throws InvalidAccountException if request is invalid
     */
    public Account createAccount(AccountCreateRequest request) {
        // Implementation
    }
}
```

**TypeScript:**

````typescript
/**
 * Dashboard component displaying user account summary
 *
 * @component
 * @example
 * ```tsx
 * <Dashboard userId="123" />
 * ```
 */
export const Dashboard: React.FC<DashboardProps> = ({ userId }) => {
  // Implementation
};
````

### API Documentation

Update OpenAPI/Swagger annotations:

```java
@RestController
@RequestMapping("/api/accounts")
@Tag(name = "Account Management", description = "APIs for managing user accounts")
public class AccountController {

    @PostMapping
    @Operation(summary = "Create new account", description = "Creates a new bank account")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Account created successfully"),
        @ApiResponse(responseCode = "400", description = "Invalid request")
    })
    public ResponseEntity<AccountResponse> createAccount(
            @Valid @RequestBody AccountCreateRequest request) {
        // Implementation
    }
}
```

### Documentation Updates

When adding features:

1. Update `docs/API.md` with new endpoints
2. Update `docs/FEATURE_MATRIX.md` with new features
3. Add examples to `docs/examples/`
4. Update relevant configuration docs

## Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] All tests pass
- [ ] Code coverage meets requirements (80%+)
- [ ] Documentation is updated
- [ ] Commit messages follow convention
- [ ] No merge conflicts with develop branch

### PR Title and Description

**Title Format:**

```
<type>: brief description
```

**Description Template:**

```markdown
## Description

Brief description of what this PR does.

## Type of Change

- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Changes Made

- Change 1
- Change 2

## Testing

- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing completed

## Screenshots (if applicable)

[Add screenshots for UI changes]

## Related Issues

Closes #123
Relates to #456

## Checklist

- [ ] Code follows project guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] No new warnings
- [ ] Tests added and passing
```

### Review Process

1. Submit PR targeting `develop` branch
2. Automated checks run (tests, linting, security)
3. Code review by maintainers
4. Address review comments
5. PR approved and merged

### After Merge

```bash
# Update your local repository
git checkout develop
git pull upstream develop

# Delete feature branch
git branch -d feature/your-feature-name
git push origin --delete feature/your-feature-name
```

## Updating Documentation

### When to Update

Update documentation when you:

- Add new features
- Change API endpoints
- Modify configuration options
- Fix bugs affecting usage
- Add new dependencies

### Documentation Files

| File                      | When to Update                  |
| ------------------------- | ------------------------------- |
| `docs/API.md`             | New/changed endpoints           |
| `docs/USAGE.md`           | New features, changed workflows |
| `docs/CONFIGURATION.md`   | New config options              |
| `docs/FEATURE_MATRIX.md`  | New features                    |
| `docs/EXAMPLES/`          | New use cases                   |
| `docs/TROUBLESHOOTING.md` | Common issues discovered        |

### Documentation Style

- Use clear, concise language
- Include code examples
- Add tables for configuration options
- Use proper Markdown formatting
- Include links to related docs

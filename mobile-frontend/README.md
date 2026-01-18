# FinovaBank Mobile Frontend

A comprehensive React Native mobile application for FinovaBank's digital banking platform, providing secure banking services on iOS and Android devices.

## Features

- **Authentication**: Secure login and registration with JWT token management
- **Account Management**: View account details, balance, and account information
- **Transactions**: Browse transaction history with filtering and search capabilities
- **Loans**: Apply for loans and manage existing loan accounts
- **Savings Goals**: Create and track progress towards savings goals
- **Secure Storage**: Local data persistence with AsyncStorage
- **Responsive Design**: Optimized for various screen sizes

## Prerequisites

- Node.js 16 or later
- npm or yarn
- React Native development environment set up
  - For iOS: Xcode 12 or later, CocoaPods
  - For Android: Android Studio, Android SDK (API 21+)
- Java JDK 11 or later (for Android)

## Installation

1. **Clone the repository** (if not already done):

   ```bash
   git clone https://github.com/quantsingularity/FinovaBank.git
   cd FinovaBank/mobile-frontend
   ```

2. **Install dependencies**:

   ```bash
   npm install
   # or
   yarn install
   ```

3. **Install iOS dependencies** (iOS only, macOS required):

   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Configure environment** (optional):
   ```bash
   cp .env.example .env
   # Edit .env to configure API endpoint if needed
   ```

## Running the Application

### Development Mode

Start the Metro bundler:

```bash
npm start
# or
yarn start
```

### Run on Android

Make sure you have an Android emulator running or a device connected, then:

```bash
npm run android
# or
yarn android
```

### Run on iOS

Make sure you have the iOS Simulator open or a device connected, then:

```bash
npm run ios
# or
yarn ios
```

## Backend Integration

The mobile frontend requires the FinovaBank backend to be running. By default, the app connects to:

- **Development**: `http://localhost:8080/api/v1`
- **Production**: `https://api.finovabank.com/api/v1`

### Starting the Backend Locally

1. Navigate to the backend directory:

   ```bash
   cd ../backend
   ```

2. Follow backend setup instructions in `../backend/README.md`

3. Start the backend server:

   ```bash
   ./mvnw spring-boot:run
   ```

4. Verify the backend is running by visiting:
   - `http://localhost:8080/actuator/health`

### Configuring API Endpoint

The API endpoint is configured in `src/services/config.ts`. It automatically switches between development and production based on the build mode.

For custom configuration:

- Development builds use `http://localhost:8080/api/v1`
- Production builds use the production API URL

## Testing

### Run All Tests

```bash
npm test
# or
yarn test
```

### Run Tests in Watch Mode

```bash
npm run test:watch
# or
yarn test:watch
```

### Generate Coverage Report

```bash
npm run test:coverage
# or
yarn test:coverage
```

Coverage reports are generated in the `coverage/` directory.

### Test Structure

- Unit tests: Located in `src/**/__tests__/` directories
- Test setup: `jest.setup.js`
- Test configuration: `jest.config.js`

## Project Structure

```
mobile-frontend/
├── __tests__/              # App-level tests
├── android/                # Android native code
├── ios/                    # iOS native code
├── src/
│   ├── context/           # React Context providers
│   │   └── AuthContext.tsx
│   ├── navigation/        # Navigation configuration
│   │   └── AppNavigator.tsx
│   ├── screens/           # Screen components
│   │   ├── __tests__/     # Screen tests
│   │   ├── LoginScreen.tsx
│   │   ├── RegisterScreen.tsx
│   │   ├── DashboardScreen.tsx
│   │   ├── AccountDetailsScreen.tsx
│   │   ├── TransactionsScreen.tsx
│   │   ├── TransactionDetailsScreen.tsx
│   │   ├── TransactionFiltersScreen.tsx
│   │   ├── LoansScreen.tsx
│   │   └── SavingsGoalsScreen.tsx
│   ├── services/          # API and services
│   │   ├── api.ts
│   │   └── config.ts
│   └── styles/            # Shared styles
│       └── commonStyles.ts
├── .env.example           # Environment variables template
├── App.tsx                # App root component
├── index.js               # Entry point
├── jest.config.js         # Jest configuration
├── jest.setup.js          # Test setup
├── package.json           # Dependencies and scripts
└── tsconfig.json          # TypeScript configuration
```

## Development

### Code Style

The project uses ESLint and Prettier for code quality and formatting:

```bash
# Lint code
npm run lint

# Format code
npm run format

# Check formatting
npm run format:check

# Type check
npm run type-check
```

### Adding New Features

1. Create new screen components in `src/screens/`
2. Add navigation routes in `src/navigation/AppNavigator.tsx`
3. Create API service functions in `src/services/api.ts`
4. Write tests in corresponding `__tests__/` directories
5. Update type definitions in navigation types

### Common Issues

#### Metro Bundler Cache Issues

```bash
# Clear cache and restart
npm start -- --reset-cache
```

#### iOS Build Issues

```bash
# Clean iOS build
cd ios
rm -rf build/
pod deintegrate
pod install
cd ..
```

#### Android Build Issues

```bash
# Clean Android build
cd android
./gradlew clean
cd ..
```

## Architecture

### State Management

- **Authentication**: Managed by `AuthContext` using React Context API
- **Local Storage**: AsyncStorage for persistent data
- **API Communication**: Axios with interceptors for token management

### Navigation

- React Navigation v7 with Native Stack Navigator
- Conditional navigation based on authentication state
- Type-safe navigation with TypeScript

### Security

- JWT token-based authentication
- Secure token storage with AsyncStorage
- Automatic token refresh and logout on expiration
- Network request encryption (HTTPS in production)

## API Endpoints

The mobile app integrates with the following backend endpoints:

### Authentication

- `POST /api/v1/auth/login` - User login
- `POST /api/v1/auth/register` - User registration
- `POST /api/v1/auth/logout` - User logout

### Accounts

- `GET /api/v1/accounts` - Get user accounts
- `GET /api/v1/accounts/:id` - Get account details

### Transactions

- `GET /api/v1/accounts/:id/transactions` - Get account transactions

### Loans

- `GET /api/v1/accounts/:id/loans` - Get account loans
- `POST /api/v1/loans` - Apply for a loan
- `GET /api/v1/loans/types` - Get available loan types

### Savings Goals

- `GET /api/v1/accounts/:id/savings` - Get savings goals
- `POST /api/v1/savings` - Create savings goal
- `POST /api/v1/savings/:id/contribute` - Contribute to goal

## Troubleshooting

### Cannot Connect to Backend

1. Ensure backend is running on `localhost:8080`
2. For Android emulator, use `10.0.2.2:8080` instead of `localhost:8080`
3. For iOS simulator, `localhost:8080` should work
4. For physical devices, use your computer's IP address

### Build Errors

1. Clear caches: `npm start -- --reset-cache`
2. Reinstall dependencies: `rm -rf node_modules && npm install`
3. For iOS: `cd ios && pod install && cd ..`
4. For Android: `cd android && ./gradlew clean && cd ..`

## Contributing

1. Create a feature branch
2. Write tests for new features
3. Ensure all tests pass: `npm test`
4. Format code: `npm run format`
5. Submit a pull request

## License

This project is part of the FinovaBank platform and is licensed under the MIT License.

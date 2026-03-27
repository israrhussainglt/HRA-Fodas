# Contributing to HRA-FoDAS

Thank you for your interest in contributing to HRA-FoDAS! This document provides guidelines and instructions for contributing.

## 🤝 How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/yourusername/hra-fodas/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots if applicable
   - Device/OS information
   - App version

### Suggesting Features

1. Check [Discussions](https://github.com/yourusername/hra-fodas/discussions) for similar suggestions
2. Create a new discussion with:
   - Clear description of the feature
   - Use case and benefits
   - Possible implementation approach

### Pull Requests

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/AmazingFeature
   ```

3. **Make your changes**
   - Follow the code style guidelines
   - Add tests if applicable
   - Update documentation

4. **Commit your changes**
   ```bash
   git commit -m 'Add some AmazingFeature'
   ```

5. **Push to your fork**
   ```bash
   git push origin feature/AmazingFeature
   ```

6. **Open a Pull Request**
   - Provide clear description
   - Reference related issues
   - Include screenshots for UI changes

## 📝 Code Style Guidelines

### Dart/Flutter

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use `flutter format` before committing
- Maximum line length: 80 characters (flexible for readability)
- Use meaningful variable and function names
- Add comments for complex logic

### File Organization

```
lib/
├── core/           # Core utilities, constants, theme
├── data/           # Models and repositories
├── providers/      # Riverpod providers
├── router/         # Navigation
├── services/       # External services (Firebase, etc.)
└── ui/             # Screens and widgets
```

### Naming Conventions

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Functions**: `camelCase`
- **Constants**: `SCREAMING_SNAKE_CASE`
- **Private members**: `_leadingUnderscore`

### Example

```dart
// Good
class DonationCard extends StatelessWidget {
  final Donation donation;
  final VoidCallback onTap;
  
  const DonationCard({
    super.key,
    required this.donation,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(donation.title),
        onTap: onTap,
      ),
    );
  }
}

// Bad
class donationcard extends StatelessWidget {
  Donation d;
  Function t;
  
  donationcard(this.d, this.t);
  
  Widget build(context) {
    return Card(child: ListTile(title: Text(d.title), onTap: t));
  }
}
```

## 🧪 Testing

- Write tests for new features
- Ensure existing tests pass
- Run tests before submitting PR

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
```

## 📚 Documentation

- Update README.md for major changes
- Add inline comments for complex logic
- Update SETUP_GUIDE.md if setup process changes
- Document new features in code comments

## 🔒 Security

- Never commit sensitive data (.env, API keys, etc.)
- Use environment variables for configuration
- Follow security best practices
- Report security vulnerabilities privately

## 🎯 Priority Areas

We especially welcome contributions in:

- 🐛 Bug fixes
- 📱 UI/UX improvements
- ♿ Accessibility enhancements
- 🌍 Internationalization (i18n)
- 📖 Documentation improvements
- ✅ Test coverage
- 🚀 Performance optimizations

## 💬 Communication

- **Issues**: For bugs and feature requests
- **Discussions**: For questions and ideas
- **Pull Requests**: For code contributions
- **Email**: For private matters

## 📜 Code of Conduct

- Be respectful and inclusive
- Welcome newcomers
- Focus on constructive feedback
- Help others learn and grow

## ✅ Checklist Before Submitting PR

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] No console errors or warnings
- [ ] Tested on Android/iOS (if applicable)
- [ ] Screenshots included (for UI changes)

## 🎉 Recognition

Contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Credited in the app (for major contributions)

## 📞 Questions?

Feel free to ask questions in:
- [GitHub Discussions](https://github.com/yourusername/hra-fodas/discussions)
- [Issues](https://github.com/yourusername/hra-fodas/issues)

Thank you for contributing to HRA-FoDAS! 🙏

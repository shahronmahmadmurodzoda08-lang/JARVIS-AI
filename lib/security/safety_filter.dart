/// Natijai tekshiruvi amniyat.
class SafetyDecision {
  const SafetyDecision.allowed() : allowed = true;
  const SafetyDecision.blocked() : allowed = false;

  final bool allowed;
}

/// Safety layer: pesh az har ijroi AI Agent seshavad.
abstract interface class SafetyFilter {
  SafetyDecision check(String text);
}

/// Filtri sodda bar asosi kalimaho. Baʼdan jagoh meshavad.
class KeywordSafetyFilter implements SafetyFilter {
  const KeywordSafetyFilter();

  static const List<String> _blocked = ['porn', 'xxx', 'порно', 'секс'];

  @override
  SafetyDecision check(String text) {
    final lower = text.toLowerCase();
    for (final word in _blocked) {
      if (lower.contains(word)) return const SafetyDecision.blocked();
    }
    return const SafetyDecision.allowed();
  }
}
